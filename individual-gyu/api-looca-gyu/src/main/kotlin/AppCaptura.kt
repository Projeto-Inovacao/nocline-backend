import com.github.britooo.looca.api.core.Looca // biblioteca para capturar informações do sistema
import java.util.concurrent.TimeUnit // biblioteca usada para manipulação de unidades de tempo.
import javax.swing.JOptionPane


fun main() {
    Conexao.criarTabelas()

    val looca = Looca()
    val login = Usuario()
    val dadoslogin = LoginRepositorio()

    login.email = JOptionPane.showInputDialog("Digite o seu email:").toString()
    login.senha = JOptionPane.showInputDialog("Digite a sua senha:").toString()

    dadoslogin.iniciar()
    if (dadoslogin.validarLogin(login)) {
        JOptionPane.showMessageDialog(null, dadoslogin.comprimentar(login))

        var fk_empresa = dadoslogin.verificarEmpresa(login)
        var listaDeMaquinas = dadoslogin.mostrarMaquina(fk_empresa)
        var id_maquina =
            JOptionPane.showInputDialog("Digite o ID da máquina que você deseja monitorar:\n\r $listaDeMaquinas")
                .toInt()

        val repositorio = DadosRepositorios()
        repositorio.iniciar()

        JOptionPane.showConfirmDialog(null, "O monitoramento irá inicializar agora!")
        while (true) {

            // CAPTURA DE JANELAS
            val novaJanela = repositorio.capturarDadosJ(looca)
            repositorio.cadastrarJanela(novaJanela, id_maquina, fk_empresa)

            // CAPTURA DE TEMPERATURA
            val novaTemp = repositorio.capturarDadosT(looca)
            repositorio.cadastrarT(novaTemp, id_maquina, fk_empresa )

            // CAPTURA DE CPU
            val novaCpu = repositorio.capturarDadosCpu(looca)
            repositorio.cadastrarCpu(novaCpu, id_maquina, fk_empresa )


            TimeUnit.SECONDS.sleep(32)
        }
    } else {
        JOptionPane.showMessageDialog(
            null, """
                Não conseguimos validar seu login dentro da nossa plataforma, caso você ache que isso é um erro, por favor, entre em contato conosco!
                """.trimIndent()
        )
    }
}



