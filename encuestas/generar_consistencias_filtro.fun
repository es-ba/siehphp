##FUN
generar_consistencias_filtro
##ESQ
encu
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path = encu, dbo, comun, public;

CREATE OR REPLACE FUNCTION encu.generar_consistencias_filtro(p_ope text)
  RETURNS void AS
$BODY$
declare
 v_filtros RECORD;
 v_variables_salteadas RECORD;
 v_matrices RECORD;
 v_preguntas RECORD;
 v_desde integer;
 v_hasta integer;
 v_precondicion text;
 v_postcondicion text;
 v_explicacion text;
 v_cuenta integer;
 v_activa BOOLEAN;
 v_codigo_filtro text;

BEGIN 
    DELETE FROM encu.inconsistencias
        WHERE inc_ope=p_ope and inc_con like 'flujo_f%';
    DELETE FROM encu.ano_con
        WHERE anocon_ope=p_ope and anocon_con like 'flujo_f%';
    DELETE FROM encu.con_var
        WHERE convar_ope=p_ope and convar_con like 'flujo_f%';
    DELETE FROM encu.consistencias
           WHERE con_ope=p_ope and con_con like 'flujo_f%';
    FOR v_matrices in
        SELECT mat_for as formulario, mat_mat as matriz, mat_texto as texto
               from encu.matrices 
               where mat_ope = p_ope and mat_for <> 'TEM'
        LOOP 
        FOR v_filtros in
            SELECT fil_for as formu, fil_mat as matri, fil_blo as bloque, fil_fil as filtro, fil_expresion as expresion, fil_destino as destino, 
                   fil_orden as orden     
               FROM encu.filtros
               WHERE fil_ope = p_ope and fil_for = v_matrices.formulario and fil_mat = v_matrices.matriz
               ORDER BY fil_orden
        LOOP
           v_precondicion:=replace(lower(v_filtros.expresion),'copia_','');
           select 'Filtro '||coalesce(v_filtros.filtro||' ','') || for_nombre into v_explicacion from encu.formularios where for_ope = p_ope and for_for = v_matrices.formulario;
           if v_matrices.matriz <> '' then
              v_explicacion:=v_explicacion||' '||v_matrices.texto;
           end if;
           --  verifico si el destino del filtro es una pregunta
           select count(*) into v_cuenta from encu.preguntas where pre_ope = p_ope and pre_pre = v_filtros.destino;
            if v_cuenta = 1 then 
              FOR v_preguntas in
                  select blo_blo as elemento, 'pregunta' as tipo, blo_orden as orden, blo_for as formulario, pre_pre as codigo_elemento, 
                         pre_orden as orden_elemento, (100000 * blo_orden  + pre_orden) as orden_final, '' as filtro_destino
                         from encu.bloques 
                         inner join encu.preguntas on blo_ope = pre_ope and blo_blo = pre_blo and blo_for = pre_for 
                         where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                  union select blo_blo as elemento, 'filtro' as tipo, blo_orden as orden, blo_for as formulario, fil_fil as codigo_elemento, 
                         fil_orden as orden_elemento, (100000* blo_orden + fil_orden) as orden_final, fil_destino as filtro_destino
                         from encu.bloques 
                         inner join encu.filtros on blo_ope = fil_ope and blo_blo = fil_blo and blo_for = fil_for
                         where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                         order by orden, orden_final
              LOOP
                 if v_preguntas.codigo_elemento = v_filtros.filtro then
                    v_desde:= v_preguntas.orden_final;
                 end if;
                 if v_preguntas.codigo_elemento = v_filtros.destino then
                    v_hasta:= v_preguntas.orden_final;
                 end if;
              END LOOP;
            else
              -- verifico si el destino es un bloque
              v_desde:= 0;
              v_hasta:= 0;
              select count(*) into v_cuenta from encu.bloques  where blo_ope = p_ope and blo_blo = v_filtros.destino;
              if v_cuenta = 1 then
                 FOR v_preguntas in
                     select blo_blo as elemento, 'pregunta' as tipo, blo_orden as orden, blo_for as formulario, pre_pre as codigo_elemento, 
                            pre_orden as orden_elemento, (100000 * blo_orden  + pre_orden) as orden_final, '' as filtro_destino
                            from encu.bloques 
                            inner join encu.preguntas on blo_ope = pre_ope and blo_blo = pre_blo and blo_for = pre_for 
                            where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                     union select blo_blo as elemento, 'filtro' as tipo, blo_orden as orden, blo_for as formulario, fil_fil as codigo_elemento, 
                            fil_orden as orden_elemento, (100000* blo_orden + fil_orden) as orden_final, fil_destino as filtro_destino
                            from encu.bloques 
                            inner join encu.filtros on blo_ope = fil_ope and blo_blo = fil_blo and blo_for = fil_for
                            where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                            order by orden, orden_final
                 LOOP
                    if v_preguntas.codigo_elemento = v_filtros.filtro then
                       v_desde:= v_preguntas.orden_final;
                    end if;
                    if v_preguntas.elemento = v_filtros.destino and v_hasta = 0 then
                       raise notice 'para destino bloque % , orden_final % ', v_filtros.destino, v_preguntas.orden_final;
                       v_hasta:= v_preguntas.orden_final;
                    end if;
                 END LOOP;
              else 
                 -- verifico si el destino es un filtro
                 select count(*) into v_cuenta from encu.filtros where fil_ope = p_ope and fil_fil = v_filtros.destino and fil_for=v_filtros.formu;
                 if v_cuenta = 1 then
                    FOR v_preguntas in
                        select blo_blo as elemento, 'pregunta' as tipo, blo_orden as orden, blo_for as formulario, pre_pre as codigo_elemento, 
                               pre_orden as orden_elemento, (100000 * blo_orden  + pre_orden) as orden_final, '' as filtro_destino
                               from encu.bloques 
                               inner join encu.preguntas on blo_ope = pre_ope and blo_blo = pre_blo and blo_for = pre_for 
                               where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                        union select blo_blo as elemento, 'filtro' as tipo, blo_orden as orden, blo_for as formulario, fil_fil as codigo_elemento, 
                               fil_orden as orden_elemento, (100000* blo_orden + fil_orden) as orden_final, fil_destino as filtro_destino
                               from encu.bloques 
                               inner join encu.filtros on blo_ope = fil_ope and blo_blo = fil_blo and blo_for = fil_for
                               where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                               order by orden, orden_final
                    LOOP
                       if v_preguntas.codigo_elemento = v_filtros.filtro then
                          v_desde:= v_preguntas.orden_final;
                       end if;
                       if v_preguntas.codigo_elemento = v_filtros.destino then
                          v_hasta:= v_preguntas.orden_final;
                       end if;
                    END LOOP;
                 else
                    --- verifico si el destino es 'fin'
                    if v_filtros.destino = 'fin' then
                       FOR v_preguntas in
                           select blo_blo as elemento, 'pregunta' as tipo, blo_orden as orden, blo_for as formulario, pre_pre as codigo_elemento, 
                                  pre_orden as orden_elemento, (100000 * blo_orden  + pre_orden) as orden_final, '' as filtro_destino
                                  from encu.bloques 
                                  inner join encu.preguntas on blo_ope = pre_ope and blo_blo = pre_blo and blo_for = pre_for 
                                  where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                           union select blo_blo as elemento, 'filtro' as tipo, blo_orden as orden, blo_for as formulario, fil_fil as codigo_elemento, 
                                  fil_orden as orden_elemento, (100000* blo_orden + fil_orden) as orden_final, fil_destino as filtro_destino
                                  from encu.bloques 
                                  inner join encu.filtros on blo_ope = fil_ope and blo_blo = fil_blo and blo_for = fil_for
                                  where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                                  order by orden, orden_final
                       LOOP
                          if v_preguntas.codigo_elemento = v_filtros.filtro then
                             v_desde:= v_preguntas.orden_final;
                          end if;
                          v_hasta:=v_preguntas.orden_final;
                       END LOOP;
                       v_hasta:=v_hasta+1;
                    end if;
                 end if;
              end if;
           end if;
           v_postcondicion:='true ';
           FOR v_preguntas in
               select x.codigo_elemento as codigo_pregunta from
               (select blo_blo as elemento, 'pregunta' as tipo, blo_orden as orden, blo_for as formulario, pre_pre as codigo_elemento, 
                       pre_orden as orden_elemento, (100000 * blo_orden  + pre_orden) as orden_final, '' as filtro_destino
                       from encu.bloques 
                       inner join encu.preguntas on blo_ope = pre_ope and blo_blo = pre_blo and blo_for = pre_for 
                       where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
               union select blo_blo as elemento, 'filtro' as tipo, blo_orden as orden, blo_for as formulario, fil_fil as codigo_elemento, 
                       fil_orden as orden_elemento, (100000* blo_orden + fil_orden) as orden_final, fil_destino as filtro_destino
                       from encu.bloques 
                       inner join encu.filtros on blo_ope = fil_ope and blo_blo = fil_blo and blo_for = fil_for
                       where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                       order by orden, orden_final) x
               where x.orden_final >= v_desde and x.orden_final < v_hasta
           LOOP
              FOR v_variables_salteadas in        
                   SELECT var_var as lavariable
                          FROM encu.preguntas 
                          inner join encu.variables on var_ope = pre_ope and pre_pre = var_pre
                          WHERE pre_ope = p_ope and pre_pre = v_preguntas.codigo_pregunta
                          ORDER BY var_orden         
              LOOP
                 v_postcondicion:=v_postcondicion || 'and '||v_variables_salteadas.lavariable||' is null ';
              END LOOP;
           END LOOP;
           v_activa=NOT (v_filtros.filtro='FILTRO_0');
           v_codigo_filtro='flujo_f_'||v_filtros.filtro||'_'||v_filtros.formu;
           INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
                                           con_postcondicion,
                                           con_activa, con_explicacion, con_tipo, con_falsos_positivos,
                                           con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
           values( p_ope, v_codigo_filtro, v_precondicion, '=>',
                   v_postcondicion, v_activa, v_explicacion, 'Auditoría', false,
                  'ALTA', 'Recepción', 'flujo', 'Error', 1) ;
            IF coalesce(v_hasta,0)=0 THEN
                RAISE EXCEPTION 'ERROR en consistencias % , destino no es pregunta, bloque, filtro o fin: %', v_codigo_filtro,v_filtros.destino;
            END IF;     
       END LOOP;
    END LOOP;
END
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
ALTER FUNCTION encu.generar_consistencias_filtro(text)
  OWNER TO tedede_php;

