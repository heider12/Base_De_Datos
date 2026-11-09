-- =========================================================
-- Ocaña Park - Correcciones propuestas tras las pruebas UAT
-- Ejecutar en el SQL Editor de Supabase en este orden.
-- =========================================================
 
-- 1. Dominios y unicidad (INT-04, INT-05, INT-06, INT-07, INT-10)
ALTER TABLE customer    ADD CONSTRAINT customer_email_uk   UNIQUE (email);
ALTER TABLE reservation ADD CONSTRAINT reservation_status_ck
      CHECK (status IN ('PENDIENTE', 'CONFIRMADA', 'CANCELADA'));
ALTER TABLE area        ADD CONSTRAINT area_price_ck  CHECK (price >= 0);
ALTER TABLE area        ADD CONSTRAINT area_type_ck
      CHECK (area_type IN ('ACADEMY', 'PLAY', 'CREART', 'GROWING', 'STATION', 'OTHER'));
ALTER TABLE shift       ADD CONSTRAINT shift_time_ck  CHECK (end_time > start_time);
ALTER TABLE play        ADD CONSTRAINT play_capacity_ck CHECK (max_capacity > 0);
 
-- 2. Índices sobre llaves foráneas (PER-02 a PER-04)
CREATE INDEX idx_reservation_customer   ON reservation (customer_id);
CREATE INDEX idx_reservation_date       ON reservation (reservation_date);
CREATE INDEX idx_detail_reservation     ON reservation_detail (reservation_id);
CREATE INDEX idx_detail_area_shift      ON reservation_detail (area_id, shift_id);
CREATE INDEX idx_shift_employee         ON shift (employee_id);
 
-- 3. Coherencia supertipo/subtipo (INT-08)
CREATE OR REPLACE FUNCTION check_area_subtype() RETURNS trigger AS $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM area
                 WHERE area_id = NEW.area_id AND area_type = TG_ARGV[0]) THEN
    RAISE EXCEPTION 'El área % no es de tipo %', NEW.area_id, TG_ARGV[0];
  END IF;
  RETURN NEW;
END $$ LANGUAGE plpgsql;
 
CREATE TRIGGER academy_subtype_trg BEFORE INSERT OR UPDATE ON academy FOR EACH ROW EXECUTE FUNCTION check_area_subtype('ACADEMY');
CREATE TRIGGER play_subtype_trg    BEFORE INSERT OR UPDATE ON play    FOR EACH ROW EXECUTE FUNCTION check_area_subtype('PLAY');
CREATE TRIGGER creart_subtype_trg  BEFORE INSERT OR UPDATE ON creart  FOR EACH ROW EXECUTE FUNCTION check_area_subtype('CREART');
CREATE TRIGGER growing_subtype_trg BEFORE INSERT OR UPDATE ON growing FOR EACH ROW EXECUTE FUNCTION check_area_subtype('GROWING');
CREATE TRIGGER station_subtype_trg BEFORE INSERT OR UPDATE ON station FOR EACH ROW EXECUTE FUNCTION check_area_subtype('STATION');
CREATE TRIGGER other_subtype_trg   BEFORE INSERT OR UPDATE ON other   FOR EACH ROW EXECUTE FUNCTION check_area_subtype('OTHER');
 
-- 4. Cupo máximo en áreas PLAY (regla 6, CON-04)
CREATE OR REPLACE FUNCTION check_play_capacity() RETURNS trigger AS $$
DECLARE cap NUMERIC; ocupados INTEGER;
BEGIN
  SELECT max_capacity INTO cap FROM play WHERE area_id = NEW.area_id;
  IF cap IS NULL THEN RETURN NEW; END IF;          -- el área no tiene cupo
  PERFORM 1 FROM shift WHERE shift_id = NEW.shift_id FOR UPDATE;  -- serializa reservas del mismo turno
  SELECT count(*) INTO ocupados
  FROM reservation_detail d JOIN reservation r USING (reservation_id)
  WHERE d.area_id = NEW.area_id AND d.shift_id = NEW.shift_id AND r.status <> 'CANCELADA';
  IF ocupados >= cap THEN
    RAISE EXCEPTION 'Cupo lleno: el área % ya tiene % participantes en el turno %', NEW.area_id, ocupados, NEW.shift_id;
  END IF;
  RETURN NEW;
END $$ LANGUAGE plpgsql;
 
CREATE TRIGGER reservation_detail_capacity_trg BEFORE INSERT ON reservation_detail
  FOR EACH ROW EXECUTE FUNCTION check_play_capacity();
 
-- 5. Seguridad: activar RLS y quitar escritura al rol anónimo (SEC-01, SEC-03, SEC-04)
ALTER TABLE area               ENABLE ROW LEVEL SECURITY;
ALTER TABLE academy            ENABLE ROW LEVEL SECURITY;
ALTER TABLE play               ENABLE ROW LEVEL SECURITY;
ALTER TABLE creart             ENABLE ROW LEVEL SECURITY;
ALTER TABLE growing            ENABLE ROW LEVEL SECURITY;
ALTER TABLE station            ENABLE ROW LEVEL SECURITY;
ALTER TABLE other              ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer           ENABLE ROW LEVEL SECURITY;
ALTER TABLE employee           ENABLE ROW LEVEL SECURITY;
ALTER TABLE shift              ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservation        ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservation_detail ENABLE ROW LEVEL SECURITY;
 
REVOKE INSERT, UPDATE, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA public FROM anon;
 
-- El catálogo de áreas sí puede ser público (solo lectura)
CREATE POLICY area_lectura_publica ON area FOR SELECT TO anon, authenticated USING (true);
-- El personal autenticado gestiona clientes y reservas
CREATE POLICY customer_personal    ON customer           FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY reservation_personal ON reservation        FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY detail_personal      ON reservation_detail FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY shift_personal       ON shift              FOR SELECT TO authenticated USING (true);