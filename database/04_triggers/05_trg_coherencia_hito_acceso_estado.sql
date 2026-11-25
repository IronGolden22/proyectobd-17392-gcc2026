-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/04_triggers/05_trg_coherencia_hito_acceso_estado.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Validación de limpieza textual, unicidad local (HU-12), bloqueo
--           de reapertura tras cierre permanente (HU-10), obligatoriedad de
--           al menos una categoría (HU-10) y coherencia de horarios cuando
--           libre_acceso = FALSE y estado_operativo = 'disponible' (HU-14).
-- ============================================================================

CREATE OR REPLACE FUNCTION trg_fn_coherencia_hito_before()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.nombre_estado    := BTRIM(NEW.nombre_estado);
    NEW.nombre_municipio := BTRIM(NEW.nombre_municipio);
    NEW.nombre_parroquia := BTRIM(NEW.nombre_parroquia);
    NEW.nombre_hito      := BTRIM(NEW.nombre_hito);
    NEW.historia         := BTRIM(NEW.historia);

    IF TG_OP = 'UPDATE' THEN
        IF OLD.estado_operativo = 'cerrado permanentemente'
           AND NEW.estado_operativo <> 'cerrado permanentemente' THEN
            RAISE EXCEPTION 'Un hito en estado "cerrado permanentemente" no puede reabrirse (hito: "%").', OLD.nombre_hito;
        END IF;
    END IF;

    IF TG_OP = 'INSERT' OR (
        LOWER(NEW.nombre_estado)    <> LOWER(OLD.nombre_estado) OR
        LOWER(NEW.nombre_municipio) <> LOWER(OLD.nombre_municipio) OR
        LOWER(NEW.nombre_parroquia) <> LOWER(OLD.nombre_parroquia) OR
        LOWER(NEW.nombre_hito)      <> LOWER(OLD.nombre_hito)
    ) THEN
        IF EXISTS (
            SELECT 1 FROM hito h
             WHERE LOWER(BTRIM(h.nombre_estado))    = LOWER(NEW.nombre_estado)
               AND LOWER(BTRIM(h.nombre_municipio)) = LOWER(NEW.nombre_municipio)
               AND LOWER(BTRIM(h.nombre_parroquia)) = LOWER(NEW.nombre_parroquia)
               AND LOWER(BTRIM(h.nombre_hito))      = LOWER(NEW.nombre_hito)
        ) THEN
            RAISE EXCEPTION 'HU-12 violada: ya existe un hito llamado "%" en la parroquia %, municipio %, %.',
                NEW.nombre_hito, NEW.nombre_parroquia, NEW.nombre_municipio, NEW.nombre_estado;
        END IF;
    END IF;

    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION trg_fn_validar_hito_horario_y_categoria()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_est VARCHAR(100);
    v_mun VARCHAR(100);
    v_par VARCHAR(100);
    v_hit VARCHAR(150);
    v_libre BOOLEAN;
    v_estado_op VARCHAR(30);
BEGIN
    IF TG_TABLE_NAME = 'hito' THEN
        v_est := NEW.nombre_estado;
        v_mun := NEW.nombre_municipio;
        v_par := NEW.nombre_parroquia;
        v_hit := NEW.nombre_hito;
    ELSE
        v_est := OLD.nombre_estado;
        v_mun := OLD.nombre_municipio;
        v_par := OLD.nombre_parroquia;
        v_hit := OLD.nombre_hito;
    END IF;

    SELECT h.libre_acceso, h.estado_operativo
      INTO v_libre, v_estado_op
      FROM hito h
     WHERE h.nombre_estado = v_est
       AND h.nombre_municipio = v_mun
       AND h.nombre_parroquia = v_par
       AND h.nombre_hito = v_hit;

    IF NOT FOUND THEN
        RETURN NULL;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM categoria_hito ch
         WHERE ch.nombre_estado = v_est
           AND ch.nombre_municipio = v_mun
           AND ch.nombre_parroquia = v_par
           AND ch.nombre_hito = v_hit
    ) THEN
        RAISE EXCEPTION 'HU-10 violada: el hito "%" debe tener al menos una categoría asignada en CATEGORIA_HITO.', v_hit;
    END IF;

    IF v_libre = FALSE AND v_estado_op = 'disponible' AND NOT EXISTS (
        SELECT 1 FROM horario_hito hh
         WHERE hh.nombre_estado = v_est
           AND hh.nombre_municipio = v_mun
           AND hh.nombre_parroquia = v_par
           AND hh.nombre_hito = v_hit
    ) THEN
        RAISE EXCEPTION 'HU-14 violada: el hito "%" no es de libre acceso y está disponible, por lo que requiere al menos un horario en HORARIO_HITO.', v_hit;
    END IF;

    RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_hito_coherencia_before ON hito;
CREATE TRIGGER trg_hito_coherencia_before
    BEFORE INSERT OR UPDATE ON hito
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_coherencia_hito_before();

DROP TRIGGER IF EXISTS trg_hito_horario_y_categoria ON hito;
CREATE CONSTRAINT TRIGGER trg_hito_horario_y_categoria
    AFTER INSERT OR UPDATE ON hito
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_validar_hito_horario_y_categoria();

DROP TRIGGER IF EXISTS trg_categoria_hito_minima ON categoria_hito;
CREATE CONSTRAINT TRIGGER trg_categoria_hito_minima
    AFTER DELETE OR UPDATE ON categoria_hito
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_validar_hito_horario_y_categoria();

DROP TRIGGER IF EXISTS trg_horario_hito_coherencia ON horario_hito;
CREATE CONSTRAINT TRIGGER trg_horario_hito_coherencia
    AFTER DELETE OR UPDATE ON horario_hito
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_validar_hito_horario_y_categoria();
