-- Script consolidado de inicialización para Docker Compose (RutasVenezuela)
-- Generado desde database/install_all.sql - Autor: Gabriel López (C.I. 30.821.466)

-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/00_drop/00_drop_all.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Propósito: Limpieza idempotente de objetos de la base de datos en orden
--            inverso de dependencia (procedimientos, funciones y las 31 tablas).
-- ============================================================================

-- 1. Procedimientos almacenados (HU-01 a HU-14)
DROP PROCEDURE IF EXISTS sp_actualizar_estado_operativo_hito(VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, TEXT, TEXT[]);
DROP PROCEDURE IF EXISTS sp_registrar_hito_completo(VARCHAR, VARCHAR, VARCHAR, VARCHAR, NUMERIC, NUMERIC, NUMERIC, VARCHAR, BOOLEAN, TEXT, TEXT[], TEXT[], TEXT[]);
DROP PROCEDURE IF EXISTS sp_registrar_jerarquia_territorial(VARCHAR, VARCHAR, VARCHAR);
DROP PROCEDURE IF EXISTS sp_actualizar_contacto_actor(VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, TEXT);
DROP PROCEDURE IF EXISTS sp_actualizar_perfil_visitante(VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, TEXT, TEXT[]);
DROP PROCEDURE IF EXISTS sp_cambiar_estado_cuenta_usuario(VARCHAR, VARCHAR, VARCHAR, VARCHAR, TEXT);
DROP PROCEDURE IF EXISTS sp_registrar_ente_publico(VARCHAR, TEXT, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR);
DROP PROCEDURE IF EXISTS sp_registrar_comercio_aliado(VARCHAR, TEXT, VARCHAR, VARCHAR, INTEGER, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR);
DROP PROCEDURE IF EXISTS sp_parametrizar_idiomas_zona_guia(VARCHAR, VARCHAR, VARCHAR, VARCHAR, TEXT[], TEXT[]);
DROP PROCEDURE IF EXISTS sp_registrar_guia_turistico(VARCHAR, VARCHAR, TEXT, VARCHAR, VARCHAR, VARCHAR, INTEGER, NUMERIC, VARCHAR, VARCHAR, TEXT[], TEXT[], VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR);
DROP PROCEDURE IF EXISTS sp_registrar_visitante(VARCHAR, TEXT, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, TEXT[]);

-- 2. Funciones de consulta, cálculo y triggers (HU-01 a HU-14)
DROP FUNCTION IF EXISTS fn_catalogo_hitos(VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS fn_consultar_ficha_integral_hito(VARCHAR, VARCHAR, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS fn_buscar_hitos_cercanos_3d(NUMERIC, NUMERIC, NUMERIC, NUMERIC);
DROP FUNCTION IF EXISTS fn_calcular_distancia_3d_m(NUMERIC, NUMERIC, NUMERIC, NUMERIC, NUMERIC, NUMERIC);
DROP FUNCTION IF EXISTS fn_listar_jerarquia_territorial(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS fn_buscar_guias_disponibles(VARCHAR, VARCHAR, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS fn_obtener_perfil_visitante(VARCHAR);
DROP FUNCTION IF EXISTS fn_autenticar_usuario(VARCHAR, TEXT, VARCHAR);
DROP FUNCTION IF EXISTS fn_hash_contrasena(TEXT);

DROP FUNCTION IF EXISTS trg_fn_validar_hito_horario_y_categoria() CASCADE;
DROP FUNCTION IF EXISTS trg_fn_coherencia_hito_before() CASCADE;
DROP FUNCTION IF EXISTS trg_fn_validar_rm13_guia_ruta() CASCADE;
DROP FUNCTION IF EXISTS trg_fn_validar_rm02_municipio_parroquia() CASCADE;
DROP FUNCTION IF EXISTS trg_fn_validar_rm01_estado_municipio() CASCADE;
DROP FUNCTION IF EXISTS trg_fn_validar_disyuncion_usuarios() CASCADE;
DROP FUNCTION IF EXISTS trg_fn_preparar_registro_usuario() CASCADE;

-- 3. Tablas en orden inverso de dependencias (31 tablas del modelo relacional)
DROP TABLE IF EXISTS reporte_incidencia CASCADE;
DROP TABLE IF EXISTS credencial_acceso CASCADE;
DROP TABLE IF EXISTS evaluacion_experiencia CASCADE;
DROP TABLE IF EXISTS recorrido_realizado CASCADE;
DROP TABLE IF EXISTS visita_hito CASCADE;
DROP TABLE IF EXISTS experiencia_incluye_hito CASCADE;
DROP TABLE IF EXISTS experiencia_promocional CASCADE;
DROP TABLE IF EXISTS acompana_ruta CASCADE;
DROP TABLE IF EXISTS idioma_guia CASCADE;
DROP TABLE IF EXISTS especialidad_guia CASCADE;
DROP TABLE IF EXISTS guia_turistico CASCADE;
DROP TABLE IF EXISTS accesibilidad_visitante CASCADE;
DROP TABLE IF EXISTS paso_itinerario CASCADE;
DROP TABLE IF EXISTS ruta_dinamica CASCADE;
DROP TABLE IF EXISTS ruta_fija CASCADE;
DROP TABLE IF EXISTS ruta_turistica CASCADE;
DROP TABLE IF EXISTS parada_cercana_hito CASCADE;
DROP TABLE IF EXISTS parada_transporte CASCADE;
DROP TABLE IF EXISTS modo_recorrido_via CASCADE;
DROP TABLE IF EXISTS via CASCADE;
DROP TABLE IF EXISTS punto_anclaje_ra CASCADE;
DROP TABLE IF EXISTS cronograma_evento_hito CASCADE;
DROP TABLE IF EXISTS horario_hito CASCADE;
DROP TABLE IF EXISTS categoria_hito CASCADE;
DROP TABLE IF EXISTS hito CASCADE;
DROP TABLE IF EXISTS parroquia CASCADE;
DROP TABLE IF EXISTS municipio CASCADE;
DROP TABLE IF EXISTS estado CASCADE;
DROP TABLE IF EXISTS ente_publico CASCADE;
DROP TABLE IF EXISTS comercio_aliado CASCADE;
DROP TABLE IF EXISTS visitante CASCADE;


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


-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/02_constraints/01_fk_estructurales_base.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Integridad referencial del Modelo Relacional (RM-01 a RM-19, RM-21).
-- ============================================================================

-- Subsistema 2.1: Jerarquía Político-Territorial, Hitos y RA (RM-01 a RM-04)
ALTER TABLE municipio
    ADD CONSTRAINT fk_municipio_estado
    FOREIGN KEY (nombre_estado)
    REFERENCES estado (nombre_estado)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE parroquia
    ADD CONSTRAINT fk_parroquia_municipio
    FOREIGN KEY (nombre_estado, nombre_municipio)
    REFERENCES municipio (nombre_estado, nombre_municipio)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE hito
    ADD CONSTRAINT fk_hito_parroquia
    FOREIGN KEY (nombre_estado, nombre_municipio, nombre_parroquia)
    REFERENCES parroquia (nombre_estado, nombre_municipio, nombre_parroquia)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE categoria_hito
    ADD CONSTRAINT fk_categoria_hito
    FOREIGN KEY (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
    REFERENCES hito (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE horario_hito
    ADD CONSTRAINT fk_horario_hito
    FOREIGN KEY (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
    REFERENCES hito (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE cronograma_evento_hito
    ADD CONSTRAINT fk_cronograma_evento_hito
    FOREIGN KEY (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
    REFERENCES hito (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE punto_anclaje_ra
    ADD CONSTRAINT fk_punto_anclaje_hito
    FOREIGN KEY (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
    REFERENCES hito (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Subsistema 2.2: Vías, Transporte y Rutas Turísticas (RM-05 a RM-11)
ALTER TABLE modo_recorrido_via
    ADD CONSTRAINT fk_modo_recorrido_via
    FOREIGN KEY (codigo_via)
    REFERENCES via (codigo_via)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE parada_transporte
    ADD CONSTRAINT fk_parada_transporte_via
    FOREIGN KEY (codigo_via)
    REFERENCES via (codigo_via)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE parada_cercana_hito
    ADD CONSTRAINT fk_parada_cercana_terminal
    FOREIGN KEY (codigo_terminal)
    REFERENCES parada_transporte (codigo_terminal)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT fk_parada_cercana_hito
    FOREIGN KEY (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
    REFERENCES hito (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ruta_turistica
    ADD CONSTRAINT fk_ruta_turistica_municipio_origen
    FOREIGN KEY (nombre_estado_origen, nombre_municipio_origen)
    REFERENCES municipio (nombre_estado, nombre_municipio)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE ruta_fija
    ADD CONSTRAINT fk_ruta_fija_superclase
    FOREIGN KEY (nombre_estado_origen, nombre_municipio_origen, nombre_ruta)
    REFERENCES ruta_turistica (nombre_estado_origen, nombre_municipio_origen, nombre_ruta)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ruta_dinamica
    ADD CONSTRAINT fk_ruta_dinamica_superclase
    FOREIGN KEY (nombre_estado_origen, nombre_municipio_origen, nombre_ruta)
    REFERENCES ruta_turistica (nombre_estado_origen, nombre_municipio_origen, nombre_ruta)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT fk_ruta_dinamica_creador
    FOREIGN KEY (cedula_pasaporte_creador)
    REFERENCES visitante (cedula_pasaporte)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE paso_itinerario
    ADD CONSTRAINT fk_paso_itinerario_ruta
    FOREIGN KEY (nombre_estado_origen, nombre_municipio_origen, nombre_ruta)
    REFERENCES ruta_turistica (nombre_estado_origen, nombre_municipio_origen, nombre_ruta)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT fk_paso_itinerario_via
    FOREIGN KEY (codigo_via)
    REFERENCES via (codigo_via)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT fk_paso_itinerario_parada
    FOREIGN KEY (codigo_terminal)
    REFERENCES parada_transporte (codigo_terminal)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT fk_paso_itinerario_hito
    FOREIGN KEY (nombre_estado_hito, nombre_municipio_hito, nombre_parroquia_hito, nombre_hito)
    REFERENCES hito (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
    MATCH FULL ON DELETE RESTRICT ON UPDATE CASCADE;

-- Subsistema 2.3: Usuarios y Operación Turística (RM-12 a RM-19, RM-21)
ALTER TABLE accesibilidad_visitante
    ADD CONSTRAINT fk_accesibilidad_visitante
    FOREIGN KEY (cedula_pasaporte)
    REFERENCES visitante (cedula_pasaporte)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE guia_turistico
    ADD CONSTRAINT fk_guia_zona_municipio
    FOREIGN KEY (nombre_estado_zona, nombre_municipio_zona)
    REFERENCES municipio (nombre_estado, nombre_municipio)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE especialidad_guia
    ADD CONSTRAINT fk_especialidad_guia
    FOREIGN KEY (nro_rtn, cod_licencia)
    REFERENCES guia_turistico (nro_rtn, cod_licencia)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE idioma_guia
    ADD CONSTRAINT fk_idioma_guia
    FOREIGN KEY (nro_rtn, cod_licencia)
    REFERENCES guia_turistico (nro_rtn, cod_licencia)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE acompana_ruta
    ADD CONSTRAINT fk_acompana_ruta_guia
    FOREIGN KEY (nro_rtn, cod_licencia)
    REFERENCES guia_turistico (nro_rtn, cod_licencia)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT fk_acompana_ruta_ruta
    FOREIGN KEY (nombre_estado_origen, nombre_municipio_origen, nombre_ruta)
    REFERENCES ruta_turistica (nombre_estado_origen, nombre_municipio_origen, nombre_ruta)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE experiencia_promocional
    ADD CONSTRAINT fk_exp_comercio
    FOREIGN KEY (rif_comercio)
    REFERENCES comercio_aliado (rif)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT fk_exp_guia
    FOREIGN KEY (nro_rtn_guia, cod_licencia_guia)
    REFERENCES guia_turistico (nro_rtn, cod_licencia)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT fk_exp_ruta
    FOREIGN KEY (nombre_estado_origen, nombre_municipio_origen, nombre_ruta)
    REFERENCES ruta_turistica (nombre_estado_origen, nombre_municipio_origen, nombre_ruta)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT fk_exp_guia_acompana_ruta_rm21
    FOREIGN KEY (nro_rtn_guia, cod_licencia_guia, nombre_estado_origen, nombre_municipio_origen, nombre_ruta)
    REFERENCES acompana_ruta (nro_rtn, cod_licencia, nombre_estado_origen, nombre_municipio_origen, nombre_ruta)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE experiencia_incluye_hito
    ADD CONSTRAINT fk_exp_incluye_experiencia
    FOREIGN KEY (titulo_experiencia, fecha_activacion)
    REFERENCES experiencia_promocional (titulo_experiencia, fecha_activacion)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT fk_exp_incluye_hito
    FOREIGN KEY (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
    REFERENCES hito (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE visita_hito
    ADD CONSTRAINT fk_visita_hito_visitante
    FOREIGN KEY (cedula_pasaporte)
    REFERENCES visitante (cedula_pasaporte)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT fk_visita_hito_hito
    FOREIGN KEY (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
    REFERENCES hito (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE recorrido_realizado
    ADD CONSTRAINT fk_recorrido_visitante
    FOREIGN KEY (cedula_pasaporte)
    REFERENCES visitante (cedula_pasaporte)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT fk_recorrido_ruta
    FOREIGN KEY (nombre_estado_origen, nombre_municipio_origen, nombre_ruta)
    REFERENCES ruta_turistica (nombre_estado_origen, nombre_municipio_origen, nombre_ruta)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE evaluacion_experiencia
    ADD CONSTRAINT fk_eval_visitante
    FOREIGN KEY (cedula_pasaporte)
    REFERENCES visitante (cedula_pasaporte)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT fk_eval_recorrido
    FOREIGN KEY (cedula_pasaporte, fecha_hora_inicio_rec)
    REFERENCES recorrido_realizado (cedula_pasaporte, fecha_hora_inicio)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT fk_eval_hito
    FOREIGN KEY (nombre_estado_hito, nombre_municipio_hito, nombre_parroquia_hito, nombre_hito)
    REFERENCES hito (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
    MATCH FULL ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE credencial_acceso
    ADD CONSTRAINT fk_credencial_visitante
    FOREIGN KEY (cedula_pasaporte)
    REFERENCES visitante (cedula_pasaporte)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT fk_credencial_experiencia
    FOREIGN KEY (titulo_experiencia, fecha_activacion)
    REFERENCES experiencia_promocional (titulo_experiencia, fecha_activacion)
    MATCH FULL ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE reporte_incidencia
    ADD CONSTRAINT fk_incidencia_visitante
    FOREIGN KEY (cedula_pasaporte_reporta)
    REFERENCES visitante (cedula_pasaporte)
    ON DELETE SET NULL ON UPDATE CASCADE,
    ADD CONSTRAINT fk_incidencia_guia
    FOREIGN KEY (nro_rtn_reporta, cod_licencia_reporta)
    REFERENCES guia_turistico (nro_rtn, cod_licencia)
    MATCH FULL ON DELETE SET NULL ON UPDATE CASCADE,
    ADD CONSTRAINT fk_incidencia_ente_reporta
    FOREIGN KEY (rif_gub_reporta)
    REFERENCES ente_publico (rif_gubernamental)
    ON DELETE SET NULL ON UPDATE CASCADE,
    ADD CONSTRAINT fk_incidencia_ente_validador
    FOREIGN KEY (rif_gub_validador)
    REFERENCES ente_publico (rif_gubernamental)
    ON DELETE SET NULL ON UPDATE CASCADE,
    ADD CONSTRAINT fk_incidencia_via
    FOREIGN KEY (codigo_via_afectada)
    REFERENCES via (codigo_via)
    ON DELETE SET NULL ON UPDATE CASCADE,
    ADD CONSTRAINT fk_incidencia_hito
    FOREIGN KEY (nombre_estado_hito, nombre_municipio_hito, nombre_parroquia_hito, nombre_hito_afectado)
    REFERENCES hito (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
    MATCH FULL ON DELETE SET NULL ON UPDATE CASCADE;


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


-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/02_constraints/03_chk_dominio_hitos_territorial.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Restricciones de dominio, unicidad local y 3D para jerarquía
--           territorial e hitos (HU-09 a HU-14, RE-01, RE-02, RE-03).
-- ============================================================================

-- Jerarquía Político-Territorial (HU-09)
ALTER TABLE estado
    ADD CONSTRAINT chk_estado_nombre_no_vacio
        CHECK (BTRIM(nombre_estado) <> '');

ALTER TABLE municipio
    ADD CONSTRAINT chk_municipio_nombre_no_vacio
        CHECK (BTRIM(nombre_municipio) <> '');

ALTER TABLE parroquia
    ADD CONSTRAINT chk_parroquia_nombre_no_vacio
        CHECK (BTRIM(nombre_parroquia) <> '');

-- Hitos Turísticos y Culturales (HU-10 a HU-14, RE-01, RE-03)
ALTER TABLE hito
    ADD CONSTRAINT chk_hito_campos_no_vacios
        CHECK (BTRIM(nombre_hito) <> '' AND BTRIM(historia) <> ''),
    ADD CONSTRAINT chk_hito_estado_operativo
        CHECK (estado_operativo IN (
            'disponible',
            'en restauracion',
            'clausurado temporalmente',
            'cerrado permanentemente'
        )),
    ADD CONSTRAINT chk_hito_coordenadas_geodesicas
        CHECK (
            latitud BETWEEN -90 AND 90 AND
            longitud BETWEEN -180 AND 180 AND
            altitud_msnm BETWEEN -500 AND 9000
        ),
    -- HU-13: Permite compartir latitud/longitud siempre que difiera la altitud/elevación
    ADD CONSTRAINT uq_hito_coordenada_3d
        UNIQUE (latitud, longitud, altitud_msnm);

-- HU-12: Garantiza unicidad del nombre normalizado dentro del mismo Municipio y Parroquia
CREATE UNIQUE INDEX uq_hito_nombre_normalizado_parroquia
    ON hito (
        LOWER(BTRIM(nombre_estado)),
        LOWER(BTRIM(nombre_municipio)),
        LOWER(BTRIM(nombre_parroquia)),
        LOWER(BTRIM(nombre_hito))
    );

-- Categorías, Horarios y Cronogramas del Hito (HU-10, HU-14, RE-02)
ALTER TABLE categoria_hito
    ADD CONSTRAINT chk_categoria_hito_catalogo
        CHECK (categoria_hito IN (
            'historico',
            'religioso',
            'natural',
            'gastronomico',
            'recreativo',
            'descanso'
        ));

ALTER TABLE horario_hito
    ADD CONSTRAINT chk_horario_hito_no_vacio
        CHECK (BTRIM(horario_visita) <> '');

ALTER TABLE cronograma_evento_hito
    ADD CONSTRAINT chk_cronograma_evento_no_vacio
        CHECK (BTRIM(cronograma_eventos) <> '');


-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/02_constraints/04_chk_dominio_resto_esquema.sql
-- Autor:    Gabriel López (C.I. 30.821.466) - Restricciones declarativas base
--           RE-04 a RE-25 y RM-19 a RM-25 para el resto del esquema.
-- ============================================================================

-- RE-04: Punto de anclaje de Realidad Aumentada
ALTER TABLE punto_anclaje_ra
    ADD CONSTRAINT chk_ra_coordenadas_y_parametros
        CHECK (
            latitud_ra BETWEEN -90 AND 90 AND
            longitud_ra BETWEEN -180 AND 180 AND
            radio_activacion_m > 0 AND
            escala_visual > 0 AND
            azimut >= 0 AND azimut <= 360
        );

-- RE-05: Vías físicas
ALTER TABLE via
    ADD CONSTRAINT chk_via_tipo_y_estado
        CHECK (
            tipo_via IN ('calle', 'avenida', 'bulevar', 'camineria', 'sendero', 'puente') AND
            estado_via IN ('habilitada', 'cierre total por mantenimiento')
        );

-- RE-06: Modos de recorrido por vía
ALTER TABLE modo_recorrido_via
    ADD CONSTRAINT chk_modo_recorrido_catalogo
        CHECK (modos_recorrido IN ('a pie', 'bicicleta', 'transporte publico', 'vehiculo adaptado'));

-- RE-07: Paradas de transporte
ALTER TABLE parada_transporte
    ADD CONSTRAINT chk_parada_dominio_operativo
        CHECK (
            modalidad_transp IN ('metro', 'ferrocarril', 'autobus superficial', 'teleferico', 'transporte acuatico') AND
            estado_disponib IN ('activa', 'en mantenimiento', 'fuera de servicio') AND
            latitud_parada BETWEEN -90 AND 90 AND
            longitud_parada BETWEEN -180 AND 180 AND
            tarifa_basica_bs >= 0 AND
            frecuencia_paso_min > 0 AND
            capacidad_max_espera > 0 AND
            hora_cierre > hora_apertura
        );

-- RE-09: Proximidad parada-hito
ALTER TABLE parada_cercana_hito
    ADD CONSTRAINT chk_parada_cercana_distancia_pos
        CHECK (distancia_metros > 0);

-- RE-10: Rutas turísticas
ALTER TABLE ruta_turistica
    ADD CONSTRAINT chk_ruta_duracion_y_dificultad
        CHECK (
            duracion_estimada > 0 AND
            nivel_dificultad IN ('bajo', 'medio', 'alto')
        );

-- RE-12, RE-13 (parte positiva), RM-20: Pasos de itinerario
ALTER TABLE paso_itinerario
    ADD CONSTRAINT chk_paso_itinerario_reglas
        CHECK (
            nro_orden_secuencia >= 1 AND
            tiempo_estancia_min >= 0 AND
            (codigo_terminal IS NOT NULL OR nombre_hito IS NOT NULL)
        );

-- RE-17: Experiencias promocionales
ALTER TABLE experiencia_promocional
    ADD CONSTRAINT chk_exp_reglas_comerciales
        CHECK (
            fecha_vencimiento > fecha_activacion AND
            cupo_max_grupo >= 1 AND
            precio_total >= 0 AND
            porcentaje_descuento >= 0 AND porcentaje_descuento <= 100
        ),
    ADD CONSTRAINT uq_exp_codigo_promocional
        UNIQUE (codigo_promocional);

-- RE-20, RE-21, RE-22, RM-19, RM-22, RM-23: Reportes de incidencia
ALTER TABLE reporte_incidencia
    ADD CONSTRAINT chk_incidencia_dominio
        CHECK (
            estado_reporte IN ('preliminar', 'activo', 'resuelto') AND
            nivel_severidad IN ('bajo', 'medio', 'critico') AND
            fecha_est_resolucion >= fecha_hora_deteccion
        ),
    ADD CONSTRAINT chk_incidencia_afecta_al_menos_uno_rm22
        CHECK (codigo_via_afectada IS NOT NULL OR nombre_hito_afectado IS NOT NULL),
    ADD CONSTRAINT chk_incidencia_emisor_exclusivo_rm19_re20
        CHECK (
            (cedula_pasaporte_reporta IS NOT NULL AND nro_rtn_reporta IS NULL AND cod_licencia_reporta IS NULL AND rif_gub_reporta IS NULL) OR
            (cedula_pasaporte_reporta IS NULL AND nro_rtn_reporta IS NOT NULL AND cod_licencia_reporta IS NOT NULL AND rif_gub_reporta IS NULL) OR
            (cedula_pasaporte_reporta IS NULL AND nro_rtn_reporta IS NULL AND cod_licencia_reporta IS NULL AND rif_gub_reporta IS NOT NULL)
        ),
    ADD CONSTRAINT chk_incidencia_validacion_re22_rm23
        CHECK (
            (
                (cedula_pasaporte_reporta IS NOT NULL OR nro_rtn_reporta IS NOT NULL) AND
                estado_reporte IN ('activo', 'resuelto')
            ) IS NOT TRUE OR rif_gub_validador IS NOT NULL
        ),
    ADD CONSTRAINT chk_incidencia_ente_nace_activo_re22
        CHECK (
            rif_gub_reporta IS NULL OR estado_reporte IN ('activo', 'resuelto')
        );

-- RE-23: Recorridos realizados
ALTER TABLE recorrido_realizado
    ADD CONSTRAINT chk_recorrido_fecha_fin
        CHECK (completado = FALSE OR (fecha_hora_fin IS NOT NULL AND fecha_hora_fin >= fecha_hora_inicio));

-- RE-24, RM-24 (parte estructural): Evaluaciones de experiencia
ALTER TABLE evaluacion_experiencia
    ADD CONSTRAINT chk_evaluacion_rangos_y_objetivo
        CHECK (
            calif_estrellas BETWEEN 1 AND 5 AND
            indice_seguridad BETWEEN 1 AND 5 AND
            (fecha_hora_inicio_rec IS NOT NULL OR nombre_hito IS NOT NULL)
        );

-- RE-25: Credenciales de acceso
ALTER TABLE credencial_acceso
    ADD CONSTRAINT chk_credencial_dominio
        CHECK (
            estado_pase IN ('emitido', 'canjeado', 'cancelado', 'vencido') AND
            monto_abonado >= 0 AND
            cantidad_beneficiarios >= 1
        );


-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/03_functions/01_fn_hash_y_autenticacion.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Hashing SHA-256 nativo y autenticación unificada multi-actor
--           (Visitante, Guía, Comercio Aliado, Ente Público) con control de
--           estado de cuenta (HU-01, HU-03, HU-05, HU-06, HU-07).
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_hash_contrasena(p_texto TEXT)
RETURNS VARCHAR(64)
LANGUAGE plpgsql
IMMUTABLE
STRICT
AS $$
BEGIN
    IF BTRIM(p_texto) = '' THEN
        RAISE EXCEPTION 'La contraseña no puede ser vacía.';
    END IF;

    RETURN encode(sha256(convert_to(p_texto, 'UTF8')), 'hex');
END;
$$;

CREATE OR REPLACE FUNCTION fn_autenticar_usuario(
    p_identificador VARCHAR,
    p_contrasena    TEXT,
    p_cod_licencia  VARCHAR DEFAULT NULL
)
RETURNS TABLE (
    tipo_actor     VARCHAR,
    identificador  VARCHAR,
    nombre_mostrar VARCHAR,
    estado_cuenta  VARCHAR,
    autenticado    BOOLEAN,
    mensaje        TEXT
)
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    v_id          VARCHAR := UPPER(BTRIM(p_identificador));
    v_lic         VARCHAR := NULLIF(UPPER(BTRIM(p_cod_licencia)), '');
    v_hash_input  VARCHAR(64);
    v_hash_stored VARCHAR(255);
    v_nombre      VARCHAR;
    v_estado      VARCHAR;
BEGIN
    IF v_id IS NULL OR v_id = '' OR p_contrasena IS NULL OR BTRIM(p_contrasena) = '' THEN
        RETURN QUERY SELECT NULL::VARCHAR, p_identificador, NULL::VARCHAR, NULL::VARCHAR, FALSE,
            'Debe proporcionar identificador y contraseña.'::TEXT;
        RETURN;
    END IF;

    v_hash_input := fn_hash_contrasena(p_contrasena);

    -- 1. Caso Guía Turístico (requiere RTN + código de licencia)
    IF v_lic IS NOT NULL THEN
        SELECT g.contrasena, (g.nombres || ' ' || g.apellidos)::VARCHAR, g.estado_cuenta
          INTO v_hash_stored, v_nombre, v_estado
          FROM guia_turistico g
         WHERE UPPER(BTRIM(g.nro_rtn)) = v_id
           AND UPPER(BTRIM(g.cod_licencia)) = v_lic;

        IF NOT FOUND THEN
            RETURN QUERY SELECT 'GUIA_TURISTICO'::VARCHAR, (v_id || ' / ' || v_lic)::VARCHAR,
                NULL::VARCHAR, NULL::VARCHAR, FALSE, 'Credenciales de guía turístico no encontradas.'::TEXT;
            RETURN;
        END IF;

        IF v_hash_stored <> v_hash_input THEN
            RETURN QUERY SELECT 'GUIA_TURISTICO'::VARCHAR, (v_id || ' / ' || v_lic)::VARCHAR,
                v_nombre, v_estado, FALSE, 'Contraseña incorrecta.'::TEXT;
            RETURN;
        END IF;

        IF v_estado <> 'activa' THEN
            RETURN QUERY SELECT 'GUIA_TURISTICO'::VARCHAR, (v_id || ' / ' || v_lic)::VARCHAR,
                v_nombre, v_estado, FALSE, ('Acceso denegado: cuenta en estado ' || v_estado || '.')::TEXT;
            RETURN;
        END IF;

        RETURN QUERY SELECT 'GUIA_TURISTICO'::VARCHAR, (v_id || ' / ' || v_lic)::VARCHAR,
            v_nombre, v_estado, TRUE, 'Autenticación exitosa.'::TEXT;
        RETURN;
    END IF;

    -- 2. Caso Visitante (cédula o pasaporte)
    SELECT v.contrasena, (v.nombres || ' ' || v.apellidos)::VARCHAR, v.estado_cuenta
      INTO v_hash_stored, v_nombre, v_estado
      FROM visitante v
     WHERE UPPER(BTRIM(v.cedula_pasaporte)) = v_id;

    IF FOUND THEN
        IF v_hash_stored <> v_hash_input THEN
            RETURN QUERY SELECT 'VISITANTE'::VARCHAR, v_id, v_nombre, v_estado, FALSE,
                'Contraseña incorrecta.'::TEXT;
            RETURN;
        END IF;
        IF v_estado <> 'activa' THEN
            RETURN QUERY SELECT 'VISITANTE'::VARCHAR, v_id, v_nombre, v_estado, FALSE,
                ('Acceso denegado: cuenta en estado ' || v_estado || '.')::TEXT;
            RETURN;
        END IF;
        RETURN QUERY SELECT 'VISITANTE'::VARCHAR, v_id, v_nombre, v_estado, TRUE,
            'Autenticación exitosa.'::TEXT;
        RETURN;
    END IF;

    -- 3. Caso Comercio Aliado (RIF jurídico)
    SELECT c.contrasena, c.razon_social, c.estado_cuenta
      INTO v_hash_stored, v_nombre, v_estado
      FROM comercio_aliado c
     WHERE UPPER(BTRIM(c.rif)) = v_id;

    IF FOUND THEN
        IF v_hash_stored <> v_hash_input THEN
            RETURN QUERY SELECT 'COMERCIO_ALIADO'::VARCHAR, v_id, v_nombre, v_estado, FALSE,
                'Contraseña incorrecta.'::TEXT;
            RETURN;
        END IF;
        IF v_estado <> 'activa' THEN
            RETURN QUERY SELECT 'COMERCIO_ALIADO'::VARCHAR, v_id, v_nombre, v_estado, FALSE,
                ('Acceso denegado: cuenta en estado ' || v_estado || '.')::TEXT;
            RETURN;
        END IF;
        RETURN QUERY SELECT 'COMERCIO_ALIADO'::VARCHAR, v_id, v_nombre, v_estado, TRUE,
            'Autenticación exitosa.'::TEXT;
        RETURN;
    END IF;

    -- 4. Caso Ente Público (RIF gubernamental)
    SELECT e.contrasena, e.denominacion_oficial, e.estado_cuenta
      INTO v_hash_stored, v_nombre, v_estado
      FROM ente_publico e
     WHERE UPPER(BTRIM(e.rif_gubernamental)) = v_id;

    IF FOUND THEN
        IF v_hash_stored <> v_hash_input THEN
            RETURN QUERY SELECT 'ENTE_PUBLICO'::VARCHAR, v_id, v_nombre, v_estado, FALSE,
                'Contraseña incorrecta.'::TEXT;
            RETURN;
        END IF;
        IF v_estado <> 'activa' THEN
            RETURN QUERY SELECT 'ENTE_PUBLICO'::VARCHAR, v_id, v_nombre, v_estado, FALSE,
                ('Acceso denegado: cuenta en estado ' || v_estado || '.')::TEXT;
            RETURN;
        END IF;
        RETURN QUERY SELECT 'ENTE_PUBLICO'::VARCHAR, v_id, v_nombre, v_estado, TRUE,
            'Autenticación exitosa.'::TEXT;
        RETURN;
    END IF;

    RETURN QUERY SELECT NULL::VARCHAR, v_id, NULL::VARCHAR, NULL::VARCHAR, FALSE,
        'Usuario no registrado en la plataforma.'::TEXT;
END;
$$;


-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/03_functions/02_fn_consultar_perfil_usuario.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Consulta de perfil de visitante con accesibilidad (HU-01, HU-02,
--           HU-08) y búsqueda/filtrado de guías turísticos por idiomas,
--           zona geográfica asignada y especialidades (HU-03, HU-04).
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_obtener_perfil_visitante(
    p_cedula_pasaporte VARCHAR
)
RETURNS TABLE (
    cedula_pasaporte    VARCHAR,
    nombres             VARCHAR,
    apellidos           VARCHAR,
    pais_origen         VARCHAR,
    idioma_nativo       VARCHAR,
    telefono_emergencia VARCHAR,
    grupo_sanguineo     VARCHAR,
    correo_contacto     VARCHAR,
    telefono_contacto   VARCHAR,
    estado_cuenta       VARCHAR,
    requerimientos_acc  TEXT[]
)
LANGUAGE sql
STABLE
AS $$
    SELECT
        v.cedula_pasaporte,
        v.nombres,
        v.apellidos,
        v.pais_origen,
        v.idioma_nativo,
        v.telefono_emergencia,
        v.grupo_sanguineo,
        v.correo_contacto,
        v.telefono_contacto,
        v.estado_cuenta,
        COALESCE(
            ARRAY_AGG(av.req_accesibilidad ORDER BY av.req_accesibilidad)
            FILTER (WHERE av.req_accesibilidad IS NOT NULL),
            ARRAY[]::TEXT[]
        ) AS requerimientos_acc
    FROM visitante v
    LEFT JOIN accesibilidad_visitante av
           ON av.cedula_pasaporte = v.cedula_pasaporte
    WHERE UPPER(BTRIM(v.cedula_pasaporte)) = UPPER(BTRIM(p_cedula_pasaporte))
    GROUP BY
        v.cedula_pasaporte,
        v.nombres,
        v.apellidos,
        v.pais_origen,
        v.idioma_nativo,
        v.telefono_emergencia,
        v.grupo_sanguineo,
        v.correo_contacto,
        v.telefono_contacto,
        v.estado_cuenta;
$$;

CREATE OR REPLACE FUNCTION fn_buscar_guias_disponibles(
    p_idioma         VARCHAR DEFAULT NULL,
    p_estado_zona    VARCHAR DEFAULT NULL,
    p_municipio_zona VARCHAR DEFAULT NULL,
    p_especialidad   VARCHAR DEFAULT NULL
)
RETURNS TABLE (
    nro_rtn               VARCHAR,
    cod_licencia          VARCHAR,
    nombres               VARCHAR,
    apellidos             VARCHAR,
    acreditacion_oficial  VARCHAR,
    anos_trayectoria      INTEGER,
    tarifa_horaria        NUMERIC,
    nombre_estado_zona    VARCHAR,
    nombre_municipio_zona VARCHAR,
    correo_contacto       VARCHAR,
    telefono_contacto     VARCHAR,
    idiomas_dominados     TEXT[],
    especialidades        TEXT[],
    cantidad_rutas        BIGINT
)
LANGUAGE sql
STABLE
AS $$
    SELECT
        g.nro_rtn,
        g.cod_licencia,
        g.nombres,
        g.apellidos,
        g.acreditacion_oficial,
        g.anos_trayectoria,
        g.tarifa_horaria,
        g.nombre_estado_zona,
        g.nombre_municipio_zona,
        g.correo_contacto,
        g.telefono_contacto,
        COALESCE(
            (SELECT ARRAY_AGG(DISTINCT ig.idiomas_dominados ORDER BY ig.idiomas_dominados)
               FROM idioma_guia ig
              WHERE ig.nro_rtn = g.nro_rtn AND ig.cod_licencia = g.cod_licencia),
            ARRAY[]::TEXT[]
        ) AS idiomas_dominados,
        COALESCE(
            (SELECT ARRAY_AGG(DISTINCT eg.especialidades ORDER BY eg.especialidades)
               FROM especialidad_guia eg
              WHERE eg.nro_rtn = g.nro_rtn AND eg.cod_licencia = g.cod_licencia),
            ARRAY[]::TEXT[]
        ) AS especialidades,
        (SELECT COUNT(*)
           FROM acompana_ruta ar
          WHERE ar.nro_rtn = g.nro_rtn AND ar.cod_licencia = g.cod_licencia) AS cantidad_rutas
    FROM guia_turistico g
    WHERE g.estado_cuenta = 'activa'
      AND (
          p_estado_zona IS NULL
          OR LOWER(BTRIM(g.nombre_estado_zona)) = LOWER(BTRIM(p_estado_zona))
      )
      AND (
          p_municipio_zona IS NULL
          OR LOWER(BTRIM(g.nombre_municipio_zona)) = LOWER(BTRIM(p_municipio_zona))
      )
      AND (
          p_idioma IS NULL
          OR EXISTS (
              SELECT 1
                FROM idioma_guia ig
               WHERE ig.nro_rtn = g.nro_rtn
                 AND ig.cod_licencia = g.cod_licencia
                 AND LOWER(BTRIM(ig.idiomas_dominados)) = LOWER(BTRIM(p_idioma))
          )
      )
      AND (
          p_especialidad IS NULL
          OR EXISTS (
              SELECT 1
                FROM especialidad_guia eg
               WHERE eg.nro_rtn = g.nro_rtn
                 AND eg.cod_licencia = g.cod_licencia
                 AND LOWER(eg.especialidades) LIKE ('%' || LOWER(BTRIM(p_especialidad)) || '%')
          )
      )
    ORDER BY g.anos_trayectoria DESC, g.tarifa_horaria ASC, g.apellidos ASC;
$$;


-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/03_functions/03_fn_jerarquia_territorial.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Consulta estructurada de la jerarquía político-territorial
--           Estado -> Municipio -> Parroquia y conteo de hitos (HU-09).
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_listar_jerarquia_territorial(
    p_nombre_estado    VARCHAR DEFAULT NULL,
    p_nombre_municipio VARCHAR DEFAULT NULL
)
RETURNS TABLE (
    nombre_estado     VARCHAR,
    nombre_municipio  VARCHAR,
    nombre_parroquia  VARCHAR,
    total_hitos       BIGINT,
    hitos_disponibles BIGINT
)
LANGUAGE sql
STABLE
AS $$
    SELECT
        e.nombre_estado,
        m.nombre_municipio,
        p.nombre_parroquia,
        COUNT(h.nombre_hito) AS total_hitos,
        COUNT(h.nombre_hito) FILTER (WHERE h.estado_operativo = 'disponible') AS hitos_disponibles
    FROM estado e
    JOIN municipio m
      ON m.nombre_estado = e.nombre_estado
    JOIN parroquia p
      ON p.nombre_estado = m.nombre_estado
     AND p.nombre_municipio = m.nombre_municipio
    LEFT JOIN hito h
      ON h.nombre_estado = p.nombre_estado
     AND h.nombre_municipio = p.nombre_municipio
     AND h.nombre_parroquia = p.nombre_parroquia
    WHERE (
        p_nombre_estado IS NULL
        OR LOWER(BTRIM(e.nombre_estado)) = LOWER(BTRIM(p_nombre_estado))
    )
      AND (
        p_nombre_municipio IS NULL
        OR LOWER(BTRIM(m.nombre_municipio)) = LOWER(BTRIM(p_nombre_municipio))
    )
    GROUP BY e.nombre_estado, m.nombre_municipio, p.nombre_parroquia
    ORDER BY e.nombre_estado, m.nombre_municipio, p.nombre_parroquia;
$$;


-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/03_functions/04_fn_distancia_3d_hitos.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Cálculo matemático tridimensional (Haversine + desnivel vertical)
--           usando exclusivamente tipos numéricos primitivos sin extensiones
--           espaciales (HU-11, HU-13).
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_calcular_distancia_3d_m(
    p_lat1 NUMERIC,
    p_lon1 NUMERIC,
    p_alt1 NUMERIC,
    p_lat2 NUMERIC,
    p_lon2 NUMERIC,
    p_alt2 NUMERIC
)
RETURNS NUMERIC(12,2)
LANGUAGE plpgsql
IMMUTABLE
STRICT
AS $$
DECLARE
    v_radio_tierra_m CONSTANT DOUBLE PRECISION := 6371000.0;
    v_lat1_rad       DOUBLE PRECISION;
    v_lat2_rad       DOUBLE PRECISION;
    v_dlat           DOUBLE PRECISION;
    v_dlon           DOUBLE PRECISION;
    v_a              DOUBLE PRECISION;
    v_d_horiz        DOUBLE PRECISION;
    v_dz             DOUBLE PRECISION;
BEGIN
    v_lat1_rad := radians(p_lat1::DOUBLE PRECISION);
    v_lat2_rad := radians(p_lat2::DOUBLE PRECISION);
    v_dlat     := radians((p_lat2 - p_lat1)::DOUBLE PRECISION);
    v_dlon     := radians((p_lon2 - p_lon1)::DOUBLE PRECISION);

    v_a := power(sin(v_dlat / 2.0), 2)
           + cos(v_lat1_rad) * cos(v_lat2_rad) * power(sin(v_dlon / 2.0), 2);
    v_a := LEAST(1.0::DOUBLE PRECISION, GREATEST(0.0::DOUBLE PRECISION, v_a));

    v_d_horiz := 2.0 * v_radio_tierra_m * asin(sqrt(v_a));
    v_dz      := (p_alt2 - p_alt1)::DOUBLE PRECISION;

    RETURN ROUND(sqrt(power(v_d_horiz, 2) + power(v_dz, 2))::NUMERIC, 2);
END;
$$;

CREATE OR REPLACE FUNCTION fn_buscar_hitos_cercanos_3d(
    p_latitud      NUMERIC,
    p_longitud     NUMERIC,
    p_altitud_msnm NUMERIC,
    p_radio_max_m  NUMERIC DEFAULT 1000.0
)
RETURNS TABLE (
    nombre_estado    VARCHAR,
    nombre_municipio VARCHAR,
    nombre_parroquia VARCHAR,
    nombre_hito      VARCHAR,
    latitud          NUMERIC,
    longitud         NUMERIC,
    altitud_msnm     NUMERIC,
    estado_operativo VARCHAR,
    diferencia_alt_m NUMERIC,
    distancia_3d_m   NUMERIC
)
LANGUAGE sql
STABLE
AS $$
    SELECT
        h.nombre_estado,
        h.nombre_municipio,
        h.nombre_parroquia,
        h.nombre_hito,
        h.latitud,
        h.longitud,
        h.altitud_msnm,
        h.estado_operativo,
        ABS(h.altitud_msnm - p_altitud_msnm) AS diferencia_alt_m,
        fn_calcular_distancia_3d_m(
            p_latitud, p_longitud, p_altitud_msnm,
            h.latitud, h.longitud, h.altitud_msnm
        ) AS distancia_3d_m
    FROM hito h
    WHERE fn_calcular_distancia_3d_m(
        p_latitud, p_longitud, p_altitud_msnm,
        h.latitud, h.longitud, h.altitud_msnm
    ) <= p_radio_max_m
    ORDER BY distancia_3d_m ASC, h.nombre_hito ASC;
$$;


-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/03_functions/05_fn_ficha_integral_hito.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Consulta de la ficha integral del hito (historia, categorías,
--           horarios, cronograma de eventos, RA y rutas) y catálogo filtrado
--           de hitos (HU-10, HU-14).
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_consultar_ficha_integral_hito(
    p_estado      VARCHAR,
    p_municipio   VARCHAR,
    p_parroquia   VARCHAR,
    p_nombre_hito VARCHAR
)
RETURNS TABLE (
    nombre_estado         VARCHAR,
    nombre_municipio      VARCHAR,
    nombre_parroquia      VARCHAR,
    nombre_hito           VARCHAR,
    latitud               NUMERIC,
    longitud              NUMERIC,
    altitud_msnm          NUMERIC,
    estado_operativo      VARCHAR,
    libre_acceso          BOOLEAN,
    historia              TEXT,
    categorias            TEXT[],
    horarios_visita       TEXT[],
    cronograma_eventos    TEXT[],
    cantidad_anclajes_ra  BIGINT,
    rutas_asociadas       TEXT[]
)
LANGUAGE sql
STABLE
AS $$
    SELECT
        h.nombre_estado,
        h.nombre_municipio,
        h.nombre_parroquia,
        h.nombre_hito,
        h.latitud,
        h.longitud,
        h.altitud_msnm,
        h.estado_operativo,
        h.libre_acceso,
        h.historia,
        COALESCE(
            (SELECT ARRAY_AGG(ch.categoria_hito ORDER BY ch.categoria_hito)
               FROM categoria_hito ch
              WHERE ch.nombre_estado = h.nombre_estado
                AND ch.nombre_municipio = h.nombre_municipio
                AND ch.nombre_parroquia = h.nombre_parroquia
                AND ch.nombre_hito = h.nombre_hito),
            ARRAY[]::TEXT[]
        ) AS categorias,
        COALESCE(
            (SELECT ARRAY_AGG(hh.horario_visita ORDER BY hh.horario_visita)
               FROM horario_hito hh
              WHERE hh.nombre_estado = h.nombre_estado
                AND hh.nombre_municipio = h.nombre_municipio
                AND hh.nombre_parroquia = h.nombre_parroquia
                AND hh.nombre_hito = h.nombre_hito),
            ARRAY[]::TEXT[]
        ) AS horarios_visita,
        COALESCE(
            (SELECT ARRAY_AGG(ce.cronograma_eventos ORDER BY ce.cronograma_eventos)
               FROM cronograma_evento_hito ce
              WHERE ce.nombre_estado = h.nombre_estado
                AND ce.nombre_municipio = h.nombre_municipio
                AND ce.nombre_parroquia = h.nombre_parroquia
                AND ce.nombre_hito = h.nombre_hito),
            ARRAY[]::TEXT[]
        ) AS cronograma_eventos,
        (SELECT COUNT(*)
           FROM punto_anclaje_ra ra
          WHERE ra.nombre_estado = h.nombre_estado
            AND ra.nombre_municipio = h.nombre_municipio
            AND ra.nombre_parroquia = h.nombre_parroquia
            AND ra.nombre_hito = h.nombre_hito) AS cantidad_anclajes_ra,
        COALESCE(
            (SELECT ARRAY_AGG(DISTINCT (pi.nombre_ruta || ' (' || pi.nombre_municipio_origen || ', ' || pi.nombre_estado_origen || ')')
                              ORDER BY (pi.nombre_ruta || ' (' || pi.nombre_municipio_origen || ', ' || pi.nombre_estado_origen || ')'))
               FROM paso_itinerario pi
              WHERE pi.nombre_estado_hito = h.nombre_estado
                AND pi.nombre_municipio_hito = h.nombre_municipio
                AND pi.nombre_parroquia_hito = h.nombre_parroquia
                AND pi.nombre_hito = h.nombre_hito),
            ARRAY[]::TEXT[]
        ) AS rutas_asociadas
    FROM hito h
    WHERE LOWER(BTRIM(h.nombre_estado)) = LOWER(BTRIM(p_estado))
      AND LOWER(BTRIM(h.nombre_municipio)) = LOWER(BTRIM(p_municipio))
      AND LOWER(BTRIM(h.nombre_parroquia)) = LOWER(BTRIM(p_parroquia))
      AND LOWER(BTRIM(h.nombre_hito)) = LOWER(BTRIM(p_nombre_hito));
$$;

CREATE OR REPLACE FUNCTION fn_catalogo_hitos(
    p_estado           VARCHAR DEFAULT NULL,
    p_municipio        VARCHAR DEFAULT NULL,
    p_parroquia        VARCHAR DEFAULT NULL,
    p_categoria        VARCHAR DEFAULT NULL,
    p_estado_operativo VARCHAR DEFAULT NULL
)
RETURNS TABLE (
    nombre_estado    VARCHAR,
    nombre_municipio VARCHAR,
    nombre_parroquia VARCHAR,
    nombre_hito      VARCHAR,
    latitud          NUMERIC,
    longitud         NUMERIC,
    altitud_msnm     NUMERIC,
    estado_operativo VARCHAR,
    libre_acceso     BOOLEAN,
    categorias       TEXT[]
)
LANGUAGE sql
STABLE
AS $$
    SELECT
        h.nombre_estado,
        h.nombre_municipio,
        h.nombre_parroquia,
        h.nombre_hito,
        h.latitud,
        h.longitud,
        h.altitud_msnm,
        h.estado_operativo,
        h.libre_acceso,
        COALESCE(
            ARRAY_AGG(DISTINCT ch.categoria_hito ORDER BY ch.categoria_hito)
            FILTER (WHERE ch.categoria_hito IS NOT NULL),
            ARRAY[]::TEXT[]
        ) AS categorias
    FROM hito h
    LEFT JOIN categoria_hito ch
      ON ch.nombre_estado = h.nombre_estado
     AND ch.nombre_municipio = h.nombre_municipio
     AND ch.nombre_parroquia = h.nombre_parroquia
     AND ch.nombre_hito = h.nombre_hito
    WHERE (p_estado IS NULL OR LOWER(BTRIM(h.nombre_estado)) = LOWER(BTRIM(p_estado)))
      AND (p_municipio IS NULL OR LOWER(BTRIM(h.nombre_municipio)) = LOWER(BTRIM(p_municipio)))
      AND (p_parroquia IS NULL OR LOWER(BTRIM(h.nombre_parroquia)) = LOWER(BTRIM(p_parroquia)))
      AND (p_estado_operativo IS NULL OR h.estado_operativo = p_estado_operativo)
      AND (
          p_categoria IS NULL
          OR EXISTS (
              SELECT 1
                FROM categoria_hito ch2
               WHERE ch2.nombre_estado = h.nombre_estado
                 AND ch2.nombre_municipio = h.nombre_municipio
                 AND ch2.nombre_parroquia = h.nombre_parroquia
                 AND ch2.nombre_hito = h.nombre_hito
                 AND ch2.categoria_hito = p_categoria
          )
      )
    GROUP BY
        h.nombre_estado,
        h.nombre_municipio,
        h.nombre_parroquia,
        h.nombre_hito,
        h.latitud,
        h.longitud,
        h.altitud_msnm,
        h.estado_operativo,
        h.libre_acceso
    ORDER BY h.nombre_estado, h.nombre_municipio, h.nombre_parroquia, h.nombre_hito;
$$;


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


-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/04_triggers/03_trg_completitud_territorial_rm01_rm02.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Triggers diferibles (DEFERRABLE INITIALLY DEFERRED) para garantizar
--           participación total de ESTADO en MUNICIPIO (RM-01) y de MUNICIPIO
--           en PARROQUIA (RM-02) al cierre de cada transacción (HU-09).
-- ============================================================================

CREATE OR REPLACE FUNCTION trg_fn_validar_rm01_estado_municipio()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_estado VARCHAR(100);
BEGIN
    IF TG_TABLE_NAME = 'estado' THEN
        v_estado := NEW.nombre_estado;
    ELSE
        v_estado := OLD.nombre_estado;
    END IF;

    IF EXISTS (SELECT 1 FROM estado e WHERE e.nombre_estado = v_estado)
       AND NOT EXISTS (SELECT 1 FROM municipio m WHERE m.nombre_estado = v_estado) THEN
        RAISE EXCEPTION 'RM-01 violada: el estado "%" debe poseer al menos un municipio registrado.', v_estado;
    END IF;

    RETURN NULL;
END;
$$;

CREATE OR REPLACE FUNCTION trg_fn_validar_rm02_municipio_parroquia()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_estado    VARCHAR(100);
    v_municipio VARCHAR(100);
BEGIN
    IF TG_TABLE_NAME = 'municipio' THEN
        v_estado    := NEW.nombre_estado;
        v_municipio := NEW.nombre_municipio;
    ELSE
        v_estado    := OLD.nombre_estado;
        v_municipio := OLD.nombre_municipio;
    END IF;

    IF EXISTS (
        SELECT 1 FROM municipio m
         WHERE m.nombre_estado = v_estado
           AND m.nombre_municipio = v_municipio
    ) AND NOT EXISTS (
        SELECT 1 FROM parroquia p
         WHERE p.nombre_estado = v_estado
           AND p.nombre_municipio = v_municipio
    ) THEN
        RAISE EXCEPTION 'RM-02 violada: el municipio "%, %" debe poseer al menos una parroquia registrada.', v_municipio, v_estado;
    END IF;

    RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_rm01_estado_posee_municipio ON estado;
CREATE CONSTRAINT TRIGGER trg_rm01_estado_posee_municipio
    AFTER INSERT OR UPDATE ON estado
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_validar_rm01_estado_municipio();

DROP TRIGGER IF EXISTS trg_rm01_municipio_minimo ON municipio;
CREATE CONSTRAINT TRIGGER trg_rm01_municipio_minimo
    AFTER DELETE OR UPDATE OF nombre_estado ON municipio
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_validar_rm01_estado_municipio();

DROP TRIGGER IF EXISTS trg_rm02_municipio_posee_parroquia ON municipio;
CREATE CONSTRAINT TRIGGER trg_rm02_municipio_posee_parroquia
    AFTER INSERT OR UPDATE ON municipio
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_validar_rm02_municipio_parroquia();

DROP TRIGGER IF EXISTS trg_rm02_parroquia_minima ON parroquia;
CREATE CONSTRAINT TRIGGER trg_rm02_parroquia_minima
    AFTER DELETE OR UPDATE OF nombre_estado, nombre_municipio ON parroquia
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_validar_rm02_municipio_parroquia();


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


-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/04_triggers/05_trg_coherencia_hito_acceso_estado.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Validación de limpieza textual, unicidad local (HU-12), bloqueo
--           de reapertura tras cierre permanente (HU-10), obligatoriedad de
--           al menos una categoría (HU-10) y coherencia de horarios cuando
--           libre_acceso = FALSE y estado_operativo = 'disponible' (HU-14).
-- ============================================================================

CREATE OR REPLACE FUNCTION trg_fn_coherencia_hito_before()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.nombre_estado    := BTRIM(NEW.nombre_estado);
    NEW.nombre_municipio := BTRIM(NEW.nombre_municipio);
    NEW.nombre_parroquia := BTRIM(NEW.nombre_parroquia);
    NEW.nombre_hito      := BTRIM(NEW.nombre_hito);
    NEW.historia         := BTRIM(NEW.historia);

    IF TG_OP = 'UPDATE' THEN
        IF OLD.estado_operativo = 'cerrado permanentemente'
           AND NEW.estado_operativo <> 'cerrado permanentemente' THEN
            RAISE EXCEPTION 'Un hito en estado "cerrado permanentemente" no puede reabrirse (hito: "%").', OLD.nombre_hito;
        END IF;
    END IF;

    IF TG_OP = 'INSERT' OR (
        LOWER(NEW.nombre_estado)    <> LOWER(OLD.nombre_estado) OR
        LOWER(NEW.nombre_municipio) <> LOWER(OLD.nombre_municipio) OR
        LOWER(NEW.nombre_parroquia) <> LOWER(OLD.nombre_parroquia) OR
        LOWER(NEW.nombre_hito)      <> LOWER(OLD.nombre_hito)
    ) THEN
        IF EXISTS (
            SELECT 1 FROM hito h
             WHERE LOWER(BTRIM(h.nombre_estado))    = LOWER(NEW.nombre_estado)
               AND LOWER(BTRIM(h.nombre_municipio)) = LOWER(NEW.nombre_municipio)
               AND LOWER(BTRIM(h.nombre_parroquia)) = LOWER(NEW.nombre_parroquia)
               AND LOWER(BTRIM(h.nombre_hito))      = LOWER(NEW.nombre_hito)
        ) THEN
            RAISE EXCEPTION 'HU-12 violada: ya existe un hito llamado "%" en la parroquia %, municipio %, %.',
                NEW.nombre_hito, NEW.nombre_parroquia, NEW.nombre_municipio, NEW.nombre_estado;
        END IF;
    END IF;

    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION trg_fn_validar_hito_horario_y_categoria()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_est VARCHAR(100);
    v_mun VARCHAR(100);
    v_par VARCHAR(100);
    v_hit VARCHAR(150);
    v_libre BOOLEAN;
    v_estado_op VARCHAR(30);
BEGIN
    IF TG_TABLE_NAME = 'hito' THEN
        v_est := NEW.nombre_estado;
        v_mun := NEW.nombre_municipio;
        v_par := NEW.nombre_parroquia;
        v_hit := NEW.nombre_hito;
    ELSE
        v_est := OLD.nombre_estado;
        v_mun := OLD.nombre_municipio;
        v_par := OLD.nombre_parroquia;
        v_hit := OLD.nombre_hito;
    END IF;

    SELECT h.libre_acceso, h.estado_operativo
      INTO v_libre, v_estado_op
      FROM hito h
     WHERE h.nombre_estado = v_est
       AND h.nombre_municipio = v_mun
       AND h.nombre_parroquia = v_par
       AND h.nombre_hito = v_hit;

    IF NOT FOUND THEN
        RETURN NULL;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM categoria_hito ch
         WHERE ch.nombre_estado = v_est
           AND ch.nombre_municipio = v_mun
           AND ch.nombre_parroquia = v_par
           AND ch.nombre_hito = v_hit
    ) THEN
        RAISE EXCEPTION 'HU-10 violada: el hito "%" debe tener al menos una categoría asignada en CATEGORIA_HITO.', v_hit;
    END IF;

    IF v_libre = FALSE AND v_estado_op = 'disponible' AND NOT EXISTS (
        SELECT 1 FROM horario_hito hh
         WHERE hh.nombre_estado = v_est
           AND hh.nombre_municipio = v_mun
           AND hh.nombre_parroquia = v_par
           AND hh.nombre_hito = v_hit
    ) THEN
        RAISE EXCEPTION 'HU-14 violada: el hito "%" no es de libre acceso y está disponible, por lo que requiere al menos un horario en HORARIO_HITO.', v_hit;
    END IF;

    RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_hito_coherencia_before ON hito;
CREATE TRIGGER trg_hito_coherencia_before
    BEFORE INSERT OR UPDATE ON hito
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_coherencia_hito_before();

DROP TRIGGER IF EXISTS trg_hito_horario_y_categoria ON hito;
CREATE CONSTRAINT TRIGGER trg_hito_horario_y_categoria
    AFTER INSERT OR UPDATE ON hito
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_validar_hito_horario_y_categoria();

DROP TRIGGER IF EXISTS trg_categoria_hito_minima ON categoria_hito;
CREATE CONSTRAINT TRIGGER trg_categoria_hito_minima
    AFTER DELETE OR UPDATE ON categoria_hito
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_validar_hito_horario_y_categoria();

DROP TRIGGER IF EXISTS trg_horario_hito_coherencia ON horario_hito;
CREATE CONSTRAINT TRIGGER trg_horario_hito_coherencia
    AFTER DELETE OR UPDATE ON horario_hito
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_validar_hito_horario_y_categoria();


-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/05_procedures/01_sp_registrar_visitante.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Registro transaccional de visitante y sus requerimientos de
--           accesibilidad física o sensorial (HU-01, HU-02).
-- ============================================================================

CREATE OR REPLACE PROCEDURE sp_registrar_visitante(
    p_cedula_pasaporte    VARCHAR,
    p_contrasena          TEXT,
    p_nombres             VARCHAR,
    p_apellidos           VARCHAR,
    p_pais_origen         VARCHAR,
    p_idioma_nativo       VARCHAR,
    p_telefono_emergencia VARCHAR,
    p_grupo_sanguineo     VARCHAR,
    p_correo_contacto     VARCHAR DEFAULT NULL,
    p_telefono_contacto   VARCHAR DEFAULT NULL,
    p_accesibilidades     TEXT[]  DEFAULT ARRAY[]::TEXT[]
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id  VARCHAR := UPPER(BTRIM(p_cedula_pasaporte));
    v_req TEXT;
BEGIN
    INSERT INTO visitante (
        cedula_pasaporte,
        contrasena,
        nombres,
        apellidos,
        pais_origen,
        idioma_nativo,
        telefono_emergencia,
        grupo_sanguineo,
        correo_contacto,
        telefono_contacto,
        estado_cuenta
    ) VALUES (
        v_id,
        p_contrasena,
        p_nombres,
        p_apellidos,
        p_pais_origen,
        p_idioma_nativo,
        p_telefono_emergencia,
        p_grupo_sanguineo,
        p_correo_contacto,
        p_telefono_contacto,
        'activa'
    );

    IF p_accesibilidades IS NOT NULL AND array_length(p_accesibilidades, 1) IS NOT NULL THEN
        FOREACH v_req IN ARRAY p_accesibilidades LOOP
            IF NULLIF(BTRIM(v_req), '') IS NOT NULL THEN
                INSERT INTO accesibilidad_visitante (cedula_pasaporte, req_accesibilidad)
                VALUES (v_id, BTRIM(v_req))
                ON CONFLICT DO NOTHING;
            END IF;
        END LOOP;
    END IF;
END;
$$;


-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/05_procedures/02_sp_registrar_guia_turistico.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Registro de guía/baqueano comunitario con especialidades, idiomas
--           y ruta inicial (HU-03, RM-13) y parametrización de idiomas y
--           zona geográfica asignada (HU-04).
-- ============================================================================

CREATE OR REPLACE PROCEDURE sp_registrar_guia_turistico(
    p_nro_rtn               VARCHAR,
    p_cod_licencia          VARCHAR,
    p_contrasena            TEXT,
    p_nombres               VARCHAR,
    p_apellidos             VARCHAR,
    p_acreditacion_oficial  VARCHAR,
    p_anos_trayectoria      INTEGER,
    p_tarifa_horaria        NUMERIC,
    p_nombre_estado_zona    VARCHAR,
    p_nombre_municipio_zona VARCHAR,
    p_especialidades        TEXT[],
    p_idiomas               TEXT[],
    p_estado_ruta_inicial   VARCHAR,
    p_municipio_ruta_inicial VARCHAR,
    p_nombre_ruta_inicial   VARCHAR,
    p_correo_contacto       VARCHAR DEFAULT NULL,
    p_telefono_contacto     VARCHAR DEFAULT NULL,
    p_telefono_emergencia   VARCHAR DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_rtn  VARCHAR := UPPER(BTRIM(p_nro_rtn));
    v_lic  VARCHAR := UPPER(BTRIM(p_cod_licencia));
    v_item TEXT;
BEGIN
    INSERT INTO guia_turistico (
        nro_rtn,
        cod_licencia,
        contrasena,
        nombres,
        apellidos,
        acreditacion_oficial,
        anos_trayectoria,
        tarifa_horaria,
        nombre_estado_zona,
        nombre_municipio_zona,
        correo_contacto,
        telefono_contacto,
        telefono_emergencia,
        estado_cuenta
    ) VALUES (
        v_rtn,
        v_lic,
        p_contrasena,
        p_nombres,
        p_apellidos,
        p_acreditacion_oficial,
        p_anos_trayectoria,
        p_tarifa_horaria,
        p_nombre_estado_zona,
        p_nombre_municipio_zona,
        p_correo_contacto,
        p_telefono_contacto,
        p_telefono_emergencia,
        'activa'
    );

    -- Adscripción obligatoria de ruta inicial para satisfacer RM-13 dentro de la transacción
    INSERT INTO acompana_ruta (
        nro_rtn,
        cod_licencia,
        nombre_estado_origen,
        nombre_municipio_origen,
        nombre_ruta
    ) VALUES (
        v_rtn,
        v_lic,
        BTRIM(p_estado_ruta_inicial),
        BTRIM(p_municipio_ruta_inicial),
        BTRIM(p_nombre_ruta_inicial)
    );

    IF p_especialidades IS NOT NULL AND array_length(p_especialidades, 1) IS NOT NULL THEN
        FOREACH v_item IN ARRAY p_especialidades LOOP
            IF NULLIF(BTRIM(v_item), '') IS NOT NULL THEN
                INSERT INTO especialidad_guia (nro_rtn, cod_licencia, especialidades)
                VALUES (v_rtn, v_lic, BTRIM(v_item))
                ON CONFLICT DO NOTHING;
            END IF;
        END LOOP;
    END IF;

    IF p_idiomas IS NOT NULL AND array_length(p_idiomas, 1) IS NOT NULL THEN
        FOREACH v_item IN ARRAY p_idiomas LOOP
            IF NULLIF(BTRIM(v_item), '') IS NOT NULL THEN
                INSERT INTO idioma_guia (nro_rtn, cod_licencia, idiomas_dominados)
                VALUES (v_rtn, v_lic, BTRIM(v_item))
                ON CONFLICT DO NOTHING;
            END IF;
        END LOOP;
    END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_parametrizar_idiomas_zona_guia(
    p_nro_rtn               VARCHAR,
    p_cod_licencia          VARCHAR,
    p_nombre_estado_zona    VARCHAR,
    p_nombre_municipio_zona VARCHAR,
    p_idiomas               TEXT[],
    p_especialidades        TEXT[] DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_rtn  VARCHAR := UPPER(BTRIM(p_nro_rtn));
    v_lic  VARCHAR := UPPER(BTRIM(p_cod_licencia));
    v_item TEXT;
BEGIN
    UPDATE guia_turistico
       SET nombre_estado_zona    = BTRIM(p_nombre_estado_zona),
           nombre_municipio_zona = BTRIM(p_nombre_municipio_zona)
     WHERE nro_rtn = v_rtn
       AND cod_licencia = v_lic;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Guía turístico (RTN %, Licencia %) no encontrado.', v_rtn, v_lic;
    END IF;

    IF p_idiomas IS NOT NULL THEN
        DELETE FROM idioma_guia
         WHERE nro_rtn = v_rtn AND cod_licencia = v_lic;

        IF array_length(p_idiomas, 1) IS NOT NULL THEN
            FOREACH v_item IN ARRAY p_idiomas LOOP
                IF NULLIF(BTRIM(v_item), '') IS NOT NULL THEN
                    INSERT INTO idioma_guia (nro_rtn, cod_licencia, idiomas_dominados)
                    VALUES (v_rtn, v_lic, BTRIM(v_item))
                    ON CONFLICT DO NOTHING;
                END IF;
            END LOOP;
        END IF;
    END IF;

    IF p_especialidades IS NOT NULL THEN
        DELETE FROM especialidad_guia
         WHERE nro_rtn = v_rtn AND cod_licencia = v_lic;

        IF array_length(p_especialidades, 1) IS NOT NULL THEN
            FOREACH v_item IN ARRAY p_especialidades LOOP
                IF NULLIF(BTRIM(v_item), '') IS NOT NULL THEN
                    INSERT INTO especialidad_guia (nro_rtn, cod_licencia, especialidades)
                    VALUES (v_rtn, v_lic, BTRIM(v_item))
                    ON CONFLICT DO NOTHING;
                END IF;
            END LOOP;
        END IF;
    END IF;
END;
$$;


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


-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/05_procedures/06_sp_actualizar_perfil_usuario.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Actualización de contacto, contraseña, teléfono de emergencia y
--           accesibilidad de los actores del sistema (HU-02, HU-08).
-- ============================================================================

CREATE OR REPLACE PROCEDURE sp_actualizar_perfil_visitante(
    p_cedula_pasaporte    VARCHAR,
    p_correo_contacto     VARCHAR DEFAULT NULL,
    p_telefono_contacto   VARCHAR DEFAULT NULL,
    p_telefono_emergencia VARCHAR DEFAULT NULL,
    p_idioma_nativo       VARCHAR DEFAULT NULL,
    p_grupo_sanguineo     VARCHAR DEFAULT NULL,
    p_nueva_contrasena    TEXT    DEFAULT NULL,
    p_accesibilidades     TEXT[]  DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id  VARCHAR := UPPER(BTRIM(p_cedula_pasaporte));
    v_req TEXT;
BEGIN
    UPDATE visitante
       SET correo_contacto     = COALESCE(NULLIF(LOWER(BTRIM(p_correo_contacto)), ''), correo_contacto),
           telefono_contacto   = COALESCE(NULLIF(BTRIM(p_telefono_contacto), ''), telefono_contacto),
           telefono_emergencia = COALESCE(NULLIF(BTRIM(p_telefono_emergencia), ''), telefono_emergencia),
           idioma_nativo       = COALESCE(NULLIF(BTRIM(p_idioma_nativo), ''), idioma_nativo),
           grupo_sanguineo     = COALESCE(NULLIF(UPPER(BTRIM(p_grupo_sanguineo)), ''), grupo_sanguineo),
           contrasena          = COALESCE(NULLIF(p_nueva_contrasena, ''), contrasena)
     WHERE cedula_pasaporte = v_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Visitante % no encontrado.', v_id;
    END IF;

    IF p_accesibilidades IS NOT NULL THEN
        DELETE FROM accesibilidad_visitante WHERE cedula_pasaporte = v_id;
        IF array_length(p_accesibilidades, 1) IS NOT NULL THEN
            FOREACH v_req IN ARRAY p_accesibilidades LOOP
                IF NULLIF(BTRIM(v_req), '') IS NOT NULL THEN
                    INSERT INTO accesibilidad_visitante (cedula_pasaporte, req_accesibilidad)
                    VALUES (v_id, BTRIM(v_req))
                    ON CONFLICT DO NOTHING;
                END IF;
            END LOOP;
        END IF;
    END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_actualizar_contacto_actor(
    p_tipo_actor          VARCHAR,
    p_identificador       VARCHAR,
    p_cod_licencia        VARCHAR DEFAULT NULL,
    p_correo_contacto     VARCHAR DEFAULT NULL,
    p_telefono_contacto   VARCHAR DEFAULT NULL,
    p_telefono_emergencia VARCHAR DEFAULT NULL,
    p_nueva_contrasena    TEXT    DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_tipo VARCHAR := UPPER(BTRIM(p_tipo_actor));
    v_id   VARCHAR := UPPER(BTRIM(p_identificador));
    v_lic  VARCHAR := NULLIF(UPPER(BTRIM(p_cod_licencia)), '');
BEGIN
    IF v_tipo = 'VISITANTE' THEN
        UPDATE visitante
           SET correo_contacto     = COALESCE(NULLIF(LOWER(BTRIM(p_correo_contacto)), ''), correo_contacto),
               telefono_contacto   = COALESCE(NULLIF(BTRIM(p_telefono_contacto), ''), telefono_contacto),
               telefono_emergencia = COALESCE(NULLIF(BTRIM(p_telefono_emergencia), ''), telefono_emergencia),
               contrasena          = COALESCE(NULLIF(p_nueva_contrasena, ''), contrasena)
         WHERE cedula_pasaporte = v_id;
    ELSIF v_tipo = 'GUIA_TURISTICO' THEN
        IF v_lic IS NULL THEN
            RAISE EXCEPTION 'Para GUIA_TURISTICO debe suministrar p_cod_licencia.';
        END IF;
        UPDATE guia_turistico
           SET correo_contacto     = COALESCE(NULLIF(LOWER(BTRIM(p_correo_contacto)), ''), correo_contacto),
               telefono_contacto   = COALESCE(NULLIF(BTRIM(p_telefono_contacto), ''), telefono_contacto),
               telefono_emergencia = COALESCE(NULLIF(BTRIM(p_telefono_emergencia), ''), telefono_emergencia),
               contrasena          = COALESCE(NULLIF(p_nueva_contrasena, ''), contrasena)
         WHERE nro_rtn = v_id AND cod_licencia = v_lic;
    ELSIF v_tipo = 'COMERCIO_ALIADO' THEN
        UPDATE comercio_aliado
           SET correo_contacto     = COALESCE(NULLIF(LOWER(BTRIM(p_correo_contacto)), ''), correo_contacto),
               telefono_contacto   = COALESCE(NULLIF(BTRIM(p_telefono_contacto), ''), telefono_contacto),
               telefono_emergencia = COALESCE(NULLIF(BTRIM(p_telefono_emergencia), ''), telefono_emergencia),
               contrasena          = COALESCE(NULLIF(p_nueva_contrasena, ''), contrasena)
         WHERE rif = v_id;
    ELSIF v_tipo = 'ENTE_PUBLICO' THEN
        UPDATE ente_publico
           SET correo_contacto     = COALESCE(NULLIF(LOWER(BTRIM(p_correo_contacto)), ''), correo_contacto),
               telefono_contacto   = COALESCE(NULLIF(BTRIM(p_telefono_contacto), ''), telefono_contacto),
               telefono_emergencia = COALESCE(NULLIF(BTRIM(p_telefono_emergencia), ''), telefono_emergencia),
               contrasena          = COALESCE(NULLIF(p_nueva_contrasena, ''), contrasena)
         WHERE rif_gubernamental = v_id;
    ELSE
        RAISE EXCEPTION 'Tipo de actor inválido: "%".', p_tipo_actor;
    END IF;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'No se encontró el actor % con identificador %.', v_tipo, v_id;
    END IF;
END;
$$;


-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/05_procedures/07_sp_registrar_territorio.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Registro atómico e idempotente de la jerarquía político-territorial
--           Estado -> Municipio -> Parroquia cumpliendo RM-01 y RM-02 (HU-09).
-- ============================================================================

CREATE OR REPLACE PROCEDURE sp_registrar_jerarquia_territorial(
    p_nombre_estado    VARCHAR,
    p_nombre_municipio VARCHAR,
    p_nombre_parroquia VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_est VARCHAR(100) := BTRIM(p_nombre_estado);
    v_mun VARCHAR(100) := BTRIM(p_nombre_municipio);
    v_par VARCHAR(100) := BTRIM(p_nombre_parroquia);
BEGIN
    INSERT INTO estado (nombre_estado)
    VALUES (v_est)
    ON CONFLICT DO NOTHING;

    INSERT INTO municipio (nombre_estado, nombre_municipio)
    VALUES (v_est, v_mun)
    ON CONFLICT DO NOTHING;

    INSERT INTO parroquia (nombre_estado, nombre_municipio, nombre_parroquia)
    VALUES (v_est, v_mun, v_par)
    ON CONFLICT DO NOTHING;
END;
$$;


-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/05_procedures/08_sp_registrar_y_actualizar_hito.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Registro integral de hitos en coordenadas 3D con categorías,
--           horarios y cronograma de eventos (HU-10 a HU-14), más
--           actualización de estado operativo y agenda cultural.
-- ============================================================================

CREATE OR REPLACE PROCEDURE sp_registrar_hito_completo(
    p_nombre_estado      VARCHAR,
    p_nombre_municipio   VARCHAR,
    p_nombre_parroquia   VARCHAR,
    p_nombre_hito        VARCHAR,
    p_latitud            NUMERIC,
    p_longitud           NUMERIC,
    p_altitud_msnm       NUMERIC,
    p_estado_operativo   VARCHAR,
    p_libre_acceso       BOOLEAN,
    p_historia           TEXT,
    p_categorias         TEXT[],
    p_horarios           TEXT[] DEFAULT ARRAY[]::TEXT[],
    p_cronograma_eventos TEXT[] DEFAULT ARRAY[]::TEXT[]
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_est  VARCHAR(100) := BTRIM(p_nombre_estado);
    v_mun  VARCHAR(100) := BTRIM(p_nombre_municipio);
    v_par  VARCHAR(100) := BTRIM(p_nombre_parroquia);
    v_hit  VARCHAR(150) := BTRIM(p_nombre_hito);
    v_item TEXT;
BEGIN
    INSERT INTO hito (
        nombre_estado,
        nombre_municipio,
        nombre_parroquia,
        nombre_hito,
        latitud,
        longitud,
        altitud_msnm,
        estado_operativo,
        libre_acceso,
        historia
    ) VALUES (
        v_est,
        v_mun,
        v_par,
        v_hit,
        p_latitud,
        p_longitud,
        p_altitud_msnm,
        LOWER(BTRIM(p_estado_operativo)),
        p_libre_acceso,
        p_historia
    );

    IF p_categorias IS NOT NULL AND array_length(p_categorias, 1) IS NOT NULL THEN
        FOREACH v_item IN ARRAY p_categorias LOOP
            IF NULLIF(BTRIM(v_item), '') IS NOT NULL THEN
                INSERT INTO categoria_hito (
                    nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, categoria_hito
                ) VALUES (v_est, v_mun, v_par, v_hit, LOWER(BTRIM(v_item)))
                ON CONFLICT DO NOTHING;
            END IF;
        END LOOP;
    END IF;

    IF p_horarios IS NOT NULL AND array_length(p_horarios, 1) IS NOT NULL THEN
        FOREACH v_item IN ARRAY p_horarios LOOP
            IF NULLIF(BTRIM(v_item), '') IS NOT NULL THEN
                INSERT INTO horario_hito (
                    nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, horario_visita
                ) VALUES (v_est, v_mun, v_par, v_hit, BTRIM(v_item))
                ON CONFLICT DO NOTHING;
            END IF;
        END LOOP;
    END IF;

    IF p_cronograma_eventos IS NOT NULL AND array_length(p_cronograma_eventos, 1) IS NOT NULL THEN
        FOREACH v_item IN ARRAY p_cronograma_eventos LOOP
            IF NULLIF(BTRIM(v_item), '') IS NOT NULL THEN
                INSERT INTO cronograma_evento_hito (
                    nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, cronograma_eventos
                ) VALUES (v_est, v_mun, v_par, v_hit, BTRIM(v_item))
                ON CONFLICT DO NOTHING;
            END IF;
        END LOOP;
    END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_actualizar_estado_operativo_hito(
    p_nombre_estado    VARCHAR,
    p_nombre_municipio VARCHAR,
    p_nombre_parroquia VARCHAR,
    p_nombre_hito      VARCHAR,
    p_nuevo_estado     VARCHAR,
    p_nuevo_evento     TEXT   DEFAULT NULL,
    p_nuevos_horarios  TEXT[] DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_est  VARCHAR(100) := BTRIM(p_nombre_estado);
    v_mun  VARCHAR(100) := BTRIM(p_nombre_municipio);
    v_par  VARCHAR(100) := BTRIM(p_nombre_parroquia);
    v_hit  VARCHAR(150) := BTRIM(p_nombre_hito);
    v_item TEXT;
BEGIN
    UPDATE hito
       SET estado_operativo = LOWER(BTRIM(p_nuevo_estado))
     WHERE nombre_estado = v_est
       AND nombre_municipio = v_mun
       AND nombre_parroquia = v_par
       AND nombre_hito = v_hit;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Hito "%" en %, %, % no encontrado.', v_hit, v_par, v_mun, v_est;
    END IF;

    IF NULLIF(BTRIM(p_nuevo_evento), '') IS NOT NULL THEN
        INSERT INTO cronograma_evento_hito (
            nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, cronograma_eventos
        ) VALUES (v_est, v_mun, v_par, v_hit, BTRIM(p_nuevo_evento))
        ON CONFLICT DO NOTHING;
    END IF;

    IF p_nuevos_horarios IS NOT NULL THEN
        DELETE FROM horario_hito
         WHERE nombre_estado = v_est
           AND nombre_municipio = v_mun
           AND nombre_parroquia = v_par
           AND nombre_hito = v_hit;

        IF array_length(p_nuevos_horarios, 1) IS NOT NULL THEN
            FOREACH v_item IN ARRAY p_nuevos_horarios LOOP
                IF NULLIF(BTRIM(v_item), '') IS NOT NULL THEN
                    INSERT INTO horario_hito (
                        nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, horario_visita
                    ) VALUES (v_est, v_mun, v_par, v_hit, BTRIM(v_item))
                    ON CONFLICT DO NOTHING;
                END IF;
            END LOOP;
        END IF;
    END IF;
END;
$$;


-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/06_security/01_roles_y_privilegios.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Seguridad lógica en PostgreSQL: roles de negocio, privilegios de
--           sistema y privilegios granulares sobre tablas, secuencias,
--           funciones y procedimientos almacenados.
-- ============================================================================

-- 1. Creación idempotente de roles funcionales del dominio
DO $$
DECLARE
    v_rol TEXT;
    v_roles TEXT[] := ARRAY[
        'rol_admin_sistema',
        'rol_admin_patrimonial',
        'rol_visitante',
        'rol_guia_turistico',
        'rol_comercio_aliado',
        'rol_ente_publico'
    ];
BEGIN
    FOREACH v_rol IN ARRAY v_roles LOOP
        IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = v_rol) THEN
            EXECUTE format('CREATE ROLE %I NOLOGIN', v_rol);
        END IF;
    END LOOP;
END;
$$;

-- 2. Privilegios de acceso al esquema y secuencias
GRANT USAGE ON SCHEMA public TO
    rol_admin_sistema,
    rol_admin_patrimonial,
    rol_visitante,
    rol_guia_turistico,
    rol_comercio_aliado,
    rol_ente_publico;

GRANT USAGE, SELECT ON SEQUENCE reporte_incidencia_nro_reporte_seq TO
    rol_admin_sistema,
    rol_visitante,
    rol_guia_turistico,
    rol_ente_publico;

-- 3. Privilegios sobre objetos para ROL_VISITANTE (HU-01, HU-02, HU-08, HU-14 y consultas)
GRANT SELECT ON
    estado, municipio, parroquia, hito, categoria_hito, horario_hito, cronograma_evento_hito,
    punto_anclaje_ra, via, modo_recorrido_via, parada_transporte, parada_cercana_hito,
    ruta_turistica, ruta_fija, guia_turistico, especialidad_guia, idioma_guia,
    acompana_ruta, comercio_aliado, experiencia_promocional, experiencia_incluye_hito,
    evaluacion_experiencia, reporte_incidencia
TO rol_visitante;

GRANT SELECT, INSERT, UPDATE ON visitante TO rol_visitante;
GRANT SELECT, INSERT, UPDATE, DELETE ON accesibilidad_visitante TO rol_visitante;
GRANT SELECT, INSERT, UPDATE, DELETE ON ruta_dinamica, paso_itinerario TO rol_visitante;
GRANT SELECT, INSERT ON visita_hito, recorrido_realizado, evaluacion_experiencia, credencial_acceso, reporte_incidencia TO rol_visitante;
GRANT UPDATE (fecha_hora_fin, completado) ON recorrido_realizado TO rol_visitante;

-- 4. Privilegios sobre objetos para ROL_GUIA_TURISTICO (HU-03, HU-04, HU-08)
GRANT SELECT ON
    estado, municipio, parroquia, hito, categoria_hito, horario_hito, cronograma_evento_hito,
    punto_anclaje_ra, via, modo_recorrido_via, parada_transporte, parada_cercana_hito,
    ruta_turistica, ruta_fija, experiencia_promocional, experiencia_incluye_hito,
    credencial_acceso, reporte_incidencia
TO rol_guia_turistico;

GRANT SELECT, INSERT, UPDATE ON guia_turistico TO rol_guia_turistico;
GRANT SELECT, INSERT, UPDATE, DELETE ON especialidad_guia, idioma_guia, acompana_ruta TO rol_guia_turistico;
GRANT INSERT ON reporte_incidencia TO rol_guia_turistico;
GRANT UPDATE (estado_pase) ON credencial_acceso TO rol_guia_turistico;

-- 5. Privilegios sobre objetos para ROL_COMERCIO_ALIADO (HU-05, HU-08)
GRANT SELECT ON
    estado, municipio, parroquia, hito, ruta_turistica, guia_turistico, acompana_ruta
TO rol_comercio_aliado;

GRANT SELECT, INSERT, UPDATE ON comercio_aliado TO rol_comercio_aliado;
GRANT SELECT, INSERT, UPDATE ON experiencia_promocional, experiencia_incluye_hito TO rol_comercio_aliado;
GRANT SELECT, UPDATE (estado_pase) ON credencial_acceso TO rol_comercio_aliado;

-- 6. Privilegios sobre objetos para ROL_ENTE_PUBLICO (HU-06, HU-08, incidencias y hitos)
GRANT SELECT ON
    estado, municipio, parroquia, via, modo_recorrido_via, parada_transporte,
    ruta_turistica, ruta_fija, visitante, guia_turistico, comercio_aliado
TO rol_ente_publico;

GRANT SELECT, INSERT, UPDATE ON ente_publico TO rol_ente_publico;
GRANT SELECT, INSERT, UPDATE ON hito, categoria_hito, horario_hito, cronograma_evento_hito TO rol_ente_publico;
GRANT SELECT, INSERT, UPDATE ON reporte_incidencia TO rol_ente_publico;

-- 7. Privilegios para ROL_ADMIN_PATRIMONIAL (HU-09 a HU-14)
GRANT SELECT, INSERT, UPDATE, DELETE ON
    estado, municipio, parroquia, hito, categoria_hito, horario_hito,
    cronograma_evento_hito, punto_anclaje_ra
TO rol_admin_patrimonial;
GRANT SELECT ON ruta_turistica, ruta_fija, paso_itinerario, via, parada_transporte TO rol_admin_patrimonial;

-- 8. Privilegios para ROL_ADMIN_SISTEMA (HU-07 y supervisión general)
GRANT SELECT ON ALL TABLES IN SCHEMA public TO rol_admin_sistema;
GRANT UPDATE (estado_cuenta) ON visitante, guia_turistico, comercio_aliado, ente_publico TO rol_admin_sistema;

-- 9. Privilegios de ejecución sobre funciones y procedimientos (HU-01 a HU-14)
GRANT EXECUTE ON FUNCTION
    fn_hash_contrasena(TEXT),
    fn_autenticar_usuario(VARCHAR, TEXT, VARCHAR),
    fn_obtener_perfil_visitante(VARCHAR),
    fn_buscar_guias_disponibles(VARCHAR, VARCHAR, VARCHAR, VARCHAR),
    fn_listar_jerarquia_territorial(VARCHAR, VARCHAR),
    fn_calcular_distancia_3d_m(NUMERIC, NUMERIC, NUMERIC, NUMERIC, NUMERIC, NUMERIC),
    fn_buscar_hitos_cercanos_3d(NUMERIC, NUMERIC, NUMERIC, NUMERIC),
    fn_consultar_ficha_integral_hito(VARCHAR, VARCHAR, VARCHAR, VARCHAR),
    fn_catalogo_hitos(VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR)
TO rol_admin_sistema, rol_admin_patrimonial, rol_visitante, rol_guia_turistico, rol_comercio_aliado, rol_ente_publico;

GRANT EXECUTE ON PROCEDURE
    sp_registrar_visitante(VARCHAR, TEXT, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, TEXT[]),
    sp_actualizar_perfil_visitante(VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, TEXT, TEXT[])
TO rol_visitante, rol_admin_sistema;

GRANT EXECUTE ON PROCEDURE
    sp_registrar_guia_turistico(VARCHAR, VARCHAR, TEXT, VARCHAR, VARCHAR, VARCHAR, INTEGER, NUMERIC, VARCHAR, VARCHAR, TEXT[], TEXT[], VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR),
    sp_parametrizar_idiomas_zona_guia(VARCHAR, VARCHAR, VARCHAR, VARCHAR, TEXT[], TEXT[])
TO rol_guia_turistico, rol_admin_sistema;

GRANT EXECUTE ON PROCEDURE
    sp_registrar_comercio_aliado(VARCHAR, TEXT, VARCHAR, VARCHAR, INTEGER, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR)
TO rol_comercio_aliado, rol_admin_sistema;

GRANT EXECUTE ON PROCEDURE
    sp_registrar_ente_publico(VARCHAR, TEXT, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR)
TO rol_ente_publico, rol_admin_sistema;

GRANT EXECUTE ON PROCEDURE
    sp_actualizar_contacto_actor(VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, TEXT)
TO rol_visitante, rol_guia_turistico, rol_comercio_aliado, rol_ente_publico, rol_admin_sistema;

GRANT EXECUTE ON PROCEDURE
    sp_cambiar_estado_cuenta_usuario(VARCHAR, VARCHAR, VARCHAR, VARCHAR, TEXT)
TO rol_admin_sistema;

GRANT EXECUTE ON PROCEDURE
    sp_registrar_jerarquia_territorial(VARCHAR, VARCHAR, VARCHAR),
    sp_registrar_hito_completo(VARCHAR, VARCHAR, VARCHAR, VARCHAR, NUMERIC, NUMERIC, NUMERIC, VARCHAR, BOOLEAN, TEXT, TEXT[], TEXT[], TEXT[]),
    sp_actualizar_estado_operativo_hito(VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, TEXT, TEXT[])
TO rol_admin_patrimonial, rol_ente_publico, rol_admin_sistema;

-- 10. Concesión integral al usuario técnico de la aplicación (Spring Boot / db_user)
GRANT rol_admin_sistema, rol_admin_patrimonial, rol_visitante, rol_guia_turistico, rol_comercio_aliado, rol_ente_publico TO db_user;
GRANT ALL PRIVILEGES ON SCHEMA public TO db_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO db_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO db_user;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO db_user;
GRANT ALL PRIVILEGES ON ALL PROCEDURES IN SCHEMA public TO db_user;


-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/07_seeds/01_datos_prueba_venezuela.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Carga realista y coherente de datos de prueba en el contexto
--           turístico y urbano venezolano cubriendo las 31 tablas del esquema.
-- ============================================================================

-- 1. Jerarquía Político-Territorial (incluye homónimos en distintos estados - HU-09)
CALL sp_registrar_jerarquia_territorial('Distrito Capital', 'Libertador', 'Catedral');
CALL sp_registrar_jerarquia_territorial('Distrito Capital', 'Libertador', 'Altagracia');
CALL sp_registrar_jerarquia_territorial('Distrito Capital', 'Libertador', 'San José');
CALL sp_registrar_jerarquia_territorial('Miranda', 'Chacao', 'Chacao');
CALL sp_registrar_jerarquia_territorial('Miranda', 'Sucre', 'Petare');
CALL sp_registrar_jerarquia_territorial('Mérida', 'Libertador', 'El Sagrario');
CALL sp_registrar_jerarquia_territorial('Falcón', 'Miranda', 'Santa Ana');
CALL sp_registrar_jerarquia_territorial('Sucre', 'Sucre', 'Santa Inés');
CALL sp_registrar_jerarquia_territorial('La Guaira', 'Vargas', 'Macuto');

-- 2. Hitos Turísticos y Culturales en 3D (HU-10 a HU-14)
CALL sp_registrar_hito_completo(
    'Distrito Capital', 'Libertador', 'Catedral',
    'Casa Natal del Libertador',
    10.506080, -66.912690, 908.00,
    'disponible', FALSE,
    'Residencia colonial del siglo XVIII donde nació Simón Bolívar el 24 de julio de 1783. Conserva piezas originales de la época independentista y murales de Tito Salas.',
    ARRAY['historico', 'recreativo'],
    ARRAY['Martes a Domingo 09:00-16:30'],
    ARRAY['Recorrido guiado teatralizado: Sábados 11:00', 'Tertulia Bolivariana: Jueves 15:00']
);

CALL sp_registrar_hito_completo(
    'Distrito Capital', 'Libertador', 'Catedral',
    'Plaza Bolívar de Caracas',
    10.506180, -66.914630, 910.00,
    'disponible', TRUE,
    'Plaza mayor fundacional de Santiago de León de Caracas (1567), centro neurálgico histórico rodeado por la Catedral de Caracas, el Palacio Municipal y la Casa Amarilla.',
    ARRAY['historico', 'recreativo', 'descanso'],
    ARRAY['Acceso libre 24 horas'],
    ARRAY['Retreta dominical de la Banda Marcial: Domingos 10:00']
);

-- Prueba explícita de HU-13: Misma latitud y longitud que Plaza Bolívar de Caracas, distinta elevación/altitud
CALL sp_registrar_hito_completo(
    'Distrito Capital', 'Libertador', 'Catedral',
    'Estatua Ecuestre del Libertador',
    10.506180, -66.914630, 914.50,
    'disponible', TRUE,
    'Monumento en bronce inaugurado en 1874 sobre pedestal escalonado en el centro exacto de la Plaza Bolívar de Caracas, obra del escultor Adamo Tadolini.',
    ARRAY['historico'],
    ARRAY['Acceso libre 24 horas'],
    ARRAY['Ofrenda floral conmemorativa: 24 de julio 08:30']
);

CALL sp_registrar_hito_completo(
    'Distrito Capital', 'Libertador', 'Altagracia',
    'Panteón Nacional',
    10.511750, -66.911450, 935.00,
    'disponible', FALSE,
    'Santuario cívico nacional ubicado en el antiguo solar de la Iglesia de la Santísima Trinidad, donde reposan los restos de Simón Bolívar y próceres de la República.',
    ARRAY['historico', 'religioso'],
    ARRAY['Martes a Domingo 09:00-16:00'],
    ARRAY['Cambio de guardia de honor: Sábados 12:00']
);

CALL sp_registrar_hito_completo(
    'Distrito Capital', 'Libertador', 'San José',
    'Museo de Arte Colonial Quinta de Anauco',
    10.508200, -66.899400, 920.00,
    'en restauracion', FALSE,
    'Hacienda cafetalera del siglo XVIII en San Bernardino que exhibe mobiliario, platería y arte sacro del período colonial venezolano.',
    ARRAY['historico', 'recreativo'],
    ARRAY['Miércoles a Domingo 09:30-16:00 (sujeto a obra)'],
    ARRAY['Jornada de conservación preventiva de techos coloniales']
);

CALL sp_registrar_hito_completo(
    'Miranda', 'Chacao', 'Chacao',
    'Estación Warairarepano Pico Ávila',
    10.543200, -66.885500, 2105.00,
    'disponible', FALSE,
    'Estación superior del teleférico de Caracas en la cima del Parque Nacional Warairarepano, punto de partida para senderismo ecológico y gastronomía de montaña.',
    ARRAY['natural', 'recreativo', 'gastronomico'],
    ARRAY['Miércoles a Domingo 09:00-19:00'],
    ARRAY['Feria artesanal y chocolate caliente: Viernes a Domingo']
);

-- Segundo ejemplo HU-13: Misma coordenada horizontal en la cima del Ávila con distinta altitud
CALL sp_registrar_hito_completo(
    'Miranda', 'Chacao', 'Chacao',
    'Mirador Circular Hotel Humboldt',
    10.543200, -66.885500, 2140.00,
    'disponible', FALSE,
    'Emblemática torre cilíndrica modernista diseñada por Tomás José Sanabria en 1956, con vista panorámica de 360 grados sobre Caracas y el mar Caribe.',
    ARRAY['historico', 'recreativo'],
    ARRAY['Jueves a Domingo 10:00-18:00'],
    ARRAY['Visita arquitectónica comentada: Sábados 15:00']
);

CALL sp_registrar_hito_completo(
    'Falcón', 'Miranda', 'Santa Ana',
    'Catedral Basílica de Santa Ana de Coro',
    11.409167, -69.676389, 21.00,
    'disponible', FALSE,
    'Templo católico más antiguo de Venezuela en pie (iniciado en 1583), núcleo del Patrimonio Cultural de la Humanidad declarado por la UNESCO en Coro.',
    ARRAY['religioso', 'historico'],
    ARRAY['Lunes a Domingo 08:00-12:00 y 15:00-18:30'],
    ARRAY['Misa patrimonial y concierto coral: Domingos 10:00']
);

CALL sp_registrar_hito_completo(
    'Mérida', 'Libertador', 'El Sagrario',
    'Basílica Menor Inmaculada Concepción de Mérida',
    8.597778, -71.144167, 1630.00,
    'disponible', TRUE,
    'Catedral neobarroca inspirada en la Catedral de Toledo, ubicada frente a la Plaza Bolívar de Mérida en plena cordillera andina.',
    ARRAY['religioso', 'historico'],
    ARRAY['Lunes a Domingo 07:30-19:00'],
    ARRAY['Recorrido de vitrales y cripta: Sábados 16:00']
);

CALL sp_registrar_hito_completo(
    'Sucre', 'Sucre', 'Santa Inés',
    'Castillo San Antonio de la Eminencia',
    10.464444, -64.171111, 68.00,
    'disponible', FALSE,
    'Fortificación militar colonial de planta estrellada construida en piedra coralina entre 1659 y 1686 para defender la ciudad de Cumaná y el Golfo de Cariaco.',
    ARRAY['historico', 'recreativo'],
    ARRAY['Martes a Domingo 09:00-17:00'],
    ARRAY['Atardecer histórico sobre el Golfo de Cariaco: Viernes 17:00']
);

CALL sp_registrar_hito_completo(
    'Miranda', 'Sucre', 'Petare',
    'Centro Histórico y Museo Bárbaro Rivas',
    10.476944, -66.803889, 855.00,
    'disponible', FALSE,
    'Conjunto colonial de calles empedradas en lo alto de Petare, sede del Museo de Arte Popular Bárbaro Rivas y la Iglesia Dulce Nombre de Jesús.',
    ARRAY['historico', 'recreativo'],
    ARRAY['Martes a Sábado 09:30-16:00'],
    ARRAY['Taller de pintura ingenua comunitaria: Sábados 10:30']
);

-- 3. Puntos de Anclaje de Realidad Aumentada
INSERT INTO punto_anclaje_ra (
    nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, codigo_recurso_3d,
    latitud_ra, longitud_ra, altitud_suelo, azimut, inclinacion, rotacion, radio_activacion_m, escala_visual
) VALUES
('Distrito Capital', 'Libertador', 'Catedral', 'Casa Natal del Libertador', 'AR-CASA-NATAL-PATIO-01',
 10.506082, -66.912688, 1.80, 125.50, 5.00, 0.00, 25.00, 1.000),
('Distrito Capital', 'Libertador', 'Catedral', 'Estatua Ecuestre del Libertador', 'AR-BOLIVAR-EC-1874',
 10.506180, -66.914630, 4.50, 180.00, 12.00, 0.00, 35.00, 1.150),
('Sucre', 'Sucre', 'Santa Inés', 'Castillo San Antonio de la Eminencia', 'AR-CASTILLO-CUMANA-3D',
 10.464446, -64.171108, 2.20, 270.00, 0.00, 15.00, 50.00, 1.250);

-- 4. Red de Vías y Modos de Recorrido
INSERT INTO via (codigo_via, nombre_via, tipo_via, condicion_terreno, desnivel_pendiente_3d, estado_via) VALUES
('VIA-CCS-01', 'Bulevar Panteón - San Jacinto', 'bulevar', 'Adoquín plano en buen estado', 1.50, 'habilitada'),
('VIA-CCS-02', 'Esquina La Torre a Principal', 'calle', 'Pavimento urbano llano', 0.80, 'habilitada'),
('VIA-CCS-03', 'Avenida Urdaneta Tramo Catedral', 'avenida', 'Asfalto con rampas accesibles', 1.20, 'habilitada'),
('VIA-MIR-01', 'Sendero Turístico Galipán - Humboldt', 'sendero', 'Empedrado de montaña con escalinatas', 18.50, 'habilitada'),
('VIA-MIR-02', 'Calle Lino de Clemente Petare', 'calle', 'Empedrado colonial inclinado', 7.40, 'habilitada'),
('VIA-FAL-01', 'Paseo Talavera Casco Colonial', 'bulevar', 'Ladrillo peatonal nivelado', 0.40, 'habilitada'),
('VIA-MER-01', 'Avenida 3 Independencia Mérida', 'avenida', 'Asfalto urbano con pendiente suave', 4.20, 'habilitada'),
('VIA-SUC-01', 'Subida Cerro Pan de Azúcar', 'camineria', 'Escalinata de piedra consolidada', 14.00, 'habilitada'),
('VIA-CCS-04', 'Callejón Sur Anauco (Obras)', 'calle', 'En reparación por drenaje', 2.00, 'cierre total por mantenimiento');

INSERT INTO modo_recorrido_via (codigo_via, modos_recorrido) VALUES
('VIA-CCS-01', 'a pie'),
('VIA-CCS-01', 'vehiculo adaptado'),
('VIA-CCS-02', 'a pie'),
('VIA-CCS-02', 'bicicleta'),
('VIA-CCS-03', 'a pie'),
('VIA-CCS-03', 'transporte publico'),
('VIA-CCS-03', 'vehiculo adaptado'),
('VIA-MIR-01', 'a pie'),
('VIA-MIR-02', 'a pie'),
('VIA-FAL-01', 'a pie'),
('VIA-FAL-01', 'vehiculo adaptado'),
('VIA-MER-01', 'a pie'),
('VIA-MER-01', 'transporte publico'),
('VIA-SUC-01', 'a pie');

-- 5. Paradas de Transporte y Cercanía a Hitos
INSERT INTO parada_transporte (
    codigo_terminal, nombre_descriptivo, modalidad_transp, tarifa_basica_bs, nivel_accesibilidad,
    latitud_parada, longitud_parada, altitud_parada, hora_apertura, hora_cierre, estado_disponib,
    frecuencia_paso_min, capacidad_max_espera, tiene_techo, iluminacion_nocturna, tiene_taquilla,
    vigilancia_permanente, estacionamiento_transferencia, codigo_via
) VALUES
('TERM-CCS-CAP', 'Estación Metro Capitolio', 'metro', 10.00, 'Ascensor y rampas podotáctiles',
 10.505500, -66.916200, 902.00, '05:30', '23:00', 'activa', 4.00, 350, TRUE, TRUE, TRUE, TRUE, FALSE, 'VIA-CCS-03'),
('TERM-MIR-AVILA', 'Terminal Teleférico Warairarepano', 'teleferico', 450.00, 'Cabinas adaptadas para silla de ruedas',
 10.517800, -66.889100, 995.00, '09:00', '20:00', 'activa', 6.00, 220, TRUE, TRUE, TRUE, TRUE, TRUE, 'VIA-MIR-01'),
('TERM-MER-CEN', 'Parada Trolmérida Plaza Bolívar', 'autobus superficial', 15.00, 'Plataforma a nivel para silla de ruedas',
 8.597100, -71.144900, 1625.00, '06:00', '21:00', 'activa', 10.00, 90, TRUE, TRUE, TRUE, FALSE, FALSE, 'VIA-MER-01'),
('TERM-FAL-CORO', 'Parada Casco Histórico Coro', 'autobus superficial', 20.00, 'Acceso peatonal básico con rampa',
 11.408500, -69.675800, 20.00, '06:00', '20:00', 'activa', 15.00, 60, TRUE, TRUE, FALSE, TRUE, FALSE, 'VIA-FAL-01');

INSERT INTO parada_cercana_hito (
    codigo_terminal, nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, distancia_metros
) VALUES
('TERM-CCS-CAP', 'Distrito Capital', 'Libertador', 'Catedral', 'Plaza Bolívar de Caracas', 185.00),
('TERM-CCS-CAP', 'Distrito Capital', 'Libertador', 'Catedral', 'Casa Natal del Libertador', 390.00),
('TERM-MIR-AVILA', 'Miranda', 'Chacao', 'Chacao', 'Estación Warairarepano Pico Ávila', 2950.00),
('TERM-MER-CEN', 'Mérida', 'Libertador', 'El Sagrario', 'Basílica Menor Inmaculada Concepción de Mérida', 110.00),
('TERM-FAL-CORO', 'Falcón', 'Miranda', 'Santa Ana', 'Catedral Basílica de Santa Ana de Coro', 95.00);

-- 6. Visitantes (HU-01, HU-02)
CALL sp_registrar_visitante(
    'V-28451902', 'ClaveVisitante2026!', 'Valeria Sofía', 'Mendoza Ríos',
    'Venezuela', 'Español', '+58-412-5550192', 'O+',
    'valeria.mendoza@correo.ve', '+58-414-5550101',
    ARRAY['Silla de ruedas', 'Rampas de acceso continuo']
);

CALL sp_registrar_visitante(
    'V-30821466', 'GabrielClave2026!', 'Gabriel', 'López',
    'Venezuela', 'Español', '+58-424-5550200', 'A+',
    'gabriel.lopez@ucab.edu.ve', '+58-424-5550201',
    ARRAY[]::TEXT[]
);

CALL sp_registrar_visitante(
    'P-FR994821', 'JeanLucParis2026!', 'Jean-Luc', 'Moreau',
    'Francia', 'Francés', '+33-612-889900', 'B+',
    'jeanluc.moreau@voyage.fr', '+58-412-5550998',
    ARRAY['Audio guía descriptiva', 'Asistencia visual']
);

-- 7. Rutas Turísticas (Fijas, Dinámica y Pasos de Itinerario)
INSERT INTO ruta_turistica (
    nombre_estado_origen, nombre_municipio_origen, nombre_ruta,
    duracion_estimada, mejor_hora_inicio, nivel_dificultad, categoria_tematica
) VALUES
('Distrito Capital', 'Libertador', 'Ruta Histórica Libertadora', 180.00, '09:00', 'bajo', 'Patrimonio Histórico'),
('Mérida', 'Libertador', 'Ruta Histórica Libertadora', 150.00, '08:30', 'medio', 'Patrimonio Andino'),
('Miranda', 'Chacao', 'Ruta del Cacao y Neblina Ávila', 240.00, '09:30', 'medio', 'Ecoturismo y Cacao'),
('Sucre', 'Sucre', 'Ruta del Cacao y Fortaleza Oriental', 210.00, '14:30', 'medio', 'Historia y Gastronomía'),
('Distrito Capital', 'Libertador', 'Mi Paseo por Catedral', 120.00, '10:00', 'bajo', 'Accesible');

INSERT INTO ruta_fija (nombre_estado_origen, nombre_municipio_origen, nombre_ruta, fecha_curaduria, resena_experto) VALUES
('Distrito Capital', 'Libertador', 'Ruta Histórica Libertadora', '2026-10-15',
 'Circuito peatonal curado por cronistas de Caracas que enlaza la Plaza Bolívar, la Casa Natal y el Panteón Nacional con acceso por Metro Capitolio.'),
('Mérida', 'Libertador', 'Ruta Histórica Libertadora', '2026-10-18',
 'Recorrido patrimonial por el casco fundacional merideño destacando la Basílica Menor y la arquitectura republicana.'),
('Miranda', 'Chacao', 'Ruta del Cacao y Neblina Ávila', '2026-10-20',
 'Ascenso en teleférico hasta el Pico Ávila con degustación de cacao de Barlovento y visita al Hotel Humboldt.'),
('Sucre', 'Sucre', 'Ruta del Cacao y Fortaleza Oriental', '2026-10-22',
 'Itinerario cultural cumanés desde las faldas del Castillo San Antonio hasta talleres chocolateros artesanales.');

INSERT INTO ruta_dinamica (
    nombre_estado_origen, nombre_municipio_origen, nombre_ruta,
    pref_transporte, fecha_generacion, cedula_pasaporte_creador
) VALUES
('Distrito Capital', 'Libertador', 'Mi Paseo por Catedral', 'vehiculo adaptado', '2026-11-10 09:45:00', 'V-28451902');

INSERT INTO paso_itinerario (
    nombre_estado_origen, nombre_municipio_origen, nombre_ruta, nro_orden_secuencia,
    tiempo_estancia_min, codigo_via, codigo_terminal,
    nombre_estado_hito, nombre_municipio_hito, nombre_parroquia_hito, nombre_hito
) VALUES
('Distrito Capital', 'Libertador', 'Ruta Histórica Libertadora', 1, 15.00, 'VIA-CCS-03', 'TERM-CCS-CAP', NULL, NULL, NULL, NULL),
('Distrito Capital', 'Libertador', 'Ruta Histórica Libertadora', 2, 45.00, 'VIA-CCS-02', NULL, 'Distrito Capital', 'Libertador', 'Catedral', 'Plaza Bolívar de Caracas'),
('Distrito Capital', 'Libertador', 'Ruta Histórica Libertadora', 3, 60.00, 'VIA-CCS-01', NULL, 'Distrito Capital', 'Libertador', 'Catedral', 'Casa Natal del Libertador'),
('Distrito Capital', 'Libertador', 'Ruta Histórica Libertadora', 4, 60.00, 'VIA-CCS-01', NULL, 'Distrito Capital', 'Libertador', 'Altagracia', 'Panteón Nacional'),
('Mérida', 'Libertador', 'Ruta Histórica Libertadora', 1, 90.00, 'VIA-MER-01', 'TERM-MER-CEN', 'Mérida', 'Libertador', 'El Sagrario', 'Basílica Menor Inmaculada Concepción de Mérida'),
('Miranda', 'Chacao', 'Ruta del Cacao y Neblina Ávila', 1, 60.00, 'VIA-MIR-01', 'TERM-MIR-AVILA', 'Miranda', 'Chacao', 'Chacao', 'Estación Warairarepano Pico Ávila'),
('Miranda', 'Chacao', 'Ruta del Cacao y Neblina Ávila', 2, 90.00, 'VIA-MIR-01', NULL, 'Miranda', 'Chacao', 'Chacao', 'Mirador Circular Hotel Humboldt'),
('Sucre', 'Sucre', 'Ruta del Cacao y Fortaleza Oriental', 1, 90.00, 'VIA-SUC-01', NULL, 'Sucre', 'Sucre', 'Santa Inés', 'Castillo San Antonio de la Eminencia'),
('Distrito Capital', 'Libertador', 'Mi Paseo por Catedral', 1, 45.00, 'VIA-CCS-02', 'TERM-CCS-CAP', 'Distrito Capital', 'Libertador', 'Catedral', 'Plaza Bolívar de Caracas'),
('Distrito Capital', 'Libertador', 'Mi Paseo por Catedral', 2, 60.00, 'VIA-CCS-01', NULL, 'Distrito Capital', 'Libertador', 'Catedral', 'Casa Natal del Libertador');

-- 8. Guías Turísticos (HU-03, HU-04, RM-13)
CALL sp_registrar_guia_turistico(
    'RTN-CCS-1042', 'LIC-MINTUR-881', 'GuiaCaracas2026!',
    'Carlos Eduardo', 'Rivas Briceño',
    'Guía Nacional Certificado INATUR Nro. 881', 12, 250.00,
    'Distrito Capital', 'Libertador',
    ARRAY['Historia Colonial', 'Arquitectura Republicana', 'Turismo Accesible'],
    ARRAY['Español', 'Inglés', 'Francés'],
    'Distrito Capital', 'Libertador', 'Ruta Histórica Libertadora',
    'carlos.rivas@guias.ve', '+58-414-2201188', '+58-412-2209900'
);

CALL sp_registrar_guia_turistico(
    'RTN-MIR-2075', 'LIC-MINTUR-914', 'GuiaAvila2026!',
    'Mariana del Valle', 'Quintero Peña',
    'Baqueana Comunitaria Warairarepano - Mintur 914', 8, 220.00,
    'Miranda', 'Chacao',
    ARRAY['Ecoturismo de Montaña', 'Cacao Venezolano', 'Observación de Aves'],
    ARRAY['Español', 'Inglés'],
    'Miranda', 'Chacao', 'Ruta del Cacao y Neblina Ávila',
    'mariana.quintero@guias.ve', '+58-416-3304455', '+58-414-3300011'
);

CALL sp_registrar_guia_turistico(
    'RTN-SUC-3190', 'LIC-MINTUR-502', 'GuiaCumana2026!',
    'Rafael Antonio', 'Salazar Marcano',
    'Cronista y Guía Patrimonial de Cumaná Nro. 502', 15, 190.00,
    'Sucre', 'Sucre',
    ARRAY['Fortificaciones Coloniales', 'Gastronomía Oriental'],
    ARRAY['Español', 'Portugués'],
    'Sucre', 'Sucre', 'Ruta del Cacao y Fortaleza Oriental',
    'rafael.salazar@guias.ve', '+58-424-8807711', '+58-412-8807700'
);

-- 9. Comercios Aliados (HU-05)
CALL sp_registrar_comercio_aliado(
    'J-40123456-7', 'ComercioSanJacinto26!',
    'Chocolatería y Café San Jacinto C.A.', 'Gastronomía y Cacao', 45,
    'PS-DC-2026-0091', '01020111220000123456', 'Lunes a Domingo 08:00-19:00',
    'contacto@cafesanjacinto.ve', '+58-212-5553311', '+58-414-5553312'
);

CALL sp_registrar_comercio_aliado(
    'J-50987654-3', 'ComercioAvila2026!',
    'Posada y Fogón Galipán S.R.L.', 'Gastronomía de Montaña', 60,
    'PS-MIR-2026-0412', '01080222330000654321', 'Miércoles a Domingo 09:00-20:00',
    'reservas@fogongalipan.ve', '+58-212-5554422', '+58-424-5554423'
);

-- 10. Entes Públicos Patrimoniales (HU-06)
CALL sp_registrar_ente_publico(
    'G-20001234-5', 'EnteIpc2026!',
    'Instituto del Patrimonio Cultural de Venezuela', 'nacional',
    'Dra. Beatriz Eugenia Tovar', 'Decreto Nro. 2.145 Gaceta Oficial 41.200',
    'patrimonio@ipc.gob.ve', '+58-212-4821100', '+58-212-4821199'
);

CALL sp_registrar_ente_publico(
    'G-20009876-1', 'EnteCaracas2026!',
    'Fundación para la Cultura y las Artes de Caracas', 'municipal',
    'Lic. Andrés Felipe Zambrano', 'Ordenanza Municipal de Patrimonio 04-2025',
    'enlace@fundarte.gob.ve', '+58-212-5418800', '+58-212-5418899'
);

-- 11. Experiencias Promocionales, Inclusión de Hitos, Visitas, Recorridos, Evaluaciones, Credenciales e Incidencias
INSERT INTO experiencia_promocional (
    titulo_experiencia, fecha_activacion, descripcion_detallada, precio_total, cupo_max_grupo,
    porcentaje_descuento, fecha_vencimiento, codigo_promocional, rif_comercio,
    nro_rtn_guia, cod_licencia_guia, nombre_estado_origen, nombre_municipio_origen, nombre_ruta
) VALUES
('Combo Bolívar y Cacao Mantuanos', '2026-11-01',
 'Recorrido guiado por el Casco Histórico de Caracas con cata de bombones de cacao criollo en Café San Jacinto.',
 850.00, 12, 15.00, '2027-03-31', 'BOLIVAR-CACAO-15', 'J-40123456-7',
 'RTN-CCS-1042', 'LIC-MINTUR-881', 'Distrito Capital', 'Libertador', 'Ruta Histórica Libertadora'),
('Travesía Neblina y Chocolate en el Ávila', '2026-11-10',
 'Visita guiada en la cima del Warairarepano y almuerzo típico de montaña en Posada y Fogón Galipán.',
 1450.00, 8, 10.00, '2027-04-30', 'AVILA-NEBLINA-10', 'J-50987654-3',
 'RTN-MIR-2075', 'LIC-MINTUR-914', 'Miranda', 'Chacao', 'Ruta del Cacao y Neblina Ávila');

INSERT INTO experiencia_incluye_hito (
    titulo_experiencia, fecha_activacion, nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito
) VALUES
('Combo Bolívar y Cacao Mantuanos', '2026-11-01', 'Distrito Capital', 'Libertador', 'Catedral', 'Casa Natal del Libertador'),
('Combo Bolívar y Cacao Mantuanos', '2026-11-01', 'Distrito Capital', 'Libertador', 'Catedral', 'Plaza Bolívar de Caracas'),
('Travesía Neblina y Chocolate en el Ávila', '2026-11-10', 'Miranda', 'Chacao', 'Chacao', 'Estación Warairarepano Pico Ávila');

INSERT INTO visita_hito (
    cedula_pasaporte, nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, fecha_hora_visita
) VALUES
('V-28451902', 'Distrito Capital', 'Libertador', 'Catedral', 'Plaza Bolívar de Caracas', '2026-11-12 10:30:00'),
('V-30821466', 'Distrito Capital', 'Libertador', 'Catedral', 'Casa Natal del Libertador', '2026-11-14 11:00:00'),
('P-FR994821', 'Miranda', 'Chacao', 'Chacao', 'Mirador Circular Hotel Humboldt', '2026-11-18 14:20:00');

INSERT INTO recorrido_realizado (
    cedula_pasaporte, fecha_hora_inicio, fecha_hora_fin, completado,
    nombre_estado_origen, nombre_municipio_origen, nombre_ruta
) VALUES
('V-28451902', '2026-11-12 09:15:00', '2026-11-12 12:10:00', TRUE, 'Distrito Capital', 'Libertador', 'Ruta Histórica Libertadora'),
('P-FR994821', '2026-11-18 10:00:00', '2026-11-18 15:00:00', TRUE, 'Miranda', 'Chacao', 'Ruta del Cacao y Neblina Ávila');

INSERT INTO evaluacion_experiencia (
    codigo_resena, calif_estrellas, indice_seguridad, fecha_emision, opinion_detallada,
    cedula_pasaporte, fecha_hora_inicio_rec,
    nombre_estado_hito, nombre_municipio_hito, nombre_parroquia_hito, nombre_hito
) VALUES
('RES-2026-0001', 5, 5, '2026-11-12 13:00:00',
 'Excelente accesibilidad en el bulevar y muy buena atención en la Casa Natal del Libertador.',
 'V-28451902', '2026-11-12 09:15:00',
 'Distrito Capital', 'Libertador', 'Catedral', 'Plaza Bolívar de Caracas'),
('RES-2026-0002', 5, 4, '2026-11-18 16:30:00',
 'Paisaje inolvidable desde el Mirador del Hotel Humboldt y guía bilingüe muy preparado.',
 'P-FR994821', '2026-11-18 10:00:00',
 'Miranda', 'Chacao', 'Chacao', 'Mirador Circular Hotel Humboldt');

INSERT INTO credencial_acceso (
    codigo_verificacion, fecha_hora_programada, monto_abonado, cantidad_beneficiarios,
    estado_pase, cedula_pasaporte, titulo_experiencia, fecha_activacion
) VALUES
('RVZ-PASS-7741A', '2026-11-12 09:00:00', 722.50, 1, 'canjeado', 'V-28451902', 'Combo Bolívar y Cacao Mantuanos', '2026-11-01'),
('RVZ-PASS-8832B', '2026-11-28 10:00:00', 2610.00, 2, 'emitido', 'P-FR994821', 'Travesía Neblina y Chocolate en el Ávila', '2026-11-10');

INSERT INTO reporte_incidencia (
    fecha_hora_deteccion, fecha_est_resolucion, prorroga_justificada, narrativa_evento,
    estado_reporte, nivel_severidad,
    cedula_pasaporte_reporta, nro_rtn_reporta, cod_licencia_reporta, rif_gub_reporta,
    rif_gub_validador, codigo_via_afectada,
    nombre_estado_hito, nombre_municipio_hito, nombre_parroquia_hito, nombre_hito_afectado
) VALUES
('2026-11-20 08:30:00', '2026-11-27 17:00:00', NULL,
 'Desprendimiento menor de adoquines frente a la esquina de San Jacinto; paso peatonal reducido.',
 'preliminar', 'bajo',
 'V-28451902', NULL, NULL, NULL,
 NULL, 'VIA-CCS-01', NULL, NULL, NULL, NULL),
('2026-11-15 09:00:00', '2026-12-15 18:00:00', 'Prórroga aprobada por trabajos estructurales de drenaje en San José.',
 'Cierre total de Callejón Sur Anauco por sustitución de colector pluvial.',
 'activo', 'medio',
 NULL, NULL, NULL, 'G-20009876-1',
 'G-20009876-1', 'VIA-CCS-04', NULL, NULL, NULL, NULL);
