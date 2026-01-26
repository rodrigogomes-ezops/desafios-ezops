variable "service_name" {
  description = "Nome do serviço ECS"
  type        = string
}

variable "cluster_id" {
  description = "ID do cluster ECS"
  type        = string
}

variable "task_definition_arn" {
  description = "ARN da task definition"
  type        = string
}

variable "desired_count" {
  description = "Número desejado de tasks"
  type        = number
  default     = 1
}

variable "launch_type" {
  description = "Tipo de launch (FARGATE, EC2)"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs das subnets"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Lista de IDs dos security groups"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Atribuir IP público"
  type        = bool
  default     = false
}

variable "load_balancer" {
  description = "Configuração do load balancer"
  type = object({
    target_group_arn = string
    container_name   = string
    container_port   = number
  })
  default = null
}

variable "service_registry" {
  description = "Configuração do service registry (Service Discovery)"
  type = object({
    registry_arn  = string
    port          = optional(number)
    container_name = optional(string)
  })
  default = null
}

variable "deployment_maximum_percent" {
  description = "Percentual máximo de deployment"
  type        = number
  default     = 200
}

variable "deployment_minimum_percent" {
  description = "Percentual mínimo de deployment"
  type        = number
  default     = 100
}

variable "health_check_grace_period_seconds" {
  description = "Período de graça para health check (segundos)"
  type        = number
  default     = 0
}

variable "enable_execute_command" {
  description = "Habilitar ECS Exec"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags do serviço"
  type        = map(string)
  default     = {}
}

