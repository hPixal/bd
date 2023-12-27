--- Este select te crea otra columna al final con el precio actualizado

select *,price*1.08 from titles;

--- Esta consulta es para que te des cuenta que se te organiza solo por abecedario
select au_lname as Apellido, city as Ciudad from authors;

select * from titles where type = 'business';

--- Desc dice descendente order by bueno, medio obvio
select title_id,title,price*1.08 as precionuevo from titles order by precionuevo desc;

--- Tambien podes seleccionar el numero de columna aca selecciona en base a advance descendente
select * from  titles  order by 6 desc;

--- aca selecciona en base a price descendente
select * from  titles  order by 5 desc;

--- Podes concatenar texto con ||
select  'Empleado del mes: ' || lname as "Datos de empleado" from employee;

--- Podes concatenar datos de esta manera
select * from authors;
select * from titleauthor;

select 'Nombre del autor: ' || au_lname || ', ' ||  au_fname as "Autores" from authors;

--- Cast para castear datos de una forma a otra

select * from titles;
select title_id || ': tiene un precio de $' || cast (price as char(3)) from titles ; 

--- CLAUSULA WHERE

select  column_name,data_type from information_schema.columns where table_name = 'titles';
select * from titles where price < 14;

select * from titles where price between  7 and 13;

select * from employee where hire_date between '1988-01-01' and '1990-01-01';

-- Podes seleccionar una lista de precios especificos con la clausula in ojo son los que son exactamente lo especificado, no los valores entre medio

select * from titles where price in(20,11.95,7.99);

-- PREDICADO LIKE

select  * from titles;
select * from titles where title like '%Is%';
select * from titles where title like '_motional%';

select * from titles where title like '%_omputer%'

-- NULL

select * from publishers where state is null;

--- Fechas

select * from sales;

select * from sales where date_part('month',ord_date) = 5;




