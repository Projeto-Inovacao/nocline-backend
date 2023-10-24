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
        
            sql_query = "SELECT id_maquina, fk_empresaM FROM maquina WHERE hostname = %s;"
        
            mycursor.execute(sql_query, (hostname,))

            # Obtém o resultado da consulta
            result = mycursor.fetchone()  # Você pode usar fetchall() se houver múltiplas linhas de resultado

            if result:
                id_maquina, fk_empresaM = result  # Desempacota os valores

                sql_query = """
                INSERT INTO Monitoramento (dado_coletado, data_hora, descricao, fk_componentes_monitoramento, fk_maquina_monitoramento, fk_empresa_monitoramento, fk_unidade_medida)
                VALUES (%s, now(), 'uso cpu', 1, %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = '%')),
                       (%s, now(), 'disco livre', 2, %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = 'B')),
                       (%s, now(), 'disco total', 2, %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = 'B')),
                       (%s, now(), 'memoria disponivel', 3, %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = 'B')),
                       (%s, now(), 'memoria total', 3, %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = 'B'));
                """
                val = [cpu_percentual, id_maquina, fk_empresaM, disco_livre, id_maquina, fk_empresaM, disco_total, id_maquina, fk_empresaM, memoria_disponivel, id_maquina, fk_empresaM, memoria_total, id_maquina, fk_empresaM]
                mycursor.execute(sql_query, val)
                mydb.commit()  # Se tudo estiver OK, aqui ele dá o INSERT no banco
                print(mycursor.rowcount, "registros inseridos no banco")  # Este rowcount fala o número de registros inseridos de uma vez
                print("\r\n")
            else:
                print("A máquina " + hostname + " não foi cadastrada no site, cadastre-a para que seja feita a captura!")

    except mysql.connector.Error as e:  # Aqui é se der ruim com o banco, cai nesse erro
        print("Erro ao conectar com o MySQL", e)
    finally:
        if mydb.is_connected():  # Verifica se a conexão com o banco de dados está aberta
            mycursor.close()  # Aqui fecha uma parte
            mydb.close()  # Aqui fecha outra, só vai cair aqui dentro se clicar esc, ai chama a função de fechar o loop, caso contrário continua dando INSERT
            time.sleep(60)
