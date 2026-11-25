-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/05_procedures/08_sp_registrar_y_actualizar_hito.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Registro integral de hitos en coordenadas 3D con categorías,
--           horarios y cronograma de eventos (HU-10 a HU-14), más
--           actualización de estado operativo y agenda cultural.
-- ============================================================================

CREATE OR REPLACE PROCEDURE sp_registrar_hito_completo(
    p_nombre_estado      VARCHAR,
    p_nombre_municipio   VARCHAR,
    p_nombre_parroquia   VARCHAR,
    p_nombre_hito        VARCHAR,
    p_latitud            NUMERIC,
    p_longitud           NUMERIC,
    p_altitud_msnm       NUMERIC,
    p_estado_operativo   VARCHAR,
    p_libre_acceso       BOOLEAN,
    p_historia           TEXT,
    p_categorias         TEXT[],
    p_horarios           TEXT[] DEFAULT ARRAY[]::TEXT[],
    p_cronograma_eventos TEXT[] DEFAULT ARRAY[]::TEXT[]
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_est  VARCHAR(100) := BTRIM(p_nombre_estado);
    v_mun  VARCHAR(100) := BTRIM(p_nombre_municipio);
    v_par  VARCHAR(100) := BTRIM(p_nombre_parroquia);
    v_hit  VARCHAR(150) := BTRIM(p_nombre_hito);
    v_item TEXT;
BEGIN
    INSERT INTO hito (
        nombre_estado,
        nombre_municipio,
        nombre_parroquia,
        nombre_hito,
        latitud,
        longitud,
        altitud_msnm,
        estado_operativo,
        libre_acceso,
        historia
    ) VALUES (
        v_est,
        v_mun,
        v_par,
        v_hit,
        p_latitud,
        p_longitud,
        p_altitud_msnm,
        LOWER(BTRIM(p_estado_operativo)),
        p_libre_acceso,
        p_historia
    );

    IF p_categorias IS NOT NULL AND array_length(p_categorias, 1) IS NOT NULL THEN
        FOREACH v_item IN ARRAY p_categorias LOOP
            IF NULLIF(BTRIM(v_item), '') IS NOT NULL THEN
                INSERT INTO categoria_hito (
                    nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, categoria_hito
                ) VALUES (v_est, v_mun, v_par, v_hit, LOWER(BTRIM(v_item)))
                ON CONFLICT DO NOTHING;
            END IF;
        END LOOP;
    END IF;

    IF p_horarios IS NOT NULL AND array_length(p_horarios, 1) IS NOT NULL THEN
        FOREACH v_item IN ARRAY p_horarios LOOP
            IF NULLIF(BTRIM(v_item), '') IS NOT NULL THEN
                INSERT INTO horario_hito (
                    nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, horario_visita
                ) VALUES (v_est, v_mun, v_par, v_hit, BTRIM(v_item))
                ON CONFLICT DO NOTHING;
            END IF;
        END LOOP;
    END IF;

    IF p_cronograma_eventos IS NOT NULL AND array_length(p_cronograma_eventos, 1) IS NOT NULL THEN
        FOREACH v_item IN ARRAY p_cronograma_eventos LOOP
            IF NULLIF(BTRIM(v_item), '') IS NOT NULL THEN
                INSERT INTO cronograma_evento_hito (
                    nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, cronograma_eventos
                ) VALUES (v_est, v_mun, v_par, v_hit, BTRIM(v_item))
                ON CONFLICT DO NOTHING;
            END IF;
        END LOOP;
    END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_actualizar_estado_operativo_hito(
    p_nombre_estado    VARCHAR,
    p_nombre_municipio VARCHAR,
    p_nombre_parroquia VARCHAR,
    p_nombre_hito      VARCHAR,
    p_nuevo_estado     VARCHAR,
    p_nuevo_evento     TEXT   DEFAULT NULL,
    p_nuevos_horarios  TEXT[] DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_est  VARCHAR(100) := BTRIM(p_nombre_estado);
    v_mun  VARCHAR(100) := BTRIM(p_nombre_municipio);
    v_par  VARCHAR(100) := BTRIM(p_nombre_parroquia);
    v_hit  VARCHAR(150) := BTRIM(p_nombre_hito);
    v_item TEXT;
BEGIN
    UPDATE hito
       SET estado_operativo = LOWER(BTRIM(p_nuevo_estado))
     WHERE nombre_estado = v_est
       AND nombre_municipio = v_mun
       AND nombre_parroquia = v_par
       AND nombre_hito = v_hit;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Hito "%" en %, %, % no encontrado.', v_hit, v_par, v_mun, v_est;
    END IF;

    IF NULLIF(BTRIM(p_nuevo_evento), '') IS NOT NULL THEN
        INSERT INTO cronograma_evento_hito (
            nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, cronograma_eventos
        ) VALUES (v_est, v_mun, v_par, v_hit, BTRIM(p_nuevo_evento))
        ON CONFLICT DO NOTHING;
    END IF;

    IF p_nuevos_horarios IS NOT NULL THEN
        DELETE FROM horario_hito
         WHERE nombre_estado = v_est
           AND nombre_municipio = v_mun
           AND nombre_parroquia = v_par
           AND nombre_hito = v_hit;

        IF array_length(p_nuevos_horarios, 1) IS NOT NULL THEN
            FOREACH v_item IN ARRAY p_nuevos_horarios LOOP
                IF NULLIF(BTRIM(v_item), '') IS NOT NULL THEN
                    INSERT INTO horario_hito (
                        nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, horario_visita
                    ) VALUES (v_est, v_mun, v_par, v_hit, BTRIM(v_item))
                    ON CONFLICT DO NOTHING;
                END IF;
            END LOOP;
        END IF;
    END IF;
END;
$$;
