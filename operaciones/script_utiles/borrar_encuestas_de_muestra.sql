-- SECCIÓN COPIA A OPERACIONES DE ENCUESTAS QUE COMIENZAN CON 8 Y 9
select * INTO operaciones.plana_tem_ from encu.plana_tem_ where cast(pla_enc as text) not like ('8%') and cast(pla_enc as text) not like ('9%');
select * INTO operaciones.respuestas from encu.respuestas where res_enc in (select pla_enc from operaciones.plana_tem_);
select * INTO operaciones.claves from encu.claves where cla_enc in (select pla_enc from operaciones.plana_tem_);
select * INTO operaciones.tem from encu.tem where tem_enc in (select pla_enc from operaciones.plana_tem_);

-- SECCIÓN CONSULTAS
select distinct(res_enc) from encu.respuestas where res_enc in (select pla_enc from operaciones.plana_tem_);
select distinct(cla_enc) from encu.claves where cla_enc in (select pla_enc from operaciones.plana_tem_);
select pla_enc from encu.plana_tem_ where pla_enc in (select pla_enc from operaciones.plana_tem_);
select tem_enc from encu.tem where tem_enc in (select pla_enc from operaciones.plana_tem_);

-- SECCIÓN DELETES
DELETE FROM encu.respuestas where res_enc in (select pla_enc from operaciones.plana_tem_);
DELETE from encu.claves where cla_enc in (select pla_enc from operaciones.plana_tem_);
DELETE from encu.plana_tem_ where pla_enc in (select pla_enc from operaciones.plana_tem_);
DELETE FROM encu.tem where tem_enc in (select pla_enc from operaciones.plana_tem_);