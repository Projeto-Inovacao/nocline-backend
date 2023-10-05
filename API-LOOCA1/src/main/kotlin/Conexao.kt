import org.apache.commons.dbcp2.BasicDataSource
import org.springframework.jdbc.core.JdbcTemplate

object Conexao {

    var jdbcTemplate: JdbcTemplate? = null
        get() {
            if (field == null){
                val dataSource = BasicDataSource()
                dataSource.driverClassName = "com.mysql.cj.jdbc.Driver"
                dataSource.url= "jdbc:mysql://localhost:3306/nocLineS"
                dataSource.username = "noc_line"
                dataSource.password = "noc_line143#"
                val novoJdbcTemplate = JdbcTemplate(dataSource)
                field = novoJdbcTemplate
            }
            return  field
        }

    fun criarTabelas() {
        val jdbcTemplate = Conexao.jdbcTemplate ?: throw IllegalStateException("O jdbcTemplate não foi inicializado corretamente.")

        // Criação da tabela janelas
        fun criarTabelas() {
            val jdbcTemplate = Conexao.jdbcTemplate ?: throw IllegalStateException("O jdbcTemplate não foi inicializado corretamente.")

            // Criação da tabela janelas
            jdbcTemplate.execute("""
        CREATE TABLE IF NOT EXISTS janelas (
            id INT AUTO_INCREMENT PRIMARY KEY,
            nomeJanelaJson VARCHAR(1000),
            quantidade INT,
            dataHora TIMESTAMP
        )
    """)

            // Criação da tabela rede
            jdbcTemplate.execute("""
        CREATE TABLE IF NOT EXISTS rede (
            id INT AUTO_INCREMENT PRIMARY KEY,
            nomeRede VARCHAR(50),
            bytesEnviados LONG,
            bytesRecebidos LONG,
            dataHora TIMESTAMP
        )
    """)
        }

    }
    }