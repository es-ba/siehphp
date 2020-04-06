update encu.consistencias set con_precondicion = 'rea<>2' where con_con = 'Total_h';
update encu.consistencias set con_precondicion = 'P4=4' where con_con = 'P4=4_EdaJ';


update encu.consistencias set con_precondicion = 'P9=2 and P10<>1' where con_con = 'P9=2_P11';
update encu.consistencias set con_precondicion = 'P9=6 and P10<>1' where con_con = 'P9_P11_a';
update encu.consistencias set con_precondicion = 'P9=7 and P10<>1' where con_con = 'P9_P11_b';

update encu.respuestas set res_valor=-1 where res_var='p3_b' and res_estado<>'opc_ok' and res_valor='SIN ESPECIFICAR' and res_enc in (812632,120905,127046);
