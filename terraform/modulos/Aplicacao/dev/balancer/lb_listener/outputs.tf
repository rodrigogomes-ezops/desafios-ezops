output "listener_https_arn" {
  description = "ARN do Listener HTTPS"
  value       = aws_lb_listener.this.arn
}

output "listener_https_id" {
  description = "ID do Listener HTTPS"
  value       = aws_lb_listener.this.id
}

output "https_listener_arn" {
  description = "ARN do HTTPS Listener"
  value       = aws_lb_listener.this.arn
}
