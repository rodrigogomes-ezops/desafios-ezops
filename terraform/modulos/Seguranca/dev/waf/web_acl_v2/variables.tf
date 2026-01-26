variable "name" {
  type = string
  description = "Nome do Waf WebAcl"
}

variable "description" {
  type = string
  description = "Descrição do Waf WebAcl"
}

variable "scope" {
  type = string
  description = "Scope do WAF"
  default = "CLOUDFRONT"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "provider_override" {
  description = "Provider opcional para o WAF (ex: aws.useast)"
  type        = any
  default     = null
}

variable "managed_rules" {
  description = "Lista de regras gerenciadas do WAF"
  type = list(object({
    name     = string
    priority = number
    override_action_type = string # none ou count
    managed_rule_group = object({
      name        = string
      vendor_name = string
      rule_action_override = optional(list(object({
        name   = string
        action = string # count ou none
      })), [])
    })
  }))
}