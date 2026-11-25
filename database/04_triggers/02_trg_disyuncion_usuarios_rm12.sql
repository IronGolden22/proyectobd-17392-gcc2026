-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/04_triggers/02_trg_disyuncion_usuarios_rm12.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Disyunción de claves naturales entre las subclases de USUARIO
--           (RM-12: Visitante, Guía Turístico, Comercio Aliado y Ente Público).
-- ============================================================================

CREATE OR REPLACE FUNCTION trg_fn_validar_disyuncion_usuarios()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_principal VARCHAR;
BEGIN
    IF TG_TABLE_NAME = 'visitante' THEN
        v_id_principal := UPPER(BTRIM(NEW.cedula_pasaporte));
        IF EXISTS (SELECT 1 FROM comercio_aliado WHERE UPPER(BTRIM(rif)) = v_id_principal)
           OR EXISTS (SELECT 1 FROM ente_publico WHERE UPPER(BTRIM(rif_gubernamental)) = v_id_principal)
           OR EXISTS (SELECT 1 FROM guia_turistico WHERE UPPER(BTRIM(nro_rtn)) = v_id_principal) THEN
            RAISE EXCEPTION 'RM-12 violada: el identificador % ya pertenece a otro perfil de usuario incompatible.', v_id_principal;
        END IF;

    ELSIF TG_TABLE_NAME = 'guia_turistico' THEN
        v_id_principal := UPPER(BTRIM(NEW.nro_rtn));
        IF EXISTS (SELECT 1 FROM visitante WHERE UPPER(BTRIM(cedula_pasaporte)) = v_id_principal)
           OR EXISTS (SELECT 1 FROM comercio_aliado WHERE UPPER(BTRIM(rif)) = v_id_principal)
           OR EXISTS (SELECT 1 FROM ente_publico WHERE UPPER(BTRIM(rif_gubernamental)) = v_id_principal) THEN
            RAISE EXCEPTION 'RM-12 violada: el RTN % colisiona con un perfil de usuario incompatible.', v_id_principal;
        END IF;

    ELSIF TG_TABLE_NAME = 'comercio_aliado' THEN
        v_id_principal := UPPER(BTRIM(NEW.rif));
        IF EXISTS (SELECT 1 FROM visitante WHERE UPPER(BTRIM(cedula_pasaporte)) = v_id_principal)
           OR EXISTS (SELECT 1 FROM ente_publico WHERE UPPER(BTRIM(rif_gubernamental)) = v_id_principal)
           OR EXISTS (SELECT 1 FROM guia_turistico WHERE UPPER(BTRIM(nro_rtn)) = v_id_principal) THEN
            RAISE EXCEPTION 'RM-12 violada: el RIF % ya pertenece a otro perfil de usuario incompatible.', v_id_principal;
        END IF;

    ELSIF TG_TABLE_NAME = 'ente_publico' THEN
        v_id_principal := UPPER(BTRIM(NEW.rif_gubernamental));
        IF EXISTS (SELECT 1 FROM visitante WHERE UPPER(BTRIM(cedula_pasaporte)) = v_id_principal)
           OR EXISTS (SELECT 1 FROM comercio_aliado WHERE UPPER(BTRIM(rif)) = v_id_principal)
           OR EXISTS (SELECT 1 FROM guia_turistico WHERE UPPER(BTRIM(nro_rtn)) = v_id_principal) THEN
            RAISE EXCEPTION 'RM-12 violada: el RIF gubernamental % ya pertenece a otro perfil de usuario incompatible.', v_id_principal;
        END IF;
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_rm12_disyuncion_visitante ON visitante;
CREATE TRIGGER trg_rm12_disyuncion_visitante
    BEFORE INSERT OR UPDATE ON visitante
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_validar_disyuncion_usuarios();

DROP TRIGGER IF EXISTS trg_rm12_disyuncion_guia ON guia_turistico;
CREATE TRIGGER trg_rm12_disyuncion_guia
    BEFORE INSERT OR UPDATE ON guia_turistico
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_validar_disyuncion_usuarios();

DROP TRIGGER IF EXISTS trg_rm12_disyuncion_comercio ON comercio_aliado;
CREATE TRIGGER trg_rm12_disyuncion_comercio
    BEFORE INSERT OR UPDATE ON comercio_aliado
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_validar_disyuncion_usuarios();

DROP TRIGGER IF EXISTS trg_rm12_disyuncion_ente ON ente_publico;
CREATE TRIGGER trg_rm12_disyuncion_ente
    BEFORE INSERT OR UPDATE ON ente_publico
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_validar_disyuncion_usuarios();
