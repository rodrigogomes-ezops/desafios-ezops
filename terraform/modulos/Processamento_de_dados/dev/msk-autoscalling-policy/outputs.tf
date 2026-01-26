output "appautoscaling_policy_name" {
  description = "Nome da política de escalonamento criada"
  value       = aws_appautoscaling_policy.this.name
}

output "appautoscaling_policy_arn" {
  description = "ARN da política de escalonamento"
  value       = aws_appautoscaling_policy.this.arn
}
