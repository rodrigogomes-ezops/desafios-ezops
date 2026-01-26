variable "log_destination" {
  type        = string
  description = "LogGroup de Destino waf"
  default     = "arn:aws:logs:eu-central-1:986523078570:log-group:aws-waf-logs-eu:*"
}

variable "resource_arn" {
  type        = string
  description = "Resource Arn WebAcl do waf "
  default     = "arn:aws:wafv2:eu-central-1:986523078570:regional/webacl/PH_WAF_ACL_REGIONAL/8bb1c92f-004a-4688-872e-7393643c7a40"
}