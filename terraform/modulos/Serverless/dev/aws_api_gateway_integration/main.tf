locals {
  request_params = {
    for h in var.authorizer_headers :
    "integration.request.header.${h}" => "context.authorizer.${h}"
  }
}

resource "aws_api_gateway_integration" "this" {
  rest_api_id             = var.rest_api_id
  resource_id             = var.resource_id
  http_method             = var.http_method

  type                    = "HTTP"
  uri                     = var.uri
  integration_http_method = var.integration_http_method

  connection_type = "VPC_LINK"
  connection_id   = var.connection_id

  # só define se houver headers
  request_parameters = length(var.authorizer_headers) > 0 ? local.request_params : null
}
