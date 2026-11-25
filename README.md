# Proyecto de Bases de Datos (`proyectobd-17392-gcc2026`)

Proyecto full-stack para la asignatura de Sistemas de Bases de Datos en la Universidad Catolica Andres Bello. Curso dictado por la profesora Marlene Goncalves

## Stack Tecnológico

- **Backend**: Java + Spring Boot (Spring Web, Spring Data JPA, Validation, PostgreSQL Driver) en [`backend/`](./backend)
- **Frontend**: Angular (HTML, CSS, TypeScript / JavaScript) en [`frontend/`](./frontend)
- **Base de Datos**: PostgreSQL (scripts SQL y configuración Docker Compose) en [`database/`](./database)

## Estructura del Repositorio

```text
proyectobd-17392-gcc2026/
├── backend/       # API REST con Java y Spring Boot (Maven)
├── frontend/      # Aplicación web con Angular
├── database/      # Scripts DDL/DML e inicialización de PostgreSQL
├── docker-compose.yml # Servicio de PostgreSQL listo para levantar
├── .env.example   # Variables de entorno de conexión
├── .gitignore
└── README.md
```

## Requisitos Previos

- **Base de Datos**: PostgreSQL (instalado localmente o vía Docker con `docker compose up -d`).
- **Backend**: JDK 17 o superior (para ejecutar el wrapper de Maven `./mvnw` / `mvnw.cmd`).
- **Frontend**: Node.js (LTS) y npm.

## Ejecución Rápida

### Backend (Spring Boot)

```bash
cd backend
./mvnw spring-boot:run
```

En Windows PowerShell:

```powershell
cd backend
.\mvnw.cmd spring-boot:run
```

### Frontend (Angular)

```bash
cd frontend
npm install
npm start
```
