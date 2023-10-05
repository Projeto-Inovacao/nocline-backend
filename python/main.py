import psutil
import threading
import time
import keyboard
#import datetime
import mysql.connector
from cred import usr, pswd

event = threading.Event()
print(event)

def stop(): #define o evento para parar o monitoramento (tecla esc)
    event.set() #para o evento
    print("\nFinalizando monitoramento")
    print(event)

keyboard.add_hotkey("esc", stop)


print('monitorando energia...')

while not event.is_set():
    uso_cpu = round(psutil.cpu_percent(), 2) #percent uso cpu
    uso_disco = round(psutil.disk_usage('/').percent, 2) #percent uso disco
    uso_memoria = round(psutil.virtual_memory().percent, 2) #percent uso ram
    #bat = psutil.sensors_battery()[2]
    #perc = psutil.sensors_battery()[0]
    if bat:
        print('Bateria {:.2f}%'.format(perc))    
    if not bat:
        #hoje = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print('Bateria {:.2f}% ...ALERTA'.format(perc))
        try:
            mydb = mysql.connector.connect(host = 'localhost',user = usr, password = pswd, database = 'nocLine')
            if mydb.is_connected():
                db_info = mydb.get_server_info()
                #print("Conectado ao MySQL Server versão ",db_info)
                
                mycursor = mydb.cursor()

                sql_query = "INSERT INTO Monitoramento VALUES (null, current_timestamp(), 'Bateria desconectada',%s)"
                val = [round(perc,2)]
                mycursor.execute(sql_query, val)

                mydb.commit() #se tiver tudo ok, aqui ele da o insert no banco
                print(mycursor.rowcount, "registro inserido") #esse rowcount fala o número de registros inseridos de uma vez
        except mysql.connector.Error as e: #aqui é se der ruim com o banco, cai nesse erro
            print("Erro ao conectar com o MySQL", e)
        finally:
            if(mydb.is_connected()): #verifica se a conexão com o banco de dados está aberta
                mycursor.close() #aqui fecha uma parte
                mydb.close() #aqui fecha outra, só vai cair aqui dentro se clicar esq, ai chama a função de fechar o loop, caso contrario continua dando insert
    time.sleep(5)
