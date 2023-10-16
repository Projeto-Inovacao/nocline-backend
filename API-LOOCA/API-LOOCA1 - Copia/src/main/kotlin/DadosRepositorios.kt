import com.fasterxml.jackson.databind.ObjectMapper
import com.github.britooo.looca.api.group.janelas.Janela
import com.github.britooo.looca.api.group.processos.Processo
import org.springframework.jdbc.core.JdbcTemplate
import java.time.LocalDate

// classe responsável por interagir com o banco de dados para dados relacionados a janelas e redes
class DadosRepositorios {

    // objeto JdbcTemplate usado para interagir com o banco de dados
    lateinit var jdbcTemplate: JdbcTemplate

    // método para iniciar o repositório, geralmente chamado no início para configurar a conexão com o banco de dados
    fun iniciar() {
        jdbcTemplate = Conexao.jdbcTemplate!!
    }

    // método para cadastrar informações sobre uma janela no banco de dados
    fun cadastrarJanela(novaJanela: MutableList<Janela>?) {
        var dataHora = LocalDate.now()

        novaJanela?.forEach { janela ->
            if (janela.titulo != null){
            jdbcTemplate.update(
                """
            insert into janelas (nomeJanela, dtHora, fkMaquina, fkEmpresa) values
            (?,?,1,1)
            """,
                janela.titulo,
                dataHora
            )
        }
        }
    }

    fun cadastrarRede(novaRede: Redes) {

        var rowBytesEnviados = jdbcTemplate.update(
            """
                insert into monitoramento (dadoColetado, dtHora, descricao, fkComponentesMonitoramentos, fkMaquinaMonitoramentos, fkEmpresaMonitoramentos, fkUnidadeMedida) values
                (?,?,"bytes enviados",4,1,1,1)
            """,
            novaRede.bytesEnviados,
            novaRede.dataHora
        )

        var rowBytesRecebidos = jdbcTemplate.update(
            """
                insert into monitoramento (dadoColetado, dtHora, descricao, fkComponentesMonitoramentos, fkMaquinaMonitoramentos, fkEmpresaMonitoramentos, fkUnidadeMedida) values
                (?,?,"bytes recebidos",4,1,1,1)
            """,
            novaRede.bytesRecebidos,
            novaRede.dataHora
        )

        println("""
            $rowBytesEnviados query de bytes enviados foi registrado no banco
            $rowBytesRecebidos query de bytes recebidos foi registrado no banco
        """.trimIndent())

    }

    fun cadastrarProcesso(novoProcesso: MutableList<Processo>?){
        novoProcesso?.forEach { p ->
            val queryProcesso = jdbcTemplate.update(
                """
            insert into processos (PID, nome, usoCPU, usoMemoria, memoriaVirtual, fkMaquina, fkEmpresa) values
            (?,?,?,?,?,1,1)
            """,
                p.pid,
                p.nome,
                p.usoCpu,
                p.usoMemoria,
                p.memoriaVirtualUtilizada
            )
            println("$queryProcesso query inseridas no banco de processos")
        }
    }
}