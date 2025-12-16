variable "name" {
  type        = string
  description = "Name User Pool Client"
  default     = "Diagnostic"
}

variable "user_pool_id" {
  type        = string
  description = "User Pool ID"
  default     = aws_cognito_user_pool.diagnostic-pool.id
}

variable "explicit_auth_flows" {
  type        = string
  description = "Authentication flows"
  default     = "ALLOW_REFRESH_TOKEN_AUTH"
}

variable "token_revocation" {
  type        = bool
  description = "Enable token revocation Advanced security configurations"
  default     = true
}

variable "prevent_user_errors" {
  type        = bool
  description = "Prevent user existence errors Advanced security configurations"
  default     = true
}

variable "generate_secret" {
  type        = bool
  description = "Generate Client secret"
  default     = true
}

variable "allowed_oauth_flows" {
  type        = bool
  description = "allowed_oauth_flows_user_pool_client"
  default     = true
}

variable "allowed_oauth_scopes" {
  type        = string
  description = "Scopes de acesso permitido"
  default     = "DiagnosticServerAccess/ServerAccess"
}