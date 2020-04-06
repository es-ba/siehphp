INSERT INTO encu.relaciones(rel_rel, rel_nombre, rel_tlg)
SELECT rel_rel, rel_nombre, /*CAMPOS_AUDITORIA*/
  FROM encu_anterior.relaciones;
