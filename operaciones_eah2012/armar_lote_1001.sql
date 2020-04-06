-- 3 encuestas de primera participacion
select * from encu.plana_tem_ where pla_enc in (
select tem_enc from encu.tem where tem_participacion = 1 order by tem_enc limit 3) ;

-- 1 encuesta de segunda participacion con un hogar rea 
select * from encu.tem where tem_participacion = 2 and tem_enc in (
select res_enc from encu.respuestas where res_ope='eah2011' and res_for='S1' and res_mat='' and res_var='entrea' and res_valor = '1' group by res_enc 
having count(res_enc)=1 order by res_enc) limit 1

-- 1 encuesta de segunda participacion con un hogar norea 
select * from encu.tem where tem_participacion = 2 and tem_enc in (
select res_enc from encu.respuestas where res_ope='eah2011' and res_for='S1' and res_mat='' and res_var='entrea' and res_valor='2' group by res_enc 
having count(res_enc)=1 order by res_enc) limit 1

-- 1 encuesta de tercera participacion con un hogar 2011 rea 2010 norea 
select * from encu.tem where tem_participacion = 3 and tem_enc in (
select res_enc from encu.respuestas where res_ope='eah2011' and res_for='S1' and res_mat='' and res_var='entrea' and res_valor='1' group by res_enc 
having count(res_enc)=1 order by res_enc) and tem_enc in (
select res_enc from encu.respuestas where res_ope='eah2010' and res_for='S1' and res_mat='' and res_var='entrea' and res_valor='2' group by res_enc 
having count(res_enc)=1 order by res_enc) limit 1

-- 1 encuesta de tercera participacion con un hogar 2011 norea and 2010 rea
select * from encu.tem where tem_participacion = 3 and tem_enc in (
select res_enc from encu.respuestas where res_ope='eah2011' and res_for='S1' and res_mat='' and res_var='entrea' and res_valor='2' group by res_enc 
having count(res_enc)=1 order by res_enc) and tem_enc in (
select res_enc from encu.respuestas where res_ope='eah2010' and res_for='S1' and res_mat='' and res_var='entrea' and res_valor='1' group by res_enc 
having count(res_enc)=1 order by res_enc) and tem_enc > 111111 limit 10

-- 1 encuesta de tercera participacion con un hogar 2011 rea and 2010 rea
select * from encu.tem where tem_participacion = 3 and tem_enc in (
select res_enc from encu.respuestas where res_ope='eah2011' and res_for='S1' and res_mat='' and res_var='entrea' and res_valor='1' group by res_enc 
having count(res_enc)=1 order by res_enc) and tem_enc in (
select res_enc from encu.respuestas where res_ope='eah2010' and res_for='S1' and res_mat='' and res_var='entrea' and res_valor='1' group by res_enc 
having count(res_enc)=1 order by res_enc) and tem_enc > 111111 limit 1

-- 2 encuestas de segunda participacion con dos hogares
select * from encu.tem where tem_participacion = 2 and tem_enc in (
select res_enc from encu.respuestas where res_ope='eah2011' and res_for='S1' and res_mat='' and res_var='entrea' and res_valor = '1' group by res_enc 
having count(res_enc)=2 order by res_enc) and  tem_enc not in (
select res_enc from encu.respuestas where res_ope='eah2010') limit 2


update encu.tem set tem_lote = 1001 where tem_enc in (512001,512002,512003,310004,310001,200686,200033,200010,310059,310486);
update encu.plana_tem_ set pla_lote = 1001 where pla_enc in (512001,512002,512003,310004,310001,200686,200033,200010,310059,310486);





