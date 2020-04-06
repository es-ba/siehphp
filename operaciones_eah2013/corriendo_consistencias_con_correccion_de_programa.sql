create table operaciones.inconsistencias_20140521_previas as select * from encu.inconsistencias; -- 1760 -- 493 s/just

select count(*) from encu.inconsistencias where inc_justificacion is null;

create table operaciones.inconsistencias_20140521_02_corrida_previa as select * from encu.inconsistencias; -- 1793 -- 559 s/just

select count(*) from encu.inconsistencias where inc_justificacion is null;

create table operaciones.inconsistencias_20140521_03_corregidas_las_funciones as select * from encu.inconsistencias; -- 1793 -- 559 s/just

select count(*) from encu.inconsistencias where inc_justificacion is null;

create table operaciones.inconsistencias_20140521_04_corregido_el_php as select * from encu.inconsistencias; -- 1713 -- 557 s/just

select count(*) from encu.inconsistencias where inc_justificacion is null;

select v.*, n.* 
  from encu.inconsistencias n full outer join operaciones.inconsistencias_20140521_03_corregidas_las_funciones v
      on v.inc_ope=n.inc_ope and v.inc_con=n.inc_con and v.inc_enc=n.inc_enc
  where v.inc_ope is null or n.inc_ope is null
  order by coalesce(v.inc_con, n.inc_con)

select *
  from his.modificaciones inner join encu.tiempo_logico on mdf_tlg=tlg_tlg
  where mdf_pk like '%P7=4_b%'
  order by tlg_tlg desc;