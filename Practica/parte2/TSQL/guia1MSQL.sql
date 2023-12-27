
SELECT au_lname AS 'Apellido del autor', city AS 'Ciudad' FROM authors;

-- EJERCICIO 1
SELECT *,price*1.08 AS 'PRECIO ACTUALIZADO' FROM  titles;

-- EJERCICIO 2
SELECT *,price*1.08 AS 'PRECIO ACTUALIZADO' FROM titles WHERE titles.type = 'business';

-- EJERCICIO 3
SELECT *,price*1.08 AS 'PRECIO ACTUALIZADO' FROM  titles ORDER BY 'PRECIO ACTUALIZADO' DESC;

-- EJERCICIO 4
SELECT *,price*1.08 AS 'PRECIO ACTUALIZADO' FROM  titles ORDER BY 11 DESC;

-- EJERCICIO 5
SELECT * FROM authors;
SELECT  authors.au_lname + ', ' + authors.au_fname AS 'NOMBRE AUTOR' FROM authors;

-- EJERCICIO 6
SELECT * FROM titles;
SELECT title_id + ' tiene un valor de $' + CAST(price AS VARCHAR) FROM titles;
