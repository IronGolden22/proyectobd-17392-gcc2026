-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/01_schema/02_vias_transporte_rutas.sql
-- Autor:    Gabriel López (C.I. 30.821.466) - Estructura base compartida
--           para el equipo (Caroline Corniells / Christian Villera).
-- Alcance:  Subsistema 2.2 - Infraestructura Vial, Transporte y Rutas Turísticas.
-- ============================================================================

CREATE TABLE via (
    codigo_via            VARCHAR(50)  PRIMARY KEY,
    nombre_via            VARCHAR(150) NOT NULL,
    tipo_via              VARCHAR(30)  NOT NULL,
    condicion_terreno     VARCHAR(100) NOT NULL,
    desnivel_pendiente_3d NUMERIC(6,2) NOT NULL DEFAULT 0,
    estado_via            VARCHAR(40)  NOT NULL
);

CREATE TABLE modo_recorrido_via (
    codigo_via      VARCHAR(50) NOT NULL,
    modos_recorrido VARCHAR(30) NOT NULL,
    PRIMARY KEY (codigo_via, modos_recorrido)
);

CREATE TABLE parada_transporte (
    codigo_terminal               VARCHAR(50)   PRIMARY KEY,
    nombre_descriptivo            VARCHAR(150)  NOT NULL,
    modalidad_transp              VARCHAR(30)   NOT NULL,
    tarifa_basica_bs              NUMERIC(12,2) NOT NULL,
    nivel_accesibilidad           VARCHAR(60)   NOT NULL,
    latitud_parada                NUMERIC(9,6)  NOT NULL,
    longitud_parada               NUMERIC(9,6)  NOT NULL,
    altitud_parada                NUMERIC(8,2)  NOT NULL,
    hora_apertura                 TIME          NOT NULL,
    hora_cierre                   TIME          NOT NULL,
    estado_disponib               VARCHAR(30)   NOT NULL,
    frecuencia_paso_min           NUMERIC(6,2)  NOT NULL,
    capacidad_max_espera          INTEGER       NOT NULL,
    tiene_techo                   BOOLEAN       NOT NULL DEFAULT FALSE,
    iluminacion_nocturna          BOOLEAN       NOT NULL DEFAULT FALSE,
    tiene_taquilla                BOOLEAN       NOT NULL DEFAULT FALSE,
    vigilancia_permanente         BOOLEAN       NOT NULL DEFAULT FALSE,
    estacionamiento_transferencia BOOLEAN       NOT NULL DEFAULT FALSE,
    codigo_via                    VARCHAR(50)   NOT NULL
);

CREATE TABLE parada_cercana_hito (
    codigo_terminal  VARCHAR(50)  NOT NULL,
    nombre_estado    VARCHAR(100) NOT NULL,
    nombre_municipio VARCHAR(100) NOT NULL,
    nombre_parroquia VARCHAR(100) NOT NULL,
    nombre_hito      VARCHAR(150) NOT NULL,
    distancia_metros NUMERIC(8,2) NOT NULL,
    PRIMARY KEY (codigo_terminal, nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
);

CREATE TABLE ruta_turistica (
    nombre_estado_origen    VARCHAR(100) NOT NULL,
    nombre_municipio_origen VARCHAR(100) NOT NULL,
    nombre_ruta             VARCHAR(150) NOT NULL,
    duracion_estimada       NUMERIC(8,2) NOT NULL,
    mejor_hora_inicio       TIME         NOT NULL,
    nivel_dificultad        VARCHAR(20)  NOT NULL,
    categoria_tematica      VARCHAR(60)  NOT NULL,
    PRIMARY KEY (nombre_estado_origen, nombre_municipio_origen, nombre_ruta)
);

CREATE TABLE ruta_fija (
    nombre_estado_origen    VARCHAR(100) NOT NULL,
    nombre_municipio_origen VARCHAR(100) NOT NULL,
    nombre_ruta             VARCHAR(150) NOT NULL,
    fecha_curaduria         DATE         NOT NULL,
    resena_experto          TEXT         NOT NULL,
    PRIMARY KEY (nombre_estado_origen, nombre_municipio_origen, nombre_ruta)
);

CREATE TABLE ruta_dinamica (
    nombre_estado_origen     VARCHAR(100) NOT NULL,
    nombre_municipio_origen  VARCHAR(100) NOT NULL,
    nombre_ruta              VARCHAR(150) NOT NULL,
    pref_transporte          VARCHAR(40)  NOT NULL,
    fecha_generacion         TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cedula_pasaporte_creador VARCHAR(30)  NOT NULL,
    PRIMARY KEY (nombre_estado_origen, nombre_municipio_origen, nombre_ruta)
);

CREATE TABLE paso_itinerario (
    nombre_estado_origen    VARCHAR(100) NOT NULL,
    nombre_municipio_origen VARCHAR(100) NOT NULL,
    nombre_ruta             VARCHAR(150) NOT NULL,
    nro_orden_secuencia     INTEGER      NOT NULL,
    tiempo_estancia_min     NUMERIC(6,2) NOT NULL DEFAULT 0,
    codigo_via              VARCHAR(50)  NOT NULL,
    codigo_terminal         VARCHAR(50)  NULL,
    nombre_estado_hito      VARCHAR(100) NULL,
    nombre_municipio_hito   VARCHAR(100) NULL,
    nombre_parroquia_hito   VARCHAR(100) NULL,
    nombre_hito             VARCHAR(150) NULL,
    PRIMARY KEY (nombre_estado_origen, nombre_municipio_origen, nombre_ruta, nro_orden_secuencia)
);
