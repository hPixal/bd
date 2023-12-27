COPY actor FROM '/var/lib/postgres/copies/Actor.csv'
WITH (FORMAT csv, DELIMITER E'\t', HEADER true, NULL '');

COPY usuario FROM '/var/lib/postgres/copies/Usuario.csv'
WITH (FORMAT csv, DELIMITER E'\t', HEADER true, NULL '');


COPY PaisProvinciaDepto FROM '/var/lib/postgres/copies/PaisProvinciaDepto.csv'
WITH (FORMAT csv, DELIMITER E'\t', HEADER true, NULL '');


COPY Localidad FROM '/var/lib/postgres/copies/Localidad.csv'
WITH (FORMAT csv, DELIMITER E'\t', HEADER true, NULL '');



