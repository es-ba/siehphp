##FUN
sincronizacion_tem_datos
##ESQ
encu
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path = encu, dbo, comun, public;

-- Function: encu.sincronizacion_tem_datos(text, integer)

-- DROP FUNCTION encu.sincronizacion_tem_datos(text, integer);

CREATE OR REPLACE FUNCTION encu.sincronizacion_tem_datos(p_ope text, p_enc integer, 
                            INOUT p_rea integer, 
                            INOUT p_norea integer,
                            INOUT p_rea_enc integer, 
                            INOUT p_norea_enc integer, 
                            INOUT p_con_dato_enc integer,    
                            INOUT p_rea_recu integer, 
                            INOUT p_norea_recu integer, 
                            INOUT p_con_dato_recu integer,
                            INOUT p_pob_tot integer, 
                            INOUT p_pob_pre integer,
                            INOUT p_hog_tot integer, 
                            INOUT p_hog_pre integer)
 RETURNS RECORD
 AS
$BODY$
DECLARE
    v_max_entrea    integer;
    v_min_entrea    integer;
    v_cod_recu      integer;
    v_norea         integer;
    v_rol           text;
    v_con_dato      integer;
    v_for_hogar     text;
    v_sentencia     text;
    v_where         text;
    v_n_entrea4     integer;    
BEGIN
    p_rea:=null;
    p_norea:=null;
    SELECT pla_cod_recu,pla_rol
        INTO v_cod_recu, v_rol
        FROM plana_tem_ t 
        WHERE pla_enc=p_enc;
    --PARA GENERALIZAR FORMULARIO DE LA PLANA_xx_
    select for_for into v_for_hogar from formularios where for_es_principal and for_ope=p_ope; 
    v_sentencia:= $$
        SELECT max(pla_total_h) as hog_tot, count(case when pla_entrea=1 then 1 else null end) as hog_pre,
               max(coalesce(pla_entrea,-1)) as max_entrea, min(coalesce(pla_entrea,-1)) as min_entrea,
               count(case when pla_entrea=4 then 1 else null end) as cant_entrea4                
    $$; 
    v_where:= $$
        WHERE pla_enc=$1
    $$;
    EXECUTE v_sentencia || ' FROM plana_' || v_for_hogar || '_ ' || v_where  INTO p_hog_tot, p_hog_pre, v_max_entrea, v_min_entrea, v_n_entrea4 using  p_enc;   
    v_sentencia:= $$
        SELECT nullif(
                (coalesce(pla_razon1,0)::text || 
                coalesce(case s1.pla_razon1 
                when 1 then case when s1.pla_razon2_1 > 0 then s1.pla_razon2_1 else '0' end::text 
                when 2 then case when s1.pla_razon2_2 > 0 then s1.pla_razon2_2 else '0' end::text 
                when 3 then case when s1.pla_razon2_3 > 0 then s1.pla_razon2_3 else '0' end::text 
                when 4 then case when s1.pla_razon2_4 > 0 then s1.pla_razon2_4 else '0' end::text 
                when 5 then case when s1.pla_razon2_5 > 0 then s1.pla_razon2_5 else '0' end::text 
                when 6 then case when s1.pla_razon2_6 > 0 then s1.pla_razon2_6 else '0' end::text
                when 7 then case when s1.pla_razon2_7 > 0 then s1.pla_razon2_7 else '0' end::text 
                when 8 then case when s1.pla_razon2_8 > 0 then s1.pla_razon2_8 else '0' end::text
                when 9 then case when s1.pla_razon2_9 > 0 then s1.pla_razon2_9 else '0' end::text                                
                when 99 then case when s1.pla_razon2_99 > 0 then s1.pla_razon2_99 else '0' end::text end,'0')),'00') 
    $$;
    v_where:= $$
        WHERE s1.pla_enc=$1 and s1.pla_hog=1
    $$;
    EXECUTE v_sentencia || ' FROM plana_' || v_for_hogar || '_ s1 ' || v_where INTO v_norea using p_enc;
    v_sentencia:= $$            
        SELECT count(distinct res_hog::text||'-'||res_mie::text) FROM respuestas 
    $$;
    v_where:=$$
        WHERE res_ope=$1 and res_enc=$2 and res_for=$3 and res_mat='' 
            and res_valor is not null and trim(res_valor)<>''
    $$;
    EXECUTE v_sentencia || v_where into p_pob_pre using p_ope, p_enc, 'I1'; -- OJO GENERALIZAR 
    v_sentencia:= $$
        SELECT count(distinct m.res_hog::text||'-'||m.res_mie::text) FROM respuestas m
    $$;
    v_where:= $$
        WHERE m.res_ope=$1 and m.res_enc=$2 and m.res_for=$3 and m.res_mat='P' 
            and (m.res_valor is not null or trim(m.res_valor)<>'')
    $$;
    if false /*ya no hay p7*/ then 
       v_where:= v_where || $$
            and m.res_mie in (
            SELECT res_mie FROM encu.respuestas
                WHERE res_ope=$1 and res_enc=$2 and res_for=$3 and res_mat='P' 
                    and res_hog=m.res_hog and res_mie=m.res_mie                
                    and res_var ='p7' 
                    and (res_valor is null or res_valor not in ('3','4')));
       $$;  
    end if;
    EXECUTE v_sentencia || v_where  into p_pob_tot using p_ope, p_enc, v_for_hogar;  
    if v_max_entrea=2 and v_min_entrea=2 then
        if v_cod_recu is null then
            p_rea:=0;
        else
            p_rea:=2;
        end if;
        p_norea:=v_norea;
    elsif v_max_entrea=v_min_entrea and v_max_entrea in (1,4,5) then
        if v_max_entrea in (4,5) then
            p_rea=v_max_entrea;
        else
            if v_cod_recu is null then
                p_rea:=1;
            else
                p_rea:=3;
            end if;
        end if;
    elsif v_n_entrea4>0 then
            p_rea=4;   
    else
        if v_cod_recu is null then
            p_rea:=0;
            p_norea:=10;
        else
            p_rea:=2;
            p_norea:=18;
        end if;            
    end if;
    SELECT distinct 1 into v_con_dato
      FROM encu.respuestas 
      WHERE res_ope=p_ope and res_enc=p_enc and res_for<>'TEM' and (res_valor is not null or trim(res_valor)<>'');
    v_con_dato:=coalesce (v_con_dato,0);
    IF v_rol='encuestador' THEN
        p_rea_enc=p_rea;
        p_norea_enc=p_norea;
        p_con_dato_enc=v_con_dato;
    END IF;
    IF v_rol='recuperador' THEN
        p_rea_recu=p_rea;
        p_norea_recu=p_norea;
        p_con_dato_recu=v_con_dato;
    END IF;    
END;
$BODY$
  LANGUAGE plpgsql ;
/*OTRA*/
ALTER FUNCTION encu.sincronizacion_tem_datos(text, integer,
                                            integer, 
                                            integer,
                                            integer, 
                                            integer, 
                                            integer,    
                                            integer, 
                                            integer, 
                                            integer,
                                            integer, 
                                            integer,
                                            integer, 
                                            integer)
  OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION encu.respuestas_sinc_tem_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  rvar  RECORD;
  p_ope text;
  p_enc integer;
    p_rea integer; 
    p_norea integer;
    p_rea_enc integer; 
    p_norea_enc integer; 
    p_con_dato_enc integer; 
    p_rea_recu integer; 
    p_norea_recu integer; 
    p_con_dato_recu integer;
    p_pob_tot integer; 
    p_pob_pre integer;
    p_hog_tot integer; 
    p_hog_pre integer;  
BEGIN
  IF new.res_for<>'TEM' and (
      new.res_valor is distinct from old.res_valor or 
      new.res_valesp is distinct from old.res_valesp or 
      new.res_valor_con_error is distinct from old.res_valor_con_error or 
      new.res_var in ('obs', 's1a1_obs')
  ) THEN
    p_ope:=new.res_ope;
    p_enc=new.res_enc;
    select pla_rea   ,
           pla_norea ,   
           pla_rea_enc      ,
           pla_norea_enc    ,
           pla_con_dato_enc ,
           pla_rea_recu     ,
           pla_norea_recu   ,
           pla_con_dato_recu,
           pla_pob_tot      ,
           pla_pob_pre      ,
           pla_hog_tot      ,
           pla_hog_pre    
        into p_rea   ,
                p_norea ,   
                p_rea_enc      ,
                p_norea_enc    ,
                p_con_dato_enc ,
                p_rea_recu     ,
                p_norea_recu   ,
                p_con_dato_recu,
                p_pob_tot      ,
                p_pob_pre      ,
                p_hog_tot      ,
                p_hog_pre
        from encu.plana_tem_
        where pla_enc= p_enc;
    rvar:= encu.sincronizacion_tem_datos(p_ope, p_enc
                                ,p_rea     
                                ,p_norea
                                ,p_rea_enc      
                                ,p_norea_enc    
                                ,p_con_dato_enc 
                                ,p_rea_recu     
                                ,p_norea_recu   
                                ,p_con_dato_recu
                                ,p_pob_tot      
                                ,p_pob_pre      
                                ,p_hog_tot      
                                ,p_hog_pre      
        ); 
    update encu.respuestas 
      set res_valor=rvar.p_rea
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='rea'
        and res_valor is distinct from rvar.p_rea::text;
    update encu.respuestas 
      set res_valor=rvar.p_norea
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='norea'
        and res_valor is distinct from rvar.p_norea::text;
    update encu.respuestas 
      set res_valor=rvar.p_rea_enc
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='rea_enc'
        and res_valor is distinct from rvar.p_rea_enc::text;
    update encu.respuestas 
      set res_valor=rvar.p_norea_enc
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='norea_enc'
        and res_valor is distinct from rvar.p_norea_enc::text;
    update encu.respuestas 
      set res_valor=rvar.p_con_dato_enc
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='con_dato_enc'
        and res_valor is distinct from rvar.p_con_dato_enc::text;
    update encu.respuestas 
      set res_valor=rvar.p_rea_recu
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='rea_recu'
        and res_valor is distinct from rvar.p_rea_recu::text;
    update encu.respuestas 
      set res_valor=rvar.p_norea_recu
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='norea_recu'
        and res_valor is distinct from rvar.p_norea_recu::text;
    update encu.respuestas 
      set res_valor=rvar.p_con_dato_recu
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='con_dato_recu'
        and res_valor is distinct from rvar.p_con_dato_recu::text;
    update encu.respuestas 
      set res_valor=rvar.p_pob_tot
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='pob_tot'
        and res_valor is distinct from rvar.p_pob_tot::text;
    update encu.respuestas 
      set res_valor=rvar.p_pob_pre
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='pob_pre'
        and res_valor is distinct from rvar.p_pob_pre::text;
    update encu.respuestas 
      set res_valor=rvar.p_hog_tot
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='hog_tot'
        and res_valor is distinct from rvar.p_hog_tot::text;
    update encu.respuestas 
      set res_valor=rvar.p_hog_pre
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='hog_pre'
        and res_valor is distinct from rvar.p_hog_pre::text;
  END IF;
RETURN new;
END;
$BODY$
  LANGUAGE plpgsql;
/*OTRA*/
ALTER FUNCTION encu.respuestas_sinc_tem_trg()
  OWNER TO tedede_php;
/*OTRA*/
