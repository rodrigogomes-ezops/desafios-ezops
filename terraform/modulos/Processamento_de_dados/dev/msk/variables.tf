
variable "security_groups_ids" {
  type        = list(string)
  description = "Security Groups Ids MSK" 
}

variable "tags" {
  description = "Tags adicionais para o MSK"
  type        = map(string)
 }

variable "cloudwatch_enabled_logs" {
  type        = bool
  description = "Ativar o Log Group"
}

variable "cloudwatch_log_group_name" {
  type        = string
  description = "CloudWatch LogGroup Name"
}

variable "encryption_kms_key_arn" {
  type        = string
  description = "Key do KMS para encryption"
}

variable "client_subnets" {
  type        = list(string)
  description = "Subnets do client"
}

variable "instance_type" {
  type        = string
  description = "Instance Type"
}

variable "cluster_name" {
  type        = string
  description = "Cluster Name"
}

variable "client_broker" {
  type        = string
  description = "Cluster Name"
}

variable "firehose"{
  type = bool
  description = "Ativar o firehose"
}

variable "s3"{
  type = bool
  description = "Ativar o s3"
}

variable "client_authentication"{
  type = bool
  description = "Ativar o Authetication"
}

variable "iam"{
  type = bool
  description = "Ativar o iam"
}

variable "scram"{
  type = bool
  description = "Ativar o iam"
}

variable "in_clusters" {
  type        = bool
  description = "Ativar encryption in transit"
}

variable "volume_size" {
  type        = string
  description = "Tamanho do Cluster"
}

variable "version_kafka" {
  type        = string
  description = "Versão do Kafka"
}

variable "broker_nodes" {
  type        = string
  description = "Numero de Nodes Brokens"
}


