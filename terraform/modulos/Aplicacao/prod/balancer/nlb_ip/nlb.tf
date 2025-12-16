
resource "aws_lb" "nlb" {
  name                       = var.name
  internal                   = var.internal
  load_balancer_type         = var.type
  security_groups            = var.security_group_ids  
  enable_deletion_protection = var.enable_deletion_protection
  subnet_mapping {
    subnet_id            = var.subnet_ids_1a
    private_ipv4_address = var.private_ipv4_address_1a
  }
  subnet_mapping {
    subnet_id            = var.subnet_ids_1b
    private_ipv4_address = var.private_ipv4_address_1b
  }

    subnet_mapping {
    subnet_id            = var.subnet_ids_1c
    private_ipv4_address = var.private_ipv4_address_1c
  }
  
  access_logs {
     bucket = var.access_logs_bucket
     prefix = var.access_logs_prefix
     enabled = var.access_logs_enabled
   }

  tags = var.tags
}


