-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/05_procedures/07_sp_registrar_territorio.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Registro atómico e idempotente de la jerarquía político-territorial
--           Estado -> Municipio -> Parroquia cumpliendo RM-01 y RM-02 (HU-09).
-- ============================================================================

CREATE OR REPLACE PROCEDURE sp_registrar_jerarquia_territorial(
    p_nombre_estado    VARCHAR,
    p_nombre_municipio VARCHAR,
    p_nombre_parroquia VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_est VARCHAR(100) := BTRIM(p_nombre_estado);
    v_mun VARCHAR(100) := BTRIM(p_nombre_municipio);
    v_par VARCHAR(100) := BTRIM(p_nombre_parroquia);
BEGIN
    INSERT INTO estado (nombre_estado)
    VALUES (v_est)
    ON CONFLICT DO NOTHING;

    INSERT INTO municipio (nombre_estado, nombre_municipio)
    VALUES (v_est, v_mun)
    ON CONFLICT DO NOTHING;

    INSERT INTO parroquia (nombre_estado, nombre_municipio, nombre_parroquia)
    VALUES (v_est, v_mun, v_par)
    ON CONFLICT DO NOTHING;
END;
$$;
