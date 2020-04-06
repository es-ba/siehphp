/*
alter table cvp.calculos add column transmitir_canastas character varying(1) NOT NULL DEFAULT 'N'::character varying;

create table cvp.transf_info (
  operativo text,
  agrupacion text,
  grupo text,
  primary key (operativo, agrupacion, grupo)
);

alter table cvp.transf_info  add foreign key (agrupacion, grupo) references cvp.grupos (agrupacion, grupo);

insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'D', 'D11');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'D', 'D211');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'D', 'D221');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'D', 'D231');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'D', 'D241');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'D', 'D251');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'D', 'D311');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'D', 'D312');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'D', 'D313');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'D', 'D321');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'D', 'D33');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'D', 'D34');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'D', 'D411');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'D', 'D421');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'D', 'D431');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'D', 'D511');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'D', 'D512');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'D', 'D52');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'D', 'D53');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A11');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A211');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A221');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A231');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A241');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A251');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A311');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A312');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A313');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A321');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A33');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A34');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A411');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A421');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A431');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A511');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A512');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A513');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A514');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A52');
insert into cvp.transf_info(operativo, agrupacion, grupo) values ('val_can', 'A', 'A53');

*/
/* --original 
create or replace view cvp.transf_data as 
select c.periodo, c.agrupacion, c.grupo, round(c.valorgru::numeric,2) as valorgruredondeado
  from cvp.calgru c
    inner join cvp.transf_info t on operativo='val_can' and c.agrupacion = t.agrupacion and c.grupo=t.grupo
    inner join cvp.calculos cal on cal.calculo=c.calculo and cal.periodo = c.periodo and cal.transmitir_canastas='S'
  order by 1,2,3,4;
  
grant select on cvp.transf_data to sieh;  

*/
--ahora la vista tiene valorgru y los promedios de los tres meses
create or replace view cvp.transf_data as 
select c.periodo, c.agrupacion, c.grupo, round(c.valorgru::numeric,2) as valorgruredondeado, round(c.valorgrupromedio::numeric, 2) AS valorgrupromedioredondeado
  from cvp.calgru_promedios c
    inner join cvp.transf_info t on operativo='val_can' and c.agrupacion = t.agrupacion and c.grupo=t.grupo
    inner join cvp.calculos cal on cal.calculo=c.calculo and cal.periodo = c.periodo and cal.transmitir_canastas='S'
  order by 1,2,3,4,5;
  
grant select on cvp.transf_data to sieh; 