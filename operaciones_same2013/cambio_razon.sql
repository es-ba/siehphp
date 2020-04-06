update encu.bloques set blo_for='SM1', blo_orden=70 where blo_blo='RAZON';
update encu.preguntas set pre_orden=pre_orden-500 where pre_for='SM1' and pre_mat='' and pre_pre like 'razon%'; 
update encu.variables set var_for='SM1' where var_for='SMI1' and var_mat='' and var_pre like 'razon%'; 
update encu.saltos set sal_destino='RAZON' where sal_var='entrea';


