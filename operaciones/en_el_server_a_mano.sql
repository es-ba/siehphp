-- Para adaptar el commit 595 y para poner los ID_prod en las bolsa ya cerradas

set search_path=yeah_2011, yeah, comun, public;

update yeah_2011.tem11 x
  set id_proc=nuevo_id
  from (select encues, row_number() over (order by bolsa, encues) as nuevo_id 
	          from yeah_2011.tem11 
			  where bolsa is not null) y
      where x.encues=y.encues;
