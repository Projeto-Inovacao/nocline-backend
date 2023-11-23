import speedtest
import socket
import socket
import mysql.connector
from cred import usr, pswd

event = threading.Event()
print(event)

def stop():
    event.set()
    print("\nFinalizando monitoramento")
    print(event)

keyboard.add_hotkey("esc", stop)

while not event.is_set():

    # Obtém o nome do host
    host_name = socket.gethostname()

    # Obtém o endereço IP associado ao nome do host
    ip_address = socket.gethostbyname(host_name)

print(f"Nome do host:", host_name)
print(f"Endereço IP:", ip_address)

teste = speedtest.Speedtest()

print("testando conexão...")

# obtem velocidade de download
velocidade_download = teste.download()
# obtem velocidade de upload
velocidade_upload = teste.upload()
#ping
ping = teste.results.ping
#latencia
latencia = ping/2

#print("Valores arredondados para duas casas decimais")
#print("Velocidade download:", round(velocidade_download/10**6,2))
#print("Velocidade upload:", round(velocidade_upload/10**6,2))
#print("ping:", ping)

vel_down = velocidade_download/10**6
vel_uplo = velocidade_upload/10**6


print("Valores originais")
print("Velocidade download:", vel_down)
print("Velocidade upload:", vel_uplo)
print("ping:", ping)
print("latência:", latencia)
mydb = mysql.connector.connect(host='localhost', user=usr, password=pswd, database='nocLine')
    
try:
        if mydb.is_connected():
            db_info = mydb.get_server_info()
                
            mycursor = mydb.cursor()
        
            sql_query = "SELECT id_maquina, fk_empresaM FROM maquina WHERE hostname = %s;"
            mycursor.execute(sql_query, (hostname,))
            
            result = mycursor.fetchone()
            
            if result:
                id_maquina, fk_empresaM = result
                
                sql_query = """
                INSERT INTO monitoramento (dado_coletado, data_hora, descricao, fk_componentes_monitoramento, fk_maquina_monitoramento, fk_empresa_monitoramento, fk_unidade_medida)
                VALUES (%s, now(), 'nome do host', (SELECT id_componente from componente WHERE nome_componente = 'CPU' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s)),
                       (%s, now(), 'endereço IP', (SELECT id_componente from componente WHERE nome_componente = 'CPU' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s)),
                       (%s, now(), 'velocidade de dowload', (SELECT id_componente from componente WHERE nome_componente = 'REDE' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s)),
                       (%s, now(), 'velocidade de upload', (SELECT id_componente from componente WHERE nome_componente = 'REDE' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s)),
                       (%s, now(), 'ping', (SELECT id_componente from componente WHERE nome_componente = 'REDE' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s));
                """
                val = [host_name, id_maquina, id_maquina, fk_empresaM, '%',
                       ip_address, id_maquina, id_maquina, fk_empresaM, 'B',
                       vel_down, id_maquina, id_maquina, fk_empresaM, 'B',
                       vel_uplo, id_maquina, id_maquina, fk_empresaM, 'B',
                       ping, id_maquina, id_maquina, fk_empresaM, 'B']
                
                mycursor.execute(sql_query, val)
                mydb.commit()
                print(mycursor.rowcount, "registros inseridos no banco")
                print("\r\n")
            else:
                print("A máquina " + hostname + " não foi cadastrada no site. Cadastre-a para fazer a captura!")
    
    except mysql.connector.Error as e: print("Erro ao conectar com o MySQL:", e)finally:        if mydb.is_connected():            mycursor.close()
