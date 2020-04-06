update encu.tem set tem_dominio=case tem_replica when 8 then 4 when 7 then 5 else 3 end;
update encu.tem set tem_participacion=case tem_replica when 1 then 3 when 2 then 3 when 3 then 2 when 4 then 2 else 1 end; 

INSERT INTO encu.claves (cla_ope, cla_for, cla_mat, cla_enc, cla_tlg) 
  SELECT 'eah2012','TEM','',tem_enc,tem_tlg 
    FROM encu.tem;

-- update encu.plana_tem_ set pla_dominio=case pla_replica when 8 then 4 when 7 then 5 else 3 end;
