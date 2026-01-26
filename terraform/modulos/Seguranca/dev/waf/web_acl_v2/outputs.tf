output "web_acl_arn" {
  description = "ARN do WAF Web ACL"
  value       = aws_wafv2_web_acl.this.arn
}

output "web_acl_id" {
  description = "ID do WAF Web ACL"
  value       = aws_wafv2_web_acl.this.id
}

output "web_acl_name" {
  description = "Nome do WAF Web ACL"
  value       = aws_wafv2_web_acl.this.name
}
