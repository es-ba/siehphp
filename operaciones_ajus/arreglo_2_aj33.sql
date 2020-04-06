
update encu.respuestas
set res_estado='opc_sinesp'
where res_var='aj33'
and res_estado is null
and res_valor='-1';

update encu.respuestas
set res_estado='opc_salt'
where res_var='aj33'
and res_estado is null
and res_valor is null;

update encu.respuestas
set res_estado='opc_ok'
where res_var='aj33'
and res_estado is null
and res_valor is not null
and res_valor <>'-1';


