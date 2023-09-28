Create database NocLine;
use NocLine;

Create table Empresa(
idEmpresa int primary key auto_increment , 
razãoSocial varchar (45),
 CNPJ  char (14) unique not null);
 
    CREATE TABLE  Setor (
  `idSetor` INT NOT NULL,
  `Nome` VARCHAR(45) NULL,
  PRIMARY KEY (`idSetor`));

CREATE TABLE Colaborador (
  `idColaborador` INT NOT NULL,
  `nome` VARCHAR(200) NOT NULL,
  `email_corporativo` VARCHAR(45) NULL,
  `senha` VARCHAR(255) NOT NULL,
  `telCel` CHAR(11) NULL,
  `fkEmpresa` INT NOT NULL,
  `fkPermissao` INT NOT NULL,
  `Setor_idSetor` INT NOT NULL,
  PRIMARY KEY (`idColaborador`, `fkEmpresa`, `fkPermissao`),
  INDEX `fk_Usuarios_Empresa1_idx` (`fkEmpresa` ASC) VISIBLE,
  INDEX `fk_Colaborador_Setor1_idx` (`Setor_idSetor` ASC) VISIBLE,
  CONSTRAINT `fk_Usuarios_Empresa1`
    FOREIGN KEY (`fkEmpresa`)
    REFERENCES `Empresa` (`idEmpresa`),
  CONSTRAINT `fk_Colaborador_Setor1`
    FOREIGN KEY (`Setor_idSetor`)
    REFERENCES `Setor` (`idSetor`)
    
);

 CREATE TABLE Endereco (
  `idEndereco` INT auto_increment,
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
    REFERENCES `Empresa` (`idEmpresa`)
    );
    
CREATE TABLE Permissao (
  `idPermissao` INT NOT NULL,
  `Visualizar` TINYINT NULL,
  `Excluir` TINYINT NULL,
  `Alterar` TINYINT NULL,
  `Cadastrar` TINYINT NULL,
  `maquinas` TINYINT NULL,
  `equipe_corporativa` TINYINT NULL,
  `fksetor` INT NOT NULL,
  PRIMARY KEY (`idPermissao`, `fksetor`),
  INDEX `fk_Permissao_Setor1_idx` (`fksetor` ASC) VISIBLE,
  CONSTRAINT `fk_Permissao_Setor1`
    FOREIGN KEY (`fksetor`)
    REFERENCES `Setor` (`idSetor`)
   );
   
    CREATE TABLE Máquina (
  `idMáquina` INT NOT NULL,
  `IP` VARCHAR(45) NULL,
  `SO` VARCHAR(45) NULL,
  `modelo` VARCHAR(45) NULL,
  `fkEmpresa` INT NOT NULL,
  PRIMARY KEY (`idMáquina`, `fkEmpresa`),
  INDEX `fk_Máquina_Empresa1_idx` (`fkEmpresa` ASC) VISIBLE,
  CONSTRAINT `fk_Máquina_Empresa1`
    FOREIGN KEY (`fkEmpresa`)
    REFERENCES `Empresa` (`idEmpresa`)
);

   CREATE TABLE ControleAcesso (
  `fkColaborador` INT NOT NULL,
  `fkEmpresaColaborador` INT NOT NULL,
  `fkNívelAcesso` INT NOT NULL,
  `fkMáquina` INT NOT NULL,
  `fkEmpresaMáquina` INT NOT NULL,
  `idColaboradoreseMaquinas` INT NOT NULL,
  `InicioSessao` DATETIME NOT NULL,
  `FimSessao` DATETIME NULL,
  PRIMARY KEY (`fkColaborador`, `fkEmpresaColaborador`, `fkNívelAcesso`, `fkMáquina`, `fkEmpresaMáquina`, `idColaboradoreseMaquinas`),
  INDEX `fk_Usuarios_has_Máquina_Máquina1_idx` (`fkMáquina` ASC, `fkEmpresaMáquina` ASC) VISIBLE,
  INDEX `fk_Usuarios_has_Máquina_Usuarios1_idx` (`fkColaborador` ASC, `fkEmpresaColaborador` ASC, `fkNívelAcesso` ASC) VISIBLE,
  CONSTRAINT `fk_Usuarios_has_Máquina_Usuarios1`
    FOREIGN KEY (`fkColaborador` , `fkEmpresaColaborador` , `fkNívelAcesso`)
    REFERENCES `Colaborador` (`idColaborador` , `fkEmpresa` , `fkPermissao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Usuarios_has_Máquina_Máquina1`
    FOREIGN KEY (`fkMáquina` , `fkEmpresaMáquina`)
    REFERENCES `Máquina` (`idMáquina` , `fkEmpresa`)
 );
 
 CREATE TABLE Componente (
  `idComponente` INT NOT NULL,
  `nomeComponente` VARCHAR(45) NULL,
  `fkMáquinaComponente` INT NOT NULL,
  `fkEmpresaComponente` INT NOT NULL,
  `Parâmetro_idParâmetro` INT NOT NULL,
  PRIMARY KEY (`idComponente`, `fkMáquinaComponente`, `fkEmpresaComponente`),
  INDEX `fk_Componentes_Máquina1_idx` (`fkMáquinaComponente` ASC, `fkEmpresaComponente` ASC) VISIBLE,
  CONSTRAINT `fk_Componentes_Máquina1`
    FOREIGN KEY (`fkMáquinaComponente` , `fkEmpresaComponente`)
    REFERENCES `Máquina` (`idMáquina` , `fkEmpresa`)
);
CREATE TABLE  UnidadeDeMedida (
  `idUnidade` INT NOT NULL,
  `Tipo_de_Dado` VARCHAR(45) NULL,
  `Representacao` CHAR(2) NULL,
  PRIMARY KEY (`idUnidade`));
 CREATE TABLE Monitoramento (
  `idMonitoramento` INT NOT NULL,
  `dadoColetado` DOUBLE NOT NULL,
  `dtHora` DATETIME NOT NULL,
  `fkComponentesMonitoramentos` INT NOT NULL,
  `fkMáquinaMonitoramentos` INT NOT NULL,
  `fkEmpresaMonitoramentos` INT NOT NULL,
  `UnidadeDeMedida_idUnidade` INT NOT NULL,
  PRIMARY KEY (`idMonitoramento`, `fkComponentesMonitoramentos`, `fkMáquinaMonitoramentos`, `fkEmpresaMonitoramentos`, `UnidadeDeMedida_idUnidade`),
  INDEX `fk_Monitoramento_Componentes1_idx` (`fkComponentesMonitoramentos` ASC, `fkMáquinaMonitoramentos` ASC, `fkEmpresaMonitoramentos` ASC) VISIBLE,
  INDEX `fk_Monitoramento_UnidadeDeMedida1_idx` (`UnidadeDeMedida_idUnidade` ASC) VISIBLE,
  CONSTRAINT `fk_Monitoramento_Componentes1`
    FOREIGN KEY (`fkComponentesMonitoramentos` , `fkMáquinaMonitoramentos` , `fkEmpresaMonitoramentos`)
    REFERENCES `Componente` (`idComponente` , `fkMáquinaComponente` , `fkEmpresaComponente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Monitoramento_UnidadeDeMedida1`
    FOREIGN KEY (`UnidadeDeMedida_idUnidade`)
    REFERENCES `UnidadeDeMedida` (`idUnidade`)
);

CREATE TABLE Aviso(
  `fkMonitoramento` INT NOT NULL,
  `fkMáquina` INT NOT NULL,
  `fkEmpresa` INT NOT NULL,
  `idAviso` INT NOT NULL,
  `dtHora` DATETIME NULL,
  `Descricao` VARCHAR(45) NULL,
  PRIMARY KEY (`fkMonitoramento`, `fkMáquina`, `fkEmpresa`, `idAviso`),
  INDEX `fk_Monitoramento_has_Usuarios_Monitoramento1_idx` (`fkMonitoramento` ASC, `fkMáquina` ASC, `fkEmpresa` ASC) VISIBLE,
  CONSTRAINT `fk_Monitoramento_has_Usuarios_Monitoramento1`
    FOREIGN KEY (`fkMonitoramento`)
    REFERENCES `Monitoramento` (`idMonitoramento`)
);

   
   
   
   




    

