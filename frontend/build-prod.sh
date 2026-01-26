#!/bin/bash
# Script para build e deploy do frontend para produção

set -e  # Para se houver erro, para o script

echo "🚀 Building frontend for production..."

# 1. Obter URL do backend do Terraform
cd ../../terraform
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

# 3. Build com a URL do backend (SEM Docker, direto com npm)
echo "📦 Building with VITE_API_URL=$BACKEND_URL"
VITE_API_URL=$BACKEND_URL npm run build

# 4. Upload para S3
echo "☁️ Uploading to S3..."
BUCKET_NAME=$(cd ../../terraform && terraform output -raw s3_bucket_name 2>/dev/null || echo "rodrigo-ezops-frontend-bucket")
aws s3 sync dist/ s3://$BUCKET_NAME --delete

echo "✅ Build e deploy concluídos!"
echo "🌐 Frontend disponível em: $(cd ../../terraform && terraform output -raw cloudfront_frontend_url)"

