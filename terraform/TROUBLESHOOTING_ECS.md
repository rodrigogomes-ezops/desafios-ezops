# Guia de Troubleshooting - ECS Tasks Não Estão Rodando

## Problemas Comuns e Soluções

### 1. Verificar Status das Tasks no Console AWS

1. Acesse o **ECS Console** → **Clusters** → `rodrigo-ecs-cluster`
2. Clique em **Services** → `rodrigo-backend-service`
3. Vá na aba **Tasks** e verifique o status
4. Clique em uma task para ver os **detalhes** e **logs**

### 2. Verificar Logs do CloudWatch

```bash
# Ver logs do ECS
aws logs tail /ecs/rodrigo-backend --follow --region us-east-2
```

**Problema comum**: Se o log group não existir, a task falhará ao iniciar.

**Solução**: O arquivo `cloudwatch-logs.tf` foi criado para criar o log group automaticamente.

### 3. Verificar Eventos do Service

No console ECS, na aba **Events** do service, você verá mensagens como:
- `service rodrigo-backend-service has reached a steady state`
- `(service rodrigo-backend-service) has started 1 tasks`
- Erros específicos (ex: "CannotPullContainerError", "ResourceInitializationError")

### 4. Problemas Comuns

#### A) Imagem Docker Não Encontrada
**Erro**: `CannotPullContainerError: Error response from daemon: pull access denied`

**Soluções**:
- Verifique se a imagem existe no ECR: `aws ecr describe-images --repository-name backend-app-organizer --region us-east-2`
- Verifique se a tag está correta (adicione `:latest` ou tag específica)
- Verifique se a IAM role `ecsTaskExecutionRole` tem permissão para fazer pull do ECR

#### B) Task Para Imediatamente
**Erro**: Task status: STOPPED

**Verifique**:
- Logs do CloudWatch para ver o erro exato
- Se o container está crashando (verifique exit code)
- Se há variáveis de ambiente faltando
- Se o endpoint do RDS está correto

#### C) Health Check Falhando
**Erro**: Tasks ficam em estado `RUNNING` mas são substituídas

**Soluções**:
- Verifique se o path do health check está correto (`/health`)
- Verifique se a aplicação está respondendo na porta 3000
- Aumente o `health_check_grace_period_seconds` se necessário
- Verifique se o Security Group do ALB pode acessar o ECS na porta 3000

#### D) Problemas de Rede
**Erro**: Tasks não conseguem se conectar ao RDS ou internet

**Verifique**:
- Security Groups: ECS precisa de egress para internet e acesso ao RDS
- Subnets: Tasks precisam estar em subnets públicas (ou com NAT Gateway)
- `assign_public_ip = true` está configurado

#### E) Permissões IAM
**Erro**: `AccessDenied` nos logs

**Verifique**:
- A role `ecsTaskExecutionRole` precisa ter:
  - `AmazonECSTaskExecutionRolePolicy`
  - Permissão para fazer pull do ECR
  - Permissão para escrever logs no CloudWatch

### 5. Comandos Úteis para Debug

```bash
# Listar tasks do service
aws ecs list-tasks --cluster rodrigo-ecs-cluster --service-name rodrigo-backend-service --region us-east-2

# Descrever uma task específica
aws ecs describe-tasks --cluster rodrigo-ecs-cluster --tasks <TASK_ARN> --region us-east-2

# Ver eventos do service
aws ecs describe-services --cluster rodrigo-ecs-cluster --services rodrigo-backend-service --region us-east-2

# Ver logs do CloudWatch
aws logs tail /ecs/rodrigo-backend --follow --region us-east-2

# Verificar se a imagem existe no ECR
aws ecr describe-images --repository-name backend-app-organizer --region us-east-2
```

### 6. Correções Aplicadas

✅ **CloudWatch Log Group**: Criado automaticamente via `cloudwatch-logs.tf`
✅ **Security Group ECS**: Agora permite tráfego apenas do ALB (mais seguro)
✅ **Task Role**: Corrigido para `null` (não usar service role)
✅ **Imagem Docker**: Adicionada tag `:latest` (ajuste conforme necessário)

### 7. Próximos Passos

1. **Atualize o endpoint do RDS** em `ecs.auto.tfvars`:
   - Execute: `terraform output` para ver o endpoint do RDS
   - Ou pegue do console AWS: RDS → Databases → `rds-organizer` → Endpoint

2. **Verifique se a imagem Docker existe**:
   ```bash
   aws ecr describe-images --repository-name backend-app-organizer --region us-east-2
   ```

3. **Aplique as mudanças**:
   ```bash
   terraform apply
   ```

4. **Monitore os logs**:
   ```bash
   aws logs tail /ecs/rodrigo-backend --follow --region us-east-2
   ```

