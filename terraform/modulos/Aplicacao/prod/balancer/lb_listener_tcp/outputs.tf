output "listener_tcp_arn" {
  description = "ARN do Listener TCP"
  value       = aws_lb_listener.this.arn
}

output "listener_tcp_id" {
  description = "ID do Listener TCP"
  value       = aws_lb_listener.this.id
}

output "tcp_listener_arn" {
  description = "ARN do TCp Listener"
  value       = aws_lb_listener.this.arn
}
