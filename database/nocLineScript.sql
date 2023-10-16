CREATE DATABASE IF NOT exists nocLine;
 -- DROP DATABASE nocLine;
USE nocLine;

CREATE TABLE IF NOT EXISTS planos (
  idPlano INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  essentials TINYINT NULL,
  master TINYINT NULL,
  plus TINYINT NULL
    );

CREATE TABLE IF NOT EXISTS empresa (
  idEmpresa INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  razaoSocial VARCHAR(45) NOT NULL,
  CNPJ CHAR(14) NULL UNIQUE,
  fkPlano INT NULL,
  INDEX fkPlanos (fkPlano ASC) VISIBLE,
  CONSTRAINT fkPlanos
    FOREIGN KEY (fkPlano)
    REFERENCES planos (idPlano));
  
CREATE TABLE IF NOT EXISTS endereco (
  idEndereco INT NOT NULL AUTO_INCREMENT,
  cep CHAR(8) NOT NULL,
  num INT NOT NULL,
  rua VARCHAR(45) NULL,
  bairro VARCHAR(45) NULL,
  cidade VARCHAR(45) NULL,
  estado VARCHAR(45) NULL,
  pais VARCHAR(45) NULL,
  complemento VARCHAR(45) NULL,
  fkEmpresaE INT NOT NULL,
    PRIMARY KEY (idEndereco, fkEmpresaE),
  CONSTRAINT fkEmpresaE
    FOREIGN KEY (fkEmpresaE)
    REFERENCES empresa (idEmpresa)
    );
    
  
  CREATE TABLE IF NOT EXISTS nivelAcesso (
  idNivelAcesso INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  sigla CHAR(3) NULL,
  descricao VARCHAR(100) NULL
  );
  
  CREATE TABLE IF NOT EXISTS colaborador (
  idColaborador INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(200) NULL,
  cpf CHAR(11) NULL,
  email VARCHAR(45) NULL,
  celular CHAR(11) NULL,
  senha VARCHAR(255) NULL,
  fkEmpresa INT NOT NULL,
  fkNivelAcesso INT NOT NULL,
  CONSTRAINT pkColaborador
    PRIMARY KEY (idColaborador, fkEmpresa),
  CONSTRAINT fkUsuariosEmpresa
    FOREIGN KEY (fkEmpresa)
    REFERENCES empresa (idEmpresa)
    ,
  CONSTRAINT fkColaboradornivelAcesso
    FOREIGN KEY (fkNivelAcesso)
    REFERENCES nivelAcesso (idNivelAcesso)
    );
  
  CREATE TABLE IF NOT EXISTS unidadeMedida (
  idUnidade INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  tipoDado VARCHAR(45) NULL,
  representacao CHAR(2) NULL
  );

CREATE TABLE IF NOT EXISTS cartao (
  idCartao INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  nCartao CHAR(16) NULL,
  validade CHAR(4) NULL,
  cvv CHAR(3) NULL,
  bandeira VARCHAR(50) NULL,
  nomeTitular VARCHAR(45) NULL,
  fkEmpresaC INT NOT NULL,
  CONSTRAINT fkEmpresaC
    FOREIGN KEY (fkEmpresaC)
    REFERENCES empresa (idEmpresa)
    );
  
CREATE TABLE IF NOT EXISTS chat (
  idChat INT NOT NULL AUTO_INCREMENT,
  titulo VARCHAR(45) NULL,
  descricao VARCHAR(300) NULL,
  fkColaboradorChat INT NOT NULL,
  fkEmpresaChat INT NOT NULL,
  fkComentario INT NOT NULL,
  CONSTRAINT pkChat
    PRIMARY KEY (idChat, fkColaboradorChat, fkEmpresaChat, fkComentario),
  CONSTRAINT fkChatColaborador
    FOREIGN KEY (fkColaboradorChat , fkEmpresaChat)
    REFERENCES colaborador (idColaborador , fkEmpresa),
  CONSTRAINT fkChatComentario
    FOREIGN KEY (fkComentario)
    REFERENCES chat (idChat)
    );
    
CREATE TABLE IF NOT EXISTS maquina (
  idMaquina INT NOT NULL AUTO_INCREMENT,
  ip VARCHAR(20) NULL,
  so VARCHAR(45) NULL,
  hostname VARCHAR(100) NOT NULL,
  modelo VARCHAR(45) NULL,
  setor CHAR(3) NULL,
  fkEmpresa INT NOT NULL,
  CONSTRAINT pkMaquina
    PRIMARY KEY (idMaquina, fkEmpresa),
  CONSTRAINT fkMaquinaEmpresa
    FOREIGN KEY (fkEmpresa)
    REFERENCES empresa (idEmpresa)
    );
    
CREATE TABLE IF NOT EXISTS janelas (
  idJanelas INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  nomeJanela VARCHAR(45) NULL,
  data DATE NULL,
  hora TIME NULL,
  fkMaquina INT NOT NULL,
  fkEmpresa INT NOT NULL,
  CONSTRAINT fkJanelasMaquina
    FOREIGN KEY (fkMaquina , fkEmpresa)
    REFERENCES maquina (idMaquina , fkEmpresa)
);

CREATE TABLE IF NOT EXISTS rede (
  idJanelas INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  nomeJanela VARCHAR(45) NULL,
  data DATE NULL,
  hora TIME NULL,
  fkMaquina INT NOT NULL,
  fkEmpresa INT NOT NULL,
  CONSTRAINT fkJanelasMaquina
    FOREIGN KEY (fkMaquina , fkEmpresa)
    REFERENCES maquina (idMaquina , fkEmpresa)
);

CREATE TABLE IF NOT EXISTS processos (
  PID INT PRIMARY KEY NOT NULL,
  usoCPU DOUBLE NULL,
  usoMemoria DOUBLE NULL,
  memoriaVirtual DOUBLE NULL,
  fkMaquina INT NOT NULL,
  fkEmpresa INT NOT NULL,
  CONSTRAINT fkProcessosMaquina
    FOREIGN KEY (fkMaquina , fkEmpresa)
    REFERENCES maquina (idMaquina , fkEmpresa)
);
    
CREATE TABLE IF NOT EXISTS componente (
  idComponente INT NOT NULL AUTO_INCREMENT,
  nomeComponente VARCHAR(45) NULL,
  fkMaquinaComponente INT NOT NULL,
  fkEmpresaComponente INT NOT NULL,
  CONSTRAINT pkComponente
    PRIMARY KEY (idComponente, fkMaquinaComponente, fkEmpresaComponente),
  CONSTRAINT fk_ComponentesMaquina1
    FOREIGN KEY (fkMaquinaComponente , fkEmpresaComponente)
    REFERENCES maquina (idMaquina , fkEmpresa)
);
    

  
CREATE TABLE IF NOT EXISTS monitoramento (
  idMonitoramento INT NOT NULL AUTO_INCREMENT,
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
    REFERENCES componente (idComponente , fkMaquinaComponente , fkEmpresaComponente)
    ,
  CONSTRAINT fkMonitoramentoUnidadeDeMedida
    FOREIGN KEY (fkUnidadeMedida)
    REFERENCES unidadeMedida (idUnidade)
    );
  
CREATE TABLE IF NOT EXISTS aviso (
  idAviso INT NOT NULL  AUTO_INCREMENT,
  dtHora DATETIME NULL,
  descricao VARCHAR(45) NULL,
  fkMonitoramento INT NOT NULL,
  CONSTRAINT pkAviso
    PRIMARY KEY (idAviso, fkMonitoramento),
  CONSTRAINT fkMonitoramento
    FOREIGN KEY (fkMonitoramento)
    REFERENCES monitoramento (idMonitoramento)
    
    );
    
CREATE TABLE IF NOT EXISTS controleAcesso (
  fkColaborador INT NOT NULL,
  fkEmpresaColaborador INT NOT NULL,
  fkMaquina INT NOT NULL,
  fkEmpresaMáquina INT NOT NULL,
  inicioSessao DATETIME NOT NULL,
  fimSessao DATETIME NULL,
  CONSTRAINT pkAcesso
    PRIMARY KEY (fkColaborador, fkEmpresaColaborador, fkMaquina, fkEmpresaMáquina),
  CONSTRAINT fkEmpresaUsuarios
    FOREIGN KEY (fkColaborador , fkEmpresaColaborador)
    REFERENCES colaborador (idColaborador , fkEmpresa)
    ,
  CONSTRAINT fkUsuariosMaquina
    FOREIGN KEY (fkMaquina , fkEmpresaMáquina)
    REFERENCES maquina (idMaquina , fkEmpresa)
    );

