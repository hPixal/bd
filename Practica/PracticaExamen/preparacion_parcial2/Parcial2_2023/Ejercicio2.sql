-- Hacer en pubs

create table ventas as table sales;
drop table ventas;

insert into ventas values ('7067','P2121', '06/15/1992',10,'ON voice','TC7777');

create or replace function ventas_fc()
returns trigger as $$
declare
	entries numeric = (select count(*) from ventas where  ventas.stor_id = new.stor_id and ventas.ord_num = new.ord_num and ventas.title_id = new.title_id and ventas.ord_date = new.ord_date)-1;
	nqty numeric = (select sum(qty) from ventas where ventas.stor_id = new.stor_id and ventas.ord_num = new.ord_num and ventas.title_id = new.title_id and ventas.ord_date = new.ord_date);
	curs cursor for select qty from ventas where  ventas.stor_id = new.stor_id and ventas.ord_num = new.ord_num and ventas.title_id = new.title_id and ventas.ord_date = new.ord_date;
	it integer;
	aux integer;
begin
	open curs;
	raise notice 'nqty %',nqty;
	for it in 1..entries loop
		fetch next from curs into aux ;
		delete from ventas where current of curs;
	end loop;
	
	--delete from ventas where ventas.stor_id = new.stor_id and ventas.ord_num = new.ord_num and ventas.title_id = new.title_id limit 1; 
	update ventas set stor_id = new.stor_id , ord_num = new.ord_num, ord_date = new.ord_date,qty = nqty , payterms = new.payterms, title_id = new.title_id  where ventas.stor_id = new.stor_id and ventas.ord_num = new.ord_num and ventas.title_id = new.title_id;
	close curs;
	return new;
end
$$ language plpgsql;

create trigger ventas_tg 
after insert on ventas
for each row 
execute function ventas_fc();


select * from ventas where stor_id = '7067'; 


