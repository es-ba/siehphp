##FUN
variables_saltadas
##ESQ
encu
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path= encu, comun, dbo, public;
DROP FUNCTION if exists encu.variables_saltadas(text, text, text) ;
DROP FUNCTION if exists encu.variables_saltadas(text, text, text, text) ;
/*otra*/
CREATE OR REPLACE FUNCTION encu.variables_saltadas(pope text, porigen TEXT, pdestino TEXT,ptipodestino TEXT, OUT psaltadas_str TEXT, OUT psaltadas_cond_str TEXT)
  AS
$BODY$
DECLARE
  c_all_vars RECORD;
BEGIN
    psaltadas_str='';
    psaltadas_cond_str='';
    FOR c_all_vars IN
      select var_var
         from encu.variables_ordenadas v,
                (SELECT orden FROM encu.variables_ordenadas where var_ope=pope and var_var=porigen) as origen,
                (SELECT orden 
                    FROM encu.variables_ordenadas 
                    where var_ope=pope and 
                          var_var=CASE WHEN pdestino IS NOT NULL THEN pdestino
                                       ELSE (SELECT var_ultima_for 
                                                 FROM encu.variables_ordenadas 
                                                 WHERE var_ope=pope and var_var= porigen
                                            )
                                       END  
                 ) as destino
         where v.var_ope=pope and v.orden >origen.orden and 
              (v.orden<destino.orden or (ptipodestino = 'fin' and v.orden=destino.orden))           
         order by v.orden
    LOOP
         psaltadas_cond_str=  psaltadas_cond_str ||' and '|| c_all_vars.var_var|| ' is null' ;
         psaltadas_str= psaltadas_str || ', ' ||c_all_vars.var_var;
    END LOOP;
    IF psaltadas_str <>'' THEN
        psaltadas_cond_str= substr( psaltadas_cond_str,6);
        psaltadas_str= substr( psaltadas_str,3);
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
/*otra*/
ALTER FUNCTION encu.variables_saltadas(pope TEXT, porigen TEXT, pdestino TEXT,ptipodestino TEXT)
  OWNER TO tedede_php;
