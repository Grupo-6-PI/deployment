#!/bin/bash

echo "Configuração do container MySQL para o projeto Mooca Solidária"

read -p "Informe o nome do container (padrão: mooca-banco-prod): " MYSQL_CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-mooca-banco-prod}

read -p "Informe a imagem do Container (padrão: moocasolidaria/mooca-solidaria-front:latest): " MYSQL_IMAGE
CONTAINER_IMAGE=${CONTAINER_IMAGE:-moocasolidaria/mooca-solidaria-front:latest}

read -p "Informe a porta para exposição (padrão: 3306): " CONTAINER_PORT
CONTAINER_PORT=${CONTAINER_PORT:-3306}

read -p "Informe o endereço da API Back-End (padrão: localhost:8080): " BASE_URL
BASE_URL=${BASE_URL:-localhost:8080}

DOCKER_USER="moocasolidaria"
if ! docker info | grep -q "Username: $DOCKER_USER"; then
    echo "Você não está autenticado no Docker Hub com o usuário $DOCKER_USER."
    read -p "Deseja fazer login agora? (s/n): " LOGIN_CHOICE
    if [[ "$LOGIN_CHOICE" =~ ^[Ss]$ ]]; then
        docker login -u $DOCKER_USER
        if [ $? -ne 0 ]; then
            echo "Falha ao fazer login no Docker Hub. Verifique suas credenciais."
            exit 1
        fi
    else
        echo "O login é necessário para baixar a imagem do banco. Saindo..."
        exit 1
    fi
else
    echo "Usuário $DOCKER_USER já autenticado no Docker Hub."
fi

if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
    echo "O container $CONTAINER_NAME já existe. Removendo..."
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

echo "Baixando a imagem do MySQL: ${CONTAINER_IMAGE}..."
docker pull $CONTAINER_IMAGE

echo "Iniciando o container MySQL..."
docker run -d -p $CONTAINER_PORT:3000 \
  -e BASE_URL=$BASE_URL \
  --name $CONTAINER_NAME \
  $CONTAINER_IMAGE

echo "Container $CONTAINER_NAME iniciado na porta $CONTAINER_PORT"
