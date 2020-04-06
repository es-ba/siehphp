--D: Pone por defecto bol_dispositivo=2, bol_Activa=true, bol_Cerrada=false
--   y modifico el por defecto de bol_rea

ALTER TABLE encu.bolsas ALTER COLUMN bol_cerrada SET DEFAULT false;
ALTER TABLE encu.bolsas ALTER COLUMN bol_activa SET DEFAULT true;
ALTER TABLE encu.bolsas ALTER COLUMN bol_dispositivo SET DEFAULT 2;

