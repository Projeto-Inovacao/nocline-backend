# Guia de Configuração NocLine para EC2

Este é um assistente virtual em forma de script shell que automatiza a configuração de uma interface gráfica em uma instância EC2 da AWS para facilitar o acesso aos dados da máquina por meio de uma interface gráfica. O Assistente NocLine é projetado para simplificar o processo de configuração.

## Instruções de Uso

**Passo 1: Preparação Inicial**

Antes de começar, verifique se você tem sua chave privada e acesse a pasta que a contém. Abra um terminal de comando e cole o protocolo SSH disponibilizado na página "Cliente SSH" da AWS.

**Passo 2: Parte 1 - Configuração Inicial**

Execute a primeira parte do script com o seguinte comando:

bash parte1NL.sh

O script atualizará o sistema, instalará a interface gráfica LXDE, o servidor xrdp e a ferramenta nmon para monitoramento de desempenho. Após a conclusão bem-sucedida, copie o Endereço IPv4 público da página de instâncias da AWS.

No seu computador local, pesquise por "RDP" e cole o Endereço IPv4. Faça login e abra o terminal na Área de Trabalho Remota e execute:
bash parte2NL.sh

A Assistente NocLine irá orientá-lo na segunda parte da configuração.

**Passo 3: Parte 2 - Configuração Avançada**

A segunda parte do script abrirá a pasta "Desktop," criará um diretório "nmon" e programará a ferramenta nmon para coletar estatísticas de desempenho.

O script clonará o repositório NmonVisualizer e verificará a versão do Java. Se o Java não estiver instalado, o script oferecerá a opção de instalá-lo e iniciará o NmonVisualizer.

## Pré-requisitos
Conexão SSH à instância EC2 da AWS.
Credenciais sudo configuradas para usuários (certifique-se de seguir as etapas de configuração de senhas descritas abaixo).
Configuração de Senhas para Usuários

Para garantir que o script funcione corretamente, é essencial configurar senhas para os usuários. Use os seguintes comandos:

Adicionar uma senha ao usuário "root":
sudo passwd root
[sua_senha]

Adicionar uma senha ao usuário "ubuntu":
sudo passwd ubuntu
[sua_senha]

Criar um usuário para aumentar a segurança das operações:
sudo adduser nocline
[sua_senha]

Transformar o novo usuário em um administrador:
sudo usermod -a -G sudo nocline
Certifique-se de substituir "[sua_senha]" pelas senhas desejadas.


## Adicional:
Caso queira listar os processos de desempenho da máquina, dentro do terminal da Área de Trabalho Remota, basta executar os comando "ps -aux", "htop" ou "nmon t".

1. ps -aux:
Lista informações detalhadas sobre os processos em execução no sistema, incluindo detalhes como o usuário que iniciou o processo, uso de CPU e memória.

2. htop:
É um utilitário interativo para monitorar processos e o desempenho do sistema em tempo real. Permite classificar, filtrar e encerrar processos diretamente no aplicativo.

3. nmon -t:
O comando nmon é usado para coletar e exibir informações detalhadas sobre o desempenho do sistema, como uso de CPU, memória e disco. A opção -t permite que ele atualize estatísticas continuamente, fornecendo uma visão em tempo real do desempenho do sistema.   

## Autores
Grupo NocLine

## Licença
Este projeto está licenciado sob a Licença NocLine. 

## Lembre-se de substituir "[sua_senha]" pelas senhas reais nas instruções. 
