-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/04_triggers/04_trg_guia_acompana_ruta_rm13.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Trigger diferible (DEFERRABLE INITIALLY DEFERRED) que garantiza que
--           todo guía turístico cuente con al menos una ruta asignada en
--           ACOMPANA_RUTA (RM-13, HU-03, HU-04).
-- ============================================================================

CREATE OR REPLACE FUNCTION trg_fn_validar_rm13_guia_ruta()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_rtn VARCHAR(30);
    v_lic VARCHAR(30);
BEGIN
    IF TG_TABLE_NAME = 'guia_turistico' THEN
        v_rtn := NEW.nro_rtn;
        v_lic := NEW.cod_licencia;
    ELSE
        v_rtn := OLD.nro_rtn;
        v_lic := OLD.cod_licencia;
    END IF;

    IF EXISTS (
        SELECT 1 FROM guia_turistico g
         WHERE g.nro_rtn = v_rtn AND g.cod_licencia = v_lic
    ) AND NOT EXISTS (
        SELECT 1 FROM acompana_ruta ar
         WHERE ar.nro_rtn = v_rtn AND ar.cod_licencia = v_lic
    ) THEN
        RAISE EXCEPTION 'RM-13 violada: el guía (RTN %, Licencia %) debe tener al menos una ruta asignada en ACOMPANA_RUTA.', v_rtn, v_lic;
    END IF;

    RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_rm13_guia_tiene_ruta ON guia_turistico;
CREATE CONSTRAINT TRIGGER trg_rm13_guia_tiene_ruta
    AFTER INSERT OR UPDATE ON guia_turistico
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_validar_rm13_guia_ruta();

DROP TRIGGER IF EXISTS trg_rm13_acompana_ruta_minimo ON acompana_ruta;
CREATE CONSTRAINT TRIGGER trg_rm13_acompana_ruta_minimo
    AFTER DELETE OR UPDATE OF nro_rtn, cod_licencia ON acompana_ruta
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_validar_rm13_guia_ruta();
