-- Function: encu.respuestas_a_planas_trg()

-- DROP FUNCTION encu.respuestas_a_planas_trg();

CREATE OR REPLACE FUNCTION encu.respuestas_a_planas_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_mal boolean:=false;
  v_sentencia text;
  v_sentencia_null text;
  v_valor text;
  v_valor_tsp timestamp without time zone;  
BEGIN
if new.res_ope = 'eah2013' then
  v_sentencia:='UPDATE encu.plana_'||new.res_for||'_'||new.res_mat||' SET "pla_'||new.res_var||'"=$1, pla_tlg=$2 WHERE pla_enc=$3 and pla_hog=$4 and pla_mie=$5 and pla_exm=$6 and  true';
  v_sentencia_null:='UPDATE encu.plana_'||new.res_for||'_'||new.res_mat||' SET "pla_'||new.res_var||'"=null, pla_tlg=$1 WHERE pla_enc=$2 and pla_hog=$3 and pla_mie=$4 and pla_exm=$5 and  true';
  v_valor:=case new.res_valesp when '//' then '-9' when '--' then '-1' else new.res_valor end;
  BEGIN
    if v_valor is null then
      EXECUTE v_sentencia_null USING new.res_tlg , new.res_enc, new.res_hog, new.res_mie, new.res_exm;
    elseif comun.es_fecha(v_valor) and new.res_for = 'TEM' then
      v_valor_tsp:=to_timestamp(v_valor, 'YYYY MM DD HH24:MI:SS');
     EXECUTE v_sentencia USING v_valor_tsp, new.res_tlg , new.res_enc, new.res_hog, new.res_mie, new.res_exm;
    elseif comun.es_numero(v_valor) then
      EXECUTE v_sentencia USING v_valor::integer, new.res_tlg , new.res_enc, new.res_hog, new.res_mie, new.res_exm;
    else
      BEGIN
        EXECUTE v_sentencia USING v_valor, new.res_tlg , new.res_enc, new.res_hog, new.res_mie, new.res_exm;
      EXCEPTION
        WHEN OTHERS THEN -- cuando es timestamp e intenta poner string 
            EXECUTE v_sentencia USING to_timestamp('1805-5-5', 'YYYY MM DD HH24:MI:SS'), new.res_tlg , new.res_enc, new.res_hog, new.res_mie, new.res_exm;
            new.res_valor_con_error:=new.res_valor;
            new.res_valor:=null; 
        END;
    end if;
  EXCEPTION 
    WHEN OTHERS THEN -- cuando es numero e intenta poner string
        EXECUTE v_sentencia USING  -5, new.res_tlg , new.res_enc, new.res_hog, new.res_mie, new.res_exm;
        new.res_valor_con_error:=new.res_valor;
        new.res_valor:=null;
  END;
  -- Comentar este insert al hacer una instalación:
  insert into his.his_respuestas (hisres_ope, hisres_for, hisres_mat, hisres_enc, hisres_hog, hisres_mie, hisres_exm, hisres_var, hisres_valor, hisres_valesp, hisres_valor_con_error, hisres_estado, hisres_anotaciones_marginales, hisres_tlg)
    values (new.res_ope, new.res_for, new.res_mat, new.res_enc, new.res_hog, new.res_mie, new.res_exm, new.res_var, new.res_valor, new.res_valesp, new.res_valor_con_error, new.res_estado, new.res_anotaciones_marginales, new.res_tlg);

  -- */
end if;
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION encu.respuestas_a_planas_trg()
  OWNER TO tedede_php;
