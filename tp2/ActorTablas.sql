
--ejecutar todo esto conectado al esquema actor
----------------- NIVEL I (Creacion) ------------------
create table ocupacion (
	id							int4		not null,
	codigo_ocupacion			int4		not null,
	nombre_ocupacion			varchar(60)	not null,
	nombre_ocupacion_resumido	varchar(20)	not null,
	constraint pk_ocupacion primary key (id),
	constraint ak_ocupacion unique (codigo_ocupacion)
);

create table funcion (
	id							int4		not null,
	codigo_funcion				int2		not null,
	nombre_funcion				varchar(60)	not null,
	nombre_funcion_resumido		varchar(20)	null,
	constraint pk_funcion primary key (id),
	constraint ak_funcion unique (codigo_funcion)
);

create table tipopersonajuridica (
	id										int4		not null,
	codigo_tipo_persona_juridica			int2		not null,
	nombre_tipo_persona_juridica			varchar(60)	not null,
	nombre_tipo_persona_juridica_resumido	varchar(20)	not null,
	constraint pk_tipopersonajuridica primary key (id),
	constraint ak_tipopersonajuridica unique (codigo_tipo_persona_juridica)
);

create table pais (
	id						int4			not null,
	codigo_pais				varchar(3)		not null,
	nombre_pais				varchar(60)		not null,
	nombre_pais_resumido	varchar(20)		not null,
	gentilicio				varchar(255)	not null,
	constraint pk_pais primary key (id),
	constraint ak_pais unique (codigo_pais)
);

----------------- NIVEL I (Poblacion) ------------------

-- Ocupacion

INSERT INTO ocupacion (id, codigo_ocupacion, nombre_ocupacion, nombre_ocupacion_resumido)
VALUES (1, 101, 'Ingeniero de Software', 'Ing. Software');

INSERT INTO ocupacion (id, codigo_ocupacion, nombre_ocupacion, nombre_ocupacion_resumido)
VALUES (2, 201, 'Enfermera', 'Enfermera');

INSERT INTO ocupacion (id, codigo_ocupacion, nombre_ocupacion, nombre_ocupacion_resumido)
VALUES (3, 301, 'Carpintero', 'Carpintero');

INSERT INTO ocupacion (id, codigo_ocupacion, nombre_ocupacion, nombre_ocupacion_resumido)
VALUES (4, 401, 'Diseñador Gráfico', 'Diseñador Gráfico');

-- Funcion

INSERT INTO funcion (id, codigo_funcion, nombre_funcion, nombre_funcion_resumido)
VALUES (1, 101, 'Gerente de Ventas', 'Gerente Ventas');

INSERT INTO funcion (id, codigo_funcion, nombre_funcion, nombre_funcion_resumido)
VALUES (2, 201, 'Programador Junior', 'Prog. Junior');

INSERT INTO funcion (id, codigo_funcion, nombre_funcion, nombre_funcion_resumido)
VALUES (3, 301, 'Técnico de Soporte', 'Téc. Soporte');

INSERT INTO funcion (id, codigo_funcion, nombre_funcion)
VALUES (4, 401, 'Analista de Datos');

-- Tipo persona juridica

INSERT INTO tipopersonajuridica (id, codigo_tipo_persona_juridica, nombre_tipo_persona_juridica, nombre_tipo_persona_juridica_resumido)
VALUES (1, 101, 'Corporación', 'Corp.');

INSERT INTO tipopersonajuridica (id, codigo_tipo_persona_juridica, nombre_tipo_persona_juridica, nombre_tipo_persona_juridica_resumido)
VALUES (2, 201, 'Sociedad de Responsabilidad Limitada', 'S.R.L.');

INSERT INTO tipopersonajuridica (id, codigo_tipo_persona_juridica, nombre_tipo_persona_juridica, nombre_tipo_persona_juridica_resumido)
VALUES (3, 301, 'Asociación sin Fines de Lucro', 'Asoc. sin Lucro');

INSERT INTO tipopersonajuridica (id, codigo_tipo_persona_juridica, nombre_tipo_persona_juridica, nombre_tipo_persona_juridica_resumido)
VALUES (4, 401, 'Sociedad Anónima', 'S.A.');

-- Pais

INSERT INTO pais (id, codigo_pais, nombre_pais, nombre_pais_resumido, gentilicio)
VALUES (1, 'USA', 'Estados Unidos', 'EE. UU.', 'estadounidense');

INSERT INTO pais (id, codigo_pais, nombre_pais, nombre_pais_resumido, gentilicio)
VALUES (2, 'CAN', 'Canadá', 'Canadá', 'canadiense');

INSERT INTO pais (id, codigo_pais, nombre_pais, nombre_pais_resumido, gentilicio)
VALUES (3, 'ARG', 'Argentina', 'Argentina', 'argentino');

INSERT INTO pais (id, codigo_pais, nombre_pais, nombre_pais_resumido, gentilicio)
VALUES (4, 'MEX', 'México', 'México', 'mexicano');

----------------- NIVEL II (Creacion) ----------------

create table provinciaestado (
	id							int4		not null,
	id_pais						int4		not null,
	codigo_provincia			int4		not null,
	nombre_provincia			varchar(60)	not null,
	nombre_provincia_resumido	varchar(60)	not null,
	constraint pk_provinciaestado primary key (id),
	constraint ak_provinciaestado unique (id_pais,codigo_provincia),
	constraint fk_provinciaestado_pais foreign key (id_pais)
		references pais (id)
);

create table actor (
	id					int4			not null,
	codigo_actor		int4			not null,
	cuit_codigo1		int2			null,
	cuit_codigo2		int4			null,
	cuit_codigo3		int2			null,
	id_pais				int4			null,
	email_principal		varchar(255)	null,
	fecha_alta			date			not null,
	fecha_baja			date			null,
	telefono_principal	varchar(255)	null,
	constraint pk_actor primary key (id),
	constraint ak_actor	unique (codigo_actor),
	constraint fk_actor_pais foreign key (id_pais)
		references pais (id)
);

----------------- NIVEL II (Poblacion) ----------------

-- Provinciaestado

INSERT INTO provinciaestado (id, id_pais, codigo_provincia, nombre_provincia, nombre_provincia_resumido)
VALUES (1, 3, 101, 'Buenos Aires', 'Bs. As.');

INSERT INTO provinciaestado (id, id_pais, codigo_provincia, nombre_provincia, nombre_provincia_resumido)
VALUES (2, 3, 202, 'Córdoba', 'Cba.');

INSERT INTO provinciaestado (id, id_pais, codigo_provincia, nombre_provincia, nombre_provincia_resumido)
VALUES (3, 3, 303, 'Santa Fe', 'Sta. Fe.');

INSERT INTO provinciaestado (id, id_pais, codigo_provincia, nombre_provincia, nombre_provincia_resumido)
VALUES (4, 3, 404, 'Mendoza', 'Mza.');


-- Actor

INSERT INTO actor (id, codigo_actor, cuit_codigo1, cuit_codigo2, cuit_codigo3, id_pais, email_principal, fecha_alta, fecha_baja, telefono_principal)
VALUES (1, 101, 20, 123456, 78, 1, 'actor1@example.com', '2023-09-25', NULL, '+1234567890');

INSERT INTO actor (id, codigo_actor, cuit_codigo1, cuit_codigo2, cuit_codigo3, id_pais, email_principal, fecha_alta, fecha_baja, telefono_principal)
VALUES (2, 202, 30, 987654, 45, 1, 'actor2@example.com', '2023-09-26', NULL, '+9876543210');

INSERT INTO actor (id, codigo_actor, cuit_codigo1, cuit_codigo2, cuit_codigo3, id_pais, email_principal, fecha_alta, fecha_baja, telefono_principal)
VALUES (3, 303, 40, 654321, 32, 1, 'actor3@example.com', '2023-09-27', NULL, '+1112233444');

INSERT INTO actor (id, codigo_actor, cuit_codigo1, cuit_codigo2, cuit_codigo3, id_pais, email_principal, fecha_alta, fecha_baja, telefono_principal)
VALUES (4, 404, 50, 789012, 56, 1, 'actor4@example.com', '2023-09-28', NULL, '+5556667777');

------------------ NIVEL III (Creacion) -----------------

create table departamento (
	id								int4		not null,
	id_provincia					int4		not null,
	secuencia						int2		not null,
	codigo_departamento				int2		not null,
	nombre_departamento				varchar(60)	not null,
	nombre_departamento_resumido	varchar(20)	not null,
	constraint pk_departamento primary key (id),
	constraint ak_departamento unique (id_provincia,secuencia),
	constraint fk_departamento_provincia foreign key (id_provincia)
		references provinciaestado (id)
);

create table rol (
	id			int4		not null,
	id_actor	int4		not null,
	tipo_rol	varchar(60)	not null,
	codigo_rol	int4		not null,
	constraint pk_rol primary key (id),
	constraint ak_rol unique (tipo_rol,codigo_rol),
	constraint ak_rol_actor unique (id_actor),
	constraint fk_rol_actor foreign key (id_actor)
		references actor (id),
	constraint chk_tipo_rol check (tipo_rol in ('INSPECTOR_TRANSITO','MEDICO'))
);

create table usuario (
	id				int4			not null,
	codigo_usuario	varchar(60)		not null,
	apellido_nombre	varchar(255)	not null,
	fecha_alta		date			not null,
	id_actor		int4			null,
	hash			varchar(255)	null,
	time_hash		int8			null,
	fecha_baja		date			null,
	constraint pk_usuario primary key (id),
	constraint ak_usuario unique (codigo_usuario),
	constraint ak_usuario_actor unique (id_actor),
	constraint fk_usuario_actor foreign key (id_actor)
		references actor (id)
);

create table organismo (
	id					int4			not null,
	id_actor			int4			not null,
	nombre_organismo	varchar(255)	not null,
	sigla				varchar(60)		null,
	constraint pk_organismo primary key (id),
	constraint ak_organismo unique (id_actor),
	constraint fk_organismo_actor foreign key (id_actor)
		references actor (id)
);

create table personafisica (
	id							int4			not null,
	id_actor					int4			not null,
	documento_identidad_tipo	char			not null,
	documento_identidad_numero	int4			not null,
	apellido					varchar(255)	not null,
	nombre						varchar(255)	not null,
	sexo						char			not null,
	fecha_nacimiento			date			not null,
	id_ocupacion				int4			null,
	movil_principal				varchar(255)	null,
	apellido_materno			varchar(255)	null,
	donante_organos				varchar(255)	null,
	email_personal				varchar(255)	null,
	identidad_genero			varchar(255)	null,
	estado_civil				char			not null,
	constraint pk_personafisica primary key (id),
	constraint ak_personafisica unique (documento_identidad_tipo,documento_identidad_numero),
	constraint ak_personafisica_actor unique (id_actor),
	constraint fk_personafisica_actor foreign key (id_actor)
		references actor (id),
	constraint fk_personafisica_ocupacion foreign key (id_ocupacion)
		references ocupacion (id),
	constraint chk_estado_civil check (estado_civil in ('S','C','E','D','V','N'))
);

create table personajuridica (
	id							int4			not null,
	id_actor					int4			not null,
	id_tipo_persona_juridica	int4			not null,
	nombre_fantasia				varchar(255)	null,
	razon_social				varchar(255)	not null,
	constraint pk_personajuridica primary key (id),
	constraint ak_personajuridica unique (id_actor),
	constraint fk_personajuridica_actor foreign key (id_actor)
		references actor (id),
	constraint fk_personafuridica_tipopersonajuridica foreign key (id_tipo_persona_juridica)
		references tipopersonajuridica (id)
);

------------------ NIVEL III (Poblacion) -----------------

-- Departamento

INSERT INTO departamento (id, id_provincia, secuencia, codigo_departamento, nombre_departamento, nombre_departamento_resumido)
VALUES (1, 1, 1, 101, 'La Plata', 'LP');

INSERT INTO departamento (id, id_provincia, secuencia, codigo_departamento, nombre_departamento, nombre_departamento_resumido)
VALUES (2, 1, 2, 202, 'Avellaneda', 'Avell.');

INSERT INTO departamento (id, id_provincia, secuencia, codigo_departamento, nombre_departamento, nombre_departamento_resumido)
VALUES (3, 1, 3, 303, 'Lomas de Zamora', 'LdZ');

INSERT INTO departamento (id, id_provincia, secuencia, codigo_departamento, nombre_departamento, nombre_departamento_resumido)
VALUES (4, 1, 4, 404, 'Quilmes', 'Qms.');

-- Rol

-- Insertar un rol para el actor con id_actor = 1
INSERT INTO rol (id, id_actor, tipo_rol, codigo_rol)
VALUES (1, 1, 'INSPECTOR_TRANSITO', 101);

-- Insertar un rol para el actor con id_actor = 2
INSERT INTO rol (id, id_actor, tipo_rol, codigo_rol)
VALUES (2, 2, 'MEDICO', 202);

-- Insertar un rol para el actor con id_actor = 3
INSERT INTO rol (id, id_actor, tipo_rol, codigo_rol)
VALUES (3, 3, 'INSPECTOR_TRANSITO', 303);

-- Insertar un rol para el actor con id_actor = 4
INSERT INTO rol (id, id_actor, tipo_rol, codigo_rol)
VALUES (4, 4, 'MEDICO', 404);

-- Usuario

INSERT INTO usuario (id, codigo_usuario, apellido_nombre, fecha_alta, id_actor, hash, time_hash, fecha_baja)
VALUES (1, 'usuario1', 'Apellido1 Nombre1', '2023-09-25', 1, 'hash1', 123456, NULL);

INSERT INTO usuario (id, codigo_usuario, apellido_nombre, fecha_alta, id_actor, hash, time_hash, fecha_baja)
VALUES (2, 'usuario2', 'Apellido2 Nombre2', '2023-09-26', 2, 'hash2', 789012, NULL);

INSERT INTO usuario (id, codigo_usuario, apellido_nombre, fecha_alta, id_actor, hash, time_hash, fecha_baja)
VALUES (3, 'usuario3', 'Apellido3 Nombre3', '2023-09-27', 3, 'hash3', 345678, NULL);

INSERT INTO usuario (id, codigo_usuario, apellido_nombre, fecha_alta, id_actor, hash, time_hash, fecha_baja)
VALUES (4, 'usuario4', 'Apellido4 Nombre4', '2023-09-28', 4, 'hash4', 901234, NULL);

-- Persona Fisica

INSERT INTO personafisica (id, id_actor, documento_identidad_tipo, documento_identidad_numero, apellido, nombre, sexo, fecha_nacimiento, id_ocupacion, movil_principal, apellido_materno, donante_organos, email_personal, identidad_genero, estado_civil)
VALUES (1, 1, 'DNI', 12345678, 'Apellido1', 'Nombre1', 'M', '1990-01-15', 1, '+1234567890', 'Materno1', 'Sí', 'correo1@example.com', 'Masculino', 'S');

INSERT INTO personafisica (id, id_actor, documento_identidad_tipo, documento_identidad_numero, apellido, nombre, sexo, fecha_nacimiento, id_ocupacion, movil_principal, apellido_materno, donante_organos, email_personal, identidad_genero, estado_civil)
VALUES (2, 2, 'DNI', 23456789, 'Apellido2', 'Nombre2', 'F', '1985-03-20', 2, '+9876543210', 'Materno2', 'No', 'correo2@example.com', 'Femenino', 'C');

INSERT INTO personafisica (id, id_actor, documento_identidad_tipo, documento_identidad_numero, apellido, nombre, sexo, fecha_nacimiento, id_ocupacion, movil_principal, apellido_materno, donante_organos, email_personal, identidad_genero, estado_civil)
VALUES (3, 3, 'DNI', 34567890, 'Apellido3', 'Nombre3', 'M', '1988-06-10', 3, '+1112233444', 'Materno3', 'Sí', 'correo3@example.com', 'Masculino', 'E');

INSERT INTO personafisica (id, id_actor, documento_identidad_tipo, documento_identidad_numero, apellido, nombre, sexo, fecha_nacimiento, id_ocupacion, movil_principal, apellido_materno, donante_organos, email_personal, identidad_genero, estado_civil)
VALUES (4, 4, 'DNI', 45678901, 'Apellido4', 'Nombre4', 'F', '1992-09-05', 4, '+5556667777', 'Materno4', 'No', 'correo4@example.com', 'Femenino', 'S');

-- Persona Juridica

INSERT INTO personajuridica (id, id_actor, id_tipo_persona_juridica, nombre_fantasia, razon_social)
VALUES (1, 1, 1, 'Fantasia1', 'Razón Social 1');

INSERT INTO personajuridica (id, id_actor, id_tipo_persona_juridica, nombre_fantasia, razon_social)
VALUES (2, 2, 2, 'Fantasia2', 'Razón Social 2');

INSERT INTO personajuridica (id, id_actor, id_tipo_persona_juridica, nombre_fantasia, razon_social)
VALUES (3, 3, 1, 'Fantasia3', 'Razón Social 3');

INSERT INTO personajuridica (id, id_actor, id_tipo_persona_juridica, nombre_fantasia, razon_social)
VALUES (4, 4, 2, 'Fantasia4', 'Razón Social 4');

------------------ NIVEL IV -----------------

create table integrapersonajuridica (
	id					int4	not null,
	id_persona_juridica	int4	not null,
	secuencia			int2	not null,
	id_persona_fisica	int4	not null,
	id_funcion			int4	not null,
	fecha_alta			date	not null,
	fecha_baja			date	null,
	constraint pk_integrapersonajuridica primary key (id),
	constraint ak_integrapersonajuridica unique (id_persona_juridica,secuencia),
	constraint fk_integrapersonajuridica_personajuridica foreign key (id_persona_juridica)
		references personajuridica (id),
	constraint fk_integrapersonajuridica_personafisica foreign key (id_persona_fisica)
		references personafisica (id),
	constraint fk_integrapersonajuridica_funcion foreign key (id_funcion)
		references funcion (id)
);

create table integraorganismo (
	id					int4	not null,
	id_organismo		int4	not null,
	secuencia			int2	not null,
	id_persona_fisica	int4	not null,
	id_funcion			int4	not null,
	fecha_alta			date	not null,
	fecha_baja			date	null,
	constraint pk_integraorganismo primary key (id),
	constraint ak_integraorganismo unique (id_organismo,secuencia),
	constraint fk_integraorganismo_organismo foreign key (id_organismo)
		references organismo (id),
	constraint fk_integraorganismo_personafisica foreign key (id_persona_fisica)
		references personafisica (id),
	constraint fk_integraorganismo_funcion foreign key (id_funcion)
		references funcion (id)
);

create table localidad (
	id							int4		not null,
	id_departamento				int4		null,
	id_provincia_estado			int4		null,
	codigo_localidad			int4		not null,
	nombre_localidad			varchar(60)	not null,
	nombre_localidad_resumido	varchar(20)	not null,
	codigo_postal				int2		null,
	constraint pk_localidad primary key (id),
	constraint ak_localidad unique (codigo_localidad),
	constraint fk_localidad_departamento foreign key (id_departamento)
		references departamento (id),
	constraint fk_localidad_provinciaestado foreign key (id_provincia_estado)
		references provinciaestado (id)
);

------------------ NIVEL V (Población)  -----------------

-- Integracion Persona Juridica

INSERT INTO integrapersonajuridica (id, id_persona_juridica, secuencia, id_persona_fisica, id_funcion, fecha_alta, fecha_baja)
VALUES (1, 1, 1, 1, 1, '2023-09-25', NULL);

INSERT INTO integrapersonajuridica (id, id_persona_juridica, secuencia, id_persona_fisica, id_funcion, fecha_alta, fecha_baja)
VALUES (2, 2, 2, 2, 2, '2023-09-26', NULL);

INSERT INTO integrapersonajuridica (id, id_persona_juridica, secuencia, id_persona_fisica, id_funcion, fecha_alta, fecha_baja)
VALUES (3, 3, 3, 3, 3, '2023-09-27', NULL);

INSERT INTO integrapersonajuridica (id, id_persona_juridica, secuencia, id_persona_fisica, id_funcion, fecha_alta, fecha_baja)
VALUES (4, 4, 4, 4, 4, '2023-09-28', NULL);

-- Integra organismo

INSERT INTO integraorganismo (id, id_organismo, secuencia, id_persona_fisica, id_funcion, fecha_alta, fecha_baja)
VALUES (1, 1, 1, 1, 1, '2023-09-25', NULL);

INSERT INTO integraorganismo (id, id_organismo, secuencia, id_persona_fisica, id_funcion, fecha_alta, fecha_baja)
VALUES (2, 2, 2, 2, 2, '2023-09-26', NULL);

INSERT INTO integraorganismo (id, id_organismo, secuencia, id_persona_fisica, id_funcion, fecha_alta, fecha_baja)
VALUES (3, 3, 3, 3, 3, '2023-09-27', NULL);

INSERT INTO integraorganismo (id, id_organismo, secuencia, id_persona_fisica, id_funcion, fecha_alta, fecha_baja)
VALUES (4, 4, 4, 4, 4, '2023-09-28', NULL);

-- Localidad

INSERT INTO localidad (id, id_departamento, id_provincia_estado, codigo_localidad, nombre_localidad, nombre_localidad_resumido, codigo_postal)
VALUES (1, 1, 1, 101, 'Localidad1', 'Loc1', 1001);

INSERT INTO localidad (id, id_departamento, id_provincia_estado, codigo_localidad, nombre_localidad, nombre_localidad_resumido, codigo_postal)
VALUES (2, 2, 2, 202, 'Localidad2', 'Loc2', 2002);

INSERT INTO localidad (id, id_departamento, id_provincia_estado, codigo_localidad, nombre_localidad, nombre_localidad_resumido, codigo_postal)
VALUES (3, 3, 3, 303, 'Localidad3', 'Loc3', 3003);

INSERT INTO localidad (id, id_departamento, id_provincia_estado, codigo_localidad, nombre_localidad, nombre_localidad_resumido, codigo_postal)
VALUES (4, 4, 4, 404, 'Localidad4', 'Loc4', 4004);


------------------- NIVEL V ------------------

create table direccionactor (
	id				int4			not null,
	id_actor		int4			not null,
	secuencia		int2			not null,
	id_localidad	int4			null,
	domicilio		varchar(255)	null,
	calle			varchar(255)	null,
	departamento	varchar(255)	null,
	numero_portal	int4			null,
	piso			varchar(255)	null,
	edificio		varchar(255)	null,
	manzana			varchar(255)	null,
	monoblock		varchar(255)	null,
	torre			varchar(255)	null,
	vivienda		varchar(255)	null,
	tipo_domicilio	varchar(20)		null,
	constraint pk_direccionactor primary key (id),
	constraint ak_direccionactor unique (id_actor,secuencia),
	constraint fk_direccionactor_actor foreign key (id_actor)
		references actor (id),
	constraint fk_direccionactor_localidad foreign key (id_localidad)
		references localidad (id),
	constraint chk_tipo_domicilio check (tipo_domicilio in ('SUCURSAL','LABORAL','CASA_CENTRAL','FISCAL','OTRO','PARTICULAR'))
);

------------------- NIVEL V (Poblacion) ------------------

-- Insertar una dirección para el actor con ID 1
INSERT INTO direccionactor (id, id_actor, secuencia, id_localidad, domicilio, calle, departamento, numero_portal, piso, edificio, manzana, monoblock, torre, vivienda, tipo_domicilio)
VALUES (1, 1, 1, 1, 'Domicilio1', 'Calle1', 'Dept1', 123, 'Piso1', 'Edificio1', 'Manzana1', 'Monoblock1', 'Torre1', 'Vivienda1', 'SUCURSAL');

-- Insertar una dirección para el actor con ID 2
INSERT INTO direccionactor (id, id_actor, secuencia, id_localidad, domicilio, calle, departamento, numero_portal, piso, edificio, manzana, monoblock, torre, vivienda, tipo_domicilio)
VALUES (2, 2, 2, 2, 'Domicilio2', 'Calle2', 'Dept2', 456, 'Piso2', 'Edificio2', 'Manzana2', 'Monoblock2', 'Torre2', 'Vivienda2', 'LABORAL');

-- Insertar una dirección para el actor con ID 3
INSERT INTO direccionactor (id, id_actor, secuencia, id_localidad, domicilio, calle, departamento, numero_portal, piso, edificio, manzana, monoblock, torre, vivienda, tipo_domicilio)
VALUES (3, 3, 3, 3, 'Domicilio3', 'Calle3', 'Dept3', 789, 'Piso3', 'Edificio3', 'Manzana3', 'Monoblock3', 'Torre3', 'Vivienda3', 'CASA_CENTRAL');

-- Insertar una dirección para el actor con ID 4
INSERT INTO direccionactor (id, id_actor, secuencia, id_localidad, domicilio, calle, departamento, numero_portal, piso, edificio, manzana, monoblock, torre, vivienda, tipo_domicilio)
VALUES (4, 4, 4, 4, 'Domicilio4', 'Calle4', 'Dept4', 101, 'Piso4', 'Edificio4', 'Manzana4', 'Monoblock4', 'Torre4', 'Vivienda4', 'FISCAL');


