variable "resource_id" {
  type        = string
  description = "Id do Cluster do MSK"
}

variable "max_capacity" {
  type        = number
  description = "Capacidade máxima de armazenamento em GB"
}

variable "min_capacity" {
  type        = number
  description = "Capacidade mínima de armazenamento em GB"
}
