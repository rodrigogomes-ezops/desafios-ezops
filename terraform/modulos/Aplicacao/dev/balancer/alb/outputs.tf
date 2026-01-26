output "lb_arn" {
  description = "ARN do Load Balancer"
  value       = aws_lb.this.arn
}

output "lb_dns_name" {
  description = "DNS Name do Load Balancer"
  value       = aws_lb.this.dns_name
}

output "lb_id" {
  description = "ID do Load Balancer"
  value       = aws_lb.this.id
}

output "lb_name" {
  description = "Nome do Load Balancer"
  value       = aws_lb.this.name
}