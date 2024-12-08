# Etapa 1: Build
FROM node:16 AS build-stage

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia os arquivos package.json e package-lock.json para instalar dependências
COPY package*.json ./

# Instala as dependências do projeto
RUN npm install

# Copia o restante dos arquivos do projeto Angular
COPY . .

# Compila o projeto Angular em modo de produção
RUN npm run build --prod

# Etapa 2: Servir o app com Nginx
FROM nginx:stable-alpine AS production-stage

# Copia os arquivos compilados da etapa anterior para a pasta padrão do Nginx
COPY --from=build-stage /app/dist/<nome-do-projeto> /usr/share/nginx/html

# Copia um arquivo customizado de configuração do Nginx, caso necessário
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expõe a porta 80 para acesso externo
EXPOSE 80

# Inicia o Nginx
CMD ["nginx", "-g", "daemon off;"]