#######################################################################################################################
# ECS #################################################################################################################
# ---------------------------------------------------------------------------------------------------------------------

#######################
#### ECS Cluster ####
#######################

ecs_cluster_name            = "rodrigo-ecs-cluster"
ecs_container_insights_enabled = false

tags_ecs_cluster = {
  Name        = "RODRIGO-ECS-CLUSTER"
  Owner       = "Rodrigo Gomes"
  Project     = "Desafios EZOps"
  Environment = "Test"
  ManagedBy   = "Terraform"
}

#######################
#### ECS Task Definition ####
#######################

ecs_task_family                 = "rodrigo-backend-task"
ecs_task_network_mode           = "awsvpc"
ecs_task_requires_compatibilities = ["FARGATE"]
ecs_task_cpu                    = "256"
ecs_task_memory                 = "512"
ecs_execution_role_arn          = "arn:aws:iam::618889059366:role/ecsTaskExecutionRole"  # Ajuste com sua role
ecs_task_role_arn               = null  # Deixe null se não precisar de permissões específicas para a task

# Container Definitions
ecs_container_definitions = [
  {
    name      = "backend"
    image     = "618889059366.dkr.ecr.us-east-2.amazonaws.com/backend-app-organizer:latest"  # IMPORTANTE: Adicione a tag :latest ou uma tag específica
    essential = true
    portMappings = [
      {
        containerPort = 3000
        protocol      = "tcp"
      }
    ]
    environment = [
      {
        name  = "DATABASE_URL"
        value = "PLACEHOLDER_WILL_BE_REPLACED_BY_RDS_OUTPUT"  # Será substituído dinamicamente pelo output do módulo RDS
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/rodrigo-backend"
        "awslogs-region"        = "us-east-2"
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }
]

ecs_volumes = []

tags_ecs_task_definition = {
  Name        = "RODRIGO-ECS-TASK-DEFINITION"
  Owner       = "Rodrigo Gomes"
  Project     = "Desafios EZOps"
  Environment = "Test"
  ManagedBy   = "Terraform"
}

#######################
#### ECS Service ####
#######################

ecs_service_name                 = "rodrigo-backend-service"
ecs_service_desired_count        = 1
ecs_service_launch_type          = "FARGATE"
ecs_service_assign_public_ip     = true
ecs_container_name               = "backend"
ecs_container_port               = 3000
ecs_deployment_maximum_percent    = 200
ecs_deployment_minimum_percent    = 100
ecs_health_check_grace_period_seconds = 60
ecs_enable_execute_command        = false

tags_ecs_service = {
  Name        = "RODRIGO-ECS-SERVICE"
  Owner       = "Rodrigo Gomes"
  Project     = "Desafios EZOps"
  Environment = "Test"
  ManagedBy   = "Terraform"
}

#######################################################################################################################
# ALB #################################################################################################################
# ---------------------------------------------------------------------------------------------------------------------

alb_name                      = "rodrigo-alb-backend"
alb_internal                  = false
alb_enable_deletion_protection = false
alb_access_logs_bucket        = ""
alb_access_logs_prefix        = ""
alb_access_logs_enabled       = false

tags_alb = {
  Name        = "RODRIGO-ALB-BACKEND"
  Owner       = "Rodrigo Gomes"
  Project     = "Desafios EZOps"
  Environment = "Test"
  ManagedBy   = "Terraform"
}

#######################
#### Target Group ####
#######################

target_group_name              = "rodrigo-tg-backend"
target_group_port              = 3000
target_group_protocol          = "HTTP"
target_group_protocol_version  = "HTTP1"
health_check_protocol          = "HTTP"
health_check_path              = "/health"  # Ajuste conforme sua aplicação
health_check_port              = "traffic-port"
healthy_threshold              = 2
unhealthy_threshold            = 3
health_check_timeout            = 5
health_check_interval           = 30
health_check_matcher            = "200"

tags_target_group = {
  Name        = "RODRIGO-TARGET-GROUP-BACKEND"
  Owner       = "Rodrigo Gomes"
  Project     = "Desafios EZOps"
  Environment = "Test"
  ManagedBy   = "Terraform"
}

#######################
#### ALB Listener ####
#######################

alb_listener_port          = 80
alb_listener_protocol      = "HTTP"
alb_listener_ssl_policy     = ""
alb_listener_certificate_arn = ""

tags_alb_listener = {
  Name        = "RODRIGO-ALB-LISTENER"
  Owner       = "Rodrigo Gomes"
  Project     = "Desafios EZOps"
  Environment = "Test"
  ManagedBy   = "Terraform"
}


