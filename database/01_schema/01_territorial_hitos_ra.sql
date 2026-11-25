-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/01_schema/01_territorial_hitos_ra.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Subsistema 2.1 - División Político-Territorial, Hitos y RA
--           (Historias de Usuario HU-09 a HU-14).
-- Nota:     Las coordenadas 3D emplean tipos numéricos decimales primitivos
--           sin extensiones espaciales, cumpliendo el enunciado del curso.
-- ============================================================================

CREATE TABLE estado (
    nombre_estado VARCHAR(100) PRIMARY KEY
);

CREATE TABLE municipio (
    nombre_estado    VARCHAR(100) NOT NULL,
    nombre_municipio VARCHAR(100) NOT NULL,
    PRIMARY KEY (nombre_estado, nombre_municipio)
);

CREATE TABLE parroquia (
    nombre_estado    VARCHAR(100) NOT NULL,
    nombre_municipio VARCHAR(100) NOT NULL,
    nombre_parroquia VARCHAR(100) NOT NULL,
    PRIMARY KEY (nombre_estado, nombre_municipio, nombre_parroquia)
);

CREATE TABLE hito (
    nombre_estado    VARCHAR(100)  NOT NULL,
    nombre_municipio VARCHAR(100)  NOT NULL,
    nombre_parroquia VARCHAR(100)  NOT NULL,
    nombre_hito      VARCHAR(150)  NOT NULL,
    latitud          NUMERIC(9,6)  NOT NULL,
    longitud         NUMERIC(9,6)  NOT NULL,
    altitud_msnm     NUMERIC(8,2)  NOT NULL,
    estado_operativo VARCHAR(30)   NOT NULL,
    libre_acceso     BOOLEAN       NOT NULL DEFAULT TRUE,
    historia         TEXT          NOT NULL,
    PRIMARY KEY (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
);

CREATE TABLE categoria_hito (
    nombre_estado    VARCHAR(100) NOT NULL,
    nombre_municipio VARCHAR(100) NOT NULL,
    nombre_parroquia VARCHAR(100) NOT NULL,
    nombre_hito      VARCHAR(150) NOT NULL,
    categoria_hito   VARCHAR(30)  NOT NULL,
    PRIMARY KEY (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, categoria_hito)
);

CREATE TABLE horario_hito (
    nombre_estado    VARCHAR(100) NOT NULL,
    nombre_municipio VARCHAR(100) NOT NULL,
    nombre_parroquia VARCHAR(100) NOT NULL,
    nombre_hito      VARCHAR(150) NOT NULL,
    horario_visita   VARCHAR(120) NOT NULL,
    PRIMARY KEY (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, horario_visita)
);

CREATE TABLE cronograma_evento_hito (
    nombre_estado      VARCHAR(100) NOT NULL,
    nombre_municipio   VARCHAR(100) NOT NULL,
    nombre_parroquia   VARCHAR(100) NOT NULL,
    nombre_hito        VARCHAR(150) NOT NULL,
    cronograma_eventos VARCHAR(250) NOT NULL,
    PRIMARY KEY (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, cronograma_eventos)
);

CREATE TABLE punto_anclaje_ra (
    nombre_estado      VARCHAR(100)  NOT NULL,
    nombre_municipio   VARCHAR(100)  NOT NULL,
    nombre_parroquia   VARCHAR(100)  NOT NULL,
    nombre_hito        VARCHAR(150)  NOT NULL,
    codigo_recurso_3d  VARCHAR(80)   NOT NULL,
    latitud_ra         NUMERIC(9,6)  NOT NULL,
    longitud_ra        NUMERIC(9,6)  NOT NULL,
    altitud_suelo      NUMERIC(8,2)  NOT NULL,
    azimut             NUMERIC(6,2)  NOT NULL,
    inclinacion        NUMERIC(6,2)  NOT NULL,
    rotacion           NUMERIC(6,2)  NOT NULL,
    radio_activacion_m NUMERIC(8,2)  NOT NULL,
    escala_visual      NUMERIC(6,3)  NOT NULL,
    PRIMARY KEY (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, codigo_recurso_3d)
);
