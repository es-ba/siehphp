do $$
declare encuesta_inicial integer;
declare encuesta_final integer;
begin
encuesta_inicial = 995124;
encuesta_final = 995124;

delete from encu.respuestas where res_enc BETWEEN  encuesta_inicial AND encuesta_final;
delete from encu.plana_tem_ where pla_enc BETWEEN  encuesta_inicial AND encuesta_final;
delete from encu.plana_s1_ where pla_enc BETWEEN  encuesta_inicial AND encuesta_final;
delete from encu.plana_s1_p where pla_enc BETWEEN  encuesta_inicial AND encuesta_final;
delete from encu.plana_a1_ where pla_enc BETWEEN  encuesta_inicial AND encuesta_final;
delete from encu.plana_a1_x where pla_enc BETWEEN  encuesta_inicial AND encuesta_final;
delete from encu.plana_i1_ where pla_enc BETWEEN  encuesta_inicial AND encuesta_final;
delete from encu.claves where cla_enc BETWEEN  encuesta_inicial AND encuesta_final;

 end $$
