CREATE or replace FUNCTION dbo.cantidad_de_miembros_tem(p_enc integer)
  RETURNS integer AS
$BODY$
declare 
    v_cant integer;
begin
    select coalesce(trim(pla_nmiembros_recu)::integer,pla_nmiembros) 
        into v_cant
        from encu.plana_tem_ 
        where pla_enc=p_enc;
    return v_cant;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
