###################################################################################################################
################################################## ECS ############################################################
###################################################################################################################

#######################
#### ECS Cluster ####
#######################

module "ecs_cluster" {
  source                  = "./modulos/Aplicacao/prod/ecs/cluster"
  cluster_name            = var.ecs_cluster_name
  container_insights_enabled = var.ecs_container_insights_enabled
  tags                    = var.tags_ecs_cluster
}

#######################
#### ALB ####
#######################

module "alb_backend" {
  source                  = "./modulos/Aplicacao/prod/balancer/alb"
  lb_name                 = var.alb_name
  internal                = var.alb_internal
  type                    = "application"
  security_group_ids      = [module.security_group_alb.security_group_id]
  subnet_ids              = module.subnet_public.public_subnet_id
  enable_deletion_protection = var.alb_enable_deletion_protection
  access_logs_bucket      = var.alb_access_logs_bucket
  access_logs_prefix      = var.alb_access_logs_prefix
  access_logs_enabled     = var.alb_access_logs_enabled
  tags                    = var.tags_alb
}

#######################
#### Target Group ####
#######################

module "target_group_backend" {
  source                      = "./modulos/Aplicacao/prod/balancer/target_group"
  tg_name                     = var.target_group_name
  target_type                 = "ip"
  target_group_port           = var.target_group_port
  target_group_protocol       = var.target_group_protocol
  target_group_protocol_version = var.target_group_protocol_version
  vpc_id                      = module.vpc_app.vpc_id
  health_check_protocol       = var.health_check_protocol
  health_check_path           = var.health_check_path
  health_check_port           = var.health_check_port
  healthy_threshold           = var.healthy_threshold
  unhealthy_threshold         = var.unhealthy_threshold
  health_check_timeout        = var.health_check_timeout
  health_check_interval       = var.health_check_interval
  health_check_matcher        = var.health_check_matcher
  tags                        = var.tags_target_group
}

#######################
#### ALB Listener ####
#######################

module "alb_listener" {
  source            = "./modulos/Aplicacao/prod/balancer/lb_listener"
  lb_arn            = module.alb_backend.lb_arn
  port              = var.alb_listener_port
  protocol          = var.alb_listener_protocol
  ssl_policy        = var.alb_listener_ssl_policy
  certificate_arn   = var.alb_listener_certificate_arn
  target_group_arn   = module.target_group_backend.target_group_arn
  tags              = var.tags_alb_listener
}

#######################
#### ECS Task Definition ####
#######################

# Construir container definitions dinamicamente, substituindo DATABASE_URL pelo output do RDS
locals {
  # Substituir o DATABASE_URL pelo output do RDS em cada container definition
  container_definitions_with_db = [
    for container in var.ecs_container_definitions : merge(
      container,
      {
        environment = [
          for env in container.environment : env.name == "DATABASE_URL" ? {
            name  = env.name
            value = module.rds_postgre.rds_postgres_connection_string
          } : env
        ]
      }
    )
  ]
}

module "ecs_task_definition" {
  source                  = "./modulos/Aplicacao/prod/ecs/task-definition"
  family                  = var.ecs_task_family
  network_mode            = var.ecs_task_network_mode
  requires_compatibilities = var.ecs_task_requires_compatibilities
  cpu                     = var.ecs_task_cpu
  memory                  = var.ecs_task_memory
  execution_role_arn      = var.ecs_execution_role_arn
  task_role_arn           = var.ecs_task_role_arn
  container_definitions   = local.container_definitions_with_db
  volumes                 = var.ecs_volumes
  tags                    = var.tags_ecs_task_definition
}

#######################
#### ECS Service ####
#######################

module "ecs_service" {
  source                  = "./modulos/Aplicacao/prod/ecs/service"
  service_name            = var.ecs_service_name
  cluster_id              = module.ecs_cluster.cluster_id
  task_definition_arn     = module.ecs_task_definition.task_definition_arn
  desired_count           = var.ecs_service_desired_count
  launch_type             = var.ecs_service_launch_type
  subnet_ids              = module.subnet_public.public_subnet_id
  security_group_ids      = [module.security_group_ecs.security_group_id]
  assign_public_ip         = var.ecs_service_assign_public_ip
  load_balancer = {
    target_group_arn = module.target_group_backend.target_group_arn
    container_name   = var.ecs_container_name
    container_port   = var.ecs_container_port
  }
  deployment_maximum_percent         = var.ecs_deployment_maximum_percent
  deployment_minimum_percent         = var.ecs_deployment_minimum_percent
  health_check_grace_period_seconds  = var.ecs_health_check_grace_period_seconds
  enable_execute_command             = var.ecs_enable_execute_command
  tags                                = var.tags_ecs_service
}

