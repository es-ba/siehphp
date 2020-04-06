select *
  from his.his_respuestas inner join encu.tiempo_logico on tlg_tlg=hisres_tlg
       inner join encu.sesiones on ses_ses=tlg_ses
  where hisres_ope='eah2012' 
    and hisres_for='TEM'
    and hisres_enc= 410230 -- between 712001 and 712009--310007
    and hisres_var='dispositivo'
  order by hisres_tlg;

/*
select *
  from encu.plana_tem_
  where pla_norea<>pla_norea_e
  limit 100;
  */