-- Function: encu.variables_base_usuarios(text)

-- DROP FUNCTION encu.variables_base_usuarios(text);

CREATE OR REPLACE FUNCTION encu.variables_base_usuarios(p_base text)
  RETURNS void AS
$BODY$
DECLARE
   v_sentencia_var text;
   v_sentencia_var_hog text;
   v_sentencia_var_pers text;
   v_var_seleccionadas record;
   v_sentencia text;
   v_clausula text;
   v_vista text;
   v_campos_select text;
BEGIN
    v_sentencia= '';
    v_clausula='';
    v_sentencia_var:='';
    v_sentencia_var_hog:='';
    v_sentencia_var_pers:='';
    v_campos_select:='';
    v_vista:='';
    FOR v_var_seleccionadas in
       select column_name as var_bu, 
              case when varcal_nombrevar_baseusuario is not null then varcal_nombrevar_baseusuario  
              when var_nombrevar_baseusuario is not null then var_nombrevar_baseusuario 
              else substr(column_name,5) end as var_nombrebu,
              case when table_name in ('plana_i1_', 'plana_s1_p') then 'personas' 
                   when table_name in ('plana_a1_', 'plana_tem_', 'plana_s1_') then 'hogar' else '' end as tabla,
              case when varcal_nombrevar_baseusuario is not null then 2  
                   when var_nombrevar_baseusuario is not null then 1
                   else 0 end as var_orden      
          from information_schema.columns
            left join encu.varcal on varcal_ope = dbo.ope_actual() and varcal_activa and varcal_varcal=substr(column_name,5)
            left join encu.variables on var_ope = dbo.ope_actual() and var_var=substr(column_name,5) 
          where table_name in ('plana_a1_', 'plana_tem_', 'plana_s1_','plana_s1_p','plana_i1_') and table_schema='encu'
             and  substr(column_name,5) not in ('enc','hog','mie','exm','tlg')
             and  (varcal_baseusuario or var_baseusuario)
          order by tabla,var_orden,var_bu 
    LOOP
       IF p_base='basehogar' AND v_var_seleccionadas.tabla='hogar' THEN
         v_sentencia_var_hog:=v_sentencia_var_hog||v_var_seleccionadas.var_bu||' as '||v_var_seleccionadas.var_nombrebu||' ,';
       END IF;
       IF p_base='basepersonas' AND v_var_seleccionadas.tabla='personas' THEN
         v_sentencia_var_pers:=v_sentencia_var_pers||v_var_seleccionadas.var_bu||' as '||v_var_seleccionadas.var_nombrebu||' ,';
       END IF;  
    END LOOP;
       IF p_base='basehogar' THEN 
          v_clausula:=' from encu.plana_a1_ a
                         inner join encu.plana_s1_ as s1 on a.pla_enc=s1.pla_enc and a.pla_hog=s1.pla_hog
                         inner join encu.plana_tem_ t on a.pla_enc=t.pla_enc 
                         where t.pla_estado =79
                         order by a.pla_enc, a.pla_hog  ';
          v_sentencia_var:=substr(v_sentencia_var_hog,1,length(v_sentencia_var_hog)-1);
          v_campos_select:=' select a.pla_enc as enc, a.pla_hog as hog, ';          
       END IF;
       IF p_base='basepersonas' THEN                
       /* seria para personas*/                   
          v_clausula='  from encu.plana_s1_p s1_p 
                        inner join encu.plana_i1_ i1 on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie
                        inner join encu.plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and t.pla_mie=0
                        where t.pla_estado =79                        
                        order by s1_p.pla_enc, s1_p.pla_hog, s1_p.pla_mie  ';
          v_sentencia_var:=substr(v_sentencia_var_pers,1,length(v_sentencia_var_pers)-1);
          v_campos_select:=' select s1_p.pla_enc as enc, s1_p.pla_hog as hog, s1_p.pla_mie as mie, ';
       END IF;
       v_vista:=' drop view if exists encu.v_'||p_base||' ; '|| ' create view encu.v_'||p_base||' as ' ;
      -- raise notice 'v_vista %', v_vista;
       v_sentencia:=v_vista||v_campos_select||v_sentencia_var||v_clausula||';';
      -- raise notice 'Sentencia  %', v_sentencia;  
       execute v_sentencia;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION encu.variables_base_usuarios(text)
    OWNER TO tedede_php;

select encu.variables_base_usuarios('basehogar');
select encu.variables_base_usuarios('basepersonas');