--- Ejercicio 3

create table consumidor (
	idConsumidor integer not null,
	apellido varchar(50) not null,
	nombre varchar(50) not null,
	domicilio varchar(60) not null,
	email varchar(50) null,
	constraint consumidor_pk primary key(id_consumidor)
);

-- Insertar valores de prueba en la tabla consumidor
INSERT INTO consumidor (idConsumidor, apellido, nombre, domicilio, email)
VALUES
  (1, 'Pérez', 'Juan', 'Calle 123, Ciudad A', 'juan.perez@email.com'),
  (2, 'López', 'María', 'Avenida XYZ, Ciudad B', 'maria.lopez@email.com'),
  (3, 'González', 'Carlos', 'Calle 456, Ciudad C', NULL),
  (4, 'Rodríguez', 'Ana', 'Calle 789, Ciudad D', 'ana.rodriguez@email.com');

  -- Insertar valores de prueba para la familia en la misma casa
INSERT INTO consumidor (idConsumidor, apellido, nombre, domicilio, email)
VALUES
  (5, 'Pérez', 'Laura', 'Calle 123, Ciudad A', 'laura.perez@email.com'),
  (6, 'Pérez', 'Pedro', 'Calle 123, Ciudad A', 'pedro.perez@email.com'),
  (7, 'Pérez', 'Sofía', 'Calle 123, Ciudad A', 'sofia.perez@email.com'),
  (8, 'López', 'Luis', 'Avenida XYZ, Ciudad B', 'luis.lopez@email.com'),
  (9, 'González', 'Elena', 'Calle 456, Ciudad C', 'elena.gonzalez@email.com'),
  (10, 'González', 'Javier', 'Calle 456, Ciudad C', 'javier.gonzalez@email.com'),
  (11, 'Rodríguez', 'Mario', 'Calle 789, Ciudad D', 'mario.rodriguez@email.com');

drop table consumidor;
delete from consumidor where idconsumidor = 11;


 create or replace function cuentaFamilia (id  integer) 
 returns integer as
 $$
 declare 
 	domi varchar(60) := (select consumidor.domicilio from consumidor where consumidor.idconsumidor = id);
 	cuenta integer := (select count(idconsumidor) from consumidor where consumidor.domicilio = domi);
 begin
	 cuenta := cuenta -1;
 	if (cuenta > 0) then
 		return cuenta;
 	else
 		return null;
 	end if;
 end;
 $$ language plpgsql;

select cuentaFamilia(1);
 
 create or replace function tieneFamilia (id  integer) 
 returns varchar(2) as
 $$
 declare 
 	domi varchar(60) := (select consumidor.domicilio from consumidor where consumidor.idconsumidor = id);
 	cuenta integer := (select count(idconsumidor) from consumidor where consumidor.domicilio = domi);	
 begin
 	if (cuenta > 1) then
 		return 'si';
 	else
 		return 'no';
 	end if;
 end;
 $$ language plpgsql;

select tieneFamilia(4);

 create or replace function ejercicio3()
 returns table (idConsumidor integer, apellido varchar(50), nombre varchar(50), cond1 varchar(2), cond2 integer) as
 $$
 begin 
 	return query (select consumidor.idconsumidor,consumidor.nombre,consumidor.apellido, tieneFamilia(consumidor.idconsumidor), cuentaFamilia(consumidor.idconsumidor) from consumidor );
 end
 $$ language plpgsql;

 create or replace function ejercicio3bis()
 returns table (idConsumidor integer, apellido varchar(50), nombre varchar(50), cond1 varchar(2), cond2 integer) as
 $$
 begin 
 	return query (select consumidor.idconsumidor,consumidor.nombre,consumidor.apellido, tieneFamilia(consumidor.idconsumidor), cuentaFamilia(consumidor.idconsumidor) from consumidor );
 end
 $$ language plpgsql;


drop function ejercicio3();
 
select ejercicio3();
select consumidor.idconsumidor,consumidor.nombre,consumidor.apellido, tieneFamilia(idconsumidor), cuentaFamilia(idconsumidor) from consumidor ;