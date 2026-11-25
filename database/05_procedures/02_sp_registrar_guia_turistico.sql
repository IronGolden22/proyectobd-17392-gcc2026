-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/05_procedures/02_sp_registrar_guia_turistico.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Registro de guía/baqueano comunitario con especialidades, idiomas
--           y ruta inicial (HU-03, RM-13) y parametrización de idiomas y
--           zona geográfica asignada (HU-04).
-- ============================================================================

CREATE OR REPLACE PROCEDURE sp_registrar_guia_turistico(
    p_nro_rtn               VARCHAR,
    p_cod_licencia          VARCHAR,
    p_contrasena            TEXT,
    p_nombres               VARCHAR,
    p_apellidos             VARCHAR,
    p_acreditacion_oficial  VARCHAR,
    p_anos_trayectoria      INTEGER,
    p_tarifa_horaria        NUMERIC,
    p_nombre_estado_zona    VARCHAR,
    p_nombre_municipio_zona VARCHAR,
    p_especialidades        TEXT[],
    p_idiomas               TEXT[],
    p_estado_ruta_inicial   VARCHAR,
    p_municipio_ruta_inicial VARCHAR,
    p_nombre_ruta_inicial   VARCHAR,
    p_correo_contacto       VARCHAR DEFAULT NULL,
    p_telefono_contacto     VARCHAR DEFAULT NULL,
    p_telefono_emergencia   VARCHAR DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_rtn  VARCHAR := UPPER(BTRIM(p_nro_rtn));
    v_lic  VARCHAR := UPPER(BTRIM(p_cod_licencia));
    v_item TEXT;
BEGIN
    INSERT INTO guia_turistico (
        nro_rtn,
        cod_licencia,
        contrasena,
        nombres,
        apellidos,
        acreditacion_oficial,
        anos_trayectoria,
        tarifa_horaria,
        nombre_estado_zona,
        nombre_municipio_zona,
        correo_contacto,
        telefono_contacto,
        telefono_emergencia,
        estado_cuenta
    ) VALUES (
        v_rtn,
        v_lic,
        p_contrasena,
        p_nombres,
        p_apellidos,
        p_acreditacion_oficial,
        p_anos_trayectoria,
        p_tarifa_horaria,
        p_nombre_estado_zona,
        p_nombre_municipio_zona,
        p_correo_contacto,
        p_telefono_contacto,
        p_telefono_emergencia,
        'activa'
    );

    -- Adscripción obligatoria de ruta inicial para satisfacer RM-13 dentro de la transacción
    INSERT INTO acompana_ruta (
        nro_rtn,
        cod_licencia,
        nombre_estado_origen,
        nombre_municipio_origen,
        nombre_ruta
    ) VALUES (
        v_rtn,
        v_lic,
        BTRIM(p_estado_ruta_inicial),
        BTRIM(p_municipio_ruta_inicial),
        BTRIM(p_nombre_ruta_inicial)
    );

    IF p_especialidades IS NOT NULL AND array_length(p_especialidades, 1) IS NOT NULL THEN
        FOREACH v_item IN ARRAY p_especialidades LOOP
            IF NULLIF(BTRIM(v_item), '') IS NOT NULL THEN
                INSERT INTO especialidad_guia (nro_rtn, cod_licencia, especialidades)
                VALUES (v_rtn, v_lic, BTRIM(v_item))
                ON CONFLICT DO NOTHING;
            END IF;
        END LOOP;
    END IF;

    IF p_idiomas IS NOT NULL AND array_length(p_idiomas, 1) IS NOT NULL THEN
        FOREACH v_item IN ARRAY p_idiomas LOOP
            IF NULLIF(BTRIM(v_item), '') IS NOT NULL THEN
                INSERT INTO idioma_guia (nro_rtn, cod_licencia, idiomas_dominados)
                VALUES (v_rtn, v_lic, BTRIM(v_item))
                ON CONFLICT DO NOTHING;
            END IF;
        END LOOP;
    END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_parametrizar_idiomas_zona_guia(
    p_nro_rtn               VARCHAR,
    p_cod_licencia          VARCHAR,
    p_nombre_estado_zona    VARCHAR,
    p_nombre_municipio_zona VARCHAR,
    p_idiomas               TEXT[],
    p_especialidades        TEXT[] DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_rtn  VARCHAR := UPPER(BTRIM(p_nro_rtn));
    v_lic  VARCHAR := UPPER(BTRIM(p_cod_licencia));
    v_item TEXT;
BEGIN
    UPDATE guia_turistico
       SET nombre_estado_zona    = BTRIM(p_nombre_estado_zona),
           nombre_municipio_zona = BTRIM(p_nombre_municipio_zona)
     WHERE nro_rtn = v_rtn
       AND cod_licencia = v_lic;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Guía turístico (RTN %, Licencia %) no encontrado.', v_rtn, v_lic;
    END IF;

    IF p_idiomas IS NOT NULL THEN
        DELETE FROM idioma_guia
         WHERE nro_rtn = v_rtn AND cod_licencia = v_lic;

        IF array_length(p_idiomas, 1) IS NOT NULL THEN
            FOREACH v_item IN ARRAY p_idiomas LOOP
                IF NULLIF(BTRIM(v_item), '') IS NOT NULL THEN
                    INSERT INTO idioma_guia (nro_rtn, cod_licencia, idiomas_dominados)
                    VALUES (v_rtn, v_lic, BTRIM(v_item))
                    ON CONFLICT DO NOTHING;
                END IF;
            END LOOP;
        END IF;
    END IF;

    IF p_especialidades IS NOT NULL THEN
        DELETE FROM especialidad_guia
         WHERE nro_rtn = v_rtn AND cod_licencia = v_lic;

        IF array_length(p_especialidades, 1) IS NOT NULL THEN
            FOREACH v_item IN ARRAY p_especialidades LOOP
                IF NULLIF(BTRIM(v_item), '') IS NOT NULL THEN
                    INSERT INTO especialidad_guia (nro_rtn, cod_licencia, especialidades)
                    VALUES (v_rtn, v_lic, BTRIM(v_item))
                    ON CONFLICT DO NOTHING;
                END IF;
            END LOOP;
        END IF;
    END IF;
END;
$$;
