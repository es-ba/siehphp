##FUN
generar_vista_variables_calculadas
##ESQ
encu
##PARA
revisar 
##DETALLE
##PROVISORIO
set search_path = encu, comun, dbo, public;

-- DROP FUNCTION IF EXISTS encu.generar_vista_variables_calculadas(text);

CREATE OR REPLACE FUNCTION encu.generar_vista_variables_calculadas() RETURNS TEXT
LANGUAGE plpgsql VOLATILE AS
$CUERPO$
DECLARE
  v_enter text:=chr(10)||chr(13)||'    ';
  v_destinos record;
  v_uapla record;
  v_campos_union record;
  v_varcal record;
  v_join text;
  v_tabla text;
  v_tabla_ant text;
  v_on text;
  v_create text;
  v_drop_v text;
  v_tabla_principal text;
  v_variables text;
  v_varexp text;
  v_otra_capa text;
  v_expresion text;
  v_variables_capa_anterior text;
  v_debug text;
  v_num_capa integer;
  v_nombre_vista text;
  v_ciclo_vista integer;
BEGIN
  -- v_identifica_var_regexp := '\m(?!AND)(?!OR)(?!NOT)(?!IS)(?!NULL)(?!IN)(?!TRUE)(?!FALSE)(?!EXISTS)(?!DISTINCT)(?!FROM)(?!BETWEEN)(?!dbo)([a-z]\w*)(?!\s*(\(|\$\$))\M';
  FOR v_destinos in
    select * 
      from varcal_destinos
      where varcaldes_ope=dbo.ope_actual()
      order by varcaldes_orden desc
  LOOP -- estoy dentro de un destino.
    v_num_capa :=1;
    --generar variables de otros formularios
    v_join:='';
    FOR v_uapla in
      SELECT *
        FROM ua_planas
        WHERE uapla_ua = v_destinos.varcaldes_ua
        ORDER BY uapla_orden
    LOOP
      v_tabla=v_uapla.uapla_pla;
      if v_join='' then
        v_tabla_principal:=v_tabla;
        v_join:=v_tabla;
      else
        SELECT string_agg(v_tabla_ant||'.pla_'||sufijo||' = '||v_tabla||'.pla_'||sufijo, ' AND ') FROM regexp_split_to_table(v_uapla.uapla_campos_union,',') as sufijo
          INTO v_on;
        v_join:=v_enter||v_join||' INNER JOIN '||v_tabla||' ON '||v_on;
      end if;
      v_tabla_ant:=v_tabla;
    END LOOP;
    SELECT string_agg(uapla_pla||'.pla_'||var_var, ', '), string_agg(var_var, ',') 
        INTO v_varexp, v_variables
        FROM (
        SELECT var_var, uapla_pla, row_number() over (partition by var_var order by uapla_orden) as marca
            FROM (select var_var, var_for, var_mat from variables WHERE var_ope=dbo.ope_actual() 
                union select substr(column_name,5), 'TEM', ''
                    from information_schema.columns
                    where table_schema='encu'
                      and table_name='plana_tem_'
                      and column_name not in ('pla_enc','pla_hog','pla_mie','pla_exm','pla_tlg')
                union select varcal_varcal, varcaldes_for, varcaldes_mat
                    from varcal join varcal_destinos on varcaldes_destino=varcal_destino
                    where varcal_activa and varcal_destino=v_destinos.varcaldes_destino and varcal_tipo !='normal'       
                      ) x
            INNER JOIN ua_planas ON var_for=uapla_for AND var_mat=uapla_mat AND uapla_ua = v_destinos.varcaldes_ua) z
        WHERE marca=1;
    v_create:='(select '||v_tabla_principal||'.pla_enc, '||v_tabla_principal||'.pla_hog, '||v_tabla_principal||'.pla_mie, '||v_tabla_principal||'.pla_exm, '||
      v_varexp||
      v_enter||' from '||v_join||')';
    v_varexp:='';
    v_variables_capa_anterior:=v_variables;
    FOR v_varcal IN 
      SELECT varcal_varcal, last_value(varcal_varcal) over ( ) ultima,
             v_enter||'CASE '||string_agg(' WHEN '||varcalopc_expresion_condicion||' THEN '||coalesce(varcalopc_expresion_valor,varcalopc_opcion::text), v_enter ORDER BY varcalopc_orden)||' END' as expresion
        FROM varcal INNER JOIN varcalopc ON varcal_ope = varcalopc_ope AND varcal_varcal = varcalopc_varcal 
        WHERE varcal_ope = dbo.ope_actual()
          AND varcal_destino = v_destinos.varcaldes_destino
          AND varcal_tipo = 'normal'
          AND varcal_activa
          AND varcal_orden<20000
        GROUP BY varcal_varcal, varcal_orden
        ORDER BY varcal_orden
    LOOP
      SELECT necesaria.necesaria /*, string_agg(coalesce(necesaria.necesaria,'*')||'='||coalesce(vista.vista,'*'), ', ')*/ INTO v_otra_capa --, v_debug
        FROM comun.extraer_identificadores(lower(v_varcal.expresion)) necesaria
          LEFT JOIN regexp_split_to_table(v_variables_capa_anterior,',') vista ON necesaria.necesaria=vista.vista
          WHERE vista IS NULL;
      raise notice 'result % %',v_otra_capa, v_varcal.varcal_varcal; 
      v_ciclo_vista= case when v_varcal.varcal_varcal=v_varcal.ultima then 2 else 1 end ;
      for i in 1 .. v_ciclo_vista loop
              if v_otra_capa is not null or v_ciclo_vista=2 then
                v_nombre_vista:='capa_'||v_destinos.varcaldes_ua||'_'||v_num_capa;
                v_drop_v:='DROP VIEW IF EXISTS '||v_nombre_vista||' CASCADE';
                v_create:='CREATE OR REPLACE VIEW '||v_nombre_vista||' AS '||'SELECT * '||v_varexp||v_enter||' from '||v_create||' x';
                IF v_num_capa>40 and v_ciclo_vista=1 or v_nombre_vista='capa_hog_27' THEN
                  RAISE NOTICE '%', v_create;
                  RETURN 'terminando antes';
                END IF;
                --EXECUTE v_drop_v;
                --EXECUTE v_create;
                v_create:=v_nombre_vista;
                v_num_capa:=v_num_capa+1;
                v_varexp:='';
                v_variables_capa_anterior:=v_variables;
                v_varexp:='';
                raise notice '%', v_variables;
              end if;
              v_expresion:=comun.reemplazar_variables(encu.reemplazar_agregadores(v_varcal.expresion), 'pla_\1');
              v_varexp:=v_varexp||', '||v_expresion ||' as pla_'||v_varcal.varcal_varcal;
              v_variables:=v_variables||','||v_varcal.varcal_varcal;
       END LOOP;       
    END LOOP;    
  END LOOP;
  RETURN 'procesadas ok variables.';
END;
$CUERPO$;

select encu.generar_vista_variables_calculadas();
