 -- drop database pubs; // DANGER!!!

create table autores as table authors; -- Duplico la tabla authors para hacer pruebas en ella

-- Ejercicio 1

create or replace function delete_fc_autores()
returns trigger  as $$
	begin
		raise notice 'se elinimino %',old.au_id;
		return new;
	end
$$ language plpgsql;



create trigger delete_tr_autores
	before delete on autores
	for each row
	execute function delete_fc_autores();

delete from autores where au_id = '409-56-7008';
select * from autores where au_id = '409-56-7008';

drop trigger delete_tr_autores on autores;
drop function delete_fc_autores;

select * from autores limit 1;
	
-- Ejercicio 2

-- No se puede hacer en postgresql

-- Ejercicio 3


