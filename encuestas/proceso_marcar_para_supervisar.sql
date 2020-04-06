CREATE OR REPLACE FUNCTION marcar_para_supervisar(p_replica integer, p_comuna integer, p_up integer)
  RETURNS text AS
$BODY$
declare
  v_contador integer;
  v_encuesta record;
  v_tipo_sup integer; -- para ver si la primera vez es telefonica
  v_hace_sup boolean; -- para ver si hace o no supervision
  v_cant_sup_tel integer:=0;
  v_cant_sup_campo integer:=0;
begin
  v_contador:=0;
  for v_encuesta in
    select * 
      from plana_tem_ 
      where pla_replica=p_replica 
        and pla_comuna=p_comuna
        and pla_up=p_up
        and pla_rea_enc=1
        and pla_sup_diri=2
        and pla_sup_campo is null
      order by md5(pla_enc::text||pla_hn::text)
  loop
    v_contador:=v_contador+1;
    v_hace_sup:=true;
    if v_contador=1 then
      v_tipo_sup:=(v_encuesta.pla_enc+coalesce(v_encuesta.pla_up,0)) % 2+1;
    elsif v_contador=6 then
      v_tipo_sup:=(v_encuesta.pla_enc) % 2+1;
    elsif v_contador in (2,8) then
      v_tipo_sup:=3-v_tipo_sup;
    else
      v_hace_sup:=false;
    end if;
    if v_hace_sup then
      if v_tipo_sup=1 then
        v_cant_sup_campo:=v_cant_sup_campo+1;
      else
        v_cant_sup_tel:=v_cant_sup_tel+1;
      end if;
    end if;
    update respuestas 
      set res_valor=case when v_hace_sup then v_tipo_sup else 0 end, res_valesp=null, res_valor_con_error=null
      where res_enc=v_encuesta.pla_enc
        and res_ope='AJUS'
        and res_for='TEM'
        and res_mat=''
        and res_hog=0
        and res_var='sup_campo';
  end loop;
  return 'marcadas '||v_cant_sup_campo||' supervision presencial y '||v_cant_sup_tel||' supervision telefonica, de un total de '||v_contador||' viviendas';
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;