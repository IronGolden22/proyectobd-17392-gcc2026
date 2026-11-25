-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/04_triggers/03_trg_completitud_territorial_rm01_rm02.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Triggers diferibles (DEFERRABLE INITIALLY DEFERRED) para garantizar
--           participación total de ESTADO en MUNICIPIO (RM-01) y de MUNICIPIO
--           en PARROQUIA (RM-02) al cierre de cada transacción (HU-09).
-- ============================================================================

CREATE OR REPLACE FUNCTION trg_fn_validar_rm01_estado_municipio()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_estado VARCHAR(100);
BEGIN
    IF TG_TABLE_NAME = 'estado' THEN
        v_estado := NEW.nombre_estado;
    ELSE
        v_estado := OLD.nombre_estado;
    END IF;

    IF EXISTS (SELECT 1 FROM estado e WHERE e.nombre_estado = v_estado)
       AND NOT EXISTS (SELECT 1 FROM municipio m WHERE m.nombre_estado = v_estado) THEN
        RAISE EXCEPTION 'RM-01 violada: el estado "%" debe poseer al menos un municipio registrado.', v_estado;
    END IF;

    RETURN NULL;
END;
$$;

CREATE OR REPLACE FUNCTION trg_fn_validar_rm02_municipio_parroquia()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_estado    VARCHAR(100);
    v_municipio VARCHAR(100);
BEGIN
    IF TG_TABLE_NAME = 'municipio' THEN
        v_estado    := NEW.nombre_estado;
        v_municipio := NEW.nombre_municipio;
    ELSE
        v_estado    := OLD.nombre_estado;
        v_municipio := OLD.nombre_municipio;
    END IF;

    IF EXISTS (
        SELECT 1 FROM municipio m
         WHERE m.nombre_estado = v_estado
           AND m.nombre_municipio = v_municipio
    ) AND NOT EXISTS (
        SELECT 1 FROM parroquia p
         WHERE p.nombre_estado = v_estado
           AND p.nombre_municipio = v_municipio
    ) THEN
        RAISE EXCEPTION 'RM-02 violada: el municipio "%, %" debe poseer al menos una parroquia registrada.', v_municipio, v_estado;
    END IF;

    RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_rm01_estado_posee_municipio ON estado;
CREATE CONSTRAINT TRIGGER trg_rm01_estado_posee_municipio
    AFTER INSERT OR UPDATE ON estado
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_validar_rm01_estado_municipio();

DROP TRIGGER IF EXISTS trg_rm01_municipio_minimo ON municipio;
CREATE CONSTRAINT TRIGGER trg_rm01_municipio_minimo
    AFTER DELETE OR UPDATE OF nombre_estado ON municipio
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_validar_rm01_estado_municipio();

DROP TRIGGER IF EXISTS trg_rm02_municipio_posee_parroquia ON municipio;
CREATE CONSTRAINT TRIGGER trg_rm02_municipio_posee_parroquia
    AFTER INSERT OR UPDATE ON municipio
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_validar_rm02_municipio_parroquia();

DROP TRIGGER IF EXISTS trg_rm02_parroquia_minima ON parroquia;
CREATE CONSTRAINT TRIGGER trg_rm02_parroquia_minima
    AFTER DELETE OR UPDATE OF nombre_estado, nombre_municipio ON parroquia
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_validar_rm02_municipio_parroquia();
