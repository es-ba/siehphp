insert into encu.tem (tem_enc, tem_zona, tem_comuna, tem_frac_comun, tem_radio_comu, tem_mza_comuna, tem_up, tem_semana, tem_id_marco, tem_dominio, tem_area, 
         tem_cnombre, tem_hn, tem_hp, tem_hd, tem_barrio, tem_obs, tem_tlg, tem_lote, tem_replica)
  select ps.encuesta, ps.zona, z.comuna, ps.fraccion, ps.radio, ps.manzana, ps.segmento, ps.dia, orden, 5, z.villa,
         coalesce(calle_nro,'S/N'), casa, piso, depto, villa, observaciones_ps, 1, z.villa, ps.dia
    from empa.planilla_ps ps 
      inner join empa.planilla_rr rr on rr.zona = ps.zona and rr.fraccion = ps.fraccion and rr.radio=ps.radio and rr.manzana=ps.manzana and rr.segmento=ps.segmento
      inner join empa.planilla_z z on z.zona = ps.zona and z.fraccion = ps.fraccion
    where encuesta not in (select tem_enc from encu.tem)
      and ps.dia=1; -- 1 y 2

insert into encu.claves (cla_ope, cla_for, cla_enc, cla_tlg)
  select 'empa171', 'TEM', tem_enc, tem_tlg
    from encu.tem
    where tem_enc not in (select cla_enc from encu.claves where cla_for='TEM');
      
update encu.tem 
  set tem_anio_list = casa, tem_hn = segmento, tem_tipounidad = null
  from empa.planilla_ps
  where encuesta = tem_enc;

update encu.plana_tem_
  set pla_anio_list = casa, pla_hn = segmento, pla_tipounidad = null
  from empa.planilla_ps
  where encuesta = pla_enc;

update encu.respuestas set res_valor=1
  where res_ope='empa171'
    and res_for='TEM'
    and res_mat=''
    and res_var='a_ingreso_enc'
    and res_valor is null;

select encuesta, dia, count(*), max(radio||','||segmento), min(radio||','||segmento)
  from empa.planilla_ps
  group by encuesta, dia
  having count(*)>1