import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.jdbc.core.BeanPropertyRowMapper
import org.springframework.jdbc.core.JdbcTemplate

    // classe responsável por interagir com o banco de dados para dados relacionados a janelas e redes
class DadosRepositorios {

    // objeto JdbcTemplate usado para interagir com o banco de dados
    lateinit var jdbcTemplate: JdbcTemplate

    // método para iniciar o repositório, geralmente chamado no início para configurar a conexão com o banco de dados
    fun iniciar() {
        jdbcTemplate = Conexao.jdbcTemplate!!
    }

    // método para cadastrar informações sobre uma janela no banco de dados
    fun cadastrarJanela(novaJanela: Janelas) {

    // converte a lista de nomes de janelas para JSON usando a biblioteca Jackson
        val nomesJanelasJson: String = converterListaParaJson(novaJanela.nomesJanelas)

    // executa uma instrução SQL para inserir dados da janela no banco de dados
    // as interrogações (?) são espaços reservados para os parâmetros que serão fornecidos dinamicamente
    // nomesJanelasJson, novaJanela.quantidade e novaJanela.dataHora são os valores reais que serão substituídos nos espaços reservados (?) da instrução SQL.

        jdbcTemplate.update(
            """
                insert into janelas (nomeJanelaJson, quantidade, dataHora) values
                (?,?,?)
            """, nomesJanelasJson,
            novaJanela.quantidade,
            novaJanela.dataHora
        )
    }

    fun cadastrarRede(novaRede: Redes) {

        jdbcTemplate.update(
            """
                insert into rede (nomeRede, bytesEnviados, bytesRecebidos, dataHora) values
                (?,?,?,?)
            """, novaRede.nomeRede,
            novaRede.bytesEnviados,
            novaRede.bytesRecebidos,
            novaRede.dataHora
        )
    }

    // método para converter uma lista de strings para um formato JSON
    fun converterListaParaJson(lista: List<String>): String {
        // utiliza a biblioteca Jackson para serializar a lista para JSON
        val objectMapper = ObjectMapper()
        // a lista de strings é convertida em uma string JSON
        return objectMapper.writeValueAsString(lista)
    }

}
