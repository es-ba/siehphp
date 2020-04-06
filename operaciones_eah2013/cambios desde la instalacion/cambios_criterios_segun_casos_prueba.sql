-- Function: comun.reemplazar_variables(text, text)

-- DROP FUNCTION comun.reemplazar_variables(text, text);

CREATE OR REPLACE FUNCTION comun.reemplazar_variables(p_expresion text, p_reemplazante text)
  RETURNS text AS
$BODY$ select regexp_replace($1,'\m(?!AND)(?!OR)(?!NOT)(?!IS)(?!NULL)(?!IN)(?!TRUE)(?!FALSE)(?!EXISTS)(?!DISTINCT)(?!FROM)(?!BETWEEN)([a-z]\w*)(?!\s*\()\M',$2,'ig') $BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION comun.reemplazar_variables(text, text)
  OWNER TO postgres;

update encu.estados set est_criterio = 'verificado_ac=1 or verificado_enc=1 and (rea_enc=1 and hog_tot=1 or dominio=4 or dominio=5) and sup_aleat_enc is null and sup_dirigida_enc is null or verificado_recu=1 and rea_recu=3 and hog_tot=1 and sup_aleat_recu is null and sup_dirigida_recu is null or verificado_supe=1 or verificado_supr=1'
  where est_ope = 'eah2013' and est_est = 69;

update encu.estados set est_criterio =
'(((hog_tot>1 OR norea<70) AND norea is distinct from 10 AND norea is distinct from 18) OR (rea_enc=1 AND (sup_aleat_enc=3 OR sup_dirigida_enc=3))) AND verificado_enc<>0'
where est_est = 40 and est_ope = 'eah2013';

update encu.estados set est_criterio =
'(((hog_tot>1 OR norea<70) AND norea is distinct from 10 AND norea is distinct from 18) OR (rea_recu=1 AND (sup_aleat_recu=3 OR sup_dirigida_recu=3))) AND verificado_recu<>0'
where est_est = 50 and est_ope = 'eah2013';

update encu.estados set est_criterio = 
comun.buscar_reemplazar_espacios_raros('verificado_enc=4 and (rea_enc=1 and hog_tot=1 or dominio=4 or dominio=5) and sup_aleat_enc is null and sup_dirigida_enc is null or 
verificado_recu=4 and rea_recu=3 and hog_tot=1 and sup_aleat_recu is null and sup_dirigida_recu is null or verificado_supe=4 or 
verificado_supr=4 or norea=18 and (verificado_recu is not null or verificado_supe is not null or verificado_supr is not null)
') where est_est = 60 and est_ope = 'eah2013';

---para caso de prueba Excel[99] y [106]
update encu.estados set est_criterio =
comun.buscar_reemplazar_espacios_raros('verificado_ac=1 or 
verificado_enc=1 and ((rea_enc=1 and hog_tot=1 and sup_aleat_enc is null and sup_dirigida_enc is null) or (norea is distinct from 18 and norea is distinct from 10 and dominio is distinct from 3 and sup_dirigida_enc is null)) or 
verificado_recu=1 and (rea_recu=3 and hog_tot=1 and sup_aleat_recu is null and sup_dirigida_recu is null or (norea>=71 and norea not in (91,95,96))) or 
verificado_supe=1 or 
verificado_supr=1') 
where est_est = 69 and est_ope = 'eah2013';



