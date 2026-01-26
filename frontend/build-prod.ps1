 # Script PowerShell para build e deploy do frontend para produção

Write-Host "🚀 Building frontend for production..." -ForegroundColor Cyan

# 1. Obter URL do backend do Terraform
Push-Location ..\..\terraform
$BACKEND_URL = terraform output -raw cloudfront_backend_url 2>$null

if ([string]::IsNullOrEmpty($BACKEND_URL)) {
    Write-Host "❌ Erro: Não foi possível obter a URL do backend do Terraform" -ForegroundColor Red
    Write-Host "💡 Dica: Execute 'terraform apply' primeiro ou forneça a URL manualmente:" -ForegroundColor Yellow
    Write-Host "   `$env:VITE_API_URL='https://seu-cloudfront-url.cloudfront.net'" -ForegroundColor Yellow
    Pop-Location
    exit 1
}

Write-Host "✅ Backend URL: $BACKEND_URL" -ForegroundColor Green
Pop-Location

# 2. Voltar para o diretório do frontend
Push-Location .

# 3. Build com a URL do backend (SEM Docker, direto com npm)
Write-Host "📦 Building with VITE_API_URL=$BACKEND_URL" -ForegroundColor Cyan
$env:VITE_API_URL = $BACKEND_URL
npm run build

# 4. Upload para S3
Write-Host "☁️ Uploading to S3..." -ForegroundColor Cyan
Push-Location ..\..\terraform
$BUCKET_NAME = terraform output -raw s3_bucket_name 2>$null
if ([string]::IsNullOrEmpty($BUCKET_NAME)) {
    $BUCKET_NAME = "rodrigo-ezops-frontend-bucket"
}
Pop-Location

aws s3 sync dist/ "s3://$BUCKET_NAME" --delete

Write-Host "✅ Build e deploy concluídos!" -ForegroundColor Green
Push-Location ..\..\terraform
$FRONTEND_URL = terraform output -raw cloudfront_frontend_url 2>$null
Write-Host "🌐 Frontend disponível em: $FRONTEND_URL" -ForegroundColor Green
Pop-Location

Pop-Location

