-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/03_functions/02_fn_consultar_perfil_usuario.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Consulta de perfil de visitante con accesibilidad (HU-01, HU-02,
--           HU-08) y búsqueda/filtrado de guías turísticos por idiomas,
--           zona geográfica asignada y especialidades (HU-03, HU-04).
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_obtener_perfil_visitante(
    p_cedula_pasaporte VARCHAR
)
RETURNS TABLE (
    cedula_pasaporte    VARCHAR,
    nombres             VARCHAR,
    apellidos           VARCHAR,
    pais_origen         VARCHAR,
    idioma_nativo       VARCHAR,
    telefono_emergencia VARCHAR,
    grupo_sanguineo     VARCHAR,
    correo_contacto     VARCHAR,
    telefono_contacto   VARCHAR,
    estado_cuenta       VARCHAR,
    requerimientos_acc  TEXT[]
)
LANGUAGE sql
STABLE
AS $$
    SELECT
        v.cedula_pasaporte,
        v.nombres,
        v.apellidos,
        v.pais_origen,
        v.idioma_nativo,
        v.telefono_emergencia,
        v.grupo_sanguineo,
        v.correo_contacto,
        v.telefono_contacto,
        v.estado_cuenta,
        COALESCE(
            ARRAY_AGG(av.req_accesibilidad ORDER BY av.req_accesibilidad)
            FILTER (WHERE av.req_accesibilidad IS NOT NULL),
            ARRAY[]::TEXT[]
        ) AS requerimientos_acc
    FROM visitante v
    LEFT JOIN accesibilidad_visitante av
           ON av.cedula_pasaporte = v.cedula_pasaporte
    WHERE UPPER(BTRIM(v.cedula_pasaporte)) = UPPER(BTRIM(p_cedula_pasaporte))
    GROUP BY
        v.cedula_pasaporte,
        v.nombres,
        v.apellidos,
        v.pais_origen,
        v.idioma_nativo,
        v.telefono_emergencia,
        v.grupo_sanguineo,
        v.correo_contacto,
        v.telefono_contacto,
        v.estado_cuenta;
$$;

CREATE OR REPLACE FUNCTION fn_buscar_guias_disponibles(
    p_idioma         VARCHAR DEFAULT NULL,
    p_estado_zona    VARCHAR DEFAULT NULL,
    p_municipio_zona VARCHAR DEFAULT NULL,
    p_especialidad   VARCHAR DEFAULT NULL
)
RETURNS TABLE (
    nro_rtn               VARCHAR,
    cod_licencia          VARCHAR,
    nombres               VARCHAR,
    apellidos             VARCHAR,
    acreditacion_oficial  VARCHAR,
    anos_trayectoria      INTEGER,
    tarifa_horaria        NUMERIC,
    nombre_estado_zona    VARCHAR,
    nombre_municipio_zona VARCHAR,
    correo_contacto       VARCHAR,
    telefono_contacto     VARCHAR,
    idiomas_dominados     TEXT[],
    especialidades        TEXT[],
    cantidad_rutas        BIGINT
)
LANGUAGE sql
STABLE
AS $$
    SELECT
        g.nro_rtn,
        g.cod_licencia,
        g.nombres,
        g.apellidos,
        g.acreditacion_oficial,
        g.anos_trayectoria,
        g.tarifa_horaria,
        g.nombre_estado_zona,
        g.nombre_municipio_zona,
        g.correo_contacto,
        g.telefono_contacto,
        COALESCE(
            (SELECT ARRAY_AGG(DISTINCT ig.idiomas_dominados ORDER BY ig.idiomas_dominados)
               FROM idioma_guia ig
              WHERE ig.nro_rtn = g.nro_rtn AND ig.cod_licencia = g.cod_licencia),
            ARRAY[]::TEXT[]
        ) AS idiomas_dominados,
        COALESCE(
            (SELECT ARRAY_AGG(DISTINCT eg.especialidades ORDER BY eg.especialidades)
               FROM especialidad_guia eg
              WHERE eg.nro_rtn = g.nro_rtn AND eg.cod_licencia = g.cod_licencia),
            ARRAY[]::TEXT[]
        ) AS especialidades,
        (SELECT COUNT(*)
           FROM acompana_ruta ar
          WHERE ar.nro_rtn = g.nro_rtn AND ar.cod_licencia = g.cod_licencia) AS cantidad_rutas
    FROM guia_turistico g
    WHERE g.estado_cuenta = 'activa'
      AND (
          p_estado_zona IS NULL
          OR LOWER(BTRIM(g.nombre_estado_zona)) = LOWER(BTRIM(p_estado_zona))
      )
      AND (
          p_municipio_zona IS NULL
          OR LOWER(BTRIM(g.nombre_municipio_zona)) = LOWER(BTRIM(p_municipio_zona))
      )
      AND (
          p_idioma IS NULL
          OR EXISTS (
              SELECT 1
                FROM idioma_guia ig
               WHERE ig.nro_rtn = g.nro_rtn
                 AND ig.cod_licencia = g.cod_licencia
                 AND LOWER(BTRIM(ig.idiomas_dominados)) = LOWER(BTRIM(p_idioma))
          )
      )
      AND (
          p_especialidad IS NULL
          OR EXISTS (
              SELECT 1
                FROM especialidad_guia eg
               WHERE eg.nro_rtn = g.nro_rtn
                 AND eg.cod_licencia = g.cod_licencia
                 AND LOWER(eg.especialidades) LIKE ('%' || LOWER(BTRIM(p_especialidad)) || '%')
          )
      )
    ORDER BY g.anos_trayectoria DESC, g.tarifa_horaria ASC, g.apellidos ASC;
$$;
