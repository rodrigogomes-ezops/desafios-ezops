variable "lb_arn" {
  description = "ARN do Load Balancer"
  type        = string
}

variable "port" {
  description = "Porta do Listener (Padrão 443)"
  type        = number
  default     = 443
}

variable "protocol" {
  description = "Protocolo do Listener HTTP, HTTPS, TCP (Padrão HTTPS)"
  type        = string
  default     = "HTTPS"
}

variable "ssl_policy" {
  description = "Política SSL (ex: ELBSecurityPolicy-TLS13-1-2-2021-06)"
  type        = string
}

variable "certificate_arn" {
  description = "ARN do certificado ACM"
  type        = string
}

variable "target_group_arn" {
  description = "ARN do Target Group para redirecionamento"
  type        = string
}

variable "tags" {
  description = "Tags aplicadas ao recurso"
  type        = map(string)
}
