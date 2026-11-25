-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/install_all.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Propósito: Orquestador maestro de instalación limpia de toda la base de
--            datos en PostgreSQL (psql).
-- Uso:      psql -h localhost -U postgres -d proyectobd -v ON_ERROR_STOP=1 -f database/install_all.sql
-- ============================================================================

\ir 00_drop/00_drop_all.sql

\ir 01_schema/01_territorial_hitos_ra.sql
\ir 01_schema/02_vias_transporte_rutas.sql
\ir 01_schema/03_usuarios_operacion.sql

\ir 02_constraints/01_fk_estructurales_base.sql
\ir 02_constraints/02_chk_dominio_usuarios_perfiles.sql
\ir 02_constraints/03_chk_dominio_hitos_territorial.sql
\ir 02_constraints/04_chk_dominio_resto_esquema.sql

\ir 03_functions/01_fn_hash_y_autenticacion.sql
\ir 03_functions/02_fn_consultar_perfil_usuario.sql
\ir 03_functions/03_fn_jerarquia_territorial.sql
\ir 03_functions/04_fn_distancia_3d_hitos.sql
\ir 03_functions/05_fn_ficha_integral_hito.sql

\ir 04_triggers/01_trg_normalizar_y_hash_usuarios.sql
\ir 04_triggers/02_trg_disyuncion_usuarios_rm12.sql
\ir 04_triggers/03_trg_completitud_territorial_rm01_rm02.sql
\ir 04_triggers/04_trg_guia_acompana_ruta_rm13.sql
\ir 04_triggers/05_trg_coherencia_hito_acceso_estado.sql

\ir 05_procedures/01_sp_registrar_visitante.sql
\ir 05_procedures/02_sp_registrar_guia_turistico.sql
\ir 05_procedures/03_sp_registrar_comercio_aliado.sql
\ir 05_procedures/04_sp_registrar_ente_publico.sql
\ir 05_procedures/05_sp_gestionar_estado_cuenta.sql
\ir 05_procedures/06_sp_actualizar_perfil_usuario.sql
\ir 05_procedures/07_sp_registrar_territorio.sql
\ir 05_procedures/08_sp_registrar_y_actualizar_hito.sql

\ir 06_security/01_roles_y_privilegios.sql

\ir 07_seeds/01_datos_prueba_venezuela.sql
