create table partida (
	dpto varchar(2) not null, 
	partida varchar(6) not null, 
	domiciilio varchar(100) null,
	constraint patida_pk primary key (dpto,partida)
);

create table persona(
	idPersona int primary key,
	tipodoc int null,
	nrodoc varchar(8),
	apellido varchar(100),
	nombres varchar(100)
);

create table mejora (
	idMejora int primary key,
	dpto varchar(2) not null,
	partida varchar(6) not null,
	categ smallint not null,
	sup float null,
	anio varchar(4),
	constraint mejora_fk foreign key (dpto,partida) references partida(dpto,partida)
);

drop  table mejora;

create table partidaPersona(
	dpto varchar(2) not null,
	partida varchar(6) not null,
	idPersona int not null,
	porcentaje int null,
	constraint patidapersona_pk primary key (dpto,partida,idPersona),
	constraint partidapersona_fk foreign key (dpto,partida) references partida(dpto,partida),
	constraint partidopersona_fk2 foreign key (idPersona) references persona(idPersona)
);

-- Entries for the 'partida' table
INSERT INTO partida (dpto, partida, domiciilio) VALUES
('01', '000001', '123 Main St'),
('02', '000002', '456 Elm St'),
('03', '000003', '789 Oak St');

-- Entries for the 'persona' table
INSERT INTO persona (idPersona, tipodoc, nrodoc, apellido, nombres) VALUES
(1, 1, '12345678', 'Smith', 'John'),
(2, 2, '87654321', 'Garcia', 'Maria'),
(3, 1, '98765432', 'Johnson', 'David');

-- Entries for the 'mejora' table
INSERT INTO mejora (idMejora, dpto, partida,categ, sup, anio) VALUES
(101, '01', '000001',1, 150.5, '2023'),
(102, '02', '000002',2, 200.2, '2022'),
(103, '03', '000003',3, 300.8, '2023'),
(101, '01', '000001',1, 150.5, '2023');

-- Entries for the 'partidaPersona' table
INSERT INTO partidaPersona (dpto, partida, idPersona, porcentaje) VALUES
('01', '000001', 1, 50),
('02', '000002', 2, 30),
('03', '000003', 3, 40);


(select count(m.categ) from mejora m
	inner join partidapersona ps on ps.dpto = m.dpto and ps.partida = m.partida
	inner join persona p on p.idpersona = ps.idpersona
	where m.categ = 1 and p.idpersona = 1);

select p.nombres, p.apellido , (select count(m.categ) from mejora m
	inner join partidapersona ps on ps.dpto = m.dpto and ps.partida = m.partida
	inner join persona p2 on p2.idpersona = ps.idpersona
	where m.categ = 1 and p2.idpersona = p.idpersona) as "CATEGORIA 1", 
	(select count(m.categ) from mejora m
	inner join partidapersona ps on ps.dpto = m.dpto and ps.partida = m.partida
	inner join persona p2 on p2.idpersona = ps.idpersona
	where m.categ = 2 and p2.idpersona = p.idpersona) as "CATEGORIA 2",
	(select count(m.categ) from mejora m
	inner join partidapersona ps on ps.dpto = m.dpto and ps.partida = m.partida
	inner join persona p2 on p2.idpersona = ps.idpersona
	where m.categ = 3 and p2.idpersona = p.idpersona) as "CATEGORIA 3" from persona p;
