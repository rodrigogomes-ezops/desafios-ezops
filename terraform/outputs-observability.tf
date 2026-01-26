###################################################################################################################
################################################## Outputs Observabilidade #######################################
###################################################################################################################

output "prometheus_endpoint" {
  description = "Endpoint interno do Prometheus (via ALB)"
  value       = "http://${module.alb_observability.lb_dns_name}:9090"
}

output "grafana_endpoint" {
  description = "Endpoint interno do Grafana (via ALB)"
  value       = "http://${module.alb_observability.lb_dns_name}:3000"
}

output "prometheus_efs_id" {
  description = "ID do EFS para dados do Prometheus"
  value       = aws_efs_file_system.prometheus_data.id
}

output "grafana_efs_id" {
  description = "ID do EFS para dados do Grafana"
  value       = aws_efs_file_system.grafana_data.id
}
