#!/bin/bash

#Para esté script funcionar perfeitamente 
#ele deve ser executado por um usuario do grupo docker

criar_imagem() {
    
    echo "=> Criando a imagem do conteiner utilizando o Dockerfile"

    docker build -t mooca-solidaria-db .
    
    echo "=> Imagem criada nomeada de mooca_solidaria_db"
    echo ""

}

tag_envio_para_dockerhub() {
    
    echo "=> Colocando a tag para colocar a versão no DockerHub"
    
    docker tag mooca-solidaria-db davirdasilva/mooca-solidaria-db:${1}
    
    echo ""

}

envio_para_dockerhub() {
    
    echo "=> Colocando a nova versão no DockerHub"
    
    docker push davirdasilva/mooca-solidaria-db:${1}
    
    echo "=> Upload feito"
    echo ""

}

criar_imagem ${1}

tag_envio_para_dockerhub ${1}

envio_para_dockerhub ${1}

exit 0