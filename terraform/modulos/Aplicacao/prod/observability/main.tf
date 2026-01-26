locals {
  name_prefix = "${var.project_name}-monitoring"
}

# Security group for the monitoring tasks
module "security_group_monitoring" {
  source      = "../../../Conectividade/prod/security-group"
  name        = "${local.name_prefix}-sg"
  description = "Security Group for Prometheus and Grafana"
  vpc_id      = var.vpc_id
  ingress_rules = [
    {
      description     = "ALB to Grafana"
      from_port       = 3000
      to_port         = 3000
      protocol        = "tcp"
      security_groups = [var.alb_security_group_id]
    }
  ]
  egress_rules = [
    {
      description = "Egress full (Prometheus needs to talk with ALB/backend/etc)"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = var.tags
}

# CloudWatch Logs group
resource "aws_cloudwatch_log_group" "monitoring" {
  name              = "/ecs/${local.name_prefix}"
  retention_in_days = 7

  tags = var.tags
}

# Target group para Grafana
module "target_group_grafana" {
  source                      = "../../balancer/target_group"
  tg_name                     = "${substr(local.name_prefix, 0, 26)}-tg"
  target_type                 = "ip"
  target_group_port           = 3000
  target_group_protocol       = "HTTP"
  target_group_protocol_version = "HTTP1"
  vpc_id                      = var.vpc_id
  health_check_protocol       = "HTTP"
  health_check_path           = "/login"
  health_check_port           = "traffic-port"
  healthy_threshold           = 2
  unhealthy_threshold         = 3
  health_check_timeout        = 5
  health_check_interval       = 30
  health_check_matcher        = "200-399"
  tags                        = var.tags
}

# Regra do ALB para /grafana/*
module "alb_listener_rule_grafana" {
  source            = "../../balancer/lb_listener_rule"
  listener_arn      = var.alb_listener_arn
  priority          = 50
  target_group_arn  = module.target_group_grafana.target_group_arn
  path_values       = ["/grafana/*", "/grafana"]
  host_header_values = []
}

# Task definition com Prometheus + Grafana
module "ecs_task_definition_monitoring" {
  source                  = "../../ecs/task-definition"
  family                  = "${local.name_prefix}-task"
  network_mode            = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                     = "512"
  memory                  = "1024"
  execution_role_arn      = var.execution_role_arn
  task_role_arn           = var.task_role_arn
  container_definitions   = [
    {
      name      = "prometheus"
      image     = var.prometheus_image
      essential = true
      cpu       = 128
      memory    = 256
      portMappings = [
        {
          containerPort = 9090
          protocol      = "tcp"
        }
      ]
      entryPoint = ["/bin/sh", "-c"]
      command = [
        <<-EOT
          # Criar arquivo de configuração do Prometheus dinamicamente
          cat > /etc/prometheus/prometheus.yml <<EOF
          global:
            scrape_interval: 15s
          
          scrape_configs:
            - job_name: "backend-aws"
              metrics_path: /metrics
              static_configs:
                - targets: ["${var.alb_dns_name}:80"]
          EOF
          
          # Iniciar Prometheus
          exec /bin/prometheus \
            --config.file=/etc/prometheus/prometheus.yml \
            --storage.tsdb.path=/prometheus \
            --storage.tsdb.retention.time=15d \
            --web.console.libraries=/usr/share/prometheus/console_libraries \
            --web.console.templates=/usr/share/prometheus/consoles \
            --web.enable-lifecycle
        EOT
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.monitoring.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "prometheus"
        }
      }
    },
    {
      name      = "grafana"
      image     = var.grafana_image
      essential = true
      cpu       = 256
      memory    = 512
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "GF_SECURITY_ADMIN_USER"
          value = "admin"
        },
        {
          name  = "GF_SECURITY_ADMIN_PASSWORD"
          value = var.grafana_admin_password
        },
        {
          name  = "GF_SERVER_ROOT_URL"
          value = "http://${var.alb_dns_name}/grafana/"
        },
        {
          name  = "GF_SERVER_SERVE_FROM_SUB_PATH"
          value = "true"
        },
        {
          name  = "GF_SERVER_DOMAIN"
          value = var.alb_dns_name
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.monitoring.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "grafana"
        }
      }
    }
  ]
  volumes = []
  tags    = var.tags
}

data "aws_region" "current" {}

# ECS Service
module "ecs_service_monitoring" {
  source                  = "../../ecs/service"
  service_name            = "${local.name_prefix}-svc"
  cluster_id              = var.ecs_cluster_id
  task_definition_arn     = module.ecs_task_definition_monitoring.task_definition_arn
  desired_count           = 1
  launch_type             = "FARGATE"
  subnet_ids              = var.private_subnets
  security_group_ids      = [module.security_group_monitoring.security_group_id]
  assign_public_ip         = false
  load_balancer = {
    target_group_arn = module.target_group_grafana.target_group_arn
    container_name   = "grafana"
    container_port   = 3000
  }
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  health_check_grace_period_seconds  = 60
  enable_execute_command             = false
  tags                                = var.tags

  depends_on = [
    module.alb_listener_rule_grafana
  ]
}

