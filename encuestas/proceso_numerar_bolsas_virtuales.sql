CREATE OR REPLACE FUNCTION numerar_bolsas_virtuales(p_cant_enc_por_bolsa integer , p_solo_bolsas_completas boolean, p_bolsa_rea boolean, p_sesion integer)
  RETURNS text AS
$BODY$
declare
  v_bolsa integer;  
  v_where text;
  v_cant integer;
  v_select text;
  v_update text;
  v_remanentes integer;
  v_tlg integer;
  v_cant_bolsas integer;
  v_cant_embolsadas integer;  
  v_primera_bolsa integer;
  v_texto_salida text;
begin
  insert into tiempo_logico(tlg_ses) values (p_sesion)
    returning tlg_tlg into v_tlg;
    select coalesce (max(pla_bolsa)+1,case when p_bolsa_rea then 1001 else 6001 end) into v_bolsa  from plana_tem_ where case when p_bolsa_rea then pla_rea in (1,3) else pla_rea not in (1,3) end and case when p_bolsa_rea then pla_bolsa>1000 else pla_bolsa>6000 end;
    v_primera_bolsa:=v_bolsa;    
    v_where:= $$ 
    where pla_fin_campo is not null and case when $1 then pla_rea in (1,3) else pla_rea not in (1,3) end and pla_bolsa is null and (pla_estado<90 or pla_estado is null) and pla_hog=0 and pla_mie=0 and pla_exm=0 and pla_enc in ( select res_enc from respuestas inner join tiempo_logico on res_tlg = tlg_tlg where res_ope=dbo.ope_actual() and res_var='prox_rol' and res_valor is not null and res_for='TEM' and res_mat = '' and res_hog = '0' and res_mie = '0' and res_exm = '0' order by tlg_momento, res_enc) 
    $$;
    EXECUTE 'select count(pla_enc) from plana_tem_ ' || v_where into v_cant using p_bolsa_rea;
    v_cant_bolsas:= floor(v_cant/p_cant_enc_por_bolsa);
    if p_solo_bolsas_completas then
        v_remanentes:= v_cant-(v_cant_bolsas*p_cant_enc_por_bolsa);        
    else
        if mod(v_cant,p_cant_enc_por_bolsa)>0 then
            v_cant_bolsas:= v_cant_bolsas+1;                     
        end if;
        v_remanentes:=0;
    end if;
    v_cant_embolsadas:=v_cant-v_remanentes;
    v_where:=replace(v_where,'$1','$3');
    for i in 1..v_cant_bolsas LOOP
        v_update:= $$
        update respuestas set res_valor=$1, res_tlg = $2  where res_ope = dbo.ope_actual() and res_var = 'bolsa' 
        and res_for='TEM' and res_mat = '' and res_hog = '0' and res_mie = '0' and res_exm = '0' and res_enc in 
        (select pla_enc from plana_tem_ 
        $$;
        EXECUTE v_update || v_where || 'limit $4)' USING v_bolsa,v_tlg,p_bolsa_rea,p_cant_enc_por_bolsa;
        v_bolsa:=v_bolsa+1;
    end loop;
    v_texto_salida:=' Se numeraron ' || v_cant_bolsas || ' bolsas (' || v_cant_embolsadas || ' encuestas), quedaron ' || v_remanentes || ' encuestas remanentes.';
    if v_cant_embolsadas>0 then
        v_texto_salida:=v_texto_salida || ' De la bolsa ' || v_primera_bolsa || ' a la bolsa ' || v_primera_bolsa+v_cant_bolsas-1 ||'.';
    end if;
    return v_texto_salida;    
end;
$BODY$
  LANGUAGE plpgsql 
  ;
