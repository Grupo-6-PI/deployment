# Documentação de Deploy

## Visão Geral
Este repositório contém três scripts de deploy para criar determinados containers Docker. Cada script foi desenvolvido para facilitar a implantação e gerenciamento dos containers necessários para a aplicação.

## Requisitos
Antes de executar qualquer um dos scripts de deploy, é essencial garantir que o Docker esteja instalado na sua máquina e que seu usuario está habilitado a utilizar comandos docker. Para verificar a instalação do Docker, execute o seguinte comando:

```sh
docker --version #Verificando se está instalado
```

```sh
id $USER 
#verificando se está habilitado a utilizar os comandos docker
```

Caso o Docker não esteja instalado, siga os passos abaixo para instalá-lo no **Ubuntu Server**:

### Passo a passo para instalar o Docker no Ubuntu Server

1. **Atualize os pacotes do sistema:**
   ```sh
   sudo apt update && sudo apt upgrade -y
   ```

2. **Instale os pacotes necessários:**
   ```sh
   sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
   ```

3. **Adicione o repositório oficial do Docker:**
   ```sh
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
   echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```

4. **Atualize os pacotes e instale o Docker:**
   ```sh
   sudo apt update
   sudo apt install -y docker-ce docker-ce-cli containerd.io
   ```

5. **Verifique se o Docker está instalado corretamente:**
   ```sh
   docker --version
   ```

6. **Habilite e inicie o serviço do Docker:**
   ```sh
   sudo systemctl enable docker
   sudo systemctl start docker
   ```

7. **Adicione seu usuário ao grupo `docker` para executar sem `sudo`:**
   ```sh
   sudo usermod -aG docker $USER
   ```
   Para aplicar a mudança, saia e entre novamente na sessão ou execute:
   ```sh
   newgrp docker
   ```

## Scripts de Deploy
Os scripts disponíveis neste repositório executam o deploy dos containers de forma automatizada. Certifique-se de executar os scripts com permissão adequada e dentro do diretório correto.

Para executar um script, utilize o comando:

```sh
chmod +x nome_do_script.sh
./nome_do_script.sh
```

Substitua `nome_do_script.sh` pelo nome do script correspondente ao container desejado.

## Autor
Este repositório foi documentado e criado por [@DaviRdaSilva](https://github.com/DaviRdaSilva).