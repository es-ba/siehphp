select distinct con_con,con_precondicion,con_rel,con_postcondicion,hisinc_justificacion,usu_rol from (
select  distinct c1.con_con , c1.con_precondicion, c1.con_rel,c1.con_postcondicion,c1.hisinc_justificacion, usu_rol,tlg_tlg
from (select distinct on (hisinc_justificacion) con_con,con_precondicion, con_rel,con_postcondicion, hisinc_justificacion,hisinc_autor_justificacion, max(hisinc_tlg) hisinc_tlg
from encu.consistencias 
inner join his.his_inconsistencias on hisinc_ope=con_ope and hisinc_con=con_con
where con_ope='eah2012' and hisinc_justificacion is not null
group by con_con, con_precondicion, con_rel,con_postcondicion,hisinc_justificacion,hisinc_autor_justificacion 
) c1
inner join encu.tiempo_logico on tlg_tlg=hisinc_tlg
inner join encu.sesiones      on ses_ses=tlg_ses
inner join encu.usuarios      on usu_usu=ses_usu
and usu_rol='coor_campo'
) c2 
--------------------------------------
UNION
select distinct con_con,con_precondicion,con_rel,con_postcondicion,hisinc_justificacion,usu_rol
from (select distinct c1.con_con , c1.con_precondicion, c1.con_rel,c1.con_postcondicion,c1.hisinc_justificacion, usu_rol,tlg_tlg
from (select distinct on (hisinc_justificacion) con_con,con_precondicion, con_rel,con_postcondicion, hisinc_justificacion,hisinc_autor_justificacion, max(hisinc_tlg) hisinc_tlg 
from encu.consistencias 
inner join his.his_inconsistencias on hisinc_ope=con_ope and hisinc_con=con_con
where con_ope='eah2012' and hisinc_justificacion is not null
group by con_con, con_precondicion, con_rel,con_postcondicion,hisinc_justificacion,hisinc_autor_justificacion 
) c1
inner join encu.tiempo_logico on tlg_tlg=hisinc_tlg
inner join encu.sesiones      on ses_ses=tlg_ses
inner join encu.usuarios      on usu_usu=ses_usu
and  usu_rol='subcoor_campo'
) c2 
--------------------------------------
UNION
select distinct con_con,con_precondicion,con_rel,con_postcondicion,hisinc_justificacion,usu_rol 
from (select distinct c1.con_con , c1.con_precondicion, c1.con_rel,c1.con_postcondicion,c1.hisinc_justificacion, usu_rol,tlg_tlg
from (select distinct on (hisinc_justificacion) con_con,con_precondicion, con_rel,con_postcondicion, hisinc_justificacion,hisinc_autor_justificacion, max(hisinc_tlg) hisinc_tlg
from encu.consistencias 
inner join his.his_inconsistencias on hisinc_ope=con_ope and hisinc_con=con_con
where con_ope='eah2012' and hisinc_justificacion is not null
group by con_con, con_precondicion, con_rel,con_postcondicion,hisinc_justificacion,hisinc_autor_justificacion 
) c1
inner join encu.tiempo_logico on tlg_tlg=hisinc_tlg
inner join encu.sesiones      on ses_ses=tlg_ses
inner join encu.usuarios      on usu_usu=ses_usu
and  usu_rol='recepcionista'
) c2 
--------------------------------------
UNION
select distinct con_con,con_precondicion,con_rel,con_postcondicion,hisinc_justificacion,usu_rol 
from (select distinct c1.con_con , c1.con_precondicion, c1.con_rel,c1.con_postcondicion,c1.hisinc_justificacion, usu_rol,tlg_tlg
from (select distinct on (hisinc_justificacion) con_con,con_precondicion, con_rel,con_postcondicion, hisinc_justificacion,hisinc_autor_justificacion, max(hisinc_tlg) hisinc_tlg
from encu.consistencias 
inner join his.his_inconsistencias on hisinc_ope=con_ope and hisinc_con=con_con
where con_ope='eah2012' and hisinc_justificacion is not null
group by con_con, con_precondicion, con_rel,con_postcondicion,hisinc_justificacion,hisinc_autor_justificacion 
) c1
inner join encu.tiempo_logico on tlg_tlg=hisinc_tlg
inner join encu.sesiones      on ses_ses=tlg_ses
inner join encu.usuarios      on usu_usu=ses_usu
and  usu_rol='mues_campo'
) c2 order by usu_rol,con_con,con_precondicion,con_postcondicion,hisinc_justificacion
