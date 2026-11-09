-- =========================================================
-- Ocaña Park - Script DML (datos de ejemplo tomados de Supabase)
-- =========================================================
INSERT INTO area (area_id, name, description, price, area_type) VALUES
(1,  'Refuerzo Matemáticas', 'Clases de refuerzo',        30000.00, 'ACADEMY'),
(2,  'Inglés Básico',        'Clases de inglés',          28000.00, 'ACADEMY'),
(3,  'Taller de Pintura',    'Pintura y dibujo',          25000.00, 'CREART'),
(4,  'Taller de Cerámica',   'Modelado en arcilla',       27000.00, 'CREART'),
(5,  'Huerta Infantil',      'Cultivo para niños',        20000.00, 'GROWING'),
(6,  'Vivero',               'Cuidado de plantas',        18000.00, 'GROWING'),
(7,  'Estación Cafetería',   'Bebidas y snacks',          10000.00, 'STATION'),
(8,  'Estación Snacks',      'Dulces y galletas',          8000.00, 'STATION'),
(9,  'Sala de Juegos',       'Juegos de mesa',            15000.00, 'PLAY'),
(10, 'Zona de Videojuegos',  'Consolas y torneos',        20000.00, 'PLAY'),
(11, 'Salón de Eventos',     'Celebraciones y reuniones', 50000.00, 'OTHER');
 
INSERT INTO academy (area_id, subject, study_level) VALUES
(1, 'Refuerzo Matemáticas', 'Primaria'),
(2, 'Inglés Básico',        'Primaria');
 
INSERT INTO creart (area_id, discipline, materials_required) VALUES
(3, 'Taller de Pintura',  'Pinceles, lienzos y arcilla'),
(4, 'Taller de Cerámica', 'Pinceles, lienzos y arcilla');
 
INSERT INTO growing (area_id, age, stage) VALUES
(5, '6-10 años', 'Siembra'),
(6, '6-10 años', 'Siembra');
 
INSERT INTO station (area_id, table_name, products) VALUES
(7, 'Estación Cafetería', 'Jugos, galletas, café'),
(8, 'Estación Snacks',    'Jugos, galletas, café');
 
INSERT INTO play (area_id, activity, max_capacity) VALUES
(9,  'Sala de Juegos',      12),
(10, 'Zona de Videojuegos', 12);
 
INSERT INTO other (area_id) VALUES (11);
 
INSERT INTO customer (customer_id, first_name, last_name, phone, email) VALUES
(1, 'Juan',   'Vargas',  '3406266363', 'cliente1@mail.com'),
(2, 'Carlos', 'Navarro', '3919443983', 'cliente2@mail.com'),
(3, 'Juan',   'Navarro', '3852568270', 'cliente3@mail.com'),
(4, 'Ana',    'Castro',  '3686175250', 'cliente4@mail.com'),
(5, 'María',  'Vargas',  '3039972498', 'cliente5@mail.com');
-- Resto de clientes (6 a 100) generados con datos de prueba
INSERT INTO customer (customer_id, first_name, last_name, phone, email)
SELECT g,
       (ARRAY['Juan','Carlos','Ana','María','Luis','Pedro','Laura','Sofía'])[1 + (g % 8)],
       (ARRAY['Vargas','Navarro','Castro','Gómez','Mejía','Rojas','Díaz','Ruiz','Torres'])[1 + (g % 9)],
       '3' || lpad(((g * 7919) % 1000000000)::text, 9, '0'),
       'cliente' || g || '@mail.com'
FROM generate_series(6, 100) AS g;
 
INSERT INTO employee (employee_id, first_name, last_name, phone) VALUES
(1, 'David',  'Mora',    '3329765944'),
(2, 'Marta',  'León',    '3682896890'),
(3, 'Sergio', 'Cruz',    '3357149156'),
(4, 'Marta',  'Herrera', '3863762573'),
(5, 'Felipe', 'Soto',    '3872041015');
-- Resto de empleados (6 a 200)
INSERT INTO employee (employee_id, first_name, last_name, phone)
SELECT g,
       (ARRAY['David','Marta','Sergio','Felipe','Paula','Valentina','Jorge','Daniela'])[1 + (g % 8)],
       (ARRAY['Mora','León','Cruz','Herrera','Soto','Cano','Ramos'])[1 + (g % 7)],
       '3' || lpad(((g * 104729) % 1000000000)::text, 9, '0')
FROM generate_series(6, 200) AS g;
 
INSERT INTO shift (shift_id, shift_date, start_time, end_time, employee_id) VALUES
(1, '2020-02-24', '2020-02-24 08:00', '2020-02-24 12:00', 193),
(2, '2022-07-31', '2022-07-31 08:00', '2022-07-31 12:00', 95),
(3, '2022-01-03', '2022-01-03 08:00', '2022-01-03 12:00', 89),
(4, '2020-04-16', '2020-04-16 08:00', '2020-04-16 12:00', 144),
(5, '2024-10-09', '2024-10-09 14:00', '2024-10-09 18:00', 140);
-- Resto de turnos (6 a 1000): jornada mañana 08-12 o tarde 14-18
INSERT INTO shift (shift_id, shift_date, start_time, end_time, employee_id)
SELECT g, d,
       d + CASE WHEN g % 2 = 0 THEN time '08:00' ELSE time '14:00' END,
       d + CASE WHEN g % 2 = 0 THEN time '12:00' ELSE time '18:00' END,
       1 + (g * 37) % 200
FROM (SELECT g, date '2014-01-06' + ((g * 389) % 4680) AS d
      FROM generate_series(6, 1000) AS g) t;
 
INSERT INTO reservation (reservation_id, reservation_date, status, customer_id) VALUES
(1, '2014-05-10', 'CONFIRMADA', 13),
(2, '2021-11-07', 'CONFIRMADA', 11),
(3, '2018-02-28', 'CANCELADA',  89),
(4, '2022-04-14', 'CANCELADA',  23),
(5, '2022-02-11', 'CANCELADA',  46);
-- Resto de reservas (6 a 100)
INSERT INTO reservation (reservation_id, reservation_date, status, customer_id)
SELECT g, date '2014-01-03' + ((g * 547) % 4665),
       (ARRAY['CONFIRMADA','CANCELADA','PENDIENTE'])[1 + (g % 3)],
       1 + (g * 31) % 100
FROM generate_series(6, 100) AS g;
 
INSERT INTO reservation_detail (reserva_id, reservation_id, area_id, shift_id) VALUES
(1, 1, 10, 816),
(2, 2, 1,  382),
(3, 3, 2,  707),
(4, 4, 9,  597),
(5, 5, 11, 755);
-- Resto de detalles (6 a 100): un área y un turno por reserva
INSERT INTO reservation_detail (reserva_id, reservation_id, area_id, shift_id)
SELECT g, g, 1 + (g % 11), 1 + (g * 53) % 1000
FROM generate_series(6, 100) AS g;
 
-- Ejemplos de UPDATE y DELETE (operaciones de mantenimiento)
UPDATE reservation SET status = 'CONFIRMADA' WHERE reservation_id = 4;
UPDATE area SET price = 32000.00 WHERE area_id = 1;
DELETE FROM reservation_detail WHERE reserva_id = 5;
