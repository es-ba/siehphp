update encu.consistencias 
  set con_precondicion='rea<>2'
  where con_con='f_realiz_o';

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
  
update encu.consistencias 
  set con_precondicion='coalesce(rea_enc,rea_recu) in (1,3)'
  where con_con='TEM_cant_hogares';
