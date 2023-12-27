--Ejercicio 1

create or replace function obtenerPrecios(id varchar(6))
	returns numeric(10,2) as $$
	begin
	return 
	(select titles.price from titles
	where titles.title_id = id );
	end
$$ language plpgsql;
	
drop function obtenerPrecios(character varying);
select  * from titles;
select obtenerPrecios('PC1035');

---Ejercicio 2

select * from sales;
select * from publishers;

create or replace function getSaleDate(storid varchar(4),ordnum varchar(20))
	returns date as
	$$
	 begin 
	 	return (select sales.ord_date from sales
	 			where sales.ord_num = ordnum and sales.stor_id = storid );
	 end
	$$
language plpgsql;

drop function getsaledate(character,character varying);
select getSaleDate('7067','D4482');

--Ejercicio 3

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
 SERIAL,
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


-- EJercicio 4 p1

insert into productos (codprod ,descr ,precunit, stock ) values (10,'Articulo 1',50,20);
insert into productos (codprod ,descr ,precunit, stock ) values (20,'Articulo 2',70,40);
	
create or replace function insertarDetalle(cd int,cp int,nped int,n int)
returns void as
	$$
	declare
		preciototal float;
	begin 
		if exists (select 1 from productos where productos.codprod = cp) then
			preciototal = (select buscarPrecioTotal(cp,n));
			insert into detalle(codDetalle,numped,codProd,cant,preciotot) values (cd,cp,nped,n,preciototal);
		else 
			raise exception 'CodProd does not exist, not performing action.';
		end if;
	end
	$$
language plpgsql;

select * from productos;
select insertarDetalle(1,20,19,2);
select * from  detalle ;


-- EJercicio 4 p2

create or replace function buscarPrecioTotal( codpro integer , cant integer )
returns float as
		$$
		declare 
			precioFinal float;
		begin 
			precioFinal = (select precUnit*cant from productos where productos.codprod = codpro );
			return precioFinal;
		end
		$$
language plpgsql;






