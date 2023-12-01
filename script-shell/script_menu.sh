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

# java -version
# if [ $? -eq 0 ]s
# 	then
# 		echo "$(tput setaf 10)[Assistente NocLine]:$(tput setaf 7) : Você já tem o java instalado!!!"
# 	else
# 		echo "$(tput setaf 10)[Assistente NocLine]:$(tput setaf 7)  Opa! Não identifiquei nenhuma versão do Java instalado, mas sem problemas, irei resolver isso agora!"
# 		echo "$(tput setaf 10)[Assistente NocLine]:$(tput setaf 7)  Confirme para mim se realmente deseja instalar o Java (S/N)?"
# 	read inst
# 	if [ \"$inst\" == \"S\" ]
# 		then
# 			echo "$(tput setaf 10)[Assistente NocLine]:$(tput setaf 7)  Ok! Você escolheu instalar o Java ;D"
# 			echo "$(tput setaf 10)[Assistente NocLine]:$(tput setaf 7)  Adicionando o repositório!"
# 			sleep 2
# 			sudo add-apt-repository ppa:webupd8team/java -y
# 			clear
# 			echo "$(tput setaf 10)[Assistente NocLine]:$(tput setaf 7)  Atualizando! Quase lá."
# 			sleep 2
# 			sudo apt update -y
# 			clear
			
# 			if [ $VERSAO -eq 11 ]
# 				then
# 					echo "$(tput setaf 10)[Assistente NocLine]:$(tput setaf 7) Preparando para instalar a versão 11 do Java. Confirme a instalação quando solicitado ;D"
# 					sudo apt install default-jre ; apt install openjdk-11-jre-headless; -y
# 					clear
# 					echo "$(tput setaf 10)[Assistente NocLine]:$(tput setaf 7) Java instalado com sucesso!"
# 				fi
# 		else 	
# 		echo "$(tput setaf 10)[Assistente NocLine]:$(tput setaf 7)  Você optou por não instalar o Java por enquanto, até a próxima então!"
# 	fi
# fi

# ===================================================================
# Todos direitos reservados para o autor: Dra. Profa. Marise Miranda.
# Sob licença Creative Commons @2020
# Podera modificar e reproduzir para uso pessoal.
# Proibida a comercialização e a exclusão da autoria.
# ===================================================================
