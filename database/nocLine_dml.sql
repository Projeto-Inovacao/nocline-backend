/* INSERTS OBRIGATÓRIOS PARA O FUNCIONAMENTO DO PROGRAMA ! */
USE nocLine;

-- tabela empresa
INSERT INTO empresa VALUES (null, 'Empresa Exemplo', '12.345.678/9012-34');
SELECT * FROM empresa;

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
(null, 'Porcentagem', '%');
SELECT * FROM unidade_medida;

-- tabela planos
INSERT INTO plano (id_plano, essentials, master, plus) VALUES
(null, 1, 0, 0),
(null, 0, 1, 0),
(null, 0, 0, 1);
SELECT * FROM plano;

-- tabela maquina
INSERT INTO maquina VALUES (null, '177.181.7.16', 'Windows', 'gyulia_piqueira', 'Modelo Exemplo', 'CCO', 1);
SELECT * FROM maquina;

-- tabela componente
INSERT INTO componente VALUES
(null, 'CPU', 1, 1),
(null, 'DISCO', 1, 1),
(null, 'RAM', 1, 1),
(null, 'REDE', 1, 1);
SELECT * FROM componente;

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
select * from janela;
SELECT COUNT(*) monitoramento where descricao = "uso cpu";
select * from monitoramento;
select * from processos;

