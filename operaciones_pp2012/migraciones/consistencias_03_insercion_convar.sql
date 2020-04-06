insert into encu.con_var
SELECT v.var_ope AS convar_ope, x.convar_con, x.vars[1] AS convar_var, 
        CASE
            WHEN v.var_var IS NULL THEN '**** NO ENCONTRADA ****'::character varying
            ELSE v.var_texto
        END AS convar_texto, v.var_for AS convar_for, v.var_mat AS convar_mat, v.var_orden AS convar_orden, 1 as convar_tlg
   FROM ( select convar_con, vars from (SELECT DISTINCT consistencias.con_con AS convar_con,  
regexp_matches(lower((COALESCE(consistencias.con_precondicion, ''::character varying)::text || ' '::text) || 
COALESCE(consistencias.con_postcondicion, ''::character varying)::text), '([A-Za-z][A-Za-z0-9_]*)(?![A-Za-z0-9_]|[.(])'::text, 'g'::text) AS vars
           FROM encu.consistencias  
           order by con_con) y where y.vars not in ('{or}','{and}')) x
   LEFT JOIN encu.variables v ON x.vars[1] = v.var_var::text
  WHERE x.vars[1] <> ALL (ARRAY['or'::text, 'and'::text]) and var_ope=dbo.ope_actual() and true;
