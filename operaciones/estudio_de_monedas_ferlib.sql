select i2m, texto
      ,round(avg(i2),2)
      ,count(i2)
      ,count(i2m)
  from tipox.encuesta left join tipox.opciones_i2m on opcion=i2m
  group by i2m, texto
  order by 1

select o, *
  from tipox.encuesta
  where i2m=-9
  order by 1;

