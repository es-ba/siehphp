CREATE FUNCTION dbo.cantidad_de_miembros_ingresados(p_enc integer)
  RETURNS integer AS
$BODY$
declare 
    v_cant integer;
begin
    select count(*) 
        into v_cant 
        from encu.claves 
        where cla_ope='AJUS'
          and cla_for='AJH1'
          and cla_mat='M'
          and cla_enc=p_enc;
    return v_cant;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
