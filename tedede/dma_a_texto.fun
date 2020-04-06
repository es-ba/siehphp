CREATE OR REPLACE FUNCTION dbo.dma_a_texto(p_dia integer, p_mes integer, p_annio integer)
  RETURNS text AS
$BODY$
select lpad(coalesce(nullif(p_dia,-9),99)::text,2,'0')||'/'||lpad(coalesce(nullif(p_mes,-9),99)::text,2,'0')||'/'||lpad(coalesce(nullif(p_annio,-9),9999)::text,4,'0');
/*
*/
$BODY$
  LANGUAGE sql IMMUTABLE;
ALTER FUNCTION dbo.dma_a_texto(integer, integer, integer)
  OWNER TO tedede_php;

------- CASOS
  select dia,mes,annio,esperado,dbo.dma_a_texto(dia,mes,annio)
    from (
      select 31 dia, 12 mes, 2014 annio, '31/12/2014' esperado
      union select null dia, null mes, null annio, '99/99/9999' esperado
      union select -9 dia, -9 mes, -9 annio, '99/99/9999' esperado
    ) x
    where esperado::text is distinct from dbo.dma_a_texto(dia,mes,annio) 
