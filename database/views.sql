use nocline;

 
-- view CPU
CREATE VIEW VW_CPU_CHART AS
SELECT dado_coletado, Representacao, DATE_FORMAT(data_hora, "%H:%i:%s") as data_hora, nome_componente, descricao, id_maquina, hostname, razao_social
FROM monitoramento
JOIN unidade_medida ON fk_unidade_medida = id_unidade
JOIN componente ON fk_componentes_monitoramento = id_componente
JOIN maquina as M on fk_maquina_monitoramento = M.id_maquina
JOIN empresa on M.fk_empresaM = empresa.id_empresa WHERE nome_componente = 'CPU';

select * from VW_CPU_CHART;

-- view RAM
CREATE VIEW VW_RAM_CHART AS
SELECT
    DISTINCT DATE_FORMAT(M1.data_hora, "%H:%i:%s") AS data_hora,
    ROUND(((1 - M1.dado_coletado / M2.dado_coletado) * 100), 2) AS "usado",
    ROUND((M1.dado_coletado / M2.dado_coletado) * 100, 2) AS "livre",
    M2.dado_coletado AS "total",
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

select * from VW_RAM_CHART;

-- view DISCO
CREATE VIEW VW_DISCO_CHART AS  
SELECT
  DISTINCT M1.data_hora,
  ROUND((M1.dado_coletado / M2.dado_coletado) * 100, 2) AS "livre",
  ROUND(((M2.dado_coletado - M1.dado_coletado) / M2.dado_coletado) * 100, 2) AS "usado",
  componente.nome_componente,
  id_maquina,
  hostname,
  razao_social
FROM
  monitoramento AS M1
  JOIN monitoramento AS M2 ON M1.fk_maquina_monitoramento = M2.fk_maquina_monitoramento
  JOIN unidade_medida ON M1.fk_unidade_medida = id_unidade
  JOIN componente ON M1.fk_componentes_monitoramento = componente.id_componente
  JOIN maquina AS M ON M1.fk_maquina_monitoramento = M.id_maquina
  JOIN empresa ON M.fk_empresaM = empresa.id_empresa
WHERE
  M1.descricao = "disco livre"
  AND M2.descricao = "disco total";

select * from VW_DISCO_CHART;

-- view REDE
CREATE VIEW VW_REDE_CHART AS
SELECT
    DATE_FORMAT(monitoramento.data_hora, "%H:%i:%s") as data_hora,
    ROUND(MAX(CASE WHEN monitoramento.descricao = 'bytes enviados' THEN monitoramento.dado_coletado / 1048576.0 END), 2) AS enviados,
    ROUND(MAX(CASE WHEN monitoramento.descricao = 'bytes recebidos' THEN monitoramento.dado_coletado / 1048576.0 END), 2) AS recebidos,
    componente.nome_componente,
    componente.fk_maquina_componente as id_maquina,
    MAX(maquina.hostname) AS hostname,
    MAX(empresa.razao_social) AS razao_social
FROM monitoramento
JOIN componente ON monitoramento.fk_componentes_monitoramento = componente.id_componente
JOIN maquina ON monitoramento.fk_maquina_monitoramento = maquina.id_maquina
JOIN empresa ON maquina.fk_empresaM = empresa.id_empresa
WHERE componente.nome_componente = 'REDE'
GROUP BY monitoramento.data_hora, componente.nome_componente, componente.fk_maquina_componente;

select * from VW_REDE_CHART;

-- view gráfico de barra dash
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

-- view janelas
create view VW_JANELAS_CHART as select nome_janela, status_abertura, fk_maquinaJ, fk_empresaJ from janela;

select * from VW_JANELAS_CHART;

-- view alertas
create view VW_ALERTAS_TABLE as
SELECT
  M.id_maquina,
  m.ip,
  M.hostname,
  M.so,
  M.setor,
  M.modelo,
  M.status_maquina,
  M.fk_empresaM,
  COUNT(DISTINCT M.id_maquina) AS qtd_maquina,
  COUNT(CASE WHEN A.tipo_alerta = "critico" THEN A.id_alerta END) AS qtd_critico,
  COUNT(CASE WHEN A.tipo_alerta = "risco" THEN A.id_alerta END) AS qtd_risco,
  COUNT(CASE WHEN A.tipo_alerta IN ("critico", "risco") THEN A.id_alerta END) AS qtd_alerta_maquina,
  COUNT(CASE WHEN A.data_hora BETWEEN DATE_SUB(LAST_DAY(SYSDATE()), INTERVAL 1 MONTH) AND LAST_DAY(SYSDATE()) THEN A.id_alerta END) AS qtd_alertas_no_mes
FROM
  maquina AS M
LEFT JOIN
  alerta AS A ON M.id_maquina = A.fk_maquina_alerta
GROUP BY
  M.id_maquina, M.hostname, M.ip, M.so, M.modelo, M.setor, M.status_maquina, M.fk_empresaM;
  
  select * from maquina;

	


