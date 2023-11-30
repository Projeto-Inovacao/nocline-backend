import org.apache.commons.dbcp2.BasicDataSource
import org.springframework.jdbc.core.JdbcTemplate

object Conexao {


    var jdbcTemplate: JdbcTemplate? = null
        get() {
            if (field == null) {
                val dataSource = BasicDataSource()
                dataSource.driverClassName = "com.mysql.cj.jdbc.Driver"
                dataSource.url = "jdbc:mysql://localhost:3306/nocline"
                dataSource.username = "noc_line"
                dataSource.password = "noc_line134#"
                val novoJdbcTemplate = JdbcTemplate(dataSource)
                field = novoJdbcTemplate
            }
            return field
        }

    fun criarTabelas() {
        val jdbcTemplate =
            jdbcTemplate ?: throw IllegalStateException("O jdbcTemplate não foi inicializado corretamente.")

        // Criação da tabela janela

        // Criação da tabela rede
        jdbcTemplate.execute(
            """
          CREATE TABLE IF NOT EXISTS monitoramento (
              id_monitoramento INT NOT NULL AUTO_INCREMENT,
              dado_coletado DOUBLE NOT NULL,
              data_hora DATETIME NOT NULL,
              descricao VARCHAR(45) NOT NULL,
              fk_componentes_monitoramento INT NOT NULL,
              fk_maquina_monitoramento INT NOT NULL,
              fk_empresa_monitoramento INT NOT NULL,
              fk_unidade_medida INT NOT NULL,
              CONSTRAINT pk_monitoramento
                PRIMARY KEY (id_monitoramento, fk_componentes_monitoramento, fk_maquina_monitoramento, fk_empresa_monitoramento, fk_unidade_medida),
              CONSTRAINT fk_monitoramento_componente
                FOREIGN KEY (fk_componentes_monitoramento, fk_maquina_monitoramento, fk_empresa_monitoramento)
                REFERENCES componente (id_componente , fk_maquina_componente , fk_empresa_componente),
              CONSTRAINT fk_monitoramento_unidade_medida
                FOREIGN KEY (fk_unidade_medida)
                REFERENCES unidade_medida (id_unidade)
        )
    """
        )


    }

}