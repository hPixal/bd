-- Tablas originales
CREATE TABLE persona (
	tipo CHARACTER(1) not null,
	numero INTEGER not null,
	CONSTRAINT persona_pk PRIMARY KEY(tipo,numero),
	CONSTRAINT persona_chk CHECK ( tipo IN ('1','2','3') )
);

CREATE TABLE profesor (
	nro_legajo INTEGER not null,
	tipo CHARACTER(1) not null,
	numero INTEGER not null,
	CONSTRAINT profesor_pk PRIMARY KEY(nro_legajo),
	CONSTRAINT profesor_fk FOREIGN KEY (tipo,numero)
		REFERENCES persona(tipo,numero)
);

-- Inserts de persona
INSERT INTO persona (tipo, numero)
VALUES ('1', 1001);

INSERT INTO persona (tipo, numero)
VALUES ('2', 2002);

INSERT INTO persona (tipo, numero)
VALUES ('3', 3003);

-- Inserts de profesor
INSERT INTO profesor (nro_legajo, tipo, numero)
VALUES (101, '1', 1001);

INSERT INTO profesor (nro_legajo, tipo, numero)
VALUES (202, '2', 2002);

-- Alterar la tabla

alter table persona 
	drop constraint persona_chk;

alter table profesor 
	drop constraint profesor_fk;

UPDATE persona
	SET tipo = CASE
	WHEN tipo = '1' THEN 'A'
        WHEN tipo = '2' THEN 'B'
	WHEN tipo = '3' THEN 'C'
	ELSE 'X'
END;

UPDATE profesor 
	SET tipo = CASE
	WHEN tipo = '1' THEN 'A'
	WHEN tipo = '2' THEN 'B'
	WHEN tipo = '3' THEN 'C'
	ELSE 'X'
END;

alter table profesor 
	add constraint profesor_fk foreign key (tipo,numero) 
			references persona(tipo,numero);

alter table persona 
	add constraint persona_chk check ( tipo in ('A', 'B','C'));

