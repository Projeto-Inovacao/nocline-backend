import com.github.britooo.looca.api.core.Looca // biblioteca para capturar informações do sistema
import com.github.britooo.looca.api.group.janelas.Janela
import com.github.britooo.looca.api.group.processos.Processo
import java.time.LocalDateTime // biblioteca para lidar com informações de data e hora
import java.util.concurrent.TimeUnit // biblioteca usada para manipulação de unidades de tempo.


fun main() {
    Conexao.criarTabelas()
    val looca = Looca()

    val repositorio = DadosRepositorios()
    repositorio.iniciar()

    while (true) {
        //CAPTURA DE PROCESSOS
        val novoProcesso = capturarDadosP(looca)
        repositorio.cadastrarProcesso(novoProcesso)

        // CAPTURA DE JANELAS
        val novaJanela = capturarDadosJ(looca)
        repositorio.cadastrarJanela(novaJanela)

        //CAPTURA DE REDE
        val novaRede = capturarDadosR(looca)
        repositorio.cadastrarRede(novaRede)

        TimeUnit.SECONDS.sleep(60)
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


