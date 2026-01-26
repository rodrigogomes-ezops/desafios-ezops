locals {
  swagger_body = var.swagger_file != null ? file(var.swagger_file) : null
}

resource "aws_api_gateway_rest_api" "this" {
  name                         = var.api_name
  disable_execute_api_endpoint = var.disable_execute_api_endpoint
  body                         = local.swagger_body

  endpoint_configuration { types = var.endpoint_types }
  tags = var.tags
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  triggers = {
    redeploy_hash = sha256(coalesce(local.swagger_body, "no-swagger"))
  }
  lifecycle { create_before_destroy = true }
}

resource "aws_api_gateway_stage" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  deployment_id = aws_api_gateway_deployment.this.id
  stage_name    = var.stage_name
  variables     = var.stage_variables
  tags          = var.tags

  # Sem access_log_settings aqui
  lifecycle { ignore_changes = [deployment_id] }
}

resource "aws_api_gateway_method_settings" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled        = true
    logging_level          = "INFO"
    throttling_rate_limit  = 10000
    throttling_burst_limit = 5000
  }
}
