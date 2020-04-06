INSERT INTO encu.con_momentos(
            conmom_conmom, conmom_nivel, conmom_tlg)
SELECT conmom_conmom, conmom_nivel, /*CAMPOS_AUDITORIA*/ conmom_tlg
  FROM encu_anterior.con_momentos;