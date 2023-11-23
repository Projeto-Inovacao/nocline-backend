from flask import Flask
import subprocess

app = Flask(__name__)

@app.route('/')
def index():
    return '''
    <html>
        <head>
            <title>Botão Reiniciar</title>
        </head>
        <body>
            <button onclick="reiniciar()">Reiniciar</button>

            <script>
                function reiniciar() {
                    fetch('/reiniciar')
                        .then(response => response.json())
                        .then(data => console.log(data));
                }
            </script>
        </body>
    </html>
    '''

@app.route('/reiniciar')
def reiniciar():
    # Substitua o caminho pelo caminho real do seu script Python
    script_path = r"C:\Users\gyuli\OneDrive\Documentos\Sistemas de Informação\2º Semestre\NOCLINE- PI\Original - SP2\nocline-backend\individual-gyu\reiniciar.py"
    
    try:
        result = subprocess.run(['python', script_path], capture_output=True, text=True, timeout=10)
        return {'status': 'success', 'output': result.stdout, 'error': result.stderr}
    except subprocess.CalledProcessError as e:
        return {'status': 'error', 'output': e.output, 'error': e.stderr}
    except Exception as e:
        return {'status': 'error', 'error': str(e)}

if __name__ == '__main__':
    app.run(debug=True)
