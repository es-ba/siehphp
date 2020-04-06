CREATE OR REPLACE FUNCTION marcar_para_supervisar_general(p_comuna integer, p_sesion bigint)
  RETURNS text AS
$BODY$
declare
  v_contador integer;
  v_cantidad_total integer;
  v_encuesta record;
  v_tipo_sup integer; -- para ver si la primera vez es telefonica
  v_hace_sup boolean; -- para ver si hace o no supervision
  v_cant_sup_tel integer:=0;
  v_cant_sup_campo integer:=0;
  v_comuna_anterior integer:=0;
  v_tlg bigint;
begin
  insert into tiempo_logico(tlg_ses) values (p_sesion)
    returning tlg_tlg into v_tlg;
  v_contador:=0;
  v_cantidad_total:=0;
  for v_encuesta in
    select * 
      from plana_tem_ 
      where pla_rea_enc=1
        and pla_sup_diri=2
        and pla_sup_campo is null
        and pla_replica<>7
        and (pla_comuna=p_comuna or p_comuna=0)
      order by pla_comuna, md5(pla_enc::text||pla_hn::text)
  loop
    if v_comuna_anterior<>v_encuesta.pla_comuna then
      v_contador:=0;
      v_comuna_anterior:=v_encuesta.pla_comuna;
    end if;
    v_contador:=v_contador+1;
    v_cantidad_total:=v_cantidad_total+1;
    v_hace_sup:=true;
    if v_contador=1 then
      v_tipo_sup:=(v_encuesta.pla_enc+coalesce(v_encuesta.pla_up,0)) % 2+1;
    elsif v_contador=2 then
      v_tipo_sup:=3-v_tipo_sup;
    else
      v_hace_sup:=false;
      if v_contador=8 then
        v_contador:=0;
      end if;
    end if;
    if v_hace_sup then
      if v_tipo_sup=1 then
        v_cant_sup_campo:=v_cant_sup_campo+1;
      else
        v_cant_sup_tel:=v_cant_sup_tel+1;
      end if;
    end if;
    update respuestas 
      set res_valor=case when v_hace_sup then v_tipo_sup else 0 end, res_valesp=null, res_valor_con_error=null, res_tlg=v_tlg
      where res_enc=v_encuesta.pla_enc
        and res_ope='AJUS'
        and res_for='TEM'
        and res_mat=''
        and res_hog=0
        and res_var='sup_campo';
  end loop;
  return 'marcadas '||v_cant_sup_campo||' supervision presencial y '||v_cant_sup_tel||' supervision telefonica, de un total de '||v_cantidad_total||' viviendas';
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;