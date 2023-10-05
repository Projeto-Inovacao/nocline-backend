import com.github.britooo.looca.api.core.Looca
import com.github.britooo.looca.api.group.discos.DiscoGrupo
import com.github.britooo.looca.api.group.janelas.Janela
import com.github.britooo.looca.api.group.memoria.Memoria
import com.github.britooo.looca.api.group.processador.Processador
import com.github.britooo.looca.api.group.processos.ProcessoGrupo
import com.github.britooo.looca.api.group.rede.Rede
import com.github.britooo.looca.api.group.servicos.ServicoGrupo
import com.github.britooo.looca.api.group.sistema.Sistema
import com.github.britooo.looca.api.group.temperatura.Temperatura

fun main() {
    val looca: Looca = Looca()
    val sistema1: Sistema
    val memoria: Memoria
    val processador: Processador
    val temperatura: Temperatura
    val grupoDeDiscos: DiscoGrupo
    val grupoDeServicos: ServicoGrupo
    val grupoDeProcessos: ProcessoGrupo
    val janela: Janela
    val rede: Rede

    val sistema = looca.sistema
    val processos = looca.grupoDeProcessos
    val dadosJanelas = looca.grupoDeJanelas
    val redes = looca.rede.grupoDeInterfaces.interfaces

    System.out.println(redes)

    sistema.getPermissao();
    sistema.getFabricante();
    sistema.getArquitetura();
    sistema.getInicializado();
    sistema.getSistemaOperacional();
    System.out.println(sistema);

//Obtendo lista de discos a partir do getter

    val listaJanelas = dadosJanelas.janelas

    for (n in listaJanelas) {
        println(n.titulo)
    }

}
