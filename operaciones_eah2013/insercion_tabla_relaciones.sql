INSERT INTO encu.relaciones(rel_rel, rel_nombre, rel_tlg)
SELECT rel_rel, rel_nombre, 1
  FROM eah2012.relaciones;
