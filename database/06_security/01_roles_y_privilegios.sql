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
