locals {
  routes = jsondecode(var.routes_json)
}

resource "aws_ec2_transit_gateway_route" "this" {
  for_each = local.routes

  transit_gateway_route_table_id = var.transit_gateway_route_table_id

  # destino (suporta 'destination_cidr_block' ou 'cidr_block' no JSON)
  destination_cidr_block = coalesce(
    try(each.value.destination_cidr_block, null),
    try(each.value.cidr_block, null)
  )

  # alvo (um OU outro)
  transit_gateway_attachment_id = try(each.value.transit_gateway_attachment_id, null)
  blackhole                     = try(each.value.blackhole, null)
}
