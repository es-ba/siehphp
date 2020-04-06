/*
-- activo todos los encuestadores y les pongo "X"

update encu.personal
  set per_activo=true
    , per_apellido=regexp_replace(per_apellido,'[A-Za-zÁÉÍÓÚáéíóúñÑ]','X','g');

select * 
  from encu.personal 
  where per_rol='encuestador'
  order by per_per;

update encu.respuestas
  set res_valor=case res_var when 'cod_enc' then per_per else 1 end
  from (
with encuestadores_libres as (
      select per_per, row_number() over (order by per_per) as orden_persona
        from encu.personal
        where per_rol='encuestador'
          and per_per not in 
          (select pla_cod_enc 
             from encu.plana_tem_ 
             where pla_estado=22)
        order by per_per),
    encuestas_libres as (
      select pla_enc, row_number() over (order by pla_enc) as orden_encuesta, pla_estado, pla_dispositivo_enc, pla_cod_enc
        from encu.plana_tem_
        where pla_estado=20
        limit 1000)
  select *
    from encuestas_libres inner join encuestadores_libres on orden_encuesta=orden_persona
        ) x
  where res_enc=pla_enc
    and res_ope='eah2014'
    and res_for='TEM'
    and res_mat=''
    and res_var in ('cod_enc', 'dispositivo_enc');

create table operaciones.capacitaciones (
  variable text primary key,
  valor text
);
alter table operaciones.capacitaciones owner to tedede_php;

insert into operaciones.capacitaciones (variable, valor) values ('prox_encuestador',1);

-- */ 

select * from operaciones.capacitaciones;