-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/03_functions/01_fn_hash_y_autenticacion.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Hashing SHA-256 nativo y autenticación unificada multi-actor
--           (Visitante, Guía, Comercio Aliado, Ente Público) con control de
--           estado de cuenta (HU-01, HU-03, HU-05, HU-06, HU-07).
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_hash_contrasena(p_texto TEXT)
RETURNS VARCHAR(64)
LANGUAGE plpgsql
IMMUTABLE
STRICT
AS $$
BEGIN
    IF BTRIM(p_texto) = '' THEN
        RAISE EXCEPTION 'La contraseña no puede ser vacía.';
    END IF;

    RETURN encode(sha256(convert_to(p_texto, 'UTF8')), 'hex');
END;
$$;

CREATE OR REPLACE FUNCTION fn_autenticar_usuario(
    p_identificador VARCHAR,
    p_contrasena    TEXT,
    p_cod_licencia  VARCHAR DEFAULT NULL
)
RETURNS TABLE (
    tipo_actor     VARCHAR,
    identificador  VARCHAR,
    nombre_mostrar VARCHAR,
    estado_cuenta  VARCHAR,
    autenticado    BOOLEAN,
    mensaje        TEXT
)
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    v_id          VARCHAR := UPPER(BTRIM(p_identificador));
    v_lic         VARCHAR := NULLIF(UPPER(BTRIM(p_cod_licencia)), '');
    v_hash_input  VARCHAR(64);
    v_hash_stored VARCHAR(255);
    v_nombre      VARCHAR;
    v_estado      VARCHAR;
BEGIN
    IF v_id IS NULL OR v_id = '' OR p_contrasena IS NULL OR BTRIM(p_contrasena) = '' THEN
        RETURN QUERY SELECT NULL::VARCHAR, p_identificador, NULL::VARCHAR, NULL::VARCHAR, FALSE,
            'Debe proporcionar identificador y contraseña.'::TEXT;
        RETURN;
    END IF;

    v_hash_input := fn_hash_contrasena(p_contrasena);

    -- 1. Caso Guía Turístico (requiere RTN + código de licencia)
    IF v_lic IS NOT NULL THEN
        SELECT g.contrasena, (g.nombres || ' ' || g.apellidos)::VARCHAR, g.estado_cuenta
          INTO v_hash_stored, v_nombre, v_estado
          FROM guia_turistico g
         WHERE UPPER(BTRIM(g.nro_rtn)) = v_id
           AND UPPER(BTRIM(g.cod_licencia)) = v_lic;

        IF NOT FOUND THEN
            RETURN QUERY SELECT 'GUIA_TURISTICO'::VARCHAR, (v_id || ' / ' || v_lic)::VARCHAR,
                NULL::VARCHAR, NULL::VARCHAR, FALSE, 'Credenciales de guía turístico no encontradas.'::TEXT;
            RETURN;
        END IF;

        IF v_hash_stored <> v_hash_input THEN
            RETURN QUERY SELECT 'GUIA_TURISTICO'::VARCHAR, (v_id || ' / ' || v_lic)::VARCHAR,
                v_nombre, v_estado, FALSE, 'Contraseña incorrecta.'::TEXT;
            RETURN;
        END IF;

        IF v_estado <> 'activa' THEN
            RETURN QUERY SELECT 'GUIA_TURISTICO'::VARCHAR, (v_id || ' / ' || v_lic)::VARCHAR,
                v_nombre, v_estado, FALSE, ('Acceso denegado: cuenta en estado ' || v_estado || '.')::TEXT;
            RETURN;
        END IF;

        RETURN QUERY SELECT 'GUIA_TURISTICO'::VARCHAR, (v_id || ' / ' || v_lic)::VARCHAR,
            v_nombre, v_estado, TRUE, 'Autenticación exitosa.'::TEXT;
        RETURN;
    END IF;

    -- 2. Caso Visitante (cédula o pasaporte)
    SELECT v.contrasena, (v.nombres || ' ' || v.apellidos)::VARCHAR, v.estado_cuenta
      INTO v_hash_stored, v_nombre, v_estado
      FROM visitante v
     WHERE UPPER(BTRIM(v.cedula_pasaporte)) = v_id;

    IF FOUND THEN
        IF v_hash_stored <> v_hash_input THEN
            RETURN QUERY SELECT 'VISITANTE'::VARCHAR, v_id, v_nombre, v_estado, FALSE,
                'Contraseña incorrecta.'::TEXT;
            RETURN;
        END IF;
        IF v_estado <> 'activa' THEN
            RETURN QUERY SELECT 'VISITANTE'::VARCHAR, v_id, v_nombre, v_estado, FALSE,
                ('Acceso denegado: cuenta en estado ' || v_estado || '.')::TEXT;
            RETURN;
        END IF;
        RETURN QUERY SELECT 'VISITANTE'::VARCHAR, v_id, v_nombre, v_estado, TRUE,
            'Autenticación exitosa.'::TEXT;
        RETURN;
    END IF;

    -- 3. Caso Comercio Aliado (RIF jurídico)
    SELECT c.contrasena, c.razon_social, c.estado_cuenta
      INTO v_hash_stored, v_nombre, v_estado
      FROM comercio_aliado c
     WHERE UPPER(BTRIM(c.rif)) = v_id;

    IF FOUND THEN
        IF v_hash_stored <> v_hash_input THEN
            RETURN QUERY SELECT 'COMERCIO_ALIADO'::VARCHAR, v_id, v_nombre, v_estado, FALSE,
                'Contraseña incorrecta.'::TEXT;
            RETURN;
        END IF;
        IF v_estado <> 'activa' THEN
            RETURN QUERY SELECT 'COMERCIO_ALIADO'::VARCHAR, v_id, v_nombre, v_estado, FALSE,
                ('Acceso denegado: cuenta en estado ' || v_estado || '.')::TEXT;
            RETURN;
        END IF;
        RETURN QUERY SELECT 'COMERCIO_ALIADO'::VARCHAR, v_id, v_nombre, v_estado, TRUE,
            'Autenticación exitosa.'::TEXT;
        RETURN;
    END IF;

    -- 4. Caso Ente Público (RIF gubernamental)
    SELECT e.contrasena, e.denominacion_oficial, e.estado_cuenta
      INTO v_hash_stored, v_nombre, v_estado
      FROM ente_publico e
     WHERE UPPER(BTRIM(e.rif_gubernamental)) = v_id;

    IF FOUND THEN
        IF v_hash_stored <> v_hash_input THEN
            RETURN QUERY SELECT 'ENTE_PUBLICO'::VARCHAR, v_id, v_nombre, v_estado, FALSE,
                'Contraseña incorrecta.'::TEXT;
            RETURN;
        END IF;
        IF v_estado <> 'activa' THEN
            RETURN QUERY SELECT 'ENTE_PUBLICO'::VARCHAR, v_id, v_nombre, v_estado, FALSE,
                ('Acceso denegado: cuenta en estado ' || v_estado || '.')::TEXT;
            RETURN;
        END IF;
        RETURN QUERY SELECT 'ENTE_PUBLICO'::VARCHAR, v_id, v_nombre, v_estado, TRUE,
            'Autenticación exitosa.'::TEXT;
        RETURN;
    END IF;

    RETURN QUERY SELECT NULL::VARCHAR, v_id, NULL::VARCHAR, NULL::VARCHAR, FALSE,
        'Usuario no registrado en la plataforma.'::TEXT;
END;
$$;
