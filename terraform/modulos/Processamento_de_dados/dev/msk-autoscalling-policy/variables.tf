variable "name" {
  type        = string
  description = "Nome Auto Scalling Policy"
}

variable "policy_type" {
  type        = string
  description = "Tipo de Policy do AutoScalling"
  default     = "TargetTrackingScaling"

}

variable "metrics_type" {
  type        = string
  description = "Tipo de metrica para o Escalonamento"
  default     = "KafkaBrokerStorageUtilization"
}

variable "target_value" {
  type        = string
  description = "Alvo para a Metrica do escalonamento ser ativada"
  default     = 70.0

}

variable "resource_id" {
  type        = string
  description = "Resource ID AutoScalling target Cluster"
}

variable "scalable_dimension" {
  type        = string
  description = "Scalable Dimension AutoScalling target Cluster"

}

variable "service_namespace" {
  type        = string
  description = "Service Namespace AutoScalling target Cluster"

}
