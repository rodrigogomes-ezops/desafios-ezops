output "name" {
  description = "Nome do parâmetro criado"
  value       = aws_ssm_parameter.this.name
}

output "arn" {
  description = "ARN do parâmetro criado"
  value       = aws_ssm_parameter.this.arn
}
