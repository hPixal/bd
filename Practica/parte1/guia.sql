-- DECLARACION DE TABLAS

CREATE TABLE persona (
	tipodoc CHARACTER(3) not null,
	nrodoc INTEGER not null,
	sexo BOOLEAN not null,
	apenom CHARACTER(40) not null,
	domicilio CHARACTER(50) not null,
	fechanaci DATE not null,
	CONSTRAINT tipodoc_pk PRIMARY KEY(tipodoc,nrodoc,sexo)
);

CREATE TABLE localidad (
	id_localidad INTEGER(2) not null,
	nom_localidad CHARACTER(40) not null,
	CONSTRAINT localidad_pk PRIMARY KEY(id_localidad)
);

CREATE TABLE provincia (
	id_provincia INTEGER(2) not null,
	nom_provincia CHARACTER(40) not null,
	CONSTRAINT id_provincia PRIMARY KEY(id_provincia)
);

CREATE TABLE empleado (
	id_empleado INTEGER(4) not null,
	fecha_ingreso DATE not null,
	CONSTRAINT id_empleado_pk PRIMARY KEY(id_empleado)
);

CREATE TABLE medico (
	matricula INTEGER(2) not null,
	CONSTRAINT matricula_pk PRIMARY KEY(matricula)
);

CREATE TABLE asignacion (
	id_asignacion INTEGER(4) not null,
	fecha_asignacion DATE not null,
	fecha_salida DATE not null,
	CONSTRAINT id_asignacion_pk PRIMARY KEY(id_asignacion)
);

CREATE TABLE sala (
	nro_sala INTEGER(2) not null,
	nom_sala CHARACTER(40) not null,
	capacidad INTEGER(2) not null,
	CONSTRAINT nro_sala_pk PRIMARY KEY(nor_sala)
	
);

CREATE TABLE historial (
	fecha_incio DATE not null,
	fecha_fin DATE null,
	CONSTRAINT fecha_inicio_pk PRIMARY KEY(fecha_inicio)
);

CREATE TABLE cargo (
	id_cargo INTEGER(2) not null,
	nom_carco CHARACTER(32) not null,
	CONSTRAINT id_cargo_pk PRIMARY KEY(id_cargo)
);

CREATE TABLE especialidad (
	id_especialidad INTEGER(2) not null,
	nom_especialidad CHARACTER(32) not null,
	CONSTRAINT id_especialidad_pk PRIMARY KEY(id_especialidad)
);

CREATE TABLE sector (
	id_sector INTEGER not null,
	nom_sector CHARACTER(32) not null,
	CONSTRAINT id_sector_pk PRIMARY KEY(id_sector)
);

CREATE TABLE seccion (
	id_seccion INTEGER(2) not null,
	nom_seccion CHARACTER(32) not null,
	CONSTRAINT id_seccion_pk PRIMARY KEY(id_seccion)
);

--- SECCION FOERIGN KEYS, IDENTIFIERS

--- Provincia

--- FK = NULL

--- Seccion 

--- FK = NULL

--- Localidad

ALTER TABLE localidad
	ADD CONSTRAINT provincia_localidad_fk
	FOREIGN KEY(id_provincia_fk) REFERENCES provincia(id_provincia);

--- Persona

ALTER TABLE persona 
	ADD CONSTRAINT persona_localidad_fk1
	FOREIGN KEY(id_provincia_fk1,id_localidad_fk1) REFERENCES localidad(id_provincia,id_localidad);

ALTER TABLE persona 
	ADD CONSTRAINT persona_localidad_fk2
	FOREIGN KEY(id_provincia_fk2,id_localidad_fk2) REFERENCES localidad(id_provincia,id_localidad);

ALTER TABLE persona 
	ADD CONSTRAINT persona_persona_fk3
	FOREIGN KEY(nrodoc_fk3,sexo_fk3,tipodoc_fk3) REFERENCES persona(nrodoc,sexo,tipodoc);

ALTER TABLE persona 
	ADD CONSTRAINT persona_persona_fk4
	FOREIGN KEY(nrodoc_fk4,sexo_fk4,tipodoc_fk4) REFERENCES persona(nrodoc,sexo,tipodoc);

--- Empleado

ALTER TABLE empleado 
	ADD CONSTRAINT persona_empleado_fk
	FOREIGN KEY(nrodoc_fk,sexo_fk,tipodoc_fk) REFERENCES persona(nrodoc,sexo,tipodoc);

--- Sector

ALTER TABLE sector 
	ADD CONSTRAINT seccion_sector_fk
	FOREIGN KEY(id_seccion_fk) REFERENCES seccion(id_seccion);

--- Sala

ALTER TABLE sala 
	ADD CONSTRAINT sala_sector_fk
	FOREIGN KEY(id_sector_fk,id_seccion_fk) REFERENCES sector(id_sector,id_seccion_fk);

--- Asignacion 

ALTER TABLE asignacion 
	ADD CONSTRAINT asignacion_persona_fk1
	FOREIGN KEY(nrodoc_fk,sexo_fk,tipodoc_fk) REFERENCES persona(nrodoc,sexo,tipodoc);

ALTER TABLE asignacion 
	ADD CONSTRAINT asignacion_sala_fk
	FOREIGN KEY(id_seccion_fk,id_sector_fk,nro_sala_fk) REFERENCES sala(id_seccion_fk,id_sector_fk,nro_sala);


