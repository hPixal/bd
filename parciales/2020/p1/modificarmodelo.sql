-- 1 Para empezar a pasar el modelo voy a crear todas las columnas
-- de IDs que pasaran a ser la nueva PK 

ALTER TABLE provincia
	 ADD COLUMN id_provincia INTEGER;

ALTER TABLE departamento
	 ADD COLUMN id_departamento INTEGER;

ALTER TABLE localidad
	 ADD COLUMN id_localidad INTEGER;

ALTER TABLE persona
	 ADD COLUMN id_persona INTEGER;

ALTER TABLE empleado
	 ADD COLUMN id_empleado INTEGER;

ALTER TABLE oficina
	 ADD COLUMN id_oficina INTEGER;

ALTER TABLE oficina_depente
	 ADD COLUMN id_oficina_depende INTEGER;

ALTER TABLE historial
	 ADD COLUMN id_historial;

-- 2 Despues de creadas todas las IDs dropeo todas las constraints tipo
-- foreign key y los indices 
DROP INDEX IF EXISTS idx_departamento_provincia;

ALTER TABLE departamento
	 DROP CONSTRAINT fk_departamento_provincia;

DROP INDEX IF EXISTS idx_localidad_departamento;

ALTER TABLE localidad
	 DROP CONSTRAINT fk_localidad_deparmanto;

DROP INDEX IF EXISTS idx_persona_localidad;

DROP INDEX IF EXISTS idx_persona_padre;

DROP INDEX IF EXISTS idx_persona_madre;

ALTER TABLE persona
	 DROP CONSTRAINT fk_persona_padre;

ALTER TABLE persona
	 DROP CONSTRAINT fk_persona_madre;

ALTER TABLE empleado
	 DROP CONSTRAINT fk_emplado_persona;

DROP INDEX IF EXISTS idx_depende_oficina;

DROP INDEX IF EXISTS idx_depedende_oficina_padre

ALTER TABLE oficina_depende
	 DROP CONSTRAINT fk_oficina_depende_oficina;

ALTER TABLE oficina_depende
	 DROP CONSTRAINT fk_oficina_depende_oficina_padre;

DROP INDEX IF EXISTS idx_historial_oficina;

ALTER TABLE historial
	 DROP CONSTRAINT fk_hitorial_oficina;

ALTER TABLE historial
	 DROP CONSTRAINT fk_historial_empleado;

-- 3 Reemplazo las constraint de primary key por uniques

ALTER TABLE provincia
	 DROP CONSTRAINT pk_provincia;
ALTER TABLE provicina
	 ADD CONSTRAINT uq_provincia UNIQUE(codigo_provincia);

ALTER TABLE departamento
	 DROP CONSTRAINT pk_departamento;
ALTER TABLE departamento
	 ADD CONSTRAINT uq_departamento UNIQUE(item);

ALTER TABLE localidad
	 DROP CONSTRAINT pk_localidad;
ALTER TABLE localidad
	 ADD CONSTRAINT uq_localidad UNIQUE(codigo_localidad);

ALTER TABLE persona
	 DROP CONSTRAINT pk_persona;
ALTER TABLE persona
	 ADD CONSTRAINT uq_persana UNIQUE(tipo_documento,numero_documento);

ALTER TABLE empleado
	 DROP CONSTRAINT pk_empleado;
ALTER TABLE emplado
	 ADD CONSTRAINT uq_empleado UNIQUE(numero_legajo);

ALTER TABLE oficina
	DROP CONSTRAINT pk_oficina;
ALTER TABLE oficina
	ADD CONSTRAINT uq_oficina UNIQUE(codiog_oficina);

ALTER TABLE oficina_depende
	 DROP CONSTRAINT pk_oficina_depende;

ALTER TABLE historial
	 DROP CONSTRAINT pk_historial;

-- 4 Borro todas las columnas que referian a las foreign key y meto en
-- su lugar los ID's de las tablas referenciadas

ALTER TABLE departamento
	DROP COLUMN codigo_provincia;

ALTER TABLE departamento
	ADD COLUMN id_provincia;

ALTER TABLE localidad
	DROP COLUMN codigo_provincia;

ALTER TABLE localidad
	DROP COLUMN item;

ALTER TABLE localidad
	 ADD COLUMN id_provincia;

ALTER TABLE persona [
	DROP COLUMN codigo_provincia,
  	DROP COLUMN codigo_localidad,
	DROP COLUMN item
];

ALTER TABLE persona[
	DROP COLUMN tipo_documento_padre,
	DROP COLUMN numero_documento_padre
];

ALTER TABLE persona[
	DROP COLUMN tipo_documento_madre,
	DROP COLUMN numero_documento_madre
];

ALTER TABLE persona
	ADD COLUMN id_persona;

ALTER TABLE persona
	ADD COLUMN id_persona_madre;

ALTER TABLE persona
	ADD COLUMN id_persona_padre;

ALTER TABLE empleado[
	DROP COLUMN tipo_documento,
	DROP COLUMN numero_documento
];

ALTER TABLE empleado
	ADD COLUMN  id_persona;

ALTER TABLE oficina_depende[
	DROP COLUMN codigo_oficina,
	DROP COLUMN codigo_oficina_padre
];

ALTER TABLE oficina_depende[
	ADD COLUMN id_oficina,
	ADD COLUMN id_oficina_padre
];

ALTER TABLE historial
	DROP COLUMN numero_legajo;

ALTER TABLE historial
	 DROP COLUMN codigo_oficina;

ALTER TABLE historial
	 ADD COLUMN emplado_id;

ALTER TABLE historial
	 ADD COLUMN oficina_id;

-- 5 Declaro que las ID's son las nuevas primary keys

ALTER TABLE provincia
	 ADD CONSTRAINT pk_provincia PRIMARY KEY(id_provincia);

ALTER TABLE departamento
	 ADD CONSTRAINT pk_departamento PRIMARY KEY(id_departamento);

ALTER TABLE localidad
	 ADD CONSTRAINT pk_localidad PRIMARY KEY(id_localidad);

ALTER TABLE persona
	 ADD CONSTRAINT pk_persona PRIMARY KEY(id_persona);

ALTER TABLE empleado
	 ADD CONSTRAINT pk_empleado PRIMARY KEY(id_empleado);

ALTER TABLE oficina
	 ADD CONSTRAINT pk_oficina PRIMARY KEY(id_oficina);

ALTER TABLE oficina_depende
	 ADD CONSTRAINT pk_oficina_depende PRIMARY KEY(id_oficina_depende);

ALTER TABLE historial
	 ADD CONSTRAINT pk_historial PRIMARY KEY(id_historial);

