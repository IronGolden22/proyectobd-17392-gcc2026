-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/01_schema/03_usuarios_operacion.sql
-- Autor:    Gabriel López (C.I. 30.821.466) - Subsistema de Usuarios/Perfiles
--           (HU-01 a HU-08) y estructura base de operación turística.
-- Alcance:  Subsistema 2.3 - Actores, Experiencias, Visitas, Evaluaciones,
--           Credenciales de Acceso e Incidencias.
-- ============================================================================

-- Tablas de Actores y Perfiles (HU-01 a HU-08 - Gabriel López)
CREATE TABLE visitante (
    cedula_pasaporte    VARCHAR(30)  PRIMARY KEY,
    contrasena          VARCHAR(255) NOT NULL,
    nombres             VARCHAR(100) NOT NULL,
    apellidos           VARCHAR(100) NOT NULL,
    pais_origen         VARCHAR(80)  NOT NULL,
    idioma_nativo       VARCHAR(50)  NOT NULL,
    telefono_emergencia VARCHAR(30)  NOT NULL,
    grupo_sanguineo     VARCHAR(5)   NOT NULL,
    correo_contacto     VARCHAR(150) NULL,
    telefono_contacto   VARCHAR(30)  NULL,
    estado_cuenta       VARCHAR(20)  NOT NULL DEFAULT 'activa'
);

CREATE TABLE accesibilidad_visitante (
    cedula_pasaporte  VARCHAR(30)  NOT NULL,
    req_accesibilidad VARCHAR(100) NOT NULL,
    PRIMARY KEY (cedula_pasaporte, req_accesibilidad)
);

CREATE TABLE guia_turistico (
    nro_rtn               VARCHAR(30)   NOT NULL,
    cod_licencia          VARCHAR(30)   NOT NULL,
    contrasena            VARCHAR(255)  NOT NULL,
    nombres               VARCHAR(100)  NOT NULL,
    apellidos             VARCHAR(100)  NOT NULL,
    acreditacion_oficial  VARCHAR(150)  NOT NULL,
    anos_trayectoria      INTEGER       NOT NULL,
    tarifa_horaria        NUMERIC(12,2) NOT NULL,
    nombre_estado_zona    VARCHAR(100)  NOT NULL,
    nombre_municipio_zona VARCHAR(100)  NOT NULL,
    correo_contacto       VARCHAR(150)  NULL,
    telefono_contacto     VARCHAR(30)   NULL,
    telefono_emergencia   VARCHAR(30)   NULL,
    estado_cuenta         VARCHAR(20)   NOT NULL DEFAULT 'activa',
    PRIMARY KEY (nro_rtn, cod_licencia)
);

CREATE TABLE especialidad_guia (
    nro_rtn        VARCHAR(30)  NOT NULL,
    cod_licencia   VARCHAR(30)  NOT NULL,
    especialidades VARCHAR(100) NOT NULL,
    PRIMARY KEY (nro_rtn, cod_licencia, especialidades)
);

CREATE TABLE idioma_guia (
    nro_rtn           VARCHAR(30) NOT NULL,
    cod_licencia      VARCHAR(30) NOT NULL,
    idiomas_dominados VARCHAR(50) NOT NULL,
    PRIMARY KEY (nro_rtn, cod_licencia, idiomas_dominados)
);

CREATE TABLE acompana_ruta (
    nro_rtn                 VARCHAR(30)  NOT NULL,
    cod_licencia            VARCHAR(30)  NOT NULL,
    nombre_estado_origen    VARCHAR(100) NOT NULL,
    nombre_municipio_origen VARCHAR(100) NOT NULL,
    nombre_ruta             VARCHAR(150) NOT NULL,
    PRIMARY KEY (nro_rtn, cod_licencia, nombre_estado_origen, nombre_municipio_origen, nombre_ruta)
);

CREATE TABLE comercio_aliado (
    rif                 VARCHAR(20)  PRIMARY KEY,
    contrasena          VARCHAR(255) NOT NULL,
    razon_social        VARCHAR(180) NOT NULL,
    categoria_comercial VARCHAR(60)  NOT NULL,
    aforo_max           INTEGER      NOT NULL,
    permiso_sanitario   VARCHAR(60)  NOT NULL,
    cuenta_bancaria     VARCHAR(30)  NOT NULL,
    horario_comercial   VARCHAR(120) NOT NULL,
    correo_contacto     VARCHAR(150) NULL,
    telefono_contacto   VARCHAR(30)  NULL,
    telefono_emergencia VARCHAR(30)  NULL,
    estado_cuenta       VARCHAR(20)  NOT NULL DEFAULT 'activa'
);

CREATE TABLE ente_publico (
    rif_gubernamental    VARCHAR(20)  PRIMARY KEY,
    contrasena           VARCHAR(255) NOT NULL,
    denominacion_oficial VARCHAR(180) NOT NULL,
    nivel_competencia    VARCHAR(20)  NOT NULL,
    funcionario_enlace   VARCHAR(120) NOT NULL,
    decreto_adscripcion  VARCHAR(120) NOT NULL,
    correo_contacto      VARCHAR(150) NULL,
    telefono_contacto    VARCHAR(30)  NULL,
    telefono_emergencia  VARCHAR(30)  NULL,
    estado_cuenta        VARCHAR(20)  NOT NULL DEFAULT 'activa'
);

-- Tablas de Operación Turística (estructura base unificada para el equipo)
CREATE TABLE experiencia_promocional (
    titulo_experiencia      VARCHAR(150)  NOT NULL,
    fecha_activacion        DATE          NOT NULL,
    descripcion_detallada   TEXT          NOT NULL,
    precio_total            NUMERIC(12,2) NOT NULL,
    cupo_max_grupo          INTEGER       NOT NULL,
    porcentaje_descuento    NUMERIC(5,2)  NOT NULL DEFAULT 0,
    fecha_vencimiento       DATE          NOT NULL,
    codigo_promocional      VARCHAR(40)   NULL,
    rif_comercio            VARCHAR(20)   NOT NULL,
    nro_rtn_guia            VARCHAR(30)   NOT NULL,
    cod_licencia_guia       VARCHAR(30)   NOT NULL,
    nombre_estado_origen    VARCHAR(100)  NOT NULL,
    nombre_municipio_origen VARCHAR(100)  NOT NULL,
    nombre_ruta             VARCHAR(150)  NOT NULL,
    PRIMARY KEY (titulo_experiencia, fecha_activacion)
);

CREATE TABLE experiencia_incluye_hito (
    titulo_experiencia VARCHAR(150) NOT NULL,
    fecha_activacion   DATE         NOT NULL,
    nombre_estado      VARCHAR(100) NOT NULL,
    nombre_municipio   VARCHAR(100) NOT NULL,
    nombre_parroquia   VARCHAR(100) NOT NULL,
    nombre_hito        VARCHAR(150) NOT NULL,
    PRIMARY KEY (titulo_experiencia, fecha_activacion, nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
);

CREATE TABLE visita_hito (
    cedula_pasaporte  VARCHAR(30)  NOT NULL,
    nombre_estado     VARCHAR(100) NOT NULL,
    nombre_municipio  VARCHAR(100) NOT NULL,
    nombre_parroquia  VARCHAR(100) NOT NULL,
    nombre_hito       VARCHAR(150) NOT NULL,
    fecha_hora_visita TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (cedula_pasaporte, nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
);

CREATE TABLE recorrido_realizado (
    cedula_pasaporte        VARCHAR(30)  NOT NULL,
    fecha_hora_inicio       TIMESTAMP    NOT NULL,
    fecha_hora_fin          TIMESTAMP    NULL,
    completado              BOOLEAN      NOT NULL DEFAULT FALSE,
    nombre_estado_origen    VARCHAR(100) NOT NULL,
    nombre_municipio_origen VARCHAR(100) NOT NULL,
    nombre_ruta             VARCHAR(150) NOT NULL,
    PRIMARY KEY (cedula_pasaporte, fecha_hora_inicio)
);

CREATE TABLE evaluacion_experiencia (
    codigo_resena         VARCHAR(50)  PRIMARY KEY,
    calif_estrellas       INTEGER      NOT NULL,
    indice_seguridad      INTEGER      NOT NULL,
    fecha_emision         TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    opinion_detallada     TEXT         NOT NULL,
    cedula_pasaporte      VARCHAR(30)  NOT NULL,
    fecha_hora_inicio_rec TIMESTAMP    NULL,
    nombre_estado_hito    VARCHAR(100) NULL,
    nombre_municipio_hito VARCHAR(100) NULL,
    nombre_parroquia_hito VARCHAR(100) NULL,
    nombre_hito           VARCHAR(150) NULL
);

CREATE TABLE credencial_acceso (
    codigo_verificacion    VARCHAR(50)   PRIMARY KEY,
    fecha_hora_programada  TIMESTAMP     NOT NULL,
    monto_abonado          NUMERIC(12,2) NOT NULL,
    cantidad_beneficiarios INTEGER       NOT NULL,
    estado_pase            VARCHAR(20)   NOT NULL,
    cedula_pasaporte       VARCHAR(30)   NOT NULL,
    titulo_experiencia     VARCHAR(150)  NULL,
    fecha_activacion       DATE          NULL
);

CREATE TABLE reporte_incidencia (
    nro_reporte              SERIAL       PRIMARY KEY,
    fecha_hora_deteccion     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_est_resolucion     TIMESTAMP    NOT NULL,
    prorroga_justificada     TEXT         NULL,
    narrativa_evento         TEXT         NOT NULL,
    estado_reporte           VARCHAR(20)  NOT NULL,
    nivel_severidad          VARCHAR(20)  NOT NULL,
    cedula_pasaporte_reporta VARCHAR(30)  NULL,
    nro_rtn_reporta          VARCHAR(30)  NULL,
    cod_licencia_reporta     VARCHAR(30)  NULL,
    rif_gub_reporta          VARCHAR(20)  NULL,
    rif_gub_validador        VARCHAR(20)  NULL,
    codigo_via_afectada      VARCHAR(50)  NULL,
    nombre_estado_hito       VARCHAR(100) NULL,
    nombre_municipio_hito    VARCHAR(100) NULL,
    nombre_parroquia_hito    VARCHAR(100) NULL,
    nombre_hito_afectado     VARCHAR(150) NULL
);
