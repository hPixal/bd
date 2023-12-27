--Ejmplo de cursor

create or replace function get_film_titles(p_year integer)
   returns text as $$
declare 
	 titles text default '';
	 rec_film   record;
	 cur_films cursor(p_year integer) 
		 for select title, release_year
		 from film
		 where release_year = p_year;
begin
   -- open the cursor
   open cur_films(p_year);
	
   loop
    -- fetch row into the film
      fetch cur_films into rec_film;
    -- exit when no more row to fetch
      exit when not found;

    -- build the output
      if rec_film.title like '%ful%' then 
         titles := titles || ',' || rec_film.title || ':' || rec_film.release_year;
      end if;
   end loop;
  
   -- close the cursor
   close cur_films;

   return titles;
end; $$

language plpgsql;


--Ejercicio 1

create or replace function actualizarPrecio()
returns void as
$$ -- Anonymous block in PostgreSQL
declare
   curPrecios cursor for
   select price from titles
   where pub_id = '0736' -- Only titles from this publisher
   for update;

   precio numeric; -- Use 'numeric' for floating-point numbers in PostgreSQL

begin
   open curPrecios;
   loop
      fetch next from curPrecios into precio;
      exit when not found;
      if (precio <= 10) then
         update titles
         set price = price + price * 0.25
         where current of curPrecios;
      else
         update titles
         set price = price - price * 0.25
         where current of curPrecios;
      end if;
   end loop;
   close curPrecios;
   end
  $$
  language plpgsql;
 
select * from actualizarPrecio();

select * from titles;
select * from titles where pub_id = '0736';

-- Ejercicio 2

create or replace function actualizarPrecio2()
returns void as
$$ -- Anonymous block in PostgreSQL
declare
   curPrecios cursor for
   select price from titles
   where pub_id = '0736' -- Only titles from this publisher
   for update;
   iterator record;
   precio numeric; -- Use 'numeric' for floating-point numbers in PostgreSQL

begin
   open curPrecios;
   for iterator in (select count(*) from titles where titles.pub_id = '0736') loop
      fetch next from curPrecios into precio;
     
      if (precio <= 10) then
         update titles
         set price = price + price * 0.25
         where current of curPrecios;
      else
         update titles
         set price = price - price * 0.25
         where current of curPrecios;
      end if;
   end loop;
   close curPrecios;
   end
  $$
  language plpgsql;
  
 select * from actualizarPrecio();
 select * from titles where pub_id = '0736';
 
-- Ejercicio 3

create or replace function getTopPrices(topnum integer)
returns void as
$$
declare 
	cursorTipo cursor for
	select distinct type from titles;
	tipo varchar;
	it numeric;
begin
	open cursorTipo;
	loop
		fetch next from cursorTipo into tipo;
		exit when not found;
		raise notice 'Tipo: %, Top precios : ',tipo;
		for it in (select distinct price from titles where type = tipo order by price desc limit topnum )  loop
			raise notice '%',it;
		end loop;
	end loop;
	close cursorTipo;
end
$$
language plpgsql;

select * from getTopPrices(3);


-- Ejercicio 4
create or replace function autornativo()
returns table (lname varchar(40), fname varchar(40), pubid char(4), same bool) as
$$
declare
	cursorAuthor cursor for
		(select a.au_id , a.au_lname , a.au_fname , a.city 
		from authors a);
	cursorPubs cursor for
		(select p.pub_id, p.city 
		from publishers p);
	
	auidaux varchar(11);
	nameaux varchar(20);
	lnameaux varchar(20);
	acityaux varchar(20);
	pcityaux varchar(20);
	pubidaux char(4);
begin
	create temp table outTable (lname varchar(40), fname varchar(40), pubid char(4), same bool);
	open cursorAuthor;
	loop
		fetch next from cursorAuthor into auidaux,lnameaux,nameaux;
		exit when not found;
		open cursorPubs;
		loop
			fetch next from cursorPubs into pubidaux,pcityaux;
			exit when not found;
			if exists( select a.au_id from authors a 
						inner join titleauthor t on t.au_id
						inner join titles t2 on t2.title_id = t.title_id
						inner join publishers p on p.pub_id = t2.pub_id
						where a.au_id = auidaux and p.pub_id = pubidaux ) then 
					if exists( select a.au_id from authors a 
							inner join titleauthor t on t.au_id
							inner join titles t2 on t2.title_id = t.title_id
							inner join publishers p on p.pub_id = t2.pub_id
							where a.au_id = auidaux and p.pub_id = pubidaux and p.city = authors.city)	then 
								insert into outTable(lname,fname, pubid,same) values (lnameaux,nameaux,pubidaux,1);
								raise notice 'El autor : %, % vive en la misma ciudad de su publicador %',lnameaux,nameaux,pubidaux;
					else 
								insert into outTable(lname,fname, pubid,same) values (lnameaux,nameaux,pubidaux,0);
								raise notice 'El autor : %, % no vive en la misma ciudad de su publicador %',lnameaux,nameaux,pubidaux;
					end if;
			end if;	
		end loop;
		close cursorPubs;
	end loop;
	close cursorAuthor;
	return QUERY( select * from outTable);
end
$$
language plpgsql;

select autornativo();
select * from publishers p ;
select * from authors a ;
