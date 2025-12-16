output "nlb_arn" {
  description = "ARN do Load Balancer"
  value       = aws_lb.nlb.arn
}

output "nlb_dns_name" {
  description = "DNS Name do Load Balancer"
  value       = aws_lb.nlb.dns_name
}