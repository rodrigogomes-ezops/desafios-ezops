resource "aws_cognito_user_pool_domain" "this" {
  domain       = var.domain
  user_pool_id = var.cognito_user_pool
}