  create database nocLine;
  use nocLine;
 
  
CREATE TABLE IF NOT exists  `Empresa` (
  `idEmpresa` INT NOT NULL,
  `razãoSocial` VARCHAR(45) NULL,
  `CNPJ` CHAR(14) NULL,
  PRIMARY KEY (`idEmpresa`));
  
CREATE TABLE IF NOT EXISTS `Endereco` (
  `idEndereco` INT NOT NULL,
  `CEP` CHAR(8) NOT NULL,
  `num` INT NOT NULL,
  `rua` VARCHAR(45) NOT NULL,
  `bairro` VARCHAR(45) NOT NULL,
  `cidade` VARCHAR(45) NOT NULL,
  `estado` VARCHAR(45) NOT NULL,
  `pais` VARCHAR(45) NOT NULL,
  `Complemento` VARCHAR(45)  NULL,
  `fkEmpresa` INT NOT NULL,
  PRIMARY KEY (`idEndereco`, `fkEmpresa`),
  INDEX `fk_Endereco_Empresa1_idx` (`fkEmpresa` ASC) VISIBLE,
  CONSTRAINT `fk_Endereco_Empresa1`
    FOREIGN KEY (`fkEmpresa`)
    REFERENCES `Empresa` (`idEmpresa`));
    
    CREATE TABLE IF NOT EXISTS `Máquina` (
  `idMáquina` INT NOT NULL,
  `IP` VARCHAR(45) NOT NULL,
  `SO` VARCHAR(45) NULL,
  `modelo` VARCHAR(45) NULL,
  `fkEmpresa` INT NOT NULL,
  PRIMARY KEY (`idMáquina`, `fkEmpresa`),
  INDEX `fk_Máquina_Empresa1_idx` (`fkEmpresa` ASC) VISIBLE,
  CONSTRAINT `fk_Máquina_Empresa1`
    FOREIGN KEY (`fkEmpresa`)
    REFERENCES `Empresa` (`idEmpresa`));
    
    CREATE TABLE IF NOT EXISTS `Janelas` (
  `idJanelas` INT NOT NULL,
  `nomeJanela` VARCHAR(45) NULL,
  `Data` DATE NULL,
  `Hora` TIME NULL,
  `fkMaquina` INT NOT NULL,
  `fkEmpresa` INT NOT NULL,
  PRIMARY KEY (`idJanelas`),
  INDEX `fk_Janelas_Máquina1_idx` (`fkMaquina` ASC, `fkEmpresa` ASC) VISIBLE,
  CONSTRAINT `fk_Janelas_Máquina1`
    FOREIGN KEY (`fkMaquina` , `fkEmpresa`)
    REFERENCES `Máquina` (`idMáquina` , `fkEmpresa`));
    
    CREATE TABLE IF NOT EXISTS`Componente` (
  `idComponente` INT NOT NULL,
  `nomeComponente` VARCHAR(45) NULL,
  `fkMáquinaComponente` INT NOT NULL,
  `fkEmpresaComponente` INT NOT NULL,
  PRIMARY KEY (`idComponente`, `fkMáquinaComponente`, `fkEmpresaComponente`),
  INDEX `fk_Componentes_Máquina1_idx` (`fkMáquinaComponente` ASC, `fkEmpresaComponente` ASC) VISIBLE,
  CONSTRAINT `fk_Componentes_Máquina1`
    FOREIGN KEY (`fkMáquinaComponente` , `fkEmpresaComponente`)
    REFERENCES `Máquina` (`idMáquina` , `fkEmpresa`));
    
    CREATE TABLE IF NOT EXISTS `UnidadeDeMedida` (
  `idUnidade` INT NOT NULL,
  `Tipo_de_Dado` VARCHAR(45) NULL,
  `Representacao` CHAR(2) NULL,
  PRIMARY KEY (`idUnidade`));
  
  CREATE TABLE IF NOT EXISTS `Monitoramento` (
  `idMonitoramento` INT NOT NULL,
  `dadoColetado` DOUBLE NOT NULL,
  `dtHora` DATETIME NOT NULL,
  `fkComponentesMonitoramentos` INT NOT NULL,
  `fkMáquinaMonitoramentos` INT NOT NULL,
  `fkEmpresaMonitoramentos` INT NOT NULL,
  `fkUnidadeMedida` INT NOT NULL,
  PRIMARY KEY (`idMonitoramento`, `fkComponentesMonitoramentos`, `fkMáquinaMonitoramentos`, `fkEmpresaMonitoramentos`, `fkUnidadeMedida`),
  INDEX `fk_Monitoramento_Componentes1_idx` (`fkComponentesMonitoramentos` ASC, `fkMáquinaMonitoramentos` ASC, `fkEmpresaMonitoramentos` ASC) VISIBLE,
  INDEX `fk_Monitoramento_UnidadeDeMedida1_idx` (`fkUnidadeMedida` ASC) VISIBLE,
  CONSTRAINT `fk_Monitoramento_Componentes1`
    FOREIGN KEY (`fkComponentesMonitoramentos` , `fkMáquinaMonitoramentos` , `fkEmpresaMonitoramentos`)
    REFERENCES `Componente` (`idComponente` , `fkMáquinaComponente` , `fkEmpresaComponente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Monitoramento_UnidadeDeMedida1`
    FOREIGN KEY (`fkUnidadeMedida`)
    REFERENCES `UnidadeDeMedida` (`idUnidade`));
    
    CREATE TABLE IF NOT EXISTS `Aviso` (
  `idAviso` INT NOT NULL,
  `dtHora` DATETIME NULL,
  `Descricao` VARCHAR(45) NULL,
  `fkMonitoramento` INT NOT NULL,
  PRIMARY KEY (`idAviso`, `fkMonitoramento`),
  INDEX `fk_Monitoramento_has_Usuarios_Monitoramento1_idx` (`fkMonitoramento` ASC) VISIBLE,
  CONSTRAINT `fk_Monitoramento_has_Usuarios_Monitoramento1`
    FOREIGN KEY (`fkMonitoramento`)
    REFERENCES `Monitoramento` (`idMonitoramento`));
    
CREATE TABLE IF NOT EXISTS `Permissao` (
  `idPermissao` INT NOT NULL,
  `Visualizar` TINYINT NULL,
  `Excluir` TINYINT NULL,
  `Alterar` TINYINT NULL,
  `Cadastrar` TINYINT NULL,
  `maquinas` TINYINT NULL,
  `equipe_corporativa` TINYINT NULL,
  PRIMARY KEY (`idPermissao`));
  
  CREATE TABLE IF NOT EXISTS `nivelAcesso` (
  `idnivelAcesso` INT NOT NULL,
  `Sigla` CHAR(3) NULL,
  `descricao` VARCHAR(100) NULL,
  `fkPermissao` INT NOT NULL,
  PRIMARY KEY (`idnivelAcesso`, `fkPermissao`),
  INDEX `fk_nivelAcesso_Permissao1_idx` (`fkPermissao` ASC) VISIBLE,
  CONSTRAINT `fk_nivelAcesso_Permissao1`
    FOREIGN KEY (`fkPermissao`)
    REFERENCES`Permissao` (`idPermissao`)
);
CREATE TABLE IF NOT EXISTS `Colaborador` (
  `idColaborador` INT NOT NULL,
  `nome` VARCHAR(200) NULL,
  `email_corporativo` VARCHAR(45) NULL,
  `senha` VARCHAR(255) NULL,
  `telCel` CHAR(11) NULL,
  `fkEmpresa` INT NOT NULL,
  `fkNivelAcesso` INT NOT NULL,
  PRIMARY KEY (`idColaborador`, `fkEmpresa`),
  INDEX `fk_Usuarios_Empresa1_idx` (`fkEmpresa` ASC) VISIBLE,
  INDEX `fk_Colaborador_nivelAcesso1_idx` (`fkNivelAcesso` ASC) VISIBLE,
  CONSTRAINT `fk_Usuarios_Empresa1`
    FOREIGN KEY (`fkEmpresa`)
    REFERENCES `Empresa` (`idEmpresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Colaborador_nivelAcesso1`
    FOREIGN KEY (`fkNivelAcesso`)
    REFERENCES `nivelAcesso` (`idnivelAcesso`));
    
    CREATE TABLE IF NOT EXISTS `ControleAcesso` (
  `fkColaborador` INT NOT NULL,
  `fkEmpresaColaborador` INT NOT NULL,
  `fkMáquina` INT NOT NULL,
  `fkEmpresaMáquina` INT NOT NULL,
  `InicioSessao` DATETIME NOT NULL,
  `FimSessao` DATETIME NULL,
  PRIMARY KEY (`fkColaborador`, `fkEmpresaColaborador`, `fkMáquina`, `fkEmpresaMáquina`),
  INDEX `fk_Usuarios_has_Máquina_Máquina1_idx` (`fkMáquina` ASC, `fkEmpresaMáquina` ASC) VISIBLE,
  INDEX `fk_Usuarios_has_Máquina_Usuarios1_idx` (`fkColaborador` ASC, `fkEmpresaColaborador` ASC) VISIBLE,
  CONSTRAINT `fk_Usuarios_has_Máquina_Usuarios1`
    FOREIGN KEY (`fkColaborador` , `fkEmpresaColaborador`)
    REFERENCES `Colaborador` (`idColaborador` , `fkEmpresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Usuarios_has_Máquina_Máquina1`
    FOREIGN KEY (`fkMáquina` , `fkEmpresaMáquina`)
    REFERENCES`Máquina` (`idMáquina` , `fkEmpresa`));
    
    CREATE TABLE IF NOT EXISTS `Planos` (
  `idPlano` INT NOT NULL AUTO_INCREMENT,
  `Essentials` TINYINT NULL,
  `Master` TINYINT NULL,
  `plus` TINYINT NULL,
  `fkEmpresa` INT NOT NULL,
  INDEX `fk_Planos_Empresa1_idx` (`fkEmpresa` ASC) VISIBLE,
  PRIMARY KEY (`idPlano`),
  CONSTRAINT `fk_Planos_Empresa1`
    FOREIGN KEY (`fkEmpresa`)
    REFERENCES `Empresa` (`idEmpresa`));

CREATE TABLE IF NOT EXISTS`Cartao` (
  `idCartao` INT NOT NULL,
  `NumCartao` CHAR(4) NULL,
  `Validade` DATE NULL,
  `CVV` CHAR(3) NULL,
  `Bandeira` VARCHAR(50) NULL,
  `fkEmpresa` INT NOT NULL,
  PRIMARY KEY (`idCartao`),
  INDEX `fk_Cartao_Empresa1_idx` (`fkEmpresa` ASC) VISIBLE,
  CONSTRAINT `fk_Cartao_Empresa1`
    FOREIGN KEY (`fkEmpresa`)
    REFERENCES `Empresa` (`idEmpresa`));