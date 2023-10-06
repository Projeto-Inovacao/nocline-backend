CREATE DATABASE IF NOT exists nocLine;
-- DROP DATABASE nocLine;
USE nocLine;


CREATE TABLE IF NOT EXISTS `empresa` (
  `idEmpresa` INT NOT NULL AUTO_INCREMENT,
  `razaoSocial` VARCHAR(45) NOT NULL,
  `CNPJ` CHAR(14) NULL,
  PRIMARY KEY (`idEmpresa`),
  UNIQUE INDEX `CNPJ_UNIQUE` (`CNPJ` ASC) VISIBLE);
  
CREATE TABLE IF NOT EXISTS `endereco` (
  `idEndereco` INT NOT NULL AUTO_INCREMENT,
  `cep` CHAR(8) NOT NULL,
  `num` INT NOT NULL,
  `rua` VARCHAR(45) NULL,
  `bairro` VARCHAR(45) NULL,
  `cidade` VARCHAR(45) NULL,
  `estado` VARCHAR(45) NULL,
  `pais` VARCHAR(45) NULL,
  `complemento` VARCHAR(45) NULL,
  `fkEmpresa` INT NOT NULL,
  PRIMARY KEY (`idEndereco`, `fkEmpresa`),
  INDEX `fk_Endereco_Empresa1_idx` (`fkEmpresa` ASC) VISIBLE,
  CONSTRAINT `fk_Endereco_Empresa1`
    FOREIGN KEY (`fkEmpresa`)
    REFERENCES `empresa` (`idEmpresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
  
  CREATE TABLE IF NOT EXISTS `colaborador` (
  `idColaborador` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(200) NULL,
  `cpf` CHAR(11) NULL,
  `email` VARCHAR(45) NULL,
  `celular` CHAR(11) NULL,
  `senha` VARCHAR(255) NULL,
  `fkEmpresa` INT NOT NULL,
  `fkNivelAcesso` INT NOT NULL,
  PRIMARY KEY (`idColaborador`, `fkEmpresa`),
  INDEX `fk_Usuarios_Empresa1_idx` (`fkEmpresa` ASC) VISIBLE,
  INDEX `fk_Colaborador_nivelAcesso1_idx` (`fkNivelAcesso` ASC) VISIBLE,
  CONSTRAINT `fk_Usuarios_Empresa1`
    FOREIGN KEY (`fkEmpresa`)
    REFERENCES `empresa` (`idEmpresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Colaborador_nivelAcesso1`
    FOREIGN KEY (`fkNivelAcesso`)
    REFERENCES `nivelAcesso` (`idnivelAcesso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
CREATE TABLE IF NOT EXISTS `nivelAcesso` (
  `idnivelAcesso` INT NOT NULL AUTO_INCREMENT,
  `sigla` CHAR(3) NULL,
  `descricao` VARCHAR(100) NULL,
  PRIMARY KEY (`idnivelAcesso`));
  
  
CREATE TABLE IF NOT EXISTS `planos` (
  `idPlano` INT NOT NULL AUTO_INCREMENT,
  `essentials` TINYINT NULL,
  `master` TINYINT NULL,
  `plus` TINYINT NULL,
  `fkEmpresa` INT NOT NULL,
  INDEX `fk_Planos_Empresa1_idx` (`fkEmpresa` ASC) VISIBLE,
  PRIMARY KEY (`idPlano`),
  CONSTRAINT `fk_Planos_Empresa1`
    FOREIGN KEY (`fkEmpresa`)
    REFERENCES `empresa` (`idEmpresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
CREATE TABLE IF NOT EXISTS `cartao` (
  `idCartao` INT NOT NULL AUTO_INCREMENT,
  `nCartao` CHAR(16) NULL,
  `validade` DATE NULL,
  `cvv` CHAR(3) NULL,
  `bandeira` VARCHAR(50) NULL,
  `nomeTitular` VARCHAR(45) NULL,
  `fkEmpresa` INT NOT NULL,
  PRIMARY KEY (`idCartao`),
  INDEX `fk_Cartao_Empresa1_idx` (`fkEmpresa` ASC) VISIBLE,
  CONSTRAINT `fk_Cartao_Empresa1`
    FOREIGN KEY (`fkEmpresa`)
    REFERENCES `empresa` (`idEmpresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
  

CREATE TABLE IF NOT EXISTS `chat` (
  `idChat` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(45) NULL,
  `descricao` VARCHAR(300) NULL,
  `fkColaboradorChat` INT NOT NULL,
  `fkEmpresaChat` INT NOT NULL,
  PRIMARY KEY (`idChat`, `fkColaboradorChat`, `fkEmpresaChat`),
  INDEX `fk_chat_colaborador1_idx` (`fkColaboradorChat` ASC, `fkEmpresaChat` ASC) VISIBLE,
  CONSTRAINT `fk_chat_colaborador1`
    FOREIGN KEY (`fkColaboradorChat` , `fkEmpresaChat`)
    REFERENCES `colaborador` (`idColaborador` , `fkEmpresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
CREATE TABLE IF NOT EXISTS `maquina` (
  `idMaquina` INT NOT NULL AUTO_INCREMENT,
  `ip` VARCHAR(20) NULL,
  `so` VARCHAR(45) NULL,
  `modelo` VARCHAR(45) NULL,
  `setor` CHAR(3) NULL,
  `fkEmpresa` INT NOT NULL,
  PRIMARY KEY (`idMaquina`, `fkEmpresa`),
  INDEX `fk_Máquina_Empresa1_idx` (`fkEmpresa` ASC) VISIBLE,
  CONSTRAINT `fk_Máquina_Empresa1`
    FOREIGN KEY (`fkEmpresa`)
    REFERENCES `empresa` (`idEmpresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
CREATE TABLE IF NOT EXISTS `janelas` (
  `idJanelas` INT NOT NULL AUTO_INCREMENT,
  `nomeJanela` VARCHAR(45) NULL,
  `data` DATE NULL,
  `hora` TIME NULL,
  `fkMaquina` INT NOT NULL,
  `fkEmpresa` INT NOT NULL,
  PRIMARY KEY (`idJanelas`),
  INDEX `fk_Janelas_Máquina1_idx` (`fkMaquina` ASC, `fkEmpresa` ASC) VISIBLE,
  CONSTRAINT `fk_Janelas_Máquina1`
    FOREIGN KEY (`fkMaquina` , `fkEmpresa`)
    REFERENCES `maquina` (`idMaquina` , `fkEmpresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
CREATE TABLE IF NOT EXISTS `componente` (
  `idComponente` INT NOT NULL AUTO_INCREMENT,
  `nomeComponente` VARCHAR(45) NULL,
  `fkMaquinaComponente` INT NOT NULL,
  `fkEmpresaComponente` INT NOT NULL,
  PRIMARY KEY (`idComponente`, `fkMaquinaComponente`, `fkEmpresaComponente`),
  INDEX `fk_Componentes_Máquina1_idx` (`fkMaquinaComponente` ASC, `fkEmpresaComponente` ASC) VISIBLE,
  CONSTRAINT `fk_Componentes_Máquina1`
    FOREIGN KEY (`fkMaquinaComponente` , `fkEmpresaComponente`)
    REFERENCES `maquina` (`idMaquina` , `fkEmpresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
CREATE TABLE IF NOT EXISTS `monitoramento` (
  `idMonitoramento` INT NOT NULL AUTO_INCREMENT,
  `dadoColetado` DOUBLE NOT NULL,
  `dtHora` DATETIME NOT NULL,
  `fkComponentesMonitoramentos` INT NOT NULL,
  `fkMaquinaMonitoramentos` INT NOT NULL,
  `fkEmpresaMonitoramentos` INT NOT NULL,
  `fkUnidadeMedida` INT NOT NULL,
  PRIMARY KEY (`idMonitoramento`, `fkComponentesMonitoramentos`, `fkMaquinaMonitoramentos`, `fkEmpresaMonitoramentos`, `fkUnidadeMedida`),
  INDEX `fk_Monitoramento_Componentes1_idx` (`fkComponentesMonitoramentos` ASC, `fkMaquinaMonitoramentos` ASC, `fkEmpresaMonitoramentos` ASC) VISIBLE,
  INDEX `fk_Monitoramento_UnidadeDeMedida1_idx` (`fkUnidadeMedida` ASC) VISIBLE,
  CONSTRAINT `fk_Monitoramento_Componentes1`
    FOREIGN KEY (`fkComponentesMonitoramentos` , `fkMaquinaMonitoramentos` , `fkEmpresaMonitoramentos`)
    REFERENCES `componente` (`idComponente` , `fkMaquinaComponente` , `fkEmpresaComponente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Monitoramento_UnidadeDeMedida1`
    FOREIGN KEY (`fkUnidadeMedida`)
    REFERENCES `unidadeMedida` (`idUnidade`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
CREATE TABLE IF NOT EXISTS `unidadeMedida` (
  `idUnidade` INT NOT NULL AUTO_INCREMENT,
  `tipoDado` VARCHAR(45) NULL,
  `representacao` CHAR(2) NULL,
  PRIMARY KEY (`idUnidade`));
  
CREATE TABLE IF NOT EXISTS `aviso` (
  `idAviso` INT NOT NULL  AUTO_INCREMENT,
  `dtHora` DATETIME NULL,
  `descricao` VARCHAR(45) NULL,
  `fkMonitoramento` INT NOT NULL,
  PRIMARY KEY (`idAviso`, `fkMonitoramento`),
  INDEX `fk_Monitoramento_has_Usuarios_Monitoramento1_idx` (`fkMonitoramento` ASC) VISIBLE,
  CONSTRAINT `fk_Monitoramento_has_Usuarios_Monitoramento1`
    FOREIGN KEY (`fkMonitoramento`)
    REFERENCES `monitoramento` (`idMonitoramento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
CREATE TABLE IF NOT EXISTS `controleAcesso` (
  `fkColaborador` INT NOT NULL,
  `fkEmpresaColaborador` INT NOT NULL,
  `fkMaquina` INT NOT NULL,
  `fkEmpresaMáquina` INT NOT NULL,
  `inicioSessao` DATETIME NOT NULL,
  `fimSessao` DATETIME NULL,
  PRIMARY KEY (`fkColaborador`, `fkEmpresaColaborador`, `fkMaquina`, `fkEmpresaMáquina`),
  INDEX `fk_Usuarios_has_Máquina_Máquina1_idx` (`fkMaquina` ASC, `fkEmpresaMáquina` ASC) VISIBLE,
  INDEX `fk_Usuarios_has_Máquina_Usuarios1_idx` (`fkColaborador` ASC, `fkEmpresaColaborador` ASC) VISIBLE,
  CONSTRAINT `fk_Usuarios_has_Máquina_Usuarios1`
    FOREIGN KEY (`fkColaborador` , `fkEmpresaColaborador`)
    REFERENCES `colaborador` (`idColaborador` , `fkEmpresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Usuarios_has_Máquina_Máquina1`
    FOREIGN KEY (`fkMaquina` , `fkEmpresaMáquina`)
    REFERENCES `maquina` (`idMaquina` , `fkEmpresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

