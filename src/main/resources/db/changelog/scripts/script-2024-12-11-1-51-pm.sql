CREATE OR REPLACE VIEW sah.vista_tipos_cuarto AS
SELECT id_tipo_cuarto,
       nombre_tipo_cuarto
FROM sah.tipo_cuarto;

CREATE MATERIALIZED VIEW sah.vista_tipos_usuario AS
SELECT id_tipo_usuario,
       nombre_tipo_usuario
FROM sah.tipo_usuario;

CREATE OR REPLACE VIEW sah.vista_alimentos AS
SELECT codigo_alimento,
       nombre_alimento,
       tipo_alimento_fk,
       tiempo_preparacion_alimento,
       detalle_alimento,
       codigo_imagen
FROM sah.alimento;

CREATE MATERIALIZED VIEW sah.vista_servicios AS
SELECT codigo_servicio,
       nombre_servicio,
       tipo_servicio_fk,
       valor_servicio,
       codigo_imagen_servicio,
       detalle_servicio
FROM sah.servicio;

--liquibase formatted sql

-- Crear función para el trigger
CREATE OR REPLACE FUNCTION sah.trigger_actualizar_fecha_reserva()
    RETURNS TRIGGER AS
'
BEGIN
    NEW.fecha_actualizacion_reserva = NOW();
    RETURN NEW;
END;
' LANGUAGE plpgsql;


-- Crear el trigger asociado a la función
CREATE OR REPLACE TRIGGER actualizar_fecha_reserva
    BEFORE UPDATE
    ON sah.reserva
    FOR EACH ROW
EXECUTE FUNCTION sah.trigger_actualizar_fecha_reserva();

-- Crear procedimiento almacenado para registrar una nueva reserva
CREATE OR REPLACE PROCEDURE sah.procesar_reserva(
    IN p_codigo_reserva VARCHAR(7),
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    IN p_valor_total NUMERIC(10, 2),
    IN p_codigo_usuario VARCHAR(7),
    IN p_estado_reserva INT,
    IN p_codigo_cuarto VARCHAR(7)
)
    LANGUAGE plpgsql
AS
'
BEGIN
    -- Validar que el usuario existe
    IF NOT EXISTS (SELECT 1 FROM sah.usuario WHERE codigo_usuario = p_codigo_usuario) THEN
        RAISE EXCEPTION ''El usuario con código % no existe'', p_codigo_usuario;
    END IF;

    -- Validar que el cuarto existe
    IF NOT EXISTS (SELECT 1 FROM sah.cuarto WHERE codigo_cuarto = p_codigo_cuarto) THEN
        RAISE EXCEPTION ''El cuarto con código % no existe'', p_codigo_cuarto;
    END IF;

    -- Insertar la reserva
    INSERT INTO sah.reserva (codigo_reserva,
                             fecha_inicio_reserva,
                             fecha_fin_reserva,
                             fecha_creacion_reserva,
                             fecha_actualizacion_reserva,
                             valor_total_reserva,
                             codigo_usuario_fk,
                             estado_reserva_fk)
    VALUES (p_codigo_reserva,
            p_fecha_inicio,
            p_fecha_fin,
            NOW(),
            NOW(),
            p_valor_total,
            p_codigo_usuario,
            p_estado_reserva);

-- Asociar la reserva con el cuarto
    INSERT INTO sah.reserva_cuarto (codigo_reserva_fk,
                                    codigo_cuarto_fk)
    VALUES (p_codigo_reserva,
            p_codigo_cuarto);

-- Asociar alimentos al usuario
    INSERT INTO sah.usuario_alimento (codigo_usuario_fk,
                                      codigo_alimento_fk,
                                      estado_usuario_alimento_fk)
    SELECT p_codigo_usuario,
           codigo_alimento,
           1 -- Estado predeterminado
    FROM sah.alimento;

-- Asociar servicios al usuario
    INSERT INTO sah.usuario_servicio (codigo_usuario_fk,
                                      codigo_servicio_fk,
                                      estado_usuario_servicio_fk)
    SELECT p_codigo_usuario,
           codigo_servicio_fk,
           1 -- Estado predeterminado
    FROM sah.cuarto_servicio
    WHERE codigo_cuarto_fk = p_codigo_cuarto;

-- Finalizar con un mensaje de confirmación (opcional)
    RAISE NOTICE ''Reserva creada con éxito: %'', p_codigo_reserva;
END;
';
