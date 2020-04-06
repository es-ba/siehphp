SET SEARCH_PATH = encu, comun, public;

DROP SCHEMA IF EXISTS dbx cascade; 

CREATE SCHEMA dbx AUTHORIZATION tedede_php;

CREATE TABLE dbx.funciones_automaticas(
    fun_fun varchar(300) primary key,
    fun_abreviado varchar(63) not null unique,
    fun_codigo text
) owner tedede_php;

CREATE OR REPLACE FUNCTION encu.reemplazar_agregadores(p_cual text) RETURNS TEXT 
LANGUAGE plpgsql VOLATILE AS
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
BEGIN
  --RAISE NOTICE 'ENTRO CON %',p_cual;
  FOR v_cursor IN
    SELECT x[1] as encontrado, fun_fun, fun_abreviado
      FROM regexp_matches(p_cual,'@\(.*?\)@','g') x 
         LEFT JOIN dbx.funciones_automaticas ON x[1]=fun_fun
  LOOP
    --RAISE NOTICE 'ENCUENTRO % / % / %',v_cursor.encontrado,v_cursor.fun_fun,v_cursor.fun_abreviado;
    if v_cursor.fun_fun is null then
      if length(v_cursor.encontrado)>56 then
        RAISE NOTICE 'LARGO %',length(v_cursor.encontrado);
        select max(substr(fun_fun,57,4)::integer)
          into v_max_num
          from dbx.funciones_automaticas
          where substr(fun_fun,1,56)=substr(p_cual,1,56);
        v_fun_abreviado:=substr(v_cursor.encontrado,1,56)||'_'||trim(to_char(coalesce(v_max_num,1),'0000'))||')@';
      else
        v_fun_abreviado:=v_cursor.encontrado;
      end if;
      SELECT * FROM encu.reconocer_agregadores(v_cursor.encontrado) INTO v_funcion, v_expresion, v_filtro;
      RAISE NOTICE 'RECONOCER: % / % / % / %',v_fun_abreviado,v_funcion, v_expresion, v_filtro;
      IF v_funcion<>'sumap' and v_funcion<>'contarc' THEN 
        RAISE 'No se reconoce la funcion agregada %',v_funcion;
      END IF;
      v_expresion:=reemplazar_variables(v_expresion,'pla_\1');
      v_filtro:=reemplazar_variables(v_filtro,'pla_\1');
      if v_funcion='sumap' then
        v_fun_codigo:=$$
            CREATE OR REPLACE FUNCTION dbx.$$||quote_ident(v_fun_abreviado)||$$(p_enc integer, p_hog integer) RETURNS BIGINT 
            LANGUAGE SQL AS
            $SQL$ SELECT SUM(CASE WHEN $$||v_expresion||$$>0 THEN $$||v_expresion||$$ ELSE NULL END) 
                    FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                        INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                        INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                        INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                    WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                        $$||coalesce(v_filtro,'TRUE')||$$ 
                        /* $$||v_cursor.encontrado||$$  */
                    $SQL$;
        $$;
      else 
        if v_funcion='contarc' then
            v_fun_codigo:=$$
                CREATE OR REPLACE FUNCTION dbx.$$||quote_ident(v_fun_abreviado)||$$(p_enc integer, p_hog integer) RETURNS BIGINT 
                LANGUAGE SQL AS
                $SQL$ SELECT COUNT($$||v_expresion||$$) 
                        FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                            INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                            INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                            INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                        WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                            $$||coalesce(v_filtro,'TRUE')||$$ 
                            /* $$||v_cursor.encontrado||$$  */
                        $SQL$;
            $$;
        end if;
      end if;
      EXECUTE v_fun_codigo;
      INSERT INTO dbx.funciones_automaticas (fun_fun, fun_abreviado, fun_codigo)
        VALUES (v_cursor.encontrado, v_fun_abreviado, v_fun_codigo);
    else
      v_fun_abreviado:=v_cursor.fun_abreviado;
    end if;
    -- v_obtenido:=replace(v_obtenido,v_cursor.encontrado, quote_ident(v_fun_abreviado)||'(enc,hog)');
    v_obtenido:=replace(v_obtenido,v_cursor.encontrado, 'dbx.'||quote_ident(v_fun_abreviado)||'(enc,hog)');
  END LOOP;
  return v_obtenido;
END;
$BODY$;

CREATE OR REPLACE FUNCTION "@(sumap@ i3_x + i3_t @ edad>14)@"() RETURNS integer
language sql immutable as 
'select 1';

delete from dbx.funciones_automaticas;
insert into dbx.funciones_automaticas(fun_fun, fun_abreviado) values ('@(sumap@ i3_x + i3_t @ edad>14)@','@(sumap@ i3_x + i3_t @ edad>14)@');
insert into dbx.funciones_automaticas(fun_fun, fun_abreviado) values ('@(sumap@ i3_x @ edad>14)@','nombre abreviado');

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

--select dbx."@(sumap@ i2_totx @ edad>9)@"(130001,1);
  
  