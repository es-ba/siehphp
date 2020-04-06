update encu.respuestas
  set res_valor=null
  where res_valor='0'
    and res_ope='eah2010';
    
update encu.variables
  set var_tipovar='telefono'
  where var_var in ('h4_tel','telefono')
     and var_ope='eah2012';
