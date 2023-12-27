
-- EJERCICIO 1

CREATE PROCEDURE actualizarPrecio(@pub_id CHAR(4),@amount FLOAT)
AS
BEGIN
	DECLARE titleCursor CURSOR FOR 
		SELECT t.title_id, t.price 
		FROM dbo.titles t 
		WHERE t.pub_id = @pub_id;

	DECLARE @new_price FLOAT;
	DECLARE @title_id_aux VARCHAR(6);
	DECLARE @price_aux FLOAT;
	
	OPEN titleCursor;
	FETCH NEXT FROM titleCursor INTO @title_id_aux,@price_aux;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @new_price = @price_aux + @price_aux * @amount;
	
		UPDATE dbo.titles 
		SET dbo.titles.price = @new_price
		WHERE dbo.titles.title_id = @title_id_aux;
	
		FETCH NEXT FROM titleCursor INTO @title_id_aux,@price_aux;
	END;
	
	CLOSE titleCursor;
	DEALLOCATE titleCursor;
END

DROP PROCEDURE actualizarPrecio;
EXEC actualizarPrecio @pub_id = '0736', @amount = 0.25;

SELECT * FROM dbo.publishers p;
SELECT * FROM dbo.titles t ;
SELECT t.title_id , t.price FROM dbo.titles t WHERE t.pub_id = '0736';

-- EJERCICIO 2 

-- No es posible en T-SQL

-- EJERCICIO 3

CREATE PROCEDURE obtener3CarosCategoria
AS
BEGIN
	DECLARE cursorCategoria CURSOR FOR
		SELECT DISTINCT t.type
		FROM dbo.titles AS t;
	
	DECLARE @aux_type CHAR(12);
	DECLARE @t1 FLOAT;
	DECLARE @t2 FLOAT;
	DECLARE @t3 FLOAT;

	OPEN cursorCategoria;
	
	FETCH NEXT FROM cursorCategoria INTO @aux_type;
	WHILE @@FETCH_STATUS = 0 BEGIN
		SET @t1 = NULL;
		SET @t2 = NULL;
		SET @t3 = NULL;
	
		SELECT @t1 = t.price FROM dbo.titles t WHERE t.type = @aux_type ORDER BY t.price DESC OFFSET 0 ROWS FETCH NEXT 1 ROW ONLY;
		SELECT @t2 = t.price FROM dbo.titles t WHERE t.type = @aux_type ORDER BY t.price DESC OFFSET 1 ROWS FETCH NEXT 1 ROW ONLY;
		SELECT @t3 = t.price FROM dbo.titles t WHERE t.type = @aux_type ORDER BY t.price DESC OFFSET 2 ROWS FETCH NEXT 1 ROW ONLY;
	
		PRINT 'PUBLICACIONES MÁS CARAS DEL GENERO: ' + CAST(@aux_type AS VARCHAR);
		PRINT '--------------------------------------------------- ';
		PRINT 'TOP 1: ' + CAST(@t1 AS VARCHAR);
		PRINT 'TOP 2: ' + CAST(@t2 AS VARCHAR);
		PRINT 'TOP 3: ' + CAST(@t3 AS VARCHAR);
	
		FETCH NEXT FROM cursorCategoria INTO @aux_type;
	END;
	
	CLOSE cursorCategoria;
	DEALLOCATE cursorCategoria;
END

DROP PROCEDURE obtener3CarosCategoria;

EXEC  dbo.obtener3CarosCategoria;

SELECT t.price FROM dbo.titles t WHERE t.type = 'mod_cook' ORDER BY t.price DESC;
SELECT TOP 1 t.price FROM dbo.titles t WHERE t.type = 'business' ORDER BY t.price DESC;
SELECT t.price FROM dbo.titles t WHERE t.type = 'business' ORDER BY t.price DESC OFFSET 0 ROWS FETCH NEXT 1 ROW ONLY;
SELECT t.price FROM dbo.titles t WHERE t.type = 'business' ORDER BY t.price DESC OFFSET 1 ROWS FETCH NEXT 1 ROW ONLY;
SELECT t.price FROM dbo.titles t WHERE t.type = 'business' ORDER BY t.price DESC OFFSET 2 ROWS FETCH NEXT 1 ROW ONLY;

-- EJERCICIO 4

CREATE FUNCTION publicadorNatal()
RETURNS TABLE AS 
BEGIN
    DECLARE @au_id_aux VARCHAR(12);
    DECLARE @city_aux VARCHAR(20);
    DECLARE @au_fname_aux VARCHAR(40);
    DECLARE @au_lname_aux VARCHAR(40);
    DECLARE @pub_id_aux CHAR(4);
    DECLARE @msg VARCHAR(255);

    DECLARE @output TABLE (
        au_lname VARCHAR(40),
        au_fname VARCHAR(40),
        same BIT
    );

    DECLARE cursorAutor CURSOR FOR 
        SELECT au_id, city  
        FROM dbo.authors;

    OPEN cursorAutor;
    FETCH NEXT FROM cursorAutor INTO @au_id_aux, @city_aux;

    WHILE @@FETCH_STATUS = 0 BEGIN
        IF EXISTS (
            SELECT a.au_fname, a.au_lname, p.pub_id 
            FROM dbo.authors a 
            INNER JOIN dbo.titleauthor t ON t.au_id = @au_id_aux
            INNER JOIN dbo.titles t2 ON t2.title_id = t.title_id
            INNER JOIN dbo.publishers p ON t2.pub_id = p.pub_id 
            WHERE @city_aux = p.city
        )
        BEGIN
            SELECT @au_fname_aux = a.au_fname, @au_lname_aux = a.au_lname, @pub_id_aux = p.pub_id 
            FROM dbo.authors a 
            INNER JOIN dbo.titleauthor t ON t.au_id = @au_id_aux
            INNER JOIN dbo.titles t2 ON t2.title_id = t.title_id
            INNER JOIN dbo.publishers p ON t2.pub_id = p.pub_id 
            WHERE @city_aux = p.city;
            SET @msg = 'El autor: ' + @au_lname_aux + ', ' + @au_fname_aux + ' vive en la misma ciudad que la editora de codigo: ' + @pub_id_aux;
            INSERT INTO @output (au_lname, au_fname, same)
            VALUES (@au_lname_aux, @au_fname_aux, 1);
        END;
        PRINT @msg;
        FETCH NEXT FROM cursorAutor INTO @au_id_aux, @city_aux;
    END;
    CLOSE cursorAutor;
    DEALLOCATE cursorAutor;
    RETURN ( SELECT * FROM @output );
END;

SELECT * FROM dbo.authors;
SELECT * FROM dbo.publishers;
SELECT a.au_fname,a.au_lname 
				  	FROM dbo.authors a 
				  	INNER JOIN dbo.titleauthor t  ON t.au_id = a.au_id 
				  	INNER JOIN dbo.titles t2 ON t2.title_id = t.title_id
				  	INNER JOIN dbo.publishers p ON t2.pub_id = p.pub_id 
				  	WHERE a.city  = p.city;

SELECT a.au_fname,a.au_lname 
				  	FROM dbo.authors a 
				  	INNER JOIN dbo.titleauthor t  ON t.au_id = a.au_id 
				  	INNER JOIN dbo.titles t2 ON t2.title_id = t.title_id
				  	INNER JOIN dbo.publishers p ON t2.pub_id = p.pub_id 
				  	WHERE a.city != p.city;


