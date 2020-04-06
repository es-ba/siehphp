INSERT INTO encu.con_opc(
            conopc_ope, conopc_conopc, conopc_texto, conopc_despliegue, conopc_tlg)
    VALUES ('eah2013', 'solamentesi_h', null, 'horizontal', 1);


insert into encu.opciones (opc_ope, opc_conopc, opc_opc, opc_texto, opc_orden, opc_tlg)
values
('eah2013', 'solamentesi_h', '1', 'Sí', 0,1);

update encu.variables set var_expresion_habilitar='sn1_1=2 and sn1_2=2 and sn1_3=2 and sn1_4=2 and sn1_5=2', 
			  var_conopc='solamentesi_h' 
where var_var='sn1_6';
