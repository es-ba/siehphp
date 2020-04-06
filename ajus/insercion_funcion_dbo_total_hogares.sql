CREATE OR REPLACE FUNCTION dbo.total_hogares(p_enc integer)
  RETURNS integer AS
$BODY$
declare 
    v_cant integer;
begin
    select count(distinct(cla_hog)) 
      into v_cant 
      from encu.claves 
      where cla_enc=p_enc 
        and cla_ope='AJUS'
        and cla_for='AJH1'
        and cla_mat=''
        and cla_mie=0;
    return v_cant;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
