CREATE OR REPLACE FUNCTION encu.generar_consistencias_completitud(poperativo TEXT)
  RETURNS void AS
$BODY$
DECLARE
    xcon_activa             encu.consistencias.con_activa%type;
    xcon_tipo               encu.consistencias.con_tipo%type;
    xcon_falsos_positivos   encu.consistencias.con_falsos_positivos%type;  
    xcon_importancia        encu.consistencias.con_importancia%type;
    xcon_momento            encu.consistencias.con_momento%type;
    xcon_grupo              encu.consistencias.con_grupo%type;
    xcon_gravedad           encu.consistencias.con_gravedad%type;
    xcon_rel                encu.consistencias.con_rel%type;
BEGIN  
    -- Borrar las automaticas
    DELETE FROM encu.inconsistencias
        WHERE inc_con like 'compl%';
    DELETE FROM encu.ano_con
        WHERE anocon_con like 'compl%';
    DELETE FROM encu.con_var
        WHERE convar_con like 'compl%';
    DELETE FROM encu.consistencias
           WHERE con_con like 'compl%';
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
        (poperativo, 'compl_S1','', xcon_rel,
            'entrea=2 and(razon1=1 and informado(razon2_1) or'
                ||' razon1=2 and informado(razon2_2) or' 
                ||' razon1=3 and informado(razon2_3) or' 
                ||' razon1=4 and informado(razon2_4) or' 
                ||' razon1=5 and informado(razon2_5) or' 
                ||' razon1=6 or'
                ||' razon1=7 and informado(razon2_7) or' 
                ||' razon1=8 and informado(razon2_8) or' 
                ||' razon1=9 and informado(razon2_9) and (razon2_9<>1 or informado(razon2_9_esp)) ' 
                ||') or entrea=1 and total_h>0 or entrea>2',
            xcon_activa,'Formulario S1 incompleto',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad, 1),
        (poperativo, 'compl_S1_P','', xcon_rel,
            'informado(p9_6)',
            xcon_activa,'Formulario S1 renglón incompleto',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad, 1),
        (poperativo, 'compl_A1','', xcon_rel,
            '(not dbo.menor_de_45_dias_a_4_anios(enc,hog) or informado(h36d) or h33a=1) or ' ||
            '(dbo.menor_de_45_dias_a_4_anios(enc,hog) or informado(ts3_tot) or informado(ts2))',
            xcon_activa,'Formulario A1 incompleto',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad, 1),
        (poperativo, 'compl_A1_M','', xcon_rel,
            'informado(n7) and (n7<>2 or informado(n7_esp2)) and (n7<>3 or informado(n7_esp3)) and (n7<>8 or informado(n7_esp8))',
            xcon_activa,'Formulario A1 renglón M incompleto',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad, 1),
        (poperativo, 'compl_A1_X','', xcon_rel,
            'informado(lugar) and (lugar<>1 or informado(lugar_esp1)) and (lugar<>3 or informado(lugar_esp3))',
            xcon_activa,'Formulario A1 renglón X incompleto',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad, 1),
        (poperativo, 'compl_I1','', xcon_rel,
            '(informado(ti11) or (ti12=1 or ti13=1 or ti10=1 or ti9=1 or ti8=1 or ti7=1 or ti6=1 or ti5=1 or ti4=1 or ti3=1 ) and edad >=5 and edad<=17 ) or '||
           -- rg13
            '( (informado(rg13_1) or rg13_2<>1 or informado(rg13_2_esp) or rg13_3<>1 or informado(rg13_3_esp) or rg13_4<>1 or informado(rg13_4_espn)) and '||
            '   dbo.tit_mujer_madre_mayor_8_meses(enc,hog) and edad>17) or '||
          --rg12
            '(nmiembro_titular=mie and t1=1 and sexo=2 and not dbo.tit_mujer_madre_mayor_8_meses(enc,hog) and edad>17 and '||
            'informado(rg12) and (rg12<>13 or informado(rg12_esp))) or '||
         --rg11 
            '(dbo.tit_mujer_madre_menor_5_anios(enc,hog) and not (nmiembro_titular=mie and t1=1 and sexo=2) and '||
            '  not  dbo.tit_mujer_madre_mayor_8_meses(enc,hog) and edad>17 and '||
            ' informado(rg11) and (rg11<>13 or informado(rg11_esp))) or '||
           --rg10
            '(nmiembro_titular=mie and sexo=2 and not (dbo.tit_mujer_madre_menor_5_anios(enc,hog) and '||
           --not (nmiembro_titular=mie and t1=2 and sexo=2) and
           ' t1=2 and '||
           ' not  dbo.tit_mujer_madre_mayor_8_meses(enc,hog)) and '||
           ' edad>17 and  informado(rg10) ) or' ||
           --filtro10
            '(sexo=1 and nmiembro=nmiembro_titular and (edad<5 or edad>17) and informado(tip17)) or '||
           --filtro9
            '(nmiembro<>nmiembro_titular and (edad<5 or edad>17) and (informado(vc16_1) and informado(vc16_2) or (vc15=2 or vc15=3))) or '||
           --filtro8
            '((d1=2 or d4=2 or informado(d5)) and edad<5 and nmiembro_titular<>mie)'
            ,
            xcon_activa,'Formulario I1 incompleto',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento, xcon_grupo,xcon_gravedad, 1),
       (poperativo, 'compl_S1_faltante','entrea<>2', xcon_rel,
            'total_h >= dbo.total_hogares(encues) and dbo.total_hogares(encues)>0',
            xcon_activa,'Formulario S1 faltante ',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad, 1),
       (poperativo, 'compl_S1_P_faltante','entrea<>2', xcon_rel,
            'total_m >= dbo.cant_s1p_x_hog(enc, hog) and dbo.cant_s1p_x_hog(enc, hog)>0',
            xcon_activa,'Formulario S1 faltante ',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad, 1),
       (poperativo, 'compl_A1_faltante','entrea<>2', xcon_rel,
            'total_h >= dbo.cant_A1_x_hog(enc , hog) and dbo.cant_A1_x_hog(enc , hog)>0',
            xcon_activa,'Formulario S1 faltante ',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad, 1),
       (poperativo, 'compl_A1_X_faltante','entrea<>2', xcon_rel,
            'x5<>1 or (x5_tot = dbo.cant_registros_exm(enc,hog) and dbo.cant_registros_exm(enc,hog)>0)',
            xcon_activa,'Formulario A1 renglon X faltante ',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad, 1),
       (poperativo, 'compl_A1_M_faltante','entrea<>2', xcon_rel,
            'n1<>1 or (n1_tot = dbo.cant_registros_a1_m(enc,hog) and dbo.cant_registros_a1_m(enc,hog)>0)',
            xcon_activa,'Formulario A1 renglon M faltante ',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad, 1),
       (poperativo, 'compl_I1_faltante','entrea<>2', xcon_rel,
            'dbo.cant_i1_x_hog(enc, hog) = total_m',
            xcon_activa,'Formulario I1 faltante ',xcon_tipo, xcon_falsos_positivos,
            xcon_importancia,xcon_momento,xcon_grupo,xcon_gravedad, 1)
        ;
            
END;
$BODY$
LANGUAGE plpgsql ;
/*otra*/
ALTER FUNCTION encu.generar_consistencias_completitud(TEXT)
  OWNER TO tedede_php;