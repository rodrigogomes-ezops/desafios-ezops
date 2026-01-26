output "management_subnet_id" {
  description = "IDs das subnets management"
  value       = [for subnet in aws_subnet.dev_management : subnet.id]
}

output "management_subnet_ids_by_name" {
  description = "Mapa de nomes para os IDs das subnets management"
  value = {
    for az, name in var.management_subnet_names :
    name => aws_subnet.dev_management[az].id
  }
}