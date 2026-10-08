
--esto es para ETOI- para Eah es MUY SIMILAR pero se tiene que traer info de cuatro operativos
set role tedede_php;

CREATE OR REPLACE FUNCTION encu.seleccionar_supervision_operativos_anteriores(
    p_esquema_nuevo text,
    p_tabla_tem_anterior_ant text,
    p_tabla_tem_anterior text,
    p_dominio integer 
)
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_query text;
    v_conteo integer;
BEGIN

    v_query := format('
        select count(*)::integer from (
            select 
                t.pla_enc::text, 
                max(ps1) as ps1ori, 
                max(ps2) as ps2ori,
                t.pla_participacion,
                max(rs1) as rs1, 
                max(rs2) as rs2, 
                max(ps1) || (
                    case 
                        when coalesce(max(rs1), 0) in (1, 2) then ''1'' 
                        when coalesce(max(rs1), 0) = 3 then ''3''  
                        when coalesce(max(rs1), 0) = 4 then ''4'' 
                        when coalesce(max(rs1), 0) in (5, 6, 7, 8, 9) then ''5''  
                        when coalesce(max(rs1), 0) = 0 then null  
                        else ''I'' 
                    end
                ) as ps1,
                max(ps2) || (
                    case 
                        when coalesce(max(rs2), 0) in (1, 2) then ''1'' 
                        when coalesce(max(rs2), 0) = 3 then ''3''  
                        when coalesce(max(rs2), 0) = 4 then ''4'' 
                        when coalesce(max(rs2), 0) in (5, 6, 7, 8, 9) then ''5''  
                        when coalesce(max(rs2), 0) = 0 then null  
                        else ''I'' 
                    end
                ) as ps2
            from (
                select 
                    tft.pla_enc as pla_enc, 
                    tft.pla_rotaci_n_eah, 
                    tft.pla_rotaci_n_etoi,
                    tft.pla_participacion, 
                    t.pla_participacion, 
                    tft.pla_result_sup as rs1, 
                    null::integer as rs2, 
                    tft.pla_sup_aleat, 
                    tft.pla_sup_dirigida,
                    case when (tft.pla_sup_dirigida = 3 or tft.pla_sup_aleat = 3) then ''p'' else ''t'' end as ps1,
                    null::text as ps2,
                    tft.pla_rea_enc, 
                    tft.pla_rea_recu, 
                    tft.pla_rea
                from %1$I.%2$I tft
                inner join encu.plana_tem_ t on tft.pla_enc = t.pla_enc 
                where t.pla_participacion in (3) 
                  and t.pla_dominio = %4$L
                  and tft.pla_rotaci_n_eah = 1 
                  and (tft.pla_sup_aleat is not null or tft.pla_sup_dirigida is not null)
                  and tft.pla_rea in (1, 3) 
                  and t.pla_rotaci_n_eah = 1 
                union 
                select 
                    tfta.pla_enc as pla_enc, 
                    tfta.pla_rotaci_n_eah, 
                    tfta.pla_rotaci_n_etoi,
                    tfta.pla_participacion,
                    t.pla_participacion, 
                    case when tfta.pla_participacion = 1 then tfta.pla_result_sup else null end as rs1, 
                    case when tfta.pla_participacion = 2 then tfta.pla_result_sup else null end as rs2,
                    tfta.pla_sup_aleat, 
                    tfta.pla_sup_dirigida, 
                    case when tfta.pla_participacion = 1 then (case when (tfta.pla_sup_dirigida = 3 or tfta.pla_sup_aleat = 3) then ''p'' else ''t'' end) else null end as ps1, 
                    case when tfta.pla_participacion = 2 then (case when (tfta.pla_sup_dirigida = 3 or tfta.pla_sup_aleat = 3) then ''p'' else ''t'' end) else null end as ps2,
                    tfta.pla_rea_enc, 
                    tfta.pla_rea_recu, 
                    tfta.pla_rea
                from %1$I.%3$I tfta
                inner join encu.plana_tem_ t on tfta.pla_enc = t.pla_enc 
                where t.pla_participacion in (2, 3) 
                  and t.pla_dominio = %4$L 
                  and tfta.pla_rotaci_n_eah = 1 
                  and (tfta.pla_sup_aleat is not null or tfta.pla_sup_dirigida is not null)
                  and tfta.pla_rea in (1, 3)   
            ) x
            join encu.plana_tem_ t on x.pla_enc = t.pla_enc 
            group by t.pla_enc, t.pla_participacion
        ) total_registros',
        p_esquema_nuevo,          -- %1$I (Identificador)
        p_tabla_tem_anterior_ant,  -- %2$I (Identificador)
        p_tabla_tem_anterior,      -- %3$I (Identificador)
        p_dominio                  -- %4$L (Literal de valor)
    );

    EXECUTE v_query INTO v_conteo;

    RETURN v_conteo;
END;
$$;
ALTER FUNCTION encu.seleccionar_supervision_operativos_anteriores(text, text, text, integer)
    OWNER TO tedede_php;
/* ejemplo 
set search_path=encu;
select encu.seleccionar_supervision_operativos_anteriores(
    'operaciones_supervision' ,
    'platem_etoi262',
    'platem_eah2026',
    3) ;
    
*/    
CREATE OR REPLACE FUNCTION encu.actualizar_supervision_operativos_anteriores(
    p_esquema_nuevo text,
    p_tabla_tem_anterior_ant text,
    p_tabla_tem_anterior text,
    p_dominio integer 
)
RETURNS integer -- Retorna un número entero
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_query text;
    v_filas_afectadas integer;
BEGIN
    v_query := format('
        update encu.plana_tem_ t set pla_ps1=b.ps1, pla_ps2=b.ps2
        from (
        select 
                t.pla_enc, 
                max(ps1) as ps1ori, 
                max(ps2) as ps2ori,
                t.pla_participacion,
                max(rs1) as rs1, 
                max(rs2) as rs2, 
                max(ps1) || (
                    case 
                        when coalesce(max(rs1), 0) in (1, 2) then ''1'' 
                        when coalesce(max(rs1), 0) = 3 then ''3''  
                        when coalesce(max(rs1), 0) = 4 then ''4'' 
                        when coalesce(max(rs1), 0) in (5, 6, 7, 8, 9) then ''5''  
                        when coalesce(max(rs1), 0) = 0 then null  
                        else ''I'' 
                    end
                ) as ps1,
                max(ps2) || (
                    case 
                        when coalesce(max(rs2), 0) in (1, 2) then ''1'' 
                        when coalesce(max(rs2), 0) = 3 then ''3''  
                        when coalesce(max(rs2), 0) = 4 then ''4'' 
                        when coalesce(max(rs2), 0) in (5, 6, 7, 8, 9) then ''5''  
                        when coalesce(max(rs2), 0) = 0 then null  
                        else ''I'' 
                    end
                ) as ps2
            from (
                select 
                    tft.pla_enc as pla_enc, 
                    tft.pla_rotaci_n_eah, 
                    tft.pla_rotaci_n_etoi,
                    tft.pla_participacion, 
                    t.pla_participacion, 
                    tft.pla_result_sup as rs1, 
                    null::integer as rs2, 
                    tft.pla_sup_aleat, 
                    tft.pla_sup_dirigida,
                    case when (tft.pla_sup_dirigida = 3 or tft.pla_sup_aleat = 3) then ''p'' else ''t'' end as ps1,
                    null::text as ps2,
                    tft.pla_rea_enc, 
                    tft.pla_rea_recu, 
                    tft.pla_rea
                from %1$I.%2$I tft
                inner join encu.plana_tem_ t on tft.pla_enc = t.pla_enc 
                where t.pla_participacion in (3) 
                  and t.pla_dominio = %4$L
                  and tft.pla_rotaci_n_eah = 1 
                  and (tft.pla_sup_aleat is not null or tft.pla_sup_dirigida is not null)
                  and tft.pla_rea in (1, 3) 
                  and t.pla_rotaci_n_eah = 1 
                union 
                select 
                    tfta.pla_enc as pla_enc, 
                    tfta.pla_rotaci_n_eah, 
                    tfta.pla_rotaci_n_etoi,
                    tfta.pla_participacion,
                    t.pla_participacion, 
                    case when tfta.pla_participacion = 1 then tfta.pla_result_sup else null end as rs1, 
                    case when tfta.pla_participacion = 2 then tfta.pla_result_sup else null end as rs2,
                    tfta.pla_sup_aleat, 
                    tfta.pla_sup_dirigida, 
                    case when tfta.pla_participacion = 1 then (case when (tfta.pla_sup_dirigida = 3 or tfta.pla_sup_aleat = 3) then ''p'' else ''t'' end) else null end as ps1, 
                    case when tfta.pla_participacion = 2 then (case when (tfta.pla_sup_dirigida = 3 or tfta.pla_sup_aleat = 3) then ''p'' else ''t'' end) else null end as ps2,
                    tfta.pla_rea_enc, 
                    tfta.pla_rea_recu, 
                    tfta.pla_rea
                from %1$I.%3$I tfta
                inner join encu.plana_tem_ t on tfta.pla_enc = t.pla_enc 
                where t.pla_participacion in (2, 3) 
                  and t.pla_dominio = %4$L 
                  and tfta.pla_rotaci_n_eah = 1 
                  and (tfta.pla_sup_aleat is not null or tfta.pla_sup_dirigida is not null)
                  and tfta.pla_rea in (1, 3)  
           ) as x
        ,
        encu.plana_tem_ t
        where x.pla_enc=t.pla_enc
        group by t.pla_enc, t.pla_participacion 
        order by t.pla_enc    
        ) b
        where b.pla_enc= t.pla_enc and t.pla_participacion in (2,3)',
        p_esquema_nuevo,          -- %1$I (Identificador)
        p_tabla_tem_anterior_ant,  -- %2$I (Identificador)
        p_tabla_tem_anterior,      -- %3$I (Identificador)
        p_dominio                  -- %4$L (Literal de valor)
    );

    -- Ejecuta el UPDATE
    EXECUTE v_query;

    -- Obtiene la cantidad de filas modificadas
    GET DIAGNOSTICS v_filas_afectadas = ROW_COUNT;

    RETURN v_filas_afectadas;
END;
$$;
ALTER FUNCTION encu.actualizar_supervision_operativos_anteriores(text, text, text, integer)
    OWNER TO tedede_php;
    
/* ejemplo
set search_path=encu;
select encu.actualizar_supervision_operativos_anteriores(
    'operaciones_supervision' ,
    'platem_etoi262',
    'platem_eah2026',
    3) ;  
 */