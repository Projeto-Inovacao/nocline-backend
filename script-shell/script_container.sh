#!/bin/bash

container="ContainerNocLine"
mysql="mysql:8.0"


echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Boas-Vindas ao processo de configuração do container MySQL Nocline."
sleep 2
echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Primeiro preciso verificar se você possui o docker instalado."
sleep 2

docker --version 

if [ $? != 0 ]; then
    echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Ops.. Docker não instalado." 
    sleep 2
    echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Gostaria de instalar o Docker [s/n]" 

    read get 	
    
    if [ \"$get\" == \"s\" ] || [ \"$get\" == \"S\" ]; then 
        echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Estamos fazendo a instalação do Docker."
        sudo apt install docker.io -y 
        sleep 2
        echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Agora podemos prosseguir com a configuração."
        sleep 2
    else
        echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Você optou por não instalar o Docker, então não posso prosseguir com a configuração."
        sleep 2
        echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Até a próxima!"
        exit 1
    fi 
fi 

echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Docker instalado!"
sleep 3
echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Agora irei garantir que o docker está ativo"
sudo systemctl start docker
sleep 2
echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Pronto!"

if [ "$(sudo docker ps -a -q -f name=$container)" ]; then
 echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) O container $container já existe."
 sleep 2
 echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Vou executar o container e peço que confira as tabelas acessando o container via MySQL na porta padrão 3306."
 sleep 2
 echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) O acesso pode ser feito via terminal ou utlizando ferramentas como MySQL Workbench."
 sudo docker start $container
 sleep 5
 bash script_menu.sh
else
 echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) O container não está criado, vou realizar a configuração inicial dele."
 if docker images -q $mysql &> /dev/null; then
  echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) A imagem $mysql já existe."
         sleep 2
         echo "Vou criar o container "$container" utilizando a imagem $mysql."
         sleep 2
         sudo docker run -d -p 3306:3306 --name $container -e "MYSQL_DATABASE=nocline" -e "MYSQL_ROOT_PASSWORD=urubu100" $mysql
    else
        echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Estou fazendo o download da imagem $mysql"
        sudo docker pull $mysql
        sleep 2
        echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Pronto! Agora irei criar o container"
        sudo docker run -d -p 3306:3306 --name $container -e "MYSQL_DATABASE=nocline" -e "MYSQL_ROOT_PASSWORD=urubu100" $mysql
        echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Container $container criado com sucesso."
        sleep 2
        echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Para garantir a segurança peço que a configuração seja feito acessando o container"
        sleep 2
        echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) O acesso pode ser feito via terminal ou utlizando ferramentas como MySQL Workbench."
        sleep 3
        bash script_menu.sh
  fi
fi

