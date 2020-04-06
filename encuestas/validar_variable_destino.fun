##FUN
validar_variable_destino
##ESQ
encu
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path= encu, comun, dbo, public;
CREATE OR REPLACE FUNCTION encu.validar_variable_destino(pope TEXT, pfor TEXT, pmat TEXT, porigen TEXT, pdestinosalto TEXT, pdestinovarpre text, OUT pvardestino TEXT, OUT ptipodestinosalto TEXT )
 AS
$BODY$
DECLARE
  vfiltro_orden bigint;
  vbloque_orden bigint;
  vfactorblo integer;
 -- vfactorpre integer;
BEGIN
vfactorblo=100000;
--vfactorpre=10000;
--argumento de salida: variable de salida y tipo=variable, pre, filtro    
IF pdestinosalto is distinct from 'fin' then
    IF pdestinovarpre IS NOT NULL THEN
        select 'pre' INTO ptipodestinosalto
            FROM encu.variables
            WHERE var_ope=pope and var_for=pfor and var_mat=pmat and var_var=pdestinovarpre;
        pvardestino=pdestinovarpre; -- sal_destino pregunta y ya se obtuvo la variable destino
    ELSE  
       --busco si sal_destino era ya una variable
        select var_var,'var' 
            INTO pvardestino, ptipodestinosalto 
            FROM encu.variables 
            WHERE var_ope=pope and var_var=pdestinosalto;
        if pvardestino is null then -- veo si es un filtro
            --supongo filtro del mismo formulario
            select blo_orden*vfactorblo+ fil_orden
                INTO vfiltro_orden 
                FROM encu.filtros join encu.bloques on fil_ope=blo_ope and fil_for=blo_for and fil_blo=blo_blo 
                WHERE fil_ope=pope and fil_for=pfor and fil_fil=pdestinosalto;
            if vfiltro_orden>0 then
                select var_var,'fil' 
                    into pvardestino, ptipodestinosalto
                    from encu.variables_ordenadas 
                    where var_ope=pope and var_for=pfor and (blo_orden*vfactorblo+ pre_orden) >vfiltro_orden
                    order by (blo_orden*vfactorblo+ pre_orden),coalesce(lpad(var_orden::text,10),comun.para_ordenar_numeros(var_var)::text)
                    limit 1;
            else
                --ver si es un bloque
                select blo_orden*vfactorblo
                    INTO vbloque_orden 
                    FROM encu.bloques
                    WHERE blo_ope=pope and blo_for=pfor and blo_blo=pdestinosalto;
                if vbloque_orden>0 then
                    select var_var,'blo' 
                        into pvardestino, ptipodestinosalto
                        from encu.variables_ordenadas 
                        where var_ope=pope and var_for=pfor and (blo_orden*vfactorblo+ pre_orden) >vbloque_orden
                        order by (blo_orden*vfactorblo+ pre_orden),coalesce(lpad(var_orden::text,10),comun.para_ordenar_numeros(var_var)::text)
                        limit 1;
                end if;    
            end if;
        end if;   
    END IF;
ELSE
    ptipodestinosalto='fin';   
END IF;
END;
$BODY$
LANGUAGE plpgsql;
/*otra*/
ALTER FUNCTION encu.validar_variable_destino(pope TEXT, pfor TEXT, pmat TEXT, porigen TEXT, pdestinosalto TEXT, pdestinovarpre text)
  OWNER TO tedede_php; 