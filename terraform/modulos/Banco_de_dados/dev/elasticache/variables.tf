variable "security_groups_ids" {
  type = list(string)
}

data "aws_availability_zones" "available" {
  state = "available"
}

variable "engine" {
  type        = string
  description = "Engine DB"
}

variable "engine_version" {
  type        = string
  description = "Engine DB version"
}

variable "maintenance_window" {
  type        = string
  description = "Maintenance Window"
}

variable "node_type" {
  type        = string
  description = "Node Type Elasticache DB"  

}

variable "parameter_group_name" {
  type        = string
  description = "parameter_group_name Elasticache"  
}

variable "port" {
  type        = string
  description = "Port Elasticache"  
}

variable "replication_group_id" {
  type        = string
  description = "replication group id Elasticache"  
}

variable "at_rest_encryption_enabled" {
  description = "Habilita encriptação"
  type        = bool  
}

variable "auto_minor_version_upgrade" {
  description = "Habilita Menor Versão de Upgrade Automatico"
  type        = bool  
}

variable "automatic_failover_enabled" {
  description = "Habilita Failover Automatico"
  type        = bool  
}

variable "multi_az_enabled" {
  description = "Habilita Mult-AZ"
  type        = bool  
}

variable "snapshot_retention_limit" {
  description = "snapshot_retention_limit"
  type        = string  
}

variable "snapshot_window" {
  description = "snapshot_window"
  type        = string  
}

variable "subnet_group_name" {
  description = "subnet_group_name"
  type        = string  
}

variable "transit_encryption_enabled" {
  description = "transit_encryption"
  type        = bool  
}

variable "num_node_groups" {
  description = "transit_encryption"
  type        = string  
}

variable "replicas_per_node_group" {
  description = "replicas_per_node_group"
  type        = string  
}

variable "tags" {
  description = "Tags adicionais para o Elasticache"
  type        = map(string)  
}