CREATE OR REPLACE FUNCTION encu.his_inconsistencias_trg()
  RETURNS trigger AS
$BODY$
BEGIN
  INSERT INTO his.his_inconsistencias(
            hisinc_ope, hisinc_con, hisinc_enc, hisinc_hog, hisinc_mie, hisinc_variables_y_valores, 
            hisinc_justificacion, hisinc_autor_justificacion, hisinc_tlg)
    VALUES (old.inc_ope, old.inc_con, old.inc_enc, old.inc_hog, old.inc_mie, old.inc_variables_y_valores, 
            old.inc_justificacion, old.inc_autor_justificacion, old.inc_tlg);

    return old;
END
$BODY$
LANGUAGE plpgsql VOLATILE;

ALTER FUNCTION encu.his_inconsistencias_trg()
  OWNER TO tedede_php;

CREATE TRIGGER his_inconsistencias_trg
    BEFORE DELETE
  ON encu.inconsistencias
  FOR EACH ROW
  EXECUTE PROCEDURE encu.his_inconsistencias_trg();

-- no borrar
--delete from encu.consistencias;

--comprobamos con  winmerge que las estructuras son iguales. OK
INSERT INTO encu.consistencias(
            con_ope, con_con, con_precondicion, con_rel, con_postcondicion, 
            con_valida, con_descripcion, con_modulo,  con_tipo, 
            con_gravedad, con_momento, con_junta, con_activa, con_tlg)
    VALUES ('AJUS', 'TEM_encu_no_rea',NULL,NULL ,NULL ,
             FALSE   , 'La encuesta ingresada no figura como realizada en la TEM.'                                                       ,  NULL    ,  NULL            ,
             NULL      , NULL                , NULL, FALSE, 1),
           ('AJUS', 'AI_hogar_salteado',NULL,NULL ,NULL ,
              FALSE  ,  'Un hogar ha sido salteado.'                                                      ,  NULL    ,  NULL            ,
              NULL     ,  NULL               , NULL, FALSE, 1),
           ('AJUS', 'TEM_cant_miembros',NULL,NULL ,NULL ,
              FALSE  ,  'La cantidad de miembros declarada en la matriz familiar no coincide con la declarada en la tabla TEM.'                                                      ,  NULL    ,  NULL            ,
              NULL     ,  NULL               , NULL, FALSE, 1),           
           ('AJUS', 'TEM_cant_hogares',NULL,NULL ,NULL ,
              FALSE  ,  'No coinciden la cantidad de hogares ingresados con los de la TEM.'                                                      ,  NULL    ,  NULL            ,
              NULL     ,  NULL               , NULL, FALSE, 1),                                  
            ('AJUS', 'var_a_revisar_AJI1',NULL,NULL ,NULL ,
              FALSE  ,  'Existen variables a revisar en el formulario AJI1.'                                                      ,  NULL    ,  NULL            ,
              NULL     ,  NULL               , NULL, FALSE, 1),                                  
           ('AJUS', 'var_a_revisar_AJH1',NULL,NULL ,NULL ,
              FALSE  ,  'Existen variables a revisar en el formulario AJH1.'                                                      ,  NULL    ,  NULL            ,
              NULL     ,  NULL               , NULL, FALSE, 1),                                             
            ('AJUS','H3_dato_2o+hg','v1=2 OR TOTALH>1','=>','H3>=0',TRUE,'Habitaciones de uso exclusivo debe ser mayor que cero','VyH','Conceptual','Error','Relevamiento 1', 'h', TRUE, 1),
            ('AJUS','H3_dato_ref','v4>0 or v1=2 or totalh>1','=>','H3>=0',TRUE,'Habitaciones de uso exclusivo debe ser mayor que cero','VyH','Conceptual','Error','Relevamiento 1', 'h', TRUE, 1),
            ('AJUS','nhogar','hog>1','=>','dbo.Existe_Hogar(enc,hog - 1)=1',TRUE,'El nro de hogar no es consecutivo con el anterior o éste no existe','VyH','Conceptual','Error','Relevamiento 1', 'h', TRUE, 1),
            ('AJUS','Resp_dato','rea<>2','=>','respondente_num>0',TRUE,'Debe haber un respondente','VyH','Conceptual','Error','Relevamiento 1', 'h', TRUE, 1),
            ('AJUS','Resp_v','respondente_num>0','=>','respondente_num = 99 or dbo.Existe_Miembro(enc,hog,respondente_num)=1',TRUE,'Debe existir el respondente como miembro del hogar','VyH','Conceptual','Error','Relevamiento 1', 'h', TRUE, 1),
            ('AJUS','Total_h','','=>','totalh = dbo.total_hogares(enc)',TRUE,'Cantidad de hogares relevados no coincide con declaración escrita','VyH','Conceptual','Error','Procesamiento', 'h', TRUE, 1),
            ('AJUS','V1_TotH=1','v1=1','=>','TotalH = 1',TRUE,'Todos comparten los gastos, es un único hogar','VyH','Conceptual','Error','Relevamiento 1', 'h', TRUE, 1),
            ('AJUS','V1_TotH>1_a','V1 = 2','=>','TotalH > 1',TRUE,'No comparten los gastos, es más de un hogar','VyH','Conceptual','Error','Relevamiento 1', 'h', TRUE, 1),
            ('AJUS','V1_TotH>1_b','V1 = 2','=>','dbo.total_hogares(enc)>1',TRUE,'Debe haber tantos AJH1 como hogares en la vivienda','VyH','Conceptual','Error','Relevamiento 1', 'h', TRUE, 1),
            ('AJUS','f_realiz_o','','=>','dbo.es_fecha(f_realiz_o) = 1',FALSE,'Día y mes de realización debe ser válido','VyH','Conceptual','Error','Relevamiento 1', 'h', FALSE, 1),
            ('AJUS','H3<=V4','TOTALH>1 or v1=2','=>','H3<=V4',TRUE,'Suma habitaciones de uso exclusivo debe ser menor o igual que las habitaciones de la vivienda','VyH','Conceptual','Advertencia','Relevamiento 1', 'h', TRUE, 1),
            ('AJUS','P4=1_nec','','=>','dbo.existe_jefe(enc,hog)>=1',TRUE,'En este hogar no existe un jefe declarado','FAMILIAR','Conceptual','Error','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P4=7_P5','P4=7','=>','P5=1 or P5=2',TRUE,'Si es yerno/nuera debe ser unido/a, casado/a o ns/nc','FAMILIAR','Conceptual','Advertencia','Recepción', 'm', TRUE, 1),
            ('AJUS','P4=1_unico','','=>','dbo.NroJefes(enc,hog)<=1',TRUE,'En este hogar existe más de un jefe declarado','FAMILIAR','Conceptual','Error','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P4=1>18','P4 =1','=>','P3_b>18',TRUE,'El jefe preferentemente debe tener más de 18 años','FAMILIAR','Conceptual','Advertencia','Recepción', 'm', TRUE, 1),
            ('AJUS','P4=2_No','P4=1 and (P5<>1 and P5<> 2)','=>','dbo.NroConyuges(enc,hog)=0',TRUE,'Si jefe no declara "en unión" no debe existir un cónyuge declarado','FAMILIAR','Conceptual','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P4=2_P5','P4=2','=>','P5<3',TRUE,'Si es cónyuge, debe ser unido/a o casado/a','FAMILIAR','Conceptual','Advertencia','Recepción', 'm', TRUE, 1),
            ('AJUS','P4=2_P5J','P4=2','=>','P5 = dbo.estadojefe(enc,hog)',TRUE,'Si es cónyuge, debe declarar el mismo estado conyugal del jefe','FAMILIAR','Conceptual','Advertencia','Recepción', 'm', TRUE, 1),
            ('AJUS','P4=2_SexJ','P4=2','=>','p2 <> dbo.sexoJefe(enc,hog)',TRUE,'El jefe y el cónyuge declaran tener el mismo sexo','FAMILIAR','Conceptual','Advertencia','Recepción', 'm', TRUE, 1),
            ('AJUS','P4=2_unico','','=>','dbo.nroConyuges(enc,hog)<=1',TRUE,'En cada hogar debe haber solo un cónyuge o ninguno','FAMILIAR','Conceptual','Advertencia','Relevamiento 2', 'm', TRUE, 1),
            ('AJUS','P4=3_EdaJ','P4=3','=>','p3_b+10 < dbo.EdadJefe(enc, hog)',TRUE,'El hijo debe tener 10 años menos que su padre (mínimo)','FAMILIAR','Conceptual','Advertencia','Recepción', 'm', TRUE, 1),
            ('AJUS','P4=8_EdaJ','P4=8','=>','p3_b+20 < dbo.EdadJefe(enc, hog)',TRUE,'El nieto debe tener 20 años menos que su abuelo (mínimo)','FAMILIAR','Conceptual','Advertencia','Recepción', 'm', TRUE, 1),
            ('AJUS','P4=4_EdaJ','P4=7','=>','p3_b+10>dbo.edadjefe(enc, hog)',TRUE,'El padre/madre/debe tener 10 años más que el jefe (mínimo)','FAMILIAR','Conceptual','Advertencia','Recepción', 'm', TRUE, 1),
            ('AJUS','P4=6_EdaJ','P4=6','=>','p3_b+10>dbo.edadjefe(enc, hog)',TRUE,'El suegro/suegra/debe tener 10 años más que el jefe (mínimo)','FAMILIAR','Conceptual','Advertencia','Recepción', 'm', TRUE, 1),
            ('AJUS','P8_dato_a','P8=1','=>','P9>0',TRUE,'Si asiste a establecimiento educativo, debe responder el nivel que está cursando actualmente','EDUCACIÓN','Conceptual','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P8_dato_b','P8=2','=>','P9>0',TRUE,'Si asistió a establecimiento educativo, debe responder el nivel más alto que cursó','EDUCACIÓN','Conceptual','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P9=2_P11','P9=2','=>','P11>0 and P11<8 or P11=99',TRUE,'Si respondió que asiste a Primario Común, el grado que cursa debe ser menor que 8 y mayor a cero','EDUCACIÓN','Conceptual','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P9=2_P3b','P9=2','=>','P3_b>5 and P3_b<=15',TRUE,'Si respondió que asiste a Primario Común, la edad declarada debe ser igual o mayor que 5 e igual o menor que 15.','EDUCACIÓN','Conceptual','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P9=4_P11','P9=4','=>','P11> 0 and P11<7 or P11=99',TRUE,'Si respondió que asiste a Secundario Medio/Común, el año que cursa debe ser menor que 7.','EDUCACIÓN',' Conceptual','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P9=4_P3b','P9=4','=>','P3_b >10 ',TRUE,'Si respondió que asiste a Secundario/Medio Común, la edad declarada debe ser  mayor que 10 e igual o menor que 24.','EDUCACIÓN','Conceptual','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P9=5_P11','P9=5','=>','P11 < 4 or P11=99',TRUE,'Si respondió que asiste a Polimodal, el año que cursa debe ser menor que 4.','EDUCACIÓN','Conceptual','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P9_P3b','P9=5','=>','P3_b>=13 ',TRUE,'Si respondió que asiste a Polimodal, la edad declarada debe ser mayor que 14.','EDUCACIÓN','Conceptual','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P9_P10_P3b_a','P9=3 and P10=1','=>','P3_b>=14 ',TRUE,'Si respondió que cursó como máximo EGB y lo completó, la edad debe ser igual o mayor que 14 ','EDUCACIÓN','Conceptual','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P9_P10_P3b_b','P9=5 and P10=1 ','=>','P3_b>=17 ',TRUE,'Si respondió que cursó como máximo Polimodal y lo completó, la edad de E9 debe ser igual o mayor que 17 o el año de E9 debe ser igual o mayor que el año de   nacimiento más 17.','EDUCACIÓN','Conceptual','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P9_P11_a','P9=6','=>','P11<8 or P11=99',TRUE,'Si respondió que asiste a los niveles Terciario/Superior No Universitario o Universitario, el año que está cursando debe ser menor que 8.','EDUCACIÓN','Conceptual','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P9_P11_b','P9=7','=>','P11<8 or P11=99',TRUE,'Si respondió que asiste al nivel Universitario, el año que está cursando debe ser menor que 8.','EDUCACIÓN','Conceptual','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P9_P3b_c','P9=6','=>','P3_b>=17 ',TRUE,'Si respondió que asiste a los niveles Terciario/Superior No Universitario o Universitario, la edad declarada debe ser igual o mayor que 17.','EDUCACIÓN','Conceptual','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P9_P3b_d','P9=7','=>','P3_b>=17 ',TRUE,'Si repondió que el nivel que está cursando es Primario o mayor a Primario (y no asiste a Otras escuelas especiales), debe responder la E8.','EDUCACIÓN','Conceptual','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P9_P11_c','P9=8','=>','P11<5 or P11=99',TRUE,'Si respondió que asiste a Posgrado, el año que cursa debe ser menor que 5. ','EDUCACIÓN','Conceptual','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P9_P11_d','P9=8','=>','P3_b>=23',TRUE,'Si respondió que asiste a Posgrado, la edad declarada debe ser igual o mayor que 23.','EDUCACIÓN','Conceptual','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P9_P10_P11_a','P9=2 and P10=2','=>','P11<7 or  P11=99',TRUE,'Si respondió que el nivel más alto que cursó fue Primario Común y no lo completó, el útimo grado que aprobó debe ser menor que 7.','EDUCACIÓN','Conceptual ','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P9_P10_P11_b','P9 =3 and P10 = 2 ','=>','P11<9 or P11=99',TRUE,'Si respondió que el nivel más alto que cursó fue EGB y no lo completó, el útimo año que aprobó debe ser menor que 9.','EDUCACIÓN','Conceptual','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P9_P10_P11_c','P9=4 and P10=2','=>','P11<7 or  P11=99',TRUE,'Si respondió que el nivel más alto que cursó fue Secundario/Medio Común y no lo completó, el útimo año que aprobó debe ser menor que 7.','EDUCACIÓN','Conceptual','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','P9_P10_P11_d','P9=5 and P10=2','=>','P11<3 or P11=99',TRUE,'Si respondió que el nivel más alto que cursó fue Polimodal y no lo completó, el   último año que aprobó debe ser menor que 3.','EDUCACIÓN','Conceptual','Advertencia','Relevamiento 1', 'm', TRUE, 1),
            ('AJUS','T1_T44','T1=1','=>','T44>0 and T44<5',TRUE,'Si respondió que trabajó en la semana de referencia al menos una hora debe tener categoría ocupacional','Trabajo','Conceptual','Error','Relevamiento 2', 'i', TRUE, 1),
            ('AJUS','T1_T2','T1=2','=>','T2=1 or T2=2',TRUE,'Si no trabajó durante la semana de referencia debe tener una respuesta en la pregunta "rescate"','Trabajo','Conceptual','Error','Recepción', 'i', TRUE, 1),
            ('AJUS','I1_T1_T44','I1=2 and T1=1 ','=>','T44=4',TRUE,'Si no tiene ingresos en su ocupación principal debe ser un trabajador familiar sin pago o adhonorem','Trabajo','Conceptual','Advertencia','Recepción', 'i', TRUE, 1),
            ('AJUS','I1_T2_T44','I1=2 and T1=2 and T2=1','=>','T44=4',TRUE,'Si no tiene ingresos en su ocupación principal debe ser un trabajador familiar sin pago o adhonorem','Trabajo','Conceptual','Advertencia','Recepción', 'i', TRUE, 1);

            
CREATE SCHEMA dbo
  AUTHORIZATION tedede_php;

GRANT ALL ON SCHEMA dbo TO tedede_php;

CREATE OR REPLACE FUNCTION dbo.nrojefes(p_enc integer, p_hogar integer)
  RETURNS integer AS
$BODY$
declare v_cantjefes integer;
begin
    v_cantjefes := count(*) from encu.respuestas where res_enc = p_enc and res_hog = p_hogar and res_var = 'p4' and (res_valor ='1') ;
    return v_cantjefes;
end;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;
ALTER FUNCTION dbo.nrojefes(integer, integer)
  OWNER TO tedede_php;


CREATE OR REPLACE FUNCTION dbo.sexojefe(p_enc integer, p_hogar integer)
  RETURNS integer AS
$BODY$
declare v_sexojefe text;
begin
    select res_valor into v_sexojefe from encu.respuestas where res_enc = p_enc and res_hog = p_hogar and res_var = 'p2' and res_mie in (select res_mie from encu.respuestas where res_enc = p_enc and res_hog = p_hogar and res_var = 'p4' and (res_valor ='1' ) limit 1);
    return v_sexojefe;
end;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;
ALTER FUNCTION dbo.sexojefe(integer, integer)
  OWNER TO tedede_php;

CREATE OR REPLACE FUNCTION dbo.total_hogares(p_enc integer)
  RETURNS integer AS
$BODY$
declare cant integer;
begin
	
	cant :=  count(distinct(res_hog)) from encu.respuestas where res_enc = p_enc  and res_for <>'TEM';
	
		return cant;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION dbo.total_hogares(integer)
  OWNER TO tedede_php;
  
CREATE OR REPLACE FUNCTION dbo.edadjefe(p_enc integer, p_nhogar integer)
  RETURNS integer AS
$BODY$
declare v_edad_jefe integer;

begin
	v_edad_jefe := 0;

	select res_valor into v_edad_jefe from encu.respuestas where res_enc = p_enc and res_hog = p_nhogar and res_mie = 1 and res_var = 'p3_b' ;
	return v_edad_jefe;
	
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION dbo.edadjefe(integer, integer)
  OWNER TO tedede_php;
  
CREATE OR REPLACE FUNCTION dbo.estadojefe(p_enc integer, p_hogar integer)
  RETURNS integer AS
$BODY$
declare v_estadojefe text;
begin
    select res_valor into v_estadojefe from encu.respuestas where res_enc = p_enc and res_hog = p_hogar and res_var = 'p5' and res_mie in (select res_mie from encu.respuestas where res_enc = p_enc and res_hog = p_hogar and res_var = 'p4' and (res_valor ='1') limit 1);
    return v_estadojefe;
end;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;
ALTER FUNCTION dbo.estadojefe(integer, integer)
  OWNER TO tedede_php;
  
CREATE OR REPLACE FUNCTION dbo.existe_hogar(p_enc integer, p_hogar integer)
  RETURNS integer AS
$BODY$
declare v_existe integer;
begin
    v_existe := count(distinct (res_hog)) from encu.respuestas where res_enc = p_enc and res_hog = p_hogar;
    return v_existe;
end;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;
ALTER FUNCTION dbo.existe_hogar(integer, integer)
  OWNER TO tedede_php;
  
CREATE OR REPLACE FUNCTION dbo.existe_jefe(p_enc integer, p_hogar integer)
  RETURNS integer AS
$BODY$
declare v_cantjefes integer;
begin
    v_cantjefes := count(*) from encu.respuestas where res_enc = p_enc and res_hog = p_hogar and res_var = 'p4' and (res_valor ='1') ;
    if (v_cantjefes > 1) then
	v_cantjefes := 2;
    end if;
    return v_cantjefes;
end;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;
ALTER FUNCTION dbo.existe_jefe(integer, integer)
  OWNER TO tedede_php;
  
CREATE OR REPLACE FUNCTION dbo.existe_miembro(p_enc integer, p_hogar integer, p_miembro integer)
  RETURNS integer AS
$BODY$
declare v_existe integer;
begin
    v_existe := count(distinct (res_mie)) from encu.respuestas where res_enc = p_enc and res_hog = p_hogar and res_mie = p_miembro;
    return v_existe;
end;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;
ALTER FUNCTION dbo.existe_miembro(integer, integer, integer)
  OWNER TO tedede_php;
  
CREATE OR REPLACE FUNCTION dbo.nroconyuges(p_enc integer, p_hogar integer)
  RETURNS integer AS
$BODY$
declare v_nroconyuges integer;
begin
    v_nroconyuges := count(*) from encu.respuestas where res_enc = p_enc and res_hog = p_hogar and res_var = 'p4' and (res_valor ='2');
    return v_nroconyuges;
end;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;
ALTER FUNCTION dbo.nroconyuges(integer, integer)
  OWNER TO tedede_php;

update encu.consistencias set con_activa = false where con_con='enc_no_TEM';

-- correr compilar consistencias
-- ajus.php?hacer=compilar_consistencia

GRANT CREATE ON DATABASE tedede_db TO tedede_php;

