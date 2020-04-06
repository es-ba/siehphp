-- /*
delete from encu.respuestas where res_enc=909011;
delete from encu.claves  where cla_enc=909011;
delete from encu.plana_tem_  where pla_enc=909011;

INSERT INTO encu.tem (tem_id_marco,tem_comuna,tem_replica,tem_up,tem_lote,tem_enc,tem_clado,tem_ccodigo,tem_cnombre,tem_hn,tem_hp,tem_hd,tem_hab,tem_h4,tem_usp,tem_barrio,tem_ident_edif,tem_obs,tem_frac_comun,tem_radio_comu,tem_mza_comuna,tem_marco,tem_titular,tem_zona,tem_para_asignar,tem_tlg)
VALUES
  (NULL,1,9,999,900,909001,1,999,'PRUEBA',1,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,900,909002,1,999,'PRUEBA',2,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,900,909003,1,999,'PRUEBA',3,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,900,909004,1,999,'PRUEBA',4,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,900,909005,1,999,'PRUEBA',5,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,900,909006,1,999,'PRUEBA',6,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,900,909007,1,999,'PRUEBA',7,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,900,909008,1,999,'PRUEBA',8,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,900,909009,1,999,'PRUEBA',9,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,901,909010,1,999,'PRUEBA',0,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,901,909011,1,999,'PRUEBA',1,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,901,909012,1,999,'PRUEBA',2,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,901,909013,1,999,'PRUEBA',3,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,901,909014,1,999,'PRUEBA',4,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,901,909015,1,999,'PRUEBA',5,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,901,909016,1,999,'PRUEBA',6,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,901,909017,1,999,'PRUEBA',7,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,901,909018,1,999,'PRUEBA',8,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,901,909019,1,999,'PRUEBA',9,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,902,909020,1,999,'PRUEBA',0,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,902,909021,1,999,'PRUEBA',1,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,902,909022,1,999,'PRUEBA',2,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,902,909023,1,999,'PRUEBA',3,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,902,909024,1,999,'PRUEBA',4,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,902,909025,1,999,'PRUEBA',5,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,902,909026,1,999,'PRUEBA',6,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,902,909027,1,999,'PRUEBA',7,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,902,909028,1,999,'PRUEBA',8,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,902,909029,1,999,'PRUEBA',9,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,903,909030,1,999,'PRUEBA',0,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,903,909031,1,999,'PRUEBA',1,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,903,909032,1,999,'PRUEBA',2,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,903,909033,1,999,'PRUEBA',3,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,903,909034,1,999,'PRUEBA',4,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,903,909035,1,999,'PRUEBA',5,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,903,909036,1,999,'PRUEBA',6,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,903,909037,1,999,'PRUEBA',7,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,903,909038,1,999,'PRUEBA',8,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,903,909039,1,999,'PRUEBA',9,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,904,909040,1,999,'PRUEBA',0,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,904,909041,1,999,'PRUEBA',1,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,904,909042,1,999,'PRUEBA',2,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,904,909043,1,999,'PRUEBA',3,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,904,909044,1,999,'PRUEBA',4,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,904,909045,1,999,'PRUEBA',5,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,904,909046,1,999,'PRUEBA',6,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,904,909047,1,999,'PRUEBA',7,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,904,909048,1,999,'PRUEBA',8,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,904,909049,1,999,'PRUEBA',9,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,905,909050,1,999,'PRUEBA',0,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,905,909051,1,999,'PRUEBA',1,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,905,909052,1,999,'PRUEBA',2,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,905,909053,1,999,'PRUEBA',3,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,905,909054,1,999,'PRUEBA',4,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,905,909055,1,999,'PRUEBA',5,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,905,909056,1,999,'PRUEBA',6,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,905,909057,1,999,'PRUEBA',7,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,905,909058,1,999,'PRUEBA',8,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,905,909059,1,999,'PRUEBA',9,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,906,909060,1,999,'PRUEBA',0,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,906,909061,1,999,'PRUEBA',1,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,906,909062,1,999,'PRUEBA',2,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,906,909063,1,999,'PRUEBA',3,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,906,909064,1,999,'PRUEBA',4,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,906,909065,1,999,'PRUEBA',5,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,906,909066,1,999,'PRUEBA',6,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,906,909067,1,999,'PRUEBA',7,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,906,909068,1,999,'PRUEBA',8,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,906,909069,1,999,'PRUEBA',9,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,907,909070,1,999,'PRUEBA',0,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,907,909071,1,999,'PRUEBA',1,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,907,909072,1,999,'PRUEBA',2,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,907,909073,1,999,'PRUEBA',3,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,907,909074,1,999,'PRUEBA',4,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,907,909075,1,999,'PRUEBA',5,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,907,909076,1,999,'PRUEBA',6,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,907,909077,1,999,'PRUEBA',7,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,907,909078,1,999,'PRUEBA',8,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,907,909079,1,999,'PRUEBA',9,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,908,909080,1,999,'PRUEBA',0,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,908,909081,1,999,'PRUEBA',1,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,908,909082,1,999,'PRUEBA',2,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,908,909083,1,999,'PRUEBA',3,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,908,909084,1,999,'PRUEBA',4,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,908,909085,1,999,'PRUEBA',5,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,908,909086,1,999,'PRUEBA',6,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,908,909087,1,999,'PRUEBA',7,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,908,909088,1,999,'PRUEBA',8,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,908,909089,1,999,'PRUEBA',9,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,909,909090,1,999,'PRUEBA',0,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,909,909091,1,999,'PRUEBA',1,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,909,909092,1,999,'PRUEBA',2,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,909,909093,1,999,'PRUEBA',3,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,909,909094,1,999,'PRUEBA',4,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,909,909095,1,999,'PRUEBA',5,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,909,909096,1,999,'PRUEBA',6,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,909,909097,1,999,'PRUEBA',7,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,909,909098,1,999,'PRUEBA',8,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1),
  (NULL,1,9,999,909,909099,1,999,'PRUEBA',9,null,null,NULL,4,0,NULL,NULL,NULL,5,5,29,1,2,'sur','prueba',1);
--*/

INSERT INTO encu.claves (cla_ope, cla_for, cla_mat, cla_enc, cla_tlg) 
  SELECT 'pp2012','TEM','',tem_enc,tem_tlg 
  FROM encu.tem
  WHERE tem_enc>=900000;

select * 
  from encu.plana_tem_
  where pla_enc>=900000;

update encu.respuestas
  set res_valor=1
  where res_for='TEM'
    and res_ope='pp2012'
    and res_mat=''
    and res_var='participacion'
    and res_enc>=900000;
