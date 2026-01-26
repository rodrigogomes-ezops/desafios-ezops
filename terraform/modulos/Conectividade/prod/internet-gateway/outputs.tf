output "internet_gateway_id" {
  description = "ID do Internet Gateway"
  value       = aws_internet_gateway.this.id
}

output "internet_gateway_arn" {
  description = "ARN do Internet Gateway"
  value       = aws_internet_gateway.this.arn
}

