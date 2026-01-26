######################################################################################
resource "aws_msk_cluster" "this" {
  cluster_name           = var.cluster_name
  kafka_version          = var.version_kafka
  number_of_broker_nodes = var.broker_nodes
  

  broker_node_group_info {
    instance_type   = var.instance_type
    client_subnets  = var.client_subnets
    security_groups = var.security_groups_ids
    storage_info {
      ebs_storage_info {
        volume_size = var.volume_size
      }
    }
  }

  client_authentication {
    unauthenticated = true

    sasl {
      iam   = false
      scram = false
    }

    tls {}
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = var.encryption_kms_key_arn
    encryption_in_transit {
      client_broker = var.client_broker
      in_cluster    = var.in_clusters
    }
  }

 
  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }

      node_exporter {
        enabled_in_broker = true
      }
    }
  }

  logging_info {
    broker_logs {
      firehose {
        enabled = var.firehose
      }

      s3 {
        enabled = var.s3
      }
      cloudwatch_logs {
        enabled   = var.cloudwatch_enabled_logs
        log_group = var.cloudwatch_log_group_name
      }
    }
  }

  lifecycle {
    ignore_changes = [
      broker_node_group_info, client_authentication
    ]
  }

  tags = var.tags
}





