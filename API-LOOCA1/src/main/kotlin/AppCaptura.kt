import com.github.britooo.looca.api.core.Looca // biblioteca para capturar informações do sistema
import com.github.britooo.looca.api.group.janelas.Janela
import com.github.britooo.looca.api.group.processos.Processo
import java.time.LocalDateTime // biblioteca para lidar com informações de data e hora
import java.util.concurrent.TimeUnit // biblioteca usada para manipulação de unidades de tempo.
import javax.swing.JOptionPane


fun main() {
    Conexao.criarTabelas()

    val looca = Looca()
    val login = Usuario()
    val dadoslogin = DadosLogin()

    login.email = JOptionPane.showInputDialog("Digite o seu email!").toString()
    login.senha = JOptionPane.showInputDialog("Digite a sua senha!").toString()

    dadoslogin.iniciar()
    val fk_empresa = dadoslogin.validarLogin(login)
        if(fk_empresa > 0) {

            exibirMensagem("Login válido")
            var listaDeMaquinas = dadoslogin.mostrarMaquina()
            var id_maquina = JOptionPane.showInputDialog("Digite o id da maquina que você deseja monitorar \n \r $listaDeMaquinas").toInt()

            val repositorio = DadosRepositorios()
            repositorio.iniciar()

            JOptionPane.showConfirmDialog(null,"O monitoramento irá inicalizar agora")
            while (true) {
                //CAPTURA DE PROCESSOS
                val novoProcesso = capturarDadosP(looca)
                repositorio.cadastrarProcesso(novoProcesso, id_maquina)

                // CAPTURA DE JANELAS
                val novaJanela = capturarDadosJ(looca)
                repositorio.cadastrarJanela(novaJanela, id_maquina)

                //CAPTURA DE REDE
                val novaRede = capturarDadosR(looca)
                repositorio.cadastrarRede(novaRede, id_maquina)

                TimeUnit.SECONDS.sleep(60)
            }
        }else{

            exibirMensagem("Login inválido!!")

        }
}

fun capturarDadosJ(looca: Looca): MutableList<Janela>? {
        val janela = looca.grupoDeJanelas
        var janelasVisiveis = janela.janelasVisiveis

    return janelasVisiveis

}

fun capturarDadosR(looca: Looca ): Redes {
    val redes = looca.rede.grupoDeInterfaces.interfaces

    val listaBytesRecebidos = mutableListOf<Long>()
    val listaBytesEnviados = mutableListOf<Long>()


    for (rede in redes) {
        listaBytesRecebidos.add(rede.getBytesRecebidos())
        listaBytesEnviados.add(rede.getBytesEnviados())
    }

    val nomeRede = "eth15"

    return Redes(0, LocalDateTime.now(), nomeRede, listaBytesEnviados.max(), listaBytesRecebidos.max())

}

fun capturarDadosP(looca: Looca): MutableList<Processo>? {
    val processos = looca.grupoDeProcessos
    var listaProcessos = processos.processos
    return listaProcessos
}

fun exibirMensagem(mensagem: String){

    JOptionPane.showMessageDialog(null, mensagem)

}


