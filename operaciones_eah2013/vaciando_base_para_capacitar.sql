
delete from encu.respuestas 
  where res_enc in (130001,130002,130003,130004,310006,310007,310012,512392,512429,512636,513423)
    and res_ope='eah2013'
    and res_for<>'TEM';

delete from encu.claves
  where cla_enc in (130001,130002,130003,130004,310006,310007,310012,512392,512429,512636,513423)
    and cla_ope='eah2013'
    and cla_for<>'TEM';

delete from encu.plana_s1_
  where pla_enc in (130001,130002,130003,130004,310006,310007,310012,512392,512429,512636,513423);

delete from encu.plana_s1_p
  where pla_enc in (130001,130002,130003,130004,310006,310007,310012,512392,512429,512636,513423);

delete from encu.plana_i1_
  where pla_enc in (130001,130002,130003,130004,310006,310007,310012,512392,512429,512636,513423);

delete from encu.plana_a1_
  where pla_enc in (130001,130002,130003,130004,310006,310007,310012,512392,512429,512636,513423);

delete from encu.plana_a1_x
  where pla_enc in (130001,130002,130003,130004,310006,310007,310012,512392,512429,512636,513423);

update encu.respuestas 
  set res_valor=case res_var 
                    when 'asignable' then '1'
                    when 'cod_enc' then '1'
                    when 'dispositivo_enc' then '1'
                    else null
                end,
      res_valor_con_error=null, 
      res_valesp=null
  where res_enc in (130001,130002,130003,130004,310006,310007,310012,512392,512429,512636,513423)
    and res_ope='eah2013'
    and res_for='TEM';
    
