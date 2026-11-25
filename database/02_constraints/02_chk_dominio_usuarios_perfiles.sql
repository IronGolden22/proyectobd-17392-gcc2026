-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/02_constraints/02_chk_dominio_usuarios_perfiles.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Restricciones de dominio y unicidad para actores y perfiles
--           (HU-01 a HU-08, RE-14, RE-15, RE-16).
-- ============================================================================

-- Visitante (HU-01, HU-02, HU-07, HU-08)
ALTER TABLE visitante
    ADD CONSTRAINT chk_visitante_campos_no_vacios
        CHECK (
            BTRIM(cedula_pasaporte) <> '' AND
            BTRIM(contrasena) <> '' AND
            BTRIM(nombres) <> '' AND
            BTRIM(apellidos) <> '' AND
            BTRIM(pais_origen) <> '' AND
            BTRIM(idioma_nativo) <> '' AND
            BTRIM(telefono_emergencia) <> ''
        ),
    ADD CONSTRAINT chk_visitante_grupo_sanguineo
        CHECK (grupo_sanguineo IN ('O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-')),
    ADD CONSTRAINT chk_visitante_estado_cuenta
        CHECK (estado_cuenta IN ('activa', 'suspendida', 'bloqueada')),
    ADD CONSTRAINT chk_visitante_formato_correo
        CHECK (correo_contacto IS NULL OR correo_contacto ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
    ADD CONSTRAINT uq_visitante_correo_contacto
        UNIQUE (correo_contacto);

ALTER TABLE accesibilidad_visitante
    ADD CONSTRAINT chk_accesibilidad_no_vacia
        CHECK (BTRIM(req_accesibilidad) <> '');

-- Guía Turístico (HU-03, HU-04, HU-07, HU-08, RE-14)
ALTER TABLE guia_turistico
    ADD CONSTRAINT chk_guia_campos_no_vacios
        CHECK (
            BTRIM(nro_rtn) <> '' AND
            BTRIM(cod_licencia) <> '' AND
            BTRIM(contrasena) <> '' AND
            BTRIM(nombres) <> '' AND
            BTRIM(apellidos) <> '' AND
            BTRIM(acreditacion_oficial) <> ''
        ),
    ADD CONSTRAINT chk_guia_trayectoria_tarifa
        CHECK (anos_trayectoria >= 0 AND tarifa_horaria >= 0),
    ADD CONSTRAINT chk_guia_estado_cuenta
        CHECK (estado_cuenta IN ('activa', 'suspendida', 'bloqueada')),
    ADD CONSTRAINT chk_guia_formato_correo
        CHECK (correo_contacto IS NULL OR correo_contacto ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
    ADD CONSTRAINT uq_guia_correo_contacto
        UNIQUE (correo_contacto);

ALTER TABLE especialidad_guia
    ADD CONSTRAINT chk_especialidad_guia_no_vacia
        CHECK (BTRIM(especialidades) <> '');

ALTER TABLE idioma_guia
    ADD CONSTRAINT chk_idioma_guia_no_vacio
        CHECK (BTRIM(idiomas_dominados) <> '');

-- Comercio Aliado (HU-05, HU-07, HU-08, RE-15)
ALTER TABLE comercio_aliado
    ADD CONSTRAINT chk_comercio_campos_no_vacios
        CHECK (
            BTRIM(rif) <> '' AND
            BTRIM(contrasena) <> '' AND
            BTRIM(razon_social) <> '' AND
            BTRIM(categoria_comercial) <> '' AND
            BTRIM(permiso_sanitario) <> '' AND
            BTRIM(cuenta_bancaria) <> '' AND
            BTRIM(horario_comercial) <> ''
        ),
    ADD CONSTRAINT chk_comercio_formato_rif
        CHECK (rif ~ '^[JVEGP]-[0-9]{8}-[0-9]$'),
    ADD CONSTRAINT chk_comercio_aforo_positivo
        CHECK (aforo_max > 0),
    ADD CONSTRAINT chk_comercio_estado_cuenta
        CHECK (estado_cuenta IN ('activa', 'suspendida', 'bloqueada')),
    ADD CONSTRAINT chk_comercio_formato_correo
        CHECK (correo_contacto IS NULL OR correo_contacto ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
    ADD CONSTRAINT uq_comercio_razon_social
        UNIQUE (razon_social),
    ADD CONSTRAINT uq_comercio_correo_contacto
        UNIQUE (correo_contacto);

-- Ente Público (HU-06, HU-07, HU-08, RE-16)
ALTER TABLE ente_publico
    ADD CONSTRAINT chk_ente_campos_no_vacios
        CHECK (
            BTRIM(rif_gubernamental) <> '' AND
            BTRIM(contrasena) <> '' AND
            BTRIM(denominacion_oficial) <> '' AND
            BTRIM(funcionario_enlace) <> '' AND
            BTRIM(decreto_adscripcion) <> ''
        ),
    ADD CONSTRAINT chk_ente_formato_rif
        CHECK (rif_gubernamental ~ '^G-[0-9]{8}-[0-9]$'),
    ADD CONSTRAINT chk_ente_nivel_competencia
        CHECK (nivel_competencia IN ('nacional', 'estadal', 'municipal')),
    ADD CONSTRAINT chk_ente_estado_cuenta
        CHECK (estado_cuenta IN ('activa', 'suspendida', 'bloqueada')),
    ADD CONSTRAINT chk_ente_formato_correo
        CHECK (correo_contacto IS NULL OR correo_contacto ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
    ADD CONSTRAINT uq_ente_denominacion_oficial
        UNIQUE (denominacion_oficial),
    ADD CONSTRAINT uq_ente_correo_contacto
        UNIQUE (correo_contacto);
