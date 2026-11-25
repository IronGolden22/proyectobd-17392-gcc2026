-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/05_procedures/04_sp_registrar_ente_publico.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Registro de ente público o fundación patrimonial con RIF
--           gubernamental y denominación oficial única (HU-06, RE-16).
-- ============================================================================

CREATE OR REPLACE PROCEDURE sp_registrar_ente_publico(
    p_rif_gubernamental    VARCHAR,
    p_contrasena           TEXT,
    p_denominacion_oficial VARCHAR,
    p_nivel_competencia    VARCHAR,
    p_funcionario_enlace   VARCHAR,
    p_decreto_adscripcion  VARCHAR,
    p_correo_contacto      VARCHAR DEFAULT NULL,
    p_telefono_contacto    VARCHAR DEFAULT NULL,
    p_telefono_emergencia  VARCHAR DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO ente_publico (
        rif_gubernamental,
        contrasena,
        denominacion_oficial,
        nivel_competencia,
        funcionario_enlace,
        decreto_adscripcion,
        correo_contacto,
        telefono_contacto,
        telefono_emergencia,
        estado_cuenta
    ) VALUES (
        UPPER(BTRIM(p_rif_gubernamental)),
        p_contrasena,
        p_denominacion_oficial,
        p_nivel_competencia,
        p_funcionario_enlace,
        p_decreto_adscripcion,
        p_correo_contacto,
        p_telefono_contacto,
        p_telefono_emergencia,
        'activa'
    );
END;
$$;
