import psutil
import threading
import time
import keyboard
import socket
import pymssql
import mysql.connector
import json
import requests
from datetime import datetime
from cred import usr, pswd

webhook_url = "https://hooks.slack.com/services/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"
headers = {'Content-Type': 'application/json'}

event = threading.Event()
print(event)

id_maquina = None  # Inicialize id_maquina fora do loop
mydb = None  # Inicialize mydb fora do loop

def stop():
    event.set()
    print("\nFinalizando monitoramento")
    print(event)

keyboard.add_hotkey("esc", stop)

while not event.is_set():
    try:
        if mydb is None or not mydb.is_connected():
            mydb = mysql.connector.connect(host='localhost', user=usr, password=pswd, database='nocline')

        cpu = psutil.cpu_times()
        processador = psutil.cpu_percent(interval=1)
        memoria = psutil.virtual_memory()
        disco = psutil.disk_usage("/")
        hostname = socket.gethostname()

        # CPU
        cpu_percentual = processador
        print("Verificando condições de alerta CPU")
        print("Valor atual de cpu_percentual:", cpu_percentual)
        if cpu_percentual > 0 and cpu_percentual < 4:
            print("Condição de alerta CPU atendida (Risco)")
            mensagem_cpu1 = {"text": f"⚠ Alerta de Risco na CPU da máquina {id_maquina}!"}
            response = requests.post(webhook_url, data=json.dumps(mensagem_cpu1), headers=headers)
            print("Resposta da API do Slack:", response.text)
        elif cpu_percentual > 5:
            print("Condição de alerta CPU atendida (Perigo)")
            mensagem_cpu2 = {"text": f"☠️ Alerta de Perigo na CPU da máquina {id_maquina}!"}
            response = requests.post(webhook_url, data=json.dumps(mensagem_cpu2), headers=headers)
            print("Resposta da API do Slack:", response.text)
        else:
            print("Nenhuma condição de alerta CPU atendida")

        # Componente Disco
        disco_livre = disco.free
        disco_total = disco.total
        conta_disco_livre = (disco_livre / disco.total) * 100
        conta_disco_usado = 100 - conta_disco_livre
        print("Verificando condições de alerta Disco")
        print("Valor atual de disco_usado:", round(conta_disco_usado, 2))
        if round(conta_disco_usado, 2) > 20 and round(conta_disco_usado, 2) < 60:
            mensagem_disco1 = {"text": f"⚠ Alerta de Risco no Disco da máquina {id_maquina}!"}
            response = requests.post(webhook_url, data=json.dumps(mensagem_disco1), headers=headers)
            print("Resposta da API do Slack:", response.text)
        elif round(conta_disco_usado, 2) > 60:
            mensagem_disco2 = {"text": f"☠️ Alerta de Perigo no Disco da máquina {id_maquina}, há muito pouco espaço!"}
            response = requests.post(webhook_url, data=json.dumps(mensagem_disco2), headers=headers)
            print("Resposta da API do Slack:", response.text)
        else:
            print("Nenhuma condição de alerta Disco atendida")

        # Memória
        memoria_disponivel = memoria.available
        memoria_total = memoria.total
        conta_memoria_disponivel = (memoria_disponivel / memoria_total) * 100
        conta_memoria_usada = 100 - conta_memoria_disponivel
        print("Verificando condições de alerta RAM")
        print("Valor atual de memoria_usada:", round(conta_memoria_usada, 2))
        if round(conta_memoria_usada, 2) > 80 and round(conta_memoria_usada, 2) < 90:
            mensagem_ram1 = {"text": f"⚠ Alerta de Risco na Memória RAM da máquina {id_maquina}!"}
            response = requests.post(webhook_url, data=json.dumps(mensagem_ram1), headers=headers)
            print("Resposta da API do Slack:", response.text)
        elif round(conta_memoria_usada, 2) > 90:
            mensagem_ram2 = {"text": f"☠️ Alerta de Perigo na Memória RAM da máquina {id_maquina}!"}
            response = requests.post(webhook_url, data=json.dumps(mensagem_ram2), headers=headers)
            print("Resposta da API do Slack:", response.text)
        else:
            print("Nenhuma condição de alerta RAM atendida")

        sql_query = "SELECT id_maquina, fk_empresaM FROM maquina WHERE hostname = %s;"
        mycursor = mydb.cursor()
        mycursor.execute(sql_query, (hostname,))

        result = mycursor.fetchone()

        if result:
            id_maquina, fk_empresaM = result

            # Conexão com o servidor remoto
            try:
                mydb_server = pymssql.connect(server='52.22.58.174', database='nocline', user='sa', password='urubu100')

                try:
                    mycursor_server = mydb_server.cursor()
                    sql_query_server = "SELECT TOP 1 id_maquina, fk_empresaM FROM maquina WHERE hostname = %s;"
                    mycursor_server.execute(sql_query_server, (hostname,))
                    result = mycursor_server.fetchone()

                    if result:
                        id_maquina, fk_empresaM = result
                        data_hora_local = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                        sql_query = """
                                INSERT INTO monitoramento (dado_coletado, data_hora, descricao, fk_componentes_monitoramento, fk_maquina_monitoramento, fk_empresa_monitoramento, fk_unidade_medida)
                                VALUES (%s, %s, 'uso de cpu py', (SELECT TOP 1 id_componente from componente WHERE nome_componente = 'CPU' and fk_maquina_componente = %s), %s, %s, (SELECT TOP 1 id_unidade FROM unidade_medida WHERE representacao = %s)),
                                    (%s, %s, 'disco livre', (SELECT TOP 1 id_componente from componente WHERE nome_componente = 'DISCO' and fk_maquina_componente = %s), %s, %s, (SELECT TOP 1 id_unidade FROM unidade_medida WHERE representacao = %s)),
                                    (%s, %s, 'disco total', (SELECT TOP 1 id_componente from componente WHERE nome_componente = 'DISCO' and fk_maquina_componente = %s), %s, %s, (SELECT TOP 1 id_unidade FROM unidade_medida WHERE representacao = %s)),
                                    (%s, %s, 'memoria disponivel', (SELECT TOP 1 id_componente from componente WHERE nome_componente = 'RAM' and fk_maquina_componente = %s), %s, %s, (SELECT TOP 1 id_unidade FROM unidade_medida WHERE representacao = %s)),
                                    (%s, %s, 'memoria total', (SELECT TOP 1 id_componente from componente WHERE nome_componente = 'RAM' and fk_maquina_componente = %s), %s, %s, (SELECT TOP 1 id_unidade FROM unidade_medida WHERE representacao = %s));
                            """
                        val = (cpu_percentual, data_hora_local, id_maquina, id_maquina, fk_empresaM, '%',
                                disco_livre, data_hora_local, id_maquina, id_maquina, fk_empresaM, 'B',
                                disco_total, data_hora_local, id_maquina, id_maquina, fk_empresaM, 'B',
                                memoria_disponivel, data_hora_local, id_maquina, id_maquina, fk_empresaM, 'B',
                                memoria_total, data_hora_local, id_maquina, id_maquina, fk_empresaM, 'B')
                        mycursor_server.execute(sql_query, val)
                        mydb_server.commit()
                        print(mycursor_server.rowcount, "registros inseridos no servidor remoto")
                        print("\r\n")

                except mysql.connector.Error as e:
                    print("Erro ao conectar com o servidor MySQLServer:", e)

                finally:
                        mycursor_server.close()
                        mydb_server.close()

            except pymssql.OperationalError as e:
                print("Houve um erro ao realizar o insert.")
                print(f"Detalhes: {e}")

            try:
                sql_query = """
                    INSERT INTO monitoramento (dado_coletado, data_hora, descricao, fk_componentes_monitoramento, fk_maquina_monitoramento, fk_empresa_monitoramento, fk_unidade_medida)
                    VALUES (%s, now(), 'uso de cpu py', (SELECT id_componente from componente WHERE nome_componente = 'CPU' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s)),
                           (%s, now(), 'disco livre', (SELECT id_componente from componente WHERE nome_componente = 'DISCO' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s)),
                           (%s, now(), 'disco total', (SELECT id_componente from componente WHERE nome_componente = 'DISCO' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s)),
                           (%s, now(), 'memoria disponivel', (SELECT id_componente from componente WHERE nome_componente = 'RAM' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s)),
                           (%s, now(), 'memoria total', (SELECT id_componente from componente WHERE nome_componente = 'RAM' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s));
                """
                val = [cpu_percentual, id_maquina, id_maquina, fk_empresaM, '%',
                       disco_livre, id_maquina, id_maquina, fk_empresaM, 'B',
                       disco_total, id_maquina, id_maquina, fk_empresaM, 'B',
                       memoria_disponivel, id_maquina, id_maquina, fk_empresaM, 'B',
                       memoria_total, id_maquina, id_maquina, fk_empresaM, 'B']

                mycursor.execute(sql_query, val)
                mydb.commit()
                print(mycursor.rowcount, "registros inseridos no banco")
                print("\r\n")

            except mysql.connector.Error as e:
                print("Erro ao conectar com o MySQL:", e)

            finally:
                if mydb and mydb.is_connected():
                    mycursor.close()
                else:
                    print(f"A máquina {hostname} não foi cadastrada.")

    except Exception as ex:
        print(f"Erro geral: {ex}")

time.sleep(30)  # Adicionado aqui se você desejar um atraso antes da próxima iteração
