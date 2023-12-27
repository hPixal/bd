-- Nivel de creacion 1

CREATE TABLE provincia (
	idprovi INTEGER not null,
	nomprovi CHARACTER(32) not null,
	CONSTRAINT provincia_pk PRIMARY KEY(idprovi)
);

CREATE TABLE actuacion (
	nroactua INTEGER not null,
	anioactua INTEGER not null,
	nroactua_fk INTEGER null,
	anioactua_fk INTEGER null,
	CONSTRAINT actuacion_pk PRIMARY KEY(nroactua,anioactua),
	CONSTRAINT actuacion_glose_fk FOREIGN KEY (nroactua_fk,anioactua_fk)
		REFERENCES actuacion(nroactua,anioactua)
);

CREATE INDEX actuacion_idx ON actuacion(nroactua_fk,anioactua_fk); 

CREATE TABLE tematica (
	idTema INTEGER not null,
	nomtema CHARACTER(32) not null,
	CONSTRAINT tematica_pk PRIMARY KEY(idTema)
);

CREATE TABLE nivel (
	idNivel INTEGER not null,
	nomnivel CHARACTER(32) not null,
	CONSTRAINT nivel_pk PRIMARY KEY(idNivel)
);

-- Nivel de creacion 2

CREATE TABLE localidad (
	idLoca INTEGER not null,
	nomLoca CHARACTER(32) not null,
	idProvi INTEGER not null,
	CONSTRAINT localidad_pk PRIMARY KEY(idLoca,idProvi),
	CONSTRAINT localidad_provincia_fk FOREIGN KEY(idProvi) REFERENCES provincia(idProvi)
);

-- Nivel de creacion 3

CREATE TABLE persona (
	tipodocu CHARACTER(3) not null,
	nrodocu INTEGER not null,
	idProvi INTEGER not null,
	idLoca INTEGER not null,
	apenom CHARACTER(32) not null,
	domiper CHARACTER(32) not null,
	CONSTRAINT persona_pk PRIMARY KEY(tipodocu,nrodocu),
	CONSTRAINT persona_localidad_fk FOREIGN KEY(idLoca,idProvi) REFERENCES localidad(idLoca,idProvi),
	CONSTRAINT persona_chk CHECK (tipodocu IN('DNI','LE','LC','PAS','OTR'))
);

CREATE TABLE entidad (
	identidad INTEGER not null,
	idLoca INTEGER not null,
	idProvi INTEGER not null,
	nomenti CHARACTER(32) not null,
	domienti CHARACTER(32) not null,
	CONSTRAINT entidad_pk PRIMARY KEY(identidad),
	CONSTRAINT entidad_localidad_fk FOREIGN KEY(idLoca,idProvi) REFERENCES localidad(idLoca,idProvi)
);

-- Nivel de creacion 4

CREATE TABLE empleado (
	idemple INTEGER not null,
	tipodocu CHARACTER(3) not null,
	nrodocu INTEGER not null,
	feingre DATE not null,
	CONSTRAINT empleado_pk PRIMARY KEY(idemple),
	CONSTRAINT emplado_pesona_fk FOREIGN KEY(tipodocu,nrodocu) REFERENCES persona(tipodocu,nrodocu)
);

-- Nivel de creacion 5

CREATE TABLE tiene (
	nroactua INTEGER not null,
	anioactua INTEGER not null,
	idtema INTEGER not null,
	observaciones CHARACTER(255) not null,
	CONSTRAINT tiene_pk PRIMARY KEY(nroactua,anioactua),
	CONSTRAINT tiene_actuacion_fk FOREIGN KEY(anioactua,nroactua) REFERENCES actuacion(anioactua,nroactua),
	CONSTRAINT tiene_tematica FOREIGN KEY(idTema) REFERENCES tematica(idTema)
);

CREATE TABLE oficina (
	idOfi INTEGER not null,
	idNivel INTEGER not null,
	nomofi CHARACTER(32) not null,
	idemple INTEGER not null,
	idOfi_fk INTEGER null,
	idNivel_fk INTEGER null,
	CONSTRAINT oficina_pk PRIMARY KEY(idOfi,idNivel),
	CONSTRAINT oficina_fk FOREIGN KEY (idNivel)
		REFERENCES nivel(idNivel),
	CONSTRAINT oficina_fk2 FOREIGN KEY (idOfi_fk,idNivel_fk)
		REFERENCES oficina(idOfi,idNivel)
	);

CREATE INDEX idx_oficina_empleado ON oficina(idemple);
CREATE INDEX idx_oficina_depende ON oficina(idNivel_fk,idOfi_fk);

CREATE TABLE presenta_persona (
	tipodocu CHARACTER(3) not null,
	nrodocu INTEGER not null,
	nroactua INTEGER not null,
	anioactua INTEGER not null,
	CONSTRAINT presenta_persona_pk PRIMARY KEY(tipodocu,nrodocu,nroactua,anioactua),
	CONSTRAINT persona_fk FOREIGN KEY (tipodocu,nrodocu)
		REFERENCES persona(tipodocu,nrodocu),
	CONSTRAINT actuacion_fk FOREIGN KEY (nroactua,anioactua)
		REFERENCES actuacion(nroactua,anioactua)
);

CREATE TABLE presenta_entidad (
	identidad INTEGER not null,
	nroactua INTEGER not null,
	anioactua INTEGER not null,
	CONSTRAINT presenta_entidad_pk PRIMARY KEY(identidad,nroactua,anioactua),
	CONSTRAINT actuacion_fk FOREIGN KEY (nroactua,anioactua)
		REFERENCES actuacion(nroactua,anioactua),
	CONSTRAINT entidad_fk FOREIGN KEY (identidad)
		REFERENCES entidad(identidad)
);


--Nivel de creacion 6

CREATE TABLE movimiento (
	nromov INTEGER not null,
	nroactua INTEGER not null,
	anioactua INTEGER not null,
	feingreso DATE not null,
	prioridad CHARACTER(2) not null,
	observ CHARACTER(255) not null,
	idOfi INTEGER not null,
	idNivel INTEGER not null,
	fesalida DATE null,
	CONSTRAINT movimiento_pk PRIMARY KEY(nromov,nroactua,anioactua),
	CONSTRAINT actuacion_fk FOREIGN KEY (nroactua,anioactua)
		REFERENCES actuacion(nroactua,anioactua),
	CONSTRAINT oficina_fk FOREIGN KEY (idOfi,idNivel)
		REFERENCES oficina(idOfi,idNivel),
	CONSTRAINT movimiento_chk CHECK ( prioridad IN('AL','ME','BA') )
);

CREATE TABLE trabaja (
	idemple INTEGER not null,
	feinitra DATE not null,
	idOfi INTEGER not null,
	idNivel INTEGER not null,
	fefintra DATE null,
	obstra  CHARACTER(255) null,
	CONSTRAINT trabajo_pk PRIMARY KEY(idemple,feinitra),
	CONSTRAINT trabaja_fk FOREIGN KEY (idemple)
		REFERENCES empleado(idemple),
	CONSTRAINT oficina_fk FOREIGN KEY (idOfi,idNivel)
		REFERENCES oficina(idOfi,idNivel)
);

--Nivel de creacion 7

CREATE TABLE atiende (
	idemple INTEGER not null,
	nromov INTEGER not null,
	nroactua INTEGER not null,
	anioactua INTEGER not null,
	CONSTRAINT atiende_pk PRIMARY KEY(idemple,nromov,nroactua,anioactua),
	CONSTRAINT empleado_fk FOREIGN KEY (idemple)
		REFERENCES empleado(idemple),
	CONSTRAINT empleado_fk2 FOREIGN KEY (nromov,nroactua,anioactua)
		REFERENCES movimiento(nromov,nroactua,anioactua)
);
