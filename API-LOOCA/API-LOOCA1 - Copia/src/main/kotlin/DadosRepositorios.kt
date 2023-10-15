import com.fasterxml.jackson.databind.ObjectMapper
import com.github.britooo.looca.api.group.janelas.Janela
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
                (?,?,"bytes rebidos",4,1,1,1)
            """,
            novaRede.bytesRecebidos,
            novaRede.dataHora
        )

        var rowPacotesEnviados = jdbcTemplate.update(
                """
                insert into monitoramento (dadoColetado, dtHora, descricao, fkComponentesMonitoramentos, fkMaquinaMonitoramentos, fkEmpresaMonitoramentos, fkUnidadeMedida) values
                (?,?,"pacotes enviados",4,1,1,1)
            """,
        novaRede.pacotesEnviados,
        novaRede.dataHora
        )

        var rowPacotesRecebidos = jdbcTemplate.update(
                """
                insert into monitoramento (dadoColetado, dtHora, descricao, fkComponentesMonitoramentos, fkMaquinaMonitoramentos, fkEmpresaMonitoramentos, fkUnidadeMedida) values
                (?,?,"pacotes recebidos",4,1,1,1)
            """,
        novaRede.pacotesRecebidos,
        novaRede.dataHora
        )

        println("""
            $rowBytesEnviados de bytes enviados foi registrado no banco
            $rowBytesRecebidos de bytes recebidos foi registrado no banco
            $rowPacotesEnviados de pacotes enviados foi registrado no banco
            $rowPacotesRecebidos de pacotes recebidos foi registrado no banco
        """.trimIndent())

    }
    

}
