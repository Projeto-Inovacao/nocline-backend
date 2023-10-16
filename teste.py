import os
import time

def desligar_em(hora, minutos):
    agora = time.localtime()
    tempo_espera = (hora - agora.tm_hour) * 3600 + (minutos - agora.tm_min) * 60

    print(f"O computador será desligado em {tempo_espera / 60:.2f} minutos.")
    time.sleep(tempo_espera)

    # Comando para desligar no Windows
    os.system("shutdown /s /t 1")

# Exemplo: desligar às 22:30
desligar_em(9, 2)
