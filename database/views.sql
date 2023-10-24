use nocline;

CREATE VIEW VW_DISCO_CHART AS  
SELECT
  ROUND((M1.dado_coletado / M2.dado_coletado) * 100, 2) AS "livre",
  ROUND(((M2.dado_coletado - M1.dado_coletado) / M2.dado_coletado) * 100, 2) AS "usado",
  M1.data_hora,
  componente.nome_componente, id_maquina, hostname, razao_social
FROM
  monitoramento AS M1
  JOIN monitoramento AS M2 ON M1.fk_maquina_monitoramento = M2.fk_maquina_monitoramento
  JOIN unidade_medida ON M1.fk_unidade_medida = id_unidade
  JOIN componente ON M1.fk_componentes_monitoramento = componente.id_componente
  JOIN maquina as M on M1.fk_maquina_monitoramento = M.id_maquina
  JOIN empresa on M.fk_empresaM = empresa.id_empresa
WHERE
  M1.descricao = "disco livre"
  AND M2.descricao = "disco total";
 
CREATE VIEW VW_CPU_CHART AS
SELECT dado_coletado, Representacao, DATE_FORMAT(data_hora, "%H:%i:%s") as data_hora, nome_componente, descricao, id_maquina, hostname, razao_social
FROM monitoramento
JOIN unidade_medida ON fk_unidade_medida = id_unidade
JOIN componente ON fk_componentes_monitoramento = id_componente
JOIN maquina as M on fk_maquina_monitoramento = M.id_maquina
JOIN empresa on M.fk_empresaM = empresa.id_empresa WHERE nome_componente = 'CPU';

CREATE VIEW VW_RAM_CHART AS
SELECT
    ROUND(((1 - M1.dado_coletado / M2.dado_coletado) * 100), 2) AS "usado",
    ROUND((M1.dado_coletado / M2.dado_coletado) * 100, 2) AS "livre",
    M2.dado_coletado AS "total",
    DATE_FORMAT(M1.data_hora, "%H:%i:%s") AS data_hora,
    componente.nome_componente,
    M.id_maquina,
    M.hostname,
    empresa.razao_social
FROM monitoramento AS M1	
JOIN monitoramento AS M2 ON M1.fk_maquina_monitoramento = M2.fk_maquina_monitoramento
JOIN componente ON M1.fk_componentes_monitoramento = componente.id_componente
JOIN maquina AS M ON M1.fk_maquina_monitoramento = M.id_maquina
JOIN empresa ON M.fk_empresaM = empresa.id_empresa
WHERE componente.nome_componente = 'RAM'
  AND M2.descricao = 'memoria total'
  AND M1.descricao = 'memoria disponivel';


CREATE VIEW VW_REDE_CHART AS
SELECT
    CASE WHEN descricao = 'bytes enviados' THEN dado_coletado END AS enviados,
    CASE WHEN descricao = 'bytes recebidos' THEN dado_coletado END AS recebidos,
    DATE_FORMAT(data_hora, "%H:%i:%s") as data_hora,
    Representacao,
    nome_componente,
    id_maquina,
    hostname,
    razao_social
FROM monitoramento
JOIN unidade_medida ON fk_unidade_medida = id_unidade
JOIN componente ON fk_componentes_monitoramento = id_componente
JOIN maquina as M on fk_maquina_monitoramento = M.id_maquina
JOIN empresa ON M.fk_empresaM = empresa.id_empresa
WHERE nome_componente = 'REDE';

CREATE VIEW VW_DESEMPENHO_CHART AS
SELECT
    data_hora AS data_hora,
    'CPU' AS recurso,
    id_maquina AS id_maquina,
    dado_coletado AS uso
FROM (
    SELECT
        data_hora,
        id_maquina,
        dado_coletado,
        ROW_NUMBER() OVER (PARTITION BY id_maquina ORDER BY data_hora DESC) AS rn
    FROM VW_CPU_CHART
) AS C
WHERE C.rn = 1
UNION ALL
SELECT
    data_hora AS data_hora,
    'RAM' AS recurso,
    id_maquina AS id_maquina,
    usado AS uso
FROM (
    SELECT
        data_hora,
        id_maquina,
        usado,
        ROW_NUMBER() OVER (PARTITION BY id_maquina ORDER BY data_hora DESC) AS rn
    FROM VW_RAM_CHART
) AS R
WHERE R.rn = 1
UNION ALL
SELECT
    data_hora AS data_hora,
    'DISCO' AS recurso,
    id_maquina AS id_maquina,
    usado AS uso_disco
FROM (
    SELECT
        data_hora,
        id_maquina,
        usado,
        ROW_NUMBER() OVER (PARTITION BY id_maquina ORDER BY data_hora DESC) AS rn
    FROM VW_DISCO_CHART
) AS D
WHERE D.rn = 1;

create view VW_JANELAS_CHART as select nome_janela, status_abertura, fk_maquinaJ, fk_empresaJ from janela;

select * from VW_DISCO_CHART;
select * from VW_CPU_CHART;
select * from VW_RAM_CHART;
select * from VW_REDE_CHART;
select * from VW_DESEMPENHO_CHART;
select * from VW_JANELAS_CHART;




