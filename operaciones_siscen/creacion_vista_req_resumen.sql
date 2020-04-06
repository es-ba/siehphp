CREATE OR REPLACE FUNCTION comun.traer_ultimo_request(p_proyecto text, p_requerimiento text)
  RETURNS text AS
$BODY$ 
DECLARE
v_reqnov_reqest text;
v_ultimo_reqest text;
BEGIN
 select max(reqnov_reqest) into v_reqnov_reqest from siscen.req_nov where reqnov_proy = p_proyecto and reqnov_req = p_requerimiento;
 select reqnov_reqest into v_ultimo_reqest from siscen.req_nov where reqnov_proy = p_proyecto and reqnov_req = p_requerimiento and reqnov_reqest=v_reqnov_reqest;
RETURN v_ultimo_reqest;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
/*OTRA*/
ALTER FUNCTION comun.traer_ultimo_request(text, text)
  OWNER TO siscen_php;
/*OTRA*/
create or replace view siscen.req_resumen
  as select requerimientos.*, req_proy || '*' || req_req as req_id, comun.traer_ultimo_request(req_proy,req_req) as req_estado, reqest_lado 
  from siscen.requerimientos 
      join siscen.req_est on reqest_reqest = comun.traer_ultimo_request(req_proy,req_req);
