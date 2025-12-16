output "appback_subnet_id" {
  description = "IDs das subnets appback"
  value       = [for subnet in aws_subnet.dev_appback : subnet.id]
}

output "appback_subnet_ids_by_name" {
  description = "Mapa de nomes para os IDs das subnets appback"
  value = {
    for az, name in var.appback_subnet_names :
    name => aws_subnet.dev_appback[az].id
  }
}
