##FUN
generar_consistencias_auditoria()
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
-- Generar todas las consistencias de auditoria
--set search_path = encu, dbo, comun, public;

--drop function encu.generar_consistencias_auditoria();
CREATE OR REPLACE FUNCTION encu.generar_consistencias_auditoria()
  RETURNS  VOID AS
$BODY$
  select encu.generar_consistencias_flujo(ope_actual());

  select encu.generar_consistencias_audi_rango(ope_actual());

  select encu.generar_consistencias_audi_nsnc(ope_actual());

  select encu.generar_consistencias_audi_opc(ope_actual());

  select encu.generar_consistencias_filtro(ope_actual());

  select encu.generar_consistencias_flujo_obligatorio();

  select encu.generar_consistencias_continuidad();

  --FALTA
  -- ajustes de r0, dato que es una variable calculada que no consideran las funciones de generacion de consistencias.
  -- No son exactas las consistencias de auditoria, hay algunas problemas relacionados con el orden
  -- expresiones como is distinct from en los filtros como estan escritas no funcionan. Hay que modificarlas a mano
  -- algunas consistencias de salto del s1 y del s1_p se ven afectadas porque el algoritmo considera las variables del formulario sin considerar que pueden estar en distinta matriz

$BODY$
  LANGUAGE sql STABLE;
ALTER FUNCTION encu.generar_consistencias_auditoria()
  OWNER TO tedede_php;
##CASOS_SQL 

--Ejecución solo al inicio
--select encu.generar_consistencias_auditoria();




