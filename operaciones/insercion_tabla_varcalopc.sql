INSERT INTO encu.varcalopc(
            varcalopc_ope, varcalopc_varcal, varcalopc_opcion, varcalopc_expresion_condicion, 
            varcalopc_etiqueta, varcalopc_tlg, varcalopc_expresion_valor, 
            varcalopc_origen, varcalopc_orden)
    select dbo.ope_actual(), varcalopc_varcal, varcalopc_opcion, varcalopc_expresion_condicion, 
            varcalopc_etiqueta, /*CAMPOS_AUDITORIA*/, varcalopc_expresion_valor, 
            varcalopc_origen, varcalopc_orden from encu_anterior.varcalopc;