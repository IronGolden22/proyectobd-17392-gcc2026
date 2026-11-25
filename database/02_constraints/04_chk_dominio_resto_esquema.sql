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
