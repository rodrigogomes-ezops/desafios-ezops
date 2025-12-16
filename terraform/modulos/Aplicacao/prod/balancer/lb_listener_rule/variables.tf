variable "listener_arn" {
  description = "ARN do listener."
  type        = string
}

variable "priority" {
  description = "Prioridade da regra."
  type        = number
}

variable "target_group_arn" {
  description = "ARN do Target Group para forward."
  type        = string
}

variable "path_values" {
  description = "Lista de paths. Se não informada, a regra não terá path_pattern."
  type        = list(string)
  default     = []
}

variable "host_header_values" {
  description = "Lista opcional de host headers (ex: [\"api.exemplo.com\"])."
  type        = list(string)
  default     = []
}
