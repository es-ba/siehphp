update encu.varcal set varcal_destino='hog' where varcal_ope='eah2013' and varcal_varcal='zona_3';
alter table encu.plana_i1_ drop column pla_zona_3;
alter table his.plana_i1_ drop column pla_zona_3;
set search_path = encu, comun, public;

DROP FUNCTION IF EXISTS operaciones.generar_trigger_variables_calculadas_trg();
DROP FUNCTION IF EXISTS encu.generar_trigger_variables_calculadas();

CREATE OR REPLACE FUNCTION encu.generar_trigger_variables_calculadas(p_cual text) RETURNS TEXT 
LANGUAGE plpgsql VOLATILE AS
$CUERPO$
DECLARE
  v_enter text:=chr(13)||chr(10);
  v_script_principio text;
  v_script_final text; 
  v_script_creador text; 
  v_variables record;
  v_opciones record;
  v_sentencia text;
  v_expresion text;
  v_opcion text;
  v_identifica_var_regexp text;
  v_destinos record;
  v_plana_trigger text;
  v_nombre_funcion text;
  v_sentencia_variable text;
  v_alterplanas text;
  v_alterhisplanas text;
  sent_set text;
  sentencia text;
  v_revisadas integer:=0;
  v_expresion_valor text;
BEGIN
  v_identifica_var_regexp := '\m(?!AND)(?!OR)(?!NOT)(?!IS)(?!NULL)(?!IN)(?!TRUE)(?!FALSE)(?!EXISTS)(?!DISTINCT)(?!FROM)(?!BETWEEN)(?!dbo)([a-z]\w*)(?!\s*(\(|\$\$))\M';
  FOR v_destinos in
    select destino, plana_destino from (
      select 'hog'::text as destino, 's1_'::text as plana_destino
      union select 'mie'::text, 'i1_'::text
      union select 'exm'::text, 'a1_x'::text
    ) x 
  LOOP
    v_sentencia:='';
    v_alterplanas:='';
    v_alterhisplanas:='';
    ---  recorro las variables calculadas para el formulario plana_destino  
    FOR v_variables in
        select varcal_varcal as i_variable
          from encu.varcal 
          where varcal_ope = dbo.ope_actual() 
            and varcal_destino = v_destinos.destino  
            and varcal_activa 
            and (varcal_varcal=p_cual or p_cual='#todo')
          order by varcal_orden
    LOOP
        v_revisadas:=v_revisadas+1;
        v_alterplanas:=v_alterplanas||'alter table encu.plana_'||v_destinos.plana_destino||' drop column if exists pla_'||v_variables.i_variable||';'||v_enter||'alter table encu.plana_'||v_destinos.plana_destino||' add column pla_'||v_variables.i_variable||' integer;'||v_enter;
        v_alterhisplanas:=v_alterhisplanas||'alter table his.plana_'||v_destinos.plana_destino||' drop column if exists pla_'||v_variables.i_variable||';'||v_enter||'alter table his.plana_'||v_destinos.plana_destino||' add column pla_'||v_variables.i_variable||' integer;'||v_enter;
        --- por cada variable recorro sus opciones
        v_sentencia_variable:=''; 
        FOR v_opciones IN 
            select varcalopc_opcion as i_opcion, varcalopc_expresion_condicion as i_expresion_condicion, varcalopc_expresion_valor as i_expresion_valor 
              from encu.varcalopc 
              where varcalopc_ope = dbo.ope_actual() and varcalopc_varcal = v_variables.i_variable 
        LOOP
           v_expresion:=v_opciones.i_expresion_condicion; 
           v_opcion:=v_opciones.i_opcion; 
           v_expresion_valor:=v_opciones.i_expresion_valor;
           v_expresion:= regexp_replace(v_expresion, v_identifica_var_regexp, 'new.pla_\1'::text,'ig');
           v_expresion:= regexp_replace(v_expresion, '\mnew.pla_(edad|sexo|comuna|h2|h3|v2)\M'::text, 'v_\1'::text,'ig');
           v_expresion_valor:= regexp_replace(v_expresion_valor, v_identifica_var_regexp, 'new.pla_\1'::text,'ig');
           v_expresion_valor:= regexp_replace(v_expresion_valor, '\mnew.pla_(edad|sexo|comuna|h2|h3|v2)\M'::text, 'v_\1'::text,'ig');
           v_sentencia_variable:=v_sentencia_variable||v_enter||'when ('||v_expresion||') then '||coalesce(v_expresion_valor,v_opcion);
        END LOOP;
        IF v_sentencia_variable<>'' THEN
              v_sentencia_variable:=' new.pla_'||v_variables.i_variable||':=case '||v_sentencia_variable||v_enter||' else null end; '||v_enter;
              v_sentencia:=v_sentencia||v_enter||v_sentencia_variable;
        END IF;
    END LOOP;
    IF v_sentencia<>'' THEN
        --- creo el script para generar
        v_plana_trigger:='encu.plana_'||v_destinos.plana_destino;
        v_nombre_funcion:='calculo_variables_calculadas_'||v_destinos.plana_destino||'_trg';
        v_script_principio:=$SCRIPT1$
        
        CREATE OR REPLACE FUNCTION encu.$1()
        RETURNS trigger AS
        $BODY$
        DECLARE
        v_edad integer;
        v_sexo integer;  
        v_comuna integer;
        v_h2 integer;
        v_h3 integer;
        v_v2 integer;
        BEGIN
        --- lee variables de otros formularios
        select pla_edad, pla_sexo 
            from encu.plana_s1_p  p
            where p.pla_enc = new.pla_enc 
            and p.pla_hog = new.pla_hog  
            and p.pla_mie = new.pla_mie
            and p.pla_exm = 0
            into v_edad, v_sexo;
        select pla_comuna from encu.plana_tem_ t
            where t.pla_enc = new.pla_enc 
            and t.pla_hog = 0  
            and t.pla_mie = 0
            and t.pla_exm = 0
            into v_comuna;
        select pla_h2, pla_h3, pla_v2 from encu.plana_a1_ a
            where a.pla_enc = new.pla_enc 
            and a.pla_hog = new.pla_hog
            and a.pla_mie = 0
            and a.pla_exm = 0
            into v_h2, v_h3, v_v2;
        $SCRIPT1$;
        v_script_final:=$SCRIPT2$
        return new;
        END
        $BODY$
        LANGUAGE plpgsql VOLATILE
        COST 100;
        ALTER FUNCTION encu.$1()
        OWNER TO tedede_php;
        
        DROP TRIGGER IF EXISTS $1 ON $2;
        
        
        CREATE TRIGGER $1
        BEFORE UPDATE
        ON $2
        FOR EACH ROW
        EXECUTE PROCEDURE encu.$1();
        $SCRIPT2$;
        v_script_creador:= v_alterplanas||v_alterhisplanas;
        v_script_creador:=v_script_creador|| v_script_principio||v_sentencia||v_script_final;
        v_script_creador:=replace(v_script_creador,'$1',v_nombre_funcion); 
        v_script_creador:=replace(v_script_creador,'$2',v_plana_trigger); 
        EXECUTE v_script_creador; 
        BEGIN
          sent_set='';
          sentencia='';
          case  v_destinos.plana_destino 
             when 'i1_' then 
               sent_set='  set pla_obs = pla_obs ';
             when 's1_' then     
               sent_set='  set pla_movil = pla_movil ';
             when 'a1_x' then    
               sent_set='  set pla_lugar = pla_lugar ';
          end case;
          sentencia= ' update encu.plana_'||v_destinos.plana_destino||sent_set;
          -- raise notice 'sentencia %', sentencia; 
          EXECUTE  sentencia;    
        END; 
    END IF;
  END LOOP;
  RETURN 'procesadas '||v_revisadas||' variables.';
END;
$CUERPO$;


select encu.generar_trigger_variables_calculadas('#todo');
