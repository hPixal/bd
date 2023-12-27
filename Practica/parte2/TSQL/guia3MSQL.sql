-- EJERCICIO 1
SELECT * FROM authors;
SELECT * FROM titles;
SELECT * FROM dbo.titleauthor; 

SELECT a.au_lname + ', ' + a.au_fname AS 'Autor', t.title AS 'Titulo' FROM authors AS a 
	INNER JOIN titleauthor AS ta ON  ta.au_id = a.au_id 
	INNER JOIN titles AS t ON  t.title_id = ta.title_id ORDER BY 1;


-- EJERCICIO 2
SELECT e.lname + ' ' + e.fname AS 'Nombre del empleado', p.pub_name AS 'Editorial', e.job_lvl AS 'Nivel de trabajo' FROM dbo.employee AS e 
	INNER JOIN dbo.publishers AS p ON e.pub_id = p.pub_id
	WHERE e.job_lvl >= 200;

-- EJERCICIO 3
SELECT au.au_lname AS 'Apellido', au.au_fname AS 'Nombre' , sum(s.qty*t.price) AS 'Ingresos' FROM dbo.authors AS au
INNER JOIN dbo.titleauthor AS ta ON ta.au_id = au.au_id
INNER JOIN dbo.titles AS t ON t.title_id = ta.title_id 
INNER JOIN dbo.sales AS s ON s.title_id = t.title_id
GROUP BY au_lname,au.au_fname ORDER BY 'Ingresos' DESC;

-- EJERCICIO 4
SELECT DISTINCT t.type FROM dbo.titles AS t
WHERE 12 <= (SELECT SUM(price)/COUNT(price) FROM dbo.titles t2 WHERE t2.type = t.type);

-- EJERCICIO 5 
SELECT TOP 1 e.hire_date, e.lname  ,e.fname FROM dbo.employee AS e 
ORDER BY e.hire_date  DESC ;

-- EJERCICIO 6
SELECT p.pub_name  FROM dbo.publishers AS p 
INNER JOIN dbo.titles AS t ON t.pub_id = p.pub_id 
WHERE t.type  = 'business';

-- EJERCICIO 7
SELECT t.title FROM dbo.titles AS t
WHERE t.title_id NOT IN ( SELECT t2.title_id FROM dbo.titles t2 
	INNER JOIN dbo.sales s ON s.title_id = t2.title_id
	WHERE YEAR(s.ord_date) >= 1993 AND YEAR(s.ord_date) <= 1994 AND t2.title_id = t.title_id );

-- EJERCICIO 8
SELECT t.title, p.pub_name, t.price  FROM dbo.titles t
INNER JOIN dbo.publishers p ON p.pub_id = t.pub_id 
WHERE t.price < (SELECT SUM(t2.price)/COUNT(t2.price) FROM dbo.titles t2) ORDER BY t.price ;

-- EJERCICIO 9
SELECT a.au_fname,a.au_lname, CASE
	WHEN a.contract = 1 THEN 'Si'
	ELSE 'No'
	END AS 'Contrato'
FROM dbo.authors a;

-- EJERCICIO 10

SELECT e.lname ,e.fname , CASE
	WHEN e.job_lvl >= 0 AND e.job_lvl < 101 THEN 'PUNTAJE 0-100'
	WHEN e.job_lvl >= 0 AND e.job_lvl < 201 THEN 'PUNTAJE 101-200'
	WHEN e.job_lvl >= 0 AND e.job_lvl < 301 THEN 'PUNTAJE 201-300'
	ELSE 'PUNTAJE +300'
	END AS 'NIVEL'
FROM dbo.employee e;
