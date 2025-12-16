#############################
# Variables
#############################
variable "config_json" {
  type        = string
  description = "JSON da distribuição CloudFront (use templatefile(...) no chamador)."
}