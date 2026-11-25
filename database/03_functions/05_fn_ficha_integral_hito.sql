-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/03_functions/05_fn_ficha_integral_hito.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Consulta de la ficha integral del hito (historia, categorías,
--           horarios, cronograma de eventos, RA y rutas) y catálogo filtrado
--           de hitos (HU-10, HU-14).
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_consultar_ficha_integral_hito(
    p_estado      VARCHAR,
    p_municipio   VARCHAR,
    p_parroquia   VARCHAR,
    p_nombre_hito VARCHAR
)
RETURNS TABLE (
    nombre_estado         VARCHAR,
    nombre_municipio      VARCHAR,
    nombre_parroquia      VARCHAR,
    nombre_hito           VARCHAR,
    latitud               NUMERIC,
    longitud              NUMERIC,
    altitud_msnm          NUMERIC,
    estado_operativo      VARCHAR,
    libre_acceso          BOOLEAN,
    historia              TEXT,
    categorias            TEXT[],
    horarios_visita       TEXT[],
    cronograma_eventos    TEXT[],
    cantidad_anclajes_ra  BIGINT,
    rutas_asociadas       TEXT[]
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
        h.libre_acceso,
        h.historia,
        COALESCE(
            (SELECT ARRAY_AGG(ch.categoria_hito ORDER BY ch.categoria_hito)
               FROM categoria_hito ch
              WHERE ch.nombre_estado = h.nombre_estado
                AND ch.nombre_municipio = h.nombre_municipio
                AND ch.nombre_parroquia = h.nombre_parroquia
                AND ch.nombre_hito = h.nombre_hito),
            ARRAY[]::TEXT[]
        ) AS categorias,
        COALESCE(
            (SELECT ARRAY_AGG(hh.horario_visita ORDER BY hh.horario_visita)
               FROM horario_hito hh
              WHERE hh.nombre_estado = h.nombre_estado
                AND hh.nombre_municipio = h.nombre_municipio
                AND hh.nombre_parroquia = h.nombre_parroquia
                AND hh.nombre_hito = h.nombre_hito),
            ARRAY[]::TEXT[]
        ) AS horarios_visita,
        COALESCE(
            (SELECT ARRAY_AGG(ce.cronograma_eventos ORDER BY ce.cronograma_eventos)
               FROM cronograma_evento_hito ce
              WHERE ce.nombre_estado = h.nombre_estado
                AND ce.nombre_municipio = h.nombre_municipio
                AND ce.nombre_parroquia = h.nombre_parroquia
                AND ce.nombre_hito = h.nombre_hito),
            ARRAY[]::TEXT[]
        ) AS cronograma_eventos,
        (SELECT COUNT(*)
           FROM punto_anclaje_ra ra
          WHERE ra.nombre_estado = h.nombre_estado
            AND ra.nombre_municipio = h.nombre_municipio
            AND ra.nombre_parroquia = h.nombre_parroquia
            AND ra.nombre_hito = h.nombre_hito) AS cantidad_anclajes_ra,
        COALESCE(
            (SELECT ARRAY_AGG(DISTINCT (pi.nombre_ruta || ' (' || pi.nombre_municipio_origen || ', ' || pi.nombre_estado_origen || ')')
                              ORDER BY (pi.nombre_ruta || ' (' || pi.nombre_municipio_origen || ', ' || pi.nombre_estado_origen || ')'))
               FROM paso_itinerario pi
              WHERE pi.nombre_estado_hito = h.nombre_estado
                AND pi.nombre_municipio_hito = h.nombre_municipio
                AND pi.nombre_parroquia_hito = h.nombre_parroquia
                AND pi.nombre_hito = h.nombre_hito),
            ARRAY[]::TEXT[]
        ) AS rutas_asociadas
    FROM hito h
    WHERE LOWER(BTRIM(h.nombre_estado)) = LOWER(BTRIM(p_estado))
      AND LOWER(BTRIM(h.nombre_municipio)) = LOWER(BTRIM(p_municipio))
      AND LOWER(BTRIM(h.nombre_parroquia)) = LOWER(BTRIM(p_parroquia))
      AND LOWER(BTRIM(h.nombre_hito)) = LOWER(BTRIM(p_nombre_hito));
$$;

CREATE OR REPLACE FUNCTION fn_catalogo_hitos(
    p_estado           VARCHAR DEFAULT NULL,
    p_municipio        VARCHAR DEFAULT NULL,
    p_parroquia        VARCHAR DEFAULT NULL,
    p_categoria        VARCHAR DEFAULT NULL,
    p_estado_operativo VARCHAR DEFAULT NULL
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
    libre_acceso     BOOLEAN,
    categorias       TEXT[]
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
        h.libre_acceso,
        COALESCE(
            ARRAY_AGG(DISTINCT ch.categoria_hito ORDER BY ch.categoria_hito)
            FILTER (WHERE ch.categoria_hito IS NOT NULL),
            ARRAY[]::TEXT[]
        ) AS categorias
    FROM hito h
    LEFT JOIN categoria_hito ch
      ON ch.nombre_estado = h.nombre_estado
     AND ch.nombre_municipio = h.nombre_municipio
     AND ch.nombre_parroquia = h.nombre_parroquia
     AND ch.nombre_hito = h.nombre_hito
    WHERE (p_estado IS NULL OR LOWER(BTRIM(h.nombre_estado)) = LOWER(BTRIM(p_estado)))
      AND (p_municipio IS NULL OR LOWER(BTRIM(h.nombre_municipio)) = LOWER(BTRIM(p_municipio)))
      AND (p_parroquia IS NULL OR LOWER(BTRIM(h.nombre_parroquia)) = LOWER(BTRIM(p_parroquia)))
      AND (p_estado_operativo IS NULL OR h.estado_operativo = p_estado_operativo)
      AND (
          p_categoria IS NULL
          OR EXISTS (
              SELECT 1
                FROM categoria_hito ch2
               WHERE ch2.nombre_estado = h.nombre_estado
                 AND ch2.nombre_municipio = h.nombre_municipio
                 AND ch2.nombre_parroquia = h.nombre_parroquia
                 AND ch2.nombre_hito = h.nombre_hito
                 AND ch2.categoria_hito = p_categoria
          )
      )
    GROUP BY
        h.nombre_estado,
        h.nombre_municipio,
        h.nombre_parroquia,
        h.nombre_hito,
        h.latitud,
        h.longitud,
        h.altitud_msnm,
        h.estado_operativo,
        h.libre_acceso
    ORDER BY h.nombre_estado, h.nombre_municipio, h.nombre_parroquia, h.nombre_hito;
$$;
