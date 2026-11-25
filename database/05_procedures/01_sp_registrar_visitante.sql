-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/05_procedures/01_sp_registrar_visitante.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Registro transaccional de visitante y sus requerimientos de
--           accesibilidad física o sensorial (HU-01, HU-02).
-- ============================================================================

CREATE OR REPLACE PROCEDURE sp_registrar_visitante(
    p_cedula_pasaporte    VARCHAR,
    p_contrasena          TEXT,
    p_nombres             VARCHAR,
    p_apellidos           VARCHAR,
    p_pais_origen         VARCHAR,
    p_idioma_nativo       VARCHAR,
    p_telefono_emergencia VARCHAR,
    p_grupo_sanguineo     VARCHAR,
    p_correo_contacto     VARCHAR DEFAULT NULL,
    p_telefono_contacto   VARCHAR DEFAULT NULL,
    p_accesibilidades     TEXT[]  DEFAULT ARRAY[]::TEXT[]
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id  VARCHAR := UPPER(BTRIM(p_cedula_pasaporte));
    v_req TEXT;
BEGIN
    INSERT INTO visitante (
        cedula_pasaporte,
        contrasena,
        nombres,
        apellidos,
        pais_origen,
        idioma_nativo,
        telefono_emergencia,
        grupo_sanguineo,
        correo_contacto,
        telefono_contacto,
        estado_cuenta
    ) VALUES (
        v_id,
        p_contrasena,
        p_nombres,
        p_apellidos,
        p_pais_origen,
        p_idioma_nativo,
        p_telefono_emergencia,
        p_grupo_sanguineo,
        p_correo_contacto,
        p_telefono_contacto,
        'activa'
    );

    IF p_accesibilidades IS NOT NULL AND array_length(p_accesibilidades, 1) IS NOT NULL THEN
        FOREACH v_req IN ARRAY p_accesibilidades LOOP
            IF NULLIF(BTRIM(v_req), '') IS NOT NULL THEN
                INSERT INTO accesibilidad_visitante (cedula_pasaporte, req_accesibilidad)
                VALUES (v_id, BTRIM(v_req))
                ON CONFLICT DO NOTHING;
            END IF;
        END LOOP;
    END IF;
END;
$$;
