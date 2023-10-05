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
INSERT INTO Empresa (razãoSocial, CNPJ)
VALUES ('Via Mobilidade', '12345678901234');

-- Inserir dados na tabela Endereco
INSERT INTO Endereco (CEP, num, rua, bairro, cidade, estado, pais, fkEmpresa)
VALUES ('12345678', 123, 'Rua Exemplo', 'Bairro Exemplo', 'Cidade Exemplo', 'Estado Exemplo', 'Pais Exemplo', 1);

-- Inserir dados na tabela Colaborador
INSERT INTO Colaborador (nome, email_corporativo, senha, telCel, fkEmpresa, fkNivelAcesso)
VALUES ('Roberto Nogueira', 'roberto.nogueira@email.com', sha2('senha123', 256), '12345678901', 1, 1);

-- Inserir dados na tabela Maquina
INSERT INTO Maquina (IP, SO, modelo, fkEmpresa)
VALUES ('192.168.1.1', 'Windows', 'Modelo Exemplo', 1);

-- Inserir dados na tabela Componente
INSERT INTO Componente (nomeComponente, fkMaquinaComponente, fkEmpresaComponente) VALUES
('CPU', 1, 1),
('DISCO', 1, 1),
('RAM', 1, 1),
('REDE', 1, 1);

-- Inserir dados na tabela ControleAcesso
INSERT INTO ControleAcesso (fkColaborador, fkEmpresaColaborador, fkMaquina, fkEmpresaMaquina, InicioSessao)
VALUES (1, 1, 1, 1, '2023-10-04 10:00:00');

-- Inserir dados na tabela Planos
INSERT INTO Planos (Essentials, Master, plus, fkEmpresa)
VALUES (1, 0, 1, 1);

-- Inserir dados na tabela Cartao
INSERT INTO Cartao (NumCartao, Validade, CVV, Bandeira, fkEmpresa)
VALUES ('1234', '2025-12-31', '123', 'MasterCard', 1);


