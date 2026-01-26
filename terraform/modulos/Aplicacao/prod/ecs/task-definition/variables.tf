variable "family" {
  description = "Nome da família da task definition"
  type        = string
}

variable "network_mode" {
  description = "Modo de rede (awsvpc, bridge, host, none)"
  type        = string
  default     = "awsvpc"
}

variable "requires_compatibilities" {
  description = "Lista de tipos de launch (FARGATE, EC2)"
  type        = list(string)
}

variable "cpu" {
  description = "CPU units para a task"
  type        = string
}

variable "memory" {
  description = "Memória para a task"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN da role de execução"
  type        = string
}

variable "task_role_arn" {
  description = "ARN da role da task"
  type        = string
  default     = null
}

variable "container_definitions" {
  description = "Definições dos containers (lista de objetos)"
  type        = list(any)
}

variable "volumes" {
  description = "Lista de volumes"
  type        = list(any)
  default     = []
}

variable "tags" {
  description = "Tags da task definition"
  type        = map(string)
  default     = {}
}

