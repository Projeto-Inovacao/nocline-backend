-- DROP DATABASE nocline;
CREATE DATABASE nocline;
USE nocline;

CREATE TABLE IF NOT EXISTS empresa(
  id_empresa INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
  razao_social VARCHAR(150) NOT NULL,
  cnpj CHAR(18) NULL UNIQUE
);

  CREATE TABLE IF NOT EXISTS nivel_acesso (
  id_nivel_acesso INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  sigla CHAR(3) NULL,
  descricao VARCHAR(50) NULL
);

CREATE TABLE IF NOT EXISTS colaborador (
  id_colaborador INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(200) NULL,
  cpf CHAR(14) NULL,
  email VARCHAR(250) NULL UNIQUE,
  celular CHAR(13) NULL,
  senha VARCHAR(255) NULL,
  fk_empresa INT NOT NULL,
  fk_nivel_acesso INT NOT NULL,
  CONSTRAINT pk_colaborador
	PRIMARY KEY (id_colaborador, fk_empresa),
  CONSTRAINT fk_usuarios_empresa
    FOREIGN KEY (fk_empresa)
    REFERENCES empresa (id_empresa),
  CONSTRAINT fk_colaborador_nivel_acesso
    FOREIGN KEY (fk_nivel_acesso)
    REFERENCES nivel_acesso (id_nivel_acesso)
);

CREATE TABLE IF NOT EXISTS endereco (
  id_endereco INT NOT NULL AUTO_INCREMENT,
  cep CHAR(9) NOT NULL,
  num INT NOT NULL,
  rua VARCHAR(100) NULL,
  bairro VARCHAR(100) NULL,
  cidade VARCHAR(100) NULL,
  estado VARCHAR(80) NULL,
  pais VARCHAR(80) NULL,
  complemento VARCHAR(150) NULL,
  fk_empresaE INT NOT NULL,
    PRIMARY KEY (id_endereco, fk_empresaE),
  CONSTRAINT fk_empresaE
    FOREIGN KEY (fk_empresaE)
    REFERENCES empresa (id_empresa)
);

CREATE TABLE IF NOT EXISTS chat (
  id_chat INT NOT NULL AUTO_INCREMENT,
  titulo VARCHAR(45) NULL,
  descricao VARCHAR(300) NULL,
  fk_colaborador_chat INT NOT NULL,
  PRIMARY KEY (id_chat, fk_colaborador_chat),
  CONSTRAINT fk_colaborador_chat
    FOREIGN KEY (fk_colaborador_chat)
    REFERENCES colaborador (id_colaborador)
);

CREATE TABLE IF NOT EXISTS plano (
  id_plano INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  essentials TINYINT NULL,
  master TINYINT NULL,
  plus TINYINT NULL,
  qtd_min_maq INT NULL,
  preco_min DOUBLE NULL,
  valor_add_maq INT NULL,
  data_assinatura DATE NULL
);

CREATE TABLE IF NOT EXISTS contrato (
  id_contrato INT NOT NULL,
  data_inicio DATE NULL,
  data_termino DATE NULL,
  qtd_maq_add INT NULL,
  preco_total DOUBLE NOT NULL,
  pagamento VARCHAR(50) NOT NULL,
  fk_empresaCO INT NOT NULL,
  fk_plano INT NOT NULL,
  PRIMARY KEY (id_contrato, fk_empresaCO, fk_plano),
  CONSTRAINT fk_empresaCO
    FOREIGN KEY (fk_empresaCO)
    REFERENCES empresa (id_empresa),
  CONSTRAINT fk_plano
    FOREIGN KEY (fk_plano)
    REFERENCES plano (id_plano)
);

CREATE TABLE IF NOT EXISTS maquina (
  id_maquina INT NOT NULL AUTO_INCREMENT,
  ip VARCHAR(20) NULL,
  so VARCHAR(45) NULL,
  hostname VARCHAR(100) NOT NULL,
  modelo VARCHAR(45) NULL,
  setor CHAR(3) NULL,
  fk_empresaM INT NOT NULL,
  CONSTRAINT pk_maquina
    PRIMARY KEY (id_maquina, fk_empresaM),
  CONSTRAINT fk_maquina_empresa
    FOREIGN KEY (fk_empresaM)
    REFERENCES empresa (id_empresa)
);

CREATE TABLE IF NOT EXISTS controle_acesso (
  fk_colaborador INT NOT NULL,
  fk_empresa_colaborador INT NOT NULL,
  fk_maquina INT NOT NULL,
  fk_empresa_maquina INT NOT NULL,
  inicio_sessao DATETIME NOT NULL,
  fim_sessao DATETIME NULL,
  PRIMARY KEY (fk_colaborador, fk_empresa_colaborador, fk_maquina, fk_empresa_maquina),
  CONSTRAINT fk_colaboradorCA
    FOREIGN KEY (fk_colaborador, fk_empresa_colaborador)
    REFERENCES colaborador (id_colaborador, fk_empresa),
  CONSTRAINT fk_maquinaCA
    FOREIGN KEY (fk_maquina, fk_empresa_maquina)
    REFERENCES maquina (id_maquina, fk_empresaM)
);

CREATE TABLE IF NOT EXISTS janela (
  id_janela INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  nome_janela VARCHAR(150) NULL,
  status_abertura TINYINT NULL,
  data_hora DATETIME NULL,
  fk_maquinaJ INT NOT NULL,
  fk_empresaJ INT NOT NULL,
  CONSTRAINT fk_maq_empJ
    FOREIGN KEY (fk_maquinaJ, fk_empresaJ)
    REFERENCES maquina (id_maquina, fk_empresaM)
);

CREATE TABLE IF NOT EXISTS processos (
  pid INT PRIMARY KEY NOT NULL,
  uso_cpu DOUBLE NULL,
  uso_memoria DOUBLE NULL,
  memoria_virtual DOUBLE NULL,
  status_abertura TINYINT NULL,
  fk_maquinaP INT NOT NULL,
  fk_empresaP INT NOT NULL,
  CONSTRAINT fk_maq_empP
    FOREIGN KEY (fk_maquinaP, fk_empresaP)
    REFERENCES maquina (id_maquina, fk_empresaM)
);

CREATE TABLE IF NOT EXISTS componente (
  id_componente INT NOT NULL AUTO_INCREMENT,
  nome_componente VARCHAR(45) NULL,
  fk_maquina_componente INT NOT NULL,
  fk_empresa_componente INT NOT NULL,
  CONSTRAINT pk_componente
    PRIMARY KEY (id_componente, fk_maquina_componente, fk_empresa_componente),
  CONSTRAINT fk_maq_empC
    FOREIGN KEY (fk_maquina_componente , fk_empresa_componente)
    REFERENCES maquina (id_maquina , fk_empresaM),
  CONSTRAINT fk_componente_metrica
    FOREIGN KEY (fk_metrica_componente)
    REFERENCES metrica (id_metrica)
);

  CREATE TABLE IF NOT EXISTS unidade_medida (
  id_unidade INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  tipo_dado VARCHAR(45) NULL,
  representacao CHAR(2) NULL
);
  
CREATE TABLE IF NOT EXISTS monitoramento (
  id_monitoramento INT NOT NULL AUTO_INCREMENT,
  dado_coletado DOUBLE NOT NULL,
  data_hora DATETIME NOT NULL,
  descricao VARCHAR(45) NOT NULL,
  fk_componentes_monitoramento INT NOT NULL,
  fk_maquina_monitoramento INT NOT NULL,
  fk_empresa_monitoramento INT NOT NULL,
  fk_unidade_medida INT NOT NULL,
  CONSTRAINT pk_monitoramento
    PRIMARY KEY (id_monitoramento, fk_componentes_monitoramento, fk_maquina_monitoramento, fk_empresa_monitoramento, fk_unidade_medida),
  CONSTRAINT fk_monitoramento_componente
    FOREIGN KEY (fk_componentes_monitoramento)
    REFERENCES componente (id_componente),
  CONSTRAINT fk_monitoramento_unidade_medida
    FOREIGN KEY (fk_unidade_medida)
    REFERENCES unidade_medida (id_unidade)
);

CREATE TABLE IF NOT EXISTS metrica (
  id_metrica INT AUTO_INCREMENT NOT NULL,
  risco DOUBLE NULL,
  perigo DOUBLE NULL,
  fk_unidade_medida INT NOT NULL,
  CONSTRAINT pk_metrica
  PRIMARY KEY (id_metrica, fk_unidade_medida),
  CONSTRAINT fk_metrica_unidade_medida
    FOREIGN KEY (fk_unidade_medida)
    REFERENCES unidade_medida (id_unidade));


CREATE TABLE IF NOT EXISTS alerta (
  id_alerta INT PRIMARY KEY  NOT NULL,
  data_hora DATETIME NULL,
  fk_componenente_alerta INT NOT NULL,
  fk_maquina_alerta INT NOT NULL,
  fk_empresa_alerta INT NOT NULL,
  fk_unidade_medida_alerta INT NOT NULL,
  CONSTRAINT fk_alerta_monitoramento
    FOREIGN KEY (fk_componenente_alerta , fk_maquina_alerta , fk_empresa_alerta , fk_unidade_medida_alerta)
    REFERENCES monitoramento (fk_componentes_monitoramento , fk_maquina_monitoramento , fk_empresa_monitoramento , fk_unidade_medida)
   )
;

CREATE TABLE IF NOT EXISTS alerta (
  id_alerta INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  data_hora DATETIME NULL,
  fk_componenente_alerta INT NOT NULL,
  fk_maquina_alerta INT NOT NULL,
  fk_empresa_alerta INT NOT NULL,
  fk_unidade_medida_alerta INT NOT NULL,
CONSTRAINT fk_alerta_componente
    FOREIGN KEY (fk_componenente_alerta)
    REFERENCES monitoramento (fk_componentes_monitoramento),
CONSTRAINT fk_alerta_maquina
    FOREIGN KEY (fk_maquina_alerta)
    REFERENCES maquina (id_maquina),
CONSTRAINT fk_alerta_empresa
    FOREIGN KEY (fk_empresa_alerta)
    REFERENCES empresa (id_empresa),
CONSTRAINT fk_alerta_unidade_medida
    FOREIGN KEY (fk_unidade_medida_alerta)
    REFERENCES unidade_medida (id_unidade)
    );

DELIMITER //
CREATE TRIGGER criarAlerta
AFTER INSERT ON monitoramento
FOR EACH ROW 
BEGIN
    DECLARE id_metrica INT;
    DECLARE n_risco DOUBLE;
    DECLARE n_perigo DOUBLE;
    
    SELECT fk_metrica_componente
	INTO id_metrica
	FROM componente
	WHERE NEW.fk_componentes_monitoramento = id_componente;

    SELECT risco, perigo
    INTO n_risco, n_perigo
    FROM metrica
    WHERE id_metrica = id_metrica;
    
    IF NEW.dado_coletado >= n_risco THEN
        INSERT INTO alerta (tipo_alerta, fkRegistro, fkRobo, dtHora)
        VALUES ("critico", NEW.id_monitoramento, NEW.fk_maquina_monitoramento, now());
    ELSEIF NEW.dado_coletado >= n_perigo THEN
        INSERT INTO alerta (tipo_alerta, fkRegistro, fkRobo, dtHora)
        VALUES ("urgente", NEW.id_monitoramento, NEW.fk_maquina_monitoramento, now());
    END IF;
END;
//
DELIMITER ;

    


