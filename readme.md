# Ocaña Park - Base de Datos

## Descripción del proyecto

Este repositorio contiene la base de datos del sistema de reservas y gestión de servicios de Ocaña Park, una propuesta de parque o centro de actividades que ofrece distintos tipos de áreas y servicios para clientes, empleados y reservas.

La estructura está diseñada para PostgreSQL y contempla:

- Gestión de áreas o servicios
- Tipos de áreas especializados
- Registro de clientes y empleados
- Control de turnos de trabajo
- Reservas de servicios con detalle por área y turno
- Datos de prueba para validar el comportamiento del sistema
- Correcciones y reglas de negocio para asegurar integridad de datos

## Objetivo

Administrar de forma organizada la operación de Ocaña Park, permitiendo:

- registrar áreas como academias, talleres, juegos, huerta, estaciones y otros servicios;
- asignar empleados a turnos de trabajo;
- llevar el control de clientes y reservas;
- validar reglas como cupos, estados de reservas y tipos de áreas;
- proteger el acceso a la base de datos mediante políticas de seguridad.

## Estructura del repositorio

- `OcanaPark_estructura.sql`: script principal con la definición de tablas y relaciones.
- `Datos_Prueba.sql`: carga de datos de ejemplo para clientes, empleados, áreas, turnos y reservas.
- `Correciones_Tablas.sql`: ajustes, restricciones, índices, triggers y políticas de seguridad recomendados.
- `readme.md`: documentación del proyecto.

## Modelo de datos

### 1. Áreas

La tabla principal es `area`, que representa un servicio o espacio disponible en Ocaña Park.

Cada área puede ser de uno de estos tipos:

- `ACADEMY`: academias o reforzamientos académicos
- `PLAY`: zonas de juego o recreación
- `CREART`: talleres de arte y creatividad
- `GROWING`: áreas relacionadas con la huerta o crecimiento
- `STATION`: estaciones de servicio o cafetería
- `OTHER`: otros servicios

Además, existen tablas especializadas por tipo:

- `academy`
- `play`
- `creart`
- `growing`
- `station`
- `other`

Esto permite modelar un patrón de supertipo/subtipo para cada área.

### 2. Clientes y empleados

- `customer`: información de clientes, como nombre, teléfono y correo.
- `employee`: información de personal que trabaja en los turnos.

### 3. Turnos de trabajo

La tabla `shift` almacena los horarios de trabajo del personal, incluyendo:

- fecha
- hora de inicio
- hora de finalización
- identificador del empleado asignado

### 4. Reservas

- `reservation`: registra la reserva realizada por un cliente.
- `reservation_detail`: define qué área fue reservada y en qué turno.

La relación es de uno a muchos entre `reservation` y `reservation_detail`.

## Reglas de negocio

En el script `Correciones_Tablas.sql` se incorporan validaciones esenciales para la integridad del sistema, entre ellas:

- corrección del estado de una reserva (`PENDIENTE`, `CONFIRMADA`, `CANCELADA`)
- validación de precios no negativos
- validación de tipos de área permitidos
- validación de horas finales mayores que la hora inicial
- validación de capacidad positiva en áreas de juegos
- comprobación de que cada subtipo pertenezca al tipo correcto de área
- control de cupo máximo en áreas de juego por turno
- seguridad con `RLS` (Row Level Security)

## Cómo usar este proyecto

### Prerrequisitos

- PostgreSQL 17 o un entorno compatible como Supabase
- Acceso al SQL Editor o consola de PostgreSQL

### Orden recomendado de ejecución

1. Ejecutar `OcanaPark_estructura.sql`
2. Ejecutar `Datos_Prueba.sql`
3. Ejecutar `Correciones_Tablas.sql`

Esto dejará la base de datos lista para pruebas, validaciones y consultas.

## Ejemplos de consultas

### Ver todas las áreas disponibles

```sql
SELECT *
FROM area;
```

### Ver reservas confirmadas

```sql
SELECT *
FROM reservation
WHERE status = 'CONFIRMADA';
```

### Ver detalle de una reserva específica

```sql
SELECT rd.reserva_id, r.reservation_id, a.name, s.shift_date, s.start_time, s.end_time
FROM reservation_detail rd
JOIN reservation r ON rd.reservation_id = r.reservation_id
JOIN area a ON rd.area_id = a.area_id
JOIN shift s ON rd.shift_id = s.shift_id
WHERE r.reservation_id = 1;
```

## Consideraciones

- El diseño usa un enfoque relacional clásico con normalización básica.
- Los datos de prueba fueron generados para simular un entorno realista.
- El proyecto está pensado como base para evolución hacia una aplicación web, panel administrativo o gestión de reservas más completa.

## Estado del proyecto

El repositorio está estructurado como una base de datos funcional para pruebas y validación de requisitos de negocio relacionados con la administración de servicios y reservas de Ocaña Park.

## Autor

Proyecto desarrollado en el contexto del diseño y modelado de una base de datos para Ocaña Park.
