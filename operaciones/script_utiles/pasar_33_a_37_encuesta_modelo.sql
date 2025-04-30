--pasar una encuesta de estado 33 a estado 37 
--(solicitado  a veces por campo porque el recuperador/a no pudo descargar la tablet)
select pla_enc,pla_estado, pla_semana,pla_cod_enc, pla_rea, pla_rea_enc,pla_norea, 
   pla_fecha_descarga_enc,
   pla_fin_ingreso_recu, pla_con_dato_recu, pla_a_ingreso_recu 
    --,pla_verificado_enc
    from encu.plana_tem_ 
    where pla_enc in (xxxxxx) -- and pla_cod_recu=xxx; 
 --verifico que esté en 33
select comun.nueva_sesion_pgadmin('usuario','nroticket'); 

--verficar siempre con el select primero si son los datos que realmente queremos modificar

update encu.respuestas set res_valor=1, --anteriormente tenia valor null esta variable
   res_tlg=(select pga_tlg from pgadmin) 
--select * from encu.respuestas    --verifico primero antes de hacer el update
   where res_ope=dbo.ope_actual() and res_var='fin_ingreso_recu' and res_for='TEM'
     and res_enc  in (select pla_enc from encu.plana_tem_ where pla_enc in (xxxxxx) and pla_cod_recu=xxx);
--pasa a estado 37

