output "authorizer_invoke_arn" {
  value = aws_lambda_function.this.invoke_arn  
}

#output "alb_int_auth" {
#  value =  "http://${data.aws_lb.alb_int_auth.dns_name}:7366/verify"
#}

output "arn_lambda" {
  value = aws_lambda_function.this.arn
}
