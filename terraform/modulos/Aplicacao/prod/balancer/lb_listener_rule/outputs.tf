output "id" {
  value       = aws_lb_listener_rule.this.id
  description = "ID da listener rule criada."
}

output "arn" {
  value       = aws_lb_listener_rule.this.arn
  description = "ARN da listener rule criada."
}
