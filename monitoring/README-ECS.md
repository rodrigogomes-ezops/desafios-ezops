# Observabilidade no ECS - Prometheus + Grafana

Este documento descreve a configuração de Prometheus e Grafana rodando no ECS na AWS.

## 📋 Arquitetura

```
┌─────────────────┐
│   ALB Público   │ (Backend)
└────────┬────────┘
         │
    ┌────▼────┐
    │ Backend │ (ECS Service)
    │  :3000  │
    └────┬────┘
         │ /metrics
         │
┌────────▼────────┐
│  ALB Interno    │ (Observabilidade)
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
┌───▼───┐ ┌──▼────┐
│Prometh│ │Grafana│ (ECS Services)
│:9090  │ │ :3000 │
└───────┘ └───────┘
    │         │
    └────┬────┘
         │
    ┌────▼────┐
    │   EFS   │ (Persistência)
    └─────────┘
```

## 🚀 Deploy

### 1. Aplicar Terraform

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 2. Verificar Deploy

```bash
# Verificar services
aws ecs list-services --cluster rodrigo-ecs-cluster

# Verificar tasks
aws ecs list-tasks --cluster rodrigo-ecs-cluster --service-name prometheus-service
aws ecs list-tasks --cluster rodrigo-ecs-cluster --service-name grafana-service
```

### 3. Obter Endpoints

```bash
# Obter DNS do ALB interno
terraform output prometheus_endpoint
terraform output grafana_endpoint
```

## 🔐 Acesso

### Prometheus
- **URL Interna**: `http://<alb-interno-dns>:9090`
- **Acesso**: Via VPN, bastion host, ou adicionar regra no Security Group

### Grafana
- **URL Interna**: `http://<alb-interno-dns>:3000`
- **Usuário**: `admin`
- **Senha**: Definida em `observability.auto.tfvars` (ou via secrets)

## 📊 Configuração do Prometheus

O Prometheus está configurado para coletar métricas de:

1. **Backend**: Via ALB público na rota `/api/metrics`
2. **Próprio Prometheus**: `localhost:9090`

### Adicionar Novos Targets

Edite `monitoring/prometheus/prometheus.yml` e adicione novos `scrape_configs`.

## 🎨 Configuração do Grafana

### 1. Primeiro Acesso

1. Acesse o endpoint do Grafana
2. Login: `admin` / senha configurada
3. Altere a senha quando solicitado

### 2. Adicionar Datasource Prometheus

1. Vá em **Configuration** > **Data Sources**
2. Clique em **Add data source**
3. Selecione **Prometheus**
4. URL: `http://<alb-interno-dns>:9090`
5. Clique em **Save & Test**

### 3. Importar Dashboards

1. Vá em **Dashboards** > **Import**
2. Use IDs de dashboards populares:
   - **1860**: Node Exporter Full
   - **6417**: Docker Container & Host Metrics
   - Ou crie seus próprios dashboards

## 🔧 Manutenção

### Atualizar Configuração do Prometheus

1. Edite `monitoring/prometheus/prometheus.yml`
2. Reaplique o Terraform (se usar S3) ou recrie a task definition

### Backup de Dados

Os dados são persistidos em EFS:
- **Prometheus**: `/prometheus` (retention: 15 dias)
- **Grafana**: `/var/lib/grafana` (dashboards, datasources, etc)

### Escalar Serviços

```bash
# Escalar Prometheus
aws ecs update-service \
  --cluster rodrigo-ecs-cluster \
  --service prometheus-service \
  --desired-count 2

# Escalar Grafana (geralmente 1 é suficiente)
aws ecs update-service \
  --cluster rodrigo-ecs-cluster \
  --service grafana-service \
  --desired-count 1
```

## 🚨 Troubleshooting

### Prometheus não coleta métricas

1. Verifique se o backend está expondo `/api/metrics`:
   ```bash
   curl http://<alb-publico>/api/metrics
   ```

2. Verifique logs do Prometheus:
   ```bash
   aws logs tail /ecs/prometheus --follow
   ```

3. Verifique configuração:
   ```bash
   aws ecs describe-tasks \
     --cluster rodrigo-ecs-cluster \
     --tasks <task-id> \
     --query 'tasks[0].containers[0].environment'
   ```

### Grafana não conecta ao Prometheus

1. Verifique se o Prometheus está acessível:
   ```bash
   curl http://<alb-interno>:9090/-/healthy
   ```

2. Verifique Security Groups (Grafana precisa acessar Prometheus na porta 9090)

3. Verifique logs:
   ```bash
   aws logs tail /ecs/grafana --follow
   ```

### Serviços não iniciam

1. Verifique task definition:
   ```bash
   aws ecs describe-task-definition --task-definition prometheus-task
   ```

2. Verifique EFS mount points:
   ```bash
   aws efs describe-file-systems
   ```

3. Verifique CloudWatch Logs para erros

## 📚 Próximos Passos

1. **Alertmanager**: Adicionar Alertmanager para gerenciar alertas
2. **Service Discovery**: Usar ECS Service Discovery para descobrir targets automaticamente
3. **Autenticação**: Adicionar autenticação no ALB interno (OIDC, etc)
4. **HTTPS**: Configurar certificado ACM para HTTPS
5. **Backup**: Configurar backup automático dos dados do EFS

## 🔗 Referências

- [Prometheus on ECS](https://prometheus.io/docs/guides/ecs/)
- [Grafana on ECS](https://grafana.com/docs/grafana/latest/setup-grafana/installation/aws/)
- [EFS with ECS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/efs-volumes.html)
