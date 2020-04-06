update encu.variables set var_destino_nsnc=var_destino  where var_ope='eah2012' and var_var in ('t48b_esp', 'm1_anio','t11_otro');

CREATE INDEX his_respuestas_idx1
   ON his.his_respuestas (hisres_ope ASC NULLS LAST, hisres_for ASC NULLS LAST, hisres_mat ASC NULLS LAST, hisres_var ASC NULLS LAST, hisres_enc ASC NULLS LAST, hisres_hog ASC NULLS LAST, hisres_mie ASC NULLS LAST, hisres_exm ASC NULLS LAST);
