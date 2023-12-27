CREATE TABLE cliente
(codCli int NOT NULL,
ape  varchar(30) NOT NULL,
nom varchar(30) NOT NULL,
dir varchar(40) NOT NULL,
codPost char(9) NULL DEFAULT 3000);

CREATE TABLE productos
(
codProd int NOT NULL,
descr varchar(30) NOT NULL,
precUnit float NOT NULL,
stock smallint NOT NULL
);

CREATE TABLE proveed(
codProv SERIAL,
razonSoc varchar(30)  NOT NULL,
dir varchar(30) NOT NULL);

CREATE TABLE pedidos(
numPed int NOT NULL,
fechPed date NOT NULL,
codCli int NOT NULL
);

CREATE TABLE detalle(
codDetalle int NOT NULL,
numPed int NOT NULL,
codProd int NOT NULL,
cant int NOT NULL,
precioTot float NULL
);

-- Ejercicio 2

insert into cliente (codCli, ape,nom,dir,codPost) values (1,'LOPEZ','JOSE MARIA','Gral Paz 3124',NULL);
insert into cliente (codCli, ape,nom,dir) values (2,'GERVASOLI','MAURO','San luis 472');
select  * from cliente;

-- Ejercicio 3

insert into proveed (razonSoc,dir) values ('Fluke Ingenieria','ruta 12 km 8');
select * from proveed;

-- Ejercicio 4
select * from current_user;
insert into pedidos (numPed,fechPed,codCLi) values (1,now(),3);

select * from pedidos;

-- Ejercicio 5
create table ventas(
	codVentas serial not null,
	fechVenta date not null default now(),
	usuarioDB varchar(30) not null default current_user,
	monto float not null
);