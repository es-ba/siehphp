INSERT INTO encu.claves(
        cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm, 
        cla_aux_es_enc, cla_aux_es_hog, cla_aux_es_mie, cla_aux_es_exm, 
        cla_ultimo_coloreo_tlg, cla_tlg)
SELECT 'eah2013', cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm, 
	cla_aux_es_enc, cla_aux_es_hog, cla_aux_es_mie, cla_aux_es_exm, 
	cla_ultimo_coloreo_tlg, 1
FROM eah2012.claves where cla_ope = 'eah2012' and cla_for not in ('TEM') 
	and (cla_enc between 311000 and 311099 or cla_enc between 512000 and 512099 or cla_enc between 100000 and 100099);



update encu.respuestas r set res_var=a.res_var, res_valor=a.res_valor, res_valesp=a.res_valesp, res_valor_con_error=a.res_valor_con_error, 
res_estado=a.res_estado, res_anotaciones_marginales=a.res_anotaciones_marginales, res_tlg=1 from eah2012.respuestas a 
where a.res_ope='eah2012' and r.res_for=a.res_for and r.res_mat=a.res_mat and r.res_enc=a.res_enc 
and r.res_hog=a.res_hog and r.res_mie = a.res_mie and r.res_exm=a.res_exm and r.res_var=a.res_var;


