##FUN
lee_tiempo_ajustado
##ESQ
dbo
##PARA
produccion
##PUBLICA
Sí
##PAR
p_enc    INTEGER
p_hog    INTEGER
p_mie    INTEGER
p_codigo INTEGER
p_varconsintiempo TEXT
##TIPO_DEVUELTO
boolean
##NOMBRE
lee_tiempo_ajustado
##DESCRIPCION
devuelve valor del tiempo que corresponde al tipo de tiempo, codigo, miembro,hogar,encuesta pasados como parametro
##CUERPO
-- DROP FUNCTION dbo.lee_tiempo_ajustado(integer, integer, integer, integer, text);

CREATE OR REPLACE FUNCTION dbo.lee_tiempo_ajustado(
    p_enc integer,
    p_hog integer,
    p_mie integer,
    p_codigo integer,
    p_varconsintiempo TEXT)
  RETURNS integer AS
$BODY$
DECLARE
  str_sql TEXT;
  valorconsintiempo integer=null;
BEGIN 
   if p_varconsintiempo not in ('pla_t_con_simu_min','pla_t_sin_simu_min') then
       raise exception 'Error lee_tiempo_ajustado, variable no considerada: %', p_varconsintiempo ;
   else  
       str_sql='select sum('|| quote_ident(p_varconsintiempo) ||') '   --'::integer ' ||
                ' from encu.diario_actividades_ajustado_vw '||
                ' where pla_enc=$1 and pla_hog=$2 and pla_mie=$3 and pla_codigo=$4 ;';
       execute str_sql INTO valorconsintiempo USING p_enc, p_hog, p_mie, p_codigo ;      
       --raise notice 'campo %', valorconsintiempo;
       --raise notice 'str_sql %', str_sql;
   end if;
   RETURN valorconsintiempo;
   
END   
$BODY$
  LANGUAGE plpgsql STABLE; 
ALTER FUNCTION dbo.lee_tiempo_ajustado(integer, integer, integer, integer,text)
  OWNER TO tedede_php;
