create database f2;

-- Ejercicio 1

create or replace function getNetProfitInMonth(anio INT,mes INT)
returns float as 
$$
declare 
	
	amount float := 0;
	r_row  RECORD;
	total  float;

	cursorsales cursor for
	select s.title_id,s.qty 
	from sales s 
	where extract(year from s.ord_date) = anio 
	and extract(month from s.ord_date) = mes; 

begin 
	open cursorsales;
	
	loop
		fetch next from cursorsales into r_row;
		exit when not found;
	
		total := (select t.price from titles t where t.title_id = r_row.title_id)*r_row.qty;
		amount := amount + total;
	
		--raise notice ' total : % amount : %',total, amount;
	end loop;
	
	close cursorsales;
	return amount;
end
$$
language plpgsql;

select * from sales ;
select getNetProfitInMonth(1994,9);


create or replace function maxSalesMonthInYear(anio INT)
returns int as 
$$
declare 
	maxProfitInYear float;
	profitmonth int;
begin
	maxProfitInYear:=(select max((select getNetProfitInMonth(
								  cast(extract(year from s.ord_date) as INT),
								  cast(extract(month from s.ord_date) as INT)))) 
					  from sales s 
					  where extract(year from s.ord_date) = anio);
					 
	profitmonth    :=(select extract(month from s.ord_date)
					  from sales s 
					  where extract(year from s.ord_date) = anio and 
					  (select getNetProfitInMonth(
								  cast(extract(year from s.ord_date) as INT),
								  cast(extract(month from s.ord_date) as INT))) = maxProfitInYear limit 1);
	raise notice ' profitmonth : % maxProfitInYear : %',profitmonth, maxProfitInYear;
	return profitmonth; 
	
end
$$
language plpgsql;

select maxSalesMonthInYear(1994);

create or replace function getMaxSalesPerYear()
returns table(anio int, mes int) as 
$$
declare 
	year_cur cursor for 
		select distinct cast(extract(year from s.ord_date) as int) as "year" 
		from sales s order by 1;
	aux_year int := 0;
	aux_month int := 0;
begin
	create temp table
	temp_yearmonths(
		anio int, 
		mes int  );
	
	open year_cur;
	loop
		fetch next from year_cur into aux_year;
		exit when not found;
		aux_month := (select maxSalesMonthInYear(aux_year));
		
		insert into temp_yearmonths(anio,mes) values (aux_year,aux_month);
	end loop;

	close year_cur;

	return query
	select * from temp_yearmonths;
	drop table if exists temp_yearmonths;
end
$$
language plpgsql;

select anio,mes from getMaxSalesPerYear();


create or replace function getMaxSalesPerYear2()
returns table(anio int, mes int) as 
$$
declare
	anio int;
	mes int;
begin
	create temp table
	temp_yearmonths(
		anio int, 
		mes int  );
	
	for anio in select distinct cast(extract(year from s.ord_date) as int) from sales s loop
		--Tengo el año ahora quiero el mes
		mes := 
		(select distinct cast(extract(month from s2.ord_date) as int) from sales s2 
		inner join 
			(select cast(extract(month from s3.ord_date) as int) as mdate, max(s3.qty*t.price) from sales s3 natural join titles t
			 where cast(extract(year from s3.ord_date) as int) = anio group by 1 order by 2 desc limit 1 ) 
			 maxsold 
		     on maxsold.mdate = cast(extract(month from s2.ord_date) as int)
		where cast(extract(year from s2.ord_date) as int) = anio);
		
		insert into temp_yearmonths(anio,mes) values (anio,mes);
	end loop;
	
	return query (select * from temp_yearmonths);
	drop table if exists temp_yearmonths;
end;
$$
language plpgsql;


select anio,mes from getMaxSalesPerYear2();


-- Ejercicio 2

-- connect to f2

create table proveedor (
	IDProveedor int,
	apeNOm varchar(30),
	domicilio  varchar(50),
	telefono varchar(20),
	constraint proveedor_pk primary key(IDProveedor)
);

create table producto  (
	IDProducto int,
	descripcion varchar(50),
	precio float,
	constraint prodcuto_pk primary key(IDProducto)
);

create table provpred (
	IDProducto int,
	IDProveedor int,
	constraint provpred_pk primary key (IDProducto,IDProveedor),
	constraint provpred_fk1 foreign key (IDProveedor) references proveedor(IDProveedor),
	constraint provpred_fk2 foreign key (IDProducto) references producto(IDProducto)
);

-- Inserting data into proveedor table
INSERT INTO proveedor (IDProveedor, apeNOm, domicilio, telefono)
VALUES
(1, 'John Doe', '123 Main St', '555-1234'),
(2, 'Jane Smith', '456 Elm St', '555-5678'),
(3, 'Michael Johnson', '789 Oak St', '555-9090');

-- Inserting data into producto table
INSERT INTO producto (IDProducto, descripcion, precio)
VALUES
(101, 'Product A', 19.99),
(102, 'Product B', 29.99),
(103, 'Product C', 14.99);

-- Inserting data into provpred table
INSERT INTO provpred (IDProducto, IDProveedor)
VALUES
(101, 1),
(101, 2),
(102, 2),
(103, 3);

select p.apenom, pr.descripcion from proveedor as p
natural join provpred as pp
natural join public.producto as pr;

select * from proveedor as p
natural join provpred as pp
natural join public.producto as pr;

-- Ejercicio 3

-- Se obtendra la union de state y city, por lo que obtendremos todos los valores que te ambas tablas donde coincida el state y city
