#!/bin/bash

echo  "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Olá, muito prazer! Eu sou a assitente virtual da NocLine. O que você deseja fazer agora?"
sleep 2
echo  "1. Executar captura python
2. Executar captura kotlin
3. Configurar Container Nocline
4. Configurar aplicação Nocline
3. Qualquer tecla para sair"
sleep 2

read inst

if [ \"$inst\" == \"1\" ]
    then
        bash script_python.sh
elif [ \"$inst\" == \"2\" ]
    then
        bash script_kotlin.sh
elif [ \"$inst\" == \"3\" ]
    then
        bash script_container.sh
elif [ \"$inst\" == \"4\" ]
    then
        bash script_aplicacao.sh
else
echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Até uma proxima!"
fi

