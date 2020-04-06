-- Tabla donde se guardan los errores encontrados
--drop table encu.t_comparar_columnas ;
CREATE TABLE encu.t_comparar_columnas
(
  pla_enc integer,
  formulario text,
  hog integer,
  mie integer,
  exm integer,
  pla_valor text,
  res_valor text,
  res_var text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.t_comparar_columnas
  OWNER TO tedede_php;



-- devuelve la lista de registros donde el valor de la plana no coincide con el de respuestas
-- para una columna y un formulario dados.
-- presupone la existencia de la tabla t_comparar_columnas
--drop table encu.t_comparar_columnas ;
--select * into encu.t_comparar_columnas from v_comparar_columnas limit 0;
--drop function comparar_columna(text,text);
--drop view v_comparar_columnas;
create or replace function comparar_columna(p_nombre_columna text, p_for text, p_mat text)
 returns void
  language plpgsql as 
$body$
declare
  v_sql text;  
begin
    v_sql:= replace(replace(replace($sql$
            --CREATE OR REPLACE VIEW v_comparar_columnas as
            insert into encu.t_comparar_columnas 
            SELECT  pla_enc, '#for#'::text as formulario, pla_hog as hog, pla_mie as mie, pla_exm as exm, pla_#columna#::text as pla_valor, res.res_valor as res_valor, '#columna#'::text as res_var
            FROM encu.plana_#for#_#mat# plt
            inner join encu.respuestas res on plt.pla_enc = res.res_enc and res.res_ope='eah2012' and res.res_for='#for#' and res.res_var='#columna#' and res.res_mat='#mat#'
                       and res_hog=pla_hog and res_mie=pla_mie and res_exm=pla_exm
            where (pla_#columna#::text is distinct from res.res_valor::text) and (not ((pla_#columna#::text='-1' or pla_#columna#::text='-5' or pla_#columna#::text='-9') and res.res_valor::text is null));
            $sql$,'#columna#',p_nombre_columna),'#for#',p_for),'#mat#',p_mat);
    execute v_sql; --using p_for, p_mat;
end;
$body$

-- ejecuta comparar_columna para todas las variables de una lista dada, de un formulario dado.
create or replace function recorrer_para_comparar_(p_lista_columnas text[], p_for text, p_mat text)
 returns void
  language plpgsql as 
$body$
declare
  v_sql text;  
  v_col text;
begin
    FOREACH v_col IN ARRAY p_lista_columnas
    LOOP
        RAISE NOTICE 'col = %',v_col;
        perform comparar_columna(v_col,p_for,p_mat);
    END LOOP;
end;
$body$

-- ejecuta recorrer_para_comparar_ para la listas de variables de un formulario y matriz dados
create or replace function recorrer_para_comparar_planas(p_for text, p_mat text)
 returns void
  language plpgsql as 
$body$
declare
  v_cols text[];
  v_col text;
  v_k integer;
begin
        select array_agg(var_var) into v_cols from encu.variables where var_for=p_for and var_ope='eah2012' and var_mat=p_mat;
        RAISE NOTICE 'v_cols: %',v_cols;
        perform recorrer_para_comparar_(v_cols,p_for,p_mat);
end;
$body$

delete from encu.t_comparar_columnas ;
select recorrer_para_comparar_planas('TEM','');
select * from encu.t_comparar_columnas;--8953
select recorrer_para_comparar_planas('A1','');
select * from encu.t_comparar_columnas;--2
select recorrer_para_comparar_planas('A1','X');
select * from encu.t_comparar_columnas;--0
select recorrer_para_comparar_planas('S1','');
select * from encu.t_comparar_columnas;--3
select recorrer_para_comparar_planas('S1','P');
select * from encu.t_comparar_columnas;--0
select recorrer_para_comparar_planas('I1','');
select * from encu.t_comparar_columnas;--0

