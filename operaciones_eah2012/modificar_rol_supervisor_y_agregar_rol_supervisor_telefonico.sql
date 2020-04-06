INSERT INTO encu.opciones(
            opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, 
            opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg)
    VALUES ('pp2012','roles_personas','4','supervisor telefonico',NULL,4,NULL,NULL,NULL,1);

update encu.opciones set opc_texto='supervisor campo' where opc_ope='pp2012' and opc_texto='supervisor' and opc_conopc='roles_personas';

