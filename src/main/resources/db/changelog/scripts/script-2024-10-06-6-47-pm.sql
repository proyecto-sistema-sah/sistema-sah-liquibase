--Se agrega llave foranea a blacklist
ALTER TABLE black_list_token
    ADD COLUMN codigo_usuario_fk VARCHAR(7), -- Columna para la clave foránea
ADD CONSTRAINT fk_codigo_usuario
    FOREIGN KEY (codigo_usuario_fk) REFERENCES sah.usuario(codigo_usuario) ON DELETE CASCADE;

-- Crear un índice en la columna 'codigo_usuario_fk' para mejorar la eficiencia de las consultas
CREATE INDEX idx_codigo_usuario_fk ON black_list_token (codigo_usuario_fk);
