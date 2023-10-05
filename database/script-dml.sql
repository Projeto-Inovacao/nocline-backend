/* INSERTS OBRIGATÓRIOS PARA O FUNCIONAMENTO DO PROGRAMA ! */

-- tabela Permissao
INSERT INTO Permissao (Visualizar, Excluir, Alterar, Cadastrar, maquinas, equipe_corporativa) VALUES 
(1, 1, 1, 1, 1, 1),
(1, 0, 0, 0, 1, 0),
(1, 1, 1, 1, 1, 0);

-- tabela nivelAcesso
INSERT INTO nivelAcesso (Sigla, descricao, fkPermissao) VALUES
('RP', 'Representante Legal', 1),
('SSO', 'Sala de Supervisão Opercional', 2),
('CCO', 'Centro de Controle Operacioal', 3);

-- tabela UnidadeDeMedida
INSERT INTO UnidadeDeMedida (Tipo_de_Dado, Representacao) VALUES
('Bytes', 'B'),
('Porcemtagem', '%');


/* DADOS SIMULADOS PORÉM IMPORTANTES NA EXECUÇÃO DA API JÁ QUE ELA PRECISA DE UMA EMPRESA EXISTENTE*/

-- Inserir dados na tabela Empresa
INSERT INTO Empresa (razaoSocial, CNPJ)
VALUES ('Via Mobilidade', '12345678901234');

-- Inserir dados na tabela Endereco
INSERT INTO Endereco (cep, num, rua, bairro, cidade, estado, pais, fkEmpresa)
VALUES ('12345678', 123, 'Rua Exemplo', 'Bairro Exemplo', 'Cidade Exemplo', 'Estado Exemplo', 'Pais Exemplo', 1);


-- Inserir dados na tabela Colaborador
INSERT INTO Colaborador (nomeColaborador, cpfColaborador, emailColaborador, celularColaborador, senhaColaborador, fkEmpresa, fkNivelAcesso)
VALUES ('Roberto Nogueira', '12345678901', 'roberto.nogueira@email.com', '12345678901', sha2('senha123', 256), '12345678901', 1, 1);

-- Inserir dados na tabela Maquina
INSERT INTO Maquina (numeroSerie, so, modelo, setor, fkEmpresa)
VALUES ('12345', 'Windows', 'Modelo Exemplo', 'Setor Exemplo', 1);

-- Inserir dados na tabela Componente
INSERT INTO Componente (nomeComponente, fkMaquinaComponente, fkEmpresaComponente) VALUES
('CPU', 1, 1),
('DISCO', 1, 1),
('RAM', 1, 1),
('REDE', 1, 1);

