-- Function: dbo.mediana_expandida(text, text)

-- DROP FUNCTION dbo.mediana_expandida(text, text);

CREATE OR REPLACE FUNCTION dbo.mediana_expandida(p_variable text, p_filtro text)
  RETURNS decimal AS
$BODY$ 
DECLARE
  v_variable text;
  v_resultado decimal;
  v_comando text;
BEGIN
  v_variable:='pla_'||p_variable;
  v_comando:= '
    SELECT round(AVG('||v_variable||')::numeric,1) from
        (select '||v_variable||', generate_series(1,pla_fexp) from plana_s1_p s1_p 
        inner join plana_i1_ i1 on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie 
        inner join plana_s1_ s1 on s1.pla_enc=i1.pla_enc and s1.pla_hog=i1.pla_hog and s1.pla_mie=0 
        inner join plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and s1.pla_mie=0
        where '||v_variable||' is not null and '||p_filtro||' 
        order by 1
        LIMIT  2 - MOD((select sum(pla_fexp)  from encu.plana_i1_ i1 
        inner join plana_s1_p s1_p on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie 
        inner join plana_s1_ s1 on s1.pla_enc=i1.pla_enc and s1.pla_hog=i1.pla_hog and s1.pla_mie=0 
        inner join plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and s1.pla_mie=0
        where '||v_variable||' is not null and '||p_filtro||'), 2)        
        OFFSET GREATEST(CEIL((select sum(pla_fexp)  from encu.plana_i1_ i1 
        inner join plana_s1_p s1_p on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie 
        inner join plana_s1_ s1 on s1.pla_enc=i1.pla_enc and s1.pla_hog=i1.pla_hog and s1.pla_mie=0 
        inner join plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and s1.pla_mie=0
        where '||v_variable||' is not null and '||p_filtro||') / 2.0) - 1,0) ) x';
    execute v_comando into v_resultado;
    return v_resultado;
END;
$BODY$
  LANGUAGE plpgsql volatile;
ALTER FUNCTION dbo.mediana_expandida(text, text)
  OWNER TO tedede_php;

-- set search_path=encu,comun,public;
-- select dbo.mediana_expandida('e_aesc', '(pla_edad >= 25 and pla_e_aesc is distinct from 99 AND pla_e_aesc is distinct from 98) AND pla_estado>=79 AND pla_rea not in (0,2) AND pla_entrea <> 4');

-- Function: dbo.mediana_expandida_agrupada(text, text, text, integer)

-- DROP FUNCTION dbo.mediana_expandida_agrupada(text, text, text, integer);
  
CREATE OR REPLACE FUNCTION dbo.mediana_expandida_agrupada(p_variable text, p_filtro text, p_groupby text, p_valor integer)
  RETURNS decimal AS 
$BODY$ 
DECLARE
  v_resultado decimal;
  v_variable text;
  v_comando text;
  v_groupby text;
BEGIN
  v_variable:='pla_'||p_variable;
  v_groupby:='pla_'||p_groupby;
  v_comando:= '
    SELECT round(AVG('||v_variable||')::numeric,1) from
        (select '||v_variable||', generate_series(1,pla_fexp) from plana_s1_p s1_p 
        inner join plana_i1_ i1 on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie 
        inner join plana_s1_ s1 on s1.pla_enc=i1.pla_enc and s1.pla_hog=i1.pla_hog and s1.pla_mie=0 
        inner join plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and s1.pla_mie=0
        where '||v_variable||' is not null and '||p_filtro|| ' and '||v_groupby||' = '||p_valor|| ' 
        order by '||v_variable||'
        LIMIT  2 - MOD((select sum(pla_fexp)  from encu.plana_i1_ i1 
        inner join plana_s1_p s1_p on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie 
        inner join plana_s1_ s1 on s1.pla_enc=i1.pla_enc and s1.pla_hog=i1.pla_hog and s1.pla_mie=0 
        inner join plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and s1.pla_mie=0
        where '||p_filtro|| ' and '||v_groupby||' = '||p_valor||'), 2)
        OFFSET GREATEST(CEIL((select sum(pla_fexp)  from encu.plana_i1_ i1 
        inner join plana_s1_p s1_p on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie 
        inner join plana_s1_ s1 on s1.pla_enc=i1.pla_enc and s1.pla_hog=i1.pla_hog and s1.pla_mie=0 
        inner join plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and s1.pla_mie=0 
        where '||p_filtro|| ' and '||v_groupby||' = '||p_valor||') / 2.0) - 1,0) ) x';    
    execute v_comando into v_resultado;
    return v_resultado;
END;
$BODY$
  LANGUAGE plpgsql volatile;
ALTER FUNCTION dbo.mediana_expandida_agrupada(text, text, text, integer)
  OWNER TO tedede_php;

-- select dbo.mediana_expandida_agrupada('e_aesc', '(pla_edad >= 25 and pla_e_aesc is distinct from 99 AND pla_e_aesc is distinct from 98) AND pla_estado>=79 AND pla_rea not in (0,2) AND pla_entrea <> 4','comuna',1);
