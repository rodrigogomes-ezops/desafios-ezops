data "aws_api_gateway_resource" "this" {
  for_each   = var.resources
  rest_api_id = var.rest_api_id
  path        = each.value
}
