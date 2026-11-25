-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/05_procedures/06_sp_actualizar_perfil_usuario.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Actualización de contacto, contraseña, teléfono de emergencia y
--           accesibilidad de los actores del sistema (HU-02, HU-08).
-- ============================================================================

CREATE OR REPLACE PROCEDURE sp_actualizar_perfil_visitante(
    p_cedula_pasaporte    VARCHAR,
    p_correo_contacto     VARCHAR DEFAULT NULL,
    p_telefono_contacto   VARCHAR DEFAULT NULL,
    p_telefono_emergencia VARCHAR DEFAULT NULL,
    p_idioma_nativo       VARCHAR DEFAULT NULL,
    p_grupo_sanguineo     VARCHAR DEFAULT NULL,
    p_nueva_contrasena    TEXT    DEFAULT NULL,
    p_accesibilidades     TEXT[]  DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id  VARCHAR := UPPER(BTRIM(p_cedula_pasaporte));
    v_req TEXT;
BEGIN
    UPDATE visitante
       SET correo_contacto     = COALESCE(NULLIF(LOWER(BTRIM(p_correo_contacto)), ''), correo_contacto),
           telefono_contacto   = COALESCE(NULLIF(BTRIM(p_telefono_contacto), ''), telefono_contacto),
           telefono_emergencia = COALESCE(NULLIF(BTRIM(p_telefono_emergencia), ''), telefono_emergencia),
           idioma_nativo       = COALESCE(NULLIF(BTRIM(p_idioma_nativo), ''), idioma_nativo),
           grupo_sanguineo     = COALESCE(NULLIF(UPPER(BTRIM(p_grupo_sanguineo)), ''), grupo_sanguineo),
           contrasena          = COALESCE(NULLIF(p_nueva_contrasena, ''), contrasena)
     WHERE cedula_pasaporte = v_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Visitante % no encontrado.', v_id;
    END IF;

    IF p_accesibilidades IS NOT NULL THEN
        DELETE FROM accesibilidad_visitante WHERE cedula_pasaporte = v_id;
        IF array_length(p_accesibilidades, 1) IS NOT NULL THEN
            FOREACH v_req IN ARRAY p_accesibilidades LOOP
                IF NULLIF(BTRIM(v_req), '') IS NOT NULL THEN
                    INSERT INTO accesibilidad_visitante (cedula_pasaporte, req_accesibilidad)
                    VALUES (v_id, BTRIM(v_req))
                    ON CONFLICT DO NOTHING;
                END IF;
            END LOOP;
        END IF;
    END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_actualizar_contacto_actor(
    p_tipo_actor          VARCHAR,
    p_identificador       VARCHAR,
    p_cod_licencia        VARCHAR DEFAULT NULL,
    p_correo_contacto     VARCHAR DEFAULT NULL,
    p_telefono_contacto   VARCHAR DEFAULT NULL,
    p_telefono_emergencia VARCHAR DEFAULT NULL,
    p_nueva_contrasena    TEXT    DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_tipo VARCHAR := UPPER(BTRIM(p_tipo_actor));
    v_id   VARCHAR := UPPER(BTRIM(p_identificador));
    v_lic  VARCHAR := NULLIF(UPPER(BTRIM(p_cod_licencia)), '');
BEGIN
    IF v_tipo = 'VISITANTE' THEN
        UPDATE visitante
           SET correo_contacto     = COALESCE(NULLIF(LOWER(BTRIM(p_correo_contacto)), ''), correo_contacto),
               telefono_contacto   = COALESCE(NULLIF(BTRIM(p_telefono_contacto), ''), telefono_contacto),
               telefono_emergencia = COALESCE(NULLIF(BTRIM(p_telefono_emergencia), ''), telefono_emergencia),
               contrasena          = COALESCE(NULLIF(p_nueva_contrasena, ''), contrasena)
         WHERE cedula_pasaporte = v_id;
    ELSIF v_tipo = 'GUIA_TURISTICO' THEN
        IF v_lic IS NULL THEN
            RAISE EXCEPTION 'Para GUIA_TURISTICO debe suministrar p_cod_licencia.';
        END IF;
        UPDATE guia_turistico
           SET correo_contacto     = COALESCE(NULLIF(LOWER(BTRIM(p_correo_contacto)), ''), correo_contacto),
               telefono_contacto   = COALESCE(NULLIF(BTRIM(p_telefono_contacto), ''), telefono_contacto),
               telefono_emergencia = COALESCE(NULLIF(BTRIM(p_telefono_emergencia), ''), telefono_emergencia),
               contrasena          = COALESCE(NULLIF(p_nueva_contrasena, ''), contrasena)
         WHERE nro_rtn = v_id AND cod_licencia = v_lic;
    ELSIF v_tipo = 'COMERCIO_ALIADO' THEN
        UPDATE comercio_aliado
           SET correo_contacto     = COALESCE(NULLIF(LOWER(BTRIM(p_correo_contacto)), ''), correo_contacto),
               telefono_contacto   = COALESCE(NULLIF(BTRIM(p_telefono_contacto), ''), telefono_contacto),
               telefono_emergencia = COALESCE(NULLIF(BTRIM(p_telefono_emergencia), ''), telefono_emergencia),
               contrasena          = COALESCE(NULLIF(p_nueva_contrasena, ''), contrasena)
         WHERE rif = v_id;
    ELSIF v_tipo = 'ENTE_PUBLICO' THEN
        UPDATE ente_publico
           SET correo_contacto     = COALESCE(NULLIF(LOWER(BTRIM(p_correo_contacto)), ''), correo_contacto),
               telefono_contacto   = COALESCE(NULLIF(BTRIM(p_telefono_contacto), ''), telefono_contacto),
               telefono_emergencia = COALESCE(NULLIF(BTRIM(p_telefono_emergencia), ''), telefono_emergencia),
               contrasena          = COALESCE(NULLIF(p_nueva_contrasena, ''), contrasena)
         WHERE rif_gubernamental = v_id;
    ELSE
        RAISE EXCEPTION 'Tipo de actor inválido: "%".', p_tipo_actor;
    END IF;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'No se encontró el actor % con identificador %.', v_tipo, v_id;
    END IF;
END;
$$;
