-- EJERCICIO 1
CREATE FUNCTION buscarPrecio (@codigo VARCHAR(6))
RETURNS FLOAT
AS
BEGIN
    DECLARE @precio FLOAT
    SET @precio = (SELECT t.price FROM dbo.titles t WHERE t.title_id = @codigo)
    RETURN @precio
END;

SELECT dbo.buscarPrecio('BU1032');

SELECT * FROM dbo.titles t;

-- EJERCICIO 2
CREATE FUNCTION buscarFecha(@stor_id VARCHAR(4),@ord_num VARCHAR(20))
RETURNS DATE
AS
BEGIN
    DECLARE @date DATE
    SET @date = (SELECT DISTINCT s.ord_date  FROM dbo.sales s WHERE s.stor_id  = @stor_id AND s.ord_num = @ord_num )
    RETURN @date
END;

DROP FUNCTION buscarFecha;
SELECT * FROM dbo.sales;
SELECT dbo.buscarFecha('7067','P2121');

-- EJERCICIO 3 

drop table cliente;
CREATE TABLE cliente
(
codCli
 int
 NOT NULL,
ape
 varchar(30)
 NOT NULL,
nom
 varchar(30)
 NOT NULL,
dir
 varchar(40)
 NOT NULL,
codPost
 char(9)
 NULL DEFAULT 3000
);

drop table productos;
CREATE TABLE productos
(
codProd
 int
 NOT NULL,
descr
 varchar(30)
 NOT NULL,
precUnit float
 NOT NULL,
stock
 smallint
 NOT NULL
);

drop table proveed;
CREATE TABLE proveed
(
codProv
 IDENTITY(1,1),
razonSoc varchar(30)
 NOT NULL,
dir
 varchar(30)
 NOT NULL
);

drop table pedidos;
CREATE TABLE pedidos
(numPed
 int not null,
fechPed
 date not null,
codCli
 int not null);

drop table detalle;
CREATE TABLE detalle
(
codDetalle
 int
 NOT NULL,
numPed
 int
 NOT NULL,
codProd
 int
 NOT NULL,
cant
 int
 NOT NULL,
precioTot
 float
 NULL
);

insert into productos (codprod ,descr ,precunit, stock ) values (10,'Articulo 1',50,20);
insert into productos (codprod ,descr ,precunit, stock ) values (20,'Articulo 2',70,40);

-- EJERCICIO 4
CREATE FUNCTION buscarPrecio(@cod_prod INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @precio FLOAT
    SET @precio = (SELECT p.precUnit FROM dbo.productos p WHERE p.codProd = @cod_prod)
    RETURN @precio
END;
SELECT dbo.buscarPrecio(10);

CREATE PROCEDURE insertarDetalle(@cod_det INT,@numped INT,@cod_prod INT,@cant INT)
AS
BEGIN
    DECLARE @precio_tot FLOAT;
    IF EXISTS(SELECT dbo.buscarPrecio(@cod_prod)) BEGIN
    	SET @precio_tot = (SELECT dbo.buscarPrecio(@cod_prod))*@cant;
    	INSERT INTO dbo.detalle(codDetalle,numPed,codProd,cant,precioTot) VALUES (@cod_det,@numped,@cod_prod,@cant,@precio_tot);
    END
    ELSE
    BEGIN
    	THROW 51000, 'PRICE NOT FOUND',1;
    END;
END;

SELECT * FROM dbo.detalle;
EXEC insertarDetalle @cod_det = 1520,@numped = 120,@cod_prod = 10,@cant = 2;
