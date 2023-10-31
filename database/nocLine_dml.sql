/* INSERTS OBRIGATÓRIOS PARA O FUNCIONAMENTO DO PROGRAMA ! */
USE nocLine;

INSERT INTO plano VALUES 
(null, "Essentials", 10, 1230.00, 15.38), 
(null, "Master", 25, 1340.00, 12.16), 
(null, "Plus", 50, 1480.00, 10.55);
select * from plano;

INSERT INTO nivel_acesso VALUES
(null, 'RPL', 'Representante Legal'),
(null, 'SSO', 'Sala de Supervisão Opercional'),
(null, 'CCO', 'Centro de Controle Operacioal');
SELECT * FROM nivel_acesso;

INSERT INTO unidade_medida VALUES
(null, 'Bytes', 'B'),
(null, 'Porcentagem', '%'),
(null, 'MegaBytes', 'MB');
select * from unidade_medida;

INSERT INTO componente VALUES
(null, 'RAM', 1, 1, 1),
(null, 'CPU', 1, 1, 2),
(null, 'DISCO', 1, 1, 3),
(null, 'REDE', 1, 1, 4);
SELECT * FROM componente;
desc componente;

-- selects
select * from colaborador;
select * from maquina;
select * from empresa;
select * from metrica;
select * from monitoramento;
select * from processos;

SELECT 
  e.id_empresa, e.razao_social, e.cnpj,
  c.id_colaborador, c.nome, c.cpf, c.email, c.celular,
  n.id_nivel_acesso, n.sigla, n.descricao,
  en.id_endereco, en.cep, en.num, en.rua, en.bairro, en.cidade, en.estado, en.pais, en.complemento,
  m.id_maquina, m.ip, m.so, m.hostname, m.modelo, m.setor,
  co.id_componente, co.nome_componente
FROM empresa e
INNER JOIN colaborador c ON e.id_empresa = c.fk_empresa
INNER JOIN nivel_acesso n ON c.fk_nivel_acesso = n.id_nivel_acesso
INNER JOIN endereco en ON e.id_empresa = en.fk_empresaE
INNER JOIN maquina m ON e.id_empresa = m.fk_empresaM
INNER JOIN componente co ON m.id_maquina = co.fk_maquina_componente;

-- selects 
select * from componente;
select * from monitoramento;
select * from processos;
delete from colaborador where id_colaborador = 14;
delete from empresa where id_empresa = 20;
select * from colaborador;
select * from nivel_acesso;

select 
    * from colaborador 
     join empresa on fk_empresa = id_empresa;
     
     SELECT COUNT(*) as total_registros
FROM monitoramento
WHERE descricao = 'uso ram' AND dado_coletado > 5100;

-- metrica para a RAM
INSERT INTO metrica (risco, perigo, fk_unidade_medida)
VALUES (88.43, 90.71, 2);

-- metrica de cpu
INSERT INTO metrica (risco, perigo, fk_unidade_medida)
VALUES (4.04, 5.1, 2);

-- metrica de disco
INSERT INTO metrica (risco, perigo, fk_unidade_medida)
VALUES (50.96, 50.99, 2);

-- metrica de disco
INSERT INTO metrica (risco, perigo, fk_unidade_medida)
VALUES (50.96, 50.99, 2);

-- metrica de rede
INSERT INTO metrica (risco, perigo, fk_unidade_medida)
VALUES (176.45, 250.23, 2);

select * from componente;
alter table componente add column fk_metrica_componente int;
alter table componente add CONSTRAINT fk_componente_metrica
    FOREIGN KEY (fk_metrica_componente)
    REFERENCES metrica (id_metrica);
    drop trigger criarAlerta;
select * from alerta;
select * from monitoramento;
insert into monitoramento values(null, 19.0, now(), 'uso cpu', 1, 1, 1, 2);
