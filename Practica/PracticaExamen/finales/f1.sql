CREATE DATABASE f2021;
USE f2021;

CREATE TABLE categoria(
	IDCateg INT NOT NULL,
	descrip VARCHAR(100) NOT NULL,
	IDCategPadre INT NULL,
	CONSTRAINT pk_categoria PRIMARY KEY (IDCateg),
	CONSTRAINT fk_categoria FOREIGN KEY (IDCategPadre) REFERENCES dbo.categoria(IDCateg)
);
DROP TABLE dbo.categoria;

CREATE TABLE pregunta(
	IDPregunta INT NOT NULL,
	Pregunta VARCHAR(1000) NOT NULL,
	Respuesta VARCHAR(1000) NOT NULL,
	CONSTRAINT pk_pregunta PRIMARY KEY(IDPregunta)
);
DROP TABLE dbo.pregunta;

CREATE TABLE categoriapregunta(
	ID INT IDENTITY(1,1),
	IDCateg INT NOT NULL,
	IDPregunta INT NOT NULL,
	orden SMALLINT NOT NULL,
	CONSTRAINT pk_categoriapregunta PRIMARY KEY(ID),
	CONSTRAINT fk1_categoriapregunta FOREIGN KEY (IDCateg) REFERENCES dbo.categoria(IDCateg),
	CONSTRAINT fk2_categoriapregunta FOREIGN KEY (IDPregunta) REFERENCES dbo.pregunta(IDPregunta),
	CONSTRAINT uq_categoriapregunta UNIQUE (IDCateg, IDPregunta)
);
DROP TABLE dbo.categoriapregunta;

-- Inserts generados por IA, no tienen ningun sentido, es solo para tener datos con los que trabajar.

-- Nivel 0: Categorías principales
INSERT INTO categoria(IDCateg, descrip, IDCategPadre) VALUES (1, 'Electrónica', NULL);
INSERT INTO categoria(IDCateg, descrip, IDCategPadre) VALUES (2, 'Ropa', NULL);

-- Nivel 1: Subcategorías de Electrónica
INSERT INTO categoria(IDCateg, descrip, IDCategPadre) VALUES (3, 'Computadoras', 1);
INSERT INTO categoria(IDCateg, descrip, IDCategPadre) VALUES (4, 'Accesorios', 1);
INSERT INTO categoria(IDCateg, descrip, IDCategPadre) VALUES (5, 'Teléfonos', 1);

-- Nivel 1: Subcategorías de Ropa
INSERT INTO categoria(IDCateg, descrip, IDCategPadre) VALUES (6, 'Camisetas', 2);
INSERT INTO categoria(IDCateg, descrip, IDCategPadre) VALUES (7, 'Pantalones', 2);
INSERT INTO categoria(IDCateg, descrip, IDCategPadre) VALUES (8, 'Chaquetas', 2);

-- Nivel 2: Subcategorías de Computadoras
INSERT INTO categoria(IDCateg, descrip, IDCategPadre) VALUES (9, 'Laptops', 3);
INSERT INTO categoria(IDCateg, descrip, IDCategPadre) VALUES (10, 'Escritorios', 3);

-- Nivel 2: Subcategorías de Teléfonos
INSERT INTO categoria(IDCateg, descrip, IDCategPadre) VALUES (11, 'Smartphones', 5);
INSERT INTO categoria(IDCateg, descrip, IDCategPadre) VALUES (12, 'Accesorios', 5);

-- Nivel 2: Subcategorías de Camisetas
INSERT INTO categoria(IDCateg, descrip, IDCategPadre) VALUES (13, 'Mangas cortas', 6);
INSERT INTO categoria(IDCateg, descrip, IDCategPadre) VALUES (14, 'Mangas largas', 6);

-- Nivel 2: Subcategorías de Pantalones
INSERT INTO categoria(IDCateg, descrip, IDCategPadre) VALUES (15, 'Jeans', 7);
INSERT INTO categoria(IDCateg, descrip, IDCategPadre) VALUES (16, 'Chinos', 7);

-- Nivel 2: Subcategorías de Chaquetas
INSERT INTO categoria(IDCateg, descrip, IDCategPadre) VALUES (17, 'Abrigos', 8);
INSERT INTO categoria(IDCateg, descrip, IDCategPadre) VALUES (18, 'Chalecos', 8);

-- Nivel 3: Subcategorías de Smartphones
INSERT INTO categoria(IDCateg, descrip, IDCategPadre) VALUES (19, 'Libres', 11);
INSERT INTO categoria(IDCateg, descrip, IDCategPadre) VALUES (20, 'Propietarios', 11);

INSERT INTO pregunta(IDPregunta, Pregunta, Respuesta) VALUES (1, '¿Cuál es la capital de Francia?', 'París');
INSERT INTO pregunta(IDPregunta, Pregunta, Respuesta) VALUES (2, '¿En qué año comenzó la Segunda Guerra Mundial?', '1939');
INSERT INTO pregunta(IDPregunta, Pregunta, Respuesta) VALUES (3, '¿Cuál es la fórmula química del agua?', 'H2O');
INSERT INTO pregunta(IDPregunta, Pregunta, Respuesta) VALUES (4, '¿Quién pintó la Mona Lisa?', 'Leonardo da Vinci');
INSERT INTO pregunta(IDPregunta, Pregunta, Respuesta) VALUES (5, '¿Cuál es el resultado de 2+2?', '4');

INSERT INTO categoriapregunta(IDCateg, IDPregunta, orden) VALUES ( 1, 1, 1);
INSERT INTO categoriapregunta(IDCateg, IDPregunta, orden) VALUES ( 2, 2, 2);
INSERT INTO categoriapregunta(IDCateg, IDPregunta, orden) VALUES ( 3, 3, 3);
INSERT INTO categoriapregunta(IDCateg, IDPregunta, orden) VALUES ( 4, 4, 4);
INSERT INTO categoriapregunta(IDCateg, IDPregunta, orden) VALUES ( 5, 5, 5);

-- EJERCICIO 1: SE SOLICITA LISTAR LAS CATEGORIAS DE NIVEL 2, INDICANDO SI TIENEN O NO UN HIJO EN SQL PURO.

------------------------------- RESOLUCION -------------------------------
SELECT c.IDCateg,c.descrip, CASE 
			WHEN EXISTS 
				(SELECT * FROM dbo.categoria cs 
					WHERE cs.IDCategPadre = c.IDCateg) 
			THEN 'Tiene hijos' 
			ELSE 'No tiene hijos' 
		END AS 'Tiene hijos?' 
		FROM dbo.categoria c
		WHERE EXISTS (SELECT * FROM dbo.categoria c2 
						WHERE c2.IDCateg = c.IDCategPadre AND 
							EXISTS (SELECT * FROM dbo.categoria c3 
									WHERE c3.IDCateg = c2.IDCategPadre  AND C3.IDCategPadre IS NULL)); 
------------------------------- AUXILIARES -------------------------------
SELECT c.IDCateg,c.descrip, CASE 
			WHEN EXISTS 
				(SELECT * FROM dbo.categoria cs 
					WHERE cs.IDCategPadre = c.IDCateg) 
			THEN 'Tiene hijos' 
			ELSE 'No tiene hijos' 
		END AS 'Tiene hijos?' 
		FROM dbo.categoria c;
	
SELECT * FROM dbo.categoria c WHERE c.IDCategPadre IS  NULL;

SELECT * FROM dbo.categoria c2 
	WHERE EXISTS (SELECT * FROM dbo.categoria c3 
			WHERE c3.IDCateg = c2.IDCategPadre AND c3.IDCategPadre IS NULL);
--------------------------------------------------------------------------
		
-- EJERCICIO 2: ESCRIBA UN TRIGGER QUE IMPIDA QUE UNA PREGUNTA SEA ASOCIADA A DOS CATEGORIAS QUE ESTEN EN EL MISMO NIVEL EN EL ARBOL
		
------------------------------- RESOLUCION -------------------------------
CREATE FUNCTION count_levels_above(@id INT)
RETURNS INT AS
BEGIN
	DECLARE @Result INT;
	IF 
		EXISTS (SELECT * FROM dbo.categoria ca WHERE ca.IDCateg = @id AND ca.IDCategPadre IS NULL) BEGIN
		 	SET @Result = 0;
		END
		ELSE BEGIN
			DECLARE @father INT;
			SET @father = (SELECT ca.IDCategPadre FROM dbo.categoria ca WHERE ca.IDCateg = @id)
			SET @Result = (SELECT dbo.count_levels_above(@father)+1);
		END
		RETURN @Result;
END;
DROP FUNCTION  count_levels_above;


		
CREATE TRIGGER tr_pregunta ON dbo.categoriapregunta
AFTER INSERT AS
BEGIN
    DECLARE @l1 INT;
    DECLARE @l2 INT;
    DECLARE @aux_categ INT;
    DECLARE cursor_categ CURSOR FOR
        SELECT c.IDCateg
        FROM dbo.categoriapregunta c
        WHERE c.IDPregunta IN (SELECT IDPregunta FROM INSERTED);

    SET @l1 = (SELECT dbo.count_levels_above((SELECT IDCateg FROM INSERTED)));
    OPEN cursor_categ;
    FETCH NEXT FROM cursor_categ INTO @aux_categ;

    WHILE @@FETCH_STATUS = 0 BEGIN
        SET @l2 = (SELECT dbo.count_levels_above(@aux_categ));

        IF @l1 = @l2 BEGIN
            RAISERROR('LA PREGUNTA NO PUEDE SER INSERTADA EN EL MISMO NIVEL', 12, 1) WITH NOWAIT;
            ROLLBACK TRANSACTION;
            RETURN; -- Exiting trigger after rollback
        END

        FETCH NEXT FROM cursor_categ INTO @aux_categ; -- Move to the next record
    END;

    CLOSE cursor_categ;
    DEALLOCATE cursor_categ;
END;

-- Test
INSERT INTO categoriapregunta(IDCateg, IDPregunta, orden) VALUES ( 4, 3, 3);
SELECT dbo.count_levels_above(19);

------------------------------- RESOLUCION -------------------------------

-- A. Falso
-- B. Verdadero

-- Justificación:

-- En la Sesión 1, se establece el nivel de aislamiento READ UNCOMMITTED, lo que permite a la transacción ver filas que están siendo modificadas por otras transacciones, incluso si estas no han sido confirmadas (COMMIT). Luego se borran filas de la tabla titles donde type = 'business', seguido por un retraso de 30 segundos (WAITFOR DELAY '00:00:30.000';). Finalmente, se hace un ROLLBACK TRANSACTION, lo que revertirá todos los cambios realizados dentro de esa transacción.

-- Mientras tanto, en la Sesión 2, se ejecuta una consulta para seleccionar filas de la tabla titles donde title_id = 'BU7832'. Debido al nivel de aislamiento READ UNCOMMITTED en la Sesión 1, esta transacción puede leer filas que están siendo modificadas o eliminadas por otras transacciones, incluso si estas transacciones aún no han confirmado sus cambios. Por lo tanto, la sentencia de la Sesión 2 no espera a que la transacción de la Sesión 1 confirme o revierta los cambios. La fila con title_id = 'BU7832' podría haber sido eliminada por la transacción en la Sesión 1, lo que hace que la consulta en la Sesión 2 no devuelva filas o devuelva un conjunto de resultados vacío.
