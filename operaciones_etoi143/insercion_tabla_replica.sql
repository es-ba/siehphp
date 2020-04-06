INSERT INTO replica (rep_rep, rep_dominio, rep_tlg) 
select rep_rep, rep_dominio, /*CAMPOS_AUDITORIA*/ from encu_anterior.replica;