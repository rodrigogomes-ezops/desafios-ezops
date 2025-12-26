variable "cluster_name" {
  description = "Nome do cluster ECS"
  type        = string
}

variable "container_insights_enabled" {
  description = "Habilitar Container Insights"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags do cluster"
  type        = map(string)
}

