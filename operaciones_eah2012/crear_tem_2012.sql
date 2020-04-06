ALTER TABLE encu.tem ADD tem_lote2011 integer;
ALTER TABLE encu.plana_tem_ ADD pla_lote2011 integer;

DELETE FROM encu.tem;
DELETE FROM encu.respuestas;
DELETE FROM encu.claves;
DELETE FROM encu.plana_tem_;
DELETE FROM encu.plana_s1_;
DELETE FROM encu.plana_i1_;
DELETE FROM encu.plana_a1_;
DELETE FROM encu.plana_s1_p;
DELETE FROM encu.plana_a1_x;