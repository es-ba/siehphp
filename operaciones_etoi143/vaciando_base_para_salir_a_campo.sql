
delete from encu.respuestas 
  where res_ope='eah2013'
    and res_for<>'TEM';

delete from encu.claves
  where cla_ope='eah2013'
    and cla_for<>'TEM';

delete from encu.plana_s1_;
delete from encu.plana_s1_p;
delete from encu.plana_i1_;
delete from encu.plana_a1_;
delete from encu.plana_a1_x;

update encu.respuestas 
  set res_valor=null,
      res_valor_con_error=null, 
      res_valesp=null
  where res_ope='eah2013'
    and res_for='TEM'
    and (res_valor is not null or
        res_valor_con_error is not null or
        res_valesp is not null);

-- controlamos que todo esté en estado 19        
select pla_estado , count(*)
  from encu.plana_tem_
  group by pla_estado ;

    
delete from encu.inconsistencias;
delete from encu.excepciones;


---- Vaciamos el 2012 (que se usó para probar)

delete from encu.respuestas 
  where res_ope='eah2012';

delete from encu.claves
  where cla_ope='eah2012';
  
delete from encu.opciones where opc_ope<='eah2012';
delete from encu.variables where var_ope<='eah2012';
delete from encu.preguntas where pre_ope<='eah2012';
delete from encu.bloques where blo_ope<='eah2012';
delete from encu.con_opc where conopc_ope<='eah2012';
delete from encu.matrices where mat_ope<='eah2012';
delete from encu.ua where ua_ope<='eah2012';
delete from encu.formularios where for_ope<='eah2012';
delete from encu.operativos where ope_ope<='eah2012';
