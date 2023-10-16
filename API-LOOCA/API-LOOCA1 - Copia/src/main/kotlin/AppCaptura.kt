import com.github.britooo.looca.api.core.Looca // biblioteca para capturar informações do sistema
import com.github.britooo.looca.api.group.janelas.Janela
import com.github.britooo.looca.api.group.processos.Processo
import java.time.LocalDateTime // biblioteca para lidar com informações de data e hora
import java.util.concurrent.TimeUnit // biblioteca usada para manipulação de unidades de tempo.


fun main() {
    Conexao.criarTabelas()
    // criando instância da api de captura
    val looca = Looca()

    val repositorio = DadosRepositorios()
    repositorio.iniciar()

    //CAPTURA DE PROCESSOS
    val novoProcesso = capturarDadosP(looca)
    repositorio.cadastrarProcesso(novoProcesso)

    while (true) {
        // CAPTURA DE JANELAS
        // chamando a função capturarDadosJ(looca) para obter dados sobre janelas
        val novaJanela = capturarDadosJ(looca)
        repositorio.cadastrarJanela(novaJanela)

        //CAPTURA DE REDE

        // chamando a função capturarDadosR(looca) para obter dados sobre redes
        val novaRede = capturarDadosR(looca)
        repositorio.cadastrarRede(novaRede)

        // Aguarda 5 segundos antes de capturar os dados novamente
        TimeUnit.SECONDS.sleep(5)
    }
}

fun capturarDadosJ(looca: Looca): MutableList<Janela>? {
        val janela = looca.grupoDeJanelas
    // selecionar a lista de janelas visiveis
        var janelasVisiveis = janela.janelasVisiveis

    return janelasVisiveis

}

fun capturarDadosR(looca: Looca ): Redes {
    val redes = looca.rede.grupoDeInterfaces.interfaces

    // criando lista mutáveis para adicionar os bytes e o long serve para armazenar números inteiros de até 64 bits
    val listaBytesRecebidos = mutableListOf<Long>()
    val listaBytesEnviados = mutableListOf<Long>()
    val listaPacotesEnviados = mutableListOf<Long>()
    val listaPacotesRecebidos = mutableListOf<Long>()

    for (rede in redes) {
        // get servem para coletar os dados de rede
        // os dados são adicionados nas listas
        listaBytesRecebidos.add(rede.getBytesRecebidos())
        listaBytesEnviados.add(rede.getBytesEnviados())
    }

    // printando os resultados no console
    // println("Bytes enviados: $listaBytesEnviados bytes de ${redes}")

    // como nós queremos coletar dados apenas de ethernet, eu fixei o nome da rede
    val nomeRede = "eth15"

    // retorna a instância janelas com informações sobre as janelas do sistema
    // 0 -> id
    // LocalDateTime.now() -> data e hora atual
    // nomesRede -> eth15
    // listaBytesEnviados -> pega o número máximo da lista, já que haverá só um por captura
    // listaBytesRecebidos -> pega o número máximo da lista, já que haverá só um por captura
    return Redes(0, LocalDateTime.now(), nomeRede, listaBytesEnviados.max(), listaBytesRecebidos.max())

}

fun capturarDadosP(looca: Looca): MutableList<Processo>? {
    val processos = looca.grupoDeProcessos
    var listaProcessos = processos.processos
    return listaProcessos
}


