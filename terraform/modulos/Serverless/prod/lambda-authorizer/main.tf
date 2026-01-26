resource "aws_lambda_function" "this" {
  filename         = var.filename
  function_name    = var.name
  role             = var.iam_role
  handler          = var.handler
  source_code_hash = var.filename != null ? filebase64sha256(var.filename) : null
  runtime          = "provided.al2023"
  architectures    = ["arm64"]

  environment {
    variables = {
      URL_AUTH_VERIFY  = var.alb_int_auth
      ENABLE_LOG_INFO  = "true"
      ENABLE_LOG_DEBUG = "true"
    }
  }

  vpc_config {
    security_group_ids = [var.security_group] 
    subnet_ids         = var.subnet_ids          
  }

  tags = var.tags
}
