-- Vamos a migrar desde yeah2011 a encu
create or replace function migrar_una_clave(p_tabla_origen text, p_for text, p_mat text,p_venc text,p_vhog text,p_vmie text,p_vexm text) returns void
  language plpgsql as 
$body$
declare
  v_sql text;  
begin
    v_sql:=replace(replace(replace(replace(replace($sql$
        INSERT INTO encu.claves(
                    cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm, cla_tlg)
            SELECT 'pp2012' as cla_ope, $1, $2, #p_venc# as cla_enc, #p_vhog# as cla_hog, coalesce(#p_vmie#,0) as cla_mie, coalesce(#p_vexm#,0) as cla_exm, 
                    1 as cla_tlg
              FROM yeah_2011.#p_tabla_origen# where #p_venc# BETWEEN  100001 AND 100100
    $sql$,'#p_tabla_origen#',p_tabla_origen),'#p_venc#',p_venc),'#p_vhog#',p_vhog),'#p_vmie#',p_vmie),'#p_vexm#',p_vexm);
    execute v_sql using p_for, p_mat;
end;
$body$;

create or replace function migrar_una_variable(p_tabla_origen text, p_for text, p_mat text, p_var text,p_venc text,p_vhog text,p_vmie text,p_vexm text) returns void
  language plpgsql as 
$body$
declare
  v_sql text;
begin
    v_sql:=replace(replace(replace(replace(replace(replace(replace($sql$    
        UPDATE encu.respuestas
            SET res_valor=case when #p_var#::text not in (#nsnc_var#::text,'-1') then #p_var# else null end 
              , res_valesp=case #p_var#::text when #nsnc_var#::text then '//' when '-1' then '--' else null end 
            FROM yeah_2011.#p_tabla_origen#
            WHERE res_ope='pp2012' and res_for=$1 and res_mat=$2 and res_enc=#p_venc# 
                AND res_hog=#p_vhog# 
		and res_mie=coalesce(#p_vmie#,0) 
		and res_exm=coalesce(#p_vexm#,0) 
                and res_var='#p_var#' and #p_venc# BETWEEN  100001 AND 100100
    $sql$,'#p_tabla_origen#',p_tabla_origen),'#p_var#',p_var),'#nsnc_var#','9'),'#p_venc#',p_venc),'#p_vhog#',p_vhog),'#p_vmie#',p_vmie),'#p_vexm#',p_vexm);
    execute v_sql using p_for, p_mat;    
end;
$body$;

create or replace function sortear_una_variable(p_for text, p_mat text, p_var text,p_tipovar text,p_conopc text) returns void
  language plpgsql as 
$body$
declare
  v_sql text;
begin
    update encu.respuestas
        set res_valor=1
        where res_for=p_for
            and res_mat=p_mat
            and res_var=p_var
            and res_valor is null;
end;
$body$;

-- Primero vamos a poner los datos de la TEM rígida 
INSERT INTO encu.tem(
            tem_enc, tem_comuna, tem_replica, tem_up, tem_lote,/* tem_res,*/ 
           -- tem_polifiscalias_zona, 
            tem_cnombre, tem_hn, tem_hp, tem_hd, 
            tem_hab, tem_h4,/* tem_ident_edif,*/ tem_barrio, /* tem_tipounidad, tem_obs, tem_cuerpo, tem_id_marco, 
            tem_frac_comun, tem_radio_comu, tem_mza_comuna, tem_clado, tem_h1, 
            tem_usp, tem_ccodigo, tem_idcuerpo, tem_nomb_inst, tem_tot_hab, 
            tem_pzas, tem_idprocedencia, tem_procedencia, tem_yearfuente, 
            tem_tbldomicilios_zona, tem_tbldomicilios_fiscalias, tem_polifiscalias_fiscalias, */
           -- tem_participacion, 
            tem_tlg)
SELECT encues, comuna::integer, replica::integer, up::integer, lote::integer, --null as res,
	--null as polifiscalias, 
	/* ipad, id_marco, idd, dpto, 
       frac, radio, mza, clado, seg, nced, orden_altu, pisoaux, 
       usp, h1, ccodigo,*/ 
       cnombre, hn::integer, hp, hd, 
       h0, h4::integer, 
--       ident_edif, /*rep,*/
      -- barrio, 
       /*cuit, tot_hab, pzas, hab, te, fuente, fec_mod, frac_comun, radio_comu, 
       mza_comuna, up_comuna, anio_list, replica_cm, marco, marco_anio, 
       nro_orden, incluido, operacion, usuario, ok, titular, suplente, 
       marca, pelusa, anio_list_ant, obs, idcuerpo, rama_act, nomb_inst, 
       eli, fuente_ant, replica_cm_2007, yearfuente, idprocedencia, 
       codord, replica2, marca1, reserva, orden_de_reemplazo, up_i, 
       estrato, habitaciones, fec_entr_enc, fec_enc, cod_recu, fec_entr_recu, 
       fec_recu, bolsa, estado, cod_sup, fin_sup, usu_ult_mod, norea_enc, 
       dominio, poseedor, rol_poseedor, id_proc, bolsa_ok, cod_ing, 
       ingresando, vil_hog_pres, vil_hog_aus, vil_pob_pres, vil_pob_aus, 
       fin_ingreso, inq_recuento, inq_tipo_viv, inq_ocu_flia, inq_ocu_pas, 
       inq_desocupados, inq_otro, inq_tot_hab, inq_dominio, posterior, 
       rea, hog, pobl, rea_modulo, norea_modulo, cod_enc, norea_recu, 
       rea_recu_modu, norea_recu_modu, comunas, sup_campo, sup_recu_campo, 
       sup_tel, fin_anal_ing, fin_anal_campo, fin_anal_proc, cod_ana_ing, 
       cod_ana_campo, cod_procesamiento, s1_extra, vil_hogpre_rea, vil_hogpre_hog, 
       vil_hogpre_pob, vil_hogaus_rea, vil_hogaus_hog, vil_hogaus_pob, 
       hogar_con_datos_de_vivienda */
       case "replica"
		when '3' then 1
		when '4' then 1
		when '1' then 2
		when '2' then 2
		when '5' then 3
		when '6' then 3
		when '7' then 1
		when '8' then 1
		end, 
       1 as tlg
  from yeah_2011.tem11
  where encues BETWEEN  100001 AND 100100;

INSERT INTO encu.claves (cla_ope, cla_for, cla_mat, cla_enc, cla_tlg) 
SELECT 'pp2012','TEM','',tem_enc,tem_tlg FROM encu.tem
where tem_enc in (select tem_enc from encu.tem)
  and tem_enc BETWEEN  100001 AND 100100;

select migrar_una_clave('eah11_viv_s1a1','A1','','nenc','nhogar','miembro','null');
select migrar_una_clave('eah11_fam','S1','P','nenc','nhogar','p0','null'); 
select migrar_una_clave('eah11_viv_s1a1','S1','','nenc','nhogar','miembro','null'); 
select migrar_una_clave('eah11_ex','A1','X','nenc','nhogar','null','ex_miembro');
select migrar_una_clave('eah11_i1','I1','','nenc','nhogar','miembro','null');

select migrar_una_variable(tabla,formulario,matriz,column_name,enc,hog,mie,exm) 
  from information_schema.columns, 
	(select 'eah11_viv_s1a1' as tabla, 'A1' as formulario, '' as matriz, 'nenc' as enc,'nhogar' as hog,'miembro' as mie, 'null' as exm
	union select 'eah11_fam' as tabla, 'S1' as formulario, 'P' as matriz, 'nenc' as enc,'nhogar' as hog,'p0' as mie, 'null' as exm
	union select 'eah11_viv_s1a1' as tabla, 'S1' as formulario, '' as matriz, 'nenc' as enc,'nhogar' as hog,'miembro' as mie, 'null' as exm
	union select 'eah11_ex' as tabla, 'A1' as formulario, 'X' as matriz, 'nenc' as enc,'nhogar' as hog,'null' as mie, 'ex_miembro' as exm
	union select 'eah11_i1' as tabla, 'I1' as formulario, '' as matriz, 'nenc' as enc,'nhogar' as hog,'miembro' as mie, 'null' as exm
	) x
  where table_schema='yeah_2011' and table_name=tabla
    and column_name not in ('nenc','nhogar','miembro','ex_miembro','p0','participacion');

select sortear_una_variable(var_for,var_mat,var_var,var_tipovar,var_conopc) 
  from encu.variables
  where var_var like 'h30%' or var_var like 'ec%' or var_var like 'bc%' or var_var='respondi'
    and var_ope='pp2012';

update encu.respuestas
  set res_valor=case "replica"
		when '3' then 1
		when '4' then 1
		when '1' then 2
		when '2' then 2
		when '5' then 3
		when '6' then 3
		when '7' then 1
		when '8' then 1
		end
  from yeah_2011.tem11
  where res_for='TEM'
    and res_ope='pp2012'
    and res_mat=''
    and res_var='participacion'
    and res_enc=encues;

/*    
select migrar_una_variable('eah11_viv_s1a1','A1','',var_var,'nenc','nhogar','miembro') from encu.variables where var_ope='pp2012' and var_for='A1' and length(var_mat)=0;
select migrar_una_variable('eah11_fam','S1','P',var_var,'nenc','nhogar','p0') from encu.variables where var_ope='pp2012' and var_for='S1' and var_mat='P';
select migrar_una_variable('eah11_viv_s1a1','S1','',var_var,'nenc','nhogar','miembro') from encu.variables where var_ope='pp2012' and var_for='S1' and length(var_mat)=0;
select migrar_una_variable('eah11_ex','A1','X',var_var,'nenc','nhogar','ex_miembro') from encu.variables where var_ope='pp2012' and var_for='A1' and var_mat='X';
select migrar_una_variable('eah11_i1','I1','',var_var,'nenc','nhogar','miembro') from encu.variables where var_ope='pp2012' and var_for='I1' and length(var_mat)=0;
*/

-- /*
INSERT INTO encu.personal(per_ope, per_per, per_apellido, per_nombre, per_rol, per_tlg)
     select 'pp2012', per_per::integer, per_apellido, per_nombre, per_rol, 1 from yeah_2011.personal;
-- */

drop table if exists encu.tmp_claves_migracion;
create table encu.tmp_claves_migracion as 
  select 'pp2012'::text as ope_actual, pla_enc as enc_actual, 'eah2011'::text as ope_anterior, pla_enc as enc_anterior
    from encu.plana_tem_
    where pla_enc BETWEEN  100001 AND 100100;

alter table encu.tmp_claves_migracion add primary key (ope_actual, enc_actual);

update encu.tmp_claves_migracion set enc_anterior=100088 where ope_actual='pp2012' and enc_actual=100087;
update encu.tmp_claves_migracion set enc_anterior=100087 where ope_actual='pp2012' and enc_actual=100088;
update encu.tmp_claves_migracion set enc_anterior=100004 where ope_actual='pp2012' and enc_actual=100003;
update encu.tmp_claves_migracion set enc_anterior=100003 where ope_actual='pp2012' and enc_actual=100004;

alter table encu.tmp_claves_migracion add unique (ope_anterior, enc_anterior);

/*eah2011*/
INSERT INTO encu.claves(
            cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm, 
            cla_aux_es_enc, cla_aux_es_hog, cla_aux_es_mie, cla_aux_es_exm, 
            cla_ultimo_coloreo_tlg, cla_tlg)
select ope_anterior, cla_for, cla_mat, enc_anterior, cla_hog, cla_mie, cla_exm, 
            cla_aux_es_enc, cla_aux_es_hog, cla_aux_es_mie, cla_aux_es_exm, 
            cla_ultimo_coloreo_tlg, cla_tlg 
  from encu.claves inner join encu.tmp_claves_migracion on cla_ope=ope_actual and cla_enc=enc_actual;

update encu.respuestas as r1 
  set res_valor=r2.res_valor 
  from encu.respuestas as r2 
	inner join encu.tmp_claves_migracion on r2.res_ope=ope_actual and r2.res_enc=enc_actual
  where r1.res_for=r2.res_for 
   and r1.res_mat=r2.res_mat 
   and r1.res_enc=enc_anterior
   and r1.res_hog=r2.res_hog  
   and r1.res_mie=r2.res_mie 
   and r1.res_exm=r2.res_exm 
   and r1.res_ope=ope_anterior
   and r1.res_var=r2.res_var;

/*datos para probar*/
update encu.respuestas
  set res_valor=1
  where res_for='TEM'
    and res_ope='pp2012'
    and res_mat=''
    and res_var='participacion'
    and res_enc=100007;

/*
update encu.respuestas
  set res_valor=null
  where res_for='TEM'
    and res_ope='pp2012'
    and res_mat=''
    and res_var in ('per','dispositivo','estado_carga');
*/

update encu.tem set tem_hn=tem_enc % 10;
update encu.plana_tem_ set pla_hn=pla_enc % 10;

update encu.respuestas
  set res_valor=res_valor::integer+1
  where res_for='S1'
    and res_ope='pp2012'
    and res_mat='P'
    and res_var='edad'
    and comun.es_numero(res_valor);
