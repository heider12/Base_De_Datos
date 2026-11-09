-- =========================================================
-- Ocaña Park - Script DDL (estructura actual en Supabase)
-- Motor: PostgreSQL 17 (Supabase)
-- =========================================================
 
-- Supertipo: área o servicio de Ocaña Park
CREATE TABLE area (
    area_id      INTEGER       NOT NULL,
    name         VARCHAR(100)  NOT NULL,
    description  VARCHAR(255),
    price        NUMERIC       NOT NULL,
    area_type    VARCHAR(20)   NOT NULL,
    CONSTRAINT area_pk PRIMARY KEY (area_id)
);
 
-- Subtipos de área (relación 1:1 con area)
CREATE TABLE academy (
    area_id      INTEGER       NOT NULL,
    subject      VARCHAR(100)  NOT NULL,
    study_level  VARCHAR(50)   NOT NULL,
    CONSTRAINT academy_pk PRIMARY KEY (area_id),
    CONSTRAINT academy_area_fk FOREIGN KEY (area_id) REFERENCES area (area_id)
);
 
CREATE TABLE play (
    area_id      INTEGER       NOT NULL,
    activity     VARCHAR(100)  NOT NULL,
    max_capacity NUMERIC       NOT NULL,
    CONSTRAINT play_pk PRIMARY KEY (area_id),
    CONSTRAINT play_area_fk FOREIGN KEY (area_id) REFERENCES area (area_id)
);
 
CREATE TABLE creart (
    area_id             INTEGER       NOT NULL,
    discipline          VARCHAR(100)  NOT NULL,
    materials_required  VARCHAR(255),
    CONSTRAINT creart_pk PRIMARY KEY (area_id),
    CONSTRAINT creart_area_fk FOREIGN KEY (area_id) REFERENCES area (area_id)
);
 
CREATE TABLE growing (
    area_id  INTEGER      NOT NULL,
    age      VARCHAR(30)  NOT NULL,
    stage    VARCHAR(50)  NOT NULL,
    CONSTRAINT growing_pk PRIMARY KEY (area_id),
    CONSTRAINT growing_area_fk FOREIGN KEY (area_id) REFERENCES area (area_id)
);
 
CREATE TABLE station (
    area_id     INTEGER       NOT NULL,
    table_name  VARCHAR(100)  NOT NULL,
    products    VARCHAR(255)  NOT NULL,
    CONSTRAINT station_pk PRIMARY KEY (area_id),
    CONSTRAINT station_area_fk FOREIGN KEY (area_id) REFERENCES area (area_id)
);
 
CREATE TABLE other (
    area_id  INTEGER  NOT NULL,
    CONSTRAINT other_pk PRIMARY KEY (area_id),
    CONSTRAINT other_area_fk FOREIGN KEY (area_id) REFERENCES area (area_id)
);
 
-- Personas
CREATE TABLE customer (
    customer_id  INTEGER       NOT NULL,
    first_name   VARCHAR(50)   NOT NULL,
    last_name    VARCHAR(50)   NOT NULL,
    phone        VARCHAR(20)   NOT NULL,
    email        VARCHAR(100),
    CONSTRAINT customer_pk PRIMARY KEY (customer_id)
);
 
CREATE TABLE employee (
    employee_id  INTEGER      NOT NULL,
    first_name   VARCHAR(50)  NOT NULL,
    last_name    VARCHAR(50)  NOT NULL,
    phone        VARCHAR(20)  NOT NULL,
    CONSTRAINT employee_pk PRIMARY KEY (employee_id)
);
 
-- Turnos de trabajo (horario en que se presta un servicio)
CREATE TABLE shift (
    shift_id     INTEGER    NOT NULL,
    shift_date   DATE       NOT NULL,
    start_time   TIMESTAMP  NOT NULL,
    end_time     TIMESTAMP  NOT NULL,
    employee_id  INTEGER    NOT NULL,
    CONSTRAINT shift_pk PRIMARY KEY (shift_id),
    CONSTRAINT shift_employee_fk FOREIGN KEY (employee_id) REFERENCES employee (employee_id)
);
 
-- Reservas (encabezado)
CREATE TABLE reservation (
    reservation_id    INTEGER      NOT NULL,
    reservation_date  DATE         NOT NULL,
    status            VARCHAR(20)  NOT NULL,
    customer_id       INTEGER      NOT NULL,
    CONSTRAINT reservation_pk PRIMARY KEY (reservation_id),
    CONSTRAINT reservation_customer_fk FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
);
 
-- Detalle de la reserva: qué área y en qué turno
CREATE TABLE reservation_detail (
    reserva_id      INTEGER  NOT NULL,
    reservation_id  INTEGER  NOT NULL,
    area_id         INTEGER  NOT NULL,
    shift_id        INTEGER  NOT NULL,
    CONSTRAINT reservation_detail_pk PRIMARY KEY (reserva_id),
    CONSTRAINT reservation_detail_reservation_fk FOREIGN KEY (reservation_id) REFERENCES reservation (reservation_id),
    CONSTRAINT reservation_detail_area_fk FOREIGN KEY (area_id) REFERENCES area (area_id),
    CONSTRAINT reservation_detail_shift_fk FOREIGN KEY (shift_id) REFERENCES shift (shift_id)
);
