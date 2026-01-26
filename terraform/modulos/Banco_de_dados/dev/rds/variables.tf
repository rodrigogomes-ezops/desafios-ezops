variable "security_groups_ids" {
   description = "Lista de SGs do RDS"
  type = list(string)
}

variable "monitoring_role_arn" {
  type        = string
  description = "Role de Permissão do monitoramento"
}

variable "tags" {
  description = "Tags adicionais para o Elasticache"
  type        = map(string)
}

variable "identifier" {
  type        = string
  description = "Identificador do Banco de dados"
}

variable "db_name" {
  type        = string
  description = "Nome do Banco de dados"
}

variable "instance_class" {
  type        = string
  description = "Classe do  Banco de dados"
}

variable "engine" {
  type        = string
  description = "Engine do  Banco de dados"
}

variable "engine_version" {
  type        = string
  description = "Engine do  Banco de dados"
}

variable "license_model" {
  type        = string
  description = "Modelo de Licença  Banco de dados"
}
variable "username" {
  type        = string
  description = "User Banco de dados"
}

variable "password" {
  type        = string
  description = "Password Banco de dados"
}

variable "port" {
  type        = string
  description = "port Banco de dados"
}

variable "allocated_storage" {
  type        = string
  description = "allocated_storage Banco de dados"
}

variable "max_allocated_storage" {
  type        = string
  description = "Max_allocated_storage Banco de dados"
}

variable "storage_type" {
  type        = string
  description = "Tipo de Storage Banco de dados"
}

variable "final_snapshot" {
  type        = bool
  description = "Skip Final Snapshot Banco de dados"
}

variable "storage_encrypted" {
  type        = bool
  description = "storage_encrypted Banco de dados"
}

variable "publicly_accessible" {
  type        = bool
  description = "publicly_accessible Banco de dados"
}

variable "apply_immediately" {
  type        = bool
  description = "apply_immediately Banco de dados"
}

variable "backup_retention_period" {
  type        = string
  description = "backup_retention_period Banco de dados"
}

variable "backup_window" {
  type        = string
  description = "backup_window Banco de dados"
}

variable "character_set_name" {
  type        = string
  description = "character_set_name Banco de dados"
}

variable "final_snapshot_identifier" {
  type        = string
  description = "character_set_name Banco de dados"
}

variable "multi_az" {
  type        = bool
  description = "multi_az Banco de dados"
}

variable "db_subnet_group_name" {
  type        = string
  description = "db_subnet_group_name Banco de dados"
}

variable "parameter_group_name" {
  type        = string
  description = "parameter_group_name Banco de dados"
}

variable "option_group_name" {
  type        = string
  description = "option_group_name Banco de dados"  
}

variable "copy_tags_to_snapshot" {
  type        = bool
  description = "copy_tags_to_snapshot Banco de dados"
}

variable "performance_insights" {
  type        = bool
  description = "performance_insights Banco de dados"
}

variable "performance_insights_retention_period" {
  type        = string
  description = "performance_insights_retention_period Banco de dados"
}

variable "allow_major_version_upgrade" {
  type        = bool
  description = "allow_major_version_upgrade Banco de dados"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "auto_minor_version_upgrade Banco de dados"
}

variable "monitoring_interval" {
  type        = string
  description = "monitoring_interval Banco de dados"
}

variable "maintenance_window" {
  type        = string
  description = "maintenance_window Banco de dados"
}

variable "deletion_protection" {
  type        = bool
  description = "deletion_protection Banco de dados"
}

variable "delete_automated_backups" {
  type        = bool
  description = "delete_automated_backups Banco de dados"
}

variable "iam_database_authentication" {
  type        = bool
  description = "iam_database_authentication_enabled Banco de dados"
}

variable "customer_owned_ip" {
  type        = bool
  description = "customer_owned_ip Banco de dados"
}

variable "ca_cert_identifier" {
  type        = string
  description = "ca_cert_identifier Banco de dados"
}

variable "cloudwatch_logs_exports" {
  type        = list(string)
  description = "Cloudwatch logs Export"
}
