import org.apache.commons.dbcp2.BasicDataSource
import org.springframework.jdbc.core.JdbcTemplate

object Conexao {

    var jdbcTemplate: JdbcTemplate? = null
        get() {
            if (field == null){
                val dataSource = BasicDataSource()
                dataSource.driverClassName = "com.mysql.cj.jdbc.Driver"
                dataSource.url= "jdbc:mysql://localhost:3306/nocLine"
                dataSource.username = "noc_line"
                dataSource.password = "noc_line134#"
                val novoJdbcTemplate = JdbcTemplate(dataSource)
                field = novoJdbcTemplate
            }
            return  field
        }

    fun criarTabelas() {
        val jdbcTemplate = Conexao.jdbcTemplate ?: throw IllegalStateException("O jdbcTemplate não foi inicializado corretamente.")

        // Criação da tabela janelas
        jdbcTemplate.execute("""
    CREATE TABLE IF NOT EXISTS janelas (
      idJanelas INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
      nomeJanela VARCHAR(250) NULL,
      dtHora DATETIME NULL,
      fkMaquina INT NOT NULL,
      fkEmpresa INT NOT NULL,
      CONSTRAINT fkJanelasMaquina
        FOREIGN KEY (fkMaquina , fkEmpresa)
        REFERENCES maquina (idMaquina , fkEmpresa)
    )
    """)

        // Criação da tabela rede
        jdbcTemplate.execute("""
        CREATE TABLE IF NOT EXISTS monitoramento (
          idMonitoramento INT NOT NULL AUTO_INCREMENT,
          dadoColetado DOUBLE NOT NULL,
          dtHora DATETIME NOT NULL,
          descricao VARCHAR(45) NOT NULL,
          fkComponentesMonitoramentos INT NOT NULL,
          fkMaquinaMonitoramentos INT NOT NULL,
          fkEmpresaMonitoramentos INT NOT NULL,
          fkUnidadeMedida INT NOT NULL,
          CONSTRAINT pkMonitoramento
            PRIMARY KEY (idMonitoramento, fkComponentesMonitoramentos, fkMaquinaMonitoramentos, fkEmpresaMonitoramentos, fkUnidadeMedida),
          CONSTRAINT fkMonitoramentoComponentes
            FOREIGN KEY (fkComponentesMonitoramentos , fkMaquinaMonitoramentos , fkEmpresaMonitoramentos)
            REFERENCES componente (idComponente , fkMaquinaComponente , fkEmpresaComponente)
            ,
          CONSTRAINT fkMonitoramentoUnidadeDeMedida
            FOREIGN KEY (fkUnidadeMedida)
            REFERENCES unidadeMedida (idUnidade)
            );
    """)

        // Criação da tabela processos
        jdbcTemplate.execute("""
            CREATE TABLE IF NOT EXISTS processos (
              PID INT PRIMARY KEY NOT NULL,
              nome VARCHAR(150) NULL,
              usoCPU DOUBLE NULL,
              usoMemoria DOUBLE NULL,
              memoriaVirtual DOUBLE NULL,
              fkMaquina INT NOT NULL,
              fkEmpresa INT NOT NULL,
              CONSTRAINT fkProcessosMaquina
                FOREIGN KEY (fkMaquina , fkEmpresa)
                REFERENCES maquina (idMaquina , fkEmpresa)
            )
        """.trimIndent())
    }

}