import psutil
import threading
import time
import keyboard
#import datetime
import mysql.connector
from cred import usr, pswd

cpu = psutil.cpu_times()
processador = psutil.cpu_percent(interval=1)
memoria = psutil.virtual_memory()
disco = psutil.disk_usage("/")

fkMaquinaMonitoramentos = 1
fkEmpresaMonitoramentos = 1

event = threading.Event()
print(event)

def stop(): #define o evento para parar o monitoramento (tecla esc)
    event.set() #para o evento
    print("\nFinalizando monitoramento")
    print(event)

keyboard.add_hotkey("esc", stop)


while not event.is_set():
#CPU
        cpu_percentual = processador

#COMPONENTE DISCO
        disco_livre = disco.free
        disco_total = disco.total

#MEMORIA
        memoria_disponivel = memoria.available
        memoria_total = memoria.total

        mydb = mysql.connector.connect(host = 'localhost',user = usr, password = pswd, database = 'nocLine')
        try:
            if mydb.is_connected():
                db_info = mydb.get_server_info() #obtem informações do servidor mysql
                
                mycursor = mydb.cursor() #ladainha do sql
                sql_query = """
                INSERT INTO Monitoramento (dadoColetado, dtHora, descricao, fkComponentesMonitoramentos, fkMaquinaMonitoramentos, fkEmpresaMonitoramentos, fkUnidadeMedida)
                VALUES (%s, now(), 'uso cpu', 1, %s, %s, (SELECT idUnidade FROM UnidadeDeMedida WHERE Representacao = '%')),
                       (%s, now(), 'disco livre', 2, %s, %s, (SELECT idUnidade FROM UnidadeDeMedida WHERE Representacao = 'B')),
                       (%s, now(), 'disco total', 2, %s, %s, (SELECT idUnidade FROM UnidadeDeMedida WHERE Representacao = 'B')),
                       (%s, now(), 'memoria disponivel', 3, %s, %s, (SELECT idUnidade FROM UnidadeDeMedida WHERE Representacao = 'B')),
                       (%s, now(), 'memoria total', 3, %s, %s, (SELECT idUnidade FROM UnidadeDeMedida WHERE Representacao = 'B'));
            """
                val = [cpu_percentual, fkMaquinaMonitoramentos, fkEmpresaMonitoramentos, disco_livre, fkMaquinaMonitoramentos, fkEmpresaMonitoramentos, disco_total, fkMaquinaMonitoramentos, fkEmpresaMonitoramentos, memoria_disponivel, fkMaquinaMonitoramentos, fkEmpresaMonitoramentos, memoria_total, fkMaquinaMonitoramentos, fkEmpresaMonitoramentos]
                mycursor.execute(sql_query, val)
                mydb.commit() #se tiver tudo ok, aqui ele da o insert no banco
                print(mycursor.rowcount, "registros inseridos no banco") #esse rowcount fala o número de registros inseridos de uma vez
                print("\r\n")
        except mysql.connector.Error as e: #aqui é se der ruim com o banco, cai nesse erro
            print("Erro ao conectar com o MySQL", e)
        finally:
            if(mydb.is_connected()): #verifica se a conexão com o banco de dados está aberta
                mycursor.close() #aqui fecha uma parte
                mydb.close() #aqui fecha outra, só vai cair aqui dentro se clicar esq, ai chama a função de fechar o loop, caso contrario continua dando insert
                time.sleep(5)
