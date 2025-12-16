resource "aws_wafv2_web_acl" "this" {
  name        = var.name
  description = var.description
  scope       = var.scope

  #

  default_action {
    allow {}
  }

  dynamic "rule" {
    for_each = var.managed_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      # Override action condicional (count ou none)
      dynamic "override_action" {
        for_each = rule.value.override_action_type == "count" ? [1] : []
        content {
          count {}
        }
      }

      dynamic "override_action" {
        for_each = rule.value.override_action_type == "none" ? [1] : []
        content {
          #none {}
        }
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value.managed_rule_group.name
          vendor_name = rule.value.managed_rule_group.vendor_name

          dynamic "rule_action_override" {
            for_each = lookup(rule.value.managed_rule_group, "rule_action_override", [])
            content {
              name = rule_action_override.value.name
              action_to_use {
                dynamic "count" {
                  for_each = rule_action_override.value.action == "count" ? [1] : []
                  content {}
                }

               
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.name
        sampled_requests_enabled   = true
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.name
    sampled_requests_enabled   = true
  }

  tags = var.tags
}
