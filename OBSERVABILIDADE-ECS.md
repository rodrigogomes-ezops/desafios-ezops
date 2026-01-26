# Observabilidade no ECS - Prometheus + Grafana

## ✅ Implementação Completa

Foi criada uma infraestrutura completa para rodar Prometheus e Grafana no ECS, seguindo o mesmo padrão do backend.

## 📁 Arquivos Criados

### Terraform
- `terraform/observability.tf` - Infraestrutura completa (Prometheus, Grafana, EFS, ALB, Security Groups)
- `terraform/observability.auto.tfvars` - Variáveis de configuração
- `terraform/outputs-observability.tf` - Outputs (endpoints, EFS IDs)
- `terraform/variables.tf` - Adicionada variável `grafana_admin_password`

### Configuração
- `monitoring/prometheus/prometheus.yml` - Configuração do Prometheus
- `monitoring/README-ECS.md` - Documentação completa

## 🏗️ Arquitetura

```
┌─────────────────┐
│   ALB Público   │ (Backend - já existente)
└────────┬────────┘
         │
    ┌────▼────┐
    │ Backend │ (ECS Service)
    │  :3000  │
    └────┬────┘
         │ /api/metrics
         │
┌────────▼────────┐
│  ALB Interno    │ (Observabilidade - NOVO)
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
┌───▼───┐ ┌──▼────┐
│Prometh│ │Grafana│ (ECS Services - NOVOS)
│:9090  │ │ :3000 │
└───────┘ └───────┘
    │         │
    └────┬────┘
         │
    ┌────▼────┐
    │   EFS   │ (Persistência - NOVO)
    └─────────┘
```

## 🚀 Como Deployar

### 1. Configurar Variáveis

Edite `terraform/observability.auto.tfvars`:
```hcl
grafana_admin_password = "sua-senha-segura-aqui"
```

**IMPORTANTE**: Em produção, use AWS Secrets Manager ou Parameter Store!

### 2. Aplicar Terraform

```bash
cd terraform
terraform init
terraform plan  # Revisar mudanças
terraform apply
```

### 3. Verificar Deploy

```bash
# Verificar services
aws ecs list-services --cluster rodrigo-ecs-cluster

# Verificar tasks
aws ecs list-tasks --cluster rodrigo-ecs-cluster --service-name prometheus-service
aws ecs list-tasks --cluster rodrigo-ecs-cluster --service-name grafana-service

# Ver logs
aws logs tail /ecs/prometheus --follow
aws logs tail /ecs/grafana --follow
```

### 4. Obter Endpoints

```bash
terraform output prometheus_endpoint
terraform output grafana_endpoint
```

## 🔐 Acesso

### Prometheus
- **URL**: `http://<alb-interno-dns>:9090`
- **Acesso**: Via VPN, bastion host, ou adicionar regra no Security Group para seu IP

### Grafana
- **URL**: `http://<alb-interno-dns>:3000`
- **Usuário**: `admin`
- **Senha**: Definida em `observability.auto.tfvars`

## 📊 Configuração

### Prometheus

O Prometheus está configurado para coletar métricas de:
1. **Próprio Prometheus**: `localhost:9090`
2. **Backend**: Via ALB público em `http://<alb-publico>/api/metrics`

A configuração é criada dinamicamente no container usando o endpoint do ALB do backend.

### Grafana

Após o primeiro acesso:
1. Adicione o Prometheus como datasource:
   - URL: `http://<alb-interno-dns>:9090`
2. Importe dashboards ou crie os seus

## 🔧 Recursos Criados

### ECS
- ✅ Task Definition: `prometheus-task`
- ✅ Service: `prometheus-service`
- ✅ Task Definition: `grafana-task`
- ✅ Service: `grafana-service`

### Networking
- ✅ Security Group: `RODRIGO-SG-OBSERVABILITY`
- ✅ ALB Interno: `rodrigo-alb-observability`
- ✅ Target Groups: Prometheus (9090) e Grafana (3000)
- ✅ Listeners: HTTP para ambos

### Storage
- ✅ EFS: `prometheus-data` (dados do Prometheus)
- ✅ EFS: `grafana-data` (dados do Grafana)

### Logging
- ✅ CloudWatch Log Group: `/ecs/prometheus`
- ✅ CloudWatch Log Group: `/ecs/grafana`

## ⚠️ Importante

1. **Backend precisa expor `/api/metrics`**: Certifique-se de que o backend está expondo métricas Prometheus em `/api/metrics`

2. **Acesso ao ALB Interno**: O ALB é interno, então você precisa:
   - Conectar via VPN
   - Usar um bastion host
   - Adicionar regra no Security Group para seu IP
   - Ou criar um ALB público (não recomendado para produção)

3. **Senha do Grafana**: Altere a senha padrão em produção!

4. **EFS**: Os dados são persistidos em EFS, então são mantidos mesmo se os containers forem recriados

## 📚 Próximos Passos

1. **Alertmanager**: Adicionar Alertmanager para gerenciar alertas
2. **Service Discovery**: Usar ECS Service Discovery para descobrir targets automaticamente
3. **Autenticação**: Adicionar autenticação no ALB (OIDC, etc)
4. **HTTPS**: Configurar certificado ACM para HTTPS
5. **Dashboards**: Criar dashboards customizados para suas métricas

## 🔗 Documentação

Consulte `monitoring/README-ECS.md` para documentação detalhada sobre:
- Troubleshooting
- Manutenção
- Escalamento
- Backup

---

**Implementação concluída! 🎉**

Prometheus e Grafana estão prontos para rodar no ECS seguindo o mesmo padrão do seu backend.
