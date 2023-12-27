-- La verdad que no entiendo la consigna del ejercicio 1

-- Ejercicio 2
CREATE DATABASE f3;
USE f3;


-- NIVEL 1
CREATE TABLE sucursal(
	idSucursal int,
	nomSucursal varchar(30) not null,
	CONSTRAINT sucursal_pk PRIMARY KEY (idSucursal)
); 

CREATE TABLE producto(
	idProducto INT,
	nomProducto VARCHAR(48) NOT NULL,
	precio FLOAT NOT NULL,
	CONSTRAINT producto_pk PRIMARY KEY (idProducto)
);

-- NIVEL 2
CREATE TABLE deposito(
	idDeposito INT,
	idSucursal INT NOT NULL,
	nomDeposito varchar(48) NOT NULL,
	CONSTRAINT deposito_pk PRIMARY KEY (idDeposito),
	CONSTRAINT deposito_fk FOREIGN KEY (idSucursal) REFERENCES sucursal(idSucursal)
);

CREATE TABLE localventa(
	idLocal SMALLINT,
	idSucursal INT NOT NULL,
	nomLocal VARCHAR(48) NOT NULL,
	CONSTRAINT localventa_pk PRIMARY KEY (idLocal),
	CONSTRAINT localventa_fk FOREIGN KEY (idSucursal) REFERENCES sucursal(idSucursal) 
);

-- NIVEL 3
CREATE TABLE depProd (
	idDeposito INT,
	idProducto INT,
	cantidad INT NOT NULL,
	CONSTRAINT depProd_pk PRIMARY KEY (idDeposito,idProducto),
	CONSTRAINT depProd_fk1 FOREIGN KEY (idDeposito) REFERENCES deposito(idDeposito),
	CONSTRAINT depProd_fk2 FOREIGN KEY (idProducto) REFERENCES producto(idProducto)
);

CREATE TABLE localProd (
	idLocal SMALLINT,
	idProducto INT,
	cantidad INT NOT NULL,
	CONSTRAINT localProd_pk PRIMARY KEY (idLocal,idProducto),
	CONSTRAINT localProd_fk1 FOREIGN KEY (idLocal) REFERENCES localventa(idLocal),
	CONSTRAINT localProd_fk2 FOREIGN KEY (idProducto) REFERENCES producto(idProducto)
);

-- Insertar datos en la tabla sucursal
INSERT INTO sucursal (idSucursal, nomSucursal)
VALUES
    (1, 'Sucursal A'),
    (2, 'Sucursal B'),
    (3, 'Sucursal C');
-- Insertar datos en la tabla producto
INSERT INTO producto (idProducto, nomProducto, precio)
VALUES
    (101, 'Producto X', 25.99),
    (102, 'Producto Y', 19.50),
    (103, 'Producto Z', 35.75);
-- Insertar datos en la tabla deposito
INSERT INTO deposito (idDeposito, idSucursal, nomDeposito)
VALUES
    (1, 1, 'Depósito Sucursal A'),
    (2, 2, 'Depósito Sucursal B'),
    (3, 3, 'Depósito Sucursal C');
-- Insertar datos en la tabla localventa
INSERT INTO localventa (idLocal, idSucursal, nomLocal)
VALUES
    (101, 1, 'Local Venta Sucursal A'),
    (102, 2, 'Local Venta Sucursal B'),
    (103, 3, 'Local Venta Sucursal C');
-- Insertar datos en la tabla depProd (relacionando productos con depósitos)
INSERT INTO depProd (idDeposito, idProducto, cantidad)
VALUES
    (1, 101, 50),
    (2, 102, 75),
    (3, 103, 60);
-- Insertar datos en la tabla localProd (relacionando productos con locales de venta)
INSERT INTO localProd (idLocal, idProducto, cantidad)
VALUES
    (101, 101, 30),
    (102, 102, 45),
    (103, 103, 20);

-- CONSIGNA : OBTENER EL NOMBRE DE TODAS LAS SUCURSALES QUE POSEAN MÁS CANTIDAD DE ARTICULOS EN SUS DEPOSITOS QUE EN SUS LOCALES. RESOLVER SIN EXENTENSIONES, SQL PURO.
SELECT * FROM dbo.sucursal;

SELECT s.idSucursal , s.nomSucursal ,dp.cantidad as 'cantidad deposito', lp.cantidad as 'cantidad local', p.idProducto as 'producto'
FROM dbo.sucursal s
	JOIN dbo.localventa l ON l.idSucursal = s.idSucursal 
	JOIN dbo.deposito d   ON d.idSucursal = s.idSucursal 
	JOIN dbo.depProd dp   ON dp.idDeposito = d.idDeposito 
	JOIN dbo.localProd lp ON lp.idLocal = l.idLocal 
	JOIN dbo.producto p   ON p.idProducto = lp.idProducto 
						 AND p.idProducto = dp.idProducto 
WHERE dp.cantidad > lp.cantidad ;
--ez