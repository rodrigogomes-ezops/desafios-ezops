##################################################################################################
######################################## Variáveis de Conectividade ##############################
##################################################################################################

variable "vpc_cidr_block" {
  description = "cidr_block usado para a VPC"
  type        = string
}

variable "tags_vpc" {
  description = "Tags adicionais para a VPC"
  type        = map(string)
  default     = {}
}

variable "tags_igw" {
  description = "Tags adicionais para o Internet Gateway - VPC  APP"
  type        = map(string)
  default     = {}
}

variable "tags_public_subnet" {
  description = "Tags adicionais para a Subnet Publica"
  type        = map(string)
  default     = {}
}

variable "subnet_cidr_blocks_public" {
  description = "Lista de CIDR blocks para a subrede Publica"
  type        = map(string)
}

variable "availability_zones_public" {
  description = "Zonas de disponibilidades publicas"
  type        = map(string)
}

variable "public_subnet_names" {
  description = "Map para subrede publica e Nat Gateway"
  type        = map(string)
}

variable "tags_route_table_public" {
  description = "Tags adicionais para route table public"
  type        = map(string)
  default     = {}
}

variable "rt_public_name" {
  description = " route table name Public"
  type        = map(string)
}

#################################################################################
#------------------------# SECURITY - VARIAVEIS  #------------------------------#
#################################################################################

######################################################################################################################
# Security - ECS #####################################################################################################
# --------------------------------------------------------------------------------------------------------------------

variable "name_sg_ecs" {
  description = "Nome do Security Group"
  type        = string
}

variable "description_sg_ecs" {
  description = "description do Security Group"
  type        = string
}

variable "tags_sg_ecs" {
  description = "Tags do Security Group"
  type        = map(string)
}

######################################################################################################################
# Security - RDS #####################################################################################################
# --------------------------------------------------------------------------------------------------------------------

variable "name_sg_rds_ecs" {
  description = "Nome do Security Group"
  type        = string
}

variable "description_rds_ecs" {
  description = "description do Security Group"
  type        = string
}

variable "tags_rds_ecs" {
  description = "Tags do Security Group"
  type        = map(string)
}

#######################################################################################################################
# RDS - POSTGRE #######################################################################################################
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# RDS - INSTÂNCIA DE BANCO DE DADOS
# ---------------------------------------------------------------------------------------------------------------------
variable "identifier_postgre" {
  type        = string
  description = "Identificador único da instância RDS."
}

variable "db_name_postgre" {
  type        = string
  description = "Nome do banco de dados a ser criado."
}

variable "instance_class_postgre" {
  type        = string
  description = "Classe da instância RDS (ex: db.t3.medium)."
}

variable "engine_postgre" {
  type        = string
  description = "Nome do mecanismo de banco de dados (ex: postgres, mysql)."
}

variable "engine_version_postgre" {
  type        = string
  description = "Versão do mecanismo do banco de dados."
}

variable "license_model_postgre" {
  type        = string
  description = "Modelo de licença (ex: postgresql-license)."
}

variable "username_postgre" {
  type        = string
  description = "Nome de usuário master do banco."
}

variable "password_postgre" {
  type        = string
  description = "Senha do usuário master."
}

variable "port_postgre" {
  type        = number
  description = "Porta que o banco irá escutar."
}

variable "allocated_storage_postgre" {
  type        = number
  description = "Quantidade inicial de armazenamento (em GB)."
}

variable "max_allocated_storage_postgre" {
  type        = number
  description = "Máximo de armazenamento alocado (em GB)."
}

variable "storage_type_postgre" {
  type        = string
  description = "Tipo de armazenamento (standard, gp2, io1)."
}

variable "storage_encrypted_postgre" {
  type        = bool
  description = "Habilita criptografia em repouso."
}

variable "publicly_accessible_postgre" {
  type        = bool
  description = "Define se a instância será acessível publicamente."
}

variable "apply_immediately_postgre" {
  type        = bool
  description = "Aplica as alterações imediatamente."
}

variable "backup_retention_period_postgre" {
  type        = number
  description = "Período de retenção de backup em dias."
}

variable "backup_window_postgre" {
  type        = string
  description = "Janela de backup (ex: 03:00-04:00)."
}

variable "cloudwatch_logs_exports_postgre" {
  type        = list(string)
  description = "Lista de logs exportados para o CloudWatch."
}

variable "multi_az_postgre" {
  type        = bool
  description = "Habilita instância Multi-AZ para alta disponibilidade."
}

variable "copy_tags_to_snapshot_postgre" {
  type        = bool
  description = "Copia as tags da instância para os snapshots."
}

variable "performance_insights_postgre" {
  type        = bool
  description = "Ativa o Performance Insights."
}

variable "performance_insights_retention_period_postgre" {
  type        = number
  description = "Dias de retenção do Performance Insights."
}

variable "allow_major_version_upgrade_postgre" {
  type        = bool
  description = "Permite atualização de versão principal."
}

variable "auto_minor_version_upgrade_postgre" {
  type        = bool
  description = "Permite atualizações automáticas de versão menor."
}

variable "monitoring_interval_postgre" {
  type        = number
  description = "Intervalo de coleta do Enhanced Monitoring (em segundos)."
}

variable "maintenance_window_postgre" {
  type        = string
  description = "Janela de manutenção (ex: sun:05:00-sun:06:00)."
}

variable "deletion_protection_postgre" {
  type        = bool
  description = "Protege a instância contra deleção acidental."
}

variable "delete_automated_backups_postgre" {
  type        = bool
  description = "Remove backups automatizados ao deletar a instância."
}

variable "monitoring_role_arn_postgre" {
  type        = string
  description = "ARN do IAM Role para Enhanced Monitoring."
}

variable "iam_database_authentication_postgre" {
  type        = bool
  description = "Habilita autenticação via IAM."
}

variable "customer_owned_ip_postgre" {
  type        = bool
  description = "Habilita IP gerenciado pelo cliente (on-premises)."
}

variable "ca_cert_identifier_postgre" {
  type        = string
  description = "Identificador do certificado CA utilizado."
}

variable "final_snapshot_postgre" {
  type        = bool
  description = "Skip Final Snapshot Banco de dados."
}

variable "option_group_postgre" {
  type        = string
  description = "Option Group para o Postgre"
}

variable "tags_rds_postgre" {
  description = "Tags adicionais para o RDS."
  type        = map(string)
}

variable "character_set_name_postgre" {
  type        = string
  description = "Charset do banco (usado em MySQL)."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTION GROUP RDS POSTGRE 
# ---------------------------------------------------------------------------------------------------------------------
variable "engine_name_postgre" {
  type        = string
  description = "Engine Name do Option Group."
}

variable "major_engine_version_postgre" {
  type        = string
  description = "Versão principal da engine para o Option Group."
}

variable "option_group_name_postgre" {
  type        = string
  description = "Nome do Option Group a ser criado."
}

variable "option_description_postgre" {
  type        = string
  description = "Description do Option Group"
}

# ---------------------------------------------------------------------------------------------------------------------
# Parameter Group do RDS 
# ---------------------------------------------------------------------------------------------------------------------

variable "parameter_group_name_postgre" {
  type        = string
  description = "Nome do Parameter Group do RDS."
}

variable "family_postgre" {
  type        = string
  description = "Família do mecanismo de banco de dados (ex: oracle-se2-19, postgres15, etc.)."
}

variable "tags_parameter_group_postgre" {
  description = "Tags adicionais para o Parameter Group."
  type        = map(string)
  default     = {}
}

# ---------------------------------------------------------------------------------------------------------------------
# Subnet Group do RDS
# ---------------------------------------------------------------------------------------------------------------------
variable "name_subnet_group_rds" {
  type        = string
  description = "Nome do Subnet Group do RDS."
}

variable "tags_subnet_group_rds" {
  description = "Tags adicionais para o Subnet Group do RDS."
  type        = map(string)
}

#######################################################################################################################
# ECS #################################################################################################################
# ---------------------------------------------------------------------------------------------------------------------

variable "ecs_cluster_name" {
  description = "Nome do cluster ECS"
  type        = string
}

variable "ecs_container_insights_enabled" {
  description = "Habilitar Container Insights no cluster"
  type        = bool
  default     = false
}

variable "tags_ecs_cluster" {
  description = "Tags do cluster ECS"
  type        = map(string)
}

variable "ecs_task_family" {
  description = "Nome da família da task definition"
  type        = string
}

variable "ecs_task_network_mode" {
  description = "Modo de rede da task (awsvpc, bridge, host, none)"
  type        = string
  default     = "awsvpc"
}

variable "ecs_task_requires_compatibilities" {
  description = "Lista de tipos de launch (FARGATE, EC2)"
  type        = list(string)
}

variable "ecs_task_cpu" {
  description = "CPU units para a task"
  type        = string
}

variable "ecs_task_memory" {
  description = "Memória para a task"
  type        = string
}

variable "ecs_execution_role_arn" {
  description = "ARN da role de execução ECS"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "ARN da role da task ECS"
  type        = string
  default     = null
}

variable "ecs_container_definitions" {
  description = "Definições dos containers (lista de objetos)"
  type        = list(any)
}

variable "ecs_volumes" {
  description = "Lista de volumes"
  type        = list(any)
  default     = []
}

variable "tags_ecs_task_definition" {
  description = "Tags da task definition"
  type        = map(string)
  default     = {}
}

variable "ecs_service_name" {
  description = "Nome do serviço ECS"
  type        = string
}

variable "ecs_service_desired_count" {
  description = "Número desejado de tasks"
  type        = number
  default     = 1
}

variable "ecs_service_launch_type" {
  description = "Tipo de launch (FARGATE, EC2)"
  type        = string
}

variable "ecs_service_assign_public_ip" {
  description = "Atribuir IP público às tasks"
  type        = bool
  default     = false
}

variable "ecs_container_name" {
  description = "Nome do container para o load balancer"
  type        = string
}

variable "ecs_container_port" {
  description = "Porta do container para o load balancer"
  type        = number
}

variable "ecs_deployment_maximum_percent" {
  description = "Percentual máximo de deployment"
  type        = number
  default     = 200
}

variable "ecs_deployment_minimum_percent" {
  description = "Percentual mínimo de deployment"
  type        = number
  default     = 100
}

variable "ecs_health_check_grace_period_seconds" {
  description = "Período de graça para health check (segundos)"
  type        = number
  default     = 0
}

variable "ecs_enable_execute_command" {
  description = "Habilitar ECS Exec"
  type        = bool
  default     = false
}

variable "tags_ecs_service" {
  description = "Tags do serviço ECS"
  type        = map(string)
  default     = {}
}

#######################################################################################################################
# ALB #################################################################################################################
# ---------------------------------------------------------------------------------------------------------------------

variable "alb_name" {
  description = "Nome do Application Load Balancer"
  type        = string
}

variable "alb_internal" {
  description = "Se o ALB é interno"
  type        = bool
  default     = false
}

variable "alb_enable_deletion_protection" {
  description = "Proteção contra deleção"
  type        = bool
  default     = false
}

variable "alb_access_logs_bucket" {
  description = "Bucket S3 para access logs"
  type        = string
  default     = ""
}

variable "alb_access_logs_prefix" {
  description = "Prefixo dos logs no bucket"
  type        = string
  default     = ""
}

variable "alb_access_logs_enabled" {
  description = "Se os access logs estão habilitados"
  type        = bool
  default     = false
}

variable "tags_alb" {
  description = "Tags do ALB"
  type        = map(string)
}

variable "target_group_name" {
  description = "Nome do target group"
  type        = string
}

variable "target_group_port" {
  description = "Porta do target group"
  type        = number
}

variable "target_group_protocol" {
  description = "Protocolo do target group (HTTP, HTTPS)"
  type        = string
}

variable "target_group_protocol_version" {
  description = "Versão do protocolo (HTTP1, HTTP2, GRPC)"
  type        = string
  default     = "HTTP1"
}

variable "health_check_protocol" {
  description = "Protocolo do health check"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Path do health check"
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "Porta usada no health check (ex: traffic-port)"
  type        = string
  default     = "traffic-port"
}

variable "healthy_threshold" {
  description = "Número de checks consecutivos para considerar saudável"
  type        = number
  default     = 5
}

variable "unhealthy_threshold" {
  description = "Número de falhas para considerar como unhealthy"
  type        = number
  default     = 2
}

variable "health_check_timeout" {
  description = "Timeout em segundos para health check"
  type        = number
  default     = 5
}

variable "health_check_interval" {
  description = "Intervalo entre checks"
  type        = number
  default     = 30
}

variable "health_check_matcher" {
  description = "Código esperado para considerar saudável"
  type        = string
  default     = "200"
}

variable "tags_target_group" {
  description = "Tags do target group"
  type        = map(string)
}

variable "alb_listener_port" {
  description = "Porta do listener ALB"
  type        = number
  default     = 80
}

variable "alb_listener_protocol" {
  description = "Protocolo do listener (HTTP, HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "alb_listener_ssl_policy" {
  description = "Política SSL (ex: ELBSecurityPolicy-TLS13-1-2-2021-06)"
  type        = string
  default     = ""
}

variable "alb_listener_certificate_arn" {
  description = "ARN do certificado ACM"
  type        = string
  default     = ""
}

variable "tags_alb_listener" {
  description = "Tags do listener ALB"
  type        = map(string)
  default     = {}
}

variable "name_sg_alb" {
  description = "Nome do Security Group do ALB"
  type        = string
}

variable "description_sg_alb" {
  description = "Descrição do Security Group do ALB"
  type        = string
}

variable "tags_sg_alb" {
  description = "Tags do Security Group do ALB"
  type        = map(string)
}

#######################################################################################################################
# S3 ##################################################################################################################
# ---------------------------------------------------------------------------------------------------------------------

variable "s3_bucket_name" {
  description = "Nome do bucket S3"
  type        = string
}

variable "s3_environment" {
  description = "Ambiente do bucket (ex: dev, prod)"
  type        = string
}

variable "s3_enable_versioning" {
  description = "Habilita versionamento no bucket"
  type        = bool
  default     = false
}

variable "s3_enable_encryption" {
  description = "Habilita criptografia no bucket"
  type        = bool
  default     = true
}

variable "s3_bucket_policy_json" {
  description = "Política do bucket em JSON"
  type        = string
  default     = null
}

variable "tags_s3" {
  description = "Tags do bucket S3"
  type        = map(string)
}

#######################################################################################################################
# CloudFront ##########################################################################################################
# ---------------------------------------------------------------------------------------------------------------------

variable "cloudfront_oai_comment" {
  description = "Comentário da Origin Access Identity"
  type        = string
  default     = "CloudFront Origin Access Identity"
}

variable "tags_cloudfront_oai" {
  description = "Tags da Origin Access Identity"
  type        = map(string)
  default     = {}
}

variable "cloudfront_comment" {
  description = "Comentário da distribuição CloudFront"
  type        = string
  default     = ""
}

variable "cloudfront_default_root_object" {
  description = "Objeto raiz padrão"
  type        = string
  default     = "index.html"
}

variable "cloudfront_price_class" {
  description = "Classe de preço (PriceClass_All, PriceClass_200, PriceClass_100)"
  type        = string
  default     = "PriceClass_All"
}

variable "cloudfront_aliases" {
  description = "Lista de aliases (domínios)"
  type        = list(string)
  default     = []
}

variable "cloudfront_origin_id" {
  description = "ID da origem"
  type        = string
}

variable "cloudfront_allowed_methods" {
  description = "Métodos HTTP permitidos"
  type        = list(string)
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "cloudfront_cached_methods" {
  description = "Métodos HTTP em cache"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "cloudfront_cache_policy_id" {
  description = "ID da política de cache"
  type        = string
  default     = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # Managed-CachingOptimized
}

variable "cloudfront_origin_request_policy_id" {
  description = "ID da política de requisição de origem"
  type        = string
  default     = null
}

variable "cloudfront_response_headers_policy_id" {
  description = "ID da política de headers de resposta"
  type        = string
  default     = null
}

variable "cloudfront_viewer_protocol_policy" {
  description = "Política de protocolo do viewer (allow-all, https-only, redirect-to-https)"
  type        = string
  default     = "redirect-to-https"
}

variable "cloudfront_function_arn" {
  description = "ARN da função CloudFront"
  type        = string
  default     = null
}

variable "cloudfront_ordered_behaviors" {
  description = "Lista de comportamentos ordenados"
  type        = list(any)
  default     = []
}

variable "cloudfront_custom_error_responses" {
  description = "Lista de respostas de erro customizadas"
  type        = list(any)
  default     = []
}

variable "cloudfront_restriction_type" {
  description = "Tipo de restrição geográfica (none, whitelist, blacklist)"
  type        = string
  default     = "none"
}

variable "cloudfront_restriction_locations" {
  description = "Lista de localizações para restrição"
  type        = list(string)
  default     = []
}

variable "cloudfront_acm_certificate_arn" {
  description = "ARN do certificado ACM"
  type        = string
  default     = ""
}

variable "cloudfront_minimum_protocol_version" {
  description = "Versão mínima do protocolo TLS"
  type        = string
  default     = "TLSv1.2_2021"
}

variable "cloudfront_ssl_support_method" {
  description = "Método de suporte SSL (sni-only, vip)"
  type        = string
  default     = "sni-only"
}