---------------------------
--creacion d el a formula
---------------------------

CREATE OR REPLACE FUNCTION dbo.v4_Hogar(p_enc integer)
  RETURNS integer AS
$BODY$
declare v_pla_v4 integer;

begin
	v_pla_v4 := 0;
	--select pla_v4 into V_pla_V4 from encu.plana_ajh1_ where pla_enc=p_enc and pla_hog=1;
	select res_valor into v_pla_v4 from encu.respuestas where res_enc = p_enc and res_hog = 1 and res_var = 'v4'; 
	return v_pla_v4;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION dbo.v4_Hogar(integer)
  OWNER TO tedede_php;

  
----------------------------------
--modificacion en la consistencia
-----------------------------------
UPDATE encu.consistencias SET con_postcondicion='h3<=dbo.v4_Hogar(enc)'  WHERE con_con='H3<=V4';

