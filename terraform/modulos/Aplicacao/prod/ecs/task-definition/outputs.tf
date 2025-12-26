output "task_definition_arn" {
  description = "ARN da task definition"
  value       = aws_ecs_task_definition.this.arn
}

output "task_definition_family" {
  description = "Família da task definition"
  value       = aws_ecs_task_definition.this.family
}

output "task_definition_revision" {
  description = "Revisão da task definition"
  value       = aws_ecs_task_definition.this.revision
}

