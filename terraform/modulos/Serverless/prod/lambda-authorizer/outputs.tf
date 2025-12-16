output "authorizer_invoke_arn" {
  value = aws_lambda_function.this.invoke_arn  
}

output "arn_lambda" {
  value = aws_lambda_function.this.arn
}
