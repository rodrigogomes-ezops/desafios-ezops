# Como Passar VITE_API_URL no Build - Exemplos Práticos

## Como Funciona

O `ARG` no Dockerfile permite passar valores **no momento do build**. Esses valores são "embutidos" no código JavaScript durante o `npm run build`.

## Exemplos Práticos

### 1. Build Local (Desenvolvimento)

```bash
cd app-organizer/frontend

# Build com URL local
docker build --build-arg VITE_API_URL=http://localhost:3000 -t frontend-app-organizer .

# Ou usando variável de ambiente
export API_URL=http://localhost:3000
docker build --build-arg VITE_API_URL=$API_URL -t frontend-app-organizer .
```

**Resultado**: O código JavaScript gerado terá `baseURL = 'http://localhost:3000'`

### 2. Build para Produção (AWS CloudFront)

```bash
cd app-organizer/frontend

# Primeiro, obtenha a URL do CloudFront do backend
# Opção A: Do Terraform
BACKEND_URL=$(cd ../../terraform && terraform output -raw cloudfront_backend_url)
echo "Backend URL: $BACKEND_URL"
# Exemplo: https://d1234567890abc.cloudfront.net

# Opção B: Manualmente (se você já sabe a URL)
BACKEND_URL="https://d1234567890abc.cloudfront.net"

# Build com a URL do CloudFront
docker build --build-arg VITE_API_URL=$BACKEND_URL -t frontend-app-organizer .
```

**Resultado**: O código JavaScript gerado terá `baseURL = 'https://d1234567890abc.cloudfront.net'`

### 3. Build SEM Docker (Direto com npm)

```bash
cd app-organizer/frontend

# Para desenvolvimento
VITE_API_URL=http://localhost:3000 npm run build

# Para produção
VITE_API_URL=https://d1234567890abc.cloudfront.net npm run build

# Depois, upload para S3
aws s3 sync dist/ s3://rodrigo-ezops-frontend-bucket --delete
```

### 4. Script Automatizado Completo

Crie um arquivo `build-prod.sh`:

```bash
#!/bin/bash
# build-prod.sh

set -e

echo "🚀 Building frontend for production..."

# 1. Obter URL do backend do Terraform
cd ../terraform
BACKEND_URL=$(terraform output -raw cloudfront_backend_url 2>/dev/null || echo "")

if [ -z "$BACKEND_URL" ]; then
    echo "❌ Erro: Não foi possível obter a URL do backend do Terraform"
    echo "💡 Dica: Execute 'terraform apply' primeiro ou forneça a URL manualmente:"
    echo "   export VITE_API_URL=https://seu-cloudfront-url.cloudfront.net"
    exit 1
fi

echo "✅ Backend URL: $BACKEND_URL"

# 2. Voltar para o diretório do frontend
cd ../app-organizer/frontend

# 3. Build com a URL do backend
echo "📦 Building with VITE_API_URL=$BACKEND_URL"
docker build --build-arg VITE_API_URL=$BACKEND_URL -t frontend-app-organizer .

# 4. Extrair arquivos do container (opcional)
echo "📤 Extracting build files..."
docker run --rm -v $(pwd)/dist:/output frontend-app-organizer sh -c "cp -r /usr/share/nginx/html/* /output/"

# 5. Upload para S3
echo "☁️ Uploading to S3..."
BUCKET_NAME=$(cd ../../terraform && terraform output -raw s3_bucket_name 2>/dev/null || echo "rodrigo-ezops-frontend-bucket")
aws s3 sync dist/ s3://$BUCKET_NAME --delete

echo "✅ Build e deploy concluídos!"
echo "🌐 Frontend disponível em: $(cd ../../terraform && terraform output -raw cloudfront_frontend_url)"
```

**Uso:**
```bash
chmod +x build-prod.sh
./build-prod.sh
```

### 5. Usando Docker Compose (Desenvolvimento)

Crie um `docker-compose.dev.yml`:

```yaml
services:
  frontend:
    build:
      context: ./frontend
      args:
        VITE_API_URL: http://localhost:3000
    ports:
      - "8080:80"
```

**Uso:**
```bash
docker-compose -f docker-compose.dev.yml up --build
```

## Como Verificar se Funcionou

### 1. Inspecionar o Build

```bash
# Build com uma URL de teste
docker build --build-arg VITE_API_URL=https://teste.com -t frontend-test .

# Executar o container e verificar
docker run --rm frontend-test cat /usr/share/nginx/html/assets/index-*.js | grep -o "teste.com"
```

### 2. Verificar no Código Gerado

```bash
# Após o build, verifique o arquivo gerado
cat dist/assets/index-*.js | grep -i "baseURL\|api"
```

Você deve ver algo como:
```javascript
const baseURL = "https://d1234567890abc.cloudfront.net"
```

## Fluxo Completo: Desenvolvimento → Produção

### Desenvolvimento Local

```bash
# Terminal 1: Backend
cd app-organizer/backend
npm run dev  # Roda em http://localhost:3000

# Terminal 2: Frontend
cd app-organizer/frontend
VITE_API_URL=http://localhost:3000 npm run dev
# Ou
docker build --build-arg VITE_API_URL=http://localhost:3000 -t frontend .
docker run -p 8080:80 frontend
```

### Produção AWS

```bash
# 1. Aplicar Terraform (se ainda não fez)
cd terraform
terraform apply

# 2. Obter URL do backend
BACKEND_URL=$(terraform output -raw cloudfront_backend_url)

# 3. Build do frontend
cd ../app-organizer/frontend
VITE_API_URL=$BACKEND_URL npm run build

# 4. Upload para S3
aws s3 sync dist/ s3://rodrigo-ezops-frontend-bucket --delete

# 5. Invalidar cache do CloudFront (opcional)
aws cloudfront create-invalidation --distribution-id <DIST_ID> --paths "/*"
```

## Por Que Isso é Melhor?

### ❌ Antes (Hardcoded)
```dockerfile
ARG VITE_API_URL=http://18.117.128.92:3000  # IP fixo - não funciona em produção
```

**Problemas:**
- IP pode mudar
- Não funciona em diferentes ambientes
- Precisa editar Dockerfile toda vez

### ✅ Agora (Flexível)
```dockerfile
ARG VITE_API_URL  # Sem valor padrão - deve ser passado no build
ENV VITE_API_URL=$VITE_API_URL
```

**Vantagens:**
- ✅ Funciona para qualquer ambiente
- ✅ Não precisa editar Dockerfile
- ✅ Pode usar variáveis de ambiente
- ✅ Pode automatizar com scripts

## Dica: Variáveis de Ambiente vs ARG

- **ARG**: Usado no **build time** (quando roda `docker build`)
- **ENV**: Usado no **runtime** (quando roda `docker run`)

Para Vite, precisamos de **ARG** porque o Vite "embute" as variáveis `VITE_*` no código JavaScript durante o build. Variáveis de ambiente em runtime não funcionam para Vite.

