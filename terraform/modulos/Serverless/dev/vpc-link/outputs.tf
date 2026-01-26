output "id" {
  description = "ID do VPC Link (use em connectionId do API Gateway)"
  value       = aws_api_gateway_vpc_link.this.id
}

output "arn" {
  description = "ARN do VPC Link"
  value       = aws_api_gateway_vpc_link.this.arn
}
