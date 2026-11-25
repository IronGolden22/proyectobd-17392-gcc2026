-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/04_triggers/01_trg_normalizar_y_hash_usuarios.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Normalización de identificadores/correos, hashing automático SHA-256
--           de contraseñas y protección contra edición de cuentas bloqueadas
--           (HU-01, HU-03, HU-05, HU-06, HU-07, HU-08).
-- ============================================================================

CREATE OR REPLACE FUNCTION trg_fn_preparar_registro_usuario()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Normalización de correo electrónico en las 4 subclases
    NEW.correo_contacto := NULLIF(LOWER(BTRIM(NEW.correo_contacto)), '');
    NEW.telefono_contacto := NULLIF(BTRIM(NEW.telefono_contacto), '');

    -- Normalización de claves naturales según la tabla origen
    IF TG_TABLE_NAME = 'visitante' THEN
        NEW.cedula_pasaporte := UPPER(BTRIM(NEW.cedula_pasaporte));
        NEW.nombres := BTRIM(NEW.nombres);
        NEW.apellidos := BTRIM(NEW.apellidos);
        NEW.pais_origen := BTRIM(NEW.pais_origen);
        NEW.idioma_nativo := BTRIM(NEW.idioma_nativo);
        NEW.telefono_emergencia := BTRIM(NEW.telefono_emergencia);
        NEW.grupo_sanguineo := UPPER(BTRIM(NEW.grupo_sanguineo));
    ELSIF TG_TABLE_NAME = 'guia_turistico' THEN
        NEW.nro_rtn := UPPER(BTRIM(NEW.nro_rtn));
        NEW.cod_licencia := UPPER(BTRIM(NEW.cod_licencia));
        NEW.nombres := BTRIM(NEW.nombres);
        NEW.apellidos := BTRIM(NEW.apellidos);
        NEW.acreditacion_oficial := BTRIM(NEW.acreditacion_oficial);
        NEW.nombre_estado_zona := BTRIM(NEW.nombre_estado_zona);
        NEW.nombre_municipio_zona := BTRIM(NEW.nombre_municipio_zona);
        NEW.telefono_emergencia := NULLIF(BTRIM(NEW.telefono_emergencia), '');
    ELSIF TG_TABLE_NAME = 'comercio_aliado' THEN
        NEW.rif := UPPER(BTRIM(NEW.rif));
        NEW.razon_social := BTRIM(NEW.razon_social);
        NEW.categoria_comercial := BTRIM(NEW.categoria_comercial);
        NEW.permiso_sanitario := BTRIM(NEW.permiso_sanitario);
        NEW.cuenta_bancaria := BTRIM(NEW.cuenta_bancaria);
        NEW.horario_comercial := BTRIM(NEW.horario_comercial);
        NEW.telefono_emergencia := NULLIF(BTRIM(NEW.telefono_emergencia), '');
    ELSIF TG_TABLE_NAME = 'ente_publico' THEN
        NEW.rif_gubernamental := UPPER(BTRIM(NEW.rif_gubernamental));
        NEW.denominacion_oficial := BTRIM(NEW.denominacion_oficial);
        NEW.nivel_competencia := LOWER(BTRIM(NEW.nivel_competencia));
        NEW.funcionario_enlace := BTRIM(NEW.funcionario_enlace);
        NEW.decreto_adscripcion := BTRIM(NEW.decreto_adscripcion);
        NEW.telefono_emergencia := NULLIF(BTRIM(NEW.telefono_emergencia), '');
    END IF;

    -- HU-07 / HU-08: Una cuenta bloqueada no puede modificar su perfil salvo cambio explícito de estado_cuenta
    IF TG_OP = 'UPDATE' THEN
        IF OLD.estado_cuenta = 'bloqueada' AND NEW.estado_cuenta = OLD.estado_cuenta THEN
            RAISE EXCEPTION 'No se puede actualizar el perfil de una cuenta en estado bloqueada (HU-07/HU-08).';
        END IF;
    END IF;

    -- Hashing automático SHA-256 (evita doble hash en UPDATE si ya tiene formato hexadecimal de 64 chars)
    IF TG_OP = 'INSERT' OR NEW.contrasena IS DISTINCT FROM OLD.contrasena THEN
        IF NEW.contrasena !~ '^[0-9a-f]{64}$' THEN
            IF char_length(BTRIM(NEW.contrasena)) < 8 THEN
                RAISE EXCEPTION 'La contraseña debe tener al menos 8 caracteres.';
            END IF;
            NEW.contrasena := fn_hash_contrasena(NEW.contrasena);
        END IF;
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_visitante_preparar ON visitante;
CREATE TRIGGER trg_visitante_preparar
    BEFORE INSERT OR UPDATE ON visitante
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_preparar_registro_usuario();

DROP TRIGGER IF EXISTS trg_guia_preparar ON guia_turistico;
CREATE TRIGGER trg_guia_preparar
    BEFORE INSERT OR UPDATE ON guia_turistico
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_preparar_registro_usuario();

DROP TRIGGER IF EXISTS trg_comercio_preparar ON comercio_aliado;
CREATE TRIGGER trg_comercio_preparar
    BEFORE INSERT OR UPDATE ON comercio_aliado
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_preparar_registro_usuario();

DROP TRIGGER IF EXISTS trg_ente_preparar ON ente_publico;
CREATE TRIGGER trg_ente_preparar
    BEFORE INSERT OR UPDATE ON ente_publico
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_preparar_registro_usuario();
