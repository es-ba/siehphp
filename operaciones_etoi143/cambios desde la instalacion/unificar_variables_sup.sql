/*
alter table encu.plana_tem_ drop CONSTRAINT plana_tem__verificado_supe_fk;
alter table encu.plana_tem_ drop CONSTRAINT plana_tem__verificado_supr_fk;
alter table encu.plana_tem_ rename  pla_cod_supe               to  pla_cod_sup;
alter table encu.plana_tem_ rename  pla_fecha_carga_supe       to  pla_fecha_carga_sup;
alter table encu.plana_tem_ rename  pla_result_supe            to  pla_result_sup;
alter table encu.plana_tem_ rename  pla_verificado_supe        to  pla_verificado_sup;
alter table encu.plana_tem_ rename  pla_dispositivo_supe       to  pla_dispositivo_sup;
alter table encu.plana_tem_ rename  pla_fecha_primcarga_supe   to  pla_fecha_primcarga_sup;
alter table encu.plana_tem_ rename  pla_sup_aleat_enc          to  pla_sup_aleat;
alter table encu.plana_tem_ rename  pla_sup_dirigida_enc       to  pla_sup_dirigida;
alter table encu.plana_tem_ add
  CONSTRAINT plana_tem__verificado_sup_fk FOREIGN KEY (pla_verificado_sup)
      REFERENCES encu.verificado (ver_ver) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
alter table encu.plana_tem_ drop column pla_cod_supr;             
alter table encu.plana_tem_ drop column pla_fecha_carga_supr;     
alter table encu.plana_tem_ drop column pla_result_supr;          
alter table encu.plana_tem_ drop column pla_verificado_supr;      
-- alter table encu.plana_tem_ drop column pla_dispositivo_supr;     
alter table encu.plana_tem_ drop column pla_fecha_primcarga_supr; 
alter table encu.plana_tem_ drop pla_sup_aleat_recu;     
alter table encu.plana_tem_ drop pla_sup_dirigida_recu;
*/
CREATE INDEX respuestas_var_i ON encu.respuestas (res_var ASC NULLS LAST);

ALTER TABLE encu.est_var DROP CONSTRAINT est_var_variables_fk;
ALTER TABLE encu.est_var
  ADD CONSTRAINT est_var_variables_fk FOREIGN KEY (estvar_ope, estvar_var)
      REFERENCES encu.variables (var_ope, var_var) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE encu.pla_var DROP CONSTRAINT pla_var_variables_fk;
ALTER TABLE encu.pla_var
  ADD CONSTRAINT pla_var_variables_fk FOREIGN KEY (plavar_ope, plavar_var)
      REFERENCES encu.variables (var_ope, var_var) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;
      
ALTER TABLE encu.con_var DROP CONSTRAINT con_var_variables_fk;
ALTER TABLE encu.con_var
  ADD CONSTRAINT con_var_variables_fk FOREIGN KEY (convar_ope, convar_var)
      REFERENCES encu.variables (var_ope, var_var) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE encu.respuestas DROP CONSTRAINT respuestas_variables_fk;

alter table encu.respuestas disable trigger all;

update encu.variables set var_var=case var_var when 'sup_dirigida_enc' then 'sup_dirigida' when 'sup_aleat_enc' then 'sup_aleat' else replace(var_var,'_supe','_sup') end
  where (/*var_var like '%_supe' or */var_var like 'sup_%_enc')
    and var_ope='eah2013';
delete from encu.variables 
  where (/*var_var like '%_supr' or */var_var like 'sup_%_recu')
    and var_ope='eah2013';
update encu.respuestas set res_var=case res_var when 'sup_dirigida_enc' then 'sup_dirigida' when 'sup_aleat_enc' then 'sup_aleat' else  replace(res_var,'_supe','_sup') end
  where (/*res_var like '%_supe' or */res_var like 'sup_%_enc')
    and res_ope='eah2013';
delete from encu.respuestas
  where (/*res_var like '%_supr' or */res_var like 'sup_%_recu')
    and res_ope='eah2013';
    
alter table encu.respuestas enable trigger all;

ALTER TABLE encu.respuestas
  ADD CONSTRAINT respuestas_variables_fk FOREIGN KEY (res_ope, res_var)
      REFERENCES encu.variables (var_ope, var_var) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION;

INSERT INTO encu.planillas(planilla_planilla, planilla_nombre, planilla_tlg) VALUES
    ('REC_SUP_CAM','Planilla de rececpción del supervisor de campo',1),
    ('REC_SUP_TEL','Planilla de rececpción del supervisor telefónico',1);

INSERT INTO encu.pla_est(plaest_planilla, plaest_ope, plaest_est, plaest_tlg)
  SELECT planilla_planilla as plaest_planilla, plaest_ope, plaest_est, plaest_tlg
    FROM encu.pla_est, encu.planillas
    WHERE planilla_planilla in ('REC_SUP_CAM','REC_SUP_TEL')
      and plaest_planilla='REC_SUP_ENC';

INSERT INTO encu.pla_var(
            plavar_planilla, plavar_ope, plavar_var, plavar_orden, plavar_tlg)      
  SELECT planilla_planilla as plavar_planilla, plavar_ope, plavar_var, plavar_orden, plavar_tlg
    FROM encu.pla_var, encu.planillas
    WHERE planilla_planilla in ('REC_SUP_CAM','REC_SUP_TEL')
      and plavar_planilla='REC_SUP_ENC';     

INSERT INTO encu.pla_var(plavar_planilla, plavar_ope, plavar_var, plavar_orden, plavar_tlg) VALUES 
  ('REC_SUP_CAM', 'eah2013', 'cod_sup',540,1),
  ('REC_SUP_CAM', 'eah2013', 'fecha_carga_sup',550,1),
  ('REC_SUP_CAM', 'eah2013', 'fecha_primcarga_sup',560,1),
  ('REC_SUP_CAM', 'eah2013', 'rea',160,1),      
  ('REC_SUP_CAM', 'eah2013', 'norea',170,1),      
  ('REC_SUP_CAM', 'eah2013', 'hog_pre',180,1),      
  ('REC_SUP_CAM', 'eah2013', 'hog_tot',190,1),      
  ('REC_SUP_CAM', 'eah2013', 'pob_pre',200,1),      
  ('REC_SUP_CAM', 'eah2013', 'pob_tot',210,1), 
  ('REC_SUP_CAM', 'eah2013', 'cod_recu',30,1),
  ('REC_SUP_CAM', 'eah2013', 'cod_enc',20,1),
  ('REC_SUP_CAM', 'eah2013', 'estado',10,1)
  ;
      
      
INSERT INTO encu.pla_var(plavar_planilla, plavar_ope, plavar_var, plavar_orden, plavar_tlg) VALUES 
  ('REC_SUP_TEL', 'eah2013', 'cod_sup',540,1),
  ('REC_SUP_TEL', 'eah2013', 'fecha_carga_sup',550,1),
  ('REC_SUP_TEL', 'eah2013', 'fecha_primcarga_sup',560,1),
  ('REC_SUP_TEL', 'eah2013', 'rea',160,1),      
  ('REC_SUP_TEL', 'eah2013', 'norea',170,1),      
  ('REC_SUP_TEL', 'eah2013', 'hog_pre',180,1),      
  ('REC_SUP_TEL', 'eah2013', 'hog_tot',190,1),      
  ('REC_SUP_TEL', 'eah2013', 'pob_pre',200,1),      
  ('REC_SUP_TEL', 'eah2013', 'pob_tot',210,1), 
  ('REC_SUP_TEL', 'eah2013', 'cod_recu',30,1),
  ('REC_SUP_TEL', 'eah2013', 'cod_enc',20,1),
  ('REC_SUP_TEL', 'eah2013', 'estado',10,1)
  ;
      
      
