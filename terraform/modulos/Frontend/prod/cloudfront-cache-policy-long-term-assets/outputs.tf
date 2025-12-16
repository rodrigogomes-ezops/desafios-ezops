output "id" {
  description = "ID da Cache Policy criada"
  value       = aws_cloudfront_cache_policy.this.id
}

output "name" {
  description = "Nome da Cache Policy"
  value       = aws_cloudfront_cache_policy.this.name
}
