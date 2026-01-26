# Troubleshooting EFS no ECS

## Problema: ResourceInitializationError - Failed to resolve EFS DNS

### Causa
O EFS não consegue resolver o DNS do mount target. Isso geralmente acontece quando:
1. DNS não está habilitado na VPC
2. Mount targets não estão nas subnets corretas
3. Security Groups não permitem tráfego NFS

### Solução Aplicada

#### 1. Habilitar DNS na VPC
```hcl
resource "aws_vpc" "this" {
  enable_dns_hostnames = true
  enable_dns_support   = true
}
```

#### 2. Criar Access Points
Access Points facilitam o acesso ao EFS e resolvem problemas de permissões:
- Prometheus: Access Point com UID/GID 0 (root)
- Grafana: Access Point com UID/GID 472 (usuário padrão do Grafana)

#### 3. Security Groups Corretos
- EFS Security Group: Permite NFS (porta 2049) do Security Group de Observabilidade
- Observabilidade Security Group: Permite egress para qualquer lugar

### Verificações

#### 1. Verificar se DNS está habilitado
```bash
aws ec2 describe-vpcs --vpc-ids <vpc-id> --query 'Vpcs[0].{DNSHostnames:EnableDnsHostnames,DNSSupport:EnableDnsSupport}'
```

Deve retornar:
```json
{
  "DNSHostnames": true,
  "DNSSupport": true
}
```

#### 2. Verificar Mount Targets
```bash
aws efs describe-mount-targets --file-system-id <efs-id>
```

Deve mostrar mount targets em todas as subnets privadas.

#### 3. Verificar Security Groups
```bash
# Verificar regras do Security Group do EFS
aws ec2 describe-security-groups --group-ids <sg-efs-id>

# Verificar se permite NFS (porta 2049) do Security Group de Observabilidade
```

### Se o Problema Persistir

#### Opção 1: Desabilitar Transit Encryption (temporário)
Se o problema persistir, você pode desabilitar transit encryption temporariamente:

```hcl
transit_encryption = "DISABLED"
```

**Nota**: Não recomendado para produção, mas pode ajudar a identificar o problema.

#### Opção 2: Usar IP Direto (não recomendado)
Em vez de DNS, você pode usar o IP do mount target diretamente, mas isso não é escalável.

#### Opção 3: Verificar VPC Endpoints
Se estiver usando VPC Endpoints, verifique se estão configurados corretamente.

### Logs Úteis

Verifique os logs do ECS para mais detalhes:
```bash
aws logs tail /ecs/prometheus --follow
aws logs tail /ecs/grafana --follow
```

### Referências
- [EFS com ECS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/efs-volumes.html)
- [EFS Access Points](https://docs.aws.amazon.com/efs/latest/ug/efs-access-points.html)
- [VPC DNS](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html)
