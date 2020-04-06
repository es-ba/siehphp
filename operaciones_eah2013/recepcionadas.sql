select estado, cantidad, cantidad*100.0/sum(cantidad)over()
from(
  select 
         coalesce('recepcionadas '||case ok1 when '1' then 'válidas' when '2' then 'inválidas' else ok1 end,'no recepcionadas, completas:'||completa) 
         as estado
         , count(*) cantidad
    from tipox.encuesta
    group by 
         coalesce('recepcionadas '||case ok1 when '1' then 'válidas' when '2' then 'inválidas' else ok1 end,'no recepcionadas, completas:'||completa) 
    order by estado desc
  )x