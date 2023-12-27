
-- EJERCICIO 1
USE pubs;

SELECT * INTO authors2 FROM dbo.authors;
DROP TABLE dbo.authors2;

CREATE TRIGGER tg_ej1 ON dbo.authors2
AFTER DELETE 
AS
BEGIN
	PRINT 'SE ELIMINARION ' + CAST(@@ROWCOUNT AS VARCHAR) + ' FILAS';
END
DROP TRIGGER dbo.tg_ej1;

DELETE FROM dbo.authors2 WHERE au_id = '172-32-1176' OR  au_id = '213-46-8915';

-- EJERCICIO 2
USE pubs;

-- Crear una tabla de registro para almacenar los datos afectados por el trigger
CREATE TABLE TransactionLog (
    LogMessage NVARCHAR(MAX)
);

-- Crear el trigger para la tabla autores
CREATE TRIGGER tg_ej2
ON dbo.authors2 
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @InsertedData NVARCHAR(MAX);
    DECLARE @DeletedData NVARCHAR(MAX);

    -- Obtener los datos insertados
    SET @InsertedData = (SELECT 'Datos insertados en transaction log:' + CHAR(13) +
                                'au_id: ' + CONVERT(NVARCHAR(MAX), (SELECT au_id FROM INSERTED)) + CHAR(13) +
                                'au_lname: ' + CONVERT(NVARCHAR(MAX), (SELECT au_lname FROM INSERTED)) + CHAR(13) +
                                'au_fname: ' + CONVERT(NVARCHAR(MAX), (SELECT au_fname FROM INSERTED)) + CHAR(13) +
                                'address: ' + CONVERT(NVARCHAR(MAX), (SELECT address FROM INSERTED)) + CHAR(13) +
                                'city: ' + CONVERT(NVARCHAR(MAX), (SELECT city FROM INSERTED)) + CHAR(13) +
                                'state: ' + CONVERT(NVARCHAR(MAX), (SELECT state FROM INSERTED)) + CHAR(13) +
                                'zip: ' + CONVERT(NVARCHAR(MAX), (SELECT zip FROM INSERTED)) + CHAR(13) +
                                'contract: ' + CONVERT(NVARCHAR(MAX), (SELECT contract FROM INSERTED)) + CHAR(13));

    INSERT INTO TransactionLog (LogMessage) VALUES (@InsertedData);
    PRINT @InsertedData;

    -- Obtener los datos eliminados
    SET @DeletedData = (SELECT 'Datos eliminados en transaction log:' + CHAR(13) +
                               'au_id: ' + CONVERT(NVARCHAR(MAX), (SELECT au_id FROM DELETED)) + CHAR(13) +
                               'au_lname: ' + CONVERT(NVARCHAR(MAX), (SELECT au_lname FROM DELETED)) + CHAR(13) +
                               'au_fname: ' + CONVERT(NVARCHAR(MAX), (SELECT au_fname FROM DELETED)) + CHAR(13) +
                               'address: ' + CONVERT(NVARCHAR(MAX), (SELECT address FROM DELETED)) + CHAR(13) +
                               'city: ' + CONVERT(NVARCHAR(MAX), (SELECT city FROM DELETED)) + CHAR(13) +
                               'state: ' + CONVERT(NVARCHAR(MAX), (SELECT state FROM DELETED)) + CHAR(13) +
                               'zip: ' + CONVERT(NVARCHAR(MAX), (SELECT zip FROM DELETED)) + CHAR(13) +
                               'contract: ' + CONVERT(NVARCHAR(MAX), (SELECT contract FROM DELETED)) + CHAR(13));

    INSERT INTO TransactionLog (LogMessage) VALUES (@DeletedData);
    PRINT @DeletedData;
END;
DROP TRIGGER dbo.tg_ej2;

INSERT INTO dbo.authors2 
SELECT '111-11-1111', 'Lynne', 'Jeff', '415 658-9932',
'Galvez y Ochoa', 'Berkeley', 'CA', '94705', 1;
UPDATE dbo.authors2 
SET au_fname = 'Nicanor' WHERE au_id = '111-11-1111';

SELECT * FROM dbo.TransactionLog;

-- EJERCICIO 3
USE guia2;

CREATE TRIGGER tg_ej3
ON dbo.productos  
AFTER INSERT
AS
BEGIN 
	DECLARE @stock INT;
	SELECT @stock = stock FROM INSERTED;
	IF @stock < 0 BEGIN
		RAISERROR('EL STOCK DEBE SER POSITIVO O CERO',12,1) WITH NOWAIT;
		ROLLBACK TRANSACTION;
	END
END;

INSERT INTO Productos
VALUES (10, 'Producto 10', 200, -6);

-- EJERCICIO 4
USE pubs;

CREATE TRIGGER tg_ej4
ON dbo.titles 
AFTER INSERT
AS
BEGIN
	DECLARE cursor_inserted CURSOR FOR
	SELECT pub_id FROM INSERTED;
	DECLARE @pub_id_aux CHAR(4);
	OPEN cursor_inserted;
	FETCH NEXT FROM cursor_inserted INTO @pub_id_aux;
	WHILE @@FETCH_STATUS = 0 BEGIN
		IF 3000 > (SELECT SUM(t.price*s.qty) FROM dbo.titles t
					INNER JOIN dbo.sales s ON s.title_id = t.title_id
					WHERE t.pub_id = @pub_id_aux) BEGIN 
						RAISERROR('EL PUBLISHER TIENE MUY POCAS VENTAS',12,1) WITH NOWAIT;
						ROLLBACK TRANSACTION;
					END
		FETCH NEXT FROM cursor_inserted INTO @pub_id_aux;
	END;
	CLOSE cursor_inserted;
	DEALLOCATE cursor_inserted;
END;
DROP TRIGGER dbo.tg_ej4;
SELECT * FROM dbo.titles t ;


INSERT INTO titles
SELECT 'PC4546', 'Prueba 1', 'trad_cook', '1389',
14.99, 8000.00, 10, 4095, 'Prueba 2', CURRENT_TIMESTAMP;

SELECT SUM(t.price*s.qty) FROM dbo.titles t
					INNER JOIN dbo.sales s ON s.title_id = t.title_id
					WHERE t.pub_id = '1389';

INSERT INTO titles
SELECT 'PC4647', 'Prueba 3', 'trad_cook', '0736',
14.99, 8000.00, 10, 4095, 'Prueba 2', CURRENT_TIMESTAMP;
SELECT SUM(t.price*s.qty) FROM dbo.titles t
					INNER JOIN dbo.sales s ON s.title_id = t.title_id
					WHERE t.pub_id =  '1389';
