output "grafana_target_group_arn" {
  description = "ARN of the Grafana target group"
  value       = module.target_group_grafana.target_group_arn
}

output "monitoring_security_group_id" {
  description = "Security group ID for monitoring tasks"
  value       = module.security_group_monitoring.security_group_id
}

output "ecs_service_name" {
  description = "ECS service name for monitoring"
  value       = module.ecs_service_monitoring.service_name
}

output "prometheus_log_group" {
  description = "CloudWatch log group for Prometheus"
  value       = aws_cloudwatch_log_group.monitoring.name
}

output "grafana_log_group" {
  description = "CloudWatch log group for Grafana"
  value       = aws_cloudwatch_log_group.monitoring.name
}

