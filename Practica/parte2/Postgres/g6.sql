--  Ejercicio 1

create or replace function aviso_eliminacion_authors()
returns trigger as
$$
begin 
	raise notice 'se eliminó la columna de % con el atributo con au_id de valor %',TG_TABLE_NAME,old.au_id;
	return new;
end
$$
language plpgsql;


create or replace trigger ejercicio1a
before delete on authors
for each row 
execute function aviso_eliminacion_authors();


-- Ejercicio 2

create or replace function aviso_filas_afectadas()
returns trigger as
$$
begin 
	raise notice '% Columnas fueron afectadas',TG_NARGS;
	return new;
end
$$
language plpgsql;


create or replace trigger ejercicio1b
before delete or update or insert on authors
for each statement  
execute function aviso_filas_afectadas();

select * from authors;

insert into authors (au_id,au_lname,au_fname,phone,address,city,state,zip,contract) values
	 ('409-56-7008','Bennet','Abraham','415 658-9932','6223 Bateman St.','Berkeley','CA','94705',1);
	
delete from authors where au_id = '409-56-7008';


-- Ejercicio 3

create or replace function aviso_stock_negativo()
returns trigger as
$$
begin 
	if new.stock < 0 then
	raise exception 'El stock debe ser positivo'
	using ERRCODE = 'system_error', 
		  HINT= 'Checkea que en la inserción no estes metiendo valores negativos';
	end if;
	return new;
end;
$$ language plpgsql;

select * from productos;

create or replace trigger ejercicio3
before insert on productos
for each row 
execute function  aviso_stock_negativo();

insert into productos(codprod,descr,precunit,stock) values (30,'Articulo 3',80,-1);

-- Ejercicio 4

create or replace function denegar_pocas_ventas()
returns trigger as
$$
begin 
	if (new.ytd_sales*new.price) < 1500 then
	raise exception 'El titulo tiene muy pocas ventas'
	using ERRCODE = 'system_error';
	end if;
	return new;4
end;
$$ language plpgsql;

select * from productos;

create or replace trigger ejercicio4
before insert on titles
for each row 
execute function  denegar_pocas_ventas();

select * from titles;