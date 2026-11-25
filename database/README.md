# Módulo de Base de Datos — RutasVenezuela (PostgreSQL 19)

Este directorio contiene el esquema relacional completo (31 tablas), restricciones de integridad (`RE-01`..`RE-25`, `RM-01`..`RM-25`), automatización PL/pgSQL (`HU-01` a `HU-14`), seguridad lógica y datos de prueba para la plataforma **RutasVenezuela**.

## Estructura de Carpetas

- `00_drop/`: Limpieza idempotente de tablas, funciones y procedimientos (`00_drop_all.sql`).
- `01_schema/`: Definición DDL de las 31 tablas en 3FN/FNBC usando exclusivamente tipos de datos primitivos.
- `02_constraints/`: Claves foráneas (`RM-01` a `RM-21`), restricciones de dominio (`CHECK`) y unicidad (`UNIQUE` / índices funcionales).
- `03_functions/`: Funciones PL/pgSQL y SQL para hashing SHA-256, autenticación, consultas de perfiles, jerarquía territorial, cálculo geodésico 3D y ficha integral de hitos.
- `04_triggers/`: Triggers de normalización/hash, disyunción de claves naturales (`RM-12`), participación total diferible (`RM-01`, `RM-02`, `RM-13`) y coherencia de hitos (`HU-10`, `HU-12`, `HU-14`).
- `05_procedures/`: Procedimientos almacenados transaccionales para el registro, parametrización, moderación y actualización de `HU-01` a `HU-14`.
- `06_security/`: Roles de negocio en PostgreSQL y privilegios granulares sobre tablas, secuencias, funciones y procedimientos.
- `07_seeds/`: Datos de prueba realistas del contexto turístico y urbano venezolano (`01_datos_prueba_venezuela.sql`).
- `init/`: Script consolidado (`01-init.sql`) para inicialización automática vía Docker Compose.
- `install_all.sql`: Orquestador maestro de instalación desde cero con `psql`.

## Matriz de Autoría y Trazabilidad (Gabriel López — C.I. 30.821.466)

| Historia / Regla | Tipo de Objeto | Archivo | Objetos Implementados |
| :--- | :--- | :--- | :--- |
| Esquema Base 31 tablas | DDL | `01_schema/*.sql` | 31 tablas del Modelo Relacional + ajustes Entrega 2 (`razon_social`, `denominacion_oficial`, `estado_cuenta`, `historia`, contacto) |
| `RM-01`..`RM-21` | FK Constraints | `02_constraints/01_fk_estructurales_base.sql` | Todas las claves foráneas con `MATCH FULL` y políticas referenciales |
| `HU-01`..`HU-08`, `RE-14`..`RE-16` | Domain Constraints | `02_constraints/02_chk_dominio_usuarios_perfiles.sql` | `CHECK` de grupo sanguíneo, RIF jurídico/gubernamental, `aforo_max`, `estado_cuenta`, `UNIQUE` razón social/denominación/correo |
| `HU-09`..`HU-14`, `RE-01`..`RE-03` | Domain Constraints | `02_constraints/03_chk_dominio_hitos_territorial.sql` | Estados operativos, catálogo oficial de categorías, rangos geodésicos, índice único normalizado `HU-12`, `UNIQUE (latitud, longitud, altitud_msnm)` `HU-13` |
| `HU-01`..`HU-08` | Funciones y Triggers | `03_functions/01_*.sql`, `02_*.sql`, `04_triggers/01_*.sql`, `02_*.sql` | `fn_hash_contrasena`, `fn_autenticar_usuario`, `fn_obtener_perfil_visitante`, `fn_buscar_guias_disponibles`, `trg_fn_preparar_registro_usuario`, `trg_fn_validar_disyuncion_usuarios` (`RM-12`) |
| `HU-01`..`HU-08` | Procedimientos | `05_procedures/01_*.sql`..`06_*.sql` | `sp_registrar_visitante`, `sp_registrar_guia_turistico`, `sp_parametrizar_idiomas_zona_guia`, `sp_registrar_comercio_aliado`, `sp_registrar_ente_publico`, `sp_cambiar_estado_cuenta_usuario`, `sp_actualizar_perfil_visitante`, `sp_actualizar_contacto_actor` |
| `HU-09`..`HU-14`, `RM-01`, `RM-02`, `RM-13` | Funciones, Triggers y SPs | `03_functions/03_*.sql`..`05_*.sql`, `04_triggers/03_*.sql`..`05_*.sql`, `05_procedures/07_*.sql`, `08_*.sql` | `fn_listar_jerarquia_territorial`, `fn_calcular_distancia_3d_m`, `fn_buscar_hitos_cercanos_3d`, `fn_consultar_ficha_integral_hito`, `fn_catalogo_hitos`, triggers diferibles `RM-01`/`RM-02`/`RM-13` y coherencia de hitos, `sp_registrar_jerarquia_territorial`, `sp_registrar_hito_completo`, `sp_actualizar_estado_operativo_hito` |
| Seguridad Lógica | Roles y Grants | `06_security/01_roles_y_privilegios.sql` | `rol_admin_sistema`, `rol_admin_patrimonial`, `rol_visitante`, `rol_guia_turistico`, `rol_comercio_aliado`, `rol_ente_publico`, `db_user` |

## Ejecución Local (PostgreSQL nativo)

```powershell
$env:PGPASSWORD='admin'
psql -h localhost -U postgres -d proyectobd --set client_encoding=UTF8 -v ON_ERROR_STOP=1 -f database/install_all.sql
```

Credenciales de aplicación (`.env.example` / Spring Boot):
- **Host**: `localhost`
- **Puerto**: `5432`
- **Database**: `proyectobd`
- **Usuario**: `db_user`
- **Contraseña**: `db_password`
