/* INSERTS OBRIGATÓRIOS PARA O FUNCIONAMENTO DO PROGRAMA ! */


-- tabela UnidadeDeMedida
INSERT INTO unidadeMedida
VALUES
(null, 'Bytes', 'B'),
(null, 'Porcemtagem', '%');
SELECT * FROM unidadeMedida;


/* DADOS SIMULADOS PORÉM IMPORTANTES NA EXECUÇÃO DA API JÁ QUE ELA PRECISA DE UMA EMPRESA EXISTENTE*/
-- Inserir dados na tabela empresa
-- INSERT INTO empresa VALUES (null, 'Empresa Exemplo', '12345678901234', 1);
SELECT * FROM empresa;


-- Inserir dados na tabela endereco
-- INSERT INTO endereco VALUES (null, '12345678', 123, 'Rua Exemplo', 'Bairro Exemplo', 'Cidade Exemplo', 'Estado Exemplo', 'Pais Exemplo', 'Complemento Exemplo',1);
SELECT * FROM endereco;

-- Inserir dados na tabela nivelAcesso
INSERT INTO nivelAcesso VALUES
(null, 'RPL', 'Representante Legal'),
(null, 'SSO', 'Sala de Supervisão Opercional'),
(null, 'CCO', 'Centro de Controle Operacioal');
SELECT * FROM nivelAcesso;

-- Inserir dados na tabela colaborador
-- INSERT INTO colaborador VALUES (null, 'Nome Colaborador Exemplo', '34123', 'n@email.com', '12345678901', sha2('senha321', 256), 1, 1);
SELECT * FROM colaborador;

-- Inserir dados na tabela planos

INSERT INTO planos 
VALUES
 (null, 1, 0, 0),
  (null, 0, 1, 0),
   (null, 0, 0, 1);
SELECT * FROM planos;

use nocline;


-- Inserir dados na tabela cartao
-- INSERT INTO cartao VALUES (null, 1234567890123456, '2025-12-01', 123, 'visa', 'Nome Titular', 1);
SELECT * FROM cartao;

-- Inserir dados na tabela maquina
INSERT INTO maquina 
VALUES (null, '177.181.7.16', 'Windows', 'Modelo Exemplo', 'CCO', 1);
SELECT * FROM maquina;

-- Inserir dados na tabela componente
INSERT INTO componente VALUES
(null, 'CPU', 1, 1),
(null, 'DISCO', 1, 1),
(null, 'RAM', 1, 1),
(null, 'REDE', 1, 1);
SELECT * FROM componente;


SELECT CONCAT(dadoColetado, ' ', Representacao) AS DadoCompleto, dtHora, nomeComponente, descricao
FROM Monitoramento
JOIN UnidadeMedida ON fkUnidadeMedida = idUnidade
JOIN Componente ON fkComponentesMonitoramentos = idComponente;
