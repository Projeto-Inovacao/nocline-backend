import com.github.britooo.looca.api.core.Looca
import java.util.Scanner
import javax.swing.JOptionPane

fun main() {
    Conexao.criarTabelas()
    val py = ApiPython
    val pySqlServer = ApiPythonSqlServer
    val login = Usuario()
    val dadoslogin = LoginRepositorio()

    val scanner = Scanner(System.`in`)

    print("Digite o seu email:")
    login.email = scanner.nextLine()

    print("Digite a sua senha:")
    login.senha = scanner.nextLine()

    dadoslogin.iniciar()
    if (dadoslogin.validarLogin(login)) {
        print(dadoslogin.comprimentar(login))

        var fk_empresa = dadoslogin.verificarEmpresa(login)
        var listaDeMaquinas = dadoslogin.mostrarMaquina(fk_empresa)

        print("Digite o ID da máquina que você deseja monitorar:\n\r $listaDeMaquinas \n" +
                "\n")
        var id_maquina = scanner.nextLine()

        py.chamarApiPython()

    }
}