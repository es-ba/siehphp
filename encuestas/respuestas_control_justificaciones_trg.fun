##FUN
respuestas_control_justificaciones_trg
##ESQ
encu
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
CREATE OR REPLACE FUNCTION encu.respuestas_control_justificaciones_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_nojustificadas integer;
  v_select text;
  v_from text;
  v_where text;
  v_rol text;
  v_valor text;
  v_norea text;
  v_rol_verificado text;
  v_estado integer;
  v_nivel integer;
  v_f_ult_consist timestamp without time zone;
  v_f_ult_modif  timestamp without time zone;
BEGIN
-- se controla que no existan inconsistencias sin justificar según el nivel del momento
  if (new.res_var like 'verificado%' or new.res_var='fin_anacon') and new.res_valor = '1' then
    if new.res_var like 'verificado%' then
        v_rol_verificado:=substr(new.res_var,12);
        SELECT rol_ver_con_hasta_nivel INTO v_nivel 
            FROM encu.roles
            WHERE rol_rol = case  when v_rol_verificado in ('enc','recu','sup') then 'recepcionista'
                                  when v_rol_verificado='fin_campo' then 'subcoor_campo'
                                  else 'ana_ing' end;
    else
        SELECT rol_ver_con_hasta_nivel INTO v_nivel 
            FROM encu.roles
            WHERE rol_rol = 'procesamiento'; 
    end if;        
     v_nojustificadas := 0;
     SELECT COUNT(*) into v_nojustificadas 
       FROM encu.inconsistencias
       WHERE inc_ope= new.res_ope and inc_enc= new.res_enc and (inc_justificacion is null or trim(inc_justificacion)='')
             and inc_con <> 'opc_inconsistente' 
             and inc_nivel<=v_nivel ;
     if v_nojustificadas> 0 then
         raise 'NO SE PUEDE VERIFICAR LA ENCUESTA % TIENE % INCONSISTENCIAS SIN JUSTIFICAR',new.res_enc, v_nojustificadas;
     end if;
  end if;
  -- actualización
  if ((new.res_var like 'verificado%' and new.res_var not like '%_ac') or new.res_var='fin_anacon') and new.res_var <>'verificado_fin_campo' and (new.res_valor = '1' or new.res_valor = '4') then
     v_valor = null;
     v_select = $$
        SELECT res_valor
     $$;
     v_from := $$
        FROM encu.respuestas
     $$;
     v_where := $$
        WHERE res_ope = $1 AND res_for = $2 AND res_mat = $3 AND res_enc = $4 and res_hog = $5 AND 
              res_mie = $6 AND res_exm = $7 AND res_var = 'cod_'||split_part($8, '_', 2);        
        --PK DE encu.respuestas :res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, res_var
     $$;
     EXECUTE v_select||v_from||v_where INTO v_valor USING new.res_ope, new.res_for, new.res_mat, new.res_enc, new.res_hog, new.res_mie, new.res_exm, new.res_var;
     IF v_valor IS NULL THEN
         v_rol := case when new.res_var like '%_enc'    then 'ENCUESTADOR'
                       when new.res_var like '%_sup'    then 'SUPERVISOR'
                       when new.res_var like '%_recu'   then 'RECUPERADOR'
                       when new.res_var like '%_anacon' then 'ANACON'
                  end;          
         raise 'NO SE PUEDE VERIFICAR LA ENCUESTA % PORQUE NO SE HA ESPECIFICADO EL CODIGO DE %',new.res_enc, v_rol;
     END IF;
  end if;
  if new.res_var like 'verificado%' and new.res_valor = '1' then
        SELECT res_valor INTO v_norea
            FROM encu.respuestas
            WHERE res_ope = new.res_ope AND res_for = new.res_for AND res_mat = new.res_mat AND res_enc = new.res_enc and res_hog = new.res_hog AND 
            res_mie = new.res_mie AND res_exm = new.res_exm AND res_var = 'norea';
        if v_norea = '18' then
            raise 'NOREA=18 solo permite verificado=4';
        end if; 
        SELECT pla_estado into v_estado
            FROM encu.plana_tem_ 
            WHERE pla_enc = new.res_enc and pla_hog = new.res_hog and pla_mie = new.res_mie and pla_exm = new.res_exm;
        IF v_estado = 23 or v_estado = 24 or v_estado = 33 or v_estado = 34 then
            raise 'NO SE PUEDE VERIFICAR LA ENCUESTA % PORQUE SE ENCUENTRA EN ESTADO %',new.res_enc, v_estado;
        END IF;
        SELECT bit_fin 
            INTO v_f_ult_consist 
            FROM encu.bitacora 
            WHERE bit_proceso='correr_consistencias' 
                AND bit_parametros like '%"tra_enc":'||new.res_enc||',"tra_con":"#todo"%' 
                AND bit_fin IS NOT NULL
            ORDER BY bit_fin desc 
            LIMIT 1;
        select max(tlg_momento) 
            INTO v_f_ult_modif
            from encu.respuestas r join encu.tiempo_logico t on r.res_tlg=t.tlg_tlg 
            where res_ope=dbo.ope_actual() and res_enc=new.res_enc and res_for not in ('TEM','SUP') ;
        if v_f_ult_consist is null or v_f_ult_consist<v_f_ult_modif then
            raise 'NO SE PUEDE VERIFICAR LA ENCUESTA % PORQUE LAS CONSISTENCIAS ESTAN DESACTUALIZADAS! Debe consistir antes de verificar!',new.res_enc;
        end if;     
  end if;
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql STABLE;
/*OTRA*/
ALTER FUNCTION encu.respuestas_control_justificaciones_trg()
  OWNER TO tedede_php;
