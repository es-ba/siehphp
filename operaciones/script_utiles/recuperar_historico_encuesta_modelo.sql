--Primero chequear estado, que no esté cargada en una tablet
select pla_estado,pla_cod_recu, pla_fecha_carga_recu,pla_fecha_descarga_recu,*
 from encu.plana_tem_
 where pla_enc=xxxxxx;
 
 --de acuerdo a la fecha que nos hayan solicitado, buscar el tlg que corresponda para recuperar la info 
 --(en cada formulario el tlg correspondiente puede variar)
 ----xxxxxx
 --plana a1_ 
select  r.* --,sesiones.*
  from his.his_respuestas r
  join encu.var_orden  v on hisres_var=varord_var and hisres_ope=varord_ope
  inner join encu.tiempo_logico on hisres_tlg=tlg_tlg inner join encu.sesiones on tlg_ses=ses_ses
  where  hisres_enc=xxxxxx  and hisres_for='A1' and hisres_mat='' 
       --and ses_momento::text <='202x-xx-xx'  
        and hisres_tlg = xxxxx
        and hisres_ope='operativo'
  order by ses_ses, varord_orden_total ;

--plana s1_
 select  r.* --,sesiones.*
  from his.his_respuestas r
  join encu.var_orden  v on hisres_var=varord_var and hisres_ope=varord_ope
  inner join encu.tiempo_logico on hisres_tlg=tlg_tlg inner join encu.sesiones on tlg_ses=ses_ses
  where  hisres_enc=xxxxxx  and hisres_for='S1' and hisres_mat='' 
      -- and ses_momento::text <='202x-xx-xx'  
        and hisres_tlg =xxxxx
        and hisres_ope='operativo'
        --and hisres_var='s1a1_obs'
  order by ses_ses, varord_orden_total;
  
 --plana s1_p 
  select r.*--,sesiones.* 
  from his.his_respuestas r
  join encu.var_orden  v on hisres_var=varord_var and hisres_ope=varord_ope
  inner join encu.tiempo_logico on hisres_tlg=tlg_tlg inner join encu.sesiones on tlg_ses=ses_ses
  where  hisres_enc=xxxxxx  and hisres_for='S1' and hisres_mat='P' 
       -- and ses_momento::text <='202x-xx-xx'
        and hisres_ope='operativo'
        and hisres_tlg in (xxxxx,xxxxx)
        --and hisres_var='nombre'
        -- order by hisres_tlg desc;    
  order by  ses_ses,hisres_mie, varord_orden_total ;
 
--plana i1
  select  r.*--,sesiones.* 
  from his.his_respuestas r
  join encu.var_orden  v on hisres_var=varord_var and hisres_ope=varord_ope
  inner join encu.tiempo_logico on hisres_tlg=tlg_tlg inner join encu.sesiones on tlg_ses=ses_ses
  where  hisres_enc=xxxxxx  and hisres_for='I1' and hisres_mat='' 
      -- and ses_momento::text <='202x-xx-xx' 
      and hisres_tlg  in (xxxxx,xxxxx)
        and hisres_ope='operativo'
        --and hisres_var='obs'  --ses_ses=xxxx
  --order by hisres_tlg desc        
  order by  ses_ses,hisres_mie, varord_orden_total ;

--plana md
  select  r.*--,sesiones.* 
  from his.his_respuestas r
  join encu.var_orden  v on hisres_var=varord_var and hisres_ope=varord_ope
  inner join encu.tiempo_logico on hisres_tlg=tlg_tlg inner join encu.sesiones on tlg_ses=ses_ses
  where  hisres_enc=xxxxxx  and hisres_for='MD' and hisres_mat='' 
     -- and ses_momento::text <='202x-xx-xx' 
       and hisres_tlg =xxxxx
        and hisres_ope='operativo'
        --and hisres_var='obs'  
  --order by hisres_tlg desc    ;    
  order by  ses_ses,hisres_mie, varord_orden_total ;
----
