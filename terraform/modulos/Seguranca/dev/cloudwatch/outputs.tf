output "cloudwatch_arn" {
  description = "ARN do Cloudwatch LogGroup"
  value       = aws_cloudwatch_log_group.this.arn

}

output "cloudwatch_name" {
  description = "Nome do Cloudwatch Logroup"
  value = aws_cloudwatch_log_group.this.name
  
}