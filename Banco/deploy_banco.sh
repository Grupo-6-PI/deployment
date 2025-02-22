#!/bin/bash

echo "Configuração do container MySQL para o projeto Mooca Solidária"

read -p "Informe o nome do container (padrão: mooca-banco-prod): " MYSQL_CONTAINER_NAME
MYSQL_CONTAINER_NAME=${MYSQL_CONTAINER_NAME:-mooca-banco-prod}

read -p "Informe a imagem do MySQL (padrão: moocasolidaria/mooca-solidaria-db:latest): " MYSQL_IMAGE
MYSQL_IMAGE=${MYSQL_IMAGE:-moocasolidaria/mooca-solidaria-db:latest}

read -p "Informe a senha do root (padrão: urubu100): " MYSQL_ROOT_PASSWORD
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-urubu100}

read -p "Informe o nome do usuário (padrão: usuario): " MYSQL_USER
MYSQL_USER=${MYSQL_USER:-usuario}

read -p "Informe a senha do usuário (padrão: urubu100): " MYSQL_PASSWORD
MYSQL_PASSWORD=${MYSQL_PASSWORD:-urubu100}

read -p "Informe a porta para exposição (padrão: 3306): " MYSQL_PORT
MYSQL_PORT=${MYSQL_PORT:-3306}

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

if docker ps -a --format '{{.Names}}' | grep -Eq "^${MYSQL_CONTAINER_NAME}\$"; then
    echo "O container $MYSQL_CONTAINER_NAME já existe. Removendo..."
    docker stop $MYSQL_CONTAINER_NAME
    docker rm $MYSQL_CONTAINER_NAME
fi

echo "Baixando a imagem do MySQL: ${MYSQL_IMAGE}..."
docker pull $MYSQL_IMAGE

echo "Iniciando o container MySQL..."
docker run -d \
    --name $MYSQL_CONTAINER_NAME \
    -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -p $MYSQL_PORT:3306 \
    $MYSQL_IMAGE

echo "Container $MYSQL_CONTAINER_NAME iniciado na porta $MYSQL_PORT"
