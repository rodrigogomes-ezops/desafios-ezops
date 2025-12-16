variable "domain" {
  type        = string
  description = "Domain Name"
  default     = "diagnostic-auth"
}

variable "cognito_user_pool" {
  type        = string
  description = "User Pool Id"
  default     = "aws_cognito_user_pool.diagnostic-pool.id"
}