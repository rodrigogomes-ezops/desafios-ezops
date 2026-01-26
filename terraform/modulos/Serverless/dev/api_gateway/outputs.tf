output "rest_api_id" {
  description = "ID do API Gateway REST."
  value       = aws_api_gateway_rest_api.this.id
}

output "rest_api_root_resource_id" {
  description = "ID do recurso raiz '/'."
  value       = aws_api_gateway_rest_api.this.root_resource_id
}

output "stage_name" {
  description = "Nome do stage criado."
  value       = aws_api_gateway_stage.this.stage_name
}
