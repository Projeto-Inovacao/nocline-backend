import java.io.BufferedReader
import java.io.File
import java.io.InputStreamReader
import kotlin.reflect.typeOf

object ApiPython {
    private lateinit var processoPython: Process
    private lateinit var errorStream: InputStreamReader
    private lateinit var errorBufferedReader: BufferedReader

    fun chamarApiPython() {
        val nomeArquivoPyDefault = "individual-Jonny.py"
        val codigoPython = """
import psutil
import threading
import time
import keyboard
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
    cpu = psutil.cpu_times()
    processador = psutil.cpu_percent(interval=1)
    memoria = psutil.virtual_memory()
    disco = psutil.disk_usage("/")
    hostname = socket.gethostname()

    # CPU
    cpu_percentual = processador

    # Memória
    memoria_disponivel = memoria.available
    memoria_total = memoria.total

    mydb = mysql.connector.connect(host='localhost', user='noc_line', password='noc_line134#', database='nocline', auth_plugin='mysql_native_password')
    
    try:
        if mydb.is_connected():
            db_info = mydb.get_server_info()
                
            mycursor = mydb.cursor()
        
            sql_query = "SELECT id_maquina, fk_empresaM FROM maquina WHERE hostname = %s;"
            mycursor.execute(sql_query, (hostname,))
            
            result = mycursor.fetchone()
            
            if result:
                id_maquina, fk_empresaM = result
                
                sql_query = ""${'"'}
                INSERT INTO monitoramento (dado_coletado, data_hora, descricao, fk_componentes_monitoramento, fk_maquina_monitoramento, fk_empresa_monitoramento, fk_unidade_medida)
                VALUES (%s, now(), 'uso de cpu py', (SELECT id_componente from componente WHERE nome_componente = 'CPU' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s)),
                       (%s, now(), 'memoria disponivel', (SELECT id_componente from componente WHERE nome_componente = 'RAM' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s)),
                       (%s, now(), 'memoria total', (SELECT id_componente from componente WHERE nome_componente = 'RAM' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s));
                       
                ""${'"'}
                
                val = [cpu_percentual, id_maquina, id_maquina, fk_empresaM, '%',
                       memoria_disponivel, id_maquina, id_maquina, fk_empresaM, 'B',
                       memoria_total, id_maquina, id_maquina, fk_empresaM, 'B']
                
                mycursor.execute(sql_query, val)
                mydb.commit()
                print(mycursor.rowcount, "registros inseridos no banco")
                print("\r\n")
            else:
                print("A máquina " + hostname + " não foi cadastrada no site. Cadastre-a para fazer a captura!")
    
    except mysql.connector.Error as e:
        print("Erro ao conectar com o MySQL:", e)
    
    finally:
        if mydb.is_connected():
            mycursor.close()
            mydb.close()
            time.sleep(5)


        """.trimIndent()

        File(nomeArquivoPyDefault).writeText(codigoPython)

        // Use ProcessBuilder para iniciar o processo Python
        println("Iniciando o processo Python...")
        val processBuilder = ProcessBuilder("python.exe", nomeArquivoPyDefault)
        processoPython = processBuilder.start()
        println("Processo Python iniciado.")


        // Inicialize as propriedades relacionadas
        errorStream = InputStreamReader(processoPython.errorStream)
        errorBufferedReader = BufferedReader(errorStream)

        val thread = Thread {
            val combinedInputStream = InputStreamReader(processoPython.inputStream)
            val combinedBufferedReader = BufferedReader(combinedInputStream)

            val errorInputStream = InputStreamReader(processoPython.errorStream)
            val errorBufferedReader = BufferedReader(errorInputStream)

            while (true) {
                // Leia a saída padrão
                val line = combinedBufferedReader.readLine()
                if (line == null) break
                println(line)

                // Leia a saída de erro
                val errorLine = errorBufferedReader.readLine()
                if (errorLine == null) break
                println("Erro: $errorLine")
            }
        }

        thread.start()

    }
}
