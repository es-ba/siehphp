##FUN
generar_consistencias_completitud
##ESQ
encu
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path= encu, comun, dbo, public;
CREATE OR REPLACE FUNCTION encu.generar_consistencias_completitud()
  RETURNS void AS
$BODY$
DECLARE
    xoperativo             encu.consistencias.con_ope%type;
    xcon_activa            encu.consistencias.con_activa%type;
    xcon_tipo              encu.consistencias.con_tipo%type;
    xcon_falsos_positivos  encu.consistencias.con_falsos_positivos%type;  
    xcon_importancia       encu.consistencias.con_importancia%type;
    xcon_momento           encu.consistencias.con_momento%type;
    xcon_grupo             encu.consistencias.con_grupo%type;
    xcon_gravedad          encu.consistencias.con_gravedad%type;
    xcon_rel               encu.consistencias.con_rel%type;
BEGIN 
    xoperativo=dbo.ope_actual();
    -- Borrar las automaticas
    DELETE FROM encu.inconsistencias
        WHERE inc_ope= xoperativo    and inc_con like 'compl%';
    DELETE FROM encu.ano_con
        WHERE anocon_ope= xoperativo and anocon_con like 'compl%';
    DELETE FROM encu.con_var
        WHERE convar_ope= xoperativo and convar_con like 'compl%';
    DELETE FROM encu.consistencias
        WHERE con_ope= xoperativo    and con_con like 'compl%';
    xcon_activa=true;   
    xcon_tipo='Completitud';    
    xcon_falsos_positivos=false;
    xcon_importancia='ALTA';
    xcon_momento='Recepción';
    xcon_grupo=null; 
    xcon_gravedad='Error';    
    xcon_rel='=>';
    --xcon_modulo='RELACIONES';

    INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
                con_postcondicion,
                con_activa, con_explicacion, con_tipo, con_falsos_positivos,
                con_importancia, con_momento, con_grupo, con_gravedad, con_origen, con_tlg) VALUES
        (xoperativo, 'compl_S1','', xcon_rel,
            'entrea=2 and(razon1=1 and informado(razon2_1) or'
                ||' razon1=2 and informado(razon2_2) or' 
                ||' razon1=3 and informado(razon2_3) or' 
                ||' razon1=4 and informado(razon2_4) or' 
                ||' razon1=5 and informado(razon2_5) or' 
                ||' razon1=6 and informado(razon2_6) and (razon2_6<>4 or informado(razon3)) or'
                ||' razon1=7 and informado(razon2_7) or' 
                ||' razon1=8 and informado(razon2_8) or' 
                ||' razon1=9 and informado(razon2_9) ' 
                ||') or entrea=1 and total_h>0 and total_m>0 or entrea>2',
            xcon_activa,'Formulario S1 incompleto',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad,xoperativo, 1),
        (xoperativo, 'compl_S1_P','', xcon_rel,
            'informado(p4) and informado(edad) and edad>=0 and'
            ||' (edad<14 or informado(p5)) and'
            ||' (edad>24 or (informado(p6_a) and informado(p6_b)))',
            xcon_activa,'Formulario S1 renglón incompleto',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad,xoperativo, 1),
        (xoperativo, 'compl_A1','', xcon_rel,
            'informado(h3)',
            xcon_activa,'Formulario A1 incompleto',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad,xoperativo, 1),
        (xoperativo, 'compl_I1','', xcon_rel,
            'informado(sn16) and '
            ||' (edad<14 or sexo=1 or informado(s28))'
            ||' and (edad<14 or sexo=1 or s28=2 or informado(s31_anio))' ,
            xcon_activa,'Formulario I1 incompleto',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento, xcon_grupo,xcon_gravedad,xoperativo, 1),
       (xoperativo, 'compl_S1_faltante','entrea<>2', xcon_rel,
            'total_h = dbo.total_hogares(encues) and dbo.total_hogares(encues)>0',
            xcon_activa,'Formulario S1 faltante ',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad,xoperativo, 1),
       (xoperativo, 'compl_S1_P_faltante','entrea<>2', xcon_rel,
            'total_m = dbo.cant_s1p_x_hog(enc, hog) and dbo.cant_s1p_x_hog(enc, hog)>0',
            xcon_activa,'Formulario S1 renglon faltante ',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad,xoperativo, 1),
       (xoperativo, 'compl_A1_faltante','entrea<>2', xcon_rel,
            'total_h >= dbo.cant_a1(enc) and dbo.existe_a1(enc,hog)=1',
            xcon_activa,'Formulario A1 faltante ',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad,xoperativo, 1),
       (xoperativo, 'compl_I1_faltante','entrea<>2', xcon_rel,
            'total_m=dbo.cant_i1_x_hog(enc, hog) and dbo.cant_i1_x_hog(enc, hog)>0',
            xcon_activa,'Formulario I1 faltante ',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad,xoperativo, 1)
        ;
END;
$BODY$
LANGUAGE plpgsql ;
/*otra*/
ALTER FUNCTION encu.generar_consistencias_completitud()
  OWNER TO tedede_php;