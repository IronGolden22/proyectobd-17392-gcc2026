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
