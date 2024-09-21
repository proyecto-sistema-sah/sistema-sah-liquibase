
--Creacion de un nuevo enum
CREATE TYPE sah.tipo_usuario_enum AS ENUM ('ADMINISTRADOR', 'USUARIO');

--Se cambia tipo de dato en columna
ALTER TABLE sah.tipo_usuario
ALTER COLUMN nombre_tipo_usuario TYPE sah.tipo_usuario_enum
USING nombre_tipo_usuario::sah.tipo_usuario_enum,
ALTER COLUMN nombre_tipo_usuario SET NOT NULL,
ALTER COLUMN nombre_tipo_usuario SET DEFAULT 'USUARIO';

--Se insertan data a tablas
INSERT INTO sah.estado_usuario_alimento (nombre_estado_usuario_alimento) VALUES
                                                                             ('PREPARACION'),
                                                                             ('ENTREGADO');

INSERT INTO sah.estado_usuario_servicio (nombre_estado_servicio) VALUES
                                                                     ('PENDIENTE'),
                                                                     ('REALIZADO'),
                                                                     ('CANCELADO');

INSERT INTO sah.estado_cuarto (nombre_estado_cuarto) VALUES
                                                         ('OCUPADO'),
                                                         ('LIBRE'),
                                                         ('MANTENIMIENTO');

INSERT INTO sah.estado_cuarto_servicio (nombre_estado_servicio) VALUES
                                                                    ('ACTIVO'),
                                                                    ('INACTIVO');

INSERT INTO sah.estado_reserva (nombre_estado_reserva) VALUES
                                                           ('COMPLETADO'),
                                                           ('CANCELADO'),
                                                           ('PENDIENTE');

INSERT INTO sah.tipo_usuario (nombre_tipo_usuario) VALUES
                                                           ('ADMINISTRADOR'),
                                                           ('USUARIO');
