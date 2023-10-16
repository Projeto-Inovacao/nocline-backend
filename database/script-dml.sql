/* INSERTS OBRIGATÓRIOS PARA O FUNCIONAMENTO DO PROGRAMA ! */
use nocLine;

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
-- INSERT INTO colaborador VALUES (null, 'Nome Colaborador Exemplo', '12345678901', 'nome.colaborador@email.com', '12345678901', sha2('senha123', 256), 1, 1);
SELECT * FROM colaborador;
select * from planos;
select * from colaborador;
SELECT * from empresa;



select * from endereco;



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
INSERT INTO maquina VALUES (null, '177.181.7.16', 'Windows', 'gyulia_piqueira', 'Modelo Exemplo', 'CCO', 2);
SELECT * FROM maquina;

-- Inserir dados na tabela componente
INSERT INTO componente VALUES
(null, 'CPU', 2, 2),
(null, 'DISCO', 2, 2),
(null, 'RAM', 2, 2),
(null, 'REDE', 2, 2);
SELECT * FROM componente;


SELECT CONCAT(dadoColetado, ' ', Representacao) AS DadoCompleto, dtHora, nomeComponente, descricao
FROM Monitoramento
JOIN UnidadeMedida ON fkUnidadeMedida = idUnidade
JOIN Componente ON fkComponentesMonitoramentos = idComponente;


SELECT
   *
FROM empresa
LEFT JOIN colaborador ON empresa.idEmpresa = colaborador.fkEmpresa
LEFT JOIN endereco ON empresa.idEmpresa = endereco.fkEmpresaE
LEFT JOIN cartao ON empresa.idEmpresa = cartao.fkEmpresaC;

SELECT c.fkEmpresa AS idEmpresa
FROM colaborador c
WHERE c.email = 'gyu@out';

-- UPDATE colaborador
-- SET email = 'newemail@example.com',
    -- senha = 'newpassword',
    -- celular = 'newphonenumber'
-- WHERE idColaborador = <your_user_id>;


INSERT INTO cartao (nCartao, validade, cvv, bandeira, nomeTitular, fkEmpresaC) VALUES ( '1234567890123455', '1204', '123', 'visa', 'marcos', (select idEmpresa from empresa WHERE CNPJ = '98981234002233'));


SELECT dadoColetado, Representacao, dtHora, nomeComponente, descricao
FROM Monitoramento
JOIN unidadeMedida ON fkUnidadeMedida = idUnidade
JOIN Componente ON fkComponentesMonitoramentos = idComponente;

select * from monitoramento;
 CREATE VIEW VW_DISCO_CHART AS
SELECT
  ROUND((M1.dadoColetado / M2.dadoColetado) * 100, 2) AS "livre",
  ROUND(((M2.dadoColetado - M1.dadoColetado) / M2.dadoColetado) * 100, 2) AS "usado",
  M1.dtHora,
  Componente.nomeComponente, idMaquina, hostname, razaoSocial
FROM
  Monitoramento AS M1
  JOIN monitoramento AS M2 ON M1.fkMaquinaMonitoramentos = M2.fkMaquinaMonitoramentos
  JOIN unidadeMedida ON M1.fkUnidadeMedida = idUnidade
  JOIN componente ON M1.fkComponentesMonitoramentos = Componente.idComponente
  JOIN maquina as M on M1.fkMaquinaMonitoramentos = M.idMaquina
  JOIN empresa on M.fkEmpresa = empresa.idEmpresa
WHERE
  M1.descricao = "disco livre"
  AND M2.descricao = "disco total";
  
  CREATE VIEW VW_CPU_CHART AS
  SELECT dadoColetado, Representacao, DATE_FORMAT(dtHora, "%H:%i:%s") as dtHora, nomeComponente, descricao, idMaquina, hostname, razaoSocial
FROM monitoramento
JOIN unidadeMedida ON fkUnidadeMedida = idUnidade
JOIN componente ON fkComponentesMonitoramentos = idComponente
JOIN maquina as M on fkMaquinaMonitoramentos = M.idMaquina
JOIN empresa on M.fkEmpresa = empresa.idEmpresa WHERE nomeComponente = 'CPU';


CREATE VIEW VW_RAM_CHART AS
SELECT
    ROUND(((1 - M1.dadoColetado / M2.dadoColetado) * 100), 2) AS "usado",
    ROUND((M1.dadoColetado / M2.dadoColetado) * 100, 2) AS "livre",
    M2.dadoColetado AS "total",
    DATE_FORMAT(M1.dtHora, "%H:%i:%s") AS dtHora,
    componente.nomeComponente,
    M.idMaquina,
    M.hostname,
    empresa.razaoSocial
FROM monitoramento AS M1	
JOIN monitoramento AS M2 ON M1.fkMaquinaMonitoramentos = M2.fkMaquinaMonitoramentos
JOIN componente ON M1.fkComponentesMonitoramentos = componente.idComponente
JOIN maquina AS M ON M1.fkMaquinaMonitoramentos = M.idMaquina
JOIN empresa ON M.fkEmpresa = empresa.idEmpresa
WHERE componente.nomeComponente = 'RAM'
  AND M2.descricao = 'memoria total'
  AND M1.descricao = 'memoria disponivel';
  
select * from VW_RAM_CHART;
select * from VW_CPU_CHART;
select * from VW_DISCO_CHART;
  desc maquina;
  select * from componente;
   INSERT INTO maquina (ip, so, hostname, modelo, setor, fkEmpresa) VALUES ( '1111', 'linux', 'hostname', 'xxx', 'cco', '9');
  delete from componente where idComponente=16;
  
  select 
    email, senha from colaborador 
     join empresa on fkEmpresa = idEmpresa
    WHERE (email = 99 AND senha = 99) ;

use nocline;

delete from unidadeMedida where idUnidade=4;
