/*select * from etiquetas.etiquetas_eah2012 limit 1;
select * from etiquetas."Rep3_4" limit 1;

select rep3_4."CP_2011_i", e12.* from etiquetas.etiquetas_eah2012 e12
join etiquetas."Rep3_4" rep3_4
on e12.ccodigo = rep3_4."CCODIGO" and e12.hn = rep3_4."HN"
where  rep3_4."CP_2011_i" is null

select cp_2012_i, count(*) from etiquetas.etiquetas_eah2012 where replica_i in (3,4) group by cp_2012_i ;
*/

--PEGAR codigo postal desde la ultima entrega
--update etiquetas.etiquetas_eah2012 e12 set cp_2012_i = rep1_2."CP_2011_i" from etiquetas."Rep1_2" rep1_2 where e12.ccodigo = rep1_2."CCODIGO" and e12.hn = rep1_2."HN"
--update etiquetas.etiquetas_eah2012 e12 set cp_2012_i = rep3_4."CP_2011_i" from etiquetas."Rep3_4" rep3_4 where e12.ccodigo = rep3_4."CCODIGO" and e12.hn = rep3_4."HN"
update etiquetas.etiquetas_eah2012 eti set cp_2012_i = rep5_6."CP_2011" from etiquetas."Rep5_6" rep5_6 where eti.ccodigo = rep5_6."CCODIGO" and eti.hn = rep5_6."HN"

--select * from etiquetas.etiquetas_eah2012 where replica_i in (3,4) and cp_2012_i is null;
--select hn::integer,* from etiquetas.etiquetas_eah2012 where replica_i in (3,4) and cp_2012_i is null;
select * from etiquetas.etiquetas_eah2012 where replica_i in (5,6) and cp_2012_i is null;			--1151/2860
select hn::integer,* from etiquetas.etiquetas_eah2012 where replica_i in (5,6) and cp_2012_i is null;


-- CAsteamos altura y codigo de calle para las nulas 
update etiquetas.etiquetas_eah2012 set hn_i=hn::integer where hn_i is null;
update etiquetas.etiquetas_eah2012 set ccodigo_i=ccodigo::integer where ccodigo_i is null;


--select * from etiquetas.calles_cp_e where calle like '%MAGA%'

--pegar desde la tabla de codigos postales 
update etiquetas.etiquetas_eah2012 e12 set cp_2012_i = cpe.cp::integer from etiquetas.calles_cp_e cpe where e12.ccodigo_i = cpe.indec_i and (e12.hn_i >= cpe.desde_i and e12.hn_i <= cpe.hasta_i) and cp_2012_i is null


--ver en CP si existe registro para la cale PAREJA ()CP es null)(
select * from etiquetas.calles_cp_e where calle like '%PARE%'

INSERT INTO etiquetas.calles_cp_e(
            detalle, calle, desde, hasta, cp, indec, catastro, obs, col, 
            desde_i, hasta_i, indec_i, error, columna)
    VALUES ("PAREJA 2101/5200", ?, ?, ?, ?, ?, ?, ?, ?, 
            ?, ?, ?, ?, ?);
"PAREJA 2101/5200";"PAREJA ";"2101";"5200";"1419";"7340";"17019";"";"";2101;5200;7340;"<NULL>";"ok"