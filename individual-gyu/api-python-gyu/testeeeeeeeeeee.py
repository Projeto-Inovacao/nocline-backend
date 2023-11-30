import psutil
import threading
import time
import keyboard
import socket
import mysql.connector
import datetime
from cred import usr, pswd

event = threading.Event()
print(event)

mydb = None 

def stop():
    event.set()
    print("\nFinalizando monitoramento")
    print(event)

keyboard.add_hotkey("esc", stop)

while not event.is_set():
    try:
        if mydb is None or not mydb.is_connected():
            mydb = mysql.connector.connect(host='localhost', user=usr, password=pswd, database='nocLine')

        memoria = psutil.virtual_memory()
        hostname = socket.gethostname()

        # Verificar se a máquina com id_maquina 1 existe
        check_machine_query = "SELECT id_maquina FROM maquina WHERE id_maquina = 1;"
        check_machine_cursor = mydb.cursor()
        check_machine_cursor.execute(check_machine_query)
        machine_exists = check_machine_cursor.fetchone()

        if machine_exists:
            # Máquina com id_maquina 1 existe, obter o timestamp da última inicialização
            ultimo_boot_timestamp = psutil.boot_time()

            # Atualizar a tabela maquina com o novo timestamp
            update_machine_query = "UPDATE maquina SET data_hora_inicializacao = %s WHERE id_maquina = 1;"
            update_machine_cursor = mydb.cursor()
            update_machine_cursor.execute(update_machine_query, (datetime.datetime.fromtimestamp(ultimo_boot_timestamp),))
            mydb.commit()

            print("Data_hora_inicializacao atualizada na tabela maquina.")

            # Restante do código para inserir os dados de monitoramento
            sql_query = "SELECT id_maquina, fk_empresaM FROM maquina WHERE hostname = %s;"
            mycursor = mydb.cursor()
            mycursor.execute(sql_query, (hostname,))
            result = mycursor.fetchone()

            if result:
                id_maquina, fk_empresaM = result

                sql_query = """
                INSERT INTO monitoramento (dado_coletado, data_hora, descricao, fk_componentes_monitoramento, fk_maquina_monitoramento, fk_empresa_monitoramento, fk_unidade_medida)
                VALUES (%s, now(), 'memoria disponivel', (SELECT id_componente from componente WHERE nome_componente = 'RAM' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s)),
                        (%s, now(), 'memoria total', (SELECT id_componente from componente WHERE nome_componente = 'RAM' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s)),
                        (%s, now(), 'tempo corrido em horas', (SELECT id_componente from componente WHERE nome_componente = 'SISTEMA' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s));
                """
                val = [memoria.available, id_maquina, id_maquina, fk_empresaM, 'B',
                       memoria.total, id_maquina, id_maquina, fk_empresaM, 'B',
                       (datetime.datetime.now().timestamp() - ultimo_boot_timestamp) / 3600, id_maquina, id_maquina, fk_empresaM, 'H'
                       ]

                mycursor.execute(sql_query, val)
                mydb.commit()
                print(mycursor.rowcount, "registros inseridos no banco")
                print("\r\n")

    except mysql.connector.Error as e:
        print("Erro ao conectar com o MySQL:", e)

    finally:
        if mydb and mydb.is_connected():
            update_machine_cursor.close()
            check_machine_cursor.close()
            mycursor.close()
            time.sleep(30)  # Adicionado aqui se você desejar um atraso antes da próxima iteração
