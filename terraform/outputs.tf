###################################################################################################################
################################################## Outputs #######################################################
###################################################################################################################

#######################
#### CloudFront URLs ####
#######################

output "cloudfront_frontend_url" {
  description = "URL do CloudFront para o frontend (S3)"
  value       = "https://${module.cloudfront_distribution.domain_name}"
}

# output "cloudfront_backend_url" {
#   description = "URL do CloudFront para o backend (ALB)"
#   value       = "https://${aws_cloudfront_distribution.backend.domain_name}"
# }

#######################
#### ALB URLs ####
#######################

output "alb_dns_name" {
  description = "DNS Name do ALB"
  value       = module.alb_backend.lb_dns_name
}

output "alb_arn" {
  description = "ARN do ALB"
  value       = module.alb_backend.lb_arn
}

#######################
#### RDS ####
#######################

output "rds_endpoint" {
  description = "Endpoint do RDS PostgreSQL"
  value       = module.rds_postgre.rds_endpoint
}

output "rds_connection_string" {
  description = "String de conexão do RDS (sem senha)"
  value       = module.rds_postgre.rds_postgres_connection_string
  sensitive   = true
}

#######################
#### S3 Frontend ####
#######################

output "s3_frontend_bucket" {
  description = "Nome do bucket S3 do frontend"
  value       = module.s3_frontend.bucket_name
}

#######################
#### ECS ####
#######################

output "ecs_cluster_name" {
  description = "Nome do cluster ECS"
  value       = module.ecs_cluster.cluster_name
}

output "ecs_service_name" {
  description = "Nome do serviço ECS"
  value       = var.ecs_service_name
}

#######################
#### Security Groups ####
#######################

output "security_group_alb_id" {
  description = "ID do Security Group do ALB"
  value       = module.security_group_alb.security_group_id
}

output "security_group_ecs_id" {
  description = "ID do Security Group do ECS"
  value       = module.security_group_ecs.security_group_id
}

output "security_group_rds_id" {
  description = "ID do Security Group do RDS"
  value       = module.security_group_rds.security_group_id
}

