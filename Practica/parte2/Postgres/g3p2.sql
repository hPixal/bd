--- Este se hace en la base de datos pubs 

---Ejercicio 1

select * from authors;
select * from titles;
select * from titleauthor;

select authors.au_id as "ID_Autor" ,authors.au_lname as "Nombre" ,authors.au_fname as "Apellido", titles.title as "Titulo de obra" 
from titleauthor
inner join authors  on  titleauthor.au_id = authors.au_id
inner join titles on titleauthor.title_id = titles.title_id
order by titles.title;

---Ejercicio 2

select * from publishers;
select * from employee;

select  publishers.pub_name, employee.fname || ' ' || employee.lname as "Nombre de empleado", employee.job_lvl, employee.job_lvl 
from publishers
inner join employee on employee.pub_id = publishers.pub_id 
where employee.job_lvl > 200;

---Ejercicio 3

select authors.au_lname, authors.au_fname, sum(sales.qty*titles.price) as "Ingresos"
from titles 
inner join sales on sales.title_id = titles.title_id
inner join titleauthor on titleauthor.title_id = titles.title_id 
inner join authors on authors.au_id = titleauthor.au_id
group by authors.au_lname, authors.au_fname order by "Ingresos" desc;


---Ejercicio 4

with consulta_promedio as (
	select authors.au_lname, authors.au_fname, sum(sales.qty*titles.price)/sum(sales.qty) as "IngresoPromedio"
	from titles
	inner join sales on sales.title_id = titles.title_id
	inner join titleauthor on titleauthor.title_id = titles.title_id 
	inner join authors on authors.au_id = titleauthor.au_id
	group by authors.au_lname , authors.au_fname )
select * from consulta_promedio where "IngresoPromedio" > 12;

---Ejercicio 5

    SELECT
        employee.lname,
        employee.fname,
        employee.hire_date AS fecha_ini
    FROM
        employee 
    WHERE
        employee.hire_date = (SELECT MAX(hire_date) FROM employee)

---Ejercicio 6
        
   select 
   		publishers.pub_id ,publishers.pub_name 
   		from publishers 
   		inner join titles on titles.pub_id = publishers.pub_id 
   		where titles.type  = 'business';
   	
   	
---Ejercicio 7
   	   select 
   		titles.title_id  ,titles.title  
   		from titles 
   		inner join sales on sales.title_id  = titles.title_id
   		where date_part('year',sales.ord_date) < 1993 or date_part('year',sales.ord_date) > 1994;

---Ejercicio 8
   	
   	select
	titles.title_id, publishers.pub_id, titles.price 
	from titles
	inner join publishers on publishers.pub_id = titles.pub_id 
	where titles.price < ( select sum(titles.price)/count(titles.price) from titles);
	
---Ejercicio 9

select *,
	case
		when authors.contract = 0 then 'no tiene contrato'
		when authors.contract = 1 then 'tiene contrato'
		else 'error'
	end as contract_status
	from authors;
	
---Ejercicio 10

select employee.lname ,
	case
		when employee.job_lvl >= 0   and employee.job_lvl < 100 then 'nivel entre 0 y 100'
		when employee.job_lvl >= 100 and employee.job_lvl < 200 then 'nivel entre 100 y 200'
		when employee.job_lvl >= 200 and employee.job_lvl < 300 then 'nivel entre 200 y 300'
		else 'tiene una banda'
	end as estado_nivel
	from employee order by employee.job_lvl desc;
	
	
		