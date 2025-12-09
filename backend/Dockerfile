# backend/Dockerfile

# 1. Usa uma imagem leve do Node
FROM node:20-alpine

# 2. Define a pasta de trabalho dentro do container
WORKDIR /app

# 3. Copia os arquivos de dependência primeiro (para aproveitar cache)
COPY package*.json ./

# 4. Instala dependências (incluindo dev dependencies para rodar migrações se necessário)
RUN npm install

# 5. Copia o restante do código
COPY . .

# 6. Gera o cliente do Prisma (essencial!)
RUN npx prisma generate

# 7. Expõe a porta que o Express usa
EXPOSE 3000

# 8. Comando para iniciar
CMD ["npm", "run", "dev"]