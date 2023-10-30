/* INSERTS OBRIGATÓRIOS PARA O FUNCIONAMENTO DO PROGRAMA ! */
USE nocLine;
select * from plano;
INSERT INTO plano VALUES 
(null, "Essentials", 10, 1230.00, 15.38), 
(null, "Master", 25, 1340.00, 12.16), 
(null, "Plus", 50, 1480.00, 10.55);
select * from contrato;
 alter table contrato modify column id_contrato int auto_increment;
INSERT INTO contrato VALUES
(null, "2023-11-01", "2024-11-01", 0, 1480.00, "Crédito", 1, 3);

select 
    colaborador.*, empresa.cnpj, contrato.data_inicio, contrato.data_termino, plano.nome_plano, contrato.preco_total from colaborador 
     join empresa on fk_empresa = id_empresa
     left join contrato on fk_empresaCo = id_empresa
     left join plano on fk_plano = id_plano;
-- tabela empresa
INSERT INTO empresa VALUES (null, 'Empresa Exemplo', '12.345.678/9012-34');
select * from colaborador;
update colaborador set email = 'fernanda@metro.com' where id_colaborador =2;
alter table endereco modify column cidade varchar(200);
select * from maquina;
update maquina set ip = '131.72.61.67' where id_maquina = 2;


-- tabela nivel de acesso
INSERT INTO nivel_acesso VALUES
(null, 'RPL', 'Representante Legal'),
(null, 'SSO', 'Sala de Supervisão Opercional'),
(null, 'CCO', 'Centro de Controle Operacioal');
SELECT * FROM nivel_acesso;

-- tabela colaborador
INSERT INTO colaborador VALUES (null, 'Nome Colaborador Exemplo', '123.456.789-01', 'no@email.com', '12-34567-8901', 'senha321', 1, 1);
SELECT * FROM colaborador;

-- tabela endereco
INSERT INTO endereco VALUES (null, '12345-678', 123, 'Rua Exemplo', 'Bairro Exemplo', 'Cidade Exemplo', 'Estado Exemplo', 'Pais Exemplo', 'Complemento Exemplo',1);
SELECT * FROM endereco;

-- tabela unidade de medida
INSERT INTO unidade_medida VALUES
(null, 'Bytes', 'B'),
(null, 'Porcentagem', '%'),
(null, 'MegaBytes', 'MB');

-- tabela maquina
INSERT INTO maquina VALUES (null, '177.181.7.16', 'Windows', 'DESKTOP-67VH7K5', 'Modelo Exemplo', 'CCO', 1);
SELECT * FROM maquina;
select * from metrica;
-- tabela componente
INSERT INTO componente VALUES
(null, 'RAM', 1, 4, 1),
(null, 'CPU', 1, 4, 2),
(null, 'DISCO', 1, 4, 3),
(null, 'REDE', 1, 4, 4);
SELECT * FROM maquina;
SELECT id_unidade FROM unidade_medida WHERE representacao = '%';
SELECT id_componente from componente WHERE nome_componente = 'DISCO' and fk_maquina_componente = 1;
-- select completo
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
