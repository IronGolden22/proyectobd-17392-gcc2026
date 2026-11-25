-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/05_procedures/03_sp_registrar_comercio_aliado.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Registro de comercio aliado con RIF jurídico y razón social única
--           (HU-05, RE-15).
-- ============================================================================

CREATE OR REPLACE PROCEDURE sp_registrar_comercio_aliado(
    p_rif                 VARCHAR,
    p_contrasena          TEXT,
    p_razon_social        VARCHAR,
    p_categoria_comercial VARCHAR,
    p_aforo_max           INTEGER,
    p_permiso_sanitario   VARCHAR,
    p_cuenta_bancaria     VARCHAR,
    p_horario_comercial   VARCHAR,
    p_correo_contacto     VARCHAR DEFAULT NULL,
    p_telefono_contacto   VARCHAR DEFAULT NULL,
    p_telefono_emergencia VARCHAR DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO comercio_aliado (
        rif,
        contrasena,
        razon_social,
        categoria_comercial,
        aforo_max,
        permiso_sanitario,
        cuenta_bancaria,
        horario_comercial,
        correo_contacto,
        telefono_contacto,
        telefono_emergencia,
        estado_cuenta
    ) VALUES (
        UPPER(BTRIM(p_rif)),
        p_contrasena,
        p_razon_social,
        p_categoria_comercial,
        p_aforo_max,
        p_permiso_sanitario,
        p_cuenta_bancaria,
        p_horario_comercial,
        p_correo_contacto,
        p_telefono_contacto,
        p_telefono_emergencia,
        'activa'
    );
END;
$$;
