--- !!!!!!!!!!!!!!!!!!!!!!! OJO SIN TERMINAR- SIRVE PARA EL GENERADOR
-- Function: encu.calcular_t_ocup()

-- DROP FUNCTION encu.calcular_t_ocup();

CREATE OR REPLACE FUNCTION encu.calcular_t_ocup()
  RETURNS trigger AS
$BODY$
declare v_sentencia text;
declare v_destino text;
declare v_identifica_var_regexp text;
declare v_reemplazos record;
declare v_opciones record;
declare v_expresion text;
declare v_resultado integer; 
declare v_sufijo text;
BEGIN
  v_resultado:=0;
  v_identifica_var_regexp := '\m(?!AND)(?!OR)(?!NOT)(?!IS)(?!NULL)(?!IN)(?!TRUE)(?!FALSE)(?!EXISTS)(?!DISTINCT)(?!FROM)(?!BETWEEN)([a-z]\w*)(?!\s*\()\M';
  select varcal_destino from encu.varcal where varcal_ope = dbo.ope_actual() and varcal_varcal = 't_ocup' into v_destino; --- DESTINO ME DICE QUE PLANA MODIFICAR
  CASE v_destino
      when 'hog' then
          v_sufijo:='S1';
      when 'mie' then
          v_sufijo:='I1';
      when 'exm' then
          v_sufijo:='A1_X';
  END; 
  FOR v_opciones IN 
    --- buscar todas las opciones de t_ocup y por cada una 
    select varcalopc_opcion as i_opcion, varcalopc_expresion as i_expresion from encu.varcalopc where varcalopc_ope = dbo.ope_actual() and varcalopc_varcal = 't_ocup' into v_opcion, v_expresion;
    LOOP
    FOR v_reemplazos IN
        select distinct(regexp_matches(v_opciones.i_expresion, v_identifica_var_regexp, 'ig')) as una_variable;  
        LOOP
            v_opciones.i_expresion:=replace(v_opciones.i_expresion,v_reemplazos.una_variable,'new.pla_'v_reemplazo.una_variable); 
        END LOOP;
        v_sentencia:='SELECT ';
        if execute v_opciones.i_expresion then
            v_resultado:=v_opciones.i_opcion;
        end if;
        EXIT WHEN v_resultado>0;
    END LOOP;
    --- luego con cada opcion hacer update de plana segun v_destino (si es 'hog' plana_s1, si es 'mie' plana_i1, si es 'exm' plana_a1_x
    --- usando valor que da v_opcion
    if v_resultado>0 then
   
        v_sentencia:='UPDATE encu.plana_'|v_sufijo|' SET t_ocup='|v_resultado|' WHERE pla_enc='|new.res_enc|' AND pla_hog='|new.res_hog|' AND pla_mie='|new.res_mie|' AND pla_exm='|new.res_exm;
    end if; 
  
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION encu.calcular_t_ocup()
  OWNER TO tedede_php;
