output "service_subnet_id" {
  description = "IDs das subnets service"
  value       = [for subnet in aws_subnet.dev_service : subnet.id]
}

output "service_subnet_ids_by_name" {
  description = "Mapa de nomes para os IDs das subnets service"
  value = {
    for az, name in var.service_subnet_names :
    name => aws_subnet.dev_service[az].id
  }
}