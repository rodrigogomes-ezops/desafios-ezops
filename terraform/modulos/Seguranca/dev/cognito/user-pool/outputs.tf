output "user_pool_id" {
  description = "User Pool Id"
  value       = aws_cognito_user_pool.this.id
}