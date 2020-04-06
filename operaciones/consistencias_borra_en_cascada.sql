
alter table encu.con_var drop CONSTRAINT con_var_consistencias_fk;

alter table encu.con_var add CONSTRAINT con_var_consistencias_fk FOREIGN KEY (convar_ope, convar_con)
      REFERENCES encu.consistencias (con_ope, con_con) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;