
set search_path=encu, comun, public, dbo;
set search_path = encu, comun;

drop table edades;
CREATE TABLE edades 
  AS select edad from generate_series(0,75) edad;
ALTER TABLE edades 
  owner to tedede_php;  
  
CREATE OR REPLACE FUNCTION dbo.anio_diferencia(
    p_enc integer,
    p_hog integer,
    p_mie integer,
    p_edad integer,
    p_anio text)
  RETURNS integer AS
$BODY$
select case when p_anio is null  or p_anio in ('//','--' ) then  null::integer
            else (dbo.anionac(p_enc, p_hog, p_mie)+ p_edad - p_anio::integer)
       end;     
$BODY$
  LANGUAGE sql STABLE;
ALTER FUNCTION dbo.anio_diferencia(integer, integer, integer,integer, text)
  OWNER TO tedede_php;

CREATE OR REPLACE FUNCTION comun.cambia_nsnc_ignorado(dato text)
    RETURNS text  AS
    $$SELECT case dato when '//' then '-9' when '--' then '-1' else dato end$$
    LANGUAGE sql IMMUTABLE;
ALTER FUNCTION comun.cambia_nsnc_ignorado(text)
  OWNER TO tedede_php;


CREATE OR REPLACE FUNCTION dbo.pasar_a_vista(dato text, nom_var text)
    RETURNS text  AS
    $$SELECT case 
              when dato='//' or dato='--' then  comun.cambia_nsnc_ignorado(dato)
              when nom_var not in ('lugar3_detalle', 'trabajo3', 'trabajo4', 'trabajo5', 'cony2a', 'hijos2_nombre') 
                 and not comun.es_numero(dato) then '-5'
              else dato 
             end$$
    LANGUAGE sql STABLE;
ALTER FUNCTION dbo.pasar_a_vista(text, text)
  OWNER TO tedede_php;


CREATE OR REPLACE FUNCTION comun.last_agg_agg(p1 anyelement, p2 anyelement) RETURNS anyelement
  LANGUAGE SQL
AS
$SQL$
  SELECT coalesce(p2 ,p1);
$SQL$;

DROP AGGREGATE IF EXISTS last_agg(anyelement);

CREATE AGGREGATE comun.last_agg(anyelement) (
    sfunc = comun.last_agg_agg,
    stype = anyelement
);


DROP VIEW  if exists i1_retro_pre_vw;
CREATE  OR REPLACE  VIEW i1_retro_pre_vw AS
  SELECT *,
        nullif(jsonb_build_object(
            case when g2_anio_dif <>0 then 'lugar'      else 'borrar' end, g2_anio_dif,
            case when g3_anio_dif <>0 then 'vivienda'   else 'borrar' end, g3_anio_dif,
            case when g4_anio_dif <>0 then 'edu'        else 'borrar' end, g4_anio_dif,
            case when g5_anio_dif <>0 then 'trabajo'    else 'borrar' end, g5_anio_dif,
            case when g6_anio_dif <>0 then 'trabajo_no' else 'borrar' end, g6_anio_dif,
            case when g7_anio_dif <>0 then 'familiao'   else 'borrar' end, g7_anio_dif,
            case when g9_anio_dif <>0 then 'fpol'       else 'borrar' end, g9_anio_dif,
            case when g11_anio_dif<>0 then 'antic'      else 'borrar' end, g11_anio_dif,
            case when g12_anio_dif<>0 then 'disca'      else 'borrar' end, g12_anio_dif
        ) - 'borrar','{}'::jsonb) as errores_anio,
        nullif(case when abs(greatest(g2_anio_dif,g3_anio_dif,g4_anio_dif,g5_anio_dif,g6_anio_dif,g7_anio_dif,g9_anio_dif,g11_anio_dif,g12_anio_dif)) 
                        >= abs(least(g2_anio_dif,g3_anio_dif,g4_anio_dif,g5_anio_dif,g6_anio_dif,g7_anio_dif,g9_anio_dif,g11_anio_dif,g12_anio_dif))
                    then     greatest(g2_anio_dif,g3_anio_dif,g4_anio_dif,g5_anio_dif,g6_anio_dif,g7_anio_dif,g9_anio_dif,g11_anio_dif,g12_anio_dif) 
                    else    least(g2_anio_dif,g3_anio_dif,g4_anio_dif,g5_anio_dif,g6_anio_dif,g7_anio_dif,g9_anio_dif,g11_anio_dif,g12_anio_dif)
               end, 0) as max_error_anio
  FROM (
    SELECT  i.pla_enc
        ,i.pla_hog
        ,i.pla_mie
        ,e.edad as pla_edad
        ,dbo.anionac(i.pla_enc, i.pla_hog, i.pla_mie)+ e.edad pla_anio
        , dbo.anio_diferencia(i.pla_enc, i.pla_hog, i.pla_mie,e.edad, g2.anio) g2_anio_dif     
        , cambia_nsnc_ignorado(lugar3        )   pla_lugar3 
        , cambia_nsnc_ignorado(lugar3_detalle)   pla_lugar3_detalle
        , dbo.anio_diferencia(i.pla_enc, i.pla_hog, i.pla_mie,e.edad, g3.anio) g3_anio_dif     
        , cambia_nsnc_ignorado(vivienda2     )  pla_vivienda2 
        , cambia_nsnc_ignorado(vivienda3     )  pla_vivienda3 
        , cambia_nsnc_ignorado(vivienda4     )  pla_vivienda4 
        , cambia_nsnc_ignorado(vivienda5     )  pla_vivienda5 
        , cambia_nsnc_ignorado(vivienda6     )  pla_vivienda6 
        , cambia_nsnc_ignorado(vivienda7     )  pla_vivienda7
        --, g4.anio g4_anio   
        , dbo.anio_diferencia(i.pla_enc, i.pla_hog, i.pla_mie,e.edad, g4.anio) g4_anio_dif     
        , cambia_nsnc_ignorado(edu2          )  pla_edu2 
        , cambia_nsnc_ignorado(edu3          )  pla_edu3 
        , cambia_nsnc_ignorado(edu4          )  pla_edu4 
        , dbo.anio_diferencia(i.pla_enc, i.pla_hog, i.pla_mie,e.edad, g5.anio) g5_anio_dif     
        , cambia_nsnc_ignorado(trabajo3      )  pla_trabajo3  
        , cambia_nsnc_ignorado(trabajo4      )  pla_trabajo4  
        , cambia_nsnc_ignorado(trabajo5      )  pla_trabajo5  
        , cambia_nsnc_ignorado(trabajo6      )  pla_trabajo6  
        , cambia_nsnc_ignorado(trabajo7      )  pla_trabajo7  
        , cambia_nsnc_ignorado(trabajo8      )  pla_trabajo8  
        , cambia_nsnc_ignorado(trabajo9      )  pla_trabajo9  
        , cambia_nsnc_ignorado(trabajo10     )  pla_trabajo10 
        , dbo.anio_diferencia(i.pla_enc, i.pla_hog, i.pla_mie,e.edad, g6.anio) g6_anio_dif     
        , cambia_nsnc_ignorado(tno2a         )  pla_tno2a 
        , cambia_nsnc_ignorado(tno2b         )  pla_tno2b 
        , cambia_nsnc_ignorado(tno2c         )  pla_tno2c 
        , cambia_nsnc_ignorado(tno2d         )  pla_tno2d 
        , cambia_nsnc_ignorado(tno2e         )  pla_tno2e 
        , cambia_nsnc_ignorado(tno3          )  pla_tno3  
        , dbo.anio_diferencia(i.pla_enc, i.pla_hog, i.pla_mie,e.edad, g7.anio) g7_anio_dif     
        , cambia_nsnc_ignorado(familiao73    )  pla_familiao73 
        , cambia_nsnc_ignorado(familiao74    )  pla_familiao74 
        , cambia_nsnc_ignorado(familiao75    )  pla_familiao75 
        , cambia_nsnc_ignorado(familiao76    )  pla_familiao76 
        , dbo.anio_diferencia(i.pla_enc, i.pla_hog, i.pla_mie,e.edad, g9.anio) g9_anio_dif     
        , cambia_nsnc_ignorado(fpol1         )  pla_fpol1 
        , cambia_nsnc_ignorado(fpol2         )  pla_fpol2 
        , cambia_nsnc_ignorado(fpol3         )  pla_fpol3 
        , dbo.anio_diferencia(i.pla_enc, i.pla_hog, i.pla_mie,e.edad, g11.anio) g11_anio_dif     
        , cambia_nsnc_ignorado(concep        )  pla_concep        
        , dbo.anio_diferencia(i.pla_enc, i.pla_hog, i.pla_mie,e.edad, g12.anio) g12_anio_dif     
        , cambia_nsnc_ignorado(disca2a       )  pla_disca2a
        , cambia_nsnc_ignorado(disca2b       )  pla_disca2b
        , cambia_nsnc_ignorado(disca2c       )  pla_disca2c
        , cambia_nsnc_ignorado(disca2d       )  pla_disca2d
        , cambia_nsnc_ignorado(disca2e       )  pla_disca2e
        , cambia_nsnc_ignorado(disca2f       )  pla_disca2f
        , cambia_nsnc_ignorado(disca4        )  pla_disca4 
        FROM plana_i1_ i CROSS JOIN edades e
        LEFT JOIN LATERAL jsonb_to_recordset(((i.pla_lg2grilla::jsonb)->0)->'lineas' ) g2(edad integer, anio text, lugar3 text, lugar3_detalle text) ON g2.edad = e.edad
        LEFT JOIN  jsonb_to_recordset(((i.pla_v3grilla::jsonb)->0)->'lineas' )  g3(edad integer, anio text,
                vivienda2   text ,--integer,
                vivienda3   text, --integer,
                --vivienda3_o text,
                vivienda4   text ,--integer,
                vivienda5   text ,--integer,
                vivienda6   text ,--integer,
                vivienda7   text )--,integer)  
                ON g3.edad=e.edad
        LEFT JOIN  jsonb_to_recordset(((i.pla_e4grilla::jsonb)->0)->'lineas' )  g4(edad integer, anio text  /*integer*/,
            edu2        text ,--integer,
            edu3        text ,--integer,
            edu4        text )--integer)
            ON g4.edad=e.edad
        LEFT JOIN  jsonb_to_recordset(((i.pla_t5grilla::jsonb)->0)->'lineas' )  g5(edad integer, anio text  /*integer*/,
            trabajo3    text,
            trabajo4    text,
            trabajo5    text,
            trabajo6    text,--integer,
            trabajo7    text,--integer,
            trabajo8    text,--integer,
            trabajo9    text,--integer,
            trabajo10   text ) -- integer)
            ON g5.edad=e.edad
        LEFT JOIN  jsonb_to_recordset(((i.pla_tn6grilla::jsonb)->0)->'lineas' )  g6(edad integer, anio text  /*integer*/,
            tno2a       text , --integer,
            tno2b       text , --integer,
            tno2c       text , --integer,
            tno2d       text , --integer,
            tno2e       text , --integer,
            tno3        text ) --integer )
            ON g6.edad=e.edad
        LEFT JOIN  jsonb_to_recordset(((i.pla_fo7grilla::jsonb)->0)->'lineas' )  g7(edad integer, anio text  /*integer*/,
            familiao73  text, --integer,
            familiao74  text, --integer,
            familiao75  text, --integer,
            familiao76  text ) --integer)
            ON g7.edad=e.edad
        LEFT JOIN  jsonb_to_recordset(((i.pla_fp9grilla::jsonb)->0)->'lineas' )  g9(edad integer, anio text  /*integer*/,
            fpol1       text, --integer,
            fpol2       text, --integer,
            fpol3       text) --integer)    
            ON g9.edad=e.edad
        LEFT JOIN  jsonb_to_recordset(((i.pla_co11grilla::jsonb)->0)->'lineas' )  g11(edad integer, anio text  /*integer*/,    
            concep      text)
            ON g11.edad=e.edad
        LEFT JOIN  jsonb_to_recordset(((i.pla_d12grilla::jsonb)->0)->'lineas' )  g12(edad integer, anio text  /*integer*/,    
            disca2a     text, --    integer,
            disca2b     text, --    integer,
            disca2c     text, --    integer,
            disca2d     text, --    integer,   
            disca2e     text, --    integer,   
            disca2f     text, --    integer,   
            disca4      text) --   integer)
            ON g12.edad=e.edad
    ) x
--    where i.pla_enc= 949250  --trim(g4.anio) is null
    order by pla_enc, pla_hog, pla_mie, pla_edad;
;
ALTER TABLE encu.i1_retro_pre_vw
  OWNER TO tedede_php;


DROP VIEW  if exists i1_retro_vw;
CREATE  OR REPLACE  VIEW i1_retro_vw AS
  SELECT 
      pla_enc
     ,pla_hog
     ,pla_mie
     ,pla_edad
     ,pla_anio
    ,last_agg(pla_lugar3          ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_lr3
    ,last_agg(pla_lugar3_detalle  ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_lr3_esp
    ,last_agg(pla_vivienda2       ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_vi2
    ,last_agg(pla_vivienda3       ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_vi3
    ,last_agg(pla_vivienda4       ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_vi4
    ,last_agg(pla_vivienda5       ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_vi5
    ,last_agg(pla_vivienda6       ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_vi6
    ,last_agg(pla_vivienda7       ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_vi7
    ,last_agg(pla_edu2            ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_edu2
    ,last_agg(pla_edu3            ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_edu3
    ,last_agg(pla_edu4            ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_edu4
    ,last_agg(pla_trabajo3        ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_mt3
    ,last_agg(pla_trabajo4        ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_mt4
    ,last_agg(pla_trabajo5        ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_mt5
    ,last_agg(pla_trabajo6        ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_mt6
    ,last_agg(pla_trabajo7        ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_mt7
    ,last_agg(pla_trabajo8        ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_mt8
    ,last_agg(pla_trabajo9        ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_mt9
    ,last_agg(pla_trabajo10       ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_mt10
    ,last_agg(pla_tno2a           ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_tnr2a
    ,last_agg(pla_tno2b           ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_tnr2b
    ,last_agg(pla_tno2c           ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_tnr2c
    ,last_agg(pla_tno2d           ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_tnr2d
    ,last_agg(pla_tno2e           ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_tnr2e
    ,last_agg(pla_tno3            ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_tnr3 
    ,last_agg(pla_familiao73      ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_fo3
    ,last_agg(pla_familiao74      ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_fo4
    ,last_agg(pla_familiao75      ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_fo5
    ,last_agg(pla_familiao76      ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_fo6
    ,last_agg(pla_fpol1           ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_fp1
    ,last_agg(pla_fpol2           ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_fp2
    ,last_agg(pla_fpol3           ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_fp3
    ,last_agg(pla_concep          ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_antic1 
    ,last_agg(pla_disca2a         ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_dis2a
    ,last_agg(pla_disca2b         ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_dis2b
    ,last_agg(pla_disca2c         ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_dis2c
    ,last_agg(pla_disca2d         ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_dis2d
    ,last_agg(pla_disca2e         ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_dis2e
    ,last_agg(pla_disca2f         ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_dis2f
    ,last_agg(pla_disca4          ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad)   pla_dis4
  ,
        nullif(jsonb_build_object(
            case when g2_anio_dif <>0 then 'lugar'      else 'borrar' end, g2_anio_dif,
            case when g3_anio_dif <>0 then 'vivienda'   else 'borrar' end, g3_anio_dif,
            case when g4_anio_dif <>0 then 'edu'        else 'borrar' end, g4_anio_dif,
            case when g5_anio_dif <>0 then 'trabajo'    else 'borrar' end, g5_anio_dif,
            case when g6_anio_dif <>0 then 'trabajo_no' else 'borrar' end, g6_anio_dif,
            case when g7_anio_dif <>0 then 'familiao'   else 'borrar' end, g7_anio_dif,
            case when g9_anio_dif <>0 then 'fpol'       else 'borrar' end, g9_anio_dif,
            case when g11_anio_dif<>0 then 'antic'      else 'borrar' end, g11_anio_dif,
            case when g12_anio_dif<>0 then 'disca'      else 'borrar' end, g12_anio_dif
        ) - 'borrar','{}'::jsonb) as errores_anio,
        nullif(case when abs(greatest(g2_anio_dif,g3_anio_dif,g4_anio_dif,g5_anio_dif,g6_anio_dif,g7_anio_dif,g9_anio_dif,g11_anio_dif,g12_anio_dif)) 
                        >= abs(least(g2_anio_dif,g3_anio_dif,g4_anio_dif,g5_anio_dif,g6_anio_dif,g7_anio_dif,g9_anio_dif,g11_anio_dif,g12_anio_dif))
                    then     greatest(g2_anio_dif,g3_anio_dif,g4_anio_dif,g5_anio_dif,g6_anio_dif,g7_anio_dif,g9_anio_dif,g11_anio_dif,g12_anio_dif) 
                    else    least(g2_anio_dif,g3_anio_dif,g4_anio_dif,g5_anio_dif,g6_anio_dif,g7_anio_dif,g9_anio_dif,g11_anio_dif,g12_anio_dif)
               end, 0) as max_error_anio
  FROM (
    SELECT  i.pla_enc
        ,i.pla_hog
        ,i.pla_mie
        ,e.edad as pla_edad
        ,dbo.anionac(i.pla_enc, i.pla_hog, i.pla_mie)+ e.edad pla_anio
        , dbo.anio_diferencia(i.pla_enc, i.pla_hog, i.pla_mie,e.edad, g2.anio) g2_anio_dif     
        , dbo.pasar_a_vista(lugar3, 'lugar3'       )     ::integer pla_lugar3 
        , dbo.pasar_a_vista(lugar3_detalle,'lugar3_detalle')::text    pla_lugar3_detalle
        , dbo.anio_diferencia(i.pla_enc, i.pla_hog, i.pla_mie,e.edad, g3.anio) g3_anio_dif     
        , dbo.pasar_a_vista(vivienda2,'vivienda2')       ::integer pla_vivienda2 
        , dbo.pasar_a_vista(vivienda3,'vivienda3')       ::integer pla_vivienda3 
        , dbo.pasar_a_vista(vivienda4,'vivienda4')       ::integer pla_vivienda4 
        , dbo.pasar_a_vista(vivienda5,'vivienda5')       ::integer pla_vivienda5 
        , dbo.pasar_a_vista(vivienda6,'vivienda6')       ::integer pla_vivienda6 
        , dbo.pasar_a_vista(vivienda7,'vivienda7')       ::integer pla_vivienda7
        --, g4.anio g4_anio   
        , dbo.anio_diferencia(i.pla_enc, i.pla_hog, i.pla_mie,e.edad, g4.anio) g4_anio_dif     
        , dbo.pasar_a_vista(edu2,'edu2'  )               ::integer pla_edu2 
        , dbo.pasar_a_vista(edu3,'edu3'  )               ::integer pla_edu3 
        , dbo.pasar_a_vista(edu4,'edu4'  )               ::integer pla_edu4 
        , dbo.anio_diferencia(i.pla_enc, i.pla_hog, i.pla_mie,e.edad, g5.anio) g5_anio_dif     
        , dbo.pasar_a_vista(trabajo3 ,'trabajo3' )       ::text    pla_trabajo3  
        , dbo.pasar_a_vista(trabajo4 ,'trabajo4' )       ::text    pla_trabajo4  
        , dbo.pasar_a_vista(trabajo5 ,'trabajo5' )       ::text    pla_trabajo5  
        , dbo.pasar_a_vista(trabajo6 ,'trabajo6' )       ::integer pla_trabajo6  
        , dbo.pasar_a_vista(trabajo7 ,'trabajo7' )       ::integer pla_trabajo7  
        , dbo.pasar_a_vista(trabajo8 ,'trabajo8' )       ::integer pla_trabajo8  
        , dbo.pasar_a_vista(trabajo9 ,'trabajo9' )       ::integer pla_trabajo9  
        , dbo.pasar_a_vista(trabajo10,'trabajo10' )      ::integer pla_trabajo10 
        , dbo.anio_diferencia(i.pla_enc, i.pla_hog, i.pla_mie,e.edad, g6.anio) g6_anio_dif     
        , dbo.pasar_a_vista(tno2a,'tno2a')               ::integer pla_tno2a 
        , dbo.pasar_a_vista(tno2b,'tno2b')               ::integer pla_tno2b 
        , dbo.pasar_a_vista(tno2c,'tno2c')               ::integer pla_tno2c 
        , dbo.pasar_a_vista(tno2d,'tno2d')               ::integer pla_tno2d 
        , dbo.pasar_a_vista(tno2e,'tno2e')               ::integer pla_tno2e 
        , dbo.pasar_a_vista(tno3 ,'tno3')                ::integer pla_tno3  
        , dbo.anio_diferencia(i.pla_enc, i.pla_hog, i.pla_mie,e.edad, g7.anio) g7_anio_dif     
        , dbo.pasar_a_vista(familiao73, 'familiao73')    ::integer pla_familiao73 
        , dbo.pasar_a_vista(familiao74, 'familiao74')    ::integer pla_familiao74 
        , dbo.pasar_a_vista(familiao75, 'familiao75')    ::integer pla_familiao75 
        , dbo.pasar_a_vista(familiao76, 'familiao76')    ::integer pla_familiao76 
        , dbo.anio_diferencia(i.pla_enc, i.pla_hog, i.pla_mie,e.edad, g9.anio) g9_anio_dif     
        , dbo.pasar_a_vista(fpol1, 'fpol1')              ::integer pla_fpol1 
        , dbo.pasar_a_vista(fpol2, 'fpol2')              ::integer pla_fpol2 
        , dbo.pasar_a_vista(fpol3, 'fpol3')              ::integer pla_fpol3 
        , dbo.anio_diferencia(i.pla_enc, i.pla_hog, i.pla_mie,e.edad, g11.anio) g11_anio_dif     
        , dbo.pasar_a_vista(concep, 'concep')            ::integer pla_concep        
        , dbo.anio_diferencia(i.pla_enc, i.pla_hog, i.pla_mie,e.edad, g12.anio) g12_anio_dif     
        , dbo.pasar_a_vista(disca2a,'disca2a')           ::integer pla_disca2a
        , dbo.pasar_a_vista(disca2b,'disca2b')           ::integer pla_disca2b
        , dbo.pasar_a_vista(disca2c,'disca2c')           ::integer pla_disca2c
        , dbo.pasar_a_vista(disca2d,'disca2d')           ::integer pla_disca2d
        , dbo.pasar_a_vista(disca2e,'disca2e')           ::integer pla_disca2e
        , dbo.pasar_a_vista(disca2f,'disca2f')           ::integer pla_disca2f
        , dbo.pasar_a_vista(disca4 ,'disca4')           ::integer pla_disca4 
        FROM plana_i1_ i CROSS JOIN edades e
        LEFT JOIN LATERAL jsonb_to_recordset(((i.pla_lg2grilla::jsonb)->0)->'lineas' ) g2(edad integer, anio text, lugar3 text, lugar3_detalle text) ON g2.edad = e.edad
        LEFT JOIN  jsonb_to_recordset(((i.pla_v3grilla::jsonb)->0)->'lineas' )  g3(edad integer, anio text,
                vivienda2   text ,--integer,
                vivienda3   text, --integer,
                --vivienda3_o text,
                vivienda4   text ,--integer,
                vivienda5   text ,--integer,
                vivienda6   text ,--integer,
                vivienda7   text )--,integer)  
                ON g3.edad=e.edad
        LEFT JOIN  jsonb_to_recordset(((i.pla_e4grilla::jsonb)->0)->'lineas' )  g4(edad integer, anio text  /*integer*/,
            edu2        text ,  --integer,
            edu3        text ,  --integer,
            edu4        text )  --integer)
            ON g4.edad=e.edad
        LEFT JOIN  jsonb_to_recordset(((i.pla_t5grilla::jsonb)->0)->'lineas' )  g5(edad integer, anio text  /*integer*/,
            trabajo3    text,
            trabajo4    text,
            trabajo5    text,
            trabajo6    text,   --integer,
            trabajo7    text,   --integer,
            trabajo8    text,   --integer,
            trabajo9    text,   --integer,
            trabajo10   text )  -- integer)
            ON g5.edad=e.edad
        LEFT JOIN  jsonb_to_recordset(((i.pla_tn6grilla::jsonb)->0)->'lineas' )  g6(edad integer, anio text  /*integer*/,
            tno2a       text ,  --integer,
            tno2b       text ,  --integer,
            tno2c       text ,  --integer,
            tno2d       text ,  --integer,
            tno2e       text ,  --integer,
            tno3        text )  --integer )
            ON g6.edad=e.edad
        LEFT JOIN  jsonb_to_recordset(((i.pla_fo7grilla::jsonb)->0)->'lineas' )  g7(edad integer, anio text  /*integer*/,
            familiao73  text,   --integer,
            familiao74  text,   --integer,
            familiao75  text,   --integer,
            familiao76  text )  --integer)
            ON g7.edad=e.edad
        LEFT JOIN  jsonb_to_recordset(((i.pla_fp9grilla::jsonb)->0)->'lineas' )  g9(edad integer, anio text  /*integer*/,
            fpol1       text,   --integer,
            fpol2       text,   --integer,
            fpol3       text)   --integer)    
            ON g9.edad=e.edad
        LEFT JOIN  jsonb_to_recordset(((i.pla_co11grilla::jsonb)->0)->'lineas' )  g11(edad integer, anio text  /*integer*/,    
            concep      text)
            ON g11.edad=e.edad
        LEFT JOIN  jsonb_to_recordset(((i.pla_d12grilla::jsonb)->0)->'lineas' )  g12(edad integer, anio text  /*integer*/,    
            disca2a     text,   --integer,
            disca2b     text,   --integer,
            disca2c     text,   --integer,
            disca2d     text,   --integer,   
            disca2e     text,   --integer,   
            disca2f     text,   --integer,   
            disca4      text)   --integer)
            ON g12.edad=e.edad
    ) x
    where pla_anio <=dbo.anio()
    order by pla_enc, pla_hog, pla_mie, pla_edad;
ALTER TABLE encu.i1_retro_vw
  OWNER TO tedede_php;
GRANT SELECT ON TABLE encu.i1_retro_vw TO eder2017_ro;

--como rellenar
    select pla_enc, pla_hog, pla_mie, pla_edad, pla_anio
       , pla_lugar3         , last_agg(pla_lugar3        ) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad) as pla_lugar3_r
       , pla_lugar3_detalle , last_agg(pla_lugar3_detalle) over (partition by pla_enc, pla_hog, pla_mie order by pla_edad) as pla_lugar3_detalle_r
       , *
  from encu.i1_retro_vw 
  order by pla_enc, pla_hog, pla_mie, pla_edad
  limit 100;
    

select *
from encu.i1_retro_vw;

-- conyuges
DROP VIEW  if exists conyuges_vw;
CREATE  OR REPLACE  VIEW encu.conyuges_vw AS
with g8_js as (
  SELECT  i.pla_enc,
    i.pla_hog,
    i.pla_mie,
    i.pla_co8grilla,
    x.*
    FROM plana_i1_ i ,
    lateral jsonb_to_recordset(i.pla_co8grilla::jsonb) x (lineas jsonb, fijas jsonb) 
)    
select pla_enc,
    pla_hog,
    pla_mie,
    row_number() OVER (PARTITION BY pla_enc, pla_hog, pla_mie) pla_conyuge,
    dbo.pasar_a_vista(x.cony2a,'cony2a') ::text    pla_tc2a,
    dbo.pasar_a_vista(x.cony2b,'cony2b') ::integer pla_tc2b
    from g8_js, LATERAL jsonb_to_record(fijas) x (cony2a text, cony2b text)
order by 1,2,3,4 ;
GRANT SELECT ON TABLE encu.conyuges_vw TO eder2017_ro;

-- hijos
DROP VIEW encu.hijos_vw;
CREATE  OR REPLACE  VIEW encu.hijos_vw AS
with g10_js as (
  SELECT  i.pla_enc,
    i.pla_hog,
    i.pla_mie,
    i.pla_h10grilla,
    x.*
    FROM plana_i1_ i  ,
    lateral jsonb_to_recordset(i.pla_h10grilla::jsonb) x (lineas jsonb, fijas jsonb) 
)    
select pla_enc,
    pla_hog,
    pla_mie,
    row_number() OVER (PARTITION BY pla_enc, pla_hog, pla_mie) pla_hijo,
    dbo.pasar_a_vista(x.hijos2_nombre,'hijos2_nombre') ::text    pla_hj2nombre, 
    dbo.pasar_a_vista(x.hijos2       ,'hijos2')        ::integer pla_hj2,
    dbo.pasar_a_vista(x.hijos3       ,'hijos3')        ::integer pla_hj3,
    dbo.pasar_a_vista(x.hijos4       ,'hijos4')        ::integer pla_hj4,
    dbo.pasar_a_vista(x.hijos5       ,'hijos5')        ::integer pla_hj5,
    dbo.pasar_a_vista(x.hijos6       ,'hijos6')        ::integer pla_hj6,
    dbo.pasar_a_vista(x.hijos6_aniof ,'hijos6_aniof')  ::integer pla_hj6_af
    from g10_js, LATERAL jsonb_to_record(fijas) x (  hijos2_nombre text,
              hijos2 text,--integer,
              hijos3 text, --integer,
              hijos4 text, --integer,
              hijos5 text, --integer,
              hijos6 text,
              hijos6_aniof text              
)
order by 1,2,3,4 ;
ALTER TABLE encu.hijos_vw
  OWNER TO tedede_php;
GRANT SELECT ON TABLE encu.hijos_vw TO eder2017_ro;  


-- retro conyuges
DROP VIEW if exists encu.conyuges_retro_vw;
CREATE OR REPLACE VIEW encu.conyuges_retro_vw AS 
select pla_enc
    , pla_hog
    , pla_mie
    , pla_conyuge
    , pla_edad
    , pla_anio
    , last_agg(pla_cony3) over (partition by pla_enc, pla_hog, pla_mie, pla_conyuge order by pla_edad) pla_cony3
    , last_agg(pla_cony6) over (partition by pla_enc, pla_hog, pla_mie, pla_conyuge order by pla_edad) pla_cony6
    , pla_cony3 pla_cony3_orig
    , pla_cony6 pla_cony6_orig
    , nullif(pla_g8_anio_dif,0) errores_anio
from(
 WITH g8_js AS (
         SELECT i.pla_enc,
            i.pla_hog,
            i.pla_mie,
            i.pla_co8grilla,
            row_number() OVER (PARTITION BY pla_enc, pla_hog, pla_mie ) pla_conyuge,
            x_1.lineas,
            x_1.fijas
           FROM encu.plana_i1_ i,
            LATERAL jsonb_to_recordset(i.pla_co8grilla::jsonb) x_1(lineas jsonb, fijas jsonb)
        )
 SELECT g8_js.pla_enc
    ,g8_js.pla_hog
    ,g8_js.pla_mie
    --,x.cony2a
    --,x.cony2b
    ,g8_js.pla_conyuge
    ,e.edad pla_edad
    ,dbo.anionac(pla_enc, pla_hog, pla_mie)+ e.edad pla_anio
    ,dbo.anio_diferencia(pla_enc, pla_hog, pla_mie,g8.edad, g8.anio) pla_g8_anio_dif
--    g8.anio,
    ,dbo.pasar_a_vista(cony3, 'cony3')::integer pla_cony3
    ,dbo.pasar_a_vista(cony6, 'cony6')::integer pla_cony6
    ,g8_js.lineas
   FROM g8_js CROSS JOIN edades e
    --LATERAL jsonb_to_record(g8_js.fijas) x(cony2a text, cony2b text),
    LEFT JOIN LATERAL jsonb_to_recordset(g8_js.lineas) g8(edad integer, anio text, cony3 text, cony6 text) on g8.edad=e.edad
   where e.edad>=10 
) as c 
  where pla_anio<=dbo.anio()  
  ORDER BY pla_enc, pla_hog, pla_mie,pla_conyuge, pla_edad;
ALTER TABLE encu.conyuges_retro_vw
  OWNER TO tedede_php;
GRANT SELECT ON TABLE encu.conyuges_retro_vw TO eder2017_ro;   
 


--retro_hijos
with g10_js as (
  SELECT  i.pla_enc,
    i.pla_hog,
    i.pla_mie,
    i.pla_h10grilla,
    x.*
    FROM plana_i1_ i  ,
    lateral jsonb_to_recordset(i.pla_h10grilla::jsonb) x (lineas jsonb, fijas jsonb) 
)    
select pla_enc,
    pla_hog,
    pla_mie,
    row_number() OVER (PARTITION BY pla_enc, pla_hog, pla_mie ORDER BY hijos2) pla_hijo,--- ???? cual es la clave???
    edad,
    anio,
    hijos7 -- hj7
    from g10_js, LATERAL jsonb_to_recordset(lineas) g10 (edad integer, anio text,
        hijos7 integer
)
order by 1,2,3,4,5 ;


set search_path=encu, comun, public, dbo;
DROP VIEW if exists encu.hijos_retro_vw;
CREATE OR REPLACE VIEW encu.hijos_retro_vw AS 
select pla_enc
    , pla_hog
    , pla_mie
    , pla_hijo
    , pla_edad
    , pla_anio
    , last_agg(pla_hijos7) over (partition by pla_enc, pla_hog, pla_mie, pla_hijo order by pla_edad)   pla_hj7
    , pla_hijos7 pla_hj7_orig
    , nullif(pla_g10_anio_dif,0) errores_anio
from(
 WITH g10_js AS (
         SELECT i.pla_enc,
            i.pla_hog,
            i.pla_mie,
            i.pla_h10grilla,
            row_number() OVER (PARTITION BY pla_enc, pla_hog, pla_mie ) pla_hijo,
            x_1.lineas,
            x_1.fijas
           FROM encu.plana_i1_ i,
            LATERAL jsonb_to_recordset(i.pla_h10grilla::jsonb) x_1(lineas jsonb, fijas jsonb)
        )
 SELECT g10_js.pla_enc
    ,g10_js.pla_hog
    ,g10_js.pla_mie
    ,g10_js.pla_hijo
    ,e.edad pla_edad
    ,dbo.anionac(pla_enc, pla_hog, pla_mie)+ e.edad pla_anio
    ,dbo.anio_diferencia(pla_enc, pla_hog, pla_mie,e.edad, g10.anio) pla_g10_anio_dif
    ,dbo.pasar_a_vista(hijos7, 'hijos7')::integer pla_hijos7
    ,g10_js.lineas
   FROM g10_js CROSS JOIN edades e
    /* 
    LATERAL jsonb_to_record(g10_js.fijas) x( hijos2_nombre text,
              hijos2 text,
              hijos3 text,
              hijos4 text,
              hijos5 text,
              hijos6 text,
              hijos6_aniof text),
    */          
        LEFT JOIN LATERAL jsonb_to_recordset(g10_js.lineas) g10(edad integer, anio text,
            hijos7 text) ON g10.edad=e.edad
    WHERE  e.edad>=10
) as c 
  WHERE  pla_anio<=dbo.anio()   
  ORDER BY pla_enc, pla_hog, pla_mie,pla_hijo, pla_edad;
ALTER TABLE encu.hijos_retro_vw
  OWNER TO tedede_php;
GRANT SELECT ON TABLE encu.hijos_retro_vw TO eder2017_ro;

--select * from encu.hijos_retro_vw
