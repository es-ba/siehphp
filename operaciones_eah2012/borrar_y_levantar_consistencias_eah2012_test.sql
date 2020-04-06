alter table encu.con_var drop CONSTRAINT con_var_consistencias_fk;
alter table encu.inconsistencias drop CONSTRAINT inconsistencias_consistencias_fk;
alter table encu.ano_con drop CONSTRAINT ano_con_consistencias_fk;
alter table encu.sesiones drop CONSTRAINT sesiones_usuarios_fk;

delete from encu.consistencias;
delete from encu.usuarios;
delete from encu.sesiones;

--levantar los backups de consistencias y usuarios

alter table encu.con_var add CONSTRAINT con_var_consistencias_fk FOREIGN KEY (convar_ope, convar_con)
      REFERENCES encu.consistencias (con_ope, con_con) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION;
alter table encu.inconsistencias add CONSTRAINT inconsistencias_consistencias_fk FOREIGN KEY (inc_ope, inc_con)
      REFERENCES encu.consistencias (con_ope, con_con) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION;
alter table encu.ano_con add CONSTRAINT ano_con_consistencias_fk FOREIGN KEY (anocon_ope, anocon_con)
      REFERENCES encu.consistencias (con_ope, con_con) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION;      
alter table encu.sesiones add CONSTRAINT sesiones_usuarios_fk FOREIGN KEY (ses_usu)
      REFERENCES encu.usuarios (usu_usu) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

select * from encu.consistencias;
update encu.tem set tem_cnombre = left(tem_cnombre,1) || 'prueba';
update encu.plana_tem_ set pla_cnombre = left(pla_cnombre,1) || 'prueba';