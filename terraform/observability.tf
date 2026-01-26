###################################################################################################################
################################################## OBSERVABILITY ###################################################
###################################################################################################################

#######################
#### Prometheus ECS Task Definition ####
#######################

locals {
  # Prometheus config será injetado via variável de ambiente ou imagem customizada
  prometheus_container_definition = [
    {
      name      = "prometheus"
      image     = var.prometheus_image
      essential = true
      portMappings = [
        {
          containerPort = 9090
          protocol      = "tcp"
        }
      ]
      # Comando será gerenciado pelo entrypoint do Dockerfile
      command = []
      environment = [
        {
          name  = "ALB_DNS_NAME"
          value = module.alb_backend.lb_dns_name
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/prometheus"
          "awslogs-region"        = "us-east-2"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ]

  prometheus_volumes = []

  grafana_container_definition = [
    {
      name      = "grafana"
      image     = var.grafana_image
      essential = true
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
          name  = "GF_USERS_ALLOW_SIGN_UP"
          value = "false"
        },
        {
          name  = "PROMETHEUS_URL"
          value = "http://prometheus-service:9090"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/grafana"
          "awslogs-region"        = "us-east-2"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ]

  grafana_volumes = []
}

# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "prometheus" {
  name              = "/ecs/prometheus"
  retention_in_days = 7
  tags = {
    Name        = "PROMETHEUS-LOGS"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

resource "aws_cloudwatch_log_group" "grafana" {
  name              = "/ecs/grafana"
  retention_in_days = 7
  tags = {
    Name        = "GRAFANA-LOGS"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

#######################
#### Prometheus Task Definition ####
#######################

module "prometheus_task_definition" {
  source                  = "./modulos/Aplicacao/prod/ecs/task-definition"
  family                  = "prometheus-task"
  network_mode            = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                     = "512"
  memory                  = "1024"
  execution_role_arn      = var.ecs_execution_role_arn
  task_role_arn           = var.ecs_task_role_arn
  container_definitions   = local.prometheus_container_definition
  volumes                 = local.prometheus_volumes
  tags = {
    Name        = "PROMETHEUS-TASK-DEFINITION"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

#######################
#### Prometheus Service ####
#######################

module "prometheus_service" {
  source                  = "./modulos/Aplicacao/prod/ecs/service"
  service_name            = "prometheus-service"
  cluster_id              = module.ecs_cluster.cluster_id
  task_definition_arn     = module.prometheus_task_definition.task_definition_arn
  desired_count           = 1
  launch_type             = "FARGATE"
  subnet_ids              = module.subnet_public.public_subnet_id
  security_group_ids      = [module.security_group_observability.security_group_id]
  assign_public_ip         = true
  load_balancer            = null
  deployment_maximum_percent         = 200
  deployment_minimum_percent         = 100
  health_check_grace_period_seconds  = 0
  enable_execute_command             = false
  tags = {
    Name        = "PROMETHEUS-SERVICE"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

#######################
#### Grafana Task Definition ####
#######################

module "grafana_task_definition" {
  source                  = "./modulos/Aplicacao/prod/ecs/task-definition"
  family                  = "grafana-task"
  network_mode            = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                     = "512"
  memory                  = "1024"
  execution_role_arn      = var.ecs_execution_role_arn
  task_role_arn           = var.ecs_task_role_arn
  container_definitions   = local.grafana_container_definition
  volumes                 = local.grafana_volumes
  tags = {
    Name        = "GRAFANA-TASK-DEFINITION"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

#######################
#### Grafana Service ####
#######################

module "grafana_service" {
  source                  = "./modulos/Aplicacao/prod/ecs/service"
  service_name            = "grafana-service"
  cluster_id              = module.ecs_cluster.cluster_id
  task_definition_arn     = module.grafana_task_definition.task_definition_arn
  desired_count           = 1
  launch_type             = "FARGATE"
  subnet_ids              = module.subnet_public.public_subnet_id
  security_group_ids      = [module.security_group_observability.security_group_id]
  assign_public_ip         = true
  load_balancer            = null
  deployment_maximum_percent         = 200
  deployment_minimum_percent         = 100
  health_check_grace_period_seconds  = 0
  enable_execute_command             = false
  tags = {
    Name        = "GRAFANA-SERVICE"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

