CREATE TABLE pais (
	codigo_pais INTEGER not null,
	nombre_pais CHARACTER(32) not null,
	CONSTRAINT codigo_pais PRIMARY KEY(codigo_pais);
);


CREATE TABLE provincia (
	codigo_pais CHARACTER(3) not null,
	codigo_provincia INTEGER not null,
	nombre_provincia CHARACTER(30) not null,
	CONSTRAINT provincia_pk PRIMARY KEY(codigo_pais,codigo_provincia,nombre_provincia),
	CONSTRAINT provincia_fk FOREIGN KEY (codigo_pais)
		REFERENCES pais(codigo_pais)
);

CREATE TABLE localidad (
	codigo_pais CHARACTER(3) not null,
	codigo_provincia INTEGER not null,
	codigo_localidad INTEGER not null,
	nombre_localidad CHARACTER(120) null,
	codigo_postal INTEGER null
	CONSTRAINT localidad_pk PRIMARY KEY(codigo_pais,codigo_provincia,codigo_localidad),
	CONSTRAINT localidad_fk FOREIGN KEY (codigo_pais,codigo_provincia)
		REFERENCES provincia(codigo_pais,codigo_provincia),
	CONSTRAINT localidad_uq UNIQUE(codigo_postal)
);

CREATE TABLE persona (
	tipo CHARACTER(1) not null,
	numero INTEGER not null,
	apellido CHARACTER(150) null,
	nombres CHARACTER(150) null,
	domicilio CHARACTER(300) null,
	codigo_postal INTEGER null,
	CONSTRAINT persona_pk PRIMARY KEY(tipo,numero),
	CONSTRAINT persona_uq UNIQUE (codigo_postal)
);

-- Primero que hay que hacer es añadir las nuevas entradas a persona que van a contener la foreign key

ALTER TABLE persona [
	ADD COLUMN codigo_localidad INTEGER,
	ADD COLUMN codigo_pais CHARACTER(3),
	ADD COLUMN codigo_provincia INTEGER
];

-- Segundo crear la constraint

ALTER TABLE persona
	ADD CONSTRAINT persona_fk FOREIGN KEY (codigo_pais,codigo_provincia,codigo_localidad)
		REFERENCES localidad(codigo_pais,codigo_provincia,codigo_localidad);

-- Tercero eliminar la constraint unique de persona

ALTER TABLE persona
	DROP CONSTRAINT persona_uq;

-- Cuarto eliminar la columna de codigo postal

ALTER TABLE persona
	DROP TABLE codigo_postal;
