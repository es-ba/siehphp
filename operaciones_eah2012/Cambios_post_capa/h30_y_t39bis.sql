/* para corregir h30 */
update encu.variables set var_orden = 11 where var_ope = 'eah2012' and var_for = 'A1' and var_pre = 'H30' and var_var = 'h30_in';

/* para corregir salto t39bis */
update encu.saltos set sal_conopc = 't39_bis' where sal_ope = 'eah2012' and sal_var = 't39_bis' and sal_opc = '2';