use nocLine;

select * from monitoramento;
select * from colaborador;


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

select * from VW_DISCO_CHART;

select * from VW_DISCO_CHART
                    where idMaquina = 1
                   limit 2;

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

