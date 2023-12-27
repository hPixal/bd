-- Ejercicio 1

create table triangulo (
	idTriangulo integer not null,
	descripcion varchar(60) null,
	constraint triangulo_pk primary key (idTriangulo)
 );
 
create table lado (
	idLado integer not null,
	idTriangulo integer not null,
	longitud integer,
	constraint lado_pk primary key(idLado),
	constraint lado_fk foreign key(idTriangulo) references triangulo (idTriangulo)
);

INSERT INTO triangulo (idTriangulo, descripcion) VALUES
(1, 'Triángulo que cumple la propiedad de Pitágoras'),
(2, 'Triángulo que cumple la propiedad de Pitágoras'),
(3, 'Triángulo que no cumple la propiedad de Pitágoras');

INSERT INTO lado (idLado, idTriangulo, longitud) VALUES
(1, 1, 3),
(2, 1, 4),
(3, 1, 5);

INSERT INTO lado (idLado, idTriangulo, longitud) VALUES
(4, 2, 3),
(5, 2, 4),
(6, 2, 5);

INSERT INTO lado (idLado, idTriangulo, longitud) VALUES
(7, 3, 2),
(8, 3, 3),
(9, 3, 6);

delete from triangulo;
delete from lado;

-- Resolver solamente usando sql

select  T.descripcion from triangulo T where exists 
	( select l.idtriangulo from lado l where l.longitud*l.longitud = (select sum( l2.longitud*l2.longitud) from lado l2 where l2.idlado != l.idlado and l2.idTriangulo = t.idTriangulo));


