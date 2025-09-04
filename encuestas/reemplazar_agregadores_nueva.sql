set search_path = encu, dbo, comun, public;
CREATE OR REPLACE FUNCTION encu.reemplazar_agregadores(p_cual text)
  RETURNS text AS
$BODY$
DECLARE
  v_cursor RECORD;
  v_obtenido TEXT:=p_cual;
  v_max_num integer;
  v_fun_abreviado text;
  v_fun_codigo text;
  v_funcion text;
  v_expresion text;
  v_filtro text;
  v_return_fun text;
  v_join_a1 text;
  v_hay_a1 integer;
  v_fun_m text;
  v_param_call text;
  v_param_fun text;
  v_lista_select text;
  v_from1 text;
  v_from2 text;
BEGIN
  --RAISE NOTICE 'ENTRO CON %',p_cual;
  FOR v_cursor IN
    SELECT distinct x[1] as encontrado, fun_fun, fun_abreviado
      FROM regexp_matches(p_cual,'@\(.*?\)@','g') x 
         LEFT JOIN dbx.funciones_automaticas ON x[1]=fun_fun
  LOOP
    --RAISE NOTICE 'ENCUENTRO % / % / %',v_cursor.encontrado,v_cursor.fun_fun,v_cursor.fun_abreviado;
    v_param_call='(enc,hog)';
    if v_cursor.fun_fun is null then
        if length(v_cursor.encontrado)>56 then
          RAISE NOTICE 'LARGO %',length(v_cursor.encontrado);
          --select max(substr(fun_fun,57,4)::integer)
          select CASE WHEN max(substr(fun_abreviado,58,4)::integer) IS NULL THEN NULL ELSE max(substr(fun_abreviado,58,4)::integer)+1 END
            into v_max_num
            from dbx.funciones_automaticas
            where substr(fun_fun,1,56)=substr(v_cursor.encontrado,1,56);
          RAISE NOTICE 'V_MAX_NUM %',v_max_num;
          v_fun_abreviado:=substr(v_cursor.encontrado,1,56)||'_'||trim(to_char(coalesce(v_max_num,1),'0000'))||')@';
        else
          v_fun_abreviado:=v_cursor.encontrado;
        end if;
        SELECT * FROM encu.reconocer_agregadores(v_cursor.encontrado) INTO v_funcion, v_expresion, v_filtro;
        --RAISE NOTICE 'RECONOCER: % / % / % / %',v_fun_abreviado,v_funcion, v_expresion, v_filtro;
        IF coalesce(v_funcion,'') not in ('sumap', 'contarc', 'sumapd', 'contarc_per','maxip','minip', 'relacionmax','relacionmin','relacioncontar') THEN 
          RAISE 'No se reconoce la funcion agregada %',v_funcion;
        END IF;
        --RAISE notice  'reconocer v_expresion %',v_expresion;      
        v_expresion:=reemplazar_variables(v_expresion,'pla_\1');
        v_filtro:=reemplazar_variables(v_filtro,'pla_\1');
        v_param_fun= '(p_enc integer, p_hog integer)';
        SELECT 1 INTO v_hay_a1 
            FROM encu.formularios
            WHERE for_for='A1'
            limit 1;
        if v_hay_a1=1 then
            v_join_a1=' JOIN plana_a1_ a1 ON s1.pla_enc=a1.pla_enc AND s1.pla_hog=a1.pla_hog';
        else
            v_join_a1='';
        end if; 
        --raise notice ' join_a %', v_join_a1;       
        v_from1='plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie ';
        v_from2='INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                '||v_join_a1||' 
                INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc ';
        if v_funcion similar to 'suma(pd|p)' then
          v_return_fun=' BIGINT';
          IF v_funcion='sumapd' THEN
              v_return_fun =' numeric';
          END IF;
          v_lista_select= concat('SUM(CASE WHEN ',v_expresion,' >0 THEN ',v_expresion, ' ELSE NULL END)'); 
        elseif v_funcion in ('maxip','minip') then
          if v_funcion='maxip' then 
              v_fun_m:='MAX';
          else 
              v_fun_m:='MIN';
          end if;
          v_return_fun=' INTEGER';
          v_lista_select= concat(v_fun_m,'(',v_expresion,')') ;
        elseif v_funcion in ('relacionmax','relacionmin','relacioncontar') then 
          if v_funcion='relacionmax' then 
              v_fun_m:='MAX';
          elseif v_funcion='relacionmin' then
              v_fun_m:='MIN';
          else 
              v_fun_m:='count';   
          end if; 
          v_expresion=replace(v_expresion,'pla_s1p.', 's1p.pla_');
          v_filtro=replace(v_filtro,'pla_nmiembro', 'p_mie');
          v_filtro=replace(v_filtro,'pla_p_mie', 'p_mie');
          v_param_call='(enc,hog,mie)';
          v_param_fun= '(p_enc integer, p_hog integer,p_mie integer)';
          v_return_fun=' INTEGER';
          v_lista_select= concat(v_fun_m,'(',v_expresion,')') ;
        elseif v_funcion in ('contarc', 'contarc_per') then
          v_return_fun=' BIGINT';
          v_fun_m= 'COUNT';
          v_lista_select= concat(v_fun_m,'(',v_expresion,')') ;
          v_from1=' plana_s1_p s1p '||case when v_funcion='contarc_per' then 'LEFT' else 'INNER' end ||' JOIN plana_i1_ i1 ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie';
        else    
          RAISE 'Falta la funcion agregada %',v_funcion;
        end if;
        v_fun_codigo:=$$
          CREATE OR REPLACE FUNCTION dbx.$$||quote_ident(v_fun_abreviado)|| v_param_fun ||$$ RETURNS $$|| v_return_fun
          ||$$
          LANGUAGE SQL AS
          $SQL$ SELECT $$||v_lista_select||$$
                  FROM $$||v_from1||$$
                      $$||v_from2||$$
                  WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                      $$||coalesce(v_filtro,'TRUE')||$$ 
                      /* $$||v_cursor.encontrado||$$  */
          $SQL$;
        $$;

        --raise notice 'codifo fun  %', v_fun_codigo;
        EXECUTE v_fun_codigo;
        INSERT INTO dbx.funciones_automaticas (fun_fun, fun_abreviado, fun_codigo,fun_tlg )
          VALUES (v_cursor.encontrado, v_fun_abreviado, v_fun_codigo, 1);
    else
        v_fun_abreviado:=v_cursor.fun_abreviado;
        IF v_fun_abreviado~*'(relacioncontar|relacionmax|relacionmin)@' THEN
            v_param_call='(enc,hog,mie)';     
        END IF;
    end if;
    -- v_obtenido:=replace(v_obtenido,v_cursor.encontrado, quote_ident(v_fun_abreviado)||'(enc,hog)');
    v_obtenido:=replace(v_obtenido,v_cursor.encontrado, 'dbx.'||quote_ident(v_fun_abreviado)||v_param_call);
	  --raise notice 'llamada a fun %', v_obtenido;
  END LOOP;
  return v_obtenido;
END;
$BODY$
  LANGUAGE plpgsql; 
ALTER FUNCTION encu.reemplazar_agregadores(text)
  OWNER TO tedede_php;

--ejemplo
--  select encu.reemplazar_agregadores('@(sumapd@h_perhab)@(enc,hog)')
--     suma variable decimal la variable deberia ser de miembro

##CASOS_SQL  

SELECT 'ERROR EN FUNCION' as que, entrada, esperado, encu.reemplazar_agregadores(entrada) as obtenido
    FROM (SELECT 't55>@(sumap@ i3_x + i3_t @ edad>14)@' as entrada, 't55>dbx."@(sumap@ i3_x + i3_t @ edad>14)@"(enc,hog)' as esperado
      UNION SELECT 't55>@(sumap@ i3_x @ edad>14)@' as entrada, 't55>dbx."nombre abreviado"(enc,hog)' as esperado
      UNION SELECT '@(sumap@ i3_x + i3_t @ edad>14)@+@(sumap@ i3_x @ edad>14)@' as entrada, 'dbx."@(sumap@ i3_x + i3_t @ edad>14)@"(enc,hog)+dbx."nombre abreviado"(enc,hog)' as esperado
      UNION SELECT 't55>55' as entrada, 't55>55' as esperado
      UNION SELECT 't55>@(sumap@ i2_totx @ edad>9)@ + @(sumap@ i3_1x @ edad>10 and edad>11 and edad>12 and edad>11 and edad>12 and edad>11 and edad>12 and edad>11 and edad>12 )@' as entrada,
         't55>dbx."@(sumap@ i2_totx @ edad>9)@"(enc,hog) + dbx."@(sumap@ i3_1x @ edad>10 and edad>11 and edad>12 and eda_0001)@"(enc,hog)' as esperado
    ) x
    WHERE encu.reemplazar_agregadores(entrada) is distinct from esperado
  UNION SELECT 'OK' as que, fun_fun, fun_abreviado, fun_codigo
     FROM dbx.funciones_automaticas; 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------     
set search_path=encu,dbo, dbx, comun;
select encu.reemplazar_agregadores('@(maxip@ioph_neto_imp@cond_activ=1)@(enc,hog)');
select encu.reemplazar_agregadores('@(minip@ioph_neto_imp@cond_activ=1)@(enc,hog)');  
select encu.reemplazar_agregadores('@(relacionmax@edad@edad>=0 and edad<=24 and p5=8 and p6_a=p_mie)@');     
select encu.reemplazar_agregadores('@(relacionmax@edad@p6_a=nmiembro)@');     

------

