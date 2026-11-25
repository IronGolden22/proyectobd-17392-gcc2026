-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/03_functions/04_fn_distancia_3d_hitos.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Cálculo matemático tridimensional (Haversine + desnivel vertical)
--           usando exclusivamente tipos numéricos primitivos sin extensiones
--           espaciales (HU-11, HU-13).
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_calcular_distancia_3d_m(
    p_lat1 NUMERIC,
    p_lon1 NUMERIC,
    p_alt1 NUMERIC,
    p_lat2 NUMERIC,
    p_lon2 NUMERIC,
    p_alt2 NUMERIC
)
RETURNS NUMERIC(12,2)
LANGUAGE plpgsql
IMMUTABLE
STRICT
AS $$
DECLARE
    v_radio_tierra_m CONSTANT DOUBLE PRECISION := 6371000.0;
    v_lat1_rad       DOUBLE PRECISION;
    v_lat2_rad       DOUBLE PRECISION;
    v_dlat           DOUBLE PRECISION;
    v_dlon           DOUBLE PRECISION;
    v_a              DOUBLE PRECISION;
    v_d_horiz        DOUBLE PRECISION;
    v_dz             DOUBLE PRECISION;
BEGIN
    v_lat1_rad := radians(p_lat1::DOUBLE PRECISION);
    v_lat2_rad := radians(p_lat2::DOUBLE PRECISION);
    v_dlat     := radians((p_lat2 - p_lat1)::DOUBLE PRECISION);
    v_dlon     := radians((p_lon2 - p_lon1)::DOUBLE PRECISION);

    v_a := power(sin(v_dlat / 2.0), 2)
           + cos(v_lat1_rad) * cos(v_lat2_rad) * power(sin(v_dlon / 2.0), 2);
    v_a := LEAST(1.0::DOUBLE PRECISION, GREATEST(0.0::DOUBLE PRECISION, v_a));

    v_d_horiz := 2.0 * v_radio_tierra_m * asin(sqrt(v_a));
    v_dz      := (p_alt2 - p_alt1)::DOUBLE PRECISION;

    RETURN ROUND(sqrt(power(v_d_horiz, 2) + power(v_dz, 2))::NUMERIC, 2);
END;
$$;

CREATE OR REPLACE FUNCTION fn_buscar_hitos_cercanos_3d(
    p_latitud      NUMERIC,
    p_longitud     NUMERIC,
    p_altitud_msnm NUMERIC,
    p_radio_max_m  NUMERIC DEFAULT 1000.0
)
RETURNS TABLE (
    nombre_estado    VARCHAR,
    nombre_municipio VARCHAR,
    nombre_parroquia VARCHAR,
    nombre_hito      VARCHAR,
    latitud          NUMERIC,
    longitud         NUMERIC,
    altitud_msnm     NUMERIC,
    estado_operativo VARCHAR,
    diferencia_alt_m NUMERIC,
    distancia_3d_m   NUMERIC
)
LANGUAGE sql
STABLE
AS $$
    SELECT
        h.nombre_estado,
        h.nombre_municipio,
        h.nombre_parroquia,
        h.nombre_hito,
        h.latitud,
        h.longitud,
        h.altitud_msnm,
        h.estado_operativo,
        ABS(h.altitud_msnm - p_altitud_msnm) AS diferencia_alt_m,
        fn_calcular_distancia_3d_m(
            p_latitud, p_longitud, p_altitud_msnm,
            h.latitud, h.longitud, h.altitud_msnm
        ) AS distancia_3d_m
    FROM hito h
    WHERE fn_calcular_distancia_3d_m(
        p_latitud, p_longitud, p_altitud_msnm,
        h.latitud, h.longitud, h.altitud_msnm
    ) <= p_radio_max_m
    ORDER BY distancia_3d_m ASC, h.nombre_hito ASC;
$$;
