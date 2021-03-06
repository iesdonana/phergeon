------------------------------
-- Archivo de base de datos --
------------------------------
DROP TABLE IF EXISTS session CASCADE;

CREATE TABLE session
(
    id CHAR(40) NOT NULL PRIMARY KEY,
    expire INTEGER,
    data BYTEA,
    user_id BIGINT
);


DROP TABLE IF EXISTS roles CASCADE;

CREATE TABLE roles
(
    id bigserial PRIMARY KEY
   ,denominacion varchar(255) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS usuarios CASCADE;

CREATE TABLE usuarios
(

    id bigserial PRIMARY KEY
   ,nombre_usuario varchar(255) NOT NULL UNIQUE
   ,nombre_real varchar(255) NOT NULL
   ,email varchar(255) NOT NULL
   ,password varchar(255) NOT NULL
   ,created_at timestamp(0)
   ,posx double precision
   ,posy double precision
   ,foto varchar(255)
   ,token_val varchar(255) UNIQUE
   ,rol bigint NOT NULL REFERENCES roles (id) on delete cascade ON UPDATE CASCADE DEFAULT 1

);

CREATE INDEX idx_usuarios_email ON usuarios (email);
CREATE INDEX idx_usuarios_nombre_real ON usuarios (nombre_real);

DROP TABLE IF EXISTS tipos CASCADE;

CREATE TABLE tipos
(
    id bigserial PRIMARY KEY
   ,denominacion_tipo varchar(255) NOT NULL UNIQUE

);

DROP TABLE IF EXISTS razas CASCADE;

CREATE TABLE razas
(
    id bigserial PRIMARY KEY
   ,tipo_animal bigint NOT NULL REFERENCES tipos (id) on delete cascade ON UPDATE CASCADE
   ,denominacion_raza varchar(255) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS animales CASCADE;

CREATE TABLE animales
(
    id bigserial PRIMARY KEY
   ,id_usuario bigint NOT NULL REFERENCES usuarios (id) on delete cascade ON UPDATE CASCADE
   ,nombre varchar(255) NOT NULL
   ,tipo_animal bigint NOT NULL REFERENCES tipos (id) on delete cascade ON UPDATE CASCADE
   ,raza bigint NOT NULL REFERENCES razas (id) on delete cascade ON UPDATE CASCADE DEFAULT 1
   ,descripcion varchar(255) NOT NULL
   ,edad varchar(255) NOT NULL
   ,sexo varchar(255) NOT NULL
);

DROP TABLE IF EXISTS fotosAnimal CASCADE;

CREATE TABLE fotosAnimal
(
    id bigserial PRIMARY KEY
   ,id_animal bigint NOT NULL REFERENCES animales (id) on delete cascade on update CASCADE
   ,link varchar(255)
);

CREATE INDEX idx_animales_sexo ON animales (sexo);
CREATE INDEX idx_animales_sexo ON animales (edad);

DROP TABLE IF EXISTS facturas CASCADE;

CREATE TABLE facturas
(
    id bigserial PRIMARY KEY
   ,id_animal bigint NOT NULL REFERENCES animales (id) on delete cascade ON UPDATE CASCADE
   ,fecha_emision timestamp(0) NOT NULL DEFAULT localtimestamp
   ,centro_veterinario varchar(255) NOT NULL
   ,descripcion varchar(255) NOT NULL
   ,importe numeric(5,2) NOT NULL
);

DROP TABLE IF EXISTS historiales CASCADE;

CREATE TABLE historiales
(
    id bigserial PRIMARY KEY
   ,id_animal bigint NOT NULL REFERENCES animales (id) on delete cascade ON UPDATE CASCADE
   ,descripcion varchar(255) NOT NULL
);

DROP TABLE IF EXISTS adopciones CASCADE;

CREATE TABLE adopciones
(
    id bigserial PRIMARY KEY
   ,id_usuario_donante bigint NOT NULL REFERENCES usuarios (id) on delete cascade ON UPDATE CASCADE
   ,id_usuario_adoptante bigint NOT NULL REFERENCES usuarios (id) on delete cascade ON UPDATE CASCADE
   ,id_animal bigint NOT NULL REFERENCES animales (id) on delete cascade ON UPDATE CASCADE
   ,aprobado bool NOT NULL DEFAULT FALSE
   ,fecha_adopcion timestamp(0) NOT NULL DEFAULT localtimestamp
   ,unique (id_usuario_donante, id_usuario_adoptante, id_animal)
);

DROP TABLE IF EXISTS mensajes CASCADE;

CREATE TABLE mensajes
(
    id bigserial PRIMARY KEY
   ,id_receptor bigint NOT NULL REFERENCES usuarios (id) ON DELETE CASCADE ON UPDATE CASCADE
   ,id_emisor bigint NOT NULL REFERENCES usuarios (id) ON DELETE CASCADE ON UPDATE CASCADE
   ,asunto varchar(100)
   ,mensaje varchar(2000)
   ,created_at timestamp(0)
   ,visto bool DEFAULT false

);

INSERT INTO roles (denominacion)
    VALUES ('usuario')
         , ('asociacion');

INSERT INTO usuarios (nombre_usuario, nombre_real, email, posx, posy,  password, created_at, rol, foto)
    VALUES ('danigove', 'Daniel Gómez Vela', 'dani5002@hotmail.com',-6.383452 , 36.753477 , crypt('danigove', gen_salt('bf', 13)), current_timestamp(0),1, 'https://www.dropbox.com/s/47flnyzf928oa32/tragabuche.jpg?dl=1')
    ,('briganimalista', 'Brigada Animalista Sanlúcar', 'brigada@gmail.com',  -6.439270 , 36.729657, crypt('brigada', gen_salt('bf', 13)), current_timestamp(0),2, 'https://www.dropbox.com/s/nhs96ybwnby5gkg/brigada.jpg?dl=1');


INSERT INTO tipos (denominacion_tipo)
    VALUES ('Perro'),
           ('Gato'),
           ('Exótico');

INSERT INTO razas (tipo_animal, denominacion_raza)
    VALUES  ('1', 'Mestizo'),
            ('1', 'Labrador'),
            ('1', 'Mastín'),
            ('1', 'Samoyedo'),
            ('1', 'Bodeguero'),
            ('1', 'York Terrier'),
            ('1', 'Schnauzer'),
            ('1', 'Yorksire'),
            ('1', 'Pit Bull'),
            ('1', 'Pastor Alemán'),
            ('1', 'Pastor Australiano'),
            ('1', 'Pastor Belga'),
            ('1', 'Galgo'),
            ('1', 'Beagle'),
            ('1', 'Chihuahua'),
            ('1', 'Pug'),
            ('1', 'Otros Perros'),
            ('1', 'Husky'),
            ('2', 'Mainecoon'),
            ('2', 'Persa'),
            ('2', 'Ruso azul'),
            ('2', 'Bengala'),
            ('2', 'Fold escocés'),
            ('2', 'Manx'),
            ('2', 'Siamés'),
            ('2', 'Otros Gatos'),
            ('3', 'Reptiles'),
            ('3', 'Búho'),
            ('3', 'Erizo'),
            ('3', 'Roedores'),
            ('3', 'Pájaros'),
            ('3', 'Hurón'),
            ('3', 'Otros');

INSERT INTO animales (id_usuario, nombre, tipo_animal, raza, descripcion, edad, sexo)
    VALUES (1, 'Toby', '1', '2', 'Por favor necesito a alguien para este animalito pobre que me encontre en la carretera', 2, 'Macho'),
           (2, 'Batman', '2', '21', 'Por favor necesito a alguien para este animalito pobre que me encontre en la carretera', 1, 'Macho'),
           (2, 'Trinity', '3', '30', 'Por favor necesito a alguien para este animalito pobre que me encontre en la carretera', 2, 'Hembra');
