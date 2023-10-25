import com.github.britooo.looca.api.group.janelas.Janela
import org.springframework.jdbc.core.BeanPropertyRowMapper
import org.springframework.jdbc.core.JdbcTemplate
import javax.swing.JOptionPane

class DadosLogin {

    // objeto JdbcTemplate usado para interagir com o banco de dados
    lateinit var jdbcTemplate: JdbcTemplate


    // método para iniciar o repositório, geralmente chamado no início para configurar a conexão com o banco de dados
    fun iniciar() {
        jdbcTemplate = Conexao.jdbcTemplate!!
    }

     //método
     fun validarLogin(login: Usuario) {
            var fk_empresa = 0
             val dadosLoginNoBanco = jdbcTemplate.query(
                 """
                SELECT email, senha, fk_empresa FROM colaborador WHERE email = ? AND senha = ?
            """,
                 arrayOf(login.email, login.senha, login.fk_empresa)
             ) { rs, _ -> rs.getString("email");rs.getInt("fk_empresa") } // Mapeamento da linha para a propriedade 'email'


             return if (dadosLoginNoBanco.isNotEmpty()) {
                 fk_empresa = login.fk_empresa
             } else {
                 fk_empresa = login.fk_empresa
             }
     }

    fun mostrarMaquina(): String{

        val listaMaquinas:List<Maquina> = jdbcTemplate.query(
            "select * from maquina where fk_empresa = ",
            BeanPropertyRowMapper(Maquina::class.java)
        )

        val maquinas = listaMaquinas.map {
            "Maquina ${it.id_maquina} - ${it.hostname}"
        }.joinToString("\n")
        return maquinas
    }
}