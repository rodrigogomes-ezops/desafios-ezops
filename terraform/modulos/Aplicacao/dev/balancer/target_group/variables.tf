variable "tg_name" {
  description = "Nome do target group"
  type        = string
}

variable "target_type" {
  description = "Tipo do Target Group"
  type        = string
}

variable "target_group_port" {
  description = "Porta do target group"
  type        = number
}

variable "target_group_protocol" {
  description = "Protocolo do target group (HTTP, HTTPS)"
  type        = string
}

variable "target_group_protocol_version" {
  description = "Versão do protocolo (HTTP1, HTTP2, GRPC)"
  type        = string
  default     = "HTTP1"
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

# Health check variables
variable "health_check_protocol" {
  description = "Protocolo do health check"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Path do health check"
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "Porta usada no health check (ex: traffic-port)"
  type        = string
  default     = "traffic-port"
}

variable "healthy_threshold" {
  description = "Número de checks consecutivos para considerar saudável"
  type        = number
  default     = 5
}

variable "unhealthy_threshold" {
  description = "Número de falhas para considerar como unhealthy"
  type        = number
  default     = 2
}

variable "health_check_timeout" {
  description = "Timeout em segundos para health check"
  type        = number
  default     = 5
}

variable "health_check_interval" {
  description = "Intervalo entre checks"
  type        = number
  default     = 30
}

variable "health_check_matcher" {
  description = "Código esperado para considerar saudável"
  type        = string
  default     = "200"
}

variable "tags" {
  description = "Tags aplicadas ao TG"
  type        = map(string)
}
