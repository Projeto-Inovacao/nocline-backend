use nocLine;

SELECT CONCAT(dadoColetado, ' ', Representacao) AS DadoCompleto, dtHora, nomeComponente, descricao
FROM Monitoramento
JOIN unidadeMedida ON fkUnidadeMedida = idUnidade
JOIN Componente ON fkComponentesMonitoramentos = idComponente;

SELECT
  ROUND((M1.dadoColetado / M2.dadoColetado) * 100, 2) AS "espaço livre %",
  ROUND(((M2.dadoColetado - M1.dadoColetado) / M2.dadoColetado) * 100, 2) AS "espaço usado %",
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

select * from maquina;

CREATE VIEW VW_DISCO_CHART AS  
SELECT
  ROUND((M1.dadoColetado / M2.dadoColetado) * 100, 2) AS "livre",
  ROUND(((M2.dadoColetado - M1.dadoColetado) / M2.dadoColetado) * 100, 2) AS "usado",
  M1.dtHora,
  componente.nomeComponente, idMaquina, hostname, razaoSocial
FROM
  monitoramento AS M1
  JOIN monitoramento AS M2 ON M1.fkMaquinaMonitoramentos = M2.fkMaquinaMonitoramentos
  JOIN unidadeMedida ON M1.fkUnidadeMedida = idUnidade
  JOIN componente ON M1.fkComponentesMonitoramentos = componente.idComponente
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


CREATE VIEW VW_REDE_CHART AS
SELECT
    CASE WHEN descricao = 'bytes enviados' THEN dadoColetado END AS enviados,
    CASE WHEN descricao = 'bytes recebidos' THEN dadoColetado END AS recebidos,
    DATE_FORMAT(dtHora, "%H:%i:%s") as dtHora,
    Representacao,
    nomeComponente,
    idMaquina,
    hostname,
    razaoSocial
FROM monitoramento
JOIN unidadeMedida ON fkUnidadeMedida = idUnidade
JOIN componente ON fkComponentesMonitoramentos = idComponente
JOIN maquina as M on fkMaquinaMonitoramentos = M.idMaquina
JOIN empresa ON M.fkEmpresa = empresa.idEmpresa
WHERE nomeComponente = 'REDE';

CREATE VIEW VW_DESEMPENHO_CHART AS
SELECT
    dtHora AS dtHora,
    'CPU' AS recurso,
    idMaquina AS idMaquina,
    dadoColetado AS uso
FROM (
    SELECT
        dtHora,
        idMaquina,
        dadoColetado,
        ROW_NUMBER() OVER (PARTITION BY idMaquina ORDER BY dtHora DESC) AS rn
    FROM VW_CPU_CHART
) AS C
WHERE C.rn = 1
UNION ALL
SELECT
    dtHora AS dtHora,
    'RAM' AS recurso,
    idMaquina AS idMaquina,
    usado AS uso
FROM (
    SELECT
        dtHora,
        idMaquina,
        usado,
        ROW_NUMBER() OVER (PARTITION BY idMaquina ORDER BY dtHora DESC) AS rn
    FROM VW_RAM_CHART
) AS R
WHERE R.rn = 1
UNION ALL
SELECT
    dtHora AS dtHora,
    'DISCO' AS recurso,
    idMaquina AS idMaquina,
    usado AS uso_disco
FROM (
    SELECT
        dtHora,
        idMaquina,
        usado,
        ROW_NUMBER() OVER (PARTITION BY idMaquina ORDER BY dtHora DESC) AS rn
    FROM VW_DISCO_CHART
) AS D
WHERE D.rn = 1;