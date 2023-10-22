import com.fasterxml.jackson.databind.ObjectMapper
import com.github.britooo.looca.api.group.janelas.Janela
import com.github.britooo.looca.api.group.processos.Processo
import org.springframework.jdbc.core.BeanPropertyRowMapper
import org.springframework.jdbc.core.JdbcTemplate
import java.time.LocalDate
import java.time.LocalDateTime

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
        val janelasNoBanco = jdbcTemplate.queryForList(
            "SELECT nome_janela FROM janela",
            String::class.java
        )

        val janelasListadas = novaJanela?.filter { it.titulo != null && it.titulo.isNotBlank() }?.map { it.titulo }

        novaJanela?.forEach { janela ->
            if (janela.titulo != null && janela.titulo.isNotBlank()) {
                val janelaExisteNoBanco = janelasNoBanco.contains(janela.titulo)

                if (janelaExisteNoBanco) {
                    // A janela existe no banco, atualize-a definindo status_abertura como verdadeiro.
                    jdbcTemplate.update(
                        """
                UPDATE janela
                SET data_hora = ?,
                    status_abertura = ?,
                    fk_maquinaJ = ?,
                    fk_empresaJ = ?
                WHERE nome_janela = ?
                """,
                        LocalDateTime.now(),
                        true, // Defina status_abertura como verdadeiro para atualização.
                        1,    // Modifique fk_maquinaJ e fk_empresaJ conforme necessário.
                        1,
                        janela.titulo
                    )
                } else {
                    // A janela não existe no banco, insira-a com status_abertura como verdadeiro.
                    jdbcTemplate.update(
                        """
                INSERT INTO janela (nome_janela, data_hora, status_abertura, fk_maquinaJ, fk_empresaJ)
                VALUES (?, ?, ?, ?, ?)
                """,
                        janela.titulo,
                        LocalDateTime.now(),
                        true, // Defina status_abertura como verdadeiro para inserção.
                        1,    // Modifique fk_maquinaJ e fk_empresaJ conforme necessário.
                        1
                    )
                }
            }
        }

        if (janelasListadas != null && janelasListadas.isNotEmpty()) {
            val placeholders = janelasListadas.map { "?" }.joinToString(", ")
            val updateQuery = "UPDATE janela SET status_abertura = ? WHERE nome_janela NOT IN ($placeholders)"
            val params = arrayOf(false, *janelasListadas.toTypedArray())
            val queryJanela = jdbcTemplate.update(updateQuery, *params)
            println("$queryJanela registros atualizados na tabela de janelas")
        }

    }

    fun validarJanela(nome_janela: String): Boolean {
        val queryValidacao = jdbcTemplate.queryForObject(
            "SELECT count(*) FROM janela WHERE nome_janela = ?",
            Int::class.java,
            nome_janela
        )
        return queryValidacao > 0
    }


    fun cadastrarRede(novaRede: Redes) {

        var rowBytesEnviados = jdbcTemplate.update(
            """
                insert into monitoramento (dado_coletado, data_hora, descricao, fk_componentes_monitoramento, fk_maquina_monitoramento, fk_empresa_monitoramento, fk_unidade_medida) values
                (?,?,"bytes enviados",4,1,1,1)
            """,
            novaRede.bytesEnviados,
            novaRede.dataHora
        )

        var rowBytesRecebidos = jdbcTemplate.update(
            """
                insert into monitoramento (dado_coletado, data_hora, descricao, fk_componentes_monitoramento, fk_maquina_monitoramento, fk_empresa_monitoramento, fk_unidade_medida) values
                (?,?,"bytes recebidos",4,1,1,1)
            """,
            novaRede.bytesRecebidos,
            novaRede.dataHora
        )

        println(
            """
            $rowBytesEnviados query de bytes enviados foi registrado no banco
            $rowBytesRecebidos query de bytes recebidos foi registrado no banco
        """.trimIndent()
        )

    }

    fun cadastrarProcesso(novoProcesso: MutableList<Processo>?) {
        val processosNoBanco = jdbcTemplate.queryForList(
            "SELECT pid FROM processos",
            Int::class.java
        )

        val pidsListados = novoProcesso?.map { it.pid }

        novoProcesso?.forEach { p ->
            if (p.pid != null && (pidsListados == null || pidsListados.contains(p.pid))) {
                val validacao = validarProcesso(p.pid)

                if (validacao) {
                    val pid = p.pid
                    val processoExiste = processosNoBanco.contains(pid)

                    if (processoExiste) {
                        val queryProcesso = jdbcTemplate.update(
                            """
                        UPDATE processos
                        SET uso_cpu = ?,
                            uso_memoria = ?,
                            memoria_virtual = ?,
                            status_abertura = ?,
                            fk_maquinaP = ?,
                            fk_empresaP = ?
                        WHERE PID = ?
                        """,
                            p.usoCpu,
                            p.usoMemoria,
                            p.memoriaVirtualUtilizada,
                            true,
                            1,
                            1,
                            pid
                        )
                        println("$queryProcesso registro atualizado na tabela de processos")
                    }
                } else {
                    val queryProcesso = jdbcTemplate.update(
                        """
                    INSERT INTO processos (PID, uso_cpu, uso_memoria, memoria_virtual, status_abertura, fk_maquinaP, fk_empresaP)
                    VALUES (?, ?, ?, ?, ?, ?, ?)
                    """,
                        p.pid,
                        p.usoCpu,
                        p.usoMemoria,
                        p.memoriaVirtualUtilizada,
                        true,
                        1,
                        1
                    )
                    println("$queryProcesso registro inserido na tabela de processos")
                }
            }
        }

        if (pidsListados != null && pidsListados.isNotEmpty()) {
            val placeholders = pidsListados.map { "?" }.joinToString(", ")
            val updateQuery = "UPDATE processos SET status_abertura = false WHERE PID NOT IN ($placeholders)"
            val queryProcesso = jdbcTemplate.update(updateQuery, *pidsListados.toTypedArray())
            println("$queryProcesso registros atualizados na tabela de processos")
        }
    }

    fun validarProcesso(pid: Int): Boolean {
        val queryValidacao = jdbcTemplate.queryForObject(
            "SELECT count(*) FROM processos WHERE pid = ?",
            Int::class.java,
            pid
        )
        return queryValidacao > 0
    }

}
