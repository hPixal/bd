CREATE DATABASE guia2;

-- EJERCICIO 1
CREATE TABLE cliente(
	codCli int NOT NULL,
	ape varchar(30) NOT NULL,
	nom varchar(30) NOT NULL,
	dir varchar(40) NOT NULL,
	codPost char(9) NULL DEFAULT 3000
);

CREATE TABLE productos(
	codProd int NOT NULL,
	descr varchar(30) NOT NULL,
	precUnit float NOT NULL,
	stock smallint NOT NULL
);

CREATE  TABLE proveed(
	codProv int IDENTITY(1,1),
	razonSoc varchar(30) NOT NULL,
	dir varchar(30) NOT NULL
);

CREATE TABLE pedidos(
	numPed int NOT NULL,
	fechPed datetime NOT NULL,
	codCli int NOT NULL
);

CREATE  TABLE detalle(
	codDetalle int NOT NULL,
	numPed int NOT NULL,
	codProd int NOT NULL,
	cant int NOT NULL,
	precioTot float NULL
);

-- EJERCICIO 2
INSERT INTO cliente(codCli,ape,nom,dir) VALUES (1,'LOPEZ','JOSE MARIA','Gral. Paz 3124');

SELECT * FROM cliente;

-- EJERCICIO 3
INSERT INTO cliente(codCli,ape,nom,dir,codPost) VALUES (1,'GERVASOLI','MAURO','San Luis 472',NULL);

SELECT * FROM cliente;

-- EJERCICIO 4
INSERT INTO proveed(razonSoc,dir) VALUES  ('FLUKE INGENIERIA','RUTA 1');
INSERT INTO proveed(razonSoc,dir) VALUES  ('GAREIS INGENIERIA','RUTA 2');

SELECT * FROM proveed;

-- EJERCICIO 5 
CREATE TABLE ventas(
	codVent int IDENTITY(1,1),
	fechaVent datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	usuarioDB varchar(40) NOT NULL DEFAULT USER,
	monto FLOAT NOT NULL
);

DROP TABLE ventas;

INSERT INTO ventas( monto ) VALUES (300);
SELECT * FROM ventas;

-- EJERCICIO 6
SELECT * INTO clistafe FROM cliente WHERE cliente.codPost = 3000;

SELECT * FROM dbo.clistafe ;
-- EJERCICIO 7
INSERT clistafe SELECT * FROM cliente;

SELECT * FROM dbo.clistafe ;

-- EJERCICIO 8
UPDATE dbo.clistafe SET dir = 'TCM 168' WHERE dir LIKE '%1%';

-- EJERCICIO 9
DELETE FROM clistafe WHERE codPost IS NULL;
