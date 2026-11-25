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
