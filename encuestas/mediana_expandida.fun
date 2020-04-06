##FUN
mediana_expandida
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path = encu, dbo, comun, public;
-- DROP FUNCTION dbo.mediana_expandida(text, text);

CREATE OR REPLACE FUNCTION dbo.mediana_expandida(p_variable text, p_filtro text, p_modo text)
  RETURNS decimal AS
$BODY$ 
DECLARE
  v_variable text;
  v_resultado decimal;
  v_comando text;
  v_join_pla_ext_hog text;
  val_modo text;
BEGIN
  v_variable:='pla_'||p_variable;
  v_join_pla_ext_hog='';
  if p_modo!='' then
        val_modo=dbo.ope_actual();
        if p_modo='ETOI' then
            val_modo=p_modo;
        end if;
        v_join_pla_ext_hog=' inner join encu.pla_ext_hog x on x.pla_enc= s1.pla_enc and x.pla_hog= s1.pla_hog and x.pla_modo='''|| val_modo ||'''';
  end if;
  v_comando:= '
    SELECT round(AVG('||v_variable||')::numeric,1) from
        (select '||v_variable||', generate_series(1,pla_fexp) from plana_s1_p s1_p 
        inner join plana_i1_ i1 on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie 
        inner join plana_s1_ s1 on s1.pla_enc=i1.pla_enc and s1.pla_hog=i1.pla_hog and s1.pla_mie=0 
        inner join plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and s1.pla_mie=0 '||
        v_join_pla_ext_hog ||
        ' where '||v_variable||' is not null and '||p_filtro||' 
        order by 1
        LIMIT  2 - MOD((select sum(pla_fexp)  from encu.plana_i1_ i1 
        inner join plana_s1_p s1_p on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie 
        inner join plana_s1_ s1 on s1.pla_enc=i1.pla_enc and s1.pla_hog=i1.pla_hog and s1.pla_mie=0 
        inner join plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and s1.pla_mie=0 ' ||
        v_join_pla_ext_hog ||
        ' where '||v_variable||' is not null and '||p_filtro||'), 2)        
        OFFSET GREATEST(CEIL((select sum(pla_fexp)  from encu.plana_i1_ i1 
        inner join plana_s1_p s1_p on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie 
        inner join plana_s1_ s1 on s1.pla_enc=i1.pla_enc and s1.pla_hog=i1.pla_hog and s1.pla_mie=0 
        inner join plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and s1.pla_mie=0 '  ||
        v_join_pla_ext_hog ||
        ' where '||v_variable||' is not null and '||p_filtro||') / 2.0) - 1,0) ) x';
    execute v_comando into v_resultado;
    return v_resultado;
END;
$BODY$
  LANGUAGE plpgsql volatile;
ALTER FUNCTION dbo.mediana_expandida(text, text, text)
  OWNER TO tedede_php;
  
##CASOS_SQL
-- set search_path=encu,comun,public;
-- select dbo.mediana_expandida('e_aesc', '(pla_edad >= 25 and pla_e_aesc is distinct from 99 AND pla_e_aesc is distinct from 98) AND pla_estado>=77 AND pla_rea not in (0,2) AND pla_entrea <> 4','ETOI');
