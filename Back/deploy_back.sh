#!/bin/bash

echo "Configuração do container Spring Boot para o projeto Mooca Solidária"

# Solicita informações ao usuário
read -p "Informe o nome do container (padrão: mooca-back-prod): " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-mooca-back-prod}

read -p "Informe a porta para exposição (padrão: 8080): " CONTAINER_PORT
CONTAINER_PORT=${CONTAINER_PORT:-8080}

read -p "Informe a imagem do Container (padrão: moocasolidaria/mooca-solidaria-back:latest): " MYSQL_IMAGE
CONTAINER_IMAGE=${CONTAINER_IMAGE:-moocasolidaria/mooca-solidaria-back:latest}

read -p "Informe o usuário do banco de dados (padrão: root): " USUARIO_BANCO
USUARIO_BANCO=${USUARIO_BANCO:-root}

read -p "Informe a senha do banco de dados (padrão: root): " SENHA_BANCO
SENHA_BANCO=${SENHA_BANCO:-root}

read -p "Informe o host do banco de dados (padrão: localhost): " HOST_BANCO
HOST_BANCO=${HOST_BANCO:-localhost}

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

echo "Baixando a imagem do SpringBoot: ${CONTAINER_IMAGE}..."
docker pull $CONTAINER_IMAGE

echo "Iniciando o container Spring Boot..."
docker run -d \
  -p $CONTAINER_PORT:8080 \
  -e USUARIO_BANCO=$USUARIO_BANCO \
  -e SENHA_BANCO=$SENHA_BANCO \
  -e HOST_BANCO=$HOST_BANCO \
  --name $CONTAINER_NAME \
  $CONTAINER_IMAGE

echo "Container $CONTAINER_NAME iniciado com sucesso na porta $CONTAINER_PORT."