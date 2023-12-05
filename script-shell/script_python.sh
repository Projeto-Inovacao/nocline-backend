#!/bin/bash

echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Antes de começarmos, preciso verificar se as bibliotecas necessárias estão instaladas para realizar o monitoramento."
sleep 2

# Inicializa a variável inst
inst=""

# Verifica se psutil está instalado
if ! pip list | grep -F psutil &> /dev/null; then
    echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) psutil não está instalado."
    inst="S"
else
    echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) psutil está instalado."
fi
sleep 2

# Verifica se mysql-connector-python está instalado
if ! pip list | grep -F mysql-connector-python &> /dev/null; then
    echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) mysql-connector-python não está instalado."
    inst="S"
else
    echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) mysql-connector-python está instalado."
fi
sleep 2

# Verifica se pymssql está instalado
if ! pip list | grep -F pymssql &> /dev/null; then
    echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) pymssql não está instalado."
    inst="S"
else
    echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) pymssql está instalado."
fi
sleep 2

# Verifica se alguma biblioteca está faltando
if [ "$inst" == "S" ]; then
    echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Algumas bibliotecas estão faltando. Deseja instalá-las (S/N)?"
    read get

    if [ \"$get\" == \"s\" ] || [ \"$get\" == \"S\" ]; then
        echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Irei começar as instalações então."
        sudo pip install psutil
        sudo pip install mysql-connector-python
        sudo pip install pymssql
        sleep 2
        echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Bibliotecas instaladas com sucesso."
    else
        echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Você optou por não instalar as bibliotecas, então não posso prosseguir com a execução."
        sleep 2
        echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Até a próxima!"
        exit 1
    fi
fi

main_file=$(find / -type f -name "main_LOCAL.py" 2>/dev/null)

if [ -z "$main_file" ]; then
    echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Arquivo main_LOCAL.py não encontrado."
    exit 1
fi

echo "$(tput setaf 19)[Assistente NocLine]:$(tput setaf 7) Vou prosseguir com a execução da API então!"
python3 "$main_file"
