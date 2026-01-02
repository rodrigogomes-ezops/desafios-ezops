# backend/Dockerfile
# Multi-stage build para otimizar tamanho da imagem

# Estágio 1: Build (para gerar Prisma Client e instalar dependências)
FROM node:20-alpine AS builder

WORKDIR /app

# Copia arquivos de dependência
COPY package*.json ./
COPY prisma ./prisma/

# Instala TODAS as dependências (incluindo devDependencies para Prisma CLI)
RUN npm ci

# Gera o cliente do Prisma
RUN npx prisma generate

# Estágio 2: Produção (imagem final menor)
FROM node:20-alpine AS production

WORKDIR /app

# Copia apenas package.json e package-lock.json
COPY package*.json ./

# Instala APENAS dependências de produção (sem devDependencies)
RUN npm ci --only=production

# Copia o cliente Prisma gerado do estágio anterior
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder /app/node_modules/@prisma ./node_modules/@prisma

# Copia o código da aplicação (inclui prisma/schema.prisma)
COPY . .

# Expõe a porta
EXPOSE 3000

# Usa script de produção (não nodemon)
CMD ["npm", "start"]