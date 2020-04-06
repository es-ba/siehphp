CREATE OR REPLACE VIEW encu.variables_todas AS
SELECT var_ope, var_var, coalesce(var_texto,var_var) as var_texto, 'variables' as origen
  FROM encu.variables
UNION
SELECT varcal_ope as var_ope, varcal_varcal as var_var, coalesce(varcal_nombre,varcal_varcal) as var_texto, 'varcal' as origen
  FROM encu.varcal
  ORDER BY var_ope, var_var;
ALTER TABLE encu.variables_todas
  OWNER TO tedede_php;


CREATE OR REPLACE VIEW encu.opciones_todas AS
SELECT varcalopc_ope as opc_ope, varcalopc_varcal as opc_var, varcalopc_opcion::text as opc_opcion, 
  varcalopc_etiqueta as opc_texto, 'varcalopc'::text as origen, varcalopc_orden as opc_orden
  FROM encu.varcalopc
UNION
SELECT var_ope as opc_ope, var_var as opc_var, opc_opc as opc_opcion, opc_texto, 'opciones'::text as origen, null as opc_orden
  FROM encu.variables v 
    LEFT JOIN encu.con_opc c on v.var_ope = c.conopc_ope and v.var_conopc = c.conopc_conopc
    LEFT JOIN encu.opciones o on v.var_ope = o.opc_ope and c.conopc_conopc = o.opc_conopc 
  ORDER BY opc_ope, opc_var, opc_opcion;
ALTER TABLE encu.opciones_todas
  OWNER TO tedede_php;