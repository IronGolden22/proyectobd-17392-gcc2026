-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/05_procedures/05_sp_gestionar_estado_cuenta.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Activación, suspensión o bloqueo de cuentas de usuario por el
--           administrador del sistema (HU-07).
-- ============================================================================

CREATE OR REPLACE PROCEDURE sp_cambiar_estado_cuenta_usuario(
    p_tipo_actor    VARCHAR,
    p_identificador VARCHAR,
    p_nuevo_estado  VARCHAR,
    p_cod_licencia  VARCHAR DEFAULT NULL,
    p_motivo        TEXT    DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_tipo     VARCHAR := UPPER(BTRIM(p_tipo_actor));
    v_id       VARCHAR := UPPER(BTRIM(p_identificador));
    v_lic      VARCHAR := NULLIF(UPPER(BTRIM(p_cod_licencia)), '');
    v_estado   VARCHAR := LOWER(BTRIM(p_nuevo_estado));
    v_role     TEXT    := LOWER(BTRIM(p_identificador));
BEGIN
    IF v_estado NOT IN ('activa', 'suspendida', 'bloqueada') THEN
        RAISE EXCEPTION 'Estado de cuenta inválido: "%". Valores permitidos: activa, suspendida, bloqueada.', p_nuevo_estado;
    END IF;

    IF v_tipo = 'VISITANTE' THEN
        UPDATE visitante
           SET estado_cuenta = v_estado
         WHERE cedula_pasaporte = v_id;
    ELSIF v_tipo = 'GUIA_TURISTICO' THEN
        IF v_lic IS NULL THEN
            RAISE EXCEPTION 'Para GUIA_TURISTICO debe suministrar p_cod_licencia.';
        END IF;
        UPDATE guia_turistico
           SET estado_cuenta = v_estado
         WHERE nro_rtn = v_id AND cod_licencia = v_lic;
    ELSIF v_tipo = 'COMERCIO_ALIADO' THEN
        UPDATE comercio_aliado
           SET estado_cuenta = v_estado
         WHERE rif = v_id;
    ELSIF v_tipo = 'ENTE_PUBLICO' THEN
        UPDATE ente_publico
           SET estado_cuenta = v_estado
         WHERE rif_gubernamental = v_id;
    ELSE
        RAISE EXCEPTION 'Tipo de actor inválido: "%". Use VISITANTE, GUIA_TURISTICO, COMERCIO_ALIADO o ENTE_PUBLICO.', p_tipo_actor;
    END IF;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'No se encontró la cuenta % con identificador %.', v_tipo, v_id;
    END IF;

    -- Sincroniza privilegio LOGIN/NOLOGIN si existiera un rol de PostgreSQL homónimo
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = v_role) THEN
        EXECUTE format(
            'ALTER ROLE %I %s',
            v_role,
            CASE WHEN v_estado = 'activa' THEN 'LOGIN' ELSE 'NOLOGIN' END
        );
    END IF;

    RAISE NOTICE 'Cuenta % (%) actualizada a estado "%". Motivo: %',
        v_tipo, v_id, v_estado, COALESCE(NULLIF(BTRIM(p_motivo), ''), 'No especificado');
END;
$$;
