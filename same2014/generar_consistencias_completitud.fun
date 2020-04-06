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
                con_importancia, con_momento, con_grupo, con_gravedad, con_tlg) VALUES
        (xoperativo, 'compl_S1','', xcon_rel,
            'entrea=2 and(razon1=1 and informado(razon2_1) or'
                ||' razon1=2 and informado(razon2_2) or' 
                ||' razon1=3 and informado(razon2_3) or' 
                ||' razon1=4 and informado(razon2_4) or' 
                ||' razon1=5 and informado(razon2_5) or' 
                ||' razon1=6 and informado(razon2_6) and (razon2_6<>4 or informado(razon3)) or'
                ||' razon1=7 and informado(razon2_7) or' 
                ||' razon1=8 and informado(razon2_8) or' 
                ||' razon1=9 and informado(razon2_9) or' 
                ||' razon1=99 and informado(razon2_99) ' 
                ||') or entrea=1 and informado(cr_num_miembro) and (cr_num_miembro=1 and (informado(it1) or nsnc(it1) is false or (informado(it2)))'
                                  ||' or jht3=1 or jht9=1 or jht10=1 or jht11=1 or jht11=2 or jht11=3 or (jht11=4 and (jht11<>4 or informado(jht11_esp)))'
                                  ||' or jht45=3 or jht46=1 or jht46=2 or jht46=3 or informado(jht29c))'
                ||' or entrea>2',
            xcon_activa,'Formulario S1 incompleto',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad, 1),
        (xoperativo, 'compl_S1_P','', xcon_rel,
            'informado(sn1b_1) and informado(sn1b_7) and informado(sn1b_2) and informado(sn1b_3) and informado(sn1b_4) and informado(sn1b_5) ',
            xcon_activa,'Formulario S1 renglón miembro incompleto',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad, 1),
        (xoperativo, 'compl_I1','', xcon_rel,
            '(entreaind=2 and (noreaind=7 or noreaind=8 or noreaind=9) and (noreaind<>9 or informado(noreaind_esp))) or'
            ||' informado(sn34d) or sn34a=2 or sn34a=8 or sn34a=9',
            xcon_activa,'Formulario I1 incompleto',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento, xcon_grupo,xcon_gravedad, 1),
       (xoperativo, 'compl_S1_faltante','entrea<>2', xcon_rel,
            'total_h = dbo.total_hogares(encues) and dbo.total_hogares(encues)>0',
            xcon_activa,'Formulario S1 faltante ',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad, 1),
       (xoperativo, 'compl_S1_P_faltante','entrea<>2', xcon_rel,
            'total_m = dbo.cant_s1p_x_hog(enc, hog) and dbo.cant_s1p_x_hog(enc, hog)>0',
            xcon_activa,'Formulario S1 renglon persona faltante ',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad, 1),
       (xoperativo, 'compl_I1_faltante','entrea<>2', xcon_rel,
            '1=dbo.cant_i1_x_hog(enc, hog) and dbo.cant_i1_x_hog(enc, hog)>0',
            xcon_activa,'Formulario I1 faltante ',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad, 1)
        ;
END;
$BODY$
LANGUAGE plpgsql ;
/*otra*/
ALTER FUNCTION encu.generar_consistencias_completitud()
  OWNER TO tedede_php;