output "bootstrap_brokers_tls" {
  description = "Endpoint TLS para conectar ao cluster MSK"
  value       = aws_msk_cluster.this.bootstrap_brokers_tls
}

output "bootstrap_brokers_sasl_scram" {
  description = "Endpoint SCRAM (se configurado futuramente)"
  value       = aws_msk_cluster.this.bootstrap_brokers_sasl_scram
}

output "msk_cluster_arn" {
  description = "ARN do cluster MSK"
  value       = aws_msk_cluster.this.arn
}

output "zookeeper_connect_string" {
  description = "String de conexão do Zookeeper"
  value       = aws_msk_cluster.this.zookeeper_connect_string
}

output "msk_cluster_id" {
  description = "Id do Cluster"
  value = aws_msk_cluster.this.id
}

output "cluster_name" {
  description = "Nome do cluster"
  value = aws_msk_cluster.this.cluster_name  
}