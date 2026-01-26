###################################################################################################################
################################################## Observabilidade (Prometheus + Grafana) #########################
###################################################################################################################

#######################
#### CloudWatch Log Groups ####
#######################

resource "aws_cloudwatch_log_group" "prometheus" {
  name              = "/ecs/prometheus"
  retention_in_days = 7

  tags = {
    Name        = "PROMETHEUS-LOGS"
    Owner       = "Rodrigo Gomes"
    Project     = "Desafios EZOps"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

resource "aws_cloudwatch_log_group" "grafana" {
  name              = "/ecs/grafana"
  retention_in_days = 7

  tags = {
    Name        = "GRAFANA-LOGS"
    Owner       = "Rodrigo Gomes"
    Project     = "Desafios EZOps"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

#######################
#### Security Group para Prometheus/Grafana ####
#######################

module "security_group_observability" {
  source      = "./modulos/Conectividade/prod/security-group"
  name        = "RODRIGO-SG-OBSERVABILITY"
  description = "Security Group para Prometheus e Grafana"
  vpc_id      = module.vpc_app.vpc_id
  ingress_rules = [
    {
      description     = "Prometheus UI"
      from_port       = 9090
      to_port         = 9090
      protocol        = "tcp"
      security_groups = [module.security_group_alb.security_group_id]
    },
    {
      description     = "Grafana UI"
      from_port       = 3000
      to_port         = 3000
      protocol        = "tcp"
      security_groups = [module.security_group_alb.security_group_id]
    },
    {
      description     = "Backend access for metrics"
      from_port       = 9090
      to_port         = 9090
      protocol        = "tcp"
      security_groups = [module.security_group_ecs.security_group_id]
    }
  ]
  egress_rules = [
    {
      description = "Outbound to internet"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = {
    Name        = "RODRIGO-SG-OBSERVABILITY"
    Owner       = "Rodrigo Gomes"
    Project     = "Desafios EZOps"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

#######################
#### Security Group para EFS ####
#######################

module "security_group_efs" {
  source      = "./modulos/Conectividade/prod/security-group"
  name        = "RODRIGO-SG-EFS"
  description = "Security Group para EFS"
  vpc_id      = module.vpc_app.vpc_id
  ingress_rules = [
    {
      description     = "NFS from observability services"
      from_port       = 2049
      to_port         = 2049
      protocol        = "tcp"
      security_groups = [module.security_group_observability.security_group_id]
    }
  ]
  egress_rules = [
    {
      description = "Allow all outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = {
    Name        = "RODRIGO-SG-EFS"
    Owner       = "Rodrigo Gomes"
    Project     = "Desafios EZOps"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

#######################
#### EFS para persistência do Prometheus ####
#######################

resource "aws_efs_file_system" "prometheus_data" {
  creation_token   = "prometheus-data"
  encrypted        = true
  performance_mode = "generalPurpose"

  tags = {
    Name        = "prometheus-data"
    Owner       = "Rodrigo Gomes"
    Project     = "Desafios EZOps"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

# Access Point para o Prometheus (facilita o acesso)
resource "aws_efs_access_point" "prometheus_data" {
  file_system_id = aws_efs_file_system.prometheus_data.id

  # Usar root para evitar problemas de permissão
  posix_user {
    gid = 0
    uid = 0
  }

  root_directory {
    path = "/prometheus"
    creation_info {
      owner_gid   = 0
      owner_uid   = 0
      permissions = "777"  # Permissões completas
    }
  }

  tags = {
    Name = "prometheus-access-point"
  }
}

resource "aws_efs_mount_target" "prometheus_data" {
  count           = length(module.subnet_private.private_subnet_id)
  file_system_id  = aws_efs_file_system.prometheus_data.id
  subnet_id       = module.subnet_private.private_subnet_id[count.index]
  security_groups = [module.security_group_efs.security_group_id]
}

#######################
#### EFS para persistência do Grafana ####
#######################

resource "aws_efs_file_system" "grafana_data" {
  creation_token   = "grafana-data"
  encrypted        = true
  performance_mode = "generalPurpose"

  tags = {
    Name        = "grafana-data"
    Owner       = "Rodrigo Gomes"
    Project     = "Desafios EZOps"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

# Access Point para o Grafana (facilita o acesso)
resource "aws_efs_access_point" "grafana_data" {
  file_system_id = aws_efs_file_system.grafana_data.id

  posix_user {
    gid = 472  # GID padrão do Grafana
    uid = 472  # UID padrão do Grafana
  }

  root_directory {
    path = "/grafana"
    creation_info {
      owner_gid   = 472
      owner_uid   = 472
      permissions = "777"
    }
  }

  tags = {
    Name = "grafana-access-point"
  }
}

resource "aws_efs_mount_target" "grafana_data" {
  count           = length(module.subnet_private.private_subnet_id)
  file_system_id  = aws_efs_file_system.grafana_data.id
  subnet_id       = module.subnet_private.private_subnet_id[count.index]
  security_groups = [module.security_group_efs.security_group_id]
}

# Local para endpoint do backend
locals {
  backend_endpoint = module.alb_backend.lb_dns_name
}

#######################
#### Task Definition - Prometheus ####
#######################

module "ecs_task_definition_prometheus" {
  source                  = "./modulos/Aplicacao/prod/ecs/task-definition"
  family                  = "prometheus-task"
  network_mode            = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                     = "512"
  memory                  = "1024"
  execution_role_arn      = var.ecs_execution_role_arn
  task_role_arn           = var.ecs_execution_role_arn
  container_definitions   = [
    {
      name      = "prometheus"
      image     = "prom/prometheus:latest"
      essential = true
      portMappings = [
        {
          containerPort = 9090
          protocol      = "tcp"
        }
      ]
      entryPoint = ["/bin/sh", "-c"]
      command = [
        <<-EOT
          # Aguardar EFS estar montado (máximo 30 segundos)
          echo "Waiting for EFS mount..."
          for i in $(seq 1 30); do
            if mountpoint -q /prometheus 2>/dev/null || [ -d /prometheus ]; then
              echo "EFS mount confirmed"
              break
            fi
            sleep 1
          done
          
          # Criar arquivo de configuração (formato simplificado)
          cat > /etc/prometheus/prometheus.yml <<EOF
          global:
            scrape_interval: 15s
          
          scrape_configs:
            - job_name: "backend-aws"
              metrics_path: /metrics
              static_configs:
                - targets: ["${local.backend_endpoint}:80"]
          EOF
          
          # Garantir que o diretório do Prometheus existe
          mkdir -p /prometheus
          
          # Garantir permissões de escrita no diretório
          chmod 777 /prometheus 2>/dev/null || true
          
          # Remover lock file se existir e for antigo (mais de 5 minutos)
          # Isso evita problemas quando uma instância anterior não limpou o lock
          LOCK_FILE="/prometheus/lock"
          if [ -f "$LOCK_FILE" ]; then
            LOCK_AGE=$(find "$LOCK_FILE" -mmin +5 2>/dev/null)
            if [ -n "$LOCK_AGE" ]; then
              echo "Removing stale lock file (older than 5 minutes)"
              rm -f "$LOCK_FILE" 2>/dev/null || true
            else
              echo "Lock file exists but is recent, waiting 10 seconds..."
              sleep 10
              # Tentar remover novamente (pode ter sido liberado)
              if [ -f "$LOCK_FILE" ]; then
                echo "Removing lock file after wait"
                rm -f "$LOCK_FILE" 2>/dev/null || true
              fi
            fi
          fi
          
          # Criar arquivo de query log vazio com permissões corretas
          touch /prometheus/queries.active 2>/dev/null || true
          chmod 777 /prometheus/queries.active 2>/dev/null || true
          
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
      mountPoints = [
        {
          sourceVolume  = "prometheus-data"
          containerPath = "/prometheus"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.prometheus.name
          "awslogs-region"        = "us-east-2"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ]
  volumes = [
    {
      name = "prometheus-data"
      efs_volume_configuration = {
        file_system_id     = aws_efs_file_system.prometheus_data.id
        root_directory     = "/"
        transit_encryption  = "ENABLED"
        authorization_config = {
          access_point_id = aws_efs_access_point.prometheus_data.id
          iam             = "DISABLED"
        }
      }
    }
  ]
  tags = {
    Name        = "PROMETHEUS-TASK-DEFINITION"
    Owner       = "Rodrigo Gomes"
    Project     = "Desafios EZOps"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

#######################
#### Service - Prometheus ####
#######################
# Será criado depois com ALB

#######################
#### Task Definition - Grafana ####
#######################

module "ecs_task_definition_grafana" {
  source                  = "./modulos/Aplicacao/prod/ecs/task-definition"
  family                  = "grafana-task"
  network_mode            = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                     = "512"
  memory                  = "1024"
  execution_role_arn      = var.ecs_execution_role_arn
  task_role_arn           = var.ecs_execution_role_arn
  container_definitions   = [
    {
      name      = "grafana"
      image     = "grafana/grafana:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
      entryPoint = ["/bin/sh", "-c"]
      command = [
        <<-EOT
          # Aguardar EFS estar montado (máximo 30 segundos)
          echo "Waiting for EFS mount..."
          for i in $(seq 1 30); do
            if mountpoint -q /var/lib/grafana 2>/dev/null || [ -d /var/lib/grafana ]; then
              echo "EFS mount confirmed"
              break
            fi
            sleep 1
          done
          
          # Garantir que o diretório do Grafana existe e tem permissões corretas
          mkdir -p /var/lib/grafana
          # Tentar ajustar ownership, se falhar usar permissões amplas
          chown -R grafana:grafana /var/lib/grafana 2>/dev/null || chmod -R 777 /var/lib/grafana 2>/dev/null || true
          
          # Criar subdiretórios necessários se não existirem
          mkdir -p /var/lib/grafana/{dashboards,plugins,provisioning/{datasources,dashboards},alerting,log}
          chown -R grafana:grafana /var/lib/grafana 2>/dev/null || chmod -R 777 /var/lib/grafana 2>/dev/null || true
          
          # Criar arquivo de datasource do Prometheus
          cat > /var/lib/grafana/provisioning/datasources/prometheus-datasource.yml <<'EOF'
          apiVersion: 1
          
          datasources:
            - name: Prometheus
              type: prometheus
              access: proxy
              orgId: 1
              url: http://prometheus-service:9090
              isDefault: true
              editable: true
              jsonData:
                httpMethod: POST
          EOF
          
          # Criar arquivo de configuração de dashboards
          cat > /var/lib/grafana/provisioning/dashboards/dashboards.yml <<'EOF'
          apiVersion: 1
          
          providers:
            - name: "default-dashboards"
              orgId: 1
              folder: ""
              type: file
              disableDeletion: false
              updateIntervalSeconds: 30
              allowUiUpdates: true
              editable: true
              options:
                path: /var/lib/grafana/dashboards
          EOF
          
          # Ajustar permissões dos arquivos de provisioning
          chown -R grafana:grafana /var/lib/grafana/provisioning 2>/dev/null || chmod -R 777 /var/lib/grafana/provisioning 2>/dev/null || true
          
          # Iniciar Grafana usando o entrypoint padrão
          exec /run.sh
        EOT
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
          name  = "GF_SERVER_ROOT_URL"
          value = "http://localhost:3000"
        },
        {
          name  = "GF_INSTALL_PLUGINS"
          value = ""
        },
        {
          name  = "GF_PATHS_DATA"
          value = "/var/lib/grafana"
        },
        {
          name  = "GF_PATHS_LOGS"
          value = "/var/lib/grafana/log"
        },
        {
          name  = "GF_PATHS_PLUGINS"
          value = "/var/lib/grafana/plugins"
        },
        {
          name  = "GF_PATHS_PROVISIONING"
          value = "/var/lib/grafana/provisioning"
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "grafana-data"
          containerPath = "/var/lib/grafana"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.grafana.name
          "awslogs-region"        = "us-east-2"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ]
  volumes = [
    {
      name = "grafana-data"
      efs_volume_configuration = {
        file_system_id     = aws_efs_file_system.grafana_data.id
        root_directory     = "/"
        transit_encryption  = "ENABLED"
        authorization_config = {
          access_point_id = aws_efs_access_point.grafana_data.id
          iam             = "DISABLED"
        }
      }
    }
  ]
  tags = {
    Name        = "GRAFANA-TASK-DEFINITION"
    Owner       = "Rodrigo Gomes"
    Project     = "Desafios EZOps"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

#######################
#### Service - Grafana ####
#######################
# Será criado depois com ALB

#######################
#### ALB Interno para Observabilidade (Opcional) ####
#######################

# ALB interno para acessar Prometheus e Grafana
module "alb_observability" {
  source                  = "./modulos/Aplicacao/prod/balancer/alb"
  lb_name                 = "rodrigo-alb-observability"
  internal                = true  # ALB interno
  type                    = "application"
  security_group_ids      = [module.security_group_observability.security_group_id]
  subnet_ids              = module.subnet_private.private_subnet_id
  enable_deletion_protection = false
  access_logs_bucket      = ""
  access_logs_prefix      = ""
  access_logs_enabled     = false
  tags = {
    Name        = "RODRIGO-ALB-OBSERVABILITY"
    Owner       = "Rodrigo Gomes"
    Project     = "Desafios EZOps"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

# Target Group para Prometheus
module "target_group_prometheus" {
  source                      = "./modulos/Aplicacao/prod/balancer/target_group"
  tg_name                     = "rodrigo-tg-prometheus"
  target_type                 = "ip"
  target_group_port           = 9090
  target_group_protocol       = "HTTP"
  target_group_protocol_version = "HTTP1"
  vpc_id                      = module.vpc_app.vpc_id
  health_check_protocol       = "HTTP"
  health_check_path           = "/-/healthy"
  health_check_port           = "traffic-port"
  healthy_threshold           = 2
  unhealthy_threshold         = 3
  health_check_timeout        = 5
  health_check_interval       = 30
  health_check_matcher         = "200"
  tags = {
    Name        = "RODRIGO-TARGET-GROUP-PROMETHEUS"
    Owner       = "Rodrigo Gomes"
    Project     = "Desafios EZOps"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

# Target Group para Grafana
module "target_group_grafana" {
  source                      = "./modulos/Aplicacao/prod/balancer/target_group"
  tg_name                     = "rodrigo-tg-grafana"
  target_type                 = "ip"
  target_group_port           = 3000
  target_group_protocol       = "HTTP"
  target_group_protocol_version = "HTTP1"
  vpc_id                      = module.vpc_app.vpc_id
  health_check_protocol       = "HTTP"
  health_check_path           = "/api/health"
  health_check_port           = "traffic-port"
  healthy_threshold           = 2
  unhealthy_threshold         = 3
  health_check_timeout        = 5
  health_check_interval       = 30
  health_check_matcher         = "200"
  tags = {
    Name        = "RODRIGO-TARGET-GROUP-GRAFANA"
    Owner       = "Rodrigo Gomes"
    Project     = "Desafios EZOps"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

# Listener HTTP para Prometheus (porta 9090)
module "alb_listener_prometheus" {
  source            = "./modulos/Aplicacao/prod/balancer/lb_listener"
  lb_arn            = module.alb_observability.lb_arn
  port              = 9090
  protocol          = "HTTP"
  ssl_policy        = ""
  certificate_arn   = ""
  target_group_arn   = module.target_group_prometheus.target_group_arn
  tags = {
    Name        = "RODRIGO-ALB-LISTENER-PROMETHEUS"
    Owner       = "Rodrigo Gomes"
    Project     = "Desafios EZOps"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

# Listener HTTP para Grafana (porta 3000)
module "alb_listener_grafana" {
  source            = "./modulos/Aplicacao/prod/balancer/lb_listener"
  lb_arn            = module.alb_observability.lb_arn
  port              = 3000
  protocol          = "HTTP"
  ssl_policy        = ""
  certificate_arn   = ""
  target_group_arn   = module.target_group_grafana.target_group_arn
  tags = {
    Name        = "RODRIGO-ALB-LISTENER-GRAFANA"
    Owner       = "Rodrigo Gomes"
    Project     = "Desafios EZOps"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

#######################
#### Services com ALB ####
#######################

resource "aws_ecs_service" "prometheus" {
  name            = "prometheus-service"
  cluster         = module.ecs_cluster.cluster_id
  task_definition = module.ecs_task_definition_prometheus.task_definition_arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.subnet_private.private_subnet_id
    security_groups  = [module.security_group_observability.security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = module.target_group_prometheus.target_group_arn
    container_name   = "prometheus"
    container_port   = 9090
  }

  # Permitir apenas 1 instância por vez para evitar conflitos de lock no EFS
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  tags = {
    Name        = "PROMETHEUS-SERVICE"
    Owner       = "Rodrigo Gomes"
    Project     = "Desafios EZOps"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

resource "aws_ecs_service" "grafana" {
  name            = "grafana-service"
  cluster         = module.ecs_cluster.cluster_id
  task_definition = module.ecs_task_definition_grafana.task_definition_arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.subnet_private.private_subnet_id
    security_groups  = [module.security_group_observability.security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = module.target_group_grafana.target_group_arn
    container_name   = "grafana"
    container_port   = 3000
  }

  # Permitir apenas 1 instância por vez para evitar conflitos no EFS
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  tags = {
    Name        = "GRAFANA-SERVICE"
    Owner       = "Rodrigo Gomes"
    Project     = "Desafios EZOps"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}
