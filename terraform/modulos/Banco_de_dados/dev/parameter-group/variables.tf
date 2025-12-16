variable "family" {
  type        = string
  description = "Familia do banco de Dados"
}

variable "parameter_group_name" {
  type        = string
  description = "Nome Parameter Group"  
}

variable "tags" {
  description = "Tags adicionais para o Parameter Group."
  type        = map(string)
  default     = {}
}

variable "shared_preload_libraries" {
  description = "Valor para shared_preload_libraries (ex: \"pg_stat_statements,pg_tle,pg_cron\"). Se null, não altera."
  type        = string
  default     = null
}