select 
	case when ap.pla_enc is null then '1. no estaban el año anterior'
	  else '2. estaban el año anterior'
	  end 
	as casos
        , count(*) as cantidad
        , sum(case when dbo.cadena_normalizar(p.pla_nombre) is not distinct from dbo.cadena_normalizar(ap.pla_nombre) then 1 else 0 end) as coincide_nombre
        , sum(case when p.pla_edad is not distinct from ap.pla_edad+1 then 1 else 0 end) as coincide_edad
        , sum(case when p.pla_edad-ap.pla_edad between 0 and 2 then 1 else 0 end) as compatible_edad_mm1
        -- , sum(case when p.pla_f_nac_o is not distinct from ap.pla_f_nac_o then 1 else 0 end) as coincide_fecha_nacimiento
        , sum(case when i.pla_e6 is not distinct from ai.pla_e6 then 1 else 0 end) as coincide_nivel_educativo_actual
        , sum(case when i.pla_e12 is not distinct from ai.pla_e12 then 1 else 0 end) as coincide_nivel_educativo_cursado
  from encu.plana_s1_p p inner join encu.plana_tem_ t on t.pla_enc=p.pla_enc
     inner join encu.plana_i1_ i on i.pla_enc=p.pla_enc and i.pla_hog=p.pla_hog and i.pla_mie=p.pla_mie
     left join eah2012.plana_s1_p ap on ap.pla_enc=p.pla_enc and ap.pla_hog=p.pla_hog and ap.pla_mie=p.pla_mie
     left join eah2012.plana_i1_ ai on ap.pla_enc=ai.pla_enc and ap.pla_hog=ai.pla_hog and ap.pla_mie=ai.pla_mie
  where pla_replica in (3,4,5,6)
  group by 
	case when ap.pla_enc is null then '1. no estaban el año anterior'
	  else '2. estaban el año anterior'
	  end 
 order by 1,2
 