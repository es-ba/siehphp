--AGREGAR INGRESOS IMPUTADOS A LA TABLA plana_i1_
-- 1- Crear y cargar tabla axiliar asociada al excel que entrega procesamiento. Definirla en el schema operaciones
   /*
   usar el paquete txt-to-sql. REvisar nulos y tipos de datos
   Agregar esquema operaciones al create e insert
   Revisar las variables involucradas que sean las mismas de siempre. Sino Actualizar
   
   *parametro nombre de la tabla auxiliar = nombre del archivo
    ptabla_auxiliar= etoi242_indiv_con_ing_imput
    
   *lista de variables: ioph_neto_imp, ioa_imp, ios_imp, i3_1x_imp, i3_2x_imp, i3_3x_imp, i3_4x_imp, i3_5x_imp, i3_6x_imp, i3_7x_imp, i3_10x_imp
        , i3_11x_imp, i3_12x_imp, i3_13x_imp, i3_31x_imp, i3_32x_imp, i3_81x_imp, i3_82x_imp, ioph_imp, iop_imp, iop_neto_imp, fexp 
        (fexp viene desde el excel y no se usa en el update)
 "i3_36x_imp"
 "i3_35x_imp"
 "i3_34x_imp"   y se elimina  "i3_1x_imp"
 */                          
--INSERT 0 4628               
--ptabla_auxiliar

---2- control conteo cantidad de registros involucrados
set search_path= encu, dbo, comun;
--todos las claves de la plana_i1_ estan en la planilla
select count(*) cant_i1auxi, (select count(*) from operaciones.ptabla_auxiliar)nreg_auxi 
from  encu.plana_i1_ i 
where  exists (select * from operaciones.p_tabla_auxiliar o where o.enc=i.pla_enc and o.hog=i.pla_hog and o.mie=i.pla_mie)
--4628	4628
select count(*) regaux_en_i1
  , (select count(*) from encu.plana_i1_) reg_i1
  , (select count(*) from operaciones."ptabla_auxiliar" ) auxi_excel
 from encu.plana_i1_ i 
 where  exists (select * from operaciones."ptabla_auxiliar"  o where o.enc=i.pla_enc and o.hog=i.pla_hog and o.mie=i.pla_mie)
--4628	4628	4628


--3- agregar campos a la tabla plana_i1_ y su his
set search_path= encu;
alter table plana_i1_
--alter table his.plana_i1_ 
add column	pla_ioph_neto_imp		integer,
add column	pla_ioa_imp		integer,
add column	pla_ios_imp		integer,
--add column	pla_i3_1x_imp		integer,
add column	pla_i3_36x_imp		integer,
add column	pla_i3_35x_imp		integer,
add column	pla_i3_34x_imp		integer,
add column	pla_i3_2x_imp		integer,
add column	pla_i3_3x_imp		integer,
add column	pla_i3_4x_imp		integer,
add column	pla_i3_5x_imp		integer,
add column	pla_i3_6x_imp		integer,
add column	pla_i3_7x_imp		integer,
add column	pla_i3_10x_imp		integer,
add column	pla_i3_11x_imp		integer,
add column	pla_i3_12x_imp		integer,
add column	pla_i3_13x_imp		integer,
add column	pla_i3_31x_imp		integer,
add column	pla_i3_32x_imp		integer,
add column	pla_i3_81x_imp		integer,
add column	pla_i3_82x_imp		integer,
add column	pla_ioph_imp		integer,
add column	pla_iop_imp		    integer,
add column	pla_iop_neto_imp	integer;


--4- carga
set search_path= encu, dbo, comun, public;
update encu.plana_i1_ i
set
   pla_ioph_neto_imp  = o.ioph_neto_imp ,
   pla_ioa_imp        = o.ioa_imp       ,
   pla_ios_imp        = o.ios_imp       ,
   --pla_i3_1x_imp      = o.i3_1x_imp     ,
   pla_i3_36x_imp     = o.i3_36x_imp    ,
   pla_i3_35x_imp     = o.i3_35x_imp    ,
   pla_i3_34x_imp     = o.i3_34x_imp    ,
   pla_i3_2x_imp      = o.i3_2x_imp     ,
   pla_i3_3x_imp      = o.i3_3x_imp     ,
   pla_i3_4x_imp      = o.i3_4x_imp     ,
   pla_i3_5x_imp      = o.i3_5x_imp     ,
   pla_i3_6x_imp      = o.i3_6x_imp     ,
   pla_i3_7x_imp      = o.i3_7x_imp     ,
   pla_i3_10x_imp     = o.i3_10x_imp    ,
   pla_i3_11x_imp     = o.i3_11x_imp    ,
   pla_i3_12x_imp     = o.i3_12x_imp    ,
   pla_i3_13x_imp     = o.i3_13x_imp    ,
   pla_i3_31x_imp     = o.i3_31x_imp    ,
   pla_i3_32x_imp     = o.i3_32x_imp    ,
   pla_i3_81x_imp     = o.i3_81x_imp    ,
   pla_i3_82x_imp     = o.i3_82x_imp    ,
   pla_ioph_imp       = o.ioph_imp      ,
   pla_iop_imp        = o.iop_imp       ,
   pla_iop_neto_imp   = o.iop_neto_imp  
from operaciones."ptabla_auxiliar"  o
where o.enc=i.pla_enc and o.hog=i.pla_hog and o.mie=i.pla_mie;
--UPDATE 4628

-- 5- control por sumas
select 'sumas_i1',
   sum(pla_ioph_neto_imp ),
   sum(pla_ioa_imp       ),
   sum(pla_ios_imp       ),
   --sum(pla_i3_1x_imp     ),
   sum(pla_i3_36x_imp     ),
   sum(pla_i3_35x_imp     ),
   sum(pla_i3_34x_imp     ),
   sum(pla_i3_2x_imp     ),
   sum(pla_i3_3x_imp     ),
   sum(pla_i3_4x_imp     ),
   sum(pla_i3_5x_imp     ),
   sum(pla_i3_6x_imp     ),
   sum(pla_i3_7x_imp     ),
   sum(pla_i3_10x_imp    ),
   sum(pla_i3_11x_imp    ),
   sum(pla_i3_12x_imp    ),
   sum(pla_i3_13x_imp    ),
   sum(pla_i3_31x_imp    ),
   sum(pla_i3_32x_imp    ),
   sum(pla_i3_81x_imp    ),
   sum(pla_i3_82x_imp    ),
   sum(pla_ioph_imp      ),
   sum(pla_iop_imp       ),
   sum(pla_iop_neto_imp  )
from encu.plana_i1_
union
 select 'auxi',
    sum(ioph_neto_imp ),
   sum(ioa_imp       ),
   sum(ios_imp       ),
   --sum(i3_1x_imp     ),
   sum(i3_36x_imp    ),
   sum(i3_35x_imp    ),
   sum(i3_34x_imp    ),
   sum(i3_2x_imp     ),
   sum(i3_3x_imp     ),
   sum(i3_4x_imp     ),
   sum(i3_5x_imp     ),
   sum(i3_6x_imp     ),
   sum(i3_7x_imp     ),
   sum(i3_10x_imp    ),
   sum(i3_11x_imp    ),
   sum(i3_12x_imp    ),
   sum(i3_13x_imp    ),
   sum(i3_31x_imp    ),
   sum(i3_32x_imp    ),
   sum(i3_81x_imp    ),
   sum(i3_82x_imp    ),
   sum(ioph_imp      ),
   sum(iop_imp       ),
   sum(iop_neto_imp  )
from operaciones."ptabla_auxiliar";
"auxi"	1566244665	29588500	71579200	304623999	45826750	2602000	130000	14119000	179000	6081000	3036000	3613000	1873000	10438100	240000	4388531	21247978	33465000	1568044665	1553900665	1552100665
"sumas_i1"	1566244665	29588500	71579200	304623999	45826750	2602000	130000	14119000	179000	6081000	3036000	3613000	1873000	10438100	240000	4388531	21247978	33465000	1568044665	1553900665	1552100665
"planilla"  1566244665  29588500	71579200	304623999	45826750	2602000	130000	14119000	179000	6081000	3036000	3613000	1873000	10438100	240000	4388531	21247978	33465000	1568044665	1553900665	1552100665

--6- activar en varcal
select * from varcal
where varcal_varcal in('ioph_neto_imp','ioa_imp','ios_imp',--'i3_1x_imp',
'i3_36x_imp', 'i3_35x_imp', 'i3_34x_imp','i3_2x_imp','i3_3x_imp',
'i3_4x_imp','i3_5x_imp','i3_6x_imp','i3_7x_imp','i3_10x_imp','i3_11x_imp','i3_12x_imp','i3_13x_imp','i3_31x_imp','i3_32x_imp','i3_81x_imp','i3_82x_imp','ioph_imp','iop_imp','iop_neto_imp')
order by 2;--21

update varcal set varcal_activa=true
where varcal_tipo='externo' and varcal_activa is false 
and varcal_varcal in ('ioph_neto_imp','ioa_imp','ios_imp',--'i3_1x_imp',
'i3_36x_imp', 'i3_35x_imp', 'i3_34x_imp','i3_2x_imp','i3_3x_imp','i3_4x_imp','i3_5x_imp','i3_6x_imp','i3_7x_imp','i3_10x_imp','i3_11x_imp','i3_12x_imp','i3_13x_imp','i3_31x_imp','i3_32x_imp','i3_81x_imp','i3_82x_imp','ioph_imp','iop_imp','iop_neto_imp')
--UPDATE 21

--7- actualizar instalacion desde la app
  -- esto permite que las variables agregadas puedan ser usadas en las grillas, tabulados, bases producidas
