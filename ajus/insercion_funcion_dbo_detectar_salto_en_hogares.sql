CREATE OR REPLACE FUNCTION dbo.detectar_salto_en_hogares(v_enc integer, v_hog integer)
  RETURNS integer AS
$BODY$
DECLARE
  vHogant integer;
BEGIN
  if v_hog!=1 then
    SELECT distinct(cla_hog) into vHogant
    from encu.claves  
    where cla_enc = v_enc and cla_hog=v_hog-1;
        if vHogant is null then 
        return 1; 
    end if;
  end if;
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
