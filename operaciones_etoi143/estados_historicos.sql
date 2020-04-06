/*
drop table encu.estados_historicos;

create table encu.estados_historicos(
  esthis_estado varchar(10),
  esthis_fecha date,
  esthis_enc integer,
  primary key (esthis_fecha, esthis_enc)
);
*/
/*
insert into encu.estados_historicos( esthis_fecha, esthis_enc)
select fecha, pla_enc
  from (select '2013-10-04'::date + dias as fecha from generate_series(0,46,7) dias where '2013-10-04'::date + dias <=current_timestamp) fechas,
       encu.plana_tem_;
  -- 53830 encuestas
*/

update encu.estados_historicos 
  set esthis_estado=
    (select res_valor
       from encu.respuestas inner join encu.tiempo_logico on res_tlg=tlg_tlg
       where res_ope='eah2013'
         and res_for='TEM'
         and res_mat=''
         and res_enc=esthis_enc
         and res_var='estado'
         and tlg_momento>=esthis_fecha);

select esthis_fecha, count(esthis_estado)
  from encu.estados_historicos 
  group by esthis_fecha
  order by 1;
  
    lateral 
      (select hisres_enc, max(nuevo_valor) from
      (select hisres_enc, 
	lag(hisres_valor,-1,(
	    select res_valor
	      from encu.respuestas
	      where res_ope=hisres_ope
	        and res_for=hisres_for
	        and res_mat=hisres_mat
	        and res_enc=hisres_enc
	        and res_hog=hisres_hog
	        and res_mie=hisres_mie
	        and res_exm=hisres_exm
	        and res_var=hisres_var
	  )) 
	  over (partition by hisres_ope, hisres_for, hisres_mat, hisres_enc, hisres_hog, hisres_mie, hisres_exm, hisres_var order by hisres_tlg) as nuevo_valor,
	hisres_valesp,
	hisres_valor_con_error,
	hisres_tlg,
	tlg_momento,
	ses_usu
  from his.his_respuestas inner join encu.tiempo_logico on hisres_tlg=tlg_tlg inner join encu.sesiones on tlg_ses=ses_ses
  where hisres_ope='eah2013'
    and hisres_for='TEM'
    and hisres_mat=''
    and hisres_var='estado'
    and tlg_momento
  order by hisres_tlg)  x
  group by hisres_enc) y
limit 10;  
  
