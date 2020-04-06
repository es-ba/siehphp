--Eah2013 tabla encu.varcondic, agregado de columna tlg
alter table encu.varcondic add column varcondic_tlg bigint;
update encu.varcondic set varcondic_tlg=1;
alter table encu.varcondic alter column varcondic_tlg set not null;
alter table encu.varcondic add constraint varcondic_tiempo_logico_fk foreign key (varcondic_tlg)
      references encu.tiempo_logico (tlg_tlg) match simple
      on update no action on delete no action;
