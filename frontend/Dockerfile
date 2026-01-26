# frontend/Dockerfile
# Multi-stage build para otimizar tamanho da imagem

# Estágio 1: Build (Construção)
FROM node:20-alpine AS build

WORKDIR /app

# Copia arquivos de dependência
COPY package*.json ./
RUN npm ci

# Copia o código
COPY . .

# Argumento de build para a URL da API (deve ser passado no build time)
# Para desenvolvimento local: --build-arg VITE_API_URL=http://localhost:3000
# Para produção AWS: --build-arg VITE_API_URL=https://<cloudfront-backend-url>.cloudfront.net
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL

# Build da aplicação
RUN npm run build

# Estágio 2: Servidor (Nginx)
FROM nginx:alpine

# Copia os arquivos gerados no estágio anterior para a pasta do Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Configuração necessária para o React Router (para não dar erro 404 ao recarregar página)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]