INSERT INTO encu.preguntas(
             pre_ope,   pre_for, pre_blo, pre_pre,         pre_texto,                               pre_desp_opc, pre_orden, pre_tlg)
     VALUES ('eah2013', 'TEM'  , '',      'casa'         , 'número de casa en villa',               'vertical',   720,       1),
            ('eah2013', 'TEM'  , '',      'manzana'      , 'manzana de villa',                      'vertical',   730,       1),
            ('eah2013', 'TEM'  , '',      'inq_tot_hab'  , 'total de habitaciones del inquilinato', 'vertical',   740,       1),
            ('eah2013', 'TEM'  , '',      'inq_ocu_flia' , 'habitaciones del inquilinato ocupadas', 'vertical',   750,       1);

INSERT INTO encu.variables(
             var_ope,   var_for,  var_mat,  var_pre,         var_var,        var_tipovar, var_tlg)
     VALUES ('eah2013', 'TEM'  ,  '',       'casa'         , 'casa',         'texto'    , 1),
            ('eah2013', 'TEM'  ,  '',       'manzana'      , 'manzana',      'texto'    , 1),
            ('eah2013', 'TEM'  ,  '',       'inq_tot_hab'  , 'inq_tot_hab',  'texto'    , 1),
            ('eah2013', 'TEM'  ,  '',       'inq_ocu_flia' , 'inq_ocu_flia', 'texto'    , 1);

alter table encu.plana_tem_ 
      add column pla_casa   text,
      add pla_manzana       text,
      add pla_inq_tot_hab   text,
      add pla_inq_ocu_flia  text;

INSERT INTO encu.pla_var(
            plavar_planilla, plavar_ope, plavar_var, plavar_orden, plavar_tlg)
    VALUES ('REC_ENC', 'eah2013', 'casa',      70, 1),
           ('REC_ENC', 'eah2013', 'manzana',   80, 1),
           ('REC_ENC', 'eah2013', 'inq_tot_hab',  370, 1),
           ('REC_ENC', 'eah2013', 'inq_ocu_flia', 380, 1),
           ('MON_TEM', 'eah2013', 'casa',      70, 1),
           ('MON_TEM', 'eah2013', 'manzana',   80, 1),
           ('MON_TEM', 'eah2013', 'inq_tot_hab',  670, 1),
           ('MON_TEM', 'eah2013', 'inq_ocu_flia', 680, 1);

-- Function: encu.plana_tem_control_editar_variables_trg()

-- DROP FUNCTION encu.plana_tem_control_editar_variables_trg();

CREATE OR REPLACE FUNCTION encu.plana_tem_control_editar_variables_trg()
  RETURNS trigger AS
$BODY$
DECLARE

BEGIN
  if new.pla_cnombre <> old.pla_cnombre OR new.pla_hn <> old.pla_hn then
    if new.pla_dominio <> 5 then
       raise 'NO PUEDE MODIFICAR LA DIRECCION Y/O NRO. DOMINIO % ', new.pla_dominio;
    end if;
  end if;
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION encu.plana_tem_control_editar_variables_trg()
  OWNER TO tedede_php;

-- Trigger: plana_tem_control_editar_variables_trg on encu.respuestas

-- DROP TRIGGER plana_tem_control_editar_variables_trg ON encu.respuestas;

CREATE TRIGGER plana_tem_control_editar_variables_trg
  BEFORE UPDATE
  ON encu.plana_tem_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.plana_tem_control_editar_variables_trg();

  
INSERT INTO encu.preguntas(
             pre_ope,   pre_for, pre_blo, pre_pre,         pre_texto,                               pre_desp_opc, pre_orden, pre_tlg)
     VALUES ('eah2013', 'TEM'  , '',      'fecha_primcarga_supe'         , 'fecha primera carga supervisor encuestador',                  'vertical',   770,       1),
            ('eah2013', 'TEM'  , '',      'fecha_primcarga_supr'         , 'fecha primera carga supervisor recuperador',
     'vertical',   780,       1);

INSERT INTO encu.variables(
             var_ope,   var_for,  var_mat,  var_pre,         var_var,        var_tipovar, var_tlg)
     VALUES ('eah2013', 'TEM'  ,  '',       'fecha_primcarga_supe'         , 'fecha_primcarga_supe',         'timestamp'    , 1),
            ('eah2013', 'TEM'  ,  '',       'fecha_primcarga_supr'         , 'fecha_primcarga_supr',         'timestamp'    , 1);
            
alter table encu.plana_tem_ 
      add column pla_fecha_primcarga_supe   timestamp without time zone,
      add column pla_fecha_primcarga_supr   timestamp without time zone;
      
