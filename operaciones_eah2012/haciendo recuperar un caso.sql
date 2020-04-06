select *, 
	(
	select res_valor
	  from his.his_respuestas inner join encu.tiempo_logico on hisres_tlg=tlg_tlg
           inner join encu.sesiones on ses_ses=tlg_ses
	  where         
        res_ope = hisres_ope and
        res_for = hisres_for and
        res_mat = hisres_mat and
        res_enc = hisres_enc and
        res_hog = hisres_hog and
        res_mie = hisres_mie and
        res_exm = hisres_exm and
        res_var = hisres_var and
        ses_usu <> 'vojeda' 
        order by res_tlg desc
        limit 1) as valor_recuperado
  from encu.respuestas
  where res_ope='eah2012'
    and res_enc=310486
    and res_for<>'TEM'
    and res_hog=1
