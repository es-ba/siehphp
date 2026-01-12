create or replace function encu.fin_de_campo_automatico() returns void 
language sql as 
$body$
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
                    where res_ope='eah2026' and res_for ='TEM' and res_var='estado'
                ) as r_t
          where t_69.pla_enc= r_t.enc
          and extract(days from (now() - f_ult_mod_est))>= t_69.dom_dias_para_fin 
          ) as x 
     where x.pla_enc= r.res_enc AND r.res_ope='eah2026' 
        and r.res_for='TEM'
        and r.res_var='fin_de_campo';
$body$;

ALTER FUNCTION encu.fin_de_campo_automatico()
  OWNER TO tedede_owner;
