-- Crear la tabla R1
CREATE TABLE R1
(
    A Integer,
    B Integer
);

-- Crear la tabla S1
CREATE TABLE S1
(
    B Integer,
    C Integer,
    D Integer
);

-- Insertar datos en la tabla R1
INSERT INTO R1 (A, B) VALUES (1, 2);
INSERT INTO R1 (A, B) VALUES (3, 4);

-- Insertar datos en la tabla S1
INSERT INTO S1 (B, C, D) VALUES (2, 5, 6);
INSERT INTO S1 (B, C, D) VALUES (4, 7, 8);
INSERT INTO S1 (B, C, D) VALUES (9, 10, 11);

-- Realizar la consulta para combinar R1 y S1 mediante un CROSS JOIN
SELECT R1.A, R1.B AS "R1.B", S1.B AS "S1.B", S1.C, S1.D
FROM R1
CROSS JOIN S1;

