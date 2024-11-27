-- Crear schema
CREATE SCHEMA IF NOT EXISTS sah;

-- Corrección de ENUM y creación de tipos
CREATE TYPE sah.estado_usuario_alimento_enum AS ENUM ('PREPARACION', 'ENTREGADO');
CREATE TYPE sah.estado_usuario_servicio_enum AS ENUM ('PENDIENTE', 'REALIZADO', 'CANCELADO');
CREATE TYPE sah.estado_cuarto_enum AS ENUM ('OCUPADO', 'LIBRE', 'MANTENIMIENTO');
CREATE TYPE sah.estado_cuarto_servicio_enum AS ENUM ('ACTIVO', 'INACTIVO');
CREATE TYPE sah.estado_reserva_enum AS ENUM ('COMPLETADO', 'CANCELADO', 'PENDIENTE');
CREATE TYPE sah.estado_facturacion_enum AS ENUM ('PAGADO', 'PENDIENTE', 'CANCELADO');

-- Tabla de estado_usuario_alimento
CREATE TABLE sah.estado_usuario_alimento (
                                             id_estado_usuario_alimento SERIAL PRIMARY KEY,
                                             nombre_estado_usuario_alimento estado_usuario_alimento_enum NOT null default 'PREPARACION'
);

-- Tabla de tipo_alimento con restricción única
CREATE TABLE sah.tipo_alimento (
                                   id_tipo_alimento SERIAL PRIMARY KEY,
                                   nombre_tipo_alimento VARCHAR(30) NOT NULL UNIQUE
);

-- Tabla de alimento
CREATE TABLE sah.alimento (
                              codigo_alimento CHAR(7) PRIMARY KEY,
                              tiempo_preparacion_alimento TIME NOT NULL,
                              nombre_alimento VARCHAR(30) NOT NULL,
                              detalle_alimento TEXT NULL,
                              tipo_alimento_fk INT NOT NULL,
                              FOREIGN KEY (tipo_alimento_fk) REFERENCES sah.tipo_alimento(id_tipo_alimento)
);

-- Tabla de tipo_usuario con restricción única
CREATE TABLE sah.tipo_usuario (
                                  id_tipo_usuario SERIAL PRIMARY KEY,
                                  nombre_tipo_usuario VARCHAR(30) NOT NULL UNIQUE
);

-- Tabla de usuario
CREATE TABLE sah.usuario (
                             codigo_usuario CHAR(7) PRIMARY KEY,
                             nombres_usuario VARCHAR(80) NOT NULL,
                             apellidos_usuario VARCHAR(80) NOT NULL,
                             correo_usuario VARCHAR(50) NOT NULL UNIQUE,
                             codigo_imagen_usuario TEXT NULL,
                             contrasena VARCHAR(30) NOT null CHECK (char_length(contrasena) >= 8),
                             tipo_usuario_fk INT NOT NULL,
                             FOREIGN KEY (tipo_usuario_fk) REFERENCES sah.tipo_usuario(id_tipo_usuario)
);

-- Tabla de usuario_alimento con clave primaria compuesta
CREATE TABLE sah.usuario_alimento (
                                      codigo_usuario_fk VARCHAR(7) NOT NULL,
                                      codigo_alimento_fk VARCHAR(7) NOT NULL,
                                      estado_usuario_alimento_fk INT NOT NULL,
                                      PRIMARY KEY (codigo_usuario_fk, codigo_alimento_fk),
                                      FOREIGN KEY (codigo_usuario_fk) REFERENCES sah.usuario(codigo_usuario) ON DELETE CASCADE,
                                      FOREIGN KEY (codigo_alimento_fk) REFERENCES sah.alimento(codigo_alimento),
                                      FOREIGN KEY (estado_usuario_alimento_fk) REFERENCES sah.estado_usuario_alimento(id_estado_usuario_alimento)
);

-- Tabla de tipo_servicio con restricción única
CREATE TABLE sah.tipo_servicio (
                                   id_tipo_servicio SERIAL PRIMARY KEY,
                                   nombre_tipo_servicio VARCHAR(30) NOT NULL UNIQUE
);

-- Tabla de servicio
CREATE TABLE sah.servicio (
                              codigo_servicio CHAR(7) PRIMARY KEY,
                              nombre_servicio VARCHAR(50) NOT NULL,
                              valor_servicio NUMERIC(10,2) NOT null check(valor_servicio > 0),
                              codigo_imagen_servicio TEXT NOT NULL,
                              detalle_servicio TEXT NULL,
                              tipo_servicio_fk INT NOT NULL,
                              FOREIGN KEY (tipo_servicio_fk) REFERENCES sah.tipo_servicio(id_tipo_servicio)
);

-- Tabla de estado_usuario_servicio
CREATE TABLE sah.estado_usuario_servicio (
                                             id_estado_usuario_servicio SERIAL PRIMARY KEY,
                                             nombre_estado_servicio estado_usuario_servicio_enum NOT null default 'PENDIENTE'
);

-- Tabla de usuario_servicio con clave primaria compuesta
CREATE TABLE sah.usuario_servicio (
                                      codigo_servicio_fk VARCHAR(7) NOT NULL,
                                      codigo_usuario_fk VARCHAR(7) NOT NULL,
                                      estado_usuario_servicio_fk INT NOT NULL,
                                      PRIMARY KEY (codigo_servicio_fk, codigo_usuario_fk),
                                      FOREIGN KEY (codigo_servicio_fk) REFERENCES sah.servicio(codigo_servicio),
                                      FOREIGN KEY (codigo_usuario_fk) REFERENCES sah.usuario(codigo_usuario) ON DELETE CASCADE,
                                      FOREIGN KEY (estado_usuario_servicio_fk) REFERENCES sah.estado_usuario_servicio(id_estado_usuario_servicio)
);

-- Tabla de estado_cuarto
CREATE TABLE sah.estado_cuarto (
                                   id_estado_cuarto SERIAL PRIMARY KEY,
                                   nombre_estado_cuarto estado_cuarto_enum NOT null default 'LIBRE'
);

-- Tabla de tipo_cuarto con restricción única
CREATE TABLE sah.tipo_cuarto (
                                 id_tipo_cuarto SERIAL PRIMARY KEY,
                                 nombre_tipo_cuarto VARCHAR(30) NOT NULL UNIQUE
);

-- Tabla de cuarto
CREATE TABLE sah.cuarto (
                            codigo_cuarto VARCHAR(7) PRIMARY KEY,
                            numero_cuarto VARCHAR(7) NOT NULL,
                            codigo_imagen_cuarto TEXT NOT NULL,
                            valor_noche_cuarto NUMERIC(10,2) NOT null check(valor_noche_cuarto > 0),
                            detalle_cuarto TEXT NULL,
                            tipo_cuarto_fk INT NOT NULL,
                            estado_cuarto_fk INT NOT NULL,
                            FOREIGN KEY (tipo_cuarto_fk) REFERENCES sah.tipo_cuarto(id_tipo_cuarto),
                            FOREIGN KEY (estado_cuarto_fk) REFERENCES sah.estado_cuarto(id_estado_cuarto)
);

-- Tabla de estado_cuarto_servicio
CREATE TABLE sah.estado_cuarto_servicio (
                                            id_estado_cuarto_servicio SERIAL PRIMARY KEY,
                                            nombre_estado_servicio estado_cuarto_servicio_enum NOT null default 'ACTIVO'
);

-- Tabla de cuarto_servicio con clave primaria compuesta
CREATE TABLE sah.cuarto_servicio (
                                     codigo_cuarto_fk VARCHAR(7) NOT NULL,
                                     codigo_servicio_fk VARCHAR(7) NOT NULL,
                                     estado_cuarto_servicio_fk INT NOT NULL,
                                     PRIMARY KEY (codigo_cuarto_fk, codigo_servicio_fk),
                                     FOREIGN KEY (codigo_cuarto_fk) REFERENCES sah.cuarto(codigo_cuarto),
                                     FOREIGN KEY (codigo_servicio_fk) REFERENCES sah.servicio(codigo_servicio),
                                     FOREIGN KEY (estado_cuarto_servicio_fk) REFERENCES sah.estado_cuarto_servicio(id_estado_cuarto_servicio)
);

-- Tabla de estado_reserva
CREATE TABLE sah.estado_reserva (
                                    id_estado_reserva SERIAL PRIMARY KEY,
                                    nombre_estado_reserva estado_reserva_enum NOT null default 'PENDIENTE'
);

-- Tabla de reserva con restricción CHECK y corrección de clave foránea
CREATE TABLE sah.reserva (
                             codigo_reserva VARCHAR(7) PRIMARY KEY,
                             fecha_inicio_reserva DATE NOT NULL CHECK (fecha_inicio_reserva < fecha_fin_reserva),
                             fecha_fin_reserva DATE NOT null check(fecha_fin_reserva > fecha_inicio_reserva),
                             fecha_creacion_reserva TIMESTAMPTZ NOT NULL,
                             fecha_actualizacion_reserva TIMESTAMPTZ NOT NULL,
                             valor_total_reserva NUMERIC(10, 2) NOT null check(valor_total_reserva > 0),
                             codigo_usuario_fk VARCHAR(7) NOT NULL,
                             estado_reserva_fk INT NOT NULL,
                             FOREIGN KEY (codigo_usuario_fk) REFERENCES sah.usuario(codigo_usuario),
                             FOREIGN KEY (estado_reserva_fk) REFERENCES sah.estado_reserva(id_estado_reserva)
);


-- Tabla de facturacion
CREATE TABLE sah.facturacion (
                                 codigo_facturacion VARCHAR(10) PRIMARY KEY,
                                 fecha_creacion_facturacion TIMESTAMPTZ NOT NULL,
                                 codigo_reserva_fk VARCHAR(7) NOT NULL,
                                 codigo_usuario_fk VARCHAR(7) NOT NULL,
                                 estado_facturacion estado_facturacion_enum NOT NULL DEFAULT 'PENDIENTE',
                                 FOREIGN KEY (codigo_reserva_fk) REFERENCES sah.reserva(codigo_reserva),
                                 FOREIGN KEY (codigo_usuario_fk) REFERENCES sah.usuario(codigo_usuario)
);

-- Tabla de reserva_cuarto con clave primaria compuesta
CREATE TABLE sah.reserva_cuarto (
                                    codigo_reserva_fk VARCHAR(7) NOT NULL,
                                    codigo_cuarto_fk VARCHAR(7) NOT NULL,
                                    PRIMARY KEY (codigo_reserva_fk, codigo_cuarto_fk),
                                    FOREIGN KEY (codigo_reserva_fk) REFERENCES sah.reserva(codigo_reserva),
                                    FOREIGN KEY (codigo_cuarto_fk) REFERENCES sah.cuarto(codigo_cuarto)
);

-- Índices para las claves primarias
CREATE INDEX idx_estado_usuario_alimento_id ON sah.estado_usuario_alimento(id_estado_usuario_alimento);
CREATE INDEX idx_tipo_alimento_id ON sah.tipo_alimento(id_tipo_alimento);
CREATE INDEX idx_alimento_codigo ON sah.alimento(codigo_alimento);
CREATE INDEX idx_tipo_usuario_id ON sah.tipo_usuario(id_tipo_usuario);
CREATE INDEX idx_usuario_codigo ON sah.usuario(codigo_usuario);
CREATE INDEX idx_usuario_alimento_pk ON sah.usuario_alimento(codigo_usuario_fk, codigo_alimento_fk);
CREATE INDEX idx_tipo_servicio_id ON sah.tipo_servicio(id_tipo_servicio);
CREATE INDEX idx_servicio_codigo ON sah.servicio(codigo_servicio);
CREATE INDEX idx_estado_usuario_servicio_id ON sah.estado_usuario_servicio(id_estado_usuario_servicio);
CREATE INDEX idx_usuario_servicio_pk ON sah.usuario_servicio(codigo_servicio_fk, codigo_usuario_fk);
CREATE INDEX idx_estado_cuarto_id ON sah.estado_cuarto(id_estado_cuarto);
CREATE INDEX idx_tipo_cuarto_id ON sah.tipo_cuarto(id_tipo_cuarto);
CREATE INDEX idx_cuarto_codigo ON sah.cuarto(codigo_cuarto);
CREATE INDEX idx_estado_cuarto_servicio_id ON sah.estado_cuarto_servicio(id_estado_cuarto_servicio);
CREATE INDEX idx_cuarto_servicio_pk ON sah.cuarto_servicio(codigo_cuarto_fk, codigo_servicio_fk);
CREATE INDEX idx_estado_reserva_id ON sah.estado_reserva(id_estado_reserva);
CREATE INDEX idx_reserva_codigo ON sah.reserva(codigo_reserva);
CREATE INDEX idx_facturacion_codigo ON sah.facturacion(codigo_facturacion);
CREATE INDEX idx_reserva_cuarto_pk ON sah.reserva_cuarto(codigo_reserva_fk, codigo_cuarto_fk);

-- Índices para las claves foráneas
CREATE INDEX idx_alimento_tipo_fk ON sah.alimento(tipo_alimento_fk);
CREATE INDEX idx_usuario_tipo_fk ON sah.usuario(tipo_usuario_fk);
CREATE INDEX idx_usuario_alimento_usuario_fk ON sah.usuario_alimento(codigo_usuario_fk);
CREATE INDEX idx_usuario_alimento_alimento_fk ON sah.usuario_alimento(codigo_alimento_fk);
CREATE INDEX idx_usuario_alimento_estado_fk ON sah.usuario_alimento(estado_usuario_alimento_fk);
CREATE INDEX idx_servicio_tipo_fk ON sah.servicio(tipo_servicio_fk);
CREATE INDEX idx_usuario_servicio_servicio_fk ON sah.usuario_servicio(codigo_servicio_fk);
CREATE INDEX idx_usuario_servicio_usuario_fk ON sah.usuario_servicio(codigo_usuario_fk);
CREATE INDEX idx_usuario_servicio_estado_fk ON sah.usuario_servicio(estado_usuario_servicio_fk);
CREATE INDEX idx_cuarto_tipo_fk ON sah.cuarto(tipo_cuarto_fk);
CREATE INDEX idx_cuarto_estado_fk ON sah.cuarto(estado_cuarto_fk);
CREATE INDEX idx_cuarto_servicio_cuarto_fk ON sah.cuarto_servicio(codigo_cuarto_fk);
CREATE INDEX idx_cuarto_servicio_servicio_fk ON sah.cuarto_servicio(codigo_servicio_fk);
CREATE INDEX idx_cuarto_servicio_estado_fk ON sah.cuarto_servicio(estado_cuarto_servicio_fk);
CREATE INDEX idx_reserva_usuario_fk ON sah.reserva(codigo_usuario_fk);
CREATE INDEX idx_reserva_estado_fk ON sah.reserva(estado_reserva_fk);
CREATE INDEX idx_facturacion_reserva_fk ON sah.facturacion(codigo_reserva_fk);
CREATE INDEX idx_facturacion_usuario_fk ON sah.facturacion(codigo_usuario_fk);
CREATE INDEX idx_reserva_cuarto_reserva_fk ON sah.reserva_cuarto(codigo_reserva_fk);
CREATE INDEX idx_reserva_cuarto_cuarto_fk ON sah.reserva_cuarto(codigo_cuarto_fk);

-- Comentarios en tablas
COMMENT ON TABLE sah.estado_usuario_alimento IS 'Tabla que almacena los diferentes estados posibles para los alimentos de un usuario.';
COMMENT ON TABLE sah.tipo_alimento IS 'Tabla que almacena los tipos de alimentos disponibles.';
COMMENT ON TABLE sah.alimento IS 'Tabla que almacena los alimentos con sus características y tiempos de preparación.';
COMMENT ON TABLE sah.tipo_usuario IS 'Tabla que almacena los tipos de usuarios existentes.';
COMMENT ON TABLE sah.usuario IS 'Tabla que almacena la información personal y credenciales de los usuarios.';
COMMENT ON TABLE sah.usuario_alimento IS 'Tabla que relaciona a los usuarios con los alimentos que han solicitado y su estado.';
COMMENT ON TABLE sah.tipo_servicio IS 'Tabla que almacena los diferentes tipos de servicios ofrecidos.';
COMMENT ON TABLE sah.servicio IS 'Tabla que almacena los servicios ofrecidos y sus características.';
COMMENT ON TABLE sah.estado_usuario_servicio IS 'Tabla que almacena los diferentes estados posibles para los servicios de un usuario.';
COMMENT ON TABLE sah.usuario_servicio IS 'Tabla que relaciona a los usuarios con los servicios que han solicitado y su estado.';
COMMENT ON TABLE sah.estado_cuarto IS 'Tabla que almacena los diferentes estados en los que puede estar un cuarto.';
COMMENT ON TABLE sah.tipo_cuarto IS 'Tabla que almacena los diferentes tipos de cuartos disponibles.';
COMMENT ON TABLE sah.cuarto IS 'Tabla que almacena la información sobre los cuartos disponibles.';
COMMENT ON TABLE sah.estado_cuarto_servicio IS 'Tabla que almacena los diferentes estados posibles para los servicios de un cuarto.';
COMMENT ON TABLE sah.cuarto_servicio IS 'Tabla que relaciona a los cuartos con los servicios que se les han asignado y su estado.';
COMMENT ON TABLE sah.estado_reserva IS 'Tabla que almacena los diferentes estados posibles para una reserva.';
COMMENT ON TABLE sah.reserva IS 'Tabla que almacena la información de las reservas realizadas por los usuarios.';
COMMENT ON TABLE sah.facturacion IS 'Tabla que almacena la información de las facturaciones relacionadas con reservas y usuarios.';
COMMENT ON TABLE sah.reserva_cuarto IS 'Tabla que relaciona las reservas con los cuartos asignados a ellas.';

