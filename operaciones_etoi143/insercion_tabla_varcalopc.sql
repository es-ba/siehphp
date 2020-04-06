INSERT INTO encu.varcalopc(
            varcalopc_ope, varcalopc_varcal, varcalopc_opcion, varcalopc_expresion_condicion, 
            varcalopc_etiqueta, varcalopc_tlg, varcalopc_expresion_valor, 
            varcalopc_origen)
    select dbo.ope_actual(), varcalopc_varcal, varcalopc_opcion, varcalopc_expresion_condicion, 
            varcalopc_etiqueta, /*CAMPOS_AUDITORIA*/, varcalopc_expresion_valor, 
            varcalopc_origen from encu_anterior.varcalopc;