SET search_path = encu, pg_catalog;

--
-- Name: calculo_estado_trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION calculo_estado_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_estado_final integer;
  
  v_estado encu.plana_tem_.pla_estado%type; /*G*/
  v_asignable encu.plana_tem_.pla_asignable%type; /*G*/
  v_cod_enc encu.plana_tem_.pla_cod_enc%type; /*G*/
  v_dispositivo_enc encu.plana_tem_.pla_dispositivo_enc%type; /*G*/
  v_recepcionista encu.plana_tem_.pla_recepcionista%type; /*G*/
  v_fecha_carga_enc encu.plana_tem_.pla_fecha_carga_enc%type; /*G*/
  v_fecha_primcarga_enc encu.plana_tem_.pla_fecha_primcarga_enc%type; /*G*/
  v_fecha_descarga_enc encu.plana_tem_.pla_fecha_descarga_enc%type; /*G*/
  v_a_ingreso_enc encu.plana_tem_.pla_a_ingreso_enc%type; /*G*/
  v_volver_a_cargar_enc encu.plana_tem_.pla_volver_a_cargar_enc%type; /*G*/
  v_fin_ingreso_enc encu.plana_tem_.pla_fin_ingreso_enc%type; /*G*/
  v_rea_enc encu.plana_tem_.pla_rea_enc%type; /*G*/
  v_comenzo_ingreso encu.plana_tem_.pla_comenzo_ingreso%type; /*G*/
  v_norea_enc encu.plana_tem_.pla_norea_enc%type; /*G*/
  v_rea encu.plana_tem_.pla_rea%type; /*G*/
  v_norea encu.plana_tem_.pla_norea%type; /*G*/
  v_hog_pre encu.plana_tem_.pla_hog_pre%type; /*G*/
  v_hog_tot encu.plana_tem_.pla_hog_tot%type; /*G*/
  v_pob_pre encu.plana_tem_.pla_pob_pre%type; /*G*/
  v_pob_tot encu.plana_tem_.pla_pob_tot%type; /*G*/
  v_con_dato_enc encu.plana_tem_.pla_con_dato_enc%type; /*G*/
  v_carga encu.plana_tem_.pla_carga%type; /*G*/
  v_con_dato_sup encu.plana_tem_.pla_con_dato_sup%type; /*G*/
  v_sup_aleat encu.plana_tem_.pla_sup_aleat%type; /*G*/
  v_sup_dirigida encu.plana_tem_.pla_sup_dirigida%type; /*G*/
  v_cantidad_inconsistencias encu.plana_tem_.pla_cantidad_inconsistencias%type; /*G*/
  v_verificado_enc encu.plana_tem_.pla_verificado_enc%type; /*G*/
  v_comenzo_consistencias encu.plana_tem_.pla_comenzo_consistencias%type; /*G*/
  v_cod_recu encu.plana_tem_.pla_cod_recu%type; /*G*/
  v_dispositivo_recu encu.plana_tem_.pla_dispositivo_recu%type; /*G*/
  v_fecha_carga_recu encu.plana_tem_.pla_fecha_carga_recu%type; /*G*/
  v_fecha_primcarga_recu encu.plana_tem_.pla_fecha_primcarga_recu%type; /*G*/
  v_fecha_descarga_recu encu.plana_tem_.pla_fecha_descarga_recu%type; /*G*/
  v_fecha_descarga_sup encu.plana_tem_.pla_fecha_descarga_sup%type; /*G*/
  v_a_ingreso_recu encu.plana_tem_.pla_a_ingreso_recu%type; /*G*/
  v_volver_a_cargar_recu encu.plana_tem_.pla_volver_a_cargar_recu%type; /*G*/
  v_fin_ingreso_recu encu.plana_tem_.pla_fin_ingreso_recu%type; /*G*/
  v_rea_recu encu.plana_tem_.pla_rea_recu%type; /*G*/
  v_norea_recu encu.plana_tem_.pla_norea_recu%type; /*G*/
  v_con_dato_recu encu.plana_tem_.pla_con_dato_recu%type; /*G*/
  v_verificado_recu encu.plana_tem_.pla_verificado_recu%type; /*G*/
  v_cod_sup encu.plana_tem_.pla_cod_sup%type; /*G*/
  v_fecha_carga_sup encu.plana_tem_.pla_fecha_carga_sup%type; /*G*/
  v_result_sup encu.plana_tem_.pla_result_sup%type; /*G*/
  v_verificado_sup encu.plana_tem_.pla_verificado_sup%type; /*G*/
  v_per encu.plana_tem_.pla_per%type; /*G*/
  v_rol encu.plana_tem_.pla_rol%type; /*G*/
  v_en_campo encu.plana_tem_.pla_en_campo%type; /*G*/
  v_fecha_comenzo_descarga encu.plana_tem_.pla_fecha_comenzo_descarga%type; /*G*/
  v_casa encu.plana_tem_.pla_casa%type; /*G*/
  v_verificado_ac encu.plana_tem_.pla_verificado_ac%type; /*G*/
  v_manzana encu.plana_tem_.pla_manzana%type; /*G*/
  v_inq_tot_hab encu.plana_tem_.pla_inq_tot_hab%type; /*G*/
  v_fin_de_campo encu.plana_tem_.pla_fin_de_campo%type; /*G*/
  v_inq_ocu_flia encu.plana_tem_.pla_inq_ocu_flia%type; /*G*/
  v_cod_anacon encu.plana_tem_.pla_cod_anacon%type; /*G*/
  v_fin_anacon encu.plana_tem_.pla_fin_anacon%type; /*G*/
  v_dispositivo_sup encu.plana_tem_.pla_dispositivo_sup%type; /*G*/
  v_fin_anaproc encu.plana_tem_.pla_fin_anaproc%type; /*G*/
  v_fecha_primcarga_sup encu.plana_tem_.pla_fecha_primcarga_sup%type; /*G*/
  v_bolsa encu.plana_tem_.pla_bolsa%type; /*G*/
  v_etapa_pro encu.plana_tem_.pla_etapa_pro%type; /*G*/
  v_norea_sup encu.plana_tem_.pla_norea_sup%type; /*G*/
  v_resol_campo encu.plana_tem_.pla_resol_campo%type; /*G*/
  v_dominio encu.plana_tem_.pla_dominio%type; /*G*/
  
  v_en_campo_nuevo encu.plana_tem_.pla_en_campo%type; v_en_campo_viejo encu.plana_tem_.pla_en_campo%type; /*G*/
  
  v_rol_nuevo encu.plana_tem_.pla_rol%type; v_rol_viejo encu.plana_tem_.pla_rol%type; /*G_amano*/
  
  v_per_nuevo encu.plana_tem_.pla_per%type; v_per_viejo encu.plana_tem_.pla_per%type; /*G_amano*/
  
  v_calculo_enc integer;  
  v_calculo_recu integer;  
  i_sufijo integer;
  v_sufijo text;
  v_aux_aleat_enc text;
  v_aux_aleat_recu text;  
  v_reserva encu.plana_tem_.pla_reserva%type;
  v_sel_etoi14_villa encu.plana_tem_.pla_sel_etoi14_villa%type;
BEGIN
  if new.res_for='TEM' and 
        (new.res_valor is distinct from old.res_valor 
        or new.res_valesp is distinct from old.res_valesp 
        or new.res_valor_con_error is distinct from old.res_valor_con_error 
        or new.res_var = 'asignable'
        ) 
     and new.res_var<>'estado' -- porque vamos a actualizar el estado
  then
    if new.res_var='verificado_enc' and new.res_valor::integer<>2 then
        select pla_rea_enc, pla_norea_enc, pla_dominio, pla_hog_tot, (pla_enc*23 + pla_replica + pla_comuna*7 + coalesce(pla_id_marco,0)*21 + coalesce(pla_ccodigo,0)) % 10
            into   v_rea_enc, v_norea_enc, v_dominio, v_hog_tot, v_calculo_enc
            from encu.plana_tem_
            where pla_enc=new.res_enc and pla_hog=new.res_hog and pla_mie=new.res_mie and pla_exm=new.res_exm; 
        if (v_rea_enc = 1 or dbo.norea_supervisable(v_norea_enc)) and v_dominio in (3,4) then
            if v_calculo_enc = 1 and (v_dominio=3 or v_rea_enc=1) and coalesce(v_hog_tot,0)<=1 then
                v_aux_aleat_enc := '3';
            elsif v_calculo_enc = 0 and v_rea_enc = 1 and v_dominio=3 and coalesce(v_hog_tot,0)<=1 then
                v_aux_aleat_enc='4';
            else
                v_aux_aleat_enc := null;
            end if;
            UPDATE encu.respuestas
                SET res_valor=v_aux_aleat_enc, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
                    WHERE res_ope=new.res_ope
                        and res_for=new.res_for
                        and res_mat=new.res_mat
                        and res_enc=new.res_enc
                        and res_hog=new.res_hog
                        and res_mie=new.res_mie 
                        and res_exm=new.res_exm 
                        and res_var='sup_aleat'; 
        end if;
    elsif new.res_var='verificado_recu' and new.res_valor::integer<>2 then
        select pla_rea_recu, pla_norea_recu, pla_dominio, ((pla_enc*23 + pla_replica + pla_comuna*7 + coalesce(pla_id_marco,0)*21 + coalesce(pla_ccodigo,0)) % 10)
            into   v_rea_recu, v_norea_recu, v_dominio, v_calculo_recu
            from encu.plana_tem_
            where pla_enc=new.res_enc and pla_hog=new.res_hog and pla_mie=new.res_mie and pla_exm=new.res_exm;  
        if (v_rea_recu = 3 or dbo.norea_supervisable(v_norea_recu)) and v_dominio = 3 then
            if v_calculo_recu = 8 and 'si es la misma persona no hay supervision de campo'='x' then
                v_aux_aleat_recu := '3';
            elsif v_calculo_recu = 7 and v_rea_recu = 3 then
                v_aux_aleat_recu := '4';
            else
                v_aux_aleat_recu := null;
            end if;
            UPDATE encu.respuestas
                SET res_valor=v_aux_aleat_recu::text, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
                    WHERE res_ope=new.res_ope
                        and res_for=new.res_for
                        and res_mat=new.res_mat
                        and res_enc=new.res_enc
                        and res_hog=new.res_hog
                        and res_mie=new.res_mie 
                        and res_exm=new.res_exm 
                        and res_var='sup_aleat'; 
        end if;
    end if;
    select pla_reserva, pla_sel_etoi14_villa
      into   v_reserva,   v_sel_etoi14_villa
      from encu.plana_tem_
      where pla_enc=new.res_enc and pla_hog=new.res_hog and pla_mie=new.res_mie and pla_exm=new.res_exm;     
    select pla_estado /*G*/, pla_asignable /*G*/, pla_cod_enc /*G*/, pla_dispositivo_enc /*G*/, pla_recepcionista /*G*/, pla_fecha_carga_enc /*G*/, pla_fecha_primcarga_enc /*G*/, pla_fecha_descarga_enc /*G*/, pla_a_ingreso_enc /*G*/, pla_volver_a_cargar_enc /*G*/, pla_fin_ingreso_enc /*G*/, pla_rea_enc /*G*/, pla_comenzo_ingreso /*G*/, pla_norea_enc /*G*/, pla_rea /*G*/, pla_norea /*G*/, pla_hog_pre /*G*/, pla_hog_tot /*G*/, pla_pob_pre /*G*/, pla_pob_tot /*G*/, pla_con_dato_enc /*G*/, pla_carga /*G*/, pla_con_dato_sup /*G*/, pla_sup_aleat /*G*/, pla_sup_dirigida /*G*/, pla_cantidad_inconsistencias /*G*/, pla_verificado_enc /*G*/, pla_comenzo_consistencias /*G*/, pla_cod_recu /*G*/, pla_dispositivo_recu /*G*/, pla_fecha_carga_recu /*G*/, pla_fecha_primcarga_recu /*G*/, pla_fecha_descarga_recu /*G*/, pla_fecha_descarga_sup /*G*/, pla_a_ingreso_recu /*G*/, pla_volver_a_cargar_recu /*G*/, pla_fin_ingreso_recu /*G*/, pla_rea_recu /*G*/, pla_norea_recu /*G*/, pla_con_dato_recu /*G*/, pla_verificado_recu /*G*/, pla_cod_sup /*G*/, pla_fecha_carga_sup /*G*/, pla_result_sup /*G*/, pla_verificado_sup /*G*/, pla_per /*G*/, pla_rol /*G*/, pla_en_campo /*G*/, pla_fecha_comenzo_descarga /*G*/, pla_casa /*G*/, pla_verificado_ac /*G*/, pla_manzana /*G*/, pla_inq_tot_hab /*G*/, pla_fin_de_campo /*G*/, pla_inq_ocu_flia /*G*/, pla_cod_anacon /*G*/, pla_fin_anacon /*G*/, pla_dispositivo_sup /*G*/, pla_fin_anaproc /*G*/, pla_fecha_primcarga_sup /*G*/, pla_bolsa /*G*/, pla_etapa_pro /*G*/, pla_norea_sup /*G*/, pla_resol_campo /*G*/, pla_dominio /*G*/
      into   v_estado /*G*/,  v_asignable /*G*/,  v_cod_enc /*G*/,  v_dispositivo_enc /*G*/,  v_recepcionista /*G*/,  v_fecha_carga_enc /*G*/,  v_fecha_primcarga_enc /*G*/,  v_fecha_descarga_enc /*G*/,  v_a_ingreso_enc /*G*/,  v_volver_a_cargar_enc /*G*/,  v_fin_ingreso_enc /*G*/,  v_rea_enc /*G*/,  v_comenzo_ingreso /*G*/,  v_norea_enc /*G*/,  v_rea /*G*/,  v_norea /*G*/,  v_hog_pre /*G*/,  v_hog_tot /*G*/,  v_pob_pre /*G*/,  v_pob_tot /*G*/,  v_con_dato_enc /*G*/,  v_carga /*G*/,  v_con_dato_sup /*G*/,  v_sup_aleat /*G*/,  v_sup_dirigida /*G*/,  v_cantidad_inconsistencias /*G*/,  v_verificado_enc /*G*/,  v_comenzo_consistencias /*G*/,  v_cod_recu /*G*/,  v_dispositivo_recu /*G*/,  v_fecha_carga_recu /*G*/,  v_fecha_primcarga_recu /*G*/,  v_fecha_descarga_recu /*G*/,  v_fecha_descarga_sup /*G*/,  v_a_ingreso_recu /*G*/,  v_volver_a_cargar_recu /*G*/,  v_fin_ingreso_recu /*G*/,  v_rea_recu /*G*/,  v_norea_recu /*G*/,  v_con_dato_recu /*G*/,  v_verificado_recu /*G*/,  v_cod_sup /*G*/,  v_fecha_carga_sup /*G*/,  v_result_sup /*G*/,  v_verificado_sup /*G*/,  v_per /*G*/,  v_rol /*G*/,  v_en_campo /*G*/,  v_fecha_comenzo_descarga /*G*/,  v_casa /*G*/,  v_verificado_ac /*G*/,  v_manzana /*G*/,  v_inq_tot_hab /*G*/,  v_fin_de_campo /*G*/,  v_inq_ocu_flia /*G*/,  v_cod_anacon /*G*/,  v_fin_anacon /*G*/,  v_dispositivo_sup /*G*/,  v_fin_anaproc /*G*/,  v_fecha_primcarga_sup /*G*/,  v_bolsa /*G*/,  v_etapa_pro /*G*/,  v_norea_sup /*G*/,  v_resol_campo /*G*/,  v_dominio /*G*/
      from encu.plana_tem_
      where pla_enc=new.res_enc and pla_hog=new.res_hog and pla_mie=new.res_mie and pla_exm=new.res_exm; /*G:PK*/ -- pk_verificada
    if v_estado_final is null and (coalesce(v_verificado_ac, v_verificado_sup, v_verificado_recu, v_verificado_enc)=2 and v_dominio=4) then v_estado_final:=98; end if; /*G:E*/
    if v_estado_final is null and (v_fin_de_campo=1 and (v_rea=0 or v_rea=2) and v_norea is distinct from 18 and (v_fin_anacon is null OR v_fin_anaproc=1)) then v_estado_final:=90; end if; /*G:E*/
    if v_estado_final is null and (v_fin_anaproc=1 AND v_norea is distinct from 18) then v_estado_final:=79; end if; /*G:E*/
    if v_estado_final is null and (v_fin_anacon=1 AND v_norea is distinct from 18) then v_estado_final:=77; end if; /*G:E*/
    if v_estado_final is null and (v_resol_campo is not null AND v_norea is distinct from 18) then v_estado_final:=76; end if; /*G:E*/
    if v_estado_final is null and (v_fin_anacon=4 AND v_norea is distinct from 18) then v_estado_final:=75; end if; /*G:E*/
    if v_estado_final is null and (v_cod_anacon is not null AND v_norea is distinct from 18) then v_estado_final:=72; end if; /*G:E*/
    if v_estado_final is null and (v_fin_de_campo=1 AND v_norea is distinct from 18) then v_estado_final:=70; end if; /*G:E*/
    if v_estado_final is null and (v_norea is distinct from 18 and (v_verificado_enc=1  and ((v_dominio=3 and v_sup_dirigida is null and v_sup_aleat is null and ((v_rea=1 and v_hog_tot=1) or (not dbo.norea_recuperable(v_norea_enc)))) or (v_dominio is distinct from 3 and v_sup_dirigida is null and v_norea is distinct from 10)) or v_verificado_recu=1 and v_sup_dirigida is null and v_sup_aleat is null and ((v_rea=3 and v_hog_tot=1) or dbo.norea_recuperable(v_norea_enc)) or v_verificado_sup=1 or v_verificado_ac=1) or v_verificado_enc=3 or v_verificado_recu=3) then v_estado_final:=69; end if; /*G:E*/
    if v_estado_final is null and (v_verificado_ac=6 or v_verificado_enc=6 or v_verificado_recu=6 or v_verificado_sup=6 or  v_result_sup=6) then v_estado_final:=65; end if; /*G:E*/
    if v_estado_final is null and ((v_norea=18 and (v_verificado_recu is not null or v_verificado_sup is not null)) or (v_norea=10 and (v_dominio =4 or v_dominio=5) and v_verificado_enc=1)) then v_estado_final:=63; end if; /*G:E*/
    if v_estado_final is null and (v_verificado_enc=4 and (v_rea=1 and v_hog_tot=1 or v_dominio=4 or v_dominio=5) and v_sup_aleat is null and v_sup_dirigida is null or v_verificado_recu=4 and (v_rea=3 and v_hog_tot=1 or v_rea=2) and v_sup_aleat is null and v_sup_dirigida is null or v_verificado_sup=4) then v_estado_final:=60; end if; /*G:E*/
    if v_estado_final is null and (v_result_sup<>0 and (coalesce(v_sup_dirigida,v_sup_aleat)=4) and v_rea>=2) then v_estado_final:=58; end if; /*G:E*/
    if v_estado_final is null and (v_result_sup<>0 and v_rea>=2) then v_estado_final:=57; end if; /*G:E*/
    if v_estado_final is null and (v_fecha_carga_sup is not null and v_dispositivo_sup=1 and v_rea>=2) then v_estado_final:=56; end if; /*G:E*/
    if v_estado_final is null and (v_fecha_carga_sup is not null  AND (coalesce(v_sup_dirigida,v_sup_aleat)=4) AND v_rea>=2) then v_estado_final:=55; end if; /*G:E*/
    if v_estado_final is null and (v_fecha_carga_sup is not null and v_rea>=2) then v_estado_final:=54; end if; /*G:E*/
    if v_estado_final is null and (v_cod_sup <> 0 and (coalesce(v_sup_dirigida,v_sup_aleat)=4) and v_rea>=2) then v_estado_final:=53; end if; /*G:E*/
    if v_estado_final is null and (v_cod_sup <> 0 and v_rea>=2) then v_estado_final:=52; end if; /*G:E*/
    if v_estado_final is null and (v_verificado_recu is not null AND coalesce(v_sup_dirigida,v_sup_aleat)=4 and v_rea>=2) then v_estado_final:=51; end if; /*G:E*/
    if v_estado_final is null and ((((v_hog_tot>1/* OR v_norea<70*/) AND v_norea is distinct from 10 AND v_norea is distinct from 18 AND v_norea is distinct from 61) OR ((v_rea=3 OR NOT dbo.norea_recuperable(v_norea_recu) ) AND coalesce(v_sup_dirigida, v_sup_aleat)=3)) AND v_verificado_recu<>0) then v_estado_final:=50; end if; /*G:E*/
    if v_estado_final is null and (v_result_sup<>0 and (coalesce(v_sup_dirigida,v_sup_aleat)=4)) then v_estado_final:=48; end if; /*G:E*/
    if v_estado_final is null and (v_result_sup<>0) then v_estado_final:=47; end if; /*G:E*/
    if v_estado_final is null and (v_fecha_carga_sup is not null and v_dispositivo_sup=1) then v_estado_final:=46; end if; /*G:E*/
    if v_estado_final is null and (v_fecha_carga_sup is not null  AND (coalesce(v_sup_dirigida,v_sup_aleat)=4)) then v_estado_final:=45; end if; /*G:E*/
    if v_estado_final is null and (v_fecha_carga_sup is not null ) then v_estado_final:=44; end if; /*G:E*/
    if v_estado_final is null and (v_cod_sup <> 0 and (coalesce(v_sup_dirigida,v_sup_aleat)=4)) then v_estado_final:=43; end if; /*G:E*/
    if v_estado_final is null and (v_cod_sup <> 0) then v_estado_final:=42; end if; /*G:E*/
    if v_estado_final is null and (v_verificado_enc is not null AND coalesce(v_sup_dirigida,v_sup_aleat)=4) then v_estado_final:=41; end if; /*G:E*/
    if v_estado_final is null and ((((v_hog_tot>1/* OR v_norea<70*/) AND v_norea is distinct from 10 AND v_norea is distinct from 18 AND v_norea is distinct from 61 AND v_rea_recu is null and v_norea_recu is null) OR ((v_rea=1 OR NOT dbo.norea_recuperable(v_norea) ) AND (coalesce(v_sup_dirigida, v_sup_aleat)=3))) AND v_verificado_enc<>0) then v_estado_final:=40; end if; /*G:E*/
    if v_estado_final is null and (v_fin_ingreso_recu=1 OR v_con_dato_recu=1 and v_a_ingreso_recu is null) then v_estado_final:=37; end if; /*G:E*/
    if v_estado_final is null and (v_a_ingreso_recu=1) then v_estado_final:=36; end if; /*G:E*/
    if v_estado_final is null and (v_fecha_descarga_recu is not null  AND v_con_dato_recu=0) then v_estado_final:=35; end if; /*G:E*/
    if v_estado_final is null and (v_fecha_carga_recu is not null  AND v_dispositivo_recu=2) then v_estado_final:=34; end if; /*G:E*/
    if v_estado_final is null and (v_fecha_carga_recu is not null  AND v_dispositivo_recu=1) then v_estado_final:=33; end if; /*G:E*/
    if v_estado_final is null and (v_cod_recu<>0 AND v_dispositivo_recu<>0) then v_estado_final:=32; end if; /*G:E*/
    if v_estado_final is null and (dbo.norea_recuperable(v_norea) AND v_verificado_enc<>0 AND v_dominio = 3) then v_estado_final:=30; end if; /*G:E*/
    if v_estado_final is null and (v_fin_ingreso_enc=1 OR v_con_dato_enc=1 and v_a_ingreso_enc is null) then v_estado_final:=27; end if; /*G:E*/
    if v_estado_final is null and (v_a_ingreso_enc=1) then v_estado_final:=26; end if; /*G:E*/
    if v_estado_final is null and (v_fecha_descarga_enc is not null  AND v_con_dato_enc=0) then v_estado_final:=25; end if; /*G:E*/
    if v_estado_final is null and (v_fecha_carga_enc is not null  AND v_dispositivo_enc=2) then v_estado_final:=24; end if; /*G:E*/
    if v_estado_final is null and (v_fecha_carga_enc is not null AND v_dispositivo_enc=1) then v_estado_final:=23; end if; /*G:E*/
    if v_estado_final is null and (v_cod_enc<>0 AND v_dispositivo_enc<>0) then v_estado_final:=22; end if; /*G:E*/
    if v_estado_final is null and (v_asignable=1) then v_estado_final:=20; end if; /*G:E*/
    if v_estado_final is null and (v_reserva = comun.a_texto(1) or v_sel_etoi14_villa is null or v_sel_etoi14_villa = 1) then v_estado_final:=19; end if; /*G:E*/
    if v_estado_final is null and (true) then v_estado_final:=18; end if; /*G:E*/
    if v_estado_final is distinct from v_estado then
      UPDATE encu.respuestas
        SET res_valor=v_estado_final, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
        WHERE res_ope=new.res_ope
          and res_for=new.res_for
          and res_mat=new.res_mat
          and res_enc=new.res_enc
          and res_hog=new.res_hog
          and res_mie=new.res_mie 
          and res_exm=new.res_exm /*G:PK*/ 
          and res_var='estado'; -- pk_verificada
    end if;
  end if;
  for i_sufijo in 1..2 loop
      if i_sufijo=1 then
          v_sufijo='enc';
      else
          v_sufijo='recu';
      end if;
      if new.res_var='volver_a_cargar_'||v_sufijo and new.res_valor>='1' then
         UPDATE encu.respuestas
           SET res_valor=null, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
           WHERE res_ope=new.res_ope
             and res_for=new.res_for
             and res_mat=new.res_mat
             and res_enc=new.res_enc
             and res_hog=new.res_hog
             and res_mie=new.res_mie 
             and res_exm=new.res_exm 
             and res_var in ('fecha_carga_'||v_sufijo,'fecha_descarga_'||v_sufijo,'a_ingreso_'||v_sufijo,'con_dato_'||v_sufijo,'fin_ingreso_'||v_sufijo) -- pk_verificada
             and (res_valor is not null or res_valesp is not null or res_valor_con_error is not null);
      end if;
      if new.res_var='fecha_carga_'||v_sufijo and new.res_valor>'1' then
         UPDATE encu.respuestas
           SET res_valor=null, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
           WHERE res_ope=new.res_ope
             and res_for=new.res_for
             and res_mat=new.res_mat
             and res_enc=new.res_enc
             and res_hog=new.res_hog
             and res_mie=new.res_mie 
             and res_exm=new.res_exm 
             and res_var = 'volver_a_cargar_'||v_sufijo -- pk_verificada
             and (res_valor is not null or res_valesp is not null or res_valor_con_error is not null);
      end if;
      if new.res_var='a_ingreso_'||v_sufijo and new.res_valor='1' then
         UPDATE encu.respuestas
           SET res_valor='2', res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
           WHERE res_ope=new.res_ope
             and res_for=new.res_for
             and res_mat=new.res_mat
             and res_enc=new.res_enc
             and res_hog=new.res_hog
             and res_mie=new.res_mie 
             and res_exm=new.res_exm 
             and res_var = 'con_dato_'||v_sufijo -- pk_verificada
             and (res_valor is distinct from '2' or res_valesp is not null or res_valor_con_error is not null);
      end if;
  end loop;
-- seccion variables calculadas
  select 
      case when pla_estado in (23,24,33,34,44,54) then 1 else 0 end, pla_en_campo, /*G*/
      case when pla_estado<=29 then 'encuestador'  when pla_estado<=39 then 'recuperador' 
           when pla_estado<59 then  'supervisor'  else null end, pla_rol, /*G_amano*/
      case when pla_estado<=29 then pla_cod_enc when pla_estado<=39 then pla_cod_recu when pla_estado<49 then pla_cod_sup 
           when pla_estado<59 then pla_cod_sup else null end, pla_per /*G_amano*/
    into 
      v_en_campo_nuevo, v_en_campo_viejo, /*G*/
      v_rol_nuevo, v_rol_viejo, /*G_amano*/
      v_per_nuevo, v_per_viejo /*G_amano*/
    from encu.plana_tem_
    where pla_enc=new.res_enc and pla_hog=new.res_hog and pla_mie=new.res_mie and pla_exm=new.res_exm;
  if v_en_campo_nuevo is distinct from v_en_campo_viejo then
    UPDATE encu.respuestas
       SET res_valor=v_en_campo_nuevo, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
       WHERE res_ope=new.res_ope
         and res_for=new.res_for
         and res_mat=new.res_mat
         and res_enc=new.res_enc
         and res_hog=new.res_hog
         and res_mie=new.res_mie 
         and res_exm=new.res_exm 
         and res_var = 'en_campo'; -- pk_verificada
  end if; /*G*/
  if v_rol_nuevo is distinct from v_rol_viejo then
    UPDATE encu.respuestas
       SET res_valor=v_rol_nuevo, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
       WHERE res_ope=new.res_ope
         and res_for=new.res_for
         and res_mat=new.res_mat
         and res_enc=new.res_enc
         and res_hog=new.res_hog
         and res_mie=new.res_mie 
         and res_exm=new.res_exm 
         and res_var = 'rol'; -- pk_verificada
  end if; /*G_amano*/
  if v_per_nuevo is distinct from v_per_viejo then
    UPDATE encu.respuestas
       SET res_valor=v_per_nuevo, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
       WHERE res_ope=new.res_ope
         and res_for=new.res_for
         and res_mat=new.res_mat
         and res_enc=new.res_enc
         and res_hog=new.res_hog
         and res_mie=new.res_mie 
         and res_exm=new.res_exm 
         and res_var = 'per'; -- pk_verificada
  end if; /*G_amano*/
  RETURN new;
END
$$;


ALTER FUNCTION encu.calculo_estado_trg() OWNER TO tedede_php;

--
-- Name: calculo_variables_calculadas_i1__trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION calculo_variables_calculadas_i1__trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE
    v_nombre text;
    v_sexo integer;
    v_f_nac_d integer;
    v_f_nac_m integer;
    v_f_nac_a integer;
    v_edad integer;
    v_p4 integer;
    v_p5 integer;
    v_p5b integer;
    v_p6_b integer;
    v_p6_a integer;
    v_v2 integer;
    v_v2_esp text;
    v_v4 integer;
    v_v5 integer;
    v_v5_esp text;
    v_v6 integer;
    v_v7 integer;
    v_v12 integer;
    v_comuna integer;
    v_estado integer;
    v_dominio integer;
    v_h1 integer;
    v_h2 integer;
    v_h2_esp text;
    v_h3 integer;
    BEGIN
     SELECT pla_nombre,pla_sexo,pla_f_nac_d,pla_f_nac_m,pla_f_nac_a,pla_edad,pla_p4,pla_p5,pla_p5b,pla_p6_b,pla_p6_a
       INTO v_nombre,v_sexo,v_f_nac_d,v_f_nac_m,v_f_nac_a,v_edad,v_p4,v_p5,v_p5b,v_p6_b,v_p6_a
       FROM encu.plana_s1_p s
       WHERE  s.pla_enc = new.pla_enc and s.pla_hog = new.pla_hog and s.pla_mie = new.pla_mie and s.pla_exm = 0 ;
     SELECT pla_v2,pla_v2_esp,pla_v4,pla_v5,pla_v5_esp,pla_v6,pla_v7,pla_v12
       INTO v_v2,v_v2_esp,v_v4,v_v5,v_v5_esp,v_v6,v_v7,v_v12
       FROM encu.plana_a1_ a
       WHERE  a.pla_enc = new.pla_enc and a.pla_hog=1 and a.pla_mie = 0 and a.pla_exm = 0 ;
     SELECT pla_comuna,pla_estado,pla_dominio
       INTO v_comuna,v_estado,v_dominio
       FROM encu.plana_tem_ t
       WHERE  t.pla_enc = new.pla_enc and t.pla_hog = 0 and t.pla_mie = 0 and t.pla_exm = 0 ;
     SELECT pla_h1,pla_h2,pla_h2_esp,pla_h3
       INTO v_h1,v_h2,v_h2_esp,v_h3
       FROM encu.plana_a1_ a
       WHERE  a.pla_enc = new.pla_enc and a.pla_hog=new.pla_hog and a.pla_mie = 0 and a.pla_exm = 0 ;

     new.pla_e4_agr:=case 
        when (new.pla_e4<0) then -9
        when (new.pla_e4=1) then 1
        when (new.pla_e4=2 or new.pla_e4=3) then 2
         else null end; 

     new.pla_edad10a:=case 
        when (v_edad >= 0 and v_edad <= 9) then 1
        when (v_edad >= 10 and v_edad <= 19) then 2
        when (v_edad >= 20 and v_edad <= 29) then 3
        when (v_edad >= 30 and v_edad <= 39) then 4
        when (v_edad >= 40 and v_edad <= 49) then 5
        when (v_edad >= 50 and v_edad <= 59) then 6
        when (v_edad >= 60 and v_edad <= 69) then 7
        when (v_edad >= 70) then 8
         else null end; 

     new.pla_zona_3_1:=case 
        when (v_comuna=2 or v_comuna=13 or v_comuna=14) then 1
        when (v_comuna=1 or v_comuna=3 or v_comuna=5 or v_comuna=6 or v_comuna=7 or v_comuna=11 or v_comuna=12 or v_comuna=15) then 2
        when (v_comuna=4 or v_comuna=8 or v_comuna=9 or v_comuna=10) then 3
         else null end; 

     new.pla_edad10b:=case 
        when (v_edad >= 0 and v_edad <= 29) then 1
        when (v_edad >= 30 and v_edad <= 39) then 2
        when (v_edad >= 40 and v_edad <= 49) then 3
        when (v_edad >= 50 and v_edad <= 59) then 4
        when (v_edad >= 60) then 5
         else null end; 

     new.pla_t_ocup:=case 
        when (new.pla_t1<0 or new.pla_t2<0 or new.pla_t3<0 or new.pla_t4<4 or new.pla_t5<0 or new.pla_t6<0 or new.pla_t8<0) then -9
        when (new.pla_t1=1 and new.pla_t7=1) then 1
        when (new.pla_t1=1and new.pla_t7=2 and (new.pla_t8=1 or new.pla_t8=2)) then 2
        when (new.pla_t1=2 and new.pla_t2=1 and new.pla_t7=1) then 3
        when (new.pla_t1=2 and new.pla_t2=1 and new.pla_t7=2 and (new.pla_t8=1 or new.pla_t8= 2)) then 4
        when (new.pla_t1=2 and new.pla_t2=2 and new.pla_t3=5 and (new.pla_t4>=1and new.pla_t4<=3)) then 5
        when (new.pla_t1=2 and new.pla_t2=2 and new.pla_t3=5 and new.pla_t4=4 and new.pla_t5=1) then 6
        when (new.pla_t1=2 and new.pla_t2=2 and new.pla_t3=5 and new.pla_t4=5 and new.pla_t6=1) then 7
         else null end; 

     new.pla_sc_edad:=case 
        when (v_edad<14) then 0
        when (v_edad>=14 and v_edad<25) then 1
        when (v_edad>=25 and v_edad<35) then 2
        when (v_edad>=35 and v_edad<45) then 3
        when (v_edad>=45 and v_edad<55) then 4
        when (v_edad>=55 and v_edad<65) then 5
        when (v_edad>=65) then 6
         else null end; 

     new.pla_t_desoc:=case 
        when (new.pla_t1=2 and new.pla_t2=2 and (new.pla_T3=2 or new.pla_t3=3 or new.pla_t3=4) and (new.pla_t9<0 or new.pla_t12<0 or new.pla_t10<0 or new.pla_t11<0)) then -9
        when (new.pla_t1= 2 and new.pla_t2=2 and (new.pla_t3>=2 and new.pla_t3<=4) and new.pla_t9=1 and new.pla_t12=1) then 1
        when (new.pla_t1=2 and new.pla_t2=2 and (new.pla_t3>=2 and new.pla_t3<=4) and new.pla_t9=2 and new.pla_t10=1 and new.pla_t12=1) then 2
        when (new.pla_t1=2 and new.pla_t2=2 and (new.pla_t3>=2 and new.pla_t3<=4) and new.pla_t9=2 and new.pla_t10=2 and (new.pla_t11 >= 1 or new.pla_t11<=2) and new.pla_t12=1) then 3
        when (new.pla_t1=2 AND new.pla_t2=2 AND new.pla_t3= 5 AND new.pla_t4=4 AND (new.pla_t5=2 or new.pla_t5 = 3) AND new.pla_t9=1 AND new.pla_t12=1) then 4
        when (new.pla_t1= 2 AND new.pla_t2=2 AND new.pla_t3= 5 AND new.pla_t4=4 AND ( new.pla_t5=2 OR new.pla_t5 = 3) AND new.pla_t9=2 AND new.pla_t10=1 AND new.pla_t12=1) then 5
        when (new.pla_t1= 2 AND new.pla_t2=2 AND new.pla_t3= 5 AND new.pla_t4=4 AND (new.pla_t5=2 or new.pla_t5 = 3) AND new.pla_t10=2 AND (new.pla_t11= 1 oR new.pla_t11 = 2) AND new.pla_t12=1) then 6
        when ((new.pla_t1=2 AND new.pla_t2=2 AND new.pla_t3=5 AND new.pla_t4=5 AND (new.pla_t6=2 or new.pla_t6=3) AND new.pla_t9=1 AND new.pla_t12=1)) then 7
        when ((new.pla_t1= 2 AND new.pla_t2=2 AND new.pla_t3= 5 AND new.pla_t4=5 AND (new.pla_t6=2 or new.pla_t6= 3) AND new.pla_t9=2 AND new.pla_t10=1 AND new.pla_t12=1)) then 8
        when ((new.pla_t1= 2 AND new.pla_t2=2 AND new.pla_t3= 5 AND new.pla_t4=5 AND (new.pla_t6=2 or new.pla_t6 = 3) AND new.pla_t10=2 AND (new.pla_t11=1 OR new.pla_t11 = 2) AND new.pla_t12=1)) then 9
        when ((new.pla_t1= 1 AND new.pla_t7=2 AND new.pla_t8= 3 AND new.pla_t9=1 AND new.pla_t12=1)) then 10
        when ((new.pla_t1= 1 and new.pla_t7=2 and new.pla_t8= 3 and new.pla_t9=2 and new.pla_t10=1 and new.pla_t12=1)) then 11
        when ((new.pla_t1= 1 and new.pla_t7=2 and new.pla_t8= 3 and new.pla_t9=2 and new.pla_t10=2 and (new.pla_t11= 1 or new.pla_t11 = 2) and new.pla_t12=1)) then 12
        when ((new.pla_t1= 2 and new.pla_t2=1 and new.pla_t7=2 and new.pla_t8= 3 and new.pla_t9=1 and new.pla_t12=1)) then 13
        when ((new.pla_t1= 2 and new.pla_t2=1 and new.pla_t7=2 and new.pla_t8= 3 and new.pla_t9=2 and new.pla_t10=1 and new.pla_t12=1)) then 14
        when ((new.pla_t1= 2 and new.pla_t2=1 and new.pla_t7=2 and new.pla_t8= 3 and new.pla_t9=2 and new.pla_t10=2 and (new.pla_t11= 1 or new.pla_t11 = 2) and new.pla_t12=1)) then 15
         else null end; 

     new.pla_fp5_r:=case 
        when (v_edad<14) then 0
        when (v_p5=8) then 1
        when (v_p5=1) then 2
        when (v_p5=2) then 3
        when (v_p5=3 or v_p5=5 or v_p5=6) then 4
        when (v_p5=4 or v_p5=7) then 5
        when (v_p5<0) then 9
         else null end; 

     new.pla_fp5_agr:=case 
        when (v_p5<0) then -9
        when (v_p5=8) then 1
        when (v_p5=1 or v_p5=2) then 2
        when (v_p5=3 or v_p5=4 or v_p5=5 or v_p5=6 or v_p5=7) then 3
         else null end; 

     new.pla_t_ina:=case 
        when (new.pla_T1=2 AND new.pla_T2=2 AND new.pla_T3=1) then 1
        when (new.pla_T11 = 3 oR new.pla_T11 = 4 or new.pla_t11=5) then 2
        when (v_EDAD <= 9) then 3
        when (new.pla_T12 = 2) then 4
         else null end; 

     new.pla_cond_activ:=case 
        when (new.pla_t_ocup >= 1) then 1
        when (new.pla_t_desoc >= 1) then 2
        when (new.pla_t_ina >= 1) then 3
         else null end; 

     new.pla_t_desocup:=case 
        when (new.pla_cond_activ=2) then 1
         else null end; 

     new.pla_v2_2_mie:=case 
        when (v_v2=1) then 1
        when (v_v2=2) then 2
        when (v_v2=5) then 5
        when (v_v2=6) then 6
        when (v_v2=8) then 8
        when (v_v2=9) then 9
        when (v_v2=10) then 10
         else null end; 

     new.pla_e_nivela:=case 
        when (new.pla_e2=1 and new.pla_e6<0) then -9
        when (new.pla_e2=1 and (new.pla_e6 = 16 or new.pla_e6 = 17 or new.pla_e6 = 18 or new.pla_e6 = 2)) then 1
        when (new.pla_e2=1 and new.pla_e6 = 3) then 2
        when (new.pla_e2=1 and (new.pla_e6 = 7 or new.pla_e6 = 11)) then 4
        when (new.pla_e2=1 and new.pla_e6=12) then 6
        when (new.pla_e2=1 and new.pla_e6=13) then 7
        when (new.pla_e2=1 and new.pla_e6=5) then 8
        when (new.pla_e2 = 1 and new.pla_e6=6) then 10
        when (new.pla_e2 = 1 and new.pla_e6=15) then 12
        when (new.pla_e2 = 1 and new.pla_e6=10) then 14
        when (new.pla_e2 = 1 and new.pla_e6=14) then 16
         else null end; 

     new.pla_e_nivelb:=case 
        when (new.pla_e2=2 and (new.pla_e12<0 or new.pla_e13<0)) then -9
        when (new.pla_e2=2 and (new.pla_e12=16 or new.pla_e12=17 or new.pla_e12=18 or new.pla_e12=2)) then 1
        when (new.pla_e2=2 and new.pla_e13=2 and (new.pla_e12=3 or (new.pla_e12=4 and new.pla_e14>=1 and new.pla_e14<=6))) then 2
        when (new.pla_e2=2 and ((new.pla_e12=3 and new.pla_e13=1) or (new.pla_e12=4 and new.pla_e13=2 and new.pla_e14=7))) then 3
        when (new.pla_e2=2 and ((new.pla_e13=2 and (new.pla_e12=7 or new.pla_e12=11 or (new.pla_e12=4 and new.pla_e14>=8 and new.pla_e14<10))) or (new.pla_e13=1 and new.pla_e12=4))) then 4
        when (new.pla_e2 = 2 and (new.pla_e13=1 and (new.pla_e12=7 or new.pla_e12=11))) then 5
        when (new.pla_e2=2 and new.pla_e13=2 and new.pla_e12=5) then 8
        when (new.pla_e2=2 and new.pla_e13=1 and new.pla_e12=5) then 9
        when (new.pla_e2=2 and new.pla_e12=6) then 10
        when (new.pla_e2=2 and new.pla_e12=15 and new.pla_e13=2) then 12
        when (new.pla_e2=2 and new.pla_e12=15 and new.pla_e13=1) then 13
        when (new.pla_e2=2 and new.pla_e12=10 and new.pla_e13=2) then 14
        when (new.pla_e2=2 and new.pla_e12=10 and new.pla_e13=1) then 15
        when (new.pla_e2=2 and new.pla_e13=2 and new.pla_e12=12) then 17
        when (new.pla_e2=2 and new.pla_e13=1 and new.pla_e12=12) then 18
        when (new.pla_e2=2 and new.pla_e13=2 and new.pla_e12=13) then 19
        when (new.pla_e2=2 and new.pla_e13=1 and new.pla_e12=13) then 20
        when (new.pla_e2=2 and new.pla_e12=14) then 21
         else null end; 

     new.pla_e_nivelc:=case 
        when (new.pla_e_nivela<0 or new.pla_e_nivelb<0) then -9
        when (new.pla_e2=3) then 0
        when (new.pla_e_nivela=1 or new.pla_e_nivelb=1) then 1
        when (new.pla_e_nivela=2 or new.pla_e_nivelb=2) then 2
        when (new.pla_e_nivelb=3) then 3
        when (new.pla_e_nivela=4 or new.pla_e_nivelb=4) then 4
        when (new.pla_e_nivelb=5) then 5
        when (new.pla_e_nivela=6 or new.pla_e_nivelb=17 or new.pla_e_nivela=7 or new.pla_e_nivelb=19) then 6
        when (new.pla_e_nivela=16 or new.pla_e_nivelb=18 or new.pla_e_nivelb=20 or new.pla_e_nivelb=21) then 7
        when (new.pla_e_nivela=8 or new.pla_e_nivelb=8) then 8
        when (new.pla_e_nivelb=9) then 9
        when (new.pla_e_nivela=10 or new.pla_e_nivelb=10) then 10
        when (new.pla_e_nivela=12 or new.pla_e_nivelb=12) then 12
        when (new.pla_e_nivelb=13) then 13
        when (new.pla_e_nivela=14 or new.pla_e_nivelb=14) then 14
        when (new.pla_e_nivelb=15) then 15
         else null end; 

     new.pla_e_edad:=case 
        when (v_edad<25) then 1
        when (v_edad>=25) then 2
         else null end; 

     new.pla_e_nivel:=case 
        when (new.pla_e_nivelc<0 or new.pla_e2<0) then -9
        when (new.pla_e_nivelc=1) then 1
        when (new.pla_e_nivelc=2 or new.pla_e_nivelc=8 or new.pla_e_nivelc=12) then 2
        when (new.pla_e_nivelc=3 or new.pla_e_nivelc=9 or new.pla_e_nivelc=13) then 3
        when (new.pla_e_nivelc=4 or new.pla_e_nivelc=14) then 4
        when (new.pla_e_nivelc=5 or new.pla_e_nivelc=15) then 5
        when (new.pla_e_nivelc=6) then 6
        when (new.pla_e_nivelc=7) then 7
        when (new.pla_e_nivelc=0) then 8
        when (new.pla_e_nivelc=10) then 10
         else null end; 

     new.pla_e_nivel_agr:=case 
        when (new.pla_e_nivel=-9) then -9
        when (new.pla_e_nivel=1 or new.pla_e_nivel=2 or new.pla_e_nivel=8) then 1
        when (new.pla_e_nivel=3) then 2
        when (new.pla_e_nivel=4) then 3
        when (new.pla_e_nivel=5) then 4
        when (new.pla_e_nivel=6) then 5
        when (new.pla_e_nivel=7) then 6
        when (new.pla_e_nivel=10) then 10
         else null end; 

     new.pla_e_aesc:=case 
        when ((new.pla_e2=1 and (new.pla_e_nivel=4 or new.pla_e_nivel=2) and new.pla_e8<0) or (new.pla_e2=1 and new.pla_e6=12 and new.pla_e8<0) or (new.pla_e2=1 and new.pla_e6=13 and new.pla_e8<0) or (new.pla_e2=1 and new.pla_e6=14 and new.pla_e8<0) or (new.pla_e2=2 and (new.pla_e12=3 or new.pla_e12=5 or new.pla_e12=15) and new.pla_e13=2 and new.pla_e14<0) or (new.pla_e2=2 and new.pla_e12=4 and new.pla_e13=2 and new.pla_e14<0) or (new.pla_e2=2 and (new.pla_e12=7 or new.pla_e12=10) and new.pla_e13=2 and new.pla_e14<0) or (new.pla_e2=2 and new.pla_e12=11 and new.pla_e13=2 and new.pla_e14<0) or (new.pla_e2=2 and new.pla_e12=12 and new.pla_e13=2 and new.pla_e14<0) or (new.pla_e2=2 and new.pla_e12=13 and new.pla_e13=2 and new.pla_e14<0) or (new.pla_e2=2 and new.pla_e12=14 and new.pla_e13=2 and new.pla_e14<0) or (new.pla_e2=2 and new.pla_e12<0) or (new.pla_e2=2 and new.pla_e12>2 and new.pla_e13<0 and new.pla_e14<0) or (new.pla_e2=2 and new.pla_e12<0) or (new.pla_e6=6 or new.pla_e12=6)) then -9
        when (((v_edad>6 or (v_edad=6 and new.pla_edad_30=6)) and new.pla_e2=3) or (v_edad>=3 and (new.pla_e_nivel=1 or new.pla_e_nivel=8 or (new.pla_e2=2 and new.pla_e_nivel=2 and new.pla_e14=10)))) then 0
        when (new.pla_e2=2 and (new.pla_e12 = 3 or new.pla_e12 = 5 or new.pla_e12=15) and new.pla_e13=2 and new.pla_e14>6 and new.pla_e14<10) then 6
        when ((new.pla_e2 = 2 and new.pla_e_nivel = 3) or (new.pla_e2=2 and (new.pla_e12=7 or new.pla_e12=10) and new.pla_e13=2 and new.pla_e14=10)) then 7
        when (new.pla_e2=2 and new.pla_e12=4 and new.pla_e13=2 and new.pla_e14>8 and new.pla_e14 <10) then 8
        when ((new.pla_e2=2 and new.pla_e12=4 and new.pla_e13=1) or (new.pla_e2=1 and new.pla_e6=11 and new.pla_e8=1) or (new.pla_e2= 2 and new.pla_e12=11 and new.pla_e13=2 and new.pla_e14=10)) then 9
        when (new.pla_e2=1 and new.pla_e6=11 and new.pla_e8=2) then 10
        when ((new.pla_e2=1 and (new.pla_e6=7 or new.pla_e6=10) and new.pla_e8>5) or (new.pla_e2=1 and new.pla_e6=11 and new.pla_e8=3) or (new.pla_e2=2 and (new.pla_e12=7 OR new.pla_e12=10) and new.pla_e13=2 and new.pla_e14>4 and new.pla_e14<10) or (new.pla_e2=2 and new.pla_e12=11 and new.pla_e13=2 and new.pla_e14>2)) then 11
        when ((new.pla_e2=2 and new.pla_e_nivel = 5) or (new.pla_e2=1 and new.pla_e6=13 and new.pla_e8=11) or (new.pla_e2=2 and new.pla_e12=12 and new.pla_e13=2 and new.pla_e14=10) or (new.pla_e2=2 and new.pla_e12=13 and new.pla_e13=2 and new.pla_e14=10) or (new.pla_e2=2 and new.pla_e12=13 and new.pla_e13=2 and new.pla_e14=11)) then 12
        when ((new.pla_e2=1 and new.pla_e6=12 and new.pla_e8>3 and new.pla_e8<9) or (new.pla_e2=2 and new.pla_e12=12 and new.pla_e13=2 and new.pla_e14>2 and new.pla_e14<10)) then 14
        when (new.pla_e2=2 and new.pla_e_nivel=7 and new.pla_e12=12 and new.pla_e13=1) then 15
        when ((new.pla_e2=1 and new.pla_e6=13 and new.pla_e8>5 and new.pla_e8<=9) or (new.pla_e2=2 and new.pla_e12=13 and new.pla_e13=2 and new.pla_e14>4 and new.pla_e14<10)) then 16
        when ((new.pla_e2=2 and new.pla_e_nivel=7 and new.pla_e12=13 and new.pla_e13=1) or (new.pla_e2=2 and new.pla_e_nivel=7 and new.pla_e12=14 and new.pla_e13=2 and new.pla_e14=10) or (new.pla_e2=2 and new.pla_e12=14 and new.pla_e13=2 and new.pla_e14=10) or (new.pla_e_nivel=7 and new.pla_e2=1 and new.pla_e6=14 and new.pla_e8<0)) then 17
        when ((new.pla_e2=1 and new.pla_e6=14 and new.pla_e8>=3 and new.pla_e8<=5) or (new.pla_e2=2 and new.pla_e12=14 and new.pla_e13=2 and new.pla_e14>=1 and new.pla_e14<10)) then 18
        when (new.pla_e2 = 2 and new.pla_e_nivel = 7 and new.pla_e12 = 14 and new.pla_e13 = 1) then 19
        when (v_edad<3 or (new.pla_e2=3 and (v_edad<=5 or (v_edad=6 and new.pla_edad_30<=5)))) then 98
        when (new.pla_e2<0) then 99
        when (new.pla_e2=1 and new.pla_e_nivel=2 and new.pla_e8>0 and new.pla_e8<=7) then new.pla_e8 - 1
        when (new.pla_e2=1 and (new.pla_e6=7 or new.pla_e6=10) and new.pla_e8>0 and new.pla_e8<=5) then new.pla_e8 + 6
        when (new.pla_e2=1 and new.pla_e8>0 and ((new.pla_e6=12 and new.pla_e8<=3) or (new.pla_e8>0 and new.pla_e6=13 and new.pla_e8<=5))) then new.pla_e8 + 11
        when (new.pla_e2=1 and new.pla_e6=14 and (new.pla_e8=1 or new.pla_e8=2)) then new.pla_e8 + 16
        when (new.pla_e2=2 and new.pla_e13=2 and (((new.pla_e12=3 or new.pla_e12=5 or new.pla_e12=15) and new.pla_e14<=6 and new.pla_e14>0) or (new.pla_e12=4 and new.pla_e14>0 and new.pla_e14<9))) then new.pla_e14
        when (new.pla_e2=2 and (new.pla_e12=7 or new.pla_e12=10) and new.pla_e13=2 and new.pla_e14<=4 and new.pla_e14>0) then new.pla_e14 + 7
        when (new.pla_e2=2 and new.pla_e12=11 and new.pla_e13=2 and new.pla_e14<=2 and new.pla_e14>0) then new.pla_e14 + 9
        when (new.pla_e2=2 and new.pla_e13=2 and new.pla_e14>0 and ((new.pla_e12=12 and new.pla_e14<=2) or (new.pla_e12=13 and new.pla_e14<=4))) then new.pla_e14 + 12
         else null end; 

     new.pla_e_raesc:=case 
        when (new.pla_e_aesc<0 or new.pla_e_aesc>=98 or (new.pla_e12=13 and new.pla_e14<0) or (new.pla_e6=13 and new.pla_e8<0)) then -9
        when (new.pla_e_aesc >=0 and new.pla_e_aesc <= 3) then 1
        when (new.pla_e_aesc >= 4 and new.pla_e_aesc <= 6) then 2
        when (new.pla_e_aesc = 7) then 3
        when (new.pla_e_aesc >= 8 and new.pla_e_aesc <= 10) then 4
        when (new.pla_e_aesc >= 11 and new.pla_e_aesc <= 12) then 5
        when (new.pla_e_aesc = 13) then 6
        when (new.pla_e_aesc >= 14 and new.pla_e_aesc <= 19) then 7
         else null end; 

     new.pla_s_edad:=case 
        when (v_edad <= 19) then 1
        when (v_edad >= 20 and v_edad <= 59) then 2
        when (v_edad >= 60) then 3
         else null end; 

     new.pla_sn1_1a7:=case 
        when (true) then rango(new.pla_sn1_1,1,1) + rango(new.pla_sn1_2,1,1) + rango(new.pla_sn1_3,1,1) + rango(new.pla_sn1_4,1,1) + rango(new.pla_sn1_5,1,1) + rango(new.pla_sn1_7,1,1)
         else null end; 

     new.pla_tsemref:=case 
        when (new.pla_cond_activ=1 and (new.pla_t1=1 or new.pla_t2=1)) then 1
        when (new.pla_cond_activ=1 and new.pla_t1=2 and new.pla_t2=2) then 2
         else null end; 

     new.pla_sem_hs1p:=case 
        when ((new.pla_t31_d<0) OR (new.pla_t31_l<0) OR (new.pla_t31_ma<0) OR (new.pla_t31_mi<0) OR (new.pla_t31_j<0) OR (new.pla_t31_v<0) OR (new.pla_t31_s<0) OR (new.pla_t31_d>33) OR (new.pla_t31_l>33) OR (new.pla_t31_ma>33) OR (new.pla_t31_mi>33) OR (new.pla_t31_j>33) OR (new.pla_t31_v>33) OR (new.pla_t31_s>33)) then 0
        when (new.pla_t_diastra1p>0) then ((rango(new.pla_t31_d,1,24))+(rango(new.pla_t31_l,1,24))+(rango(new.pla_t31_ma,1,24))+(rango(new.pla_t31_mi,1,24))+(rango(new.pla_t31_j,1,24))+(rango(new.pla_t31_v,1,24))+(rango(new.pla_t31_s,1,24)))*(new.pla_t_diastra1p+new.pla_t_diasnotr1p)::numeric/new.pla_t_diastra1p
         else null end; 

     new.pla_sem_hs2p:=case 
        when ((new.pla_t32_d<0) OR (new.pla_t32_l<0) OR (new.pla_t32_ma<0) OR (new.pla_t32_mi<0) OR (new.pla_t32_j<0) OR (new.pla_t32_v<0) OR (new.pla_t32_s<0) OR (new.pla_t32_d>33) OR (new.pla_t32_l>33) OR (new.pla_t32_ma>33) OR (new.pla_t32_mi>33) OR (new.pla_t32_j>33) OR (new.pla_t32_v>33) OR (new.pla_t32_s>33)) then 0
        when (new.pla_t_diastra2p>0) then ((rango(new.pla_t32_d,1,24))+(rango(new.pla_t32_l,1,24))+(rango(new.pla_t32_ma,1,24))+(rango(new.pla_t32_mi,1,24))+(rango(new.pla_t32_j,1,24))+(rango(new.pla_t32_v,1,24))+(rango(new.pla_t32_s,1,24)))*(new.pla_t_diastra2p+new.pla_t_diasnotr2p)::numeric/new.pla_t_diastra2p

         else null end; 

     new.pla_sem_hs:=case 
        when ((new.pla_t31_d<0) OR (new.pla_t31_l<0) OR (new.pla_t31_ma<0) OR (new.pla_t31_mi<0) OR (new.pla_t31_j<0) OR (new.pla_t31_v<0) OR (new.pla_t31_s<0) OR (new.pla_t31_d>33) OR (new.pla_t31_l>33) OR (new.pla_t31_ma>33) OR (new.pla_t31_mi>33) OR (new.pla_t31_j>33) OR (new.pla_t31_v>33) OR (new.pla_t31_s>33) OR (new.pla_t32_d<0) OR (new.pla_t32_l<0) OR (new.pla_t32_ma<0) OR (new.pla_t32_mi<0) OR (new.pla_t32_j<0) OR (new.pla_t32_v<0) OR (new.pla_t32_s<0) OR (new.pla_t32_d>33) OR (new.pla_t32_l>33) OR (new.pla_t32_ma>33) OR (new.pla_t32_mi>33) OR (new.pla_t32_j>33) OR (new.pla_t32_v>33) OR (new.pla_t32_s>33)) then 0
        when (new.pla_t32_d is distinct from (-9) and new.pla_t32_l is distinct from (-9) and new.pla_t32_ma is distinct from (-9) and new.pla_t32_mi is distinct from (-9) and new.pla_t32_j is distinct from (-9) and new.pla_t32_v is distinct from (-9) and new.pla_t32_s is distinct from (-9) and new.pla_t31_d is distinct from (-9) and new.pla_t31_l is distinct from (-9) and new.pla_t31_ma is distinct from (-9) and new.pla_t31_mi is distinct from (-9) and new.pla_t31_j is distinct from (-9) and new.pla_t31_v is distinct from (-9) and new.pla_t31_s is distinct from (-9)) then coalesce(new.pla_sem_hs1p,0)+ coalesce(new.pla_sem_hs2p,0)
         else null end; 

     new.pla_t_categ:=case 
        when (new.pla_cond_activ=1 and (new.pla_t46=-9 or new.pla_t47=-9 or new.pla_t48=-9 or new.pla_t44=-9 or new.pla_t45=-9)) then -9
        when (new.pla_cond_activ = 1 and new.pla_t46 = 1) then 1
        when ((new.pla_cond_activ = 1 and (new.pla_t46 = 2 or new.pla_t46 = 3) and (new.pla_t47 = 2 or (new.pla_t47 = 1 and new.pla_t48 = 2)))) then 2
        when ((new.pla_cond_activ = 1 and new.pla_t44 = 3 or (new.pla_t44 = 2 and new.pla_t45 =1))) then 3
        when ((new.pla_cond_activ = 1 and ( (new.pla_t46 = 2 or new.pla_t46 = 3) and new.pla_t47 = 1 and new.pla_t48 = 1))) then 4
        when (new.pla_cond_activ = 1 and new.pla_t37sd = 1) then 5
        when ((new.pla_cond_activ = 1 and new.pla_t44 = 2 and new.pla_t45 = 3)) then 6
         else null end; 

     new.pla_categori:=case 
        when (new.pla_t_categ<0) then -9
        when (new.pla_cond_activ=2 or new.pla_cond_activ=3) then 0
        when (new.pla_t_categ = 1) then 1
        when (new.pla_t_categ = 2) then 2
        when (new.pla_t_categ >= 3 and new.pla_t_categ <= 5) then 3
        when (new.pla_t_categ = 6) then 4
         else null end; 

     new.pla_tipodes:=case 
        when (new.pla_cond_activ= 2 and (new.pla_t16<0 or new.pla_t16=2) and new.pla_t18<=0) then -9
        when (new.pla_cond_activ= 2 and (new.pla_t16 = 1 or new.pla_t18 = 1)) then 1
        when (new.pla_cond_activ= 2 and new.pla_t16 = 2 and new.pla_t18= 2) then 2
         else null end; 

     new.pla_f_edad:=case 
        when (v_edad >= 14 and v_edad <= 19) then 1
        when (v_edad >= 20 and v_edad <= 24) then 2
        when (v_edad >= 25 and v_edad <= 29) then 3
        when (v_edad >= 30 and v_edad <= 39) then 4
        when (v_edad >= 40 and v_edad <= 49) then 5
        when (v_edad >= 50 and v_edad <= 59) then 6
        when (v_edad >= 60 and v_edad <= 69) then 7
        when (v_edad >= 70) then 8
         else null end; 

     new.pla_categdes:=case 
        when ((new.pla_cond_activ= 2 and new.pla_t22 = 1)) then 1
        when ((new.pla_cond_activ= 2 and (new.pla_t22 = 2 or new.pla_t22 = 3))) then 2
        when ((new.pla_cond_activ= 2 and new.pla_t20 = 3 or (new.pla_t20 = 2 and new.pla_t21 = 1))) then 3
        when ((new.pla_cond_activ= 2 and new.pla_t20 = 2 and new.pla_t21 = 3)) then 4
         else null end; 

     new.pla_i12_nsnr:=case 
        when (new.pla_i12>=0) then 1
        when (new.pla_i12<0) then 9
         else null end; 

     new.pla_i13_nsnr:=case 
        when (new.pla_i13>=0) then 1
        when (new.pla_i13<0) then 9
         else null end; 

     new.pla_i14_nsnr:=case 
        when (new.pla_i14>=0) then 1
        when (new.pla_i14<0) then 9
         else null end; 

     new.pla_i3_10x_nsnr:=case 
        when (new.pla_i3_10x>=0) then 1
        when (new.pla_i3_10x<0) then 9
         else null end; 

     new.pla_i3_11x_nsnr:=case 
        when (new.pla_i3_11x>=0) then 1
        when (new.pla_i3_11x<0) then 9
         else null end; 

     new.pla_i3_12x_nsnr:=case 
        when (new.pla_i3_12x>=0) then 1
        when (new.pla_i3_12x<0) then 9
         else null end; 

     new.pla_i3_13x_nsnr:=case 
        when (new.pla_i3_13x>=0) then 1
        when (new.pla_i3_13x<0) then 9
         else null end; 

     new.pla_i3_1x_nsnr:=case 
        when (new.pla_i3_1x>=0) then 1
        when (new.pla_i3_1x<0) then 9
         else null end; 

     new.pla_i3_2x_nsnr:=case 
        when (new.pla_i3_2x>=0) then 1
        when (new.pla_i3_2x<0) then 9
         else null end; 

     new.pla_i3_31x_nsnr:=case 
        when (new.pla_i3_31x>=0) then 1
        when (new.pla_i3_31x<0) then 9
         else null end; 

     new.pla_i3_3x_nsnr:=case 
        when (new.pla_i3_3x>=0) then 1
        when (new.pla_i3_3x<0) then 9
         else null end; 

     new.pla_i3_4x_nsnr:=case 
        when (new.pla_i3_4x>=0) then 1
        when (new.pla_i3_4x<0) then 9
         else null end; 

     new.pla_i3_5x_nsnr:=case 
        when (new.pla_i3_5x>=0) then 1
        when (new.pla_i3_5x<0) then 9
         else null end; 

     new.pla_i3_6x_nsnr:=case 
        when (new.pla_i3_6x>=0) then 1
        when (new.pla_i3_6x<0) then 9
         else null end; 

     new.pla_i3_7x_nsnr:=case 
        when (new.pla_i3_7x>=0) then 1
        when (new.pla_i3_7x<0) then 9
         else null end; 

     new.pla_i3_81x_nsnr:=case 
        when (new.pla_i3_81x>=0) then 1
        when (new.pla_i3_81x<0) then 9
         else null end; 

     new.pla_i3_82x_nsnr:=case 
        when (new.pla_i3_82x>=0) then 1
        when (new.pla_i3_82x<0) then 9
         else null end; 

     new.pla_i7a_nsnr:=case 
        when (new.pla_i7a>0) then 1
        when (new.pla_i7a<0) then 9
         else null end; 

     new.pla_i7b_nsnr:=case 
        when (new.pla_i7b>0) then 1
        when (new.pla_i7b<0) then 9
         else null end; 

     new.pla_i7c_nsnr:=case 
        when (new.pla_i7c>0) then 1
        when (new.pla_i7c<0) then 9
         else null end; 

     new.pla_p5_2:=case 
        when (v_edad<14) then 0
        when (v_p5=1) then 1
        when (v_p5=2) then 2
        when (v_p5=3 or v_p5=6) then 3
        when (v_p5=4 or v_p5=7) then 4
        when (v_p5=5) then 5
        when (v_p5=8) then 6
        when (v_p5=-9) then 9
         else null end; 

     new.pla_parentes:=case 
        when (v_p4=1) then 1
        when (v_p4=2) then 2
        when (v_p4=3 or v_p4=4) then 3
        when (v_p4=5) then 4
        when (v_p4=6) then 5
        when (v_p4=7) then 6
        when (v_p4=8 or v_p4=9 or v_p4=10 or v_p4=11 or v_p4=12) then 7
        when (v_p4=14) then 8
        when (v_p4=13) then 9
         else null end; 

     new.pla_parentes2:=case 
        when (new.pla_parentes=1) then 1
        when (new.pla_parentes=2) then 2
        when (new.pla_parentes=3) then 3
        when (new.pla_parentes=4 or new.pla_parentes=5 or new.pla_parentes=6 or new.pla_parentes=7) then 4
        when (new.pla_parentes=9) then 5
        when (new.pla_parentes=8) then 6
         else null end; 

    return new;
    END;
    $$;


ALTER FUNCTION encu.calculo_variables_calculadas_i1__trg() OWNER TO tedede_php;

--
-- Name: calculo_variables_calculadas_s1__trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION calculo_variables_calculadas_s1__trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE
    v_nombre text;
    v_sexo integer;
    v_f_nac_d integer;
    v_f_nac_m integer;
    v_f_nac_a integer;
    v_edad integer;
    v_p4 integer;
    v_p5 integer;
    v_p5b integer;
    v_p6_b integer;
    v_p6_a integer;
    v_v2 integer;
    v_v2_esp text;
    v_v4 integer;
    v_v5 integer;
    v_v5_esp text;
    v_v6 integer;
    v_v7 integer;
    v_v12 integer;
    v_comuna integer;
    v_estado integer;
    v_dominio integer;
    v_h1 integer;
    v_h2 integer;
    v_h2_esp text;
    v_h3 integer;
    BEGIN
     SELECT pla_nombre,pla_sexo,pla_f_nac_d,pla_f_nac_m,pla_f_nac_a,pla_edad,pla_p4,pla_p5,pla_p5b,pla_p6_b,pla_p6_a
       INTO v_nombre,v_sexo,v_f_nac_d,v_f_nac_m,v_f_nac_a,v_edad,v_p4,v_p5,v_p5b,v_p6_b,v_p6_a
       FROM encu.plana_s1_p s
       WHERE  s.pla_enc = new.pla_enc and s.pla_hog = new.pla_hog and s.pla_mie = new.pla_mie and s.pla_exm = 0 ;
     SELECT pla_v2,pla_v2_esp,pla_v4,pla_v5,pla_v5_esp,pla_v6,pla_v7,pla_v12
       INTO v_v2,v_v2_esp,v_v4,v_v5,v_v5_esp,v_v6,v_v7,v_v12
       FROM encu.plana_a1_ a
       WHERE  a.pla_enc = new.pla_enc and a.pla_hog=1 and a.pla_mie = 0 and a.pla_exm = 0 ;
     SELECT pla_comuna,pla_estado,pla_dominio
       INTO v_comuna,v_estado,v_dominio
       FROM encu.plana_tem_ t
       WHERE  t.pla_enc = new.pla_enc and t.pla_hog = 0 and t.pla_mie = 0 and t.pla_exm = 0 ;
     SELECT pla_h1,pla_h2,pla_h2_esp,pla_h3
       INTO v_h1,v_h2,v_h2_esp,v_h3
       FROM encu.plana_a1_ a
       WHERE  a.pla_enc = new.pla_enc and a.pla_hog=new.pla_hog and a.pla_mie = 0 and a.pla_exm = 0 ;

     new.pla_zona_3:=case 
        when (v_comuna=2 or v_comuna=13 or v_comuna=14) then 1
        when (v_comuna=1 or v_comuna=3 or v_comuna=5 or v_comuna=6 or v_comuna=7 or v_comuna=11 or v_comuna=12 or v_comuna=15) then 2
        when (v_comuna=4 or v_comuna=8 or v_comuna=9 or v_comuna=10) then 3
         else null end; 

     new.pla_tot_mi:=case 
        when (true) then dbo.cant_i1_x_hog(new.pla_enc,new.pla_hog)
         else null end; 

     new.pla_tot_mr:=case 
        when (new.pla_tot_mi=1) then 1
        when (new.pla_tot_mi=2) then 2
        when (new.pla_tot_mi=3) then 3
        when (new.pla_tot_mi=4) then 4
        when (new.pla_tot_mi >= 5) then 5
         else null end; 

     new.pla_h2_re:=case 
        when (v_h2< 0) then -9
        when (v_h2= 1) then 1
        when (v_h2= 3) then 2
        when (v_h2= 2 or (v_h2 >= 4 and v_h2 <= 7)) then 3
         else null end; 

     new.pla_h2_re_bu:=case 
        when (v_h2=-1) then 0
        when (v_h2=1) then 1
        when (v_h2=3) then 2
        when (v_h2= 2 or (v_h2 >= 4 and v_h2 <= 7)) then 3
        when (v_h2=-9) then 9
         else null end; 

     new.pla_h2_2:=case 
        when (v_h2<0) then -9
        when (v_h2 = 1) then 1
        when (v_h2 = 2) then 2
        when (v_h2 = 3) then 3
        when (v_h2 = 4) then 4
        when (v_h2= 5) then 5
        when (v_h2= 6) then 6
        when (v_h2= 7) then 7
         else null end; 

     new.pla_h_perhab:=case 
        when (v_h3=-9) then -9
        when (v_h3=0) then 0
        when (v_h3>0 and new.pla_entrea is distinct from 4) then new.pla_tot_mi::numeric/v_h3
         else null end; 

     new.pla_h_hacina:=case 
        when (v_h3 = 0) then 0
        when (new.pla_h_perhab >0 and new.pla_h_perhab<1) then 1
        when (new.pla_h_perhab>=1 and new.pla_h_perhab<2) then 2
        when (new.pla_h_perhab>=2 and new.pla_h_perhab<=3) then 3
        when (new.pla_h_perhab>3) then 4
        when (v_h3 = -9) then 9
         else null end; 

     new.pla_hacinam_2:=case 
        when (new.pla_h_hacina=0) then 0
        when (new.pla_h_hacina=1 or new.pla_h_hacina=2) then 1
        when (new.pla_h_hacina=3) then 2
        when (new.pla_h_hacina=4) then 3
        when (new.pla_h_hacina=9) then 9
         else null end; 

     new.pla_hacinam:=case 
        when (new.pla_hacinam_2=0) then 0
        when (new.pla_hacinam_2=1) then 1
        when (new.pla_hacinam_2=2 or new.pla_hacinam_2=3) then 2
        when (new.pla_hacinam_2=9) then 9
         else null end; 

     new.pla_v2_re:=case 
        when (v_v2=0) then 0
        when (v_v2=1) then 1
        when (v_v2=2) then 2
        when (v_v2=9 or v_v2=10 or v_v2=5 or v_v2=6 or v_v2=8) then 3
         else null end; 

     new.pla_v2_2:=case 
        when (v_v2=1) then 1
        when (v_v2=2) then 2
        when (v_v2=5) then 5
        when (v_v2=6) then 6
        when (v_v2=8) then 8
        when (v_v2=9) then 9
        when (v_v2=10) then 10
         else null end; 

     new.pla_sexoj:=case 
        when (true) then dbo.sexojefe(new.pla_enc,new.pla_hog)
         else null end; 

    return new;
    END;
    $$;


ALTER FUNCTION encu.calculo_variables_calculadas_s1__trg() OWNER TO tedede_php;

--
-- Name: claves_campos_aux_trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION claves_campos_aux_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

    new.cla_aux_es_enc:=null;
    new.cla_aux_es_hog:=null;
    new.cla_aux_es_mie:=null;
    new.cla_aux_es_exm:=null;
  if new.cla_hog=0 then
    new.cla_aux_es_enc:=true;
    if new.cla_mie=0 then
      null;
    else
      raise 'si la clave es de hogar no puede tener especificado el miembro (en encuesta %)',new.cla_enc;
    end if;
    if new.cla_exm=0 then
      null;
    else
      raise 'si la clave es de hogar no puede tener especificado el emigrante (en encuesta %)',new.cla_enc;
    end if;
  elsif new.cla_mie=0 then
    new.cla_aux_es_hog:=true;
    if new.cla_exm=0 then
      new.cla_aux_es_hog:=true;
    else
      new.cla_aux_es_hog:=null;
      new.cla_aux_es_exm:=null;
    end if;
  else
    if new.cla_exm=0 then
      null;
    else
      raise 'si la clave es de hogar no puede tener especificado el emigrante y el miembro (en encuesta %)',new.cla_enc;
    end if;
    new.cla_aux_es_mie:=true;
  end if;
  RETURN new;
END
$$;


ALTER FUNCTION encu.claves_campos_aux_trg() OWNER TO tedede_php;

--
-- Name: claves_ins_trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION claves_ins_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
  v_sentencia text;
BEGIN
  -- GENERADO POR: generacion_trigger_respuestas.php
  INSERT INTO encu.respuestas (res_ope,res_for,res_mat,res_enc,res_hog,res_mie,res_exm, res_var, res_tlg)
    SELECT new.cla_ope,new.cla_for,new.cla_mat,new.cla_enc,new.cla_hog,new.cla_mie,new.cla_exm, var_var, new.cla_tlg
      FROM encu.variables 
      WHERE var_ope=new.cla_ope AND var_mat=new.cla_mat AND var_for=new.cla_for;
if new.cla_ope = 'etoi152' then
  IF new.cla_for='TEM' and new.cla_mat='' THEN
    v_sentencia:='INSERT INTO encu.plana_tem_ (pla_enc,pla_hog,pla_mie,pla_exm,    pla_id_marco,pla_comuna,pla_replica,pla_up,pla_lote,pla_clado,pla_ccodigo,pla_cnombre,pla_hn,pla_hp,pla_hd,pla_hab,pla_h4,pla_usp,pla_barrio,pla_ident_edif,pla_obs,pla_frac_comun,pla_radio_comu,pla_mza_comuna,pla_dominio,pla_marco,pla_titular,pla_zona,pla_lote2011,pla_para_asignar,pla_participacion,pla_codpos,pla_etiquetas,pla_tipounidad,pla_tot_hab,pla_estrato,pla_fexp,pla_areaup,pla_trimestre,pla_semana,pla_rotaci_n_etoi,pla_rotaci_n_eah,pla_idtipounidad,pla_h1_mues,pla_idcuerpo,pla_cuerpo,pla_cuit,pla_rama_act,pla_nomb_inst,pla_pzas,pla_te,pla_idprocedencia,pla_procedencia,pla_yearfuente,pla_anio_list,pla_marco_anio,pla_nro_orden,pla_operacion,pla_area,pla_reserva,pla_up_comuna,pla_h4_mues,pla_ups,pla_sel_etoi14_villa,pla_obs_campo,pla_tlg) (SELECT $3, $4, $5, $6,  tem_id_marco,tem_comuna,tem_replica,tem_up,tem_lote,tem_clado,tem_ccodigo,tem_cnombre,tem_hn,tem_hp,tem_hd,tem_hab,tem_h4,tem_usp,tem_barrio,tem_ident_edif,tem_obs,tem_frac_comun,tem_radio_comu,tem_mza_comuna,tem_dominio,tem_marco,tem_titular,tem_zona,tem_lote2011,tem_para_asignar,tem_participacion,tem_codpos,tem_etiquetas,tem_tipounidad,tem_tot_hab,tem_estrato,tem_fexp,tem_areaup,tem_trimestre,tem_semana,tem_rotaci_n_etoi,tem_rotaci_n_eah,tem_idtipounidad,tem_h1_mues,tem_idcuerpo,tem_cuerpo,tem_cuit,tem_rama_act,tem_nomb_inst,tem_pzas,tem_te,tem_idprocedencia,tem_procedencia,tem_yearfuente,tem_anio_list,tem_marco_anio,tem_nro_orden,tem_operacion,tem_area,tem_reserva,tem_up_comuna,tem_h4_mues,tem_ups,tem_sel_etoi14_villa,tem_obs_campo,$2 FROM encu.tem  WHERE tem_enc=$1)';
    EXECUTE v_sentencia USING new.cla_enc, new.cla_tlg , new.cla_enc, new.cla_hog, new.cla_mie, new.cla_exm;
  ELSE
    v_sentencia:='INSERT INTO encu.plana_'||new.cla_for||'_'||new.cla_mat||' (pla_tlg, pla_enc, pla_hog, pla_mie, pla_exm) values ($1 , $2, $3, $4, $5)';
    EXECUTE v_sentencia USING new.cla_tlg , new.cla_enc, new.cla_hog, new.cla_mie, new.cla_exm;
  END IF;
end if;
  RETURN new;
END
$_$;


ALTER FUNCTION encu.claves_ins_trg() OWNER TO tedede_php;

--
-- Name: consistencias_upd_trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION consistencias_upd_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_en_campo boolean;
BEGIN  
  SELECT ope_en_campo INTO v_en_campo FROM operativos WHERE ope_ope=new.con_ope;
  if v_en_campo
       and ( new.con_momento='Relevamiento 1' or new.con_momento='Relevamiento 2') and new.con_activa is true 
       and ( new.con_con           is distinct from old.con_con
          or new.con_precondicion  is distinct from old.con_precondicion 
          or new.con_rel           is distinct from old.con_rel          
          or new.con_postcondicion is distinct from old.con_postcondicion
          or new.con_activa        is distinct from old.con_activa       
          or new.con_tipo          is distinct from old.con_tipo         
          or new.con_momento       is distinct from old.con_momento  
       )      
  then
    raise exception 'No se pueden modificar las consistencias de Relevamiento mientras la encuesta esta en campo. Solo pueden darse de baja o cambiarlas a momentos posteriores';
  end if;
  if new.con_precondicion is distinct from old.con_precondicion 
    or new.con_postcondicion is distinct from old.con_postcondicion
    or new.con_rel is distinct from old.con_rel
  then
    -- estos campos se anulan ante cualquier cambio, solo pueden ser restaurados por el sistema cambiando en forma simultánea la revision
    -- new.con_junta=null;
    new.con_expresion_sql:=null;
    new.con_clausula_from:=null;
    new.con_error_compilacion:='Modificada desde la compilacion anterior';
    new.con_valida:=false;
  end if;
  if comun.buscar_reemplazar_espacios_raros(new.con_precondicion) is distinct from new.con_precondicion then
    new.con_precondicion=comun.buscar_reemplazar_espacios_raros(new.con_precondicion);
  end if;
  if comun.buscar_reemplazar_espacios_raros(new.con_postcondicion) is distinct from new.con_postcondicion then
    new.con_postcondicion=comun.buscar_reemplazar_espacios_raros(new.con_postcondicion);
  end if;
  return new;
END
$$;


ALTER FUNCTION encu.consistencias_upd_trg() OWNER TO tedede_php;

--
-- Name: controlar_modificacion_semana_trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION controlar_modificacion_semana_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
    if new.pla_semana is distinct from old.pla_semana then 
        if new.pla_dominio is distinct from 4 and new.pla_estado is distinct from 18 and new.pla_sel_etoi14_villa is distinct from 0 then
            raise exception 'No se pueden modificar la semana para encuestas con estado distinto a 18 y dominio distinto a 4';    
        else
            update encu.plana_tem_
                set pla_replica=new.pla_semana
                where pla_enc=new.pla_enc;                
        end if;        
    end if;   
    return new;
    END
  $$;


ALTER FUNCTION encu.controlar_modificacion_semana_trg() OWNER TO tedede_php;

--
-- Name: destino_variable(text, text); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION destino_variable(p_var text, p_baspro text) RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
   v_destino text;
   v_cuantos integer;
   v_for text;
   v_mat text;
BEGIN
    select distinct(varcal_destino), count(*) 
      into v_destino, v_cuantos 
      from encu.varcal 
      where varcal_varcal = p_var and varcal_ope = dbo.ope_actual() 
      group by varcal_destino;
    if v_cuantos > 0 then
      return v_destino;
    end if;
    select var_for, var_mat into v_for, v_mat 
      from encu.variables 
      where var_var = p_var and var_ope = dbo.ope_actual();
    if v_for='I1' or v_for='S1' and v_mat='P' then
      v_destino = 'mie';
    elsif v_for='A1' or v_for = 'S1' then
      v_destino = 'hog';
    elsif v_for='A1' and v_mat = 'X' then
      v_destino = 'exm';
    end if;
    RETURN v_destino;
END;
$$;


ALTER FUNCTION encu.destino_variable(p_var text, p_baspro text) OWNER TO tedede_php;

--
-- Name: disparar_calculo_estado_tem_trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION disparar_calculo_estado_tem_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
    if new.pla_reserva is distinct from old.pla_reserva then
        update encu.respuestas 
		set res_valor=res_valor
		where res_ope=dbo.ope_actual()
		and res_for='TEM'
		and res_mat=''
		and res_enc=new.pla_enc
		and res_hog=0
		and res_mie=0 
		and res_exm=0
		and res_var='asignable';
    end if;
    return new;
    END
  $$;


ALTER FUNCTION encu.disparar_calculo_estado_tem_trg() OWNER TO tedede_php;

--
-- Name: evaluar_varcal_opciones_excluyentes(text, text, boolean, text); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION evaluar_varcal_opciones_excluyentes(p_cual text, p_destino text, p_opciones_excluyente boolean, p_filtro text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
  DECLARE
    v_sent_opc          TEXT;
    v_sent_opc_todas    TEXT;
    var_viv_str         TEXT;
    var_hog_str         TEXT;
    var_per_str         TEXT;
    var_tem_str         TEXT;
    for_hog             TEXT;
    v_tabla_viv         TEXT;
    v_sent              TEXT;
    v_sent_cant         TEXT;
    v_sent_excl         TEXT;
    c_opciones          RECORD;
    v_control_condicion TEXT;
    v_tiene_resto       boolean=false;
    v_alias_destino     character varying(10);
    v_alias_hogar       character varying(10);
    v_join_personas     TEXT;
    v_join_hogar        TEXT;
    v_limit             TEXT;
    v_lista_select      TEXT;
    v_casos     text;
    v_enc1       text;
    v_hog1       text;
    v_mie1       text;
    v_enc2       text;
    v_hog2       text;
    v_mie2       text;
    v_lista_clave       text;
    v_filtro            text;
    v_filtro_varcal     text;
    v_opcs1             text;
    v_opcs2             text;
    v_mensaje           TEXT;
    v_mostrar_no_clasificado TEXT;

  BEGIN
    v_filtro='t.pla_estado between 79 and 89'; -- SIEMPRE filtro de estado
    v_filtro_varcal=' true';
    select string_agg(case when p.pre_blo='Viv' then var_var else null end ,'|' order by pre_ope, pre_for, pre_orden, var_orden),
            string_agg(case when p.pre_blo in ('Hog','HEH') then var_var else null end,'|'  order by pre_ope, pre_for, pre_orden, var_orden),
            string_agg(case when p.pre_mat='P' then var_var else null end,'|'  order by pre_ope, pre_for, pre_orden, var_orden),
            (select distinct pre_for from encu.preguntas where pre_blo in ('Hog','HEH'))
        into var_viv_str, var_hog_str, var_per_str, for_hog
        from encu.variables v 
            join encu.preguntas p on v.var_ope=p.pre_ope and v.var_for=p.pre_for and
                v.var_pre=p.pre_pre and (p.pre_blo in ('Viv', 'Hog','HEH') or p.pre_mat='P');
    var_tem_str='dominio|estrato|comuna';
    v_sent_opc_todas='';
    v_tiene_resto=false;
    v_join_personas='';
    v_alias_destino='h';
    v_lista_clave='h.pla_enc, h.pla_hog, h.pla_mie';
    if for_hog='A1' then
       v_join_hogar=' join encu.plana_a1_ a on h.pla_enc=a.pla_enc and h.pla_hog=a.pla_hog '||chr(13);
       v_alias_hogar='a';
       v_tabla_viv = 'encu.plana_a1_';
    else
       v_join_hogar='';
       v_alias_hogar='h';       
       v_tabla_viv = 'encu.plana_s1_';
    end if;
    if p_destino='mie' then
        v_join_personas=' join encu.plana_s1_p p on h.pla_enc=p.pla_enc and h.pla_hog=p.pla_hog '||chr(13)||
                  repeat(' ',16)||' join encu.plana_i1_ i on i.pla_enc=p.pla_enc and i.pla_hog=p.pla_hog and i.pla_mie=p.pla_mie'; 
        v_alias_destino='i';  
        v_lista_clave=replace(v_lista_clave, 'h.', 'i.');        
    end if;

    FOR c_opciones IN
        select varcalopc_opcion as i_opcion,
               varcalopc_expresion_condicion as i_expresion_condicion,
               varcalopc_expresion_valor as i_expresion_valor,
               varcalopc_etiqueta as i_etiqueta
          from encu.varcalopc
          where varcalopc_ope = dbo.ope_actual() and varcalopc_varcal = p_cual
        order by varcalopc_ope, varcalopc_varcal, varcalopc_opcion  
    LOOP
        if coalesce(c_opciones.i_expresion_condicion,'')='' then
            RETURN '1|otro: expresion_condicion sin dato en la opcion '||c_opciones.i_opcion;
        end if;
        v_sent_opc=encu.reemplazar_agregadores(c_opciones.i_expresion_condicion);
        v_sent_opc=comun.reemplazar_variables(v_sent_opc, v_alias_destino||'.pla_\1');
        v_sent_opc=regexp_replace(v_sent_opc, '\m'||v_alias_destino||'.pla_('||var_viv_str||')\M'::text, 'v.pla_\1'::text,'ig');
        v_sent_opc=regexp_replace(v_sent_opc, '\m'||v_alias_destino||'.pla_('||var_tem_str||')\M'::text, 't.pla_\1'::text,'ig');
        v_sent_opc=regexp_replace(v_sent_opc, '\m'||v_alias_destino||'.pla_('||var_hog_str||')\M'::text, v_alias_hogar||'.pla_\1'::text,'ig');
        if p_destino='mie' then
            v_sent_opc=regexp_replace(v_sent_opc, '\m'||v_alias_destino||'.pla_('||var_per_str||')\M'::text, 'p.pla_\1'::text,'ig');
        end if;
        if c_opciones.i_etiqueta is distinct from 'Resto' then
            v_sent_opc_todas= v_sent_opc_todas||chr(13)||repeat(' ',8)||'case when ('|| v_sent_opc||') then '''||c_opciones.i_opcion||'*'||''' else '''' end ||';
        else
            v_tiene_resto=true;        
        end if;
    END LOOP;
    if coalesce(replace(p_filtro,' ',''),'')<> '' then
        v_filtro_varcal=regexp_replace(p_filtro, '\m'||v_alias_destino||'.pla_('||var_viv_str||')\M'::text, 'v.pla_\1'::text,'ig');
        v_filtro_varcal=regexp_replace(v_filtro_varcal, '\m'||v_alias_destino||'.pla_('||var_tem_str||')\M'::text, 't.pla_\1'::text,'ig');
        v_filtro_varcal=regexp_replace(v_filtro_varcal, '\m'||v_alias_destino||'.pla_('||var_hog_str||')\M'::text, v_alias_hogar||'.pla_\1'::text,'ig');
        if p_destino='mie' then
            v_filtro_varcal=regexp_replace(v_filtro_varcal, '\m'||v_alias_destino||'.pla_('||var_per_str||')\M'::text, 'p.pla_\1'::text,'ig');
        end if;
    end if;
    v_mostrar_no_clasificado= true;   
    if p_opciones_excluyente is true then
        if v_tiene_resto THEN
          v_control_condicion='cant<=1';
        else
          v_control_condicion='cant=1';
        end if;
    else
       if v_tiene_resto THEN
          v_control_condicion='cant>=0';  -- no haría falta controlar
          v_mostrar_no_clasificado= false; 
       else
          v_control_condicion='cant>=1';
       end if;
    end if;
    v_lista_select='count(*)';
    v_limit='';
    v_sent =$$
        select #lista_select
        from
            (select #lista_clave, #expresion opcs, 
                    case when length(#expresion)>0 then array_length(string_to_array(substr(#expresion,1,length(#expresion)-1), '*'),1) 
                         else 0 end cant
                from encu.plana_s1_ h join #tabla_viv v on h.pla_enc=v.pla_enc and v.pla_hog=1
                                  join encu.plana_tem_ t on t.pla_enc=h.pla_enc
                                  #join_personas
                                  #join_hogar
                #filtro
            )as x
        where not #control
        #limit
$$;
    raise notice 'varcal %, v_sent_todas:%',p_cual,v_sent_opc_todas;
    if coalesce(v_sent_opc_todas,'')='' then
        RETURN '1|otro: Variable sin opciones' ;
    end if;    
    v_sent=replace(v_sent,'#expresion',substr(v_sent_opc_todas,1,length(v_sent_opc_todas)-2)); 
    --v_sent=replace(v_sent,'#control',v_control_condicion); 
    v_sent=replace(v_sent,'#join_personas',v_join_personas);
    v_sent=replace(v_sent,'#lista_clave',v_lista_clave);
    v_sent=replace(v_sent,'#filtro','where '||v_filtro ||' and '||v_filtro_varcal);
    v_sent=replace(v_sent,'#join_hogar',v_join_hogar);
    v_sent=replace(v_sent,'#tabla_viv',v_tabla_viv);
    v_sent_cant=replace(replace(replace(v_sent,'#lista_select',v_lista_select),'#limit', v_limit),'#control',v_control_condicion);    
    raise notice 'varcal %, v_sent_todas:%',p_cual,v_sent_opc_todas;    
    raise notice 'varcal %, v_sent_cant:%',p_cual,v_sent_cant;
    EXECUTE v_sent_cant INTO v_casos;
    if v_casos::integer>0 then
        v_mensaje= v_casos;
        if p_opciones_excluyente is true then
            v_sent_excl =replace(replace(replace(v_sent,'#lista_select','pla_enc,pla_hog,pla_mie,opcs' ),'#limit', 'limit 1'),'#control',v_control_condicion|| ' and cant>1'); 
            raise notice 'v_sent_excl:%',v_sent_excl;     
            EXECUTE v_sent_excl INTO v_enc1, v_hog1, v_mie1, v_opcs1;
            if v_enc1 is not null then
                v_mensaje=v_mensaje||'|NoEx: e '||v_enc1||' h '||v_hog1||' m '||v_mie1||' opciones:'||v_opcs1 ; 
            end if;    
        end if;
        if v_mostrar_no_clasificado then
            v_sent =replace(replace(replace(v_sent,'#lista_select','pla_enc,pla_hog,pla_mie,opcs' ),'#limit', 'limit 1'),'#control',v_control_condicion|| ' and cant=0'); 
            raise notice 'v_sent:%',v_sent;     
            EXECUTE v_sent INTO v_enc2, v_hog2, v_mie2, v_opcs2;
            if v_enc2 is not null then
                v_mensaje=v_mensaje||'|NoCl: e '||v_enc2||' h '||v_hog2||' m '||v_mie2 ; 
            end if;
        end if;
    else
        v_mensaje='OK';
    end if; 
    RETURN v_mensaje;
  END;
$_$;


ALTER FUNCTION encu.evaluar_varcal_opciones_excluyentes(p_cual text, p_destino text, p_opciones_excluyente boolean, p_filtro text) OWNER TO tedede_php;

--
-- Name: fin_de_campo_automatico(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION fin_de_campo_automatico() RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO encu.sesiones(ses_usu, ses_activa,ses_borro_localStorage, ses_phpsessid, ses_httpua, ses_remote_addr) 
  values ('instalador', true, false, 'internal', (select httpua_httpua from encu.http_user_agent where httpua_texto='PostgreSQL internal'),'127.0.0.1');

INSERT INTO encu.tiempo_logico(tlg_ses) select max(ses_ses) from encu.sesiones where ses_usu='instalador';

update encu.respuestas r
     set res_valor='1',
         res_tlg=(
                select max(tlg_tlg) 
                  from encu.tiempo_logico  
                  where tlg_ses=(
                          select max(ses_ses) 
                            from encu.sesiones 
                            where ses_usu='instalador'
                   )
                )
     from (
          select t_69.*, f_ult_mod_est,  extract(days from (now() - f_ult_mod_est)) dias,
               case when (extract(days from (now() - f_ult_mod_est))> t_69.dom_dias_para_fin) then 'FinCampo' else 'NoFinaliza' end as accion
          from
              (
                select  pla_enc, pla_dominio, pla_rea, d.dom_dias_para_fin_norea,d.dom_dias_para_fin_campo,
                        case when pla_rea in (0,2) then d.dom_dias_para_fin_norea else d.dom_dias_para_fin_campo end as dom_dias_para_fin           
                    from encu.plana_tem_ left join encu.dominio d on pla_dominio= d.dom_dom
                    where pla_estado=69
               ) as t_69,
               (select res_enc  as enc, tlg_momento f_ult_mod_est
                    from encu.respuestas r join encu.tiempo_logico t on r.res_tlg=t.tlg_tlg 
                    where res_ope=dbo.ope_actual() and res_for ='TEM' and res_var='estado'
                ) as r_t
          where t_69.pla_enc= r_t.enc
          and extract(days from (now() - f_ult_mod_est))>= t_69.dom_dias_para_fin 
          ) as x 
     where x.pla_enc= r.res_enc AND r.res_ope=dbo.ope_actual() 
        and r.res_for='TEM'
        and r.res_var='fin_de_campo';
$$;


ALTER FUNCTION encu.fin_de_campo_automatico() OWNER TO tedede_php;

--
-- Name: formato_variable(text, text); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION formato_variable(p_var text, p_baspro text) RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
   v_maximo_largo integer;
   v_sentencia text;
   v_tabla text;
   v_columna text;
   v_tipo text;
   v_letra text;
   v_cantdec integer;
   v_formato text;
BEGIN
    select encu.tabla_variable(p_var) into v_tabla;
    v_columna:='pla_'||p_var;
    v_sentencia:= 'select length(comun.maxlen(pla_'||p_var||')::text) from encu.'||v_tabla||' ;'; 
    --raise notice 'sentencia %', v_sentencia;
    select data_type into v_tipo from information_schema.columns where table_schema = 'encu' and table_name = v_tabla and column_name = v_columna;
    case v_tipo
         when 'text' then 
              v_letra:='A';
              v_sentencia:= 'select length(comun.maxlen(pla_'||p_var||')::text)+10 from encu.'||v_tabla; 
         when 'character varying' then
              v_letra:='A';
              v_sentencia:= 'select length(comun.maxlen(pla_'||p_var||')::text)+10 from encu.'||v_tabla; 
         when 'timestamp without time zone' then 
              v_letra:='A';
         when 'bigint' then 
              v_letra:='F';
         when 'integer' then
              v_letra:='F';
         when 'numeric' then
              v_letra:='F';
         else v_letra:='A';
    end case;
    EXECUTE v_sentencia INTO v_maximo_largo;   
    v_formato:=v_letra||coalesce(v_maximo_largo,'1')::text;
    if v_letra ='F' then
       v_formato:=v_formato||'.';
       select basprovar_cantdecimales into v_cantdec from encu.baspro_var where basprovar_ope = dbo.ope_actual() and basprovar_baspro = p_baspro and basprovar_var = p_var;
       if v_cantdec > 0 then 
          v_formato:=v_formato||v_cantdec::text;
       else
          v_formato:=v_formato||'0';
       end if;
    end if;
    RETURN v_formato;
END;
$$;


ALTER FUNCTION encu.formato_variable(p_var text, p_baspro text) OWNER TO tedede_php;

--
-- Name: generar_consistencias_audi_nsnc(text); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION generar_consistencias_audi_nsnc(poperativo text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    xcon_activa             encu.consistencias.con_activa%type;
    xcon_tipo               encu.consistencias.con_tipo%type;
    xcon_falsos_positivos   encu.consistencias.con_falsos_positivos%type;  
    xcon_importancia        encu.consistencias.con_importancia%type;
    xcon_momento            encu.consistencias.con_momento%type;
    xcon_grupo              encu.consistencias.con_grupo%type;
    xcon_gravedad           encu.consistencias.con_gravedad%type;
    xcon_rel                encu.consistencias.con_rel%type;
BEGIN  
    -- Borrar las automaticas
    DELETE FROM encu.inconsistencias
        WHERE inc_con like 'audi_nsnc%';
    DELETE FROM encu.ano_con
        WHERE anocon_con like 'audi_nsnc%';
    DELETE FROM encu.con_var
        WHERE convar_con like 'audi_nsnc%';
    DELETE FROM encu.consistencias
           WHERE con_con like 'audi_nsnc%';
    xcon_activa=true;   
    xcon_tipo='Auditoría';   
    xcon_falsos_positivos=false;
    xcon_importancia='ALTA';
    xcon_momento='Recepción';
    xcon_grupo='nsnc'; 
    xcon_gravedad='Error';    
    xcon_rel='=>';
    
    INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
                con_postcondicion,
                con_activa, con_explicacion, con_tipo, con_falsos_positivos,
                con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
        SELECT  var_ope, 'audi_nsnc_'||var_var, 'informado('||var_var||')' as precondicion, xcon_rel,
                case when var_tipovar in ('anios','numeros','marcar_nulidad','edad','anio'
                                        ,'horas','meses','si_no','opciones','monetaria', 'si_no_nosabe3' ) then
                         var_var ||'<> -1 and '||var_var ||'<> -9 and '||var_var ||'<> -5' 
                     else  --'observaciones','telefono','texto_especificar','fecha_corta','texto','fecha','texto_libre'
                         'not es_cadena_vacia('||var_var ||') and '||
                         'not nsnc('||var_var ||') and '||
                         'not ignorado('||var_var ||') and '||
                         var_var ||'<> a_texto(-1) and '||var_var ||'<> a_texto(-9) and '||var_var ||'<> a_texto(-5)' 
                end as postcondicion,
                xcon_activa, 'Variable ' ||var_var ||' tiene NS/NC' as con_explicacion, xcon_tipo, xcon_falsos_positivos,
                xcon_importancia, xcon_momento, xcon_grupo, xcon_gravedad, 1
            FROM encu.variables_ordenadas
            WHERE var_ope=poperativo
            ORDER BY orden; 
END;
$$;


ALTER FUNCTION encu.generar_consistencias_audi_nsnc(poperativo text) OWNER TO tedede_php;

--
-- Name: generar_consistencias_audi_rango(text); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION generar_consistencias_audi_rango(poperativo text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    xcon_activa             encu.consistencias.con_activa%type;
    xcon_tipo               encu.consistencias.con_tipo%type;
    xcon_falsos_positivos   encu.consistencias.con_falsos_positivos%type;  
    xcon_importancia        encu.consistencias.con_importancia%type;
    xcon_momento            encu.consistencias.con_momento%type;
    xcon_grupo              encu.consistencias.con_grupo%type;
    xcon_rel                encu.consistencias.con_rel%type;
BEGIN  
    -- Borrar las automaticas
    DELETE FROM encu.inconsistencias
        WHERE inc_con like 'audi_rango%';
    DELETE FROM encu.ano_con
        WHERE anocon_con like 'audi_rango%';
    DELETE FROM encu.con_var
        WHERE convar_con like 'audi_rango%';
    DELETE FROM encu.consistencias
           WHERE con_con like 'audi_rango%';
    xcon_activa=true;   
    xcon_tipo='Auditoría';   
    xcon_falsos_positivos=false;
    xcon_importancia='ALTA';
    xcon_momento='Recepción';
    xcon_grupo='rango';  
    xcon_rel='=>';
    --advertencias
    INSERT INTO encu.consistencias( con_ope,con_con,
                con_precondicion,con_rel,
                con_postcondicion,con_activa,
                con_explicacion,
                con_tipo, con_falsos_positivos,
                con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
        SELECT  var_ope, 'audi_rango_adv_'||var_var,
                'informado('||var_var||') and not nsnc('||var_var||') and not ignorado('||var_var||')' as precondicion , xcon_rel,
                   coalesce (var_var||'>='||var_advertencia_inf,'') ||
                   case when var_advertencia_inf is not null and var_advertencia_sup is not null then ' and ' else '' end
                   ||coalesce (var_var||'<='||var_advertencia_sup,'')
                   as postcondicion, xcon_activa,
                'Fuera de rango ' ||var_var ||coalesce(' min:'||var_advertencia_inf,'')||coalesce(' max:'||var_advertencia_sup,'') as con_explicacion,
                xcon_tipo, xcon_falsos_positivos,
                xcon_importancia, xcon_momento, xcon_grupo, 'Advertencia', 1
            FROM encu.variables
            WHERE var_ope=poperativo
                    and var_for <>'TEM'
                    and var_conopc is null
                    and var_tipovar in ('anios','numeros','edad','anio','horas','meses','monetaria' )
                    and (var_advertencia_inf is not null or var_advertencia_sup is not null)            
            ORDER BY var_var; 
    --error        
    INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
                con_postcondicion, con_activa,
                con_explicacion,
                con_tipo, con_falsos_positivos,
                con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
        SELECT  var_ope, 'audi_rango_err_'||var_var, 'informado('||var_var||') and not nsnc('||var_var||') and not ignorado('||var_var||')' as precondicion , xcon_rel,
                   coalesce (var_var||'>='||var_minimo,'') ||
                   case when var_minimo is not null and var_maximo is not null then ' and ' else '' end
                   ||coalesce (var_var||'<='||var_maximo,'')
                   as postcondicion, xcon_activa,
                'Fuera de rango ' ||var_var||coalesce(' min:'||var_minimo,'')||coalesce(' max:'||var_maximo,'') as con_explicacion,
                xcon_tipo, xcon_falsos_positivos,
                xcon_importancia, xcon_momento, xcon_grupo, 'Error', 1
            FROM encu.variables
            WHERE var_ope=poperativo
                    and var_for <>'TEM'
                    and var_conopc is null
                    and var_tipovar in ('anios','numeros','edad','anio','horas','meses','monetaria' )
                    and (var_minimo is not null or var_maximo is not null)            
            ORDER BY var_var;             
END;
$$;


ALTER FUNCTION encu.generar_consistencias_audi_rango(poperativo text) OWNER TO tedede_php;

--
-- Name: generar_consistencias_completitud(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION generar_consistencias_completitud() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    xoperativo             encu.consistencias.con_ope%type;
    xcon_activa            encu.consistencias.con_activa%type;
    xcon_tipo              encu.consistencias.con_tipo%type;
    xcon_falsos_positivos  encu.consistencias.con_falsos_positivos%type;  
    xcon_importancia       encu.consistencias.con_importancia%type;
    xcon_momento           encu.consistencias.con_momento%type;
    xcon_grupo             encu.consistencias.con_grupo%type;
    xcon_gravedad          encu.consistencias.con_gravedad%type;
    xcon_rel               encu.consistencias.con_rel%type;
BEGIN 
    xoperativo=dbo.ope_actual();
    -- Borrar las automaticas
    DELETE FROM encu.inconsistencias
        WHERE inc_ope= xoperativo    and inc_con like 'compl%';
    DELETE FROM encu.ano_con
        WHERE anocon_ope= xoperativo and anocon_con like 'compl%';
    DELETE FROM encu.con_var
        WHERE convar_ope= xoperativo and convar_con like 'compl%';
    DELETE FROM encu.consistencias
        WHERE con_ope= xoperativo    and con_con like 'compl%';
    xcon_activa=true;   
    xcon_tipo='Completitud';    
    xcon_falsos_positivos=false;
    xcon_importancia='ALTA';
    xcon_momento='Recepción';
    xcon_grupo=null; 
    xcon_gravedad='Error';    
    xcon_rel='=>';
    --xcon_modulo='RELACIONES';

    INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
                con_postcondicion,
                con_activa, con_explicacion, con_tipo, con_falsos_positivos,
                con_importancia, con_momento, con_grupo, con_gravedad, con_origen, con_tlg) VALUES
        (xoperativo, 'compl_S1','', xcon_rel,
            'entrea=2 and(razon1=1 and informado(razon2_1) or'
                ||' razon1=2 and informado(razon2_2) or' 
                ||' razon1=3 and informado(razon2_3) or' 
                ||' razon1=4 and informado(razon2_4) or' 
                ||' razon1=5 and informado(razon2_5) or' 
                ||' razon1=6 and informado(razon2_6) and (razon2_6<>4 or informado(razon3)) or'
                ||' razon1=7 and informado(razon2_7) or' 
                ||' razon1=8 and informado(razon2_8) or' 
                ||' razon1=9 and informado(razon2_9) ' 
                ||') or entrea=1 and total_h>0 and total_m>0 or entrea>2',
            xcon_activa,'Formulario S1 incompleto',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad,xoperativo, 1),
        (xoperativo, 'compl_S1_P','', xcon_rel,
            'informado(p4) and informado(edad) and edad>=0 and'
            ||' (edad<14 or informado(p5)) and'
            ||' (edad<14 or not(p5=1 or p5=2) or informado(p5b)) and'
            ||' (edad>24 or (informado(p6_a) and informado(p6_b)))',
            xcon_activa,'Formulario S1 renglón incompleto',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad,xoperativo, 1),
        (xoperativo, 'compl_A1','', xcon_rel,
            'informado(pygf3) and (not(pygf3=1) or informado(pygf5j))',
            xcon_activa,'Formulario A1 incompleto',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad,xoperativo, 1),
        (xoperativo, 'compl_A1_X','', xcon_rel,
            'informado(lugar_esp1) or informado(lugar_esp2) or informado(lugar_esp3)',
            xcon_activa,'Formulario A1 renglon X incompleto',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad,xoperativo, 1),
        (xoperativo, 'compl_PG1','pygf1a=1 or pygf1b=1', xcon_rel,
            'informado(ga1)',
            xcon_activa,'Formulario PG1 incompleto',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad,xoperativo, 1),
        (xoperativo, 'compl_PG1_M','', xcon_rel,
            'informado(pyg17)',
            xcon_activa,'Formulario PG1 renglon M incompleto',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad,xoperativo, 1),
        (xoperativo, 'compl_I1','', xcon_rel,
            'informado(sn16) and '
            ||' (edad<14 or sexo=1 or informado(s28))'
            ||' and (edad<14 or sexo=1 or s28=2 or informado(s31_anio))' ,
            xcon_activa,'Formulario I1 incompleto',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento, xcon_grupo,xcon_gravedad,xoperativo, 1),
       (xoperativo, 'compl_S1_faltante','entrea<>2', xcon_rel,
            'total_h = dbo.total_hogares(encues) and dbo.total_hogares(encues)>0',
            xcon_activa,'Formulario S1 faltante ',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad,xoperativo, 1),
       (xoperativo, 'compl_S1_P_faltante','entrea<>2', xcon_rel,
            'total_m = dbo.cant_s1p_x_hog(enc, hog) and dbo.cant_s1p_x_hog(enc, hog)>0',
            xcon_activa,'Formulario S1 renglon faltante ',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad,xoperativo, 1),
       (xoperativo, 'compl_A1_faltante','entrea<>2', xcon_rel,
            'total_h >= dbo.cant_a1(enc) and dbo.existe_a1(enc,hog)=1',
            xcon_activa,'Formulario A1 faltante ',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad,xoperativo, 1),
       (xoperativo, 'compl_I1_faltante','entrea<>2', xcon_rel,
            'total_m=dbo.cant_i1_x_hog(enc, hog) and dbo.cant_i1_x_hog(enc, hog)>0',
            xcon_activa,'Formulario I1 faltante ',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad,xoperativo, 1),
       (xoperativo, 'compl_A1_X_faltante','entrea<>2 and x5=1', xcon_rel,
            'x5_tot=dbo.cant_registros_exm(enc, hog) and dbo.cant_registros_exm(enc, hog)>0',
            xcon_activa,'Formulario A1 X renglon faltante ',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad,xoperativo, 1),
       (xoperativo, 'compl_PG1_M_faltante','entrea<>2', xcon_rel,
            'positivo(pe1)+positivo(ga1)=dbo.cant_pg1m_x_hog(enc, hog)',
            xcon_activa,'Formulario PG1 renglon faltante ',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad,xoperativo, 1)
        ;
END;
$$;


ALTER FUNCTION encu.generar_consistencias_completitud() OWNER TO tedede_php;

--
-- Name: generar_consistencias_filtro(text); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION generar_consistencias_filtro(p_ope text) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
 v_filtros RECORD;
 v_variables_salteadas RECORD;
 v_matrices RECORD;
 v_preguntas RECORD;
 v_desde integer;
 v_hasta integer;
 v_precondicion text;
 v_postcondicion text;
 v_explicacion text;
 v_cuenta integer;
 v_activa BOOLEAN;
BEGIN 
    DELETE FROM encu.inconsistencias
        WHERE inc_ope=p_ope and inc_con like 'flujo_f%';
    DELETE FROM encu.ano_con
        WHERE anocon_ope=p_ope and anocon_con like 'flujo_f%';
    DELETE FROM encu.con_var
        WHERE convar_ope=p_ope and convar_con like 'flujo_f%';
    DELETE FROM encu.consistencias
           WHERE con_ope=p_ope and con_con like 'flujo_f%';
    FOR v_matrices in
        SELECT mat_for as formulario, mat_mat as matriz, mat_texto as texto
               from encu.matrices 
               where mat_ope = p_ope and mat_for <> 'TEM'
        LOOP 
        FOR v_filtros in
            SELECT fil_for as formu, fil_mat as matri, fil_blo as bloque, fil_fil as filtro, fil_expresion as expresion, fil_destino as destino, 
                   fil_orden as orden     
               FROM encu.filtros
               WHERE fil_ope = p_ope and fil_for = v_matrices.formulario and fil_mat = v_matrices.matriz
               ORDER BY fil_orden
        LOOP
           v_precondicion:=replace(lower(v_filtros.expresion),'copia_','');
           select 'Filtro '|| for_nombre into v_explicacion from encu.formularios where for_ope = p_ope and for_for = v_matrices.formulario;
           if v_matrices.matriz <> '' then
              v_explicacion:=v_explicacion||' '||v_matrices.texto;
           end if;
           --  verifico si el destino del filtro es una pregunta
           select count(*) into v_cuenta from encu.preguntas where pre_ope = p_ope and pre_pre = v_filtros.destino;
            if v_cuenta = 1 then 
              FOR v_preguntas in
                  select blo_blo as elemento, 'pregunta' as tipo, blo_orden as orden, blo_for as formulario, pre_pre as codigo_elemento, 
                         pre_orden as orden_elemento, (100000 * blo_orden  + pre_orden) as orden_final, '' as filtro_destino
                         from encu.bloques 
                         inner join encu.preguntas on blo_ope = pre_ope and blo_blo = pre_blo and blo_for = pre_for 
                         where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                  union select blo_blo as elemento, 'filtro' as tipo, blo_orden as orden, blo_for as formulario, fil_fil as codigo_elemento, 
                         fil_orden as orden_elemento, (100000* blo_orden + fil_orden) as orden_final, fil_destino as filtro_destino
                         from encu.bloques 
                         inner join encu.filtros on blo_ope = fil_ope and blo_blo = fil_blo and blo_for = fil_for
                         where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                         order by orden, orden_final
              LOOP
                 if v_preguntas.codigo_elemento = v_filtros.filtro then
                    v_desde:= v_preguntas.orden_final;
                 end if;
                 if v_preguntas.codigo_elemento = v_filtros.destino then
                    v_hasta:= v_preguntas.orden_final;
                 end if;
              END LOOP;
            else
              -- verifico si el destino es un bloque
              v_desde:= 0;
              v_hasta:= 0;
              select count(*) into v_cuenta from encu.bloques  where blo_ope = p_ope and blo_blo = v_filtros.destino;
              if v_cuenta = 1 then
                 FOR v_preguntas in
                     select blo_blo as elemento, 'pregunta' as tipo, blo_orden as orden, blo_for as formulario, pre_pre as codigo_elemento, 
                            pre_orden as orden_elemento, (100000 * blo_orden  + pre_orden) as orden_final, '' as filtro_destino
                            from encu.bloques 
                            inner join encu.preguntas on blo_ope = pre_ope and blo_blo = pre_blo and blo_for = pre_for 
                            where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                     union select blo_blo as elemento, 'filtro' as tipo, blo_orden as orden, blo_for as formulario, fil_fil as codigo_elemento, 
                            fil_orden as orden_elemento, (100000* blo_orden + fil_orden) as orden_final, fil_destino as filtro_destino
                            from encu.bloques 
                            inner join encu.filtros on blo_ope = fil_ope and blo_blo = fil_blo and blo_for = fil_for
                            where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                            order by orden, orden_final
                 LOOP
                    if v_preguntas.codigo_elemento = v_filtros.filtro then
                       v_desde:= v_preguntas.orden_final;
                    end if;
                    if v_preguntas.elemento = v_filtros.destino and v_hasta = 0 then
                       raise notice 'para destino bloque % , orden_final % ', v_filtros.destino, v_preguntas.orden_final;
                       v_hasta:= v_preguntas.orden_final;
                    end if;
                 END LOOP;
              else 
                 -- verifico si el destino es un filtro
                 select count(*) into v_cuenta from encu.filtros where fil_ope = p_ope and fil_fil = v_filtros.destino;
                 if v_cuenta = 1 then
                    FOR v_preguntas in
                        select blo_blo as elemento, 'pregunta' as tipo, blo_orden as orden, blo_for as formulario, pre_pre as codigo_elemento, 
                               pre_orden as orden_elemento, (100000 * blo_orden  + pre_orden) as orden_final, '' as filtro_destino
                               from encu.bloques 
                               inner join encu.preguntas on blo_ope = pre_ope and blo_blo = pre_blo and blo_for = pre_for 
                               where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                        union select blo_blo as elemento, 'filtro' as tipo, blo_orden as orden, blo_for as formulario, fil_fil as codigo_elemento, 
                               fil_orden as orden_elemento, (100000* blo_orden + fil_orden) as orden_final, fil_destino as filtro_destino
                               from encu.bloques 
                               inner join encu.filtros on blo_ope = fil_ope and blo_blo = fil_blo and blo_for = fil_for
                               where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                               order by orden, orden_final
                    LOOP
                       if v_preguntas.codigo_elemento = v_filtros.filtro then
                          v_desde:= v_preguntas.orden_final;
                       end if;
                       if v_preguntas.codigo_elemento = v_filtros.destino then
                          v_hasta:= v_preguntas.orden_final;
                       end if;
                    END LOOP;
                 else
                    --- verifico si el destino es 'fin'
                    if v_filtros.destino = 'fin' then
                       FOR v_preguntas in
                           select blo_blo as elemento, 'pregunta' as tipo, blo_orden as orden, blo_for as formulario, pre_pre as codigo_elemento, 
                                  pre_orden as orden_elemento, (100000 * blo_orden  + pre_orden) as orden_final, '' as filtro_destino
                                  from encu.bloques 
                                  inner join encu.preguntas on blo_ope = pre_ope and blo_blo = pre_blo and blo_for = pre_for 
                                  where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                           union select blo_blo as elemento, 'filtro' as tipo, blo_orden as orden, blo_for as formulario, fil_fil as codigo_elemento, 
                                  fil_orden as orden_elemento, (100000* blo_orden + fil_orden) as orden_final, fil_destino as filtro_destino
                                  from encu.bloques 
                                  inner join encu.filtros on blo_ope = fil_ope and blo_blo = fil_blo and blo_for = fil_for
                                  where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                                  order by orden, orden_final
                       LOOP
                          if v_preguntas.codigo_elemento = v_filtros.filtro then
                             v_desde:= v_preguntas.orden_final;
                          end if;
                          v_hasta:=v_preguntas.orden_final;
                       END LOOP;
                       v_hasta:=v_hasta+1;
                    end if;
                 end if;
              end if;
           end if;
           v_postcondicion:='true ';
           FOR v_preguntas in
               select x.codigo_elemento as codigo_pregunta from
               (select blo_blo as elemento, 'pregunta' as tipo, blo_orden as orden, blo_for as formulario, pre_pre as codigo_elemento, 
                       pre_orden as orden_elemento, (100000 * blo_orden  + pre_orden) as orden_final, '' as filtro_destino
                       from encu.bloques 
                       inner join encu.preguntas on blo_ope = pre_ope and blo_blo = pre_blo and blo_for = pre_for 
                       where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
               union select blo_blo as elemento, 'filtro' as tipo, blo_orden as orden, blo_for as formulario, fil_fil as codigo_elemento, 
                       fil_orden as orden_elemento, (100000* blo_orden + fil_orden) as orden_final, fil_destino as filtro_destino
                       from encu.bloques 
                       inner join encu.filtros on blo_ope = fil_ope and blo_blo = fil_blo and blo_for = fil_for
                       where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                       order by orden, orden_final) x
               where x.orden_final >= v_desde and x.orden_final < v_hasta
           LOOP
              FOR v_variables_salteadas in        
                   SELECT var_var as lavariable
                          FROM encu.preguntas 
                          inner join encu.variables on var_ope = pre_ope and pre_pre = var_pre
                          WHERE pre_ope = p_ope and pre_pre = v_preguntas.codigo_pregunta
                          ORDER BY var_orden         
              LOOP
                 v_postcondicion:=v_postcondicion || 'and '||v_variables_salteadas.lavariable||' is null ';
              END LOOP;
           END LOOP;
           v_activa=NOT (v_filtros.filtro='FILTRO_0');
           INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
                                           con_postcondicion,
                                           con_activa, con_explicacion, con_tipo, con_falsos_positivos,
                                           con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
           values( p_ope, 'flujo_f_'||v_filtros.filtro, v_precondicion, '=>',
                   v_postcondicion, v_activa, v_explicacion, 'Auditoría', false,
                  'ALTA', 'Recepción', 'flujo', 'Error', 1) ;
            IF coalesce(v_hasta,0)=0 THEN
                RAISE EXCEPTION 'ERROR en consistencias flujo_f% , destino no es pregunta, bloque, filtro o fin: %', v_filtros.filtro,v_filtros.destino;
            END IF;     
       END LOOP;
    END LOOP;
END
$$;


ALTER FUNCTION encu.generar_consistencias_filtro(p_ope text) OWNER TO tedede_php;

--
-- Name: generar_consistencias_flujo(text); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION generar_consistencias_flujo(poperativo text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
 opc_saltos text;
 rcons encu.consistencias%rowtype;
 r_saltadas RECORD;
 r_destino RECORD;
 vvar RECORD;
 vopc_s RECORD;
 vsiguiente TEXT;
 vsig_optativa boolean;
 vsig_expresion_habilitar TEXT;
 cond_nsnc text;
 v_nsnc RECORD;
 nsnc_destino TEXT;
 nsnc_tipodestino TEXT; 
 nsnc_optativa BOOLEAN;
 nsnc_expresion_habilitar TEXT;
 val_nsnc varchar(50)[];
BEGIN  
    -- Borrar las automaticas
    DELETE FROM encu.inconsistencias
        WHERE inc_ope=poperativo and inc_con SIMILAR TO 'flujo\_(s|v|sv)\_%';
    DELETE FROM encu.ano_con
        WHERE anocon_ope=poperativo and anocon_con SIMILAR TO 'flujo\_(s|v|sv)\_%';
    DELETE FROM encu.con_var
        WHERE convar_ope=poperativo and convar_con SIMILAR TO 'flujo\_(s|v|sv)\_%';
    DELETE FROM encu.consistencias
        WHERE con_ope=poperativo and con_con SIMILAR TO 'flujo\_(s|v|sv)\_%';
    FOR vvar IN --para cada salto
        select distinct v.var_for, v.var_mat, s.sal_var, v.var_destino_nsnc
            from encu.saltos s JOIN encu.variables v ON s.sal_var= v.var_var AND s.sal_ope=v.var_ope
            where s.sal_ope=poperativo  
            order by v.var_for, v.var_mat, s.sal_var            
    LOOP
        opc_saltos='';
        --c/opciones de salto
        FOR vopc_s IN
            select distinct on(sal_var,opc_orden)  
                   sal_var, sal_opc , sal_destino as sal_pre, w.var_var as var_destino,w.var_expresion_habilitar,
                   w.var_optativa as var_destino_optativa
                from encu.saltos s 
                    JOIN encu.opciones o  ON o.opc_opc=s.sal_opc AND o.opc_ope=s.sal_ope AND o.opc_conopc=s.sal_conopc
                    LEFT JOIN encu.variables w ON  w.var_pre=s.sal_destino and w.var_ope=s.sal_ope and w.var_for=vvar.var_for and w.var_mat=vvar.var_mat
                where s.sal_ope=poperativo and s.sal_var= vvar.sal_var --and s.sal_destino=vvar.sal_destino 
                order by sal_var, opc_orden, w.var_orden
        loop            
            --flujo_s_ : variables saltadas en NULL
            r_destino=encu.validar_variable_destino(poperativo, vvar.var_for, vvar.var_mat, vvar.sal_var, vopc_s.sal_pre, vopc_s.var_destino);
            IF r_destino.ptipodestinosalto IS NOT NULL THEN
                r_saltadas=encu.variables_saltadas(poperativo, vvar.sal_var, r_destino.pvardestino,r_destino.ptipodestinosalto );
            ELSE
                r_saltadas.psaltadas_str='Revisar. Destino de salto no considerado';
                r_saltadas.psaltadas_cond_str='Revisar. Destino de salto no considerado';
            END IF;
            IF NOT r_saltadas.psaltadas_str='' THEN
               raise notice '% destino % str_saltadas_condicion % largo %',vopc_s.sal_var,vopc_s.var_destino, r_saltadas.psaltadas_cond_str, length(r_saltadas.psaltadas_cond_str) ; 
               rcons.con_ope=poperativo;
               rcons.con_con='flujo_s_' || vvar.sal_var ||'_' || vopc_s.sal_opc;
               rcons.con_precondicion= vvar.sal_var||'='||vopc_s.sal_opc;
               rcons.con_rel='=>';
               rcons.con_postcondicion=r_saltadas.psaltadas_cond_str; 
               rcons.con_explicacion='Con salto en '||vvar.sal_var||'='||vopc_s.sal_opc ||' no debe ingresar '|| r_saltadas.psaltadas_str;
               execute encu.insert_consistencia_flujo(rcons.con_ope, rcons.con_con, rcons.con_precondicion, rcons.con_rel,
                                    rcons.con_postcondicion, rcons.con_explicacion);
           END IF;                                
           --flujo_sv : VARIABLE DESTINO DEBE TENER VALOR
           IF vopc_s.var_destino_optativa IS FALSE AND r_destino.ptipodestinosalto in ('var','pre') THEN
               rcons.con_ope=poperativo;
               rcons.con_con='flujo_sv_' || vvar.sal_var ||'_' || vopc_s.sal_opc;
               --rcons.con_precondicion= vvar.sal_var||'='||vopc_s.sal_opc || coalesce (' and '|| vopc_s.var_expresion_habilitar,'') ;
               rcons.con_precondicion= vvar.sal_var||'='||vopc_s.sal_opc ;
               rcons.con_precondicion= rcons.con_precondicion ||case when coalesce(length(trim(vopc_s.var_expresion_habilitar)),0)>0 and rcons.con_precondicion is distinct from vopc_s.var_expresion_habilitar then ' and ('|| vopc_s.var_expresion_habilitar||')' else '' end;
               rcons.con_rel='=>';
               rcons.con_postcondicion= 'informado(' || vopc_s.var_destino || ')'; 
               rcons.con_explicacion='Con salto en '||vvar.sal_var||'='||vopc_s.sal_opc||' debe informar '|| vopc_s.var_destino;
               execute encu.insert_consistencia_flujo(rcons.con_ope, rcons.con_con, rcons.con_precondicion, rcons.con_rel,
                                    rcons.con_postcondicion, rcons.con_explicacion);
           END IF;         
           opc_saltos= opc_saltos || ' or ' ||  vopc_s.sal_var || '=' || vopc_s.sal_opc  ;
        END LOOP; 
        --flujo_v_
        -- consultar siguiente
        SELECT v.var_var, v.var_optativa , v.var_expresion_habilitar
            INTO vsiguiente, vsig_optativa, vsig_expresion_habilitar
            FROM encu.variables_ordenadas v 
                JOIN encu.variables_ordenadas x on x.var_ope=v.var_ope and x.orden<v.orden
                               and x.pre_orden<=v.pre_orden and v.var_for=x.var_for
            WHERE x.var_var= vvar.sal_var  and x.var_ope=poperativo
            ORDER BY v.orden
            LIMIT 1; 
        opc_saltos= substr(opc_saltos,5);
        IF vsiguiente is not null and vsig_optativa is false and opc_saltos<>'' THEN
           --raise notice 'saltos origen % ', opc_saltos;
           rcons.con_ope=poperativo; 
           rcons.con_con='flujo_v_' || vvar.sal_var;
           cond_nsnc='';
           IF vvar.var_destino_nsnc IS NOT NULL THEN
             cond_nsnc= 'and not ('||vvar.sal_var||'=-1 or '||vvar.sal_var||'=-9)';
           END IF;
           rcons.con_precondicion= 'informado(' ||vvar.sal_var||') and not('|| opc_saltos ||') '||
                                   cond_nsnc|| 
                                   case when coalesce(length(trim(vsig_expresion_habilitar)),0)>0 then ' and ('|| vsig_expresion_habilitar||')' else '' end;
           rcons.con_rel='=>';
           rcons.con_postcondicion= 'informado('||vsiguiente || ')'; 
           rcons.con_explicacion='Sin salto en '||vvar.sal_var||' debe informar '|| vsiguiente;
           execute encu.insert_consistencia_flujo(rcons.con_ope, rcons.con_con, rcons.con_precondicion, rcons.con_rel,
                                rcons.con_postcondicion, rcons.con_explicacion);
        END IF;
    END LOOP;
    FOR v_nsnc IN
        select var_for, var_var, var_destino_nsnc, var_tipovar
            from encu.variables_ordenadas  
            where var_ope=poperativo and var_destino_nsnc is not null  
            order by orden         
    LOOP
      -- var_destino, str_saltadas, cond_saltadas, var_destino_optativa, expresion_habilitar_destino
        SELECT v.var_var, v.var_optativa, v.var_expresion_habilitar,
                case when v.var_var= v_nsnc.var_destino_nsnc then 'var' 
                     when v.var_pre=v_nsnc.var_destino_nsnc then 'pre' 
                     when v.blo_blo=v_nsnc.var_destino_nsnc then 'blo' 
                     else 'fil'
                end
            INTO nsnc_destino, nsnc_optativa, nsnc_expresion_habilitar, nsnc_tipodestino
            FROM encu.variables_ordenadas v 
            WHERE v.var_ope= poperativo AND 
                 (v.var_var= v_nsnc.var_destino_nsnc or v.var_pre=v_nsnc.var_destino_nsnc or v.blo_blo=v_nsnc.var_destino_nsnc)
            ORDER BY v.var_ope, v.var_orden
            LIMIT 1;
        --r_destino=encu.validar_variable_destino(poperativo, vvar.var_for, vvar.var_mat, vvar.sal_var, nsnc_destino, case when nsnc_tipodestino= then end );
        /*
        IF r_destino.ptipodestinosalto IS NOT NULL THEN
            r_saltadas=encu.variables_saltadas(poperativo, vvar.sal_var, r_destino.pvardestino );
        ELSE
            r_saltadas.psaltadas_str='Revisar. Destino de salto no considerado';
            r_saltadas.psaltadas_cond_str='Revisar. Destino de salto no considerado';
        END IF;            
        */    
        r_saltadas=encu.variables_saltadas(poperativo, v_nsnc.var_var, nsnc_destino,'var' );
        raise notice '% destino % saltadas_str % largo %',v_nsnc.var_var,nsnc_destino, r_saltadas.psaltadas_str, length(r_saltadas.psaltadas_str) ; 
        raise notice ' % destino % saltadas_cond_str %',v_nsnc.var_var,nsnc_destino, r_saltadas.psaltadas_cond_str;
        val_nsnc[1]='-1';
        val_nsnc[2]='-9';            
        IF v_nsnc.var_tipovar IN ('fecha','fecha_corta','observaciones','telefono','texto','texto_especificar','texto_libre','timestamp') THEN
            val_nsnc[1]='a_texto('||val_nsnc[1]||')';
            val_nsnc[2]='a_texto('||val_nsnc[2]||')';            
        END IF;
        IF NOT r_saltadas.psaltadas_str='' THEN
            -- flujo_s_xvar_nsnc
            rcons.con_ope=poperativo; 
            rcons.con_con='flujo_s_' || v_nsnc.var_var||'_nsnc';
            rcons.con_precondicion= v_nsnc.var_var||'='|| val_nsnc[1]||' or '||v_nsnc.var_var||'='|| val_nsnc[2];
            rcons.con_rel='=>';
            rcons.con_postcondicion= r_saltadas.psaltadas_cond_str; 
            rcons.con_explicacion='Con salto en '||v_nsnc.var_var||' por NSNC, no debe ingresar '|| r_saltadas.psaltadas_str ;
            execute encu.insert_consistencia_flujo(rcons.con_ope, rcons.con_con, rcons.con_precondicion, rcons.con_rel,
                                 rcons.con_postcondicion, rcons.con_explicacion);
        END IF;  
        IF nsnc_optativa IS FALSE  THEN
            -- flujo_sv_xvar_nsnc
            rcons.con_ope=poperativo; 
            rcons.con_con='flujo_sv_' || v_nsnc.var_var||'_nsnc';
            rcons.con_precondicion= '('||v_nsnc.var_var||'='||val_nsnc[1]||' or '||v_nsnc.var_var||'='||val_nsnc[2]||')' ||
                            case when coalesce(length(trim(nsnc_expresion_habilitar)),0)>0 then ' and '|| nsnc_expresion_habilitar else '' end ;
            rcons.con_rel='=>';
            rcons.con_postcondicion= 'informado(' || nsnc_destino || ')'; 
            rcons.con_explicacion='Con salto en '||v_nsnc.var_var||' por NSNC, debe informar '|| nsnc_destino;
            execute encu.insert_consistencia_flujo(rcons.con_ope, rcons.con_con, rcons.con_precondicion, rcons.con_rel,
                                 rcons.con_postcondicion, rcons.con_explicacion);
        END IF;        
    END LOOP;
END;
$$;


ALTER FUNCTION encu.generar_consistencias_flujo(poperativo text) OWNER TO tedede_php;

--
-- Name: generar_consistencias_flujo_obligatorio(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION generar_consistencias_flujo_obligatorio() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
 poperativo TEXT; 
 opc_saltos text;
 rcons encu.consistencias%rowtype;
 r_saltadas RECORD;
 r_destino RECORD;
 vvar RECORD;
 vobli_s RECORD;
 vsiguiente TEXT;
 vsig_optativa boolean;
 vsig_expresion_habilitar TEXT;
 cond_nsnc text;
 v_nsnc RECORD;
 nsnc_destino TEXT;
 nsnc_tipodestino TEXT; 
 nsnc_optativa BOOLEAN;
 nsnc_expresion_habilitar TEXT;
 val_nsnc varchar(50)[];
BEGIN  
    poperativo= dbo.ope_actual();
    -- Borrar las automaticas
    DELETE FROM encu.inconsistencias
        WHERE inc_ope=poperativo and inc_con SIMILAR TO 'flujo_o\_(s|v|sv)\_%';
    DELETE FROM encu.ano_con
        WHERE anocon_ope=poperativo and anocon_con SIMILAR TO 'flujo_o\_(s|v|sv)\_%';
    DELETE FROM encu.con_var
        WHERE convar_ope=poperativo and convar_con SIMILAR TO 'flujo_o\_(s|v|sv)\_%';
    DELETE FROM encu.consistencias
        WHERE con_ope=poperativo and con_con SIMILAR TO 'flujo_o\_(s|v|sv)\_%';
    FOR vvar IN --para cada salto
        select distinct v.var_for, v.var_mat, v.var_var, v.var_destino_nsnc
            from encu.variables v
            where v.var_ope=poperativo AND var_destino IS NOT NULL and replace(var_destino,' ','') is distinct from ''
            order by v.var_for, v.var_mat, v.var_var            
    LOOP
        FOR vobli_s IN
            select s.var_var, s.var_destino as var_pre_destino, w.var_var as var_destino,w.var_expresion_habilitar,
                   w.var_optativa as var_destino_optativa
                from encu.variables s 
                    LEFT JOIN encu.variables w ON  w.var_pre=s.var_destino and w.var_ope=s.var_ope and w.var_for=vvar.var_for and w.var_mat=vvar.var_mat
                where s.var_ope=poperativo and s.var_var= vvar.var_var --and s.sal_destino=vvar.sal_destino 
                order by var_var, w.var_orden
                limit 1
        loop            
            --flujo_s_ : variables saltadas en NULL
            r_destino=encu.validar_variable_destino(poperativo, vvar.var_for, vvar.var_mat, vvar.var_var, vobli_s.var_pre_destino, vobli_s.var_destino);
            IF r_destino.ptipodestinosalto IS NOT NULL THEN
                r_saltadas=encu.variables_saltadas(poperativo, vvar.var_var, r_destino.pvardestino,r_destino.ptipodestinosalto );
            ELSE
                r_saltadas.psaltadas_str='Revisar. Destino de salto no considerado';
                r_saltadas.psaltadas_cond_str='Revisar. Destino de salto no considerado';
            END IF;
            IF NOT r_saltadas.psaltadas_str='' THEN
               raise notice '% destino % str_saltadas_condicion % largo %',vobli_s.var_var,vobli_s.var_destino, r_saltadas.psaltadas_cond_str, length(r_saltadas.psaltadas_cond_str) ; 
               rcons.con_ope=poperativo;
               rcons.con_con='flujo_o_s_' || vvar.var_var ;
               rcons.con_precondicion= 'informado('||vvar.var_var||')';
               rcons.con_rel='=>';
               rcons.con_postcondicion=r_saltadas.psaltadas_cond_str; 
               rcons.con_explicacion='Con salto obligatorio en '||vvar.var_var||' no debe ingresar '|| r_saltadas.psaltadas_str;
               execute encu.insert_consistencia_flujo(rcons.con_ope, rcons.con_con, rcons.con_precondicion, rcons.con_rel,
                                    rcons.con_postcondicion, rcons.con_explicacion);
           END IF;                                
           --flujo_sv : VARIABLE DESTINO DEBE TENER VALOR
           IF vobli_s.var_destino_optativa IS FALSE AND r_destino.ptipodestinosalto in ('var','pre') THEN
               rcons.con_ope=poperativo;
               rcons.con_con='flujo_o_sv_' || vvar.var_var ;
               --rcons.con_precondicion= vvar.var_var||'='||vobli_s.sal_opc || coalesce (' and '|| vobli_s.var_expresion_habilitar,'') ;
               rcons.con_precondicion= 'informado('||vvar.var_var||')';
               rcons.con_precondicion= rcons.con_precondicion ||case when coalesce(length(trim(vobli_s.var_expresion_habilitar)),0)>0 and rcons.con_precondicion is distinct from vobli_s.var_expresion_habilitar then ' and ('|| vobli_s.var_expresion_habilitar||')' else '' end;
               rcons.con_rel='=>';
               rcons.con_postcondicion= 'informado(' || vobli_s.var_destino || ')'; 
               rcons.con_explicacion='Con salto obligatorio en '||vvar.var_var||' debe informar '|| vobli_s.var_destino;
               execute encu.insert_consistencia_flujo(rcons.con_ope, rcons.con_con, rcons.con_precondicion, rcons.con_rel,
                                    rcons.con_postcondicion, rcons.con_explicacion);
           END IF;         
        END LOOP; 
    END LOOP;
END;
$$;


ALTER FUNCTION encu.generar_consistencias_flujo_obligatorio() OWNER TO tedede_php;

--
-- Name: generar_trigger_variables_calculadas(text); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION generar_trigger_variables_calculadas(p_cual text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
    v_enter text:=chr(13)||chr(10);
    v_tab TEXT;
    v_script_principio text;
    v_script_final     text;
    v_script_creador   text;
    v_script_trigger   text;    
    v_variables record;
    v_opciones record;
    v_sentencia_calculo text:='';
    v_sentencia text:='';
    v_expresion text;
    v_opcion text;
    v_identifica_var_regexp text;
    v_destinos record;
    v_plana_trigger text;
    v_nombre_funcion text;
    v_sentencia_variable  text;
    v_alterplanas_add     text;
    v_alterplanas_drop    text;
    v_alterhisplanas_add  text;
    v_alterhisplanas_drop text;
    v_set_update     text;
    v_revisadas integer:=0;
    v_expresion_valor text;
    v_declare text;
    v_declare_total text;
    v_select_str_otro_for text;
    v_listaselect text;
    v_variables_otro_formulario record;
    v_otro_formulario record;
    v_listainto  text;
    v_variable_mensaje text:='indeterminado';
    v_sentencia_borrar text;
    v_si_existe integer;
    v_variables_a_borrar record;
    v_tipodatovar text;
    v_tiporiginal text;
    v_pos_error_var integer;
    v_listavar    text;
    v_listavar_total    text;
    v_listareemplazo text;
    v_campo_set  text;
    error_mensaje TEXT;
    error_mensaje_detalle TEXT;
    error_mensaje_ayuda TEXT;
    error_mensaje_linea TEXT;
    error_codigo TEXT;

    
BEGIN
  v_tab=repeat(' ',4);
  -- v_identifica_var_regexp := '\m(?!AND)(?!OR)(?!NOT)(?!IS)(?!NULL)(?!IN)(?!TRUE)(?!FALSE)(?!EXISTS)(?!DISTINCT)(?!FROM)(?!BETWEEN)(?!dbo)([a-z]\w*)(?!\s*(\(|\$\$))\M';
  FOR v_destinos in
    select destino, plana_destino, otro_destino_1, otro_destino_2, formulario, matriz 
        from (
              select 'hog'::text as destino, 's1_'::text as plana_destino, 'i1_'::text as otro_destino_1, (select lower(mat_for||'_'||mat_mat) from encu.matrices where mat_for='A1' and mat_mat='X') as otro_destino_2, 'S1'::text as formulario, null as matriz
              union select 'mie'::text, 'i1_'::text, 's1_'::text as otro_destino_1, (select lower(mat_for||'_'||mat_mat) from encu.matrices where mat_for='A1' and mat_mat='X') as otro_destino_2, 'I1'::text as formulario, null as matriz
              union select 'exm'::text, lower(mat_for||'_'||mat_mat)as plana_destino, 'i1_'::text as otro_destino_1, 's1_'::text as otro_destino_2 , mat_for as formulario, mat_mat as matriz
                        from encu.matrices
                        where mat_ope= dbo.ope_actual() and mat_for='A1' and mat_mat='X'
             ) x
  LOOP
    v_alterplanas_add:='';
    v_alterplanas_drop:='';
    v_alterhisplanas_add:='';
    v_alterhisplanas_drop:='';
    --- borro las variables calculadas que fueron eliminadas de varcal y quedan en las planas
    if v_destinos.matriz is null then
      FOR v_variables_a_borrar in
        select column_name as i_var_borrar from information_schema.columns where table_name = 'plana_'||v_destinos.plana_destino and table_schema = 'encu' 
          and substr(column_name,5) not in ('enc','hog','mie','exm','tlg')
          and substr(column_name,5) not in (select var_var from encu.variables where var_ope = dbo.ope_actual() and var_for = v_destinos.formulario) 
          and substr(column_name,5) not in (select distinct(varcal_varcal) from encu.varcal inner join encu.varcalopc on varcal_varcal=varcalopc_varcal where varcal_ope = dbo.ope_actual() and varcal_destino = v_destinos.destino and varcal_tipo ='normal')
          and substr(column_name,5) not in (select varcal_varcal from encu.varcal where varcal_ope = dbo.ope_actual() and varcal_destino = v_destinos.destino and varcal_activa and varcal_tipo ='externo')
          and substr(column_name,5) not in (select varcal_varcal from encu.varcal where varcal_ope = dbo.ope_actual() and varcal_destino = v_destinos.destino and varcal_activa and varcal_tipo ='especial')
      LOOP
        v_si_existe:=0;
        select count(*) into v_si_existe from information_schema.columns where table_schema = 'his' and table_name = 'plana_'||v_destinos.plana_destino and lower(column_name) = lower(v_variables_a_borrar.i_var_borrar);
          if v_si_existe=1 then
              v_alterhisplanas_drop:=v_alterhisplanas_drop||'alter table his.plana_'||v_destinos.plana_destino||' drop column '||v_variables_a_borrar.i_var_borrar||';'||v_enter;
          end if;
          v_alterplanas_drop:=v_alterplanas_drop||'alter table encu.plana_'||v_destinos.plana_destino||' drop column '||v_variables_a_borrar.i_var_borrar||';'||v_enter;
      END LOOP;
    else
      FOR v_variables_a_borrar in
        select column_name as i_var_borrar from information_schema.columns where table_name = 'plana_'||v_destinos.plana_destino and table_schema = 'encu' 
          and substr(column_name,5) not in ('enc','hog','mie','exm','tlg')
          and substr(column_name,5) not in (select var_var from encu.variables where var_ope = dbo.ope_actual() and var_for = v_destinos.formulario and var_mat = v_destinos.matriz) 
          and substr(column_name,5) not in (select distinct(varcal_varcal) from encu.varcal inner join encu.varcalopc on varcal_varcal=varcalopc_varcal where varcal_ope = dbo.ope_actual() and varcal_destino = v_destinos.destino and varcal_tipo ='normal')
          and substr(column_name,5) not in (select varcal_varcal from encu.varcal where varcal_ope = dbo.ope_actual() and varcal_destino = v_destinos.destino and varcal_activa and varcal_tipo ='externo')
          and substr(column_name,5) not in (select varcal_varcal from encu.varcal where varcal_ope = dbo.ope_actual() and varcal_destino = v_destinos.destino and varcal_activa and varcal_tipo ='especial')
      LOOP
        v_si_existe:=0;
        select count(*) into v_si_existe from information_schema.columns where table_schema = 'his' and table_name = 'plana_'||v_destinos.plana_destino and lower(column_name) = lower(v_variables_a_borrar.i_var_borrar);
          if v_si_existe=1 then
              v_alterhisplanas_drop:=v_alterhisplanas_drop||'alter table his.plana_'||v_destinos.plana_destino||' drop column '||v_variables_a_borrar.i_var_borrar||';'||v_enter;
          end if;
          v_alterplanas_drop:=v_alterplanas_drop||'alter table encu.plana_'||v_destinos.plana_destino||' drop column '||v_variables_a_borrar.i_var_borrar||';'||v_enter;
      END LOOP;
    end if;
    --generar variables de otros formularios
    v_select_str_otro_for='';
    v_listavar_total='';
    v_declare_total='';
    FOR v_otro_formulario in
        select v_otro_for, v_otra_mat, v_otro_blo, v_alias, v_condic, 'encu.plana_'||lower(v_otro_for)||'_'||lower(v_otra_mat)||' '||v_alias  as v_tabla
            from (
                   select 'S1'::text  as v_otro_for, 'P'::text as v_otra_mat, '' as v_otro_blo,'s'::text as v_alias,
                                ' s.pla_enc = new.pla_enc and s.pla_hog = new.pla_hog and s.pla_mie = new.pla_mie and s.pla_exm = 0 '::text as v_condic
                   union select 'TEM'::text as v_otro_for, ''::text as v_otra_mat,'' as v_otro_blo,'t'::text as v_alias,
                                ' t.pla_enc = new.pla_enc and t.pla_hog = 0 and t.pla_mie = 0 and t.pla_exm = 0 '::text as v_condic
                   union select blo_for as v_otro_for, blo_mat as v_otra_mat, 'Viv' as v_ptro_blo,'a'::text as v_alias,
                                ' a.pla_enc = new.pla_enc and a.pla_hog=1 and a.pla_mie = 0 and a.pla_exm = 0 '::text as v_condic
                            from encu.bloques where blo_blo ='Viv'
                   union select blo_for as v_otro_for, blo_mat as v_otra_mat, '' as v_otro_blo,'a'::text as v_alias,
                               ' a.pla_enc = new.pla_enc and a.pla_hog=new.pla_hog and a.pla_mie = 0 and a.pla_exm = 0 '::text as v_condic
                            from encu.bloques where blo_blo ='Hog'
        ) x
    LOOP
        -- acá van las variables de formularios distintos al del trigger que se está creando
        -- en el caso de variables del bloque Viv, hay que leer el hogar 1
        select string_agg(var_var, '|'), 
                   string_agg(v_enter||v_tab||'v_'||var_var||' '||CASE when var_tipovar in ('integer','anio','anios','numeros','opciones','si_no') then 'integer' else 'text' END, ';'),
                   string_agg('pla_'||var_var, ','),
                   string_agg('v_'||var_var, ',')
            into v_listavar, v_declare,
                 v_listaselect, v_listainto 
            from (
                    select var_var, var_for, var_mat, CASE WHEN coalesce(pre_blo,'') ='Viv' THEN pre_blo ELSE '' END as v_blo,var_tipovar, pre_orden, var_orden
                        from encu.variables join encu.preguntas on var_pre = pre_pre and pre_ope=var_ope
                        where var_ope = dbo.ope_actual() and
                            (var_mat='P' or pre_blo in ('Viv','Hog'))
                    union select 'comuna'::text  as var_var, 'TEM'::text as var_for, '' as var_mat,'' as v_blo, 'integer' as var_tipovar, 1 pre_orden, 1 var_orden
                    union select 'estado'::text  as var_var, 'TEM'::text as var_for, '' as var_mat,'' as v_blo, 'integer' as var_tipovar, 2 pre_orden, 2 var_orden
                    union select 'dominio'::text as var_var, 'TEM'::text as var_for, '' as var_mat,'' as v_blo, 'integer' as var_tipovar ,3 pre_orden, 3 var_orden
                    order by var_for,var_mat, v_blo,pre_orden, var_orden
                    ) x 
            where var_for = v_otro_formulario.v_otro_for and var_mat=v_otro_formulario.v_otra_mat and v_blo=v_otro_formulario.v_otro_blo;
        v_select_str_otro_for:=v_select_str_otro_for||
                      v_tab||' SELECT '||v_listaselect||v_enter||
                      v_tab||'   INTO '||v_listainto||v_enter||
                      v_tab||'   FROM '||v_otro_formulario.v_tabla||v_enter||
                      v_tab||'   WHERE '||v_otro_formulario.v_condic||';'||v_enter;
        v_declare_total=v_declare_total || v_declare||';';
        v_listavar_total= v_listavar_total|| v_listavar||'|';
        --raise notice 'v_buscar: %', v_buscar;          
        --raise notice 'v_into: %', v_into;            
        raise notice 'consultas: %', v_select_str_otro_for;            
    END LOOP;        
    v_sentencia_calculo:='';
    ---  recorro las variables calculadas para el formulario plana_destino
    FOR v_variables in
        select distinct(varcal_varcal) as i_variable, varcal_tipodedato as i_tipodedato, varcal_orden 
            from encu.varcal inner join encu.varcalopc on varcal_varcal = varcalopc_varcal
            where varcal_ope = dbo.ope_actual()
                and varcal_destino = v_destinos.destino
                and varcal_activa
                and varcal_tipo not in ('externo','especial')
                and (varcal_varcal=p_cual or p_cual='#todo')
            order by varcal_orden, varcal_varcal
    LOOP
        v_revisadas:=v_revisadas+1;
        v_tipodatovar:='';
        case v_variables.i_tipodedato
            when 'entero' then v_tipodatovar:='integer';
            when 'decimal' then v_tipodatovar:='numeric';
            else v_tipodatovar:='integer';
        end case;  
        -- agregamos si no existe
        select count(*) into v_si_existe from information_schema.columns where table_schema = 'encu' and table_name = 'plana_'||v_destinos.plana_destino and lower(column_name) = 'pla_'||lower(v_variables.i_variable);
        if v_si_existe=0 then
            v_alterplanas_add:=v_alterplanas_add||'alter table encu.plana_'||v_destinos.plana_destino||' add column pla_'||v_variables.i_variable||' '||v_tipodatovar||'; '||v_enter;
        else 
            select data_type into v_tiporiginal from information_schema.columns where table_schema = 'encu' and table_name = 'plana_'||v_destinos.plana_destino and lower(column_name) = 'pla_'||lower(v_variables.i_variable);
            if v_tiporiginal <> v_tipodatovar then
                v_alterplanas_add:=v_alterplanas_add||'alter table encu.plana_'||v_destinos.plana_destino||' add column pla_'||v_variables.i_variable||' '||v_tipodatovar||'; '||v_enter;
                v_alterplanas_drop:=v_alterplanas_drop||'alter table encu.plana_'||v_destinos.plana_destino||' drop column pla_'||v_variables.i_variable||';'||v_enter;
            end if;
        end if;
        select count(*) into v_si_existe from information_schema.columns where table_schema = 'his' and table_name = 'plana_'||v_destinos.plana_destino and lower(column_name) = 'pla_'||lower(v_variables.i_variable);
        if v_si_existe=0 then
            v_alterhisplanas_add:=v_alterhisplanas_add||'alter table his.plana_'||v_destinos.plana_destino||' add column pla_'||v_variables.i_variable||' '||v_tipodatovar||'; '||v_enter;
        else
            select data_type into v_tiporiginal from information_schema.columns where table_schema = 'his' and table_name = 'plana_'||v_destinos.plana_destino and lower(column_name) = 'pla_'||lower(v_variables.i_variable);
            if v_tiporiginal <> v_tipodatovar then
                v_alterplanas_add:=v_alterplanas_add||'alter table his.plana_'||v_destinos.plana_destino||' add column pla_'||v_variables.i_variable||' '||v_tipodatovar||'; '||v_enter;
                v_alterplanas_drop:=v_alterplanas_drop||'alter table his.plana_'||v_destinos.plana_destino||' drop column pla_'||v_variables.i_variable||';'||v_enter;
            end if;
        end if;
        -- borramos si existe en otra plana
        select count(*) into v_si_existe from information_schema.columns where table_schema = 'encu' and table_name = 'plana_'||v_destinos.otro_destino_1 and lower(column_name) = 'pla_'||lower(v_variables.i_variable);
        if v_si_existe=1 then
            v_alterplanas_drop:=v_alterplanas_drop||'alter table encu.plana_'||v_destinos.otro_destino_1||' drop column pla_'||v_variables.i_variable||';'||v_enter;
        end if;
        select count(*) into v_si_existe from information_schema.columns where table_schema = 'his' and table_name = 'plana_'||v_destinos.otro_destino_1 and lower(column_name) = 'pla_'||lower(v_variables.i_variable);
        if v_si_existe=1 then
            v_alterhisplanas_drop:=v_alterhisplanas_drop||'alter table his.plana_'||v_destinos.otro_destino_1||' drop column pla_'||v_variables.i_variable||';'||v_enter;
        end if;
        select count(*) into v_si_existe from information_schema.columns where table_schema = 'encu' and table_name = 'plana_'||v_destinos.otro_destino_2 and lower(column_name) = 'pla_'||lower(v_variables.i_variable);
        if v_si_existe=1 then
            v_alterplanas_drop:=v_alterplanas_drop||'alter table encu.plana_'||v_destinos.otro_destino_2||' drop column pla_'||v_variables.i_variable||';'||v_enter;
        end if;
        select count(*) into v_si_existe from information_schema.columns where table_schema = 'his' and table_name = 'plana_'||v_destinos.otro_destino_2 and lower(column_name) = 'pla_'||lower(v_variables.i_variable);
        if v_si_existe=1 then
            v_alterhisplanas_drop:=v_alterhisplanas_drop||'alter table his.plana_'||v_destinos.otro_destino_2||' drop column pla_'||v_variables.i_variable||';'||v_enter;
        end if;
        
        v_listareemplazo= '\mnew.pla_('||v_listavar_total||')\M';
        --- por cada variable recorro sus opciones
        v_sentencia_variable:='';
        FOR v_opciones IN
            select varcalopc_opcion as i_opcion, varcalopc_expresion_condicion as i_expresion_condicion,
                    varcalopc_expresion_valor as i_expresion_valor
                from encu.varcalopc
                where varcalopc_ope = dbo.ope_actual() and varcalopc_varcal = v_variables.i_variable
                order by varcalopc_ope, varcalopc_varcal, varcalopc_opcion  
        LOOP
            v_expresion:=v_opciones.i_expresion_condicion;
            v_opcion:=v_opciones.i_opcion;
            v_expresion_valor:=v_opciones.i_expresion_valor;
            v_expresion:= encu.reemplazar_agregadores(v_expresion);
            v_expresion:= comun.reemplazar_variables(v_expresion, 'new.pla_\1');
            v_expresion:= regexp_replace(v_expresion, v_listareemplazo::text, 'v_\1'::text,'ig');
            v_expresion_valor:= encu.reemplazar_agregadores(v_expresion_valor);
            v_expresion_valor:= comun.reemplazar_variables(v_expresion_valor, 'new.pla_\1');
            v_expresion_valor:= regexp_replace(v_expresion_valor, v_listareemplazo::text, 'v_\1'::text,'ig');
            v_sentencia_variable:=v_sentencia_variable||v_enter||v_tab||v_tab||'when ('||v_expresion||') then '||coalesce(v_expresion_valor,v_opcion);
        END LOOP;
        IF v_sentencia_variable<>'' THEN
            v_sentencia_variable:=v_tab||' new.pla_'||v_variables.i_variable||':=case '||v_sentencia_variable||v_enter||v_tab||v_tab||' else null end; '||v_enter;
            v_sentencia_calculo:=v_sentencia_calculo||v_enter||v_sentencia_variable;
        END IF;
    END LOOP;
    IF v_sentencia_calculo<>'' THEN
        --- creo el script para generar
        v_plana_trigger:='encu.plana_'||v_destinos.plana_destino;
        v_nombre_funcion:='calculo_variables_calculadas_tmp'||v_destinos.plana_destino||'_trg';
        if(p_cual='#todo')then
            v_nombre_funcion:=replace(v_nombre_funcion,'tmp','');
        end if;

        v_script_principio:='
    CREATE OR REPLACE FUNCTION encu.$1()
         RETURNS trigger AS
    $BODY$
    DECLARE'
    ||v_declare_total||'
    BEGIN'||v_enter
    ||v_select_str_otro_for ;
    
    
        v_script_final:=$SCRIPT2$
    return new;
    END;
    $BODY$
    LANGUAGE plpgsql;
    ALTER FUNCTION encu.$1()
            OWNER TO tedede_php;
    $SCRIPT2$;
        v_script_trigger= $SCRIPT3$;
    DROP TRIGGER IF EXISTS $1 ON $2;
    CREATE TRIGGER $1
        BEFORE UPDATE
            ON $2
            FOR EACH ROW
            EXECUTE PROCEDURE encu.$1();
    $SCRIPT3$;
        
        v_script_creador:= v_alterplanas_drop||v_alterhisplanas_drop||
                           v_alterplanas_add||v_alterhisplanas_add;
        v_script_creador:=v_script_creador
                        || v_script_principio
                        || v_sentencia_calculo
                        || v_script_final;
         --raise notice 'script creador %', v_script_creador;
        v_script_creador:=replace(v_script_creador,'$1',v_nombre_funcion);
        v_script_trigger:=replace(replace(v_script_trigger,'$1',v_nombre_funcion),'$2',v_plana_trigger);
        BEGIN
          raise notice ' v_script_creador % ', v_script_creador;
          EXECUTE v_script_creador;
          EXECUTE v_script_trigger;
          
          --Forzar la ejecucion del trigger recien generado
          BEGIN
            v_set_update='  set pla_#campo_set = pla_#campo_set ';
            v_sentencia='';
            select var_var 
                into v_campo_set
                from encu.variables_ordenadas
                where var_ope=dbo.ope_actual() and var_for=v_destinos.formulario
                      and var_mat=coalesce(v_destinos.matriz,'')
                limit 1;
            v_set_update= replace(v_set_update,'#campo_set',v_campo_set);
            v_sentencia= 'update encu.plana_'||v_destinos.plana_destino||v_set_update;
            raise notice 'sentencia %', v_sentencia;
            EXECUTE  v_sentencia;  
            UPDATE encu.varcal
                SET varcal_valida=TRUE
                WHERE varcal_activa = TRUE;
            
          END;
          EXCEPTION
              WHEN OTHERS THEN
                    GET STACKED DIAGNOSTICS error_mensaje = MESSAGE_TEXT,
                          error_mensaje_detalle = PG_EXCEPTION_DETAIL,
                          error_mensaje_ayuda = PG_EXCEPTION_HINT,
                          error_mensaje_linea = PG_EXCEPTION_CONTEXT,
                          error_codigo= RETURNED_SQLSTATE;              
                v_pos_error_var:=strpos(sqlerrm, '«pla_'); 
                if v_pos_error_var>0 then
                   v_variable_mensaje:=substr(substr(sqlerrm,v_pos_error_var),6); 
                   v_variable_mensaje:=substr(v_variable_mensaje,1,length(v_variable_mensaje)-1);
                else
                   v_variable_mensaje:='*indeterminada*';
                end if;
                return 'ERROR: Compilación de variable con error. Variable: '|| v_variable_mensaje||'. Error '|| sqlstate || ': ' || sqlerrm||' SENTENCIA: '||v_sentencia
                          || 'Detalle:'||error_mensaje_detalle 
                          || 'Ayuda:'||error_mensaje_ayuda
                          || 'linea err:'||error_mensaje_linea
                          || 'cod err:'||error_codigo;
          END; 
        if(p_cual<>'#todo')then 
          v_sentencia_borrar:= ' DROP TRIGGER '||v_nombre_funcion||' ON '||v_plana_trigger||';';
          EXECUTE v_sentencia_borrar;
          v_sentencia_borrar:= ' DROP FUNCTION encu.'||v_nombre_funcion||'();';
          EXECUTE v_sentencia_borrar;
        end if;            
    END IF;
  END LOOP;
  RETURN 'procesadas '||v_revisadas||' variables.';
END;
$_$;


ALTER FUNCTION encu.generar_trigger_variables_calculadas(p_cual text) OWNER TO tedede_php;

--
-- Name: his_inconsistencias_trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION his_inconsistencias_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO his.his_inconsistencias(
            hisinc_ope, hisinc_con, hisinc_enc, hisinc_hog, hisinc_mie, hisinc_exm,             hisinc_variables_y_valores, 
            hisinc_justificacion, hisinc_autor_justificacion, hisinc_tlg)
    VALUES (old.inc_ope, old.inc_con, old.inc_enc, old.inc_hog, old.inc_mie, old.inc_exm,     old.inc_variables_y_valores, 
            old.inc_justificacion, old.inc_autor_justificacion, old.inc_tlg);

    return old;
END
$$;


ALTER FUNCTION encu.his_inconsistencias_trg() OWNER TO tedede_php;

--
-- Name: his_inconsistencias_upd_trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION his_inconsistencias_upd_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_ultima_justificacion text;
  v_ultima_variables_y_valores text;
BEGIN
    if new.inc_justificacion is null then
        SELECT hisinc_justificacion,hisinc_variables_y_valores
            INTO v_ultima_justificacion, v_ultima_variables_y_valores
            FROM his.his_inconsistencias
            WHERE hisinc_ope=new.inc_ope
                AND hisinc_con=new.inc_con                AND hisinc_enc=new.inc_enc                AND hisinc_hog=new.inc_hog                AND hisinc_mie=new.inc_mie                AND hisinc_exm=new.inc_exm            ORDER BY hisinc_tlg DESC LIMIT 1;
        if v_ultima_variables_y_valores=new.inc_variables_y_valores then
            new.inc_justificacion:=v_ultima_justificacion;
        end if;
    end if;
    return new;
END
$$;


ALTER FUNCTION encu.his_inconsistencias_upd_trg() OWNER TO tedede_php;

--
-- Name: insert_consistencia_flujo(character varying, text, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION insert_consistencia_flujo(pcon_ope character varying, pcon_con text, pcon_precondicion character varying, pcon_rel character varying, pcon_postcondicion character varying, pcon_explicacion character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    xcon_activa             encu.consistencias.con_activa%type;
    xcon_tipo               encu.consistencias.con_tipo%type;
    xcon_falsos_positivos   encu.consistencias.con_falsos_positivos%type;  
    xcon_importancia        encu.consistencias.con_importancia%type;
    xcon_momento            encu.consistencias.con_momento%type;
    xcon_grupo              encu.consistencias.con_grupo%type;
    xcon_gravedad           encu.consistencias.con_gravedad%type;
BEGIN
   --xcon_expl_ok= false;
    --xcon_estado
   xcon_activa=true;   
   xcon_tipo='Auditoría';   
   xcon_falsos_positivos=false;
   xcon_importancia='ALTA';
   xcon_momento='Recepción';
   xcon_grupo='flujo'; 
   xcon_gravedad='Error';
    --con_descripcion
    --con_modulo
    --con_valida
    --con_junta
    --con_clausula_from
    --con_expresion_sql
    --con_error_compilacion
    --con_ultima_variable
    --con_orden
  INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel, con_postcondicion,
            con_activa, con_explicacion, con_tipo, con_falsos_positivos,
            con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
   values( pcon_ope, pcon_con, pcon_precondicion, pcon_rel, pcon_postcondicion,
           xcon_activa, pcon_explicacion, xcon_tipo, xcon_falsos_positivos,
           xcon_importancia, xcon_momento, xcon_grupo, xcon_gravedad, 1) ;                        

END;
$$;


ALTER FUNCTION encu.insert_consistencia_flujo(pcon_ope character varying, pcon_con text, pcon_precondicion character varying, pcon_rel character varying, pcon_postcondicion character varying, pcon_explicacion character varying) OWNER TO tedede_php;

--
-- Name: nombre_largo_para_documentacion(text, text); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION nombre_largo_para_documentacion(p_var text, p_baspro text) RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
   v_nombre_largo_para_documentacion text;
BEGIN
select trim(coalesce(var_nombre_dr,
                    varcal_nombre_dr,
                    nullif(
                      coalesce(pre_texto,'')||' '||coalesce(var_texto,''),
                      ' '
                    ),
                    varcal_nombre,
                    basprovar_var
                    )
                    ) into v_nombre_largo_para_documentacion 
              FROM encu.baspro_var b 
                LEFT JOIN encu.variables v ON b.basprovar_ope = v.var_ope AND b.basprovar_var = v.var_var
                LEFT JOIN encu.varcal c ON b.basprovar_ope = c.varcal_ope AND b.basprovar_var = c.varcal_varcal
                LEFT JOIN encu.preguntas p ON v.var_ope = p.pre_ope AND v.var_pre = p.pre_pre 
where basprovar_var = p_var and basprovar_baspro = p_baspro and basprovar_ope = dbo.ope_actual();
RETURN v_nombre_largo_para_documentacion;
END;
$$;


ALTER FUNCTION encu.nombre_largo_para_documentacion(p_var text, p_baspro text) OWNER TO tedede_php;

--
-- Name: pase_a_procesamiento_trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION pase_a_procesamiento_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  IF new.pla_estado>=70 AND old.pla_estado<70 THEN
    INSERT INTO his.plana_a1_  SELECT current_timestamp, * FROM encu.plana_a1_  WHERE pla_enc=new.pla_enc;
    INSERT INTO his.plana_a1_x SELECT current_timestamp, * FROM encu.plana_a1_x WHERE pla_enc=new.pla_enc;
    INSERT INTO his.plana_i1_  SELECT current_timestamp, * FROM encu.plana_i1_  WHERE pla_enc=new.pla_enc;
    INSERT INTO his.plana_s1_  SELECT current_timestamp, * FROM encu.plana_s1_  WHERE pla_enc=new.pla_enc;
    INSERT INTO his.plana_s1_p SELECT current_timestamp, * FROM encu.plana_s1_p  WHERE pla_enc=new.pla_enc;
  END IF;
  RETURN new;
END
$$;


ALTER FUNCTION encu.pase_a_procesamiento_trg() OWNER TO tedede_php;

--
-- Name: permitir_modificacion_tabulados_trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION permitir_modificacion_tabulados_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_usuario   text;
    v_rol       text;
    v_cant_abiertas integer;
    v_var_abiertas  TEXT;
BEGIN
    SELECT ses_usu, usu_rol  
        INTO v_usuario, v_rol
        FROM encu.tiempo_logico JOIN encu.sesiones ON tlg_ses=ses_ses JOIN encu.usuarios ON usu_usu=ses_usu
        WHERE tlg_tlg=new.tab_tlg;
    IF OLD.tab_cerrado IS DISTINCT FROM NEW.tab_cerrado THEN
        IF NEW.tab_cerrado=TRUE THEN
            --esta cerrando
            -- tiene que ser de procesamiento o programador
            -- condicion de cierre: variables calculadas cerradas
            IF coalesce(v_rol,'') not in ('programador', 'procesamiento') THEN
                RAISE EXCEPTION 'ERROR Perfil del usuario % no autorizado para realizar el cierre del tabulado "%" ',v_usuario, new.tab_tab ;
            END IF;
            SELECT string_agg(varcal_varcal, ','), count(*)
                INTO v_var_abiertas, v_cant_abiertas
                FROM encu.varcal, comun.extraer_identificadores( coalesce(new.tab_fila1,'') ||' '||coalesce(new.tab_fila2,'')||' '||coalesce(new.tab_columna,'')||' '||coalesce(new.tab_filtro,'')) 
                where varcal_ope=dbo.ope_actual() and varcal_varcal= extraer_identificadores and varcal_cerrado='N';
            if v_cant_abiertas>0 then
                RAISE EXCEPTION 'ERROR hay % variable/s dependiente/s no cerrada/s:%', v_cant_abiertas, v_var_abiertas;
            end if;
        ELSE
            --reabre un programador
            IF v_rol is distinct from 'programador' THEN
                RAISE EXCEPTION 'ERROR Perfil del usuario % no autorizado para realizar la apertura del tabulado  "%" ',v_usuario, new.tab_tab;
            END IF;
        END IF;
    ELSE
        IF new.tab_cerrado THEN    
            RAISE EXCEPTION 'ERROR no se puede modificar, tabulado "%" esta cerrada', new.tab_tab;
        END IF;         
    END IF;
    RETURN NEW; 
END;
$$;


ALTER FUNCTION encu.permitir_modificacion_tabulados_trg() OWNER TO tedede_php;

--
-- Name: permitir_modificacion_variables_calculadas_trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION permitir_modificacion_variables_calculadas_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_usuario   text;
    v_rol       text;
    v_esta_cerrado boolean;
    v_varcal    text;
    v_texto_op  text;
    v_cant_abiertas integer;
    v_var_abiertas  TEXT;
    v_opciones  text;
BEGIN
CASE TG_TABLE_NAME
    WHEN 'varcal' THEN
        SELECT ses_usu, usu_rol  
            INTO v_usuario, v_rol
            FROM encu.tiempo_logico JOIN encu.sesiones ON tlg_ses=ses_ses JOIN encu.usuarios ON usu_usu=ses_usu
            WHERE tlg_tlg=new.varcal_tlg;
        IF OLD.varcal_cerrado IS DISTINCT FROM NEW.varcal_cerrado THEN
            IF NEW.varcal_cerrado=true THEN
                --esta cerrando
                -- tiene que ser de procesamiento o programador
                -- condicion de cerrado: esten cerradas las varibles calculadas que usa
                IF coalesce(v_rol,'') not in ('programador', 'procesamiento') THEN
                    RAISE EXCEPTION 'ERROR Perfil del usuario % no autorizado para realizar el cierre de la variable "%" ',v_usuario, new.varcal_varcal;
                END IF;
                select string_agg( coalesce(varcalopc_expresion_condicion,'') ||' '|| coalesce(varcalopc_expresion_valor,''), ', ' order by varcalopc_ope, varcalopc_varcal, varcalopc_opcion) 
                    into v_opciones
                    from encu.varcalopc
                    where varcalopc_ope = dbo.ope_actual() and varcalopc_varcal = new.varcal_varcal;  
                SELECT string_agg(varcal_varcal, ','), count(*)
                    INTO v_var_abiertas, v_cant_abiertas
                    FROM encu.varcal,  comun.extraer_identificadores(v_opciones) 
                    where varcal_ope=dbo.ope_actual() and varcal_varcal= extraer_identificadores and varcal_cerrado='N';
                if v_cant_abiertas>0 then
                    RAISE EXCEPTION 'ERROR hay % variable/s calculadas dependiente/s no cerrada/s:%', v_cant_abiertas, v_var_abiertas;
                end if;
            ELSE 
                --reabre un programador
                IF v_rol is distinct from 'programador' THEN
                   RAISE EXCEPTION 'ERROR Perfil del usuario % no autorizado para realizar la apertura de la variable  "%" ',v_usuario, new.varcal_varcal;
                END IF;
            END IF;
        ELSE
            IF new.varcal_cerrado THEN
                RAISE EXCEPTION 'ERROR no se puede modificar, variable calculada "%" esta cerrada',  new.varcal_varcal;
            END IF;         
        END IF;
        RETURN NEW;
    WHEN 'varcalopc' THEN
        CASE TG_OP
            WHEN 'INSERT' THEN
                v_varcal=NEW.varcalopc_varcal;
                v_texto_op= 'agregar opcion';
            WHEN 'UPDATE' THEN
                v_varcal=NEW.varcalopc_varcal;
                v_texto_op= 'modificar opcion';
            ELSE
                v_varcal=OLD.varcalopc_varcal;
                v_texto_op= 'borrar opcion';
        END CASE;        
        SELECT varcal_cerrado 
            INTO v_esta_cerrado 
            FROM encu.varcal
            WHERE varcal_ope=new.varcalopc_ope AND varcal_varcal=v_varcal;
        IF v_esta_cerrado THEN    
            RAISE EXCEPTION 'ERROR no se puede %, variable calculada "%" esta cerrada', v_texto_op, new.varcalopc_varcal;
        END IF; 
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'ERROR Tabla "%" no considerada en "permitir_modificacion_variables_calculadas_trg"',TG_TABLE_NAME;
END CASE;    
END;
$$;


ALTER FUNCTION encu.permitir_modificacion_variables_calculadas_trg() OWNER TO tedede_php;

--
-- Name: plana_tem_control_editar_variables_trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION plana_tem_control_editar_variables_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN
  if new.pla_cnombre <> old.pla_cnombre OR new.pla_hn <> old.pla_hn then
    if new.pla_dominio <> 5 then
       raise 'NO PUEDE MODIFICAR LA DIRECCION Y/O NRO. DOMINIO % ', new.pla_dominio;
    end if;
  end if;
  RETURN new;
END
$$;


ALTER FUNCTION encu.plana_tem_control_editar_variables_trg() OWNER TO tedede_php;

--
-- Name: recalcular_mie_bu_i1_trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION recalcular_mie_bu_i1_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
    if TG_OP='UPDATE' then
       if new.pla_enc is distinct from old.pla_enc then
          perform dbo.recalcular_mie_bu(old.pla_enc);
          perform dbo.recalcular_mie_bu(new.pla_enc);
       elsif new.pla_hog is distinct from old.pla_hog or new.pla_mie is distinct from old.pla_mie then
          perform dbo.recalcular_mie_bu(new.pla_enc);
       end if;
       RETURN new;
    elsif TG_OP='INSERT' then
          perform dbo.recalcular_mie_bu(new.pla_enc);
          RETURN new;
    elsif TG_OP='DELETE' then
          perform dbo.recalcular_mie_bu(old.pla_enc);
          RETURN old;
    end if;
    END
  $$;


ALTER FUNCTION encu.recalcular_mie_bu_i1_trg() OWNER TO tedede_php;

--
-- Name: recalcular_mie_bu_s1_p_trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION recalcular_mie_bu_s1_p_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
    if TG_OP='UPDATE' then
       if new.pla_enc is distinct from old.pla_enc then
          perform dbo.recalcular_mie_bu(old.pla_enc);
          perform dbo.recalcular_mie_bu(new.pla_enc);
       elsif new.pla_hog is distinct from old.pla_hog or new.pla_mie is distinct from old.pla_mie or new.pla_p4 is distinct from old.pla_p4 then
          perform dbo.recalcular_mie_bu(new.pla_enc);
       end if;
       RETURN new;
    elsif TG_OP='INSERT' then
          perform dbo.recalcular_mie_bu(new.pla_enc);
          RETURN new;
    elsif TG_OP='DELETE' then
          perform dbo.recalcular_mie_bu(old.pla_enc);
          RETURN old;
    end if;
    END
  $$;


ALTER FUNCTION encu.recalcular_mie_bu_s1_p_trg() OWNER TO tedede_php;

--
-- Name: reconocer_agregadores(text); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION reconocer_agregadores(p_cual text, OUT p_funcion text, OUT p_expresion text, OUT p_filtro text) RETURNS record
    LANGUAGE sql IMMUTABLE
    AS $$
  SELECT trim(v_obtenido[1]), trim(v_obtenido[2]), trim(v_obtenido[4]) from regexp_matches(p_cual,'@\(([^@]*)@([^@]*)(@([^@]*))?\)@') as v_obtenido;
/*
  SELECT entrada, funcion, expresion, filtro, encu.reconocer_agregadores(entrada)
    FROM (SELECT 't55>@(sumap@ i3_x + i3_t @ edad>14)@' as entrada, 'sumap' as funcion, 'i3_x + i3_t' as expresion, 'edad>14' as filtro
         UNION SELECT 't55>@( sumap @X25)@ + 44' as entrada, 'sumap' as funcion, 'X25' as expresion, null as filtro
         UNION SELECT 't55 + 1 ' as entrada, 'sumap' as funcion, 'X25' as expresion, null as filtro
         UNION SELECT '@( sumap @ sarasa sasa )@' as entrada, 'sumap' as funcion, 'sarasa sasa' as expresion, null as filtro) x
    WHERE (funcion, expresion, filtro) is distinct from encu.reconocer_agregadores(entrada);
--*/
$$;


ALTER FUNCTION encu.reconocer_agregadores(p_cual text, OUT p_funcion text, OUT p_expresion text, OUT p_filtro text) OWNER TO tedede_php;

--
-- Name: reemplazar_agregadores(text); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION reemplazar_agregadores(p_cual text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
  v_cursor RECORD;
  v_obtenido TEXT:=p_cual;
  v_max_num integer;
  v_fun_abreviado text;
  v_fun_codigo text;
  v_funcion text;
  v_expresion text;
  v_filtro text;
BEGIN
  --RAISE NOTICE 'ENTRO CON %',p_cual;
  FOR v_cursor IN
    SELECT x[1] as encontrado, fun_fun, fun_abreviado
      FROM regexp_matches(p_cual,'@\(.*?\)@','g') x 
         LEFT JOIN dbx.funciones_automaticas ON x[1]=fun_fun
  LOOP
    --RAISE NOTICE 'ENCUENTRO % / % / %',v_cursor.encontrado,v_cursor.fun_fun,v_cursor.fun_abreviado;
    if v_cursor.fun_fun is null then
      if length(v_cursor.encontrado)>56 then
        RAISE NOTICE 'LARGO %',length(v_cursor.encontrado);
        select max(substr(fun_fun,57,4)::integer)
          into v_max_num
          from dbx.funciones_automaticas
          where substr(fun_fun,1,56)=substr(p_cual,1,56);
        v_fun_abreviado:=substr(v_cursor.encontrado,1,56)||'_'||trim(to_char(coalesce(v_max_num,1),'0000'))||')@';
      else
        v_fun_abreviado:=v_cursor.encontrado;
      end if;
      SELECT * FROM encu.reconocer_agregadores(v_cursor.encontrado) INTO v_funcion, v_expresion, v_filtro;
      RAISE NOTICE 'RECONOCER: % / % / % / %',v_fun_abreviado,v_funcion, v_expresion, v_filtro;
      IF v_funcion<>'sumap' and v_funcion<>'contarc' THEN 
        RAISE 'No se reconoce la funcion agregada %',v_funcion;
      END IF;
      v_expresion:=reemplazar_variables(v_expresion,'pla_\1');
      v_filtro:=reemplazar_variables(v_filtro,'pla_\1');
      if v_funcion='sumap' then
        v_fun_codigo:=$$
            CREATE OR REPLACE FUNCTION dbx.$$||quote_ident(v_fun_abreviado)||$$(p_enc integer, p_hog integer) RETURNS BIGINT 
            LANGUAGE SQL AS
            $SQL$ SELECT SUM(CASE WHEN $$||v_expresion||$$>0 THEN $$||v_expresion||$$ ELSE NULL END) 
                    FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                        INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                        INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                        INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                    WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                        $$||coalesce(v_filtro,'TRUE')||$$ 
                        /* $$||v_cursor.encontrado||$$  */
                    $SQL$;
        $$;
      else 
        if v_funcion='contarc' then
            v_fun_codigo:=$$
                CREATE OR REPLACE FUNCTION dbx.$$||quote_ident(v_fun_abreviado)||$$(p_enc integer, p_hog integer) RETURNS BIGINT 
                LANGUAGE SQL AS
                $SQL$ SELECT COUNT($$||v_expresion||$$) 
                        FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                            INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                            INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                            INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                        WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                            $$||coalesce(v_filtro,'TRUE')||$$ 
                            /* $$||v_cursor.encontrado||$$  */
                        $SQL$;
            $$;
        end if;
      end if;
      EXECUTE v_fun_codigo;
      INSERT INTO dbx.funciones_automaticas (fun_fun, fun_abreviado, fun_codigo)
        VALUES (v_cursor.encontrado, v_fun_abreviado, v_fun_codigo);
    else
      v_fun_abreviado:=v_cursor.fun_abreviado;
    end if;
    -- v_obtenido:=replace(v_obtenido,v_cursor.encontrado, quote_ident(v_fun_abreviado)||'(enc,hog)');
    v_obtenido:=replace(v_obtenido,v_cursor.encontrado, 'dbx.'||quote_ident(v_fun_abreviado)||'(enc,hog)');
  END LOOP;
  return v_obtenido;
END;
$_$;


ALTER FUNCTION encu.reemplazar_agregadores(p_cual text) OWNER TO tedede_php;

--
-- Name: respuestas_a_planas_trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION respuestas_a_planas_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
  v_mal boolean:=false;
  v_sentencia text;
  v_sentencia_null text;
  v_valor text;
  v_valor_tsp timestamp without time zone;  
BEGIN
if new.res_ope = 'etoi152' then
  v_sentencia:='UPDATE encu.plana_'||new.res_for||'_'||new.res_mat||' SET "pla_'||new.res_var||'"=$1, pla_tlg=$2 WHERE pla_enc=$3 and pla_hog=$4 and pla_mie=$5 and pla_exm=$6 and  true';
  v_sentencia_null:='UPDATE encu.plana_'||new.res_for||'_'||new.res_mat||' SET "pla_'||new.res_var||'"=null, pla_tlg=$1 WHERE pla_enc=$2 and pla_hog=$3 and pla_mie=$4 and pla_exm=$5 and  true';
  v_valor:=case new.res_valesp when '//' then '-9' when '--' then '-1' else new.res_valor end;
  BEGIN
    if v_valor is null then
      EXECUTE v_sentencia_null USING new.res_tlg , new.res_enc, new.res_hog, new.res_mie, new.res_exm;
    elseif comun.es_fecha(v_valor) and new.res_for = 'TEM' then
      v_valor_tsp:=comun.valor_fecha(v_valor);
     EXECUTE v_sentencia USING v_valor_tsp, new.res_tlg , new.res_enc, new.res_hog, new.res_mie, new.res_exm;
    elseif comun.es_numero(v_valor) then
      EXECUTE v_sentencia USING v_valor::bigint, new.res_tlg , new.res_enc, new.res_hog, new.res_mie, new.res_exm;
    else
      EXECUTE v_sentencia USING v_valor, new.res_tlg , new.res_enc, new.res_hog, new.res_mie, new.res_exm;
    end if;
  EXCEPTION 
    WHEN OTHERS THEN
      EXECUTE v_sentencia USING  -5, new.res_tlg , new.res_enc, new.res_hog, new.res_mie, new.res_exm;
      new.res_valor_con_error:=new.res_valor;
      new.res_valor:=null;
  END;
  -- Comentar este insert al hacer una instalación:
  insert into his.his_respuestas (hisres_ope, hisres_for, hisres_mat, hisres_enc, hisres_hog, hisres_mie, hisres_exm, hisres_var, hisres_valor, hisres_valesp, hisres_valor_con_error, hisres_estado, hisres_anotaciones_marginales, hisres_tlg)
    values (new.res_ope, new.res_for, new.res_mat, new.res_enc, new.res_hog, new.res_mie, new.res_exm, new.res_var, new.res_valor, new.res_valesp, new.res_valor_con_error, new.res_estado, new.res_anotaciones_marginales, new.res_tlg);

  -- */
end if;
  RETURN new;
END
$_$;


ALTER FUNCTION encu.respuestas_a_planas_trg() OWNER TO tedede_php;

--
-- Name: respuestas_control_editable_trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION respuestas_control_editable_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_estado integer;
  v_editable text:='nunca';
  v_edtem text:='nunca';
  v_fecha_comenzo_descarga timestamp without time zone;
  --v_rol character varying(30);
  v_permitido boolean;
  v_permitidotem boolean;
  v_rea integer;
  v_norea integer;
BEGIN
select pla_estado, pla_fecha_comenzo_descarga, pla_rea, pla_norea
	into   v_estado,   v_fecha_comenzo_descarga,   v_rea,   v_norea
	from encu.plana_tem_ 
	where pla_enc = new.res_enc;
select est_editar_encuesta, est_editar_TEM into v_editable, v_edtem from encu.estados where est_est = v_estado and est_ope = dbo.ope_actual();

	if (new.res_for<>'TEM' and new.res_for<>'SUP' and v_editable = 'nunca') or (new.res_for<>'TEM' and new.res_for<>'SUP' and v_edtem = 'nunca') then
		raise 'ENCUESTA % NO HABILITADA PARA PROC 1,%,%. ESTADO %', new.res_enc, v_rea, v_norea, v_estado;
	end if;  

	if new.res_for<>'TEM' and v_editable = 'probando' and current_timestamp<='2014-09-22' then
		return new;
	end if;
  
	if new.res_for<>'TEM' and v_editable = 'descargando' then
		if v_fecha_comenzo_descarga is  null then 
			raise 'ENCUESTA % NO HABILITADA PARA PROC 2. ESTADO %', new.res_enc, v_estado;
		else 
			if now()-v_fecha_comenzo_descarga > '10 MINUTES'::INTERVAL then
				raise 'ENCUESTA % NO HABILITADA PARA PROC 3. ESTADO %', new.res_enc, v_estado;
			end if;
		end if;
	end if;
	if new.res_for='TEM' and v_edtem = 'descargando'  then 
		if new.res_var='a_ingreso_enc' or  new.res_var='a_ingreso_recu' then  
			raise 'ENCUESTA % NO HABILITADA PARA PROC 6. ESTADO %', new.res_enc, v_estado;
		end if;  
	end if;
	if new.res_for<>'TEM' and new.res_for<>'SUP' and v_editable <> 'siempre' and v_editable <> 'descargando' then
		select case when r.rolrol_delegado is not null or u.usu_rol = v_editable then true else false end into v_permitido 
		from encu.tiempo_logico l 
		inner join encu.sesiones s on l.tlg_ses = s.ses_ses
		inner join encu.usuarios u on s.ses_usu = u.usu_usu
		left join encu.rol_rol r on u.usu_rol = r.rolrol_principal and r.rolrol_delegado = v_editable   
		where l.tlg_tlg = new.res_tlg;
		if not v_permitido then
			raise 'ENCUESTA % NO HABILITADA PARA PROC 4. ESTADO %', new.res_enc, v_estado;
		end if;    
	end if;    
  
	if new.res_for = 'TEM' and v_edtem <> 'siempre' and v_edtem <> 'descargando' then
		select case when r.rolrol_delegado is not null or u.usu_rol = v_edtem then true else false end into v_permitidotem 
		from encu.tiempo_logico l 
		inner join encu.sesiones s on l.tlg_ses = s.ses_ses
		inner join encu.usuarios u on s.ses_usu = u.usu_usu
		left join encu.rol_rol r on u.usu_rol = r.rolrol_principal and r.rolrol_delegado = v_edtem   
		where l.tlg_tlg = new.res_tlg;
		if not v_permitidotem then
			raise 'ENCUESTA % NO HABILITADA PARA PROC 5. ESTADO %', new.res_enc, v_estado;
		end if;    
	end if;

RETURN new;
END
$$;


ALTER FUNCTION encu.respuestas_control_editable_trg() OWNER TO tedede_php;

--
-- Name: respuestas_control_justificaciones_trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION respuestas_control_justificaciones_trg() RETURNS trigger
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
  v_nojustificadas integer;
  v_select text;
  v_from text;
  v_where text;
  v_rol text;
  v_valor text;
  v_norea text;
  v_estado integer;
BEGIN
  if (new.res_var like 'verificado%' or new.res_var='fin_anacon') and new.res_valor = '1' then
     v_nojustificadas := 0;
     SELECT COUNT(*) into v_nojustificadas 
       FROM encu.inconsistencias
       WHERE inc_ope= new.res_ope and inc_enc= new.res_enc and (inc_justificacion is null or trim(inc_justificacion)='')
             and inc_con <> 'opc_inconsistente' 
             and inc_nivel<50;
     if v_nojustificadas> 0 then
         raise 'NO SE PUEDE VERIFICAR LA ENCUESTA % TIENE % INCONSISTENCIAS SIN JUSTIFICAR',new.res_enc, v_nojustificadas;
     end if;
  end if;
  if ((new.res_var like 'verificado%' and new.res_var not like '%_ac') or new.res_var='fin_anacon') and (new.res_valor = '1' or new.res_valor = '4') then
     v_valor = null;
     v_select = $$
        SELECT res_valor
     $$;
     v_from := $$
        FROM encu.respuestas
     $$;
     v_where := $$
        WHERE res_ope = $1 AND res_for = $2 AND res_mat = $3 AND res_enc = $4 and res_hog = $5 AND 
              res_mie = $6 AND res_exm = $7 AND res_var = 'cod_'||split_part($8, '_', 2);        
        --PK DE encu.respuestas $1, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, res_var
     $$;
     EXECUTE v_select||v_from||v_where INTO v_valor USING new.res_ope, new.res_for, new.res_mat, new.res_enc, new.res_hog, new.res_mie, new.res_exm, new.res_var;
     IF v_valor IS NULL THEN
         v_rol := case when new.res_var like '%_enc'    then 'ENCUESTADOR'
                       when new.res_var like '%_sup'    then 'SUPERVISOR'
                       when new.res_var like '%_recu'   then 'RECUPERADOR'
                       when new.res_var like '%_anacon' then 'ANACON'
                  end;          
         raise 'NO SE PUEDE VERIFICAR LA ENCUESTA % PORQUE NO SE HA ESPECIFICADO EL CODIGO DE %',new.res_enc, v_rol;
     END IF;
  end if;
  if new.res_var like 'verificado%' and new.res_valor = '1' then
     SELECT res_valor INTO v_norea
     FROM encu.respuestas
     WHERE res_ope = new.res_ope AND res_for = new.res_for AND res_mat = new.res_mat AND res_enc = new.res_enc and res_hog = new.res_hog AND 
           res_mie = new.res_mie AND res_exm = new.res_exm AND res_var = 'norea';
     if v_norea = '18' then
       raise 'NOREA=18 solo permite verificado=4';
     end if;     
  end if;
  if new.res_var like 'verificado%' and new.res_valor = '1' then
     SELECT pla_estado into v_estado
     FROM encu.plana_tem_ 
     WHERE pla_enc = new.res_enc and pla_hog = new.res_hog and pla_mie = new.res_mie and pla_exm = new.res_exm;
     IF v_estado = 23 or v_estado = 24 or v_estado = 33 or v_estado = 34 then
         raise 'NO SE PUEDE VERIFICAR LA ENCUESTA % PORQUE SE ENCUENTRA EN ESTADO %',new.res_enc, v_estado;
     END IF;
  end if;
  RETURN new;
END
$_$;


ALTER FUNCTION encu.respuestas_control_justificaciones_trg() OWNER TO tedede_php;

--
-- Name: respuestas_control_pk_trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION respuestas_control_pk_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_mal boolean:=false;
BEGIN
  if new.res_for='AJH1' and new.res_mat='' then
    if new.res_hog is not distinct from 0 or new.res_mie is distinct from 0 then
      v_mal:=true;
    end if;
  elsif new.res_for='AJI1' and new.res_mat='' then
    if new.res_hog is not distinct from 0 or new.res_mie is distinct from 0 then
      v_mal:=true;
    end if;
  elsif new.res_for='TEM' and new.res_mat='' then
    if new.res_hog is distinct from 0 or new.res_mie is distinct from 0 then
      v_mal:=true;
    end if;
  elsif new.res_for='AJH1' and new.res_mat='M' then
    if new.res_hog is not distinct from 0 or new.res_mie is not distinct from 0 then
      v_mal:=true;
    end if;
  end if;
  if v_mal then
    raise 'Violacion de pk en %,%,% para %,%', new.res_enc, new.res_hog, new.res_mie, new.res_exm, new.res_for,new.res_mat;
  end if;
  RETURN new;
END
$$;


ALTER FUNCTION encu.respuestas_control_pk_trg() OWNER TO tedede_php;

--
-- Name: respuestas_sinc_tem_trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION respuestas_sinc_tem_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  rvar  RECORD;
  p_ope text;
  p_enc integer;
    p_rea integer; 
    p_norea integer;
    p_rea_enc integer; 
    p_norea_enc integer; 
    p_con_dato_enc integer; 
    p_rea_recu integer; 
    p_norea_recu integer; 
    p_con_dato_recu integer;
    p_pob_tot integer; 
    p_pob_pre integer;
    p_hog_tot integer; 
    p_hog_pre integer;  
BEGIN
  IF new.res_for<>'TEM' and (
      new.res_valor is distinct from old.res_valor or 
      new.res_valesp is distinct from old.res_valesp or 
      new.res_valor_con_error is distinct from old.res_valor_con_error or 
      new.res_var in ('obs', 's1a1_obs')
  ) THEN
    p_ope:=new.res_ope;
    p_enc=new.res_enc;
    select pla_rea   ,
           pla_norea ,   
           pla_rea_enc      ,
           pla_norea_enc    ,
           pla_con_dato_enc ,
           pla_rea_recu     ,
           pla_norea_recu   ,
           pla_con_dato_recu,
           pla_pob_tot      ,
           pla_pob_pre      ,
           pla_hog_tot      ,
           pla_hog_pre    
        into p_rea   ,
                p_norea ,   
                p_rea_enc      ,
                p_norea_enc    ,
                p_con_dato_enc ,
                p_rea_recu     ,
                p_norea_recu   ,
                p_con_dato_recu,
                p_pob_tot      ,
                p_pob_pre      ,
                p_hog_tot      ,
                p_hog_pre
        from encu.plana_tem_
        where pla_enc= p_enc;
    rvar:= encu.sincronizacion_tem_datos(p_ope, p_enc
                                ,p_rea     
                                ,p_norea
                                ,p_rea_enc      
                                ,p_norea_enc    
                                ,p_con_dato_enc 
                                ,p_rea_recu     
                                ,p_norea_recu   
                                ,p_con_dato_recu
                                ,p_pob_tot      
                                ,p_pob_pre      
                                ,p_hog_tot      
                                ,p_hog_pre      
        ); 
    update encu.respuestas 
      set res_valor=rvar.p_rea
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='rea'
        and res_valor is distinct from rvar.p_rea::text;
    update encu.respuestas 
      set res_valor=rvar.p_norea
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='norea'
        and res_valor is distinct from rvar.p_norea::text;
    update encu.respuestas 
      set res_valor=rvar.p_rea_enc
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='rea_enc'
        and res_valor is distinct from rvar.p_rea_enc::text;
    update encu.respuestas 
      set res_valor=rvar.p_norea_enc
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='norea_enc'
        and res_valor is distinct from rvar.p_norea_enc::text;
    update encu.respuestas 
      set res_valor=rvar.p_con_dato_enc
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='con_dato_enc'
        and res_valor is distinct from rvar.p_con_dato_enc::text;
    update encu.respuestas 
      set res_valor=rvar.p_rea_recu
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='rea_recu'
        and res_valor is distinct from rvar.p_rea_recu::text;
    update encu.respuestas 
      set res_valor=rvar.p_norea_recu
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='norea_recu'
        and res_valor is distinct from rvar.p_norea_recu::text;
    update encu.respuestas 
      set res_valor=rvar.p_con_dato_recu
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='con_dato_recu'
        and res_valor is distinct from rvar.p_con_dato_recu::text;
    update encu.respuestas 
      set res_valor=rvar.p_pob_tot
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='pob_tot'
        and res_valor is distinct from rvar.p_pob_tot::text;
    update encu.respuestas 
      set res_valor=rvar.p_pob_pre
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='pob_pre'
        and res_valor is distinct from rvar.p_pob_pre::text;
    update encu.respuestas 
      set res_valor=rvar.p_hog_tot
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='hog_tot'
        and res_valor is distinct from rvar.p_hog_tot::text;
    update encu.respuestas 
      set res_valor=rvar.p_hog_pre
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='hog_pre'
        and res_valor is distinct from rvar.p_hog_pre::text;
  END IF;
RETURN new;
END;
$$;


ALTER FUNCTION encu.respuestas_sinc_tem_trg() OWNER TO tedede_php;

--
-- Name: sincronizacion_tem_datos(text, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION sincronizacion_tem_datos(p_ope text, p_enc integer, INOUT p_rea integer, INOUT p_norea integer, INOUT p_rea_enc integer, INOUT p_norea_enc integer, INOUT p_con_dato_enc integer, INOUT p_rea_recu integer, INOUT p_norea_recu integer, INOUT p_con_dato_recu integer, INOUT p_pob_tot integer, INOUT p_pob_pre integer, INOUT p_hog_tot integer, INOUT p_hog_pre integer) RETURNS record
    LANGUAGE plpgsql
    AS $_$
DECLARE
    v_max_entrea    integer;
    v_min_entrea    integer;
    v_cod_recu      integer;
    v_norea         integer;
    v_rol           text;
    v_con_dato      integer;
    v_for_hogar     text;
    v_sentencia     text;
    v_where         text;
    v_n_entrea4     integer;    
BEGIN
    p_rea:=null;
    p_norea:=null;
    SELECT pla_cod_recu,pla_rol
        INTO v_cod_recu, v_rol
        FROM plana_tem_ t 
        WHERE pla_enc=p_enc;
    --PARA GENERALIZAR FORMULARIO DE LA PLANA_xx_
    select for_for into v_for_hogar from formularios where for_es_principal and for_ope=p_ope; 
    v_sentencia:= $$
        SELECT max(pla_total_h) as hog_tot, count(case when pla_entrea=1 then 1 else null end) as hog_pre,
               max(coalesce(pla_entrea,-1)) as max_entrea, min(coalesce(pla_entrea,-1)) as min_entrea,
               count(case when pla_entrea=4 then 1 else null end) as cant_entrea4                
    $$; 
    v_where:= $$
        WHERE pla_enc=$1
    $$;
    EXECUTE v_sentencia || ' FROM plana_' || v_for_hogar || '_ ' || v_where  INTO p_hog_tot, p_hog_pre, v_max_entrea, v_min_entrea, v_n_entrea4 using  p_enc;   
    v_sentencia:= $$
        SELECT nullif(
                (coalesce(pla_razon1,0)::text || 
                coalesce(case s1.pla_razon1 
                when 1 then case when s1.pla_razon2_1 > 0 then s1.pla_razon2_1 else '0' end::text 
                when 2 then case when s1.pla_razon2_2 > 0 then s1.pla_razon2_2 else '0' end::text 
                when 3 then case when s1.pla_razon2_3 > 0 then s1.pla_razon2_3 else '0' end::text 
                when 4 then case when s1.pla_razon2_4 > 0 then s1.pla_razon2_4 else '0' end::text 
                when 5 then case when s1.pla_razon2_5 > 0 then s1.pla_razon2_5 else '0' end::text 
                when 6 then case when s1.pla_razon2_6 > 0 then s1.pla_razon2_6 else '0' end::text
                when 7 then case when s1.pla_razon2_7 > 0 then s1.pla_razon2_7 else '0' end::text 
                when 8 then case when s1.pla_razon2_8 > 0 then s1.pla_razon2_8 else '0' end::text 
                when 9 then case when s1.pla_razon2_9 > 0 then s1.pla_razon2_9 else '0' end::text end,'0')),'00') 
    $$;
    v_where:= $$
        WHERE s1.pla_enc=$1 and s1.pla_hog=1
    $$;
    EXECUTE v_sentencia || ' FROM plana_' || v_for_hogar || '_ s1 ' || v_where INTO v_norea using p_enc;
    v_sentencia:= $$            
        SELECT count(distinct res_hog::text||'-'||res_mie::text) FROM respuestas 
    $$;
    v_where:=$$
        WHERE res_ope=$1 and res_enc=$2 and res_for=$3 and res_mat='' 
            and res_valor is not null and trim(res_valor)<>''
    $$;
    EXECUTE v_sentencia || v_where into p_pob_pre using p_ope, p_enc, 'I1'; -- OJO GENERALIZAR 
    v_sentencia:= $$
        SELECT count(distinct m.res_hog::text||'-'||m.res_mie::text) FROM respuestas m
    $$;
    v_where:= $$
        WHERE m.res_ope=$1 and m.res_enc=$2 and m.res_for=$3 and m.res_mat='P' 
            and (m.res_valor is not null or trim(m.res_valor)<>'')
    $$;
    if false /*ya no hay p7*/ then 
       v_where:= v_where || $$
            and m.res_mie in (
            SELECT res_mie FROM encu.respuestas
                WHERE res_ope=$1 and res_enc=$2 and res_for=$3 and res_mat='P' 
                    and res_hog=m.res_hog and res_mie=m.res_mie                
                    and res_var ='p7' 
                    and (res_valor is null or res_valor not in ('3','4')));
       $$;  
    end if;
    EXECUTE v_sentencia || v_where  into p_pob_tot using p_ope, p_enc, v_for_hogar;  
    if v_max_entrea=2 and v_min_entrea=2 then
        if v_cod_recu is null then
            p_rea:=0;
        else
            p_rea:=2;
        end if;
        p_norea:=v_norea;
    elsif v_max_entrea=v_min_entrea and v_max_entrea in (1,4,5) then
        if v_max_entrea in (4,5) then
            p_rea=v_max_entrea;
        else
            if v_cod_recu is null then
                p_rea:=1;
            else
                p_rea:=3;
            end if;
        end if;
    elsif v_n_entrea4>0 then
            p_rea=4;   
    else
        if v_cod_recu is null then
            p_rea:=0;
            p_norea:=10;
        else
            p_rea:=2;
            p_norea:=18;
        end if;            
    end if;
    SELECT distinct 1 into v_con_dato
      FROM encu.respuestas 
      WHERE res_ope=p_ope and res_enc=p_enc and res_for<>'TEM' and (res_valor is not null or trim(res_valor)<>'');
    v_con_dato:=coalesce (v_con_dato,0);
    IF v_rol='encuestador' THEN
        p_rea_enc=p_rea;
        p_norea_enc=p_norea;
        p_con_dato_enc=v_con_dato;
    END IF;
    IF v_rol='recuperador' THEN
        p_rea_recu=p_rea;
        p_norea_recu=p_norea;
        p_con_dato_recu=v_con_dato;
    END IF;    
END;
$_$;


ALTER FUNCTION encu.sincronizacion_tem_datos(p_ope text, p_enc integer, INOUT p_rea integer, INOUT p_norea integer, INOUT p_rea_enc integer, INOUT p_norea_enc integer, INOUT p_con_dato_enc integer, INOUT p_rea_recu integer, INOUT p_norea_recu integer, INOUT p_con_dato_recu integer, INOUT p_pob_tot integer, INOUT p_pob_pre integer, INOUT p_hog_tot integer, INOUT p_hog_pre integer) OWNER TO tedede_php;

--
-- Name: tabla_variable(text); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION tabla_variable(p_var text) RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
   v_tabla text;
BEGIN
    SELECT table_name into v_tabla
      FROM information_schema.columns  
      WHERE table_name IN ('plana_a1_', 'plana_tem_', 'plana_s1_','plana_s1_p','plana_i1_','plana_a1_m','plana_a1_x') 
        AND table_schema='encu' 
        AND substr(column_name,5)=p_var
      ORDER BY substr(column_name,5) NOT IN ('enc','hog','mie','exm','tlg') 
      LIMIT 1;
    RETURN v_tabla;
END;
$$;


ALTER FUNCTION encu.tabla_variable(p_var text) OWNER TO tedede_php;

--
-- Name: validar_variable_destino(text, text, text, text, text, text); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION validar_variable_destino(pope text, pfor text, pmat text, porigen text, pdestinosalto text, pdestinovarpre text, OUT pvardestino text, OUT ptipodestinosalto text) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE
  vfiltro_orden bigint;
  vbloque_orden bigint;
  vfactorblo integer;
  vfactorpre integer;
BEGIN
vfactorblo=100000;
vfactorpre=10000;
--argumento de salida: variable de salida y tipo=variable, pre, filtro    
IF pdestinosalto is distinct from 'fin' then
    IF pdestinovarpre IS NOT NULL THEN
        select 'pre' INTO ptipodestinosalto
            FROM encu.variables
            WHERE var_ope=pope and var_for=pfor and var_mat=pmat and var_var=pdestinovarpre;
        pvardestino=pdestinovarpre; -- sal_destino pregunta y ya se obtuvo la variable destino
    ELSE  
       --busco si sal_destino era ya una variable
        select var_var,'var' 
            INTO pvardestino, ptipodestinosalto 
            FROM encu.variables 
            WHERE var_ope=pope and var_var=pdestinosalto;
        if pvardestino is null then -- veo si es un filtro
            --supongo filtro del mismo formulario
            select ((blo_orden*vfactorblo+ fil_orden)::bigint*vfactorpre)::bigint
                INTO vfiltro_orden 
                FROM encu.filtros join encu.bloques on fil_ope=blo_ope and fil_for=blo_for and fil_blo=blo_blo 
                WHERE fil_ope=pope and fil_for=pfor and fil_fil=pdestinosalto;
            if vfiltro_orden>0 then
                select var_var,'fil' 
                    into pvardestino, ptipodestinosalto
                    from encu.variables_ordenadas 
                    where var_ope=pope and var_for=pfor and (blo_orden*vfactorblo+ pre_orden)::bigint*vfactorpre+var_orden::bigint <vfiltro_orden
                    order by ((blo_orden*vfactorblo+ pre_orden)::bigint*vfactorpre+var_orden)::bigint desc
                    limit 1;
            else
                --ver si es un bloque
                select ((blo_orden*vfactorblo)::bigint*vfactorpre)::bigint
                    INTO vbloque_orden 
                    FROM encu.bloques
                    WHERE blo_ope=pope and blo_for=pfor and blo_blo=pdestinosalto;
                if vbloque_orden>0 then
                    select var_var,'blo' 
                        into pvardestino, ptipodestinosalto
                        from encu.variables_ordenadas 
                        where var_ope=pope and var_for=pfor and (blo_orden*vfactorblo+ pre_orden)::bigint*vfactorpre+var_orden::bigint <vbloque_orden
                        order by ((blo_orden*vfactorblo+ pre_orden)::bigint*vfactorpre+var_orden)::bigint desc
                        limit 1;
                end if;    
            end if;
        end if;   
    END IF;
ELSE
    ptipodestinosalto='fin';   
END IF;
END;
$$;


ALTER FUNCTION encu.validar_variable_destino(pope text, pfor text, pmat text, porigen text, pdestinosalto text, pdestinovarpre text, OUT pvardestino text, OUT ptipodestinosalto text) OWNER TO tedede_php;

--
-- Name: variables_base_producida(text, text, integer, integer); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION variables_base_producida(p_base text, p_producida text, p_estado_desde integer, p_estado_hasta integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
   v_sentencia_var text;
   v_sentencia_var_hog text;
   v_sentencia_var_pers text;
   v_sentencia_var_exm text;
   v_var_seleccionadas record;
   v_sentencia text;
   v_clausula text;
   v_vista text;
   v_campos_select text;
   v_var_bu text;
   v_hoy_es text;
   v_transformada text;
   v_tipo character varying;
   v_sindato integer;
   v_null integer;
   v_atipico integer;
   v_cambiar boolean;
   v_exporta_pks boolean;
BEGIN
    v_sentencia= '';
    v_clausula='';
    v_sentencia_var:='';
    v_sentencia_var_hog:='';
    v_sentencia_var_pers:='';
    v_sentencia_var_exm:='';
    v_campos_select:='';
    v_vista:='';
    v_hoy_es:='';
    v_transformada:='';
    FOR v_var_seleccionadas in
       select pre_blo, table_name, column_name as var_bu, 
              coalesce(basprovar_alias,basprovar_var) as var_nombrebu,
              case when table_name in ('plana_i1_', 'plana_s1_p') then 'personas' 
                   when table_name in ('plana_a1_', 'plana_tem_', 'plana_s1_') then 'hogar' 
                   when table_name in ('plana_a1_x') then 'exm' 
                   when table_name in ('plana_a1_m') then 'exm_men' 
                   else '' end as tabla,
              case when varcal_varcal is not null then 2  
                   when var_var is not null then 1
                   else 0 end as var_orden, data_type as var_tipo, basprovar_cantdecimales as cantdecimales,
                   basprovar_orden as orden, baspro_cambiar_especiales, baspro_cambiar_nsnc_por, baspro_cambiar_sindato_por, baspro_cambiar_null_por,
              case when table_name='plana_tem_' then baspro_cambiar_nsnc_por
                   when varcal_varcal is null then coalesce(var_nsnc_atipico, baspro_cambiar_nsnc_por) 
                   when var_var is null then coalesce(varcal_nsnc_atipico, baspro_cambiar_nsnc_por) end as nsnc_atipico,
              basprovar_exportar_en
          from encu.baspro
            left join encu.baspro_var on baspro_ope = basprovar_ope and baspro_baspro = basprovar_baspro
            left join (SELECT table_name, column_name, substr(column_name,5) as infovariable, data_type
                         FROM information_schema.columns
                         WHERE table_name in ('plana_a1_', 'plana_tem_', 'plana_s1_','plana_s1_p','plana_i1_', 'plana_a1_x', 'plana_a1_m') and table_schema='encu'
                           and (substr(column_name,5) not in ('enc','hog','exm','mie','tlg') or column_name='pla_exm' and table_name in ('plana_a1_x'))) i ON basprovar_var = infovariable
            left join encu.varcal on varcal_ope = basprovar_ope and varcal_activa and varcal_varcal= infovariable
            left join encu.variables on var_ope = basprovar_ope and var_var= infovariable
            left join encu.preguntas on var_ope = pre_ope and var_pre = pre_pre
          where baspro_ope = dbo.ope_actual() and baspro_baspro = p_producida
          order by orden,tabla,var_orden,var_bu 
    LOOP  
       CASE WHEN (dbo.ope_actual() = 'same2014' and v_var_seleccionadas.table_name = 'plana_s1_') or v_var_seleccionadas.table_name = 'plana_a1_' and v_var_seleccionadas.var_bu<>'pla_exm'
         THEN CASE WHEN v_var_seleccionadas.pre_blo = 'Viv'
                THEN v_var_bu = 'v.'||v_var_seleccionadas.var_bu;
                ELSE v_var_bu = 'a.'||v_var_seleccionadas.var_bu;
                END CASE;
         ELSE
           v_var_bu = v_var_seleccionadas.var_bu;
       END CASE;
       IF v_var_bu='pla_exm' THEN
         v_var_bu:='a1_x.pla_exm';
       END IF;
       v_tipo:=v_var_seleccionadas.var_tipo;
       v_sindato:=v_var_seleccionadas.baspro_cambiar_sindato_por;
       v_null:=v_var_seleccionadas.baspro_cambiar_null_por;
       v_atipico:=v_var_seleccionadas.nsnc_atipico;
       v_cambiar:=v_var_seleccionadas.baspro_cambiar_especiales;
       CASE 
       WHEN v_cambiar THEN 
         v_transformada := ' when '||v_var_bu||' in ((-1)::'||v_tipo||',(-5)::'||v_tipo||') then '||case when v_sindato is null then 'null ' else '('||v_sindato||')::'||v_tipo end||
                           ' when '||v_var_bu||' is null then '||case when v_null is null then 'null ' else '('||v_null||')::'||v_tipo end||
                           ' when '||v_var_bu||' =(-9)::'||v_tipo||' then '||case when v_atipico is null then 'null ' else '('||v_atipico||')::'||v_tipo end||
                           ' else '||v_var_bu||' end';
         if v_tipo in ('character varying','text') then
           v_transformada := ' when '||v_var_bu||' in ($$//$$,$$-9$$) then $$NS/NC$$'||
                             ' when '||v_var_bu||' is null or '||v_var_bu||' in ($$-1$$,$$-5$$) then $$$$'||
                             v_transformada;
         end if;
         v_transformada:='case'||v_transformada;
       ELSE 
         v_transformada := v_var_bu; 
       END CASE;
       IF p_base='basehogar' AND v_var_seleccionadas.tabla='hogar' AND coalesce(v_var_seleccionadas.basprovar_exportar_en,'ambas')='ambas' THEN
         v_sentencia_var_hog:=v_sentencia_var_hog||
         case when v_var_seleccionadas.var_tipo = 'numeric' and v_var_seleccionadas.cantdecimales is not null then 
           'round('||v_transformada||'::decimal,'||v_var_seleccionadas.cantdecimales||')' 
           else v_transformada end||' as '||v_var_seleccionadas.var_nombrebu||' ,';
       END IF;
       IF p_base='basepersonas' AND ((v_var_seleccionadas.tabla='personas' and v_var_seleccionadas.basprovar_exportar_en is null) 
          OR v_var_seleccionadas.basprovar_exportar_en IN ('mie','ambas')) THEN
         v_sentencia_var_pers:=v_sentencia_var_pers||
         case when v_var_seleccionadas.var_tipo = 'numeric' and v_var_seleccionadas.cantdecimales is not null then 
           'round('||v_transformada||'::decimal,'||v_var_seleccionadas.cantdecimales||')' 
           else v_transformada end||' as '||v_var_seleccionadas.var_nombrebu||' ,';
       END IF;  
       IF p_base='baseexm' AND ((v_var_seleccionadas.tabla='exm' and v_var_seleccionadas.basprovar_exportar_en is null) 
          OR v_var_seleccionadas.basprovar_exportar_en IN ('exm','ambas')) THEN
         v_sentencia_var_exm:=v_sentencia_var_exm||
         case when v_var_seleccionadas.var_tipo = 'numeric' and v_var_seleccionadas.cantdecimales is not null then 
           'round('||v_transformada||'::decimal,'||v_var_seleccionadas.cantdecimales||')' 
           else v_transformada end||' as '||v_var_seleccionadas.var_nombrebu||' ,';
       END IF;  
       IF p_base='baseexm_men' AND ((v_var_seleccionadas.tabla='exm_men' and v_var_seleccionadas.basprovar_exportar_en is null) 
          OR v_var_seleccionadas.basprovar_exportar_en IN ('exm_men','ambas')) THEN
         v_sentencia_var_exm:=v_sentencia_var_exm||
         case when v_var_seleccionadas.var_tipo = 'numeric' and v_var_seleccionadas.cantdecimales is not null then 
           'round('||v_transformada||'::decimal,'||v_var_seleccionadas.cantdecimales||')' 
           else v_transformada end||' as '||v_var_seleccionadas.var_nombrebu||' ,';
       END IF;  
    END LOOP;
    IF p_base='basehogar' THEN 
          CASE WHEN dbo.ope_actual()= 'same2014' THEN
            v_clausula:=' from encu.plana_s1_ as a
                         inner join encu.plana_tem_ t on a.pla_enc=t.pla_enc
                         LEFT JOIN encu.plana_s1_ v ON a.pla_enc = v.pla_enc AND 1 = v.pla_hog                         
                         where t.pla_estado between '||p_estado_desde||' and '||p_estado_hasta||'
                         order by 1,2,3  ';
          ELSE
            v_clausula:=' from encu.plana_a1_ a
                     inner join encu.plana_s1_ as s1 on a.pla_enc=s1.pla_enc and a.pla_hog=s1.pla_hog
                     inner join encu.plana_tem_ t on a.pla_enc=t.pla_enc
                     LEFT JOIN encu.plana_a1_ v ON a.pla_enc = v.pla_enc AND 1 = v.pla_hog                         
                     where t.pla_estado between '||p_estado_desde||' and '||p_estado_hasta||'
                     order by 1,2,3  ';
          END CASE;
      IF length(v_sentencia_var_hog)>0 THEN 
        v_sentencia_var:=substr(v_sentencia_var_hog,1,length(v_sentencia_var_hog)-1); 
      END IF;
      v_campos_select:=' a.pla_enc as enc, a.pla_hog as hog, ';          
    END IF;
    IF p_base='basepersonas' THEN                
    /* seria para personas*/                   
      v_clausula='  from encu.plana_s1_p s1_p 
                    inner join encu.plana_i1_ i1 on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie
                    inner join encu.plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and t.pla_mie=0
                    left join encu.plana_s1_ s1 on s1_p.pla_enc=s1.pla_enc and s1_p.pla_hog=s1.pla_hog
                        left join encu.'||case when dbo.ope_actual()='same2014' then 'plana_s1_' else 'plana_a1_' end
                        ||' v  ON s1_p.pla_enc = v.pla_enc AND s1_p.pla_hog = v.pla_hog
                    where t.pla_estado between '||p_estado_desde||' and '||p_estado_hasta||'                        
                    order by 1,2,3,4  ';
      IF length(v_sentencia_var_pers)>0 THEN 
        v_sentencia_var:=substr(v_sentencia_var_pers,1,length(v_sentencia_var_pers)-1); 
      END IF;
      v_campos_select:=' s1_p.pla_enc as enc, s1_p.pla_hog as hog, s1_p.pla_mie as mie, ';
    END IF;
    IF p_base='baseexm' THEN                
      v_clausula='  from encu.plana_a1_x a1_x 
                    inner join encu.plana_tem_ t on t.pla_enc=a1_x.pla_enc and t.pla_hog=0 and t.pla_mie=0
                    left join encu.plana_s1_ s1 on a1_x.pla_enc=s1.pla_enc and a1_x.pla_hog=s1.pla_hog
                    left join encu.plana_a1_ v  ON s1.pla_enc = v.pla_enc AND s1.pla_hog = v.pla_hog
                    where t.pla_estado between '||p_estado_desde||' and '||p_estado_hasta||'                        
                    order by 1,2,3  ';
      IF length(v_sentencia_var_exm)>0 THEN 
        v_sentencia_var:=substr(v_sentencia_var_exm,1,length(v_sentencia_var_exm)-1); 
      END IF;
      v_campos_select:=' a1_x.pla_enc as enc, a1_x.pla_hog as hog, a1_x.pla_exm as exm, ';
    END IF;
    IF p_base='baseexm_men' THEN
      v_clausula='  from encu.plana_a1_m a1_x 
                    inner join encu.plana_tem_ t on t.pla_enc=a1_x.pla_enc and t.pla_hog=0 and t.pla_mie=0
                    left join encu.plana_s1_ s1 on a1_x.pla_enc=s1.pla_enc and a1_x.pla_hog=s1.pla_hog
                    left join encu.plana_a1_ v  ON s1.pla_enc = v.pla_enc AND s1.pla_hog = v.pla_hog
                    where t.pla_estado between '||p_estado_desde||' and '||p_estado_hasta||'                       
                    order by 1,2,3  ';
      IF length(v_sentencia_var_exm)>0 THEN 
        v_sentencia_var:=substr(v_sentencia_var_exm,1,length(v_sentencia_var_exm)-1); 
      END IF;
      v_campos_select:=' a1_x.pla_enc as enc, a1_x.pla_hog as hog, a1_x.pla_exm as exm, ';
    END IF;
    v_vista:=' drop view if exists encu.'||dbo.ope_actual()||'_'||p_producida||'_'||substr(p_base,5)||' ; '|| ' create view encu.'||dbo.ope_actual()||'_'||p_producida||'_'||substr(p_base,5)||' as ' ;
  -- raise notice 'v_vista %', v_vista;
    SELECT baspro_sin_pk INTO STRICT v_exporta_pks
        FROM encu.baspro
        WHERE baspro_ope = dbo.ope_actual() and baspro_baspro = p_producida;
    v_sentencia:=v_vista||' select'||case when not v_exporta_pks then v_campos_select else ' ' end||v_sentencia_var||v_clausula||';';
     --raise notice 'Sentencia  %', v_sentencia;
    IF v_sentencia_var <> '' THEN 
        execute v_sentencia;
    END IF;
END;
$_$;


ALTER FUNCTION encu.variables_base_producida(p_base text, p_producida text, p_estado_desde integer, p_estado_hasta integer) OWNER TO tedede_php;

--
-- Name: variables_base_usuarios(text); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION variables_base_usuarios(p_base text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   v_sentencia_var text;
   v_sentencia_var_hog text;
   v_sentencia_var_pers text;
   v_var_seleccionadas record;
   v_sentencia text;
   v_clausula text;
   v_vista text;
   v_campos_select text;
BEGIN
    v_sentencia= '';
    v_clausula='';
    v_sentencia_var:='';
    v_sentencia_var_hog:='';
    v_sentencia_var_pers:='';
    v_campos_select:='';
    v_vista:='';
    FOR v_var_seleccionadas in
       select column_name as var_bu, 
              case when varcal_nombrevar_baseusuario is not null then varcal_nombrevar_baseusuario  
              when var_nombrevar_baseusuario is not null then var_nombrevar_baseusuario 
              else substr(column_name,5) end as var_nombrebu,
              case when table_name in ('plana_i1_', 'plana_s1_p') then 'personas' 
                   when table_name in ('plana_a1_', 'plana_tem_', 'plana_s1_') then 'hogar' else '' end as tabla,
              case when varcal_nombrevar_baseusuario is not null then 2  
                   when var_nombrevar_baseusuario is not null then 1
                   else 0 end as var_orden      
          from information_schema.columns
            left join encu.varcal on varcal_ope = dbo.ope_actual() and varcal_activa and varcal_varcal=substr(column_name,5)
            left join encu.variables on var_ope = dbo.ope_actual() and var_var=substr(column_name,5) 
          where table_name in ('plana_a1_', 'plana_tem_', 'plana_s1_','plana_s1_p','plana_i1_') and table_schema='encu'
             and  substr(column_name,5) not in ('enc','hog','mie','exm','tlg')
             and  (varcal_baseusuario or var_baseusuario)
          order by tabla,var_orden,var_bu 
    LOOP
       IF p_base='basehogar' AND v_var_seleccionadas.tabla='hogar' THEN
         v_sentencia_var_hog:=v_sentencia_var_hog||v_var_seleccionadas.var_bu||' as '||v_var_seleccionadas.var_nombrebu||' ,';
       END IF;
       IF p_base='basepersonas' AND v_var_seleccionadas.tabla='personas' THEN
         v_sentencia_var_pers:=v_sentencia_var_pers||v_var_seleccionadas.var_bu||' as '||v_var_seleccionadas.var_nombrebu||' ,';
       END IF;  
    END LOOP;
       IF p_base='basehogar' THEN 
          v_clausula:=' from encu.plana_a1_ a
                         inner join encu.plana_s1_ as s1 on a.pla_enc=s1.pla_enc and a.pla_hog=s1.pla_hog
                         inner join encu.plana_tem_ t on a.pla_enc=t.pla_enc 
                         where t.pla_estado =79
                         order by a.pla_enc, a.pla_hog  ';
          v_sentencia_var:=substr(v_sentencia_var_hog,1,length(v_sentencia_var_hog)-1);
          v_campos_select:=' select a.pla_enc as enc, a.pla_hog as hog, ';          
       END IF;
       IF p_base='basepersonas' THEN                
       /* seria para personas*/                   
          v_clausula='  from encu.plana_s1_p s1_p 
                        inner join encu.plana_i1_ i1 on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie
                        inner join encu.plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and t.pla_mie=0
                        where t.pla_estado =79                        
                        order by s1_p.pla_enc, s1_p.pla_hog, s1_p.pla_mie  ';
          v_sentencia_var:=substr(v_sentencia_var_pers,1,length(v_sentencia_var_pers)-1);
          v_campos_select:=' select s1_p.pla_enc as enc, s1_p.pla_hog as hog, s1_p.pla_mie as mie, ';
       END IF;
       v_vista:=' drop view if exists encu.v_'||p_base||' ; '|| ' create view encu.v_'||p_base||' as ' ;
      -- raise notice 'v_vista %', v_vista;
       v_sentencia:=v_vista||v_campos_select||v_sentencia_var||v_clausula||';';
      -- raise notice 'Sentencia  %', v_sentencia;  
       execute v_sentencia;
END;
$$;


ALTER FUNCTION encu.variables_base_usuarios(p_base text) OWNER TO tedede_php;

--
-- Name: variables_ins_trg(); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION variables_ins_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_mat_ua text;
BEGIN
  -- GENERADO POR: generacion_trigger_respuestas.php
  INSERT INTO encu.respuestas (res_ope,res_for,res_mat,res_enc,res_hog,res_mie,res_exm, res_var, res_tlg)
    SELECT cla_ope,cla_for,cla_mat,cla_enc,cla_hog,cla_mie,cla_exm, new.var_var, new.var_tlg
      FROM encu.claves
      WHERE cla_ope=new.var_ope AND cla_for=new.var_for AND cla_mat=new.var_mat;
  RETURN new;
END
$$;


ALTER FUNCTION encu.variables_ins_trg() OWNER TO tedede_php;

--
-- Name: variables_saltadas(text, text, text, text); Type: FUNCTION; Schema: encu; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION variables_saltadas(pope text, porigen text, pdestino text, ptipodestino text, OUT psaltadas_str text, OUT psaltadas_cond_str text) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE
  c_all_vars RECORD;
BEGIN
    psaltadas_str='';
    psaltadas_cond_str='';
    FOR c_all_vars IN
      select var_var
         from encu.variables_ordenadas v,
                (SELECT orden FROM encu.variables_ordenadas where var_ope=pope and var_var=porigen) as origen,
                (SELECT orden 
                    FROM encu.variables_ordenadas 
                    where var_ope=pope and 
                          var_var=CASE WHEN pdestino IS NOT NULL THEN pdestino
                                       ELSE (SELECT var_ultima_for 
                                                 FROM encu.variables_ordenadas 
                                                 WHERE var_ope=pope and var_var= porigen
                                            )
                                       END  
                 ) as destino
         where v.var_ope=pope and v.orden >origen.orden and 
              (v.orden<destino.orden or (ptipodestino in ('fin','fil','blo') and v.orden=destino.orden))           
         order by v.orden
    LOOP
         psaltadas_cond_str=  psaltadas_cond_str ||' and '|| c_all_vars.var_var|| ' is null' ;
         psaltadas_str= psaltadas_str || ', ' ||c_all_vars.var_var;
    END LOOP;
    IF psaltadas_str <>'' THEN
        psaltadas_cond_str= substr( psaltadas_cond_str,6);
        psaltadas_str= substr( psaltadas_str,3);
    END IF;
END;
$$;


ALTER FUNCTION encu.variables_saltadas(pope text, porigen text, pdestino text, ptipodestino text, OUT psaltadas_str text, OUT psaltadas_cond_str text) OWNER TO tedede_php;

SET search_path = operaciones, pg_catalog;

--
-- Name: generar_calculo_estado_trg(); Type: FUNCTION; Schema: operaciones; Owner: tedede_php
--

CREATE OR REPLACE  FUNCTION generar_calculo_estado_trg() RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
  v_enter text:=chr(13)||chr(10);
  v_script_creador text;
  v_reemplazo_1 text;
  v_reemplazos record;
  otro_orden integer;
BEGIN
v_script_creador:=$SCRIPT$
-- alter table encu.plana_tem_ drop column if exists pla_sup_dirigida_enc; alter table encu.plana_tem_ add column pla_sup_dirigida_enc integer; /*G*/

-- DROP FUNCTION encu.calculo_estado_trg();
-- set search_path = encu, comun, public;

CREATE OR REPLACE FUNCTION encu.calculo_estado_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_estado_final integer;
  
  v_sup_dirigida_enc encu.plana_tem_.pla_sup_dirigida_enc%type; /*G*/
  
  v_en_campo_nuevo encu.plana_tem_.pla_en_campo%type; v_en_campo_viejo encu.plana_tem_.pla_en_campo%type; /*G*/
  
  v_rol_nuevo encu.plana_tem_.pla_rol%type; v_rol_viejo encu.plana_tem_.pla_rol%type; /*G_amano*/
  
  v_per_nuevo encu.plana_tem_.pla_per%type; v_per_viejo encu.plana_tem_.pla_per%type; /*G_amano*/
  
  v_calculo_enc integer;  
  v_calculo_recu integer;  
  i_sufijo integer;
  v_sufijo text;
  v_aux_aleat_enc text;
  v_aux_aleat_recu text;  
  v_reserva encu.plana_tem_.pla_reserva%type;
  v_sel_etoi14_villa encu.plana_tem_.pla_sel_etoi14_villa%type;
BEGIN
  if new.res_for='TEM' and 
        (new.res_valor is distinct from old.res_valor 
        or new.res_valesp is distinct from old.res_valesp 
        or new.res_valor_con_error is distinct from old.res_valor_con_error 
        or new.res_var = 'asignable'
        ) 
     and new.res_var<>'estado' -- porque vamos a actualizar el estado
  then
    if new.res_var='verificado_enc' and new.res_valor::integer<>2 then
        select pla_rea_enc, pla_norea_enc, pla_dominio, pla_hog_tot, (pla_enc*23 + pla_replica + pla_comuna*7 + coalesce(pla_id_marco,0)*21 + coalesce(pla_ccodigo,0)) % 10
            into   v_rea_enc, v_norea_enc, v_dominio, v_hog_tot, v_calculo_enc
            from encu.plana_tem_
            where pla_enc=new.res_enc and pla_hog=new.res_hog and pla_mie=new.res_mie and pla_exm=new.res_exm; 
        if (v_rea_enc = 1 or dbo.norea_supervisable(v_norea_enc)) and v_dominio in (3,4) then
            if v_calculo_enc = 1 and (v_dominio=3 or v_rea_enc=1) and coalesce(v_hog_tot,0)<=1 then
                v_aux_aleat_enc := '3';
            elsif v_calculo_enc = 0 and v_rea_enc = 1 and v_dominio=3 and coalesce(v_hog_tot,0)<=1 then
                v_aux_aleat_enc='4';
            else
                v_aux_aleat_enc := null;
            end if;
            UPDATE encu.respuestas
                SET res_valor=v_aux_aleat_enc, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
                    WHERE res_ope=new.res_ope
                        and res_for=new.res_for
                        and res_mat=new.res_mat
                        and res_enc=new.res_enc
                        and res_hog=new.res_hog
                        and res_mie=new.res_mie 
                        and res_exm=new.res_exm 
                        and res_var='sup_aleat'; 
        end if;
    elsif new.res_var='verificado_recu' and new.res_valor::integer<>2 then
        select pla_rea_recu, pla_norea_recu, pla_dominio, ((pla_enc*23 + pla_replica + pla_comuna*7 + coalesce(pla_id_marco,0)*21 + coalesce(pla_ccodigo,0)) % 10)
            into   v_rea_recu, v_norea_recu, v_dominio, v_calculo_recu
            from encu.plana_tem_
            where pla_enc=new.res_enc and pla_hog=new.res_hog and pla_mie=new.res_mie and pla_exm=new.res_exm;  
        if (v_rea_recu = 3 or dbo.norea_supervisable(v_norea_recu)) and v_dominio = 3 then
            if v_calculo_recu = 8 and 'si es la misma persona no hay supervision de campo'='x' then
                v_aux_aleat_recu := '3';
            elsif v_calculo_recu = 7 and v_rea_recu = 3 then
                v_aux_aleat_recu := '4';
            else
                v_aux_aleat_recu := null;
            end if;
            UPDATE encu.respuestas
                SET res_valor=v_aux_aleat_recu::text, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
                    WHERE res_ope=new.res_ope
                        and res_for=new.res_for
                        and res_mat=new.res_mat
                        and res_enc=new.res_enc
                        and res_hog=new.res_hog
                        and res_mie=new.res_mie 
                        and res_exm=new.res_exm 
                        and res_var='sup_aleat'; 
        end if;
    end if;
    select pla_reserva, pla_sel_etoi14_villa
      into   v_reserva,   v_sel_etoi14_villa
      from encu.plana_tem_
      where pla_enc=new.res_enc and pla_hog=new.res_hog and pla_mie=new.res_mie and pla_exm=new.res_exm;     
    select pla_sup_dirigida_enc /*G*/
      into   v_sup_dirigida_enc /*G*/
      from encu.plana_tem_
      where pla_enc=new.res_enc and pla_hog=new.res_hog and pla_mie=new.res_mie and pla_exm=new.res_exm; /*G:PK*/ -- pk_verificada
    if v_estado_final is null and (v_result_supe>0 /*G:C*/) then v_estado_final:=47 /*G:NumE*/; end if; /*G:E*/
    if v_estado_final is distinct from v_estado then
      UPDATE encu.respuestas
        SET res_valor=v_estado_final, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
        WHERE res_ope=new.res_ope
          and res_for=new.res_for
          and res_mat=new.res_mat
          and res_enc=new.res_enc
          and res_hog=new.res_hog
          and res_mie=new.res_mie 
          and res_exm=new.res_exm /*G:PK*/ 
          and res_var='estado'; -- pk_verificada
    end if;
  end if;
  for i_sufijo in 1..2 loop
      if i_sufijo=1 then
          v_sufijo='enc';
      else
          v_sufijo='recu';
      end if;
      if new.res_var='volver_a_cargar_'||v_sufijo and new.res_valor>='1' then
         UPDATE encu.respuestas
           SET res_valor=null, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
           WHERE res_ope=new.res_ope
             and res_for=new.res_for
             and res_mat=new.res_mat
             and res_enc=new.res_enc
             and res_hog=new.res_hog
             and res_mie=new.res_mie 
             and res_exm=new.res_exm 
             and res_var in ('fecha_carga_'||v_sufijo,'fecha_descarga_'||v_sufijo,'a_ingreso_'||v_sufijo,'con_dato_'||v_sufijo,'fin_ingreso_'||v_sufijo) -- pk_verificada
             and (res_valor is not null or res_valesp is not null or res_valor_con_error is not null);
      end if;
      if new.res_var='fecha_carga_'||v_sufijo and new.res_valor>'1' then
         UPDATE encu.respuestas
           SET res_valor=null, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
           WHERE res_ope=new.res_ope
             and res_for=new.res_for
             and res_mat=new.res_mat
             and res_enc=new.res_enc
             and res_hog=new.res_hog
             and res_mie=new.res_mie 
             and res_exm=new.res_exm 
             and res_var = 'volver_a_cargar_'||v_sufijo -- pk_verificada
             and (res_valor is not null or res_valesp is not null or res_valor_con_error is not null);
      end if;
      if new.res_var='a_ingreso_'||v_sufijo and new.res_valor='1' then
         UPDATE encu.respuestas
           SET res_valor='2', res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
           WHERE res_ope=new.res_ope
             and res_for=new.res_for
             and res_mat=new.res_mat
             and res_enc=new.res_enc
             and res_hog=new.res_hog
             and res_mie=new.res_mie 
             and res_exm=new.res_exm 
             and res_var = 'con_dato_'||v_sufijo -- pk_verificada
             and (res_valor is distinct from '2' or res_valesp is not null or res_valor_con_error is not null);
      end if;
  end loop;
-- seccion variables calculadas
  select 
      case when pla_estado in (23,24,33,34,44,54) then 1 else 0 end, pla_en_campo, /*G*/
      case when pla_estado<=29 then 'encuestador'  when pla_estado<=39 then 'recuperador' 
           when pla_estado<59 then  'supervisor'  else null end, pla_rol, /*G_amano*/
      case when pla_estado<=29 then pla_cod_enc when pla_estado<=39 then pla_cod_recu when pla_estado<49 then pla_cod_sup 
           when pla_estado<59 then pla_cod_sup else null end, pla_per /*G_amano*/
    into 
      v_en_campo_nuevo, v_en_campo_viejo, /*G*/
      v_rol_nuevo, v_rol_viejo, /*G_amano*/
      v_per_nuevo, v_per_viejo /*G_amano*/
    from encu.plana_tem_
    where pla_enc=new.res_enc and pla_hog=new.res_hog and pla_mie=new.res_mie and pla_exm=new.res_exm;
  if v_en_campo_nuevo is distinct from v_en_campo_viejo then
    UPDATE encu.respuestas
       SET res_valor=v_en_campo_nuevo, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
       WHERE res_ope=new.res_ope
         and res_for=new.res_for
         and res_mat=new.res_mat
         and res_enc=new.res_enc
         and res_hog=new.res_hog
         and res_mie=new.res_mie 
         and res_exm=new.res_exm 
         and res_var = 'en_campo'; -- pk_verificada
  end if; /*G*/
  if v_rol_nuevo is distinct from v_rol_viejo then
    UPDATE encu.respuestas
       SET res_valor=v_rol_nuevo, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
       WHERE res_ope=new.res_ope
         and res_for=new.res_for
         and res_mat=new.res_mat
         and res_enc=new.res_enc
         and res_hog=new.res_hog
         and res_mie=new.res_mie 
         and res_exm=new.res_exm 
         and res_var = 'rol'; -- pk_verificada
  end if; /*G_amano*/
  if v_per_nuevo is distinct from v_per_viejo then
    UPDATE encu.respuestas
       SET res_valor=v_per_nuevo, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
       WHERE res_ope=new.res_ope
         and res_for=new.res_for
         and res_mat=new.res_mat
         and res_enc=new.res_enc
         and res_hog=new.res_hog
         and res_mie=new.res_mie 
         and res_exm=new.res_exm 
         and res_var = 'per'; -- pk_verificada
  end if; /*G_amano*/
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql VOLATILE;

ALTER FUNCTION encu.calculo_estado_trg()
  OWNER TO tedede_php;

DROP TRIGGER IF EXISTS calculo_estado_trg ON encu.respuestas;

CREATE TRIGGER calculo_estado_trg
  AFTER UPDATE
  ON encu.respuestas
  FOR EACH ROW
  EXECUTE PROCEDURE encu.calculo_estado_trg();
$SCRIPT$;
  SELECT MAX(pre_orden)+100 INTO otro_orden 
    FROM encu.variables INNER JOIN encu.preguntas ON pre_ope=var_ope AND pre_pre=var_pre WHERE pre_for='TEM';

  FOR v_reemplazos IN
    SELECT v_enter as separador, '-- alter table encu.plana_tem_ drop column if exists pla_sup_dirigida_enc; alter table encu.plana_tem_ add column pla_sup_dirigida_enc integer; /*G*/' as que_reemplazar
    UNION SELECT v_enter,'  v_sup_dirigida_enc encu.plana_tem_.pla_sup_dirigida_enc%type; /*G*/'
    UNION SELECT ', '   ,'pla_sup_dirigida_enc /*G*/'
    UNION SELECT ','    ,'  v_sup_dirigida_enc /*G*/'
  LOOP
    SELECT string_agg(replace(replace(v_reemplazos.que_reemplazar,'sup_dirigida_enc',var_var),'integer',case when var_tipovar='timestamp' then 'timestamp without time zone' when var_tipovar = 'texto' then 'text' else 'integer' end),v_reemplazos.separador ORDER BY pre_orden)
        INTO v_reemplazo_1
        FROM (select var_var, var_tipovar, pre_orden from encu.variables 
              inner join encu.preguntas on pre_ope=var_ope and pre_pre=var_pre where pre_for='TEM'
              union select 'dominio' as var_var, 'numeros' as var_tipovar, otro_orden as pre_orden ) as a;
    v_script_creador:=replace(v_script_creador,v_reemplazos.que_reemplazar,v_reemplazo_1);
  END LOOP;
  FOR v_reemplazos IN
    SELECT v_enter as separador, '    if v_estado_final is null and (v_result_supe>0 /*G:C*/) then v_estado_final:=47 /*G:NumE*/; end if; /*G:E*/'::text as que_reemplazar
  LOOP
    SELECT string_agg(replace(replace(v_reemplazos.que_reemplazar,
             'v_result_supe>0 /*G:C*/',comun.reemplazar_variables(est_criterio,'v_\1')),
             '47 /*G:NumE*/',est_est::text
             ),v_reemplazos.separador ORDER BY est_est DESC)
       INTO v_reemplazo_1
        FROM encu.estados
        WHERE trim(est_criterio)<>'';
    v_script_creador:=replace(v_script_creador,v_reemplazos.que_reemplazar,v_reemplazo_1);
    IF v_script_creador IS NULL THEN
      RAISE EXCEPTION 'v_script_creador ES NULO EN % --- %',v_reemplazos.que_reemplazar,v_reemplazo_1;
    END IF;
  END LOOP;
  EXECUTE v_script_creador;
  RETURN NULL;
--  RETURN v_script_creador;
END;
$_$;

ALTER FUNCTION operaciones.generar_calculo_estado_trg() OWNER TO tedede_php;