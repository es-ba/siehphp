--UTF8: SÍ;
ALTER TABLE encu.consistencias ALTER COLUMN con_postcondicion TYPE character varying(2100);
ALTER TABLE encu.consistencias ALTER COLUMN con_explicacion TYPE character varying(900);
CREATE OR REPLACE FUNCTION encu.generar_consistencias_filtro(poperativo text)
  RETURNS void AS
$BODY$
DECLARE
   rcons encu.consistencias%rowtype;
   r_saltadas RECORD;
BEGIN 
    DELETE FROM encu.inconsistencias
        WHERE inc_ope=poperativo and inc_con like 'flujo_f%';
    DELETE FROM encu.ano_con
        WHERE anocon_ope=poperativo and anocon_con like 'flujo_f%';
    DELETE FROM encu.con_var
        WHERE convar_ope=poperativo and convar_con like 'flujo_f%';
    DELETE FROM encu.consistencias
           WHERE con_ope=poperativo and con_con like 'flujo_f%';

    INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
                con_postcondicion,
                con_activa, con_explicacion, con_tipo, con_falsos_positivos,
                con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
        values( 'ut2016', 'flujo_f_f0', 'hog>1', '=>',
                'v2 is null and v2_esp is null and v4 is null and v5 is null and v5_esp is null and v6 is null and v7 is null and v12 is null',
                true, 'Filtro Vivienda', 'Auditoría', false,
                'ALTA', 'Recepción', 'flujo', 'Error', 1) ;
           
    r_saltadas=encu.variables_saltadas('ut2016', 'respondi', 'e1' );
      raise notice 'f1 str_saltadas_condicion % largo %', r_saltadas.psaltadas_cond_str, length(r_saltadas.psaltadas_cond_str) ; 
       rcons.con_ope=poperativo;
       rcons.con_con='flujo_f_' || 'f1' ;
       rcons.con_precondicion= 'edad<10';
       rcons.con_rel='=>';
       rcons.con_postcondicion=r_saltadas.psaltadas_cond_str; 
       rcons.con_explicacion='Filtro1 I1 T,  no debe ingresar '|| r_saltadas.psaltadas_str;
       execute encu.insert_consistencia_flujo(rcons.con_ope, rcons.con_con, rcons.con_precondicion, rcons.con_rel,
                            rcons.con_postcondicion, rcons.con_explicacion);
    INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
                con_postcondicion,
                con_activa, con_explicacion, con_tipo, con_falsos_positivos,
                con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
        values( 'ut2016', 'flujo_f_f2', 'edad<3', '=>',
            'e1 is null',
            true, 'Filtro2 I1 E, no debe ingresar e1', 'Auditoría', false,
            'ALTA', 'Recepción', 'flujo', 'Error', 1) ; 
    INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
            con_postcondicion,
            con_activa, con_explicacion, con_tipo, con_falsos_positivos,
            con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
        values( 'ut2016', 'flujo_f_f3', 'edad<14 or sexo=1', '=>',
            's28 is null and s29 is null and s30 is null and s31_anio is null and s31_mes is null',
            true, 'Filtro3 I1 SMM,  no debe ingresar s28, s29, s30, s31_anio, s31_mes', 'Auditoría', false,
            'ALTA', 'Recepción', 'flujo', 'Error', 1) ;
    
    --fv
    INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
            con_postcondicion,
            con_activa, con_explicacion, con_tipo, con_falsos_positivos,
            con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
        values( 'ut2016', 'flujo_fv_f0', 'hog>1', '=>',
            'informado(h1)',
            true, 'Con Filtro Vivienda, debe informar h1', 'Auditoría', false,
            'ALTA', 'Recepción', 'flujo', 'Error', 1) ;
    INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
                con_postcondicion,
                con_activa, con_explicacion, con_tipo, con_falsos_positivos,
                con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
        values( 'ut2016', 'flujo_fv_f2', 'edad<3', '=>',
            'informado(e2)',
            true, 'Con Filtro2 I1 E , debe informar e2', 'Auditoría', false,
            'ALTA', 'Recepción', 'flujo', 'Error', 1) ; 
    --f_v        
    INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
            con_postcondicion,
            con_activa, con_explicacion, con_tipo, con_falsos_positivos,
            con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
        values( 'ut2016', 'flujo_f_v_f0', 'hog=1', '=>',
            'informado(v2)',
            true, 'Filtro Vivienda sin salto, debe informar v2', 'Auditoría', false,
            'ALTA', 'Recepción', 'flujo', 'Error', 1) ;
    INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
                con_postcondicion,
                con_activa, con_explicacion, con_tipo, con_falsos_positivos,
                con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
        values( 'ut2016', 'flujo_f_v_f1', 'edad>=10', '=>',
            'informado(t1)',
            true, 'Filtro1 I1 T sin salto, debe ingresar t1', 'Auditoría', false,
            'ALTA', 'Recepción', 'flujo', 'Error', 1) ; 
   INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
                con_postcondicion,
                con_activa, con_explicacion, con_tipo, con_falsos_positivos,
                con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
        values( 'ut2016', 'flujo_f_v_f2', 'edad>=3', '=>',
            'informado(e1)',
            true, 'Filtro2 I1 T sin salto, debe ingresar e1', 'Auditoría', false,
            'ALTA', 'Recepción', 'flujo', 'Error', 1) ; 
   INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
                con_postcondicion,
                con_activa, con_explicacion, con_tipo, con_falsos_positivos,
                con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
        values( 'ut2016', 'flujo_f_v_f3', 'edad>=14 and sexo=2', '=>',
            'informado(s28)',
            true, 'Filtro3 I1 SMM sin salto, debe ingresar s28', 'Auditoría', false,
            'ALTA', 'Recepción', 'flujo', 'Error', 1) ; 
END
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION encu.generar_consistencias_filtro(text)
  OWNER TO tedede_php;                                    
