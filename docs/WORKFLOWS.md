# 📋 Documentação dos Workflows GitHub Actions

Este documento explica o que cada workflow faz e quando é executado.

## 🔄 Workflows Disponíveis

### 1. `infra.yml` - Infraestrutura (Terraform)

**O que faz:**
- Aplica mudanças na infraestrutura AWS usando Terraform
- Cria/atualiza recursos: VPC, ECS, RDS, ALB, S3, CloudFront, etc.

**Quando executa:**
- Push na branch `main` quando há mudanças em `terraform/**`
- Execução manual (`workflow_dispatch`)

**Passos:**
1. Checkout do código
2. Setup Terraform
3. Configura credenciais AWS
4. `terraform init`
5. `terraform validate`
6. `terraform apply -auto-approve`

**Secrets necessários:**
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `DB_PASSWORD`

---

### 2. `backend-deploy.yml` - Deploy do Backend

**O que faz:**
- Faz build da imagem Docker do backend
- Faz push da imagem para o Amazon ECR
- Faz deploy no ECS (atualiza o serviço)

**Quando executa:**
- Push na branch `main` quando há mudanças em `backend/**`
- Após conclusão bem-sucedida do workflow `infra.yml`
- Execução manual (`workflow_dispatch`)

**Passos:**
1. Checkout do código
2. Configura credenciais AWS
3. Lê outputs do Terraform (nome do cluster ECS e serviço)
4. Setup Node.js 20
5. Instala dependências (`npm ci`)
6. Login no Amazon ECR
7. Build da imagem Docker
8. Push da imagem para ECR (com tag `github.sha` e `latest`)
9. Atualiza o serviço ECS (`force-new-deployment`)

**Secrets necessários:**
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `ECR_REPOSITORY` (nome do repositório ECR)

**Outputs do Terraform usados:**
- `ecs_cluster_name`
- `ecs_service_name`

---

### 3. `frontend-deploy.yml` - Deploy do Frontend

**O que faz:**
- Faz build do frontend (React/Vite)
- Faz upload dos arquivos estáticos para o S3
- (Opcional) Invalida cache do CloudFront

**Quando executa:**
- Push na branch `main` quando há mudanças em `frontend/**`
- Após conclusão bem-sucedida do workflow `infra.yml`
- Execução manual (`workflow_dispatch`)

**Passos:**
1. Checkout do código
2. Configura credenciais AWS
3. Lê outputs do Terraform (nome do bucket S3)
4. Instala dependências (`npm ci`)
5. Build do frontend (`npm run build`)
6. Sincroniza arquivos do `frontend/dist` para o S3 (`--delete` remove arquivos antigos)
7. (Opcional) Invalida cache do CloudFront

**Secrets necessários:**
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

**Outputs do Terraform usados:**
- `s3_frontend_bucket`

---

### 4. `destroy.yml` - Destruir Infraestrutura

**O que faz:**
- Destrói toda a infraestrutura criada pelo Terraform
- **CUIDADO**: Remove todos os recursos AWS!

**Quando executa:**
- Apenas execução manual (`workflow_dispatch`)

**Passos:**
1. Checkout do código
2. Setup Terraform
3. Configura credenciais AWS
4. `terraform init`
5. `terraform destroy -auto-approve`

**Secrets necessários:**
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`
- `DB_PASSWORD`

---

## 🔗 Fluxo de Execução

### Cenário 1: Mudança na Infraestrutura
```
Push em terraform/** 
  ↓
infra.yml executa
  ↓
Se sucesso → backend-deploy.yml e frontend-deploy.yml executam
```

### Cenário 2: Mudança no Backend
```
Push em backend/**
  ↓
backend-deploy.yml executa
  ↓
Build Docker → Push ECR → Deploy ECS
```

### Cenário 3: Mudança no Frontend
```
Push em frontend/**
  ↓
frontend-deploy.yml executa
  ↓
Build React → Upload S3
```

### Cenário 4: Mudança em Múltiplos Locais
```
Push em backend/** e frontend/**
  ↓
backend-deploy.yml e frontend-deploy.yml executam em paralelo
```

---

## ⚙️ Configuração

### Secrets do GitHub

Configure os seguintes secrets no GitHub (Settings > Secrets and variables > Actions):

1. **AWS_ACCESS_KEY_ID** - Access Key da AWS
2. **AWS_SECRET_ACCESS_KEY** - Secret Key da AWS
3. **AWS_REGION** - Região AWS (ex: `us-east-2`)
4. **DB_PASSWORD** - Senha do banco de dados PostgreSQL
5. **ECR_REPOSITORY** - Nome do repositório ECR (ex: `backend-app-organizer`)

### Paths Filters

Os workflows usam `paths` para executar apenas quando há mudanças relevantes:

- **infra.yml**: `terraform/**`
- **backend-deploy.yml**: `backend/**`
- **frontend-deploy.yml**: `frontend/**`

Isso evita execuções desnecessárias quando você muda apenas documentação, por exemplo.

---

## 🚀 Execução Manual

Todos os workflows de deploy suportam execução manual:

1. Vá em **Actions** no GitHub
2. Selecione o workflow desejado
3. Clique em **Run workflow**
4. Selecione a branch
5. Clique em **Run workflow**

---

## 📊 Monitoramento

Você pode monitorar os workflows em:
- **GitHub Actions** > Ver histórico de execuções
- **CloudWatch Logs** (se configurado)
- **ECS Console** - Ver status dos serviços
- **S3 Console** - Ver arquivos do frontend

---

## 🔧 Troubleshooting

### Workflow não executa
- Verifique se os paths estão corretos
- Verifique se está na branch `main`
- Verifique se os secrets estão configurados

### Deploy falha
- Verifique os logs do workflow
- Verifique se a infraestrutura existe (rode `infra.yml` primeiro)
- Verifique se os outputs do Terraform estão corretos

### Backend não atualiza
- Verifique se a imagem foi pushada para o ECR
- Verifique os logs do ECS
- Verifique se o serviço ECS está rodando

### Frontend não atualiza
- Verifique se os arquivos foram enviados para o S3
- Verifique o cache do CloudFront (pode precisar invalidar)
- Aguarde alguns minutos para o CloudFront propagar

---

## 📚 Referências

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [AWS ECR Actions](https://github.com/aws-actions/amazon-ecr-login)
- [Terraform Actions](https://github.com/hashicorp/setup-terraform)
