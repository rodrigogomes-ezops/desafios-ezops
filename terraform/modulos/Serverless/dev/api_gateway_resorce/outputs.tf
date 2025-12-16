output "resource_ids" {
  description = "Mapa nome=>resource_id dos recursos encontrados."
  value       = { for k, v in data.aws_api_gateway_resource.this : k => v.id }
}

output "resources_full" {
  description = "Objetos completos (útil para depuração)."
  value       = { for k, v in data.aws_api_gateway_resource.this : k => {
    id             = v.id
    parent_id      = v.parent_id
    path           = v.path
    path_part      = v.path_part
    rest_api_id    = v.rest_api_id
    resource_methods = v.resource_methods
  } }
}
