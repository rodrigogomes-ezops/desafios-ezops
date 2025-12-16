resource "aws_api_gateway_integration_response" "this" {
  rest_api_id       = var.rest_api_id
  resource_id       = var.resource_id
  http_method       = var.http_method
  status_code       = var.status_code
  selection_pattern = var.selection_pattern
}
