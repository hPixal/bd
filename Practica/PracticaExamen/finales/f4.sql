-- Ejercicio 1
use pubs;

SELECT DISTINCT 
	s.stor_id, s.ord_num,
	(SELECT aux.tid FROM 
		(SELECT TOP 1 s3.title_id as 'tid', t.price*s3.qty as 'amount' 
		FROM dbo.sales s3
		INNER JOIN dbo.titles t ON t.title_id = s3.title_id 
		WHERE s3.stor_id = s.stor_id  AND s3.ord_num =  s.ord_num ORDER BY 2 DESC ) 
	AS aux) AS 'PUBLICACION 1',
 	CASE WHEN 
	(SELECT COUNT(s2.title_id) FROM dbo.sales s2 WHERE s2.stor_id = s.stor_id  AND s2.ord_num = s.ord_num) > 1
	THEN 	'Hay mas de uno'
	ELSE 	'Solo hay uno'
	END AS 'OBSERVACIONES'
FROM dbo.sales s ;

-- Ejercicio 2
SELECT DISTINCT 
	s.stor_id, s.ord_num,
	(SELECT aux.tid FROM 
		(SELECT TOP 1 s3.title_id as 'tid', t.price*s3.qty as 'amount' 
		FROM dbo.sales s3
		INNER JOIN dbo.titles t ON t.title_id = s3.title_id 
		WHERE s3.stor_id = s.stor_id  AND s3.ord_num =  s.ord_num ORDER BY 2 DESC ) 
	AS aux) AS 'PUBLICACION_1',
 	CASE WHEN 
	(SELECT COUNT(s2.title_id) FROM dbo.sales s2 WHERE s2.stor_id = s.stor_id  AND s2.ord_num = s.ord_num) > 1
	THEN 	'Hay mas de uno'
	ELSE 	'Solo hay uno'
	END AS 'OBSERVACIONES' INTO #reporteVentas
FROM dbo.sales s ;

SELECT * FROM dbo.#reporteventas;
DROP TABLE dbo.#reporteVentas ;

-- Ejercicio 3
CREATE TRIGGER tr_sales 
ON dbo.sales
AFTER INSERT 
AS 
BEGIN
	DECLARE @ord_num VARCHAR(20);
	DECLARE @stor_id CHAR(4);

	SELECT @ord_num = ord_num, @stor_id = stor_id FROM INSERTED;

	IF EXISTS (SELECT * FROM #reporteVentas rp WHERE ord_num = @ord_num AND stor_id = @stor_id) 
	BEGIN
		--- ALREADY EXISTS
		UPDATE #reporteVentas 
		SET 
		#reporteVentas.OBSERVACIONES = 
		CASE 
			WHEN (SELECT COUNT(s2.title_id) FROM dbo.sales s2 WHERE s2.stor_id = @stor_id  AND s2.ord_num = @ord_num) > 1
			THEN 	'Hay mas de uno'
			ELSE 	'Solo hay uno'
		END,
		#reporteVentas.PUBLICACION_1 =
		(SELECT aux.tid FROM 
			(SELECT TOP 1 s3.title_id as 'tid', t.price*s3.qty as 'amount' 
			FROM dbo.sales s3
			INNER JOIN dbo.titles t ON t.title_id = s3.title_id 
			WHERE s3.stor_id = @stor_id  AND s3.ord_num =  @ord_num ORDER BY 2 DESC ) 
		AS aux) WHERE #reporteVentas.ord_num = @ord_num AND #reporteVentas.stor_id = @stor_id;
		PRINT 'VALUE ALREADY EXISTED';
		---
	END
	ELSE IF NOT( EXISTS (SELECT * FROM #reporteVentas rp WHERE ord_num = @ord_num AND stor_id = @stor_id) )
	BEGIN
		--- DOES NOT EXIST
		INSERT INTO #reporteVentas(stor_id,ord_num,PUBLICACION_1,OBSERVACIONES) VALUES(
		@stor_id, @ord_num,
		(SELECT aux.tid FROM 
			(SELECT TOP 1 s3.title_id as 'tid', t.price*s3.qty as 'amount' 
			FROM dbo.sales s3
			INNER JOIN dbo.titles t ON t.title_id = s3.title_id 
			WHERE s3.stor_id = @stor_id  AND s3.ord_num =  @ord_num ORDER BY 2 DESC ) 
		AS aux),
 		CASE WHEN 
		(SELECT COUNT(s2.title_id) FROM dbo.sales s2 WHERE s2.stor_id = @stor_id AND s2.ord_num = @ord_num) > 1
		THEN 	'Hay mas de uno'
		ELSE 	'Solo hay uno'
		END);
		PRINT 'VALUE DID NOT EXIST';
		---
	END
	ELSE
	BEGIN
		RAISERROR('SOMETHING HAPPEND IN THE SALES TRIGGER',12,1) WITH NOWAIT;
		ROLLBACK TRANSACTION;
	END
END

DROP TRIGGER dbo.tr_sales;

-- TEST VALUE 1
INSERT INTO sales (stor_id, ord_num, ord_date, qty, payterms, title_id)
VALUES ('7067', 'ORD001', '2023-12-17', 5, 'Net30', 'PS3333');

-- TEST VALUE 2
INSERT INTO sales (stor_id, ord_num, ord_date, qty, payterms, title_id)
VALUES ('6380', '6871', '2023-12-17', 80, 'Net30', 'PS3333');

-- MISC AND CHECK IF WORK
DELETE FROM sales WHERE stor_id = '7067' AND ord_num = 'ORD001' AND title_id = 'PS3333';
SELECT * FROM #reporteventas;
SELECT * FROM dbo.sales s ;
DROP TABLE #reporteventas;

SELECT DISTINCT 
		s.stor_id, s.ord_num,
		(SELECT aux.tid FROM 
			(SELECT TOP 1 s3.title_id as 'tid', t.price*s3.qty as 'amount' 
			FROM dbo.sales s3
			INNER JOIN dbo.titles t ON t.title_id = s3.title_id 
			WHERE s3.stor_id = s.stor_id  AND s3.ord_num =  s.ord_num ORDER BY 2 DESC ) 
		AS aux) AS 'PUBLICACION 1',
 		CASE WHEN 
		(SELECT COUNT(s2.title_id) FROM dbo.sales s2 WHERE s2.stor_id = s.stor_id  AND s2.ord_num = s.ord_num) > 1
		THEN 	'Hay mas de uno'
		ELSE 	'Solo hay uno'
		END AS 'OBSERVACIONES'
		FROM dbo.sales s WHERE s.stor_id = '7067' and s.ord_num = 'ORD001';


INSERT INTO sales (stor_id, ord_num, ord_date, qty, payterms, title_id)
VALUES ('7067', 'ORD001', '2023-12-17', 5, 'Net30', 'PS3333'),
       ('0877', 'ORD002', '2023-12-18', 10, 'Cash', 'TC4203'),
       ('0877', 'ORD003', '2023-12-19', 8, 'Credit', 'MC2222'),
       ('1389', 'ORD004', '2023-12-20', 15, 'Net60', 'BU1032'),
       ('1389', 'ORD005', '2023-12-21', 12, 'Net45', 'PC1035'),
       ('0736', 'ORD006', '2023-12-22', 7, 'Cash', 'PS7777'),
       ('0877', 'ORD007', '2023-12-23', 9, 'Credit', 'TC7777'),
       ('1389', 'ORD008', '2023-12-24', 6, 'Net30', 'BU1111'),
       ('1389', 'ORD009', '2023-12-25', 3, 'Cash', 'PC8888');
