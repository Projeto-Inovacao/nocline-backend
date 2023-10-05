CREATE DATABASE IF NOT exists nocLine;
-- DROP DATABASE nocLine;
USE nocLine;

CREATE TABLE IF NOT exists  Empresa (
  idEmpresa INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  razaoSocial VARCHAR(45) NOT NULL,
  CNPJ CHAR(14) NOT NULL UNIQUE
  );
  
CREATE TABLE IF NOT EXISTS Endereco (
  idEndereco INT AUTO_INCREMENT NOT NULL,
  cep CHAR(8) NOT NULL,
  num INT NOT NULL,
  rua VARCHAR(45) NOT NULL,
  bairro VARCHAR(45) NOT NULL,
  cidade VARCHAR(45) NOT NULL,
  estado VARCHAR(45) NOT NULL,
  pais VARCHAR(45) NOT NULL,
  complemento VARCHAR(45)  NULL,
  fkEmpresa INT NOT NULL,
  CONSTRAINT pkEndereco
    PRIMARY KEY (idEndereco, fkEmpresa),
  CONSTRAINT fk_Endereco_Empresa1
    FOREIGN KEY (fkEmpresa)
    REFERENCES Empresa (idEmpresa));
    
    CREATE TABLE IF NOT EXISTS Maquina (
  idMaquina INT AUTO_INCREMENT NOT NULL,
  numeroSerie VARCHAR(45) NOT NULL,
  so VARCHAR(45) NOT NULL,
  modelo VARCHAR(45) NULL,
 setor VARCHAR(45) NULL,
  fkEmpresa INT NOT NULL,
  CONSTRAINT pkMaquina
    PRIMARY KEY (idMaquina, fkEmpresa),
  CONSTRAINT fkMaquinaEmpresa
    FOREIGN KEY (fkEmpresa)
    REFERENCES Empresa (idEmpresa));
    
    CREATE TABLE IF NOT EXISTS Janelas (
  idJanelas INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
  nomeJanela VARCHAR(45) NULL,
  Data DATE NULL,
  Hora TIME NULL,
  fkMaquina INT NOT NULL,
  fkEmpresa INT NOT NULL,
  CONSTRAINT fkJanelasMaquina
    FOREIGN KEY (fkMaquina , fkEmpresa)
    REFERENCES Maquina (idMaquina , fkEmpresa));
    
    CREATE TABLE IF NOT EXISTS Componente (
  idComponente INT AUTO_INCREMENT NOT NULL,
  nomeComponente VARCHAR(45) NULL,
  fkMaquinaComponente INT NOT NULL,
  fkEmpresaComponente INT NOT NULL,
  CONSTRAINT pkComponente
    PRIMARY KEY (idComponente, fkMaquinaComponente, fkEmpresaComponente),
  CONSTRAINT fk_Componentes_Maquina1
    FOREIGN KEY (fkMaquinaComponente , fkEmpresaComponente)
    REFERENCES Maquina (idMaquina , fkEmpresa));
    
    CREATE TABLE IF NOT EXISTS UnidadeDeMedida (
  idUnidade INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  Tipo_de_Dado VARCHAR(45) NULL,
  Representacao CHAR(2) NULL
 );
  
  
  CREATE TABLE IF NOT EXISTS Monitoramento (
  idMonitoramento INT AUTO_INCREMENT NOT NULL,
  dadoColetado DOUBLE NOT NULL,
  dtHora DATETIME NOT NULL,
  descricao VARCHAR(45) NOT NULL,
  fkComponentesMonitoramentos INT NOT NULL,
  fkMaquinaMonitoramentos INT NOT NULL,
  fkEmpresaMonitoramentos INT NOT NULL,
  fkUnidadeMedida INT NOT NULL,
  CONSTRAINT pkMonitoramento
    PRIMARY KEY (idMonitoramento, fkComponentesMonitoramentos, fkMaquinaMonitoramentos, fkEmpresaMonitoramentos, fkUnidadeMedida),
  CONSTRAINT fkMonitoramentoComponentes
    FOREIGN KEY (fkComponentesMonitoramentos , fkMaquinaMonitoramentos , fkEmpresaMonitoramentos)
    REFERENCES Componente (idComponente , fkMaquinaComponente , fkEmpresaComponente),
  CONSTRAINT fkMonitoramentoUnidadeDeMedida
    FOREIGN KEY (fkUnidadeMedida)
    REFERENCES UnidadeDeMedida (idUnidade));
    
    CREATE TABLE IF NOT EXISTS Aviso (
  idAviso INT AUTO_INCREMENT NOT NULL,
  dtHora DATETIME NULL,
  Descricao VARCHAR(45) NULL,
  fkMonitoramento INT NOT NULL,
  CONSTRAINT pkAviso
    PRIMARY KEY (idAviso, fkMonitoramento),
  CONSTRAINT fkMonitoramentoAvisos
    FOREIGN KEY (fkMonitoramento)
    REFERENCES Monitoramento (idMonitoramento));
    
CREATE TABLE IF NOT EXISTS Permissao (
  idPermissao INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  Visualizar TINYINT NULL,
  Excluir TINYINT NULL,
  Alterar TINYINT NULL,
  Cadastrar TINYINT NULL,
  maquinas TINYINT NULL,
  equipe_corporativa TINYINT NULL
  );
  
  CREATE TABLE IF NOT EXISTS nivelAcesso (
  idNivelAcesso INT AUTO_INCREMENT NOT NULL,
  Sigla CHAR(3) NULL,
  descricao VARCHAR(100) NULL,
  fkPermissao INT NOT NULL,
  CONSTRAINT pkNivelAcesso
    PRIMARY KEY (idnivelAcesso, fkPermissao),
  CONSTRAINT fk_nivelAcesso_Permissao1
    FOREIGN KEY (fkPermissao)
    REFERENCES Permissao (idPermissao)
);

CREATE TABLE IF NOT EXISTS Colaborador (
  idColaborador INT AUTO_INCREMENT NOT NULL,
  nomeColaborador VARCHAR(200) NOT NULL,
  cpfColaborador CHAR(14) NOT NULL,
  emailColaborador VARCHAR(45) NOT NULL,
  celularColaborador CHAR(11) NULL,
  senhaColaborador VARCHAR(255) NOT NULL,
  fkEmpresa INT NOT NULL,
  fkNivelAcesso INT NOT NULL,
  CONSTRAINT pkColaborador
    PRIMARY KEY (idColaborador, fkEmpresa),
  CONSTRAINT fkUsuariosEmpresa
    FOREIGN KEY (fkEmpresa)
    REFERENCES Empresa (idEmpresa),
  CONSTRAINT fkColaboradorNivelAcesso
    FOREIGN KEY (fkNivelAcesso)
    REFERENCES nivelAcesso (idNivelAcesso));
  
    CREATE TABLE IF NOT EXISTS ControleAcesso (
  fkColaborador INT NOT NULL,
  fkEmpresaColaborador INT NOT NULL,
  fkMaquina INT NOT NULL,
  fkEmpresaMaquina INT NOT NULL,
  InicioSessao DATETIME NOT NULL,
  FimSessao DATETIME NULL,
  CONSTRAINT pkControleAcesso
	PRIMARY KEY (fkColaborador, fkEmpresaColaborador, fkMaquina, fkEmpresaMaquina),
  CONSTRAINT fkControleUsuarioEmpresa
    FOREIGN KEY (fkColaborador , fkEmpresaColaborador)
    REFERENCES Colaborador (idColaborador , fkEmpresa),
  CONSTRAINT fkControleMaquinaEmpresa
    FOREIGN KEY (fkMaquina , fkEmpresaMaquina)
    REFERENCES Maquina (idMaquina , fkEmpresa));
    
    CREATE TABLE IF NOT EXISTS Planos (
  idPlano INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Essentials TINYINT NULL,
  Master TINYINT NULL,
  plus TINYINT NULL,
  fkEmpresa INT NOT NULL,
  CONSTRAINT fkPlanosEmpresa
    FOREIGN KEY (fkEmpresa)
    REFERENCES Empresa (idEmpresa));

CREATE TABLE IF NOT EXISTS Cartao (
  idCartao INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  NumCartao CHAR(4) NULL,
  Validade DATE NULL,
  CVV CHAR(3) NULL,
  Bandeira VARCHAR(50) NULL,
  fkEmpresa INT NOT NULL,
  CONSTRAINT fkCartaoEmpresa
    FOREIGN KEY (fkEmpresa)
    REFERENCES Empresa (idEmpresa));