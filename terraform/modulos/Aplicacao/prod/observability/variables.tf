variable "vpc_id" {
  description = "VPC where monitoring tasks will run"
  type        = string
}

variable "private_subnets" {
  description = "Private subnets for Fargate tasks"
  type        = list(string)
}

variable "ecs_cluster_id" {
  description = "ECS cluster ID or ARN"
  type        = string
}

variable "execution_role_arn" {
  description = "ECS task execution role ARN"
  type        = string
}

variable "task_role_arn" {
  description = "Task role ARN for Prometheus/Grafana"
  type        = string
  default     = null
}

variable "alb_listener_arn" {
  description = "ALB listener ARN used to add /grafana/* rule"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group ID attached to the ALB"
  type        = string
}

variable "prometheus_image" {
  description = "Full ECR image URI for Prometheus"
  type        = string
}

variable "grafana_image" {
  description = "Full ECR image URI for Grafana"
  type        = string
}

variable "project_name" {
  description = "Prefix for naming resources"
  type        = string
  default     = "getting-started"
}

variable "alb_dns_name" {
  description = "Public DNS name of the ALB (used by Grafana GF_SERVER_DOMAIN)"
  type        = string
}

variable "grafana_admin_password" {
  description = "Admin password for Grafana"
  type        = string
  default     = "changeme"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

