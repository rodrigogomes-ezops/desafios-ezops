variable "identifier" {
  type        = string
  description = "Identifier resource servers"
  default     = "DiagnosticServerAccess"
}

variable "name" {
  type        = string
  description = "Name resource servers"
  default     = "DiagnosticServerAccess"
}

variable "user_pool_id" {
  type        = string
  description = "User Pool Id"
  default     = aws_cognito_user_pool.diagnostic-pool.id
}

variable "scope_name" {
  type        = string
  description = "Nome do Scopes Customizado"
  default     = "ServerAccess"
}

variable "scope_description" {
  type        = string
  description = "Description do Scopes Customizado"
  default     = "Acesso do app"
}    