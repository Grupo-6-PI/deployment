#!/bin/bash

echo "Configuração do container MySQL para o projeto Mooca Solidária"

read -p "Informe o nome do container (padrão: mooca-banco-prod): " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-mooca-banco-prod}

read -p "Informe a imagem do Container (padrão: moocasolidaria/mooca-solidaria-db:latest): " CONTAINER_IMAGE
CONTAINER_IMAGE=${CONTAINER_IMAGE:-moocasolidaria/mooca-solidaria-db:latest}

read -p "Informe a senha do root (padrão: urubu100): " MYSQL_ROOT_PASSWORD
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-urubu100}

read -p "Informe o nome do usuário (padrão: usuario): " MYSQL_USER
MYSQL_USER=${MYSQL_USER:-usuario}

read -p "Informe a senha do usuário (padrão: urubu100): " MYSQL_PASSWORD
MYSQL_PASSWORD=${MYSQL_PASSWORD:-urubu100}

read -p "Informe a porta para exposição (padrão: 3306): " CONTAINER_PORT
CONTAINER_PORT=${CONTAINER_PORT:-3306}

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

echo "Baixando a imagem do Conteiner: ${CONTAINER_IMAGE}..."
docker pull $CONTAINER_IMAGE

echo "Iniciando o container..."
docker run -d \
    --name $CONTAINER_NAME \
    -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -p $MYSQL_PORT:3306 \
    $CONTAINER_IMAGE

echo "Container $CONTAINER_NAME iniciado na porta $CONTAINER_PORT"
