-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/03_functions/03_fn_jerarquia_territorial.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Consulta estructurada de la jerarquía político-territorial
--           Estado -> Municipio -> Parroquia y conteo de hitos (HU-09).
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_listar_jerarquia_territorial(
    p_nombre_estado    VARCHAR DEFAULT NULL,
    p_nombre_municipio VARCHAR DEFAULT NULL
)
RETURNS TABLE (
    nombre_estado     VARCHAR,
    nombre_municipio  VARCHAR,
    nombre_parroquia  VARCHAR,
    total_hitos       BIGINT,
    hitos_disponibles BIGINT
)
LANGUAGE sql
STABLE
AS $$
    SELECT
        e.nombre_estado,
        m.nombre_municipio,
        p.nombre_parroquia,
        COUNT(h.nombre_hito) AS total_hitos,
        COUNT(h.nombre_hito) FILTER (WHERE h.estado_operativo = 'disponible') AS hitos_disponibles
    FROM estado e
    JOIN municipio m
      ON m.nombre_estado = e.nombre_estado
    JOIN parroquia p
      ON p.nombre_estado = m.nombre_estado
     AND p.nombre_municipio = m.nombre_municipio
    LEFT JOIN hito h
      ON h.nombre_estado = p.nombre_estado
     AND h.nombre_municipio = p.nombre_municipio
     AND h.nombre_parroquia = p.nombre_parroquia
    WHERE (
        p_nombre_estado IS NULL
        OR LOWER(BTRIM(e.nombre_estado)) = LOWER(BTRIM(p_nombre_estado))
    )
      AND (
        p_nombre_municipio IS NULL
        OR LOWER(BTRIM(m.nombre_municipio)) = LOWER(BTRIM(p_nombre_municipio))
    )
    GROUP BY e.nombre_estado, m.nombre_municipio, p.nombre_parroquia
    ORDER BY e.nombre_estado, m.nombre_municipio, p.nombre_parroquia;
$$;
