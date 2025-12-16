output "id" {
  description = "ID da Origin Request Policy"
  value       = aws_cloudfront_origin_request_policy.this.id
}

output "name" {
  description = "Nome da Origin Request Policy"
  value       = aws_cloudfront_origin_request_policy.this.name
}
