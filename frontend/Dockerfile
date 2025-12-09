# frontend/Dockerfile

# Estágio 1: Build (Construção)
FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Argumento de build para a URL da API
# Isso "grava" o endereço do backend no código JS
ARG VITE_API_URL=http://localhost:3000
ENV VITE_API_URL=$VITE_API_URL

RUN npm run build

# Estágio 2: Servidor (Nginx)
FROM nginx:alpine

# Copia os arquivos gerados no estágio anterior para a pasta do Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Configuração necessária para o React Router (para não dar erro 404 ao recarregar página)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]