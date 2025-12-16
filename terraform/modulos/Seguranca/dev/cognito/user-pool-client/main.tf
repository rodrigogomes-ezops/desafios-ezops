resource "aws_cognito_user_pool_client" "this" {
  name = var.name

  user_pool_id = var.user_pool_id

  explicit_auth_flows                  = [var.explicit_auth_flows]
  enable_token_revocation              = var.token_revocation
  prevent_user_existence_errors        = var.prevent_user_errors
  generate_secret                      = var.generate_secret
  allowed_oauth_flows                  = ["client_credentials"]
  supported_identity_providers         = ["COGNITO"]
  allowed_oauth_flows_user_pool_client = var.allowed_oauth_flows
  allowed_oauth_scopes                 = [var.allowed_oauth_scopes]

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}