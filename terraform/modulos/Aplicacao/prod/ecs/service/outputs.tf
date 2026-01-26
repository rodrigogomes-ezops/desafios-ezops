output "service_id" {
  description = "ID do serviço ECS"
  value       = aws_ecs_service.this.id
}

output "service_name" {
  description = "Nome do serviço ECS"
  value       = aws_ecs_service.this.name
}

output "service_arn" {
  description = "ARN do serviço ECS"
  value       = aws_ecs_service.this.id
}

