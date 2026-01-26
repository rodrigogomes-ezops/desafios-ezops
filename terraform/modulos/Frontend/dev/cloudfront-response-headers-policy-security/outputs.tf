output "id" {
  description = "ID da Response Headers Policy de segurança"
  value       = aws_cloudfront_response_headers_policy.this.id
}

output "name" {
  description = "Nome da Response Headers Policy"
  value       = aws_cloudfront_response_headers_policy.this.name
}
