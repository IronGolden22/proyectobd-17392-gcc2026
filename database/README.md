# Módulo de Base de Datos (PostgreSQL)

Este directorio contiene los scripts de inicialización, definición de esquema (DDL) y datos semilla (DML) para la base de datos PostgreSQL del proyecto.

## Estructura

- `init/`: Scripts que se ejecutan automáticamente al inicializar el contenedor Docker (`01-init.sql`).
- `schema/`: Definición de tablas, relaciones, restricciones e índices.
- `seeds/`: Datos de prueba para desarrollo.

## Ejecución Local con Docker Compose

Para levantar una instancia limpia de PostgreSQL compatible:

```bash
docker compose up -d
```

Credenciales configuradas por defecto:
- **Host**: `localhost`
- **Puerto**: `5432`
- **Database**: `proyectobd`
- **Usuario**: `db_user`
- **Contraseña**: `db_password`
