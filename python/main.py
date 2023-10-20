import psutil
import threading
import time
import keyboard
import socket
import mysql.connector
from cred import usr, pswd

event = threading.Event()
print(event)

def stop(): # Define o evento para parar o monitoramento (tecla esc)
    event.set() # Para o evento
    print("\nFinalizando monitoramento")
    print(event)

keyboard.add_hotkey("esc", stop)

while not event.is_set():
    cpu = psutil.cpu_times()
    processador = psutil.cpu_percent(interval=1)
    memoria = psutil.virtual_memory()
    disco = psutil.disk_usage("/")
    hostname = socket.gethostname()

    # CPU
    cpu_percentual = processador

    # Componente Disco
    disco_livre = disco.free
    disco_total = disco.total

    # Memória
    memoria_disponivel = memoria.available
    memoria_total = memoria.total

    mydb = mysql.connector.connect(host='localhost', user=usr, password=pswd, database='nocLine')
    try:
        if mydb.is_connected():
            db_info = mydb.get_server_info()  # Obtém informações do servidor MySQL
                
            mycursor = mydb.cursor()  # Ladainha do SQL
        
            sql_query = "SELECT idMaquina, fkEmpresa FROM maquina WHERE hostname = %s;"
        
            mycursor.execute(sql_query, (hostname,))

            # Obtém o resultado da consulta
            result = mycursor.fetchone()  # Você pode usar fetchall() se houver múltiplas linhas de resultado

            if result:
                fkMaquinaMonitoramentos, fkEmpresaMonitoramentos = result  # Desempacota os valores

                sql_query = """
                INSERT INTO Monitoramento (dadoColetado, dtHora, descricao, fkComponentesMonitoramentos, fkMaquinaMonitoramentos, fkEmpresaMonitoramentos, fkUnidadeMedida)
                VALUES (%s, now(), 'uso cpu', 9, %s, %s, (SELECT idUnidade FROM unidadeMedida WHERE representacao = '%')),
                       (%s, now(), 'disco livre', 10, %s, %s, (SELECT idUnidade FROM unidadeMedida WHERE representacao = 'B')),
                       (%s, now(), 'disco total', 10, %s, %s, (SELECT idUnidade FROM unidadeMedida WHERE representacao = 'B')),
                       (%s, now(), 'memoria disponivel', 11, %s, %s, (SELECT idUnidade FROM unidadeMedida WHERE representacao = 'B')),
                       (%s, now(), 'memoria total', 11, %s, %s, (SELECT idUnidade FROM unidadeMedida WHERE representacao = 'B'));
            """
                    val = [cpu_percentual, fkMaquinaMonitoramentos, fkEmpresaMonitoramentos, disco_livre, fkMaquinaMonitoramentos, fkEmpresaMonitoramentos, disco_total, fkMaquinaMonitoramentos, fkEmpresaMonitoramentos, memoria_disponivel, fkMaquinaMonitoramentos, fkEmpresaMonitoramentos, memoria_total, fkMaquinaMonitoramentos, fkEmpresaMonitoramentos]
                    mycursor.execute(sql_query, val)
                    mydb.commit() #se tiver tudo ok, aqui ele da o insert no banco
                    print(mycursor.rowcount, "registros inseridos no banco") #esse rowcount fala o número de registros inseridos de uma vez
                    print("\r\n")
                else:
                    print("A maquina " + hostname + " não foi cadastrada no site, cadastre ela para que seja feita captura!")

        except mysql.connector.Error as e: #aqui é se der ruim com o banco, cai nesse erro
            print("Erro ao conectar com o MySQL", e)
        finally:
            if(mydb.is_connected()): #verifica se a conexão com o banco de dados está aberta
                mycursor.close() #aqui fecha uma parte
                mydb.close() #aqui fecha outra, só vai cair aqui dentro se clicar esq, ai chama a função de fechar o loop, caso contrario continua dando insert
                time.sleep(5)
