output "cluster_id" {
  description = "ID do cluster ECS"
  value       = aws_ecs_cluster.this.id
}

output "cluster_arn" {
  description = "ARN do cluster ECS"
  value       = aws_ecs_cluster.this.arn
}

output "cluster_name" {
  description = "Nome do cluster ECS"
  value       = aws_ecs_cluster.this.name
}

