#!/bin/bash

echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Para que possamos utilizar a API de monitoramento kotlin, precisamos verificar se o Java está instalado."
sleep 2

java -version 

if [ $? != 0 ]; then
    echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Ops.. Java não instalado." 
    echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Gostaria de instalar o Java [s/n]" 

    read get 	
    
    if [ \"$get\" == \"s\" ] || [ \"$get\" == \"S\" ]; then 
        echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Estamos fazendo a instalação do Java."
        sudo apt install openjdk-17-jre -y 
        sleep 5
        sdk install java 8.0.282.j9-adpt
        sleep 2
        echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Agora podemos prosseguir com o monitoramento."
        sleep 2
    else
        echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Você optou por não instalar o Java, então não posso prosseguir com a execução."
        sleep 2
        echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Até a próxima!"
        exit 1
    fi 
fi 

echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Java instalado!"
sleep 5
echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Agora daremos início à captura."

main_file=$(find / -type f -name "API-LOOCA1-1.0-SNAPSHOT-jar-with-dependencies.jar" 2>/dev/null)

if [ -z "$main_file" ]; then
    echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Arquivo API-LOOCA1-1.0-SNAPSHOT-jar-with-dependencies.jar não encontrado."
    exit 1
fi

echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Vou prosseguir com a execução da API então!"
sudo java -jar "$main_file"
