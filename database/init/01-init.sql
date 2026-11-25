-- Script inicial DDL para el proyecto de Bases de Datos
-- Se ejecuta automáticamente si se levanta el contenedor con docker-compose

CREATE SCHEMA IF NOT EXISTS proyectobd;

-- Ejemplo: tabla inicial de prueba / verificación
CREATE TABLE IF NOT EXISTS proyectobd.schema_version (
    id SERIAL PRIMARY KEY,
    version VARCHAR(50) NOT NULL,
    description TEXT,
    installed_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO proyectobd.schema_version (version, description)
VALUES ('1.0.0', 'Inicialización de esquema para PostgreSQL')
ON CONFLICT DO NOTHING;
