/*
DELETE FROM encu.preguntas where pre_ope = 'same2014';
DELETE FROM encu.bloques where blo_ope = 'same2014';
*/

--variables tomadas del excel de los metadatos:
INSERT INTO encu.operativos(
            ope_ope, ope_nombre, ope_ope_anterior, ope_tlg)
    VALUES ('same2014', 'Encuesta epidemiológica de salud mental de la Ciudad de Buenos Aires 20134', '', 1);


INSERT INTO encu.formularios(
            for_ope, for_for, for_nombre, for_es_principal, for_orden, for_tlg)
    VALUES ('same2014', 'TEM', 'TEM', null, 1, 1),
	   ('same2014', 'SM1', 'Carátula - componentes del hogar y vivienda', true, 10, 1),
	   ('same2014', 'SMI1', 'Individual', null, 20, 1);


INSERT INTO encu.ua(
            ua_ope, ua_ua, ua_prefijo_respuestas, ua_sufijo_tablas, ua_pk, 
            ua_tlg)
            VALUES
            ('same2014','mie',null,null,'["enc","hog","mie"]',1),
            ('same2014','hog',null,null,'["enc","hog"]',1),
            ('same2014','enc',null,null,'["enc"]',1),
            ('same2014','exm',null,null,'["enc","hog","exm"]',1);

--delete from encu.matrices where mat_ope='same2014' ;
INSERT INTO encu.matrices(
            mat_ope, mat_for, mat_mat, mat_texto, mat_ua, mat_ultimo_campo_pk, 
            mat_orden, mat_blanquear_clave_al_retroceder, mat_tlg)
            VALUES
            ('same2014','SM1','P','Personas','mie','mie',0,'',1),
            ('same2014','SM1','','Personas','mie','mie',0,'',1),
            ('same2014','SMI1','','Personas','mie','mie',0,'',1),
	    ('same2014','TEM','','Principal','enc','enc',null,',tra_hog:0,tra_mie:0,tra_exm:0',1);	    
            

INSERT INTO encu.bloques(
            blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, blo_tlg)
    VALUES 
    ('same2014', 'SM1', 'SM1.1', '' , 'Apertura de la entrevista',null, 10, null,1),
    ('same2014', 'SM1', 'M.P'  , '' , 'COMPONENTES DEL HOGAR','P', 20, 'Empezando por el jefe',1),
    ('same2014', 'SM1', 'M.P_m', 'P', 'COMPONENTES DEL HOGAR',null, 20, 'Empezando por el jefe',1),
    ('same2014', 'SM1', 'Viv'  , '' , 'Vivienda',null,30,'Si existe más de un hogar, aplique el bloque vivienda sólo al primero. El segundo hogar pase a H1.',1),
    ('same2014', 'SM1', 'Hog'  , '' , 'HOGAR',null,40,null,1),    
    ('same2014', 'SM1', 'sitlabjefe'    ,''  , 'SITUACIÓN LABORAL DEL JEFE/JEFA DEL HOGAR',null,60,null,1),
    ('same2014', 'SMI1', 'Bloind'    ,''  , 'BLOQUE INDIVIDUAL',null,70,null,1),
    ('same2014', 'SMI1', 'SitLab'    ,''  , 'SITUACIÓN LABORAL',null,80,null,1),
    ('same2014', 'SMI1', 'Salud'    ,''  , 'SITUACIÓN DE SALUD',null,90,null,1),
    ('same2014', 'SMI1', 'Tabaco'    ,''  , 'TABACO',null,100,null,1),
    ('same2014', 'SMI1', 'Bebalc'    ,''  , 'BEBIDAS ALCOHOLICAS',null,110,null,1),
    ('same2014', 'SMI1', 'Tranqui'    ,''  , 'TRANQUILIZANTES',null,120,null,1),
    ('same2014', 'SMI1', 'Antid'    ,''  , 'ANTIDEPRESIVOS',null,130,null,1),
    ('same2014', 'SMI1', 'Marih'    ,''  , 'MARIHUANA',null,140,null,1),
    ('same2014', 'SMI1', 'Coca'    ,''  , 'COCAÍNA',null,150,null,1),
    ('same2014', 'SMI1', 'Paco'    ,''  , 'PACO O PASTA BASE',null,160,null,1),
    ('same2014', 'SMI1', 'Inhalables'    ,''  , 'INHALABLES',null,170,null,1),
    ('same2014', 'SMI1', 'Extasis'    ,''  , 'ÉXTASIS O DROGAS DE DISEÑO',null,180,null,1),
    ('same2014', 'SMI1', 'Alucinogenos'    ,''  , 'ALUCINÓGENOS',null,190,null,1),
    ('same2014', 'SMI1', 'Opiaceos'    ,''  , 'OPIÁCEOS',null,200,null,1),
    ('same2014', 'SMI1', 'Razonnoind'    ,''  , 'RAZÓN DE NO RESPUESTA INDIVIDUAL',null,220,null,1);

	   
INSERT INTO encu.preguntas(
            pre_ope, pre_pre, pre_texto, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_desp_opc,  
            pre_orden, pre_tlg)
            values           
('same2014','ENTREA','Apertura de entrevista ','SM1','','SM1.1',null,'vertical',100,1),
('same2014','RESPOND','Respondiente número ','SM1','','SM1.1',null,'vertical',110,1),
('same2014','NOMBRER','Respondiente nombre ','SM1','','SM1.1',null,'vertical',120,1),
('same2014','F_REALIZ_O','Fecha de realización ','SM1','','SM1.1',null,'vertical',130,1),
('same2014','V1','¿Todas las personas que residen en esta vivienda comparten los gastos de comida? ','SM1','','SM1.1',null,'vertical',140,1),
('same2014','TOTAL_H','Total de hogares ','SM1','','SM1.1',null,'vertical',150,1),
('same2014','TOTAL_M','Cantidad de miembros ','SM1','','SM1.1',null,'vertical',160,1),
('same2014','P1','Por favor, nombreme todas las personas que componen este hogar empezando por el jefe ','SM1','P','M.P_m','(No se olvide de Usted ni de los bebés y niños)','vertical',170,1),
('same2014','P2','Sexo ','SM1','P','M.P_m','Anote código','vertical',180,1),
('same2014','P3A','Fecha de nacimiento ','SM1','P','M.P_m',null,'vertical',190,1),
('same2014','P3B','¿Cuántos años cumplidos tiene en este momento? ','SM1','P','M.P_m','Si tiene menos de un año anote 0','vertical',200,1),
('same2014','P4','¿Qué parentesco tiene con el jefe? (E-S)','SM1','P','M.P_m','Anote código (tabla) ','vertical',210,1),
('same2014','P5','Estado conyugal (para mayores de 14 años) (G-S)','SM1','P','M.P_m','Anote código (tabla) ','vertical',220,1),
('same2014','L0','Letra de orden según edad (para personas de 16 a 65 años)  ','SM1','P','M.P_m','Comience con la letra A a partir de la persona de mayor edad y continúe','vertical',230,1),
('same2014','TP','(TP) TOTAL DE PERSONAS EN EL RANGO ','SM1','','M.P',null,'vertical',300,1),
('same2014','CR','Cuadro resumen ','SM1','','M.P',null,'vertical',305,1),
('same2014','M1','¿Dónde nació? (E-S)','SM1','P','M.P_m',null,'vertical',240,1),
('same2014','E2','¿Asiste o asistió a algún establecimiento educativo? (G-S)','SM1','P','M.P_m',null,'vertical',250,1),
('same2014','E6A','¿Qué nivel esta cursando actualmente? (E-S) con indagación','SM1','P','M.P_m',null,'vertical',260,1),
('same2014','E12A','¿Cual es el nivel mas alto que cursó? (E-S) con indagación','SM1','P','M.P_m',null,'vertical',270,1),
('same2014','E13','¿Completó ese nivel? (E-S) ','SM1','P','M.P_m',null,'vertical',280,1),
('same2014','SN1B','¿Está afiliado a…  (G-M)','SM1','P','M.P_m','(Encuestador: siga leyendo aún cuando obtenga una respueste positiva)','vertical',290,1),
('same2014','V2','Tipo de vivienda  ','SM1','','Viv','(Observacional)','vertical',300,1),
('same2014','V4','¿Cuántas habitaciones/ ambientes tiene en total, esta vivienda? Sin contar baños, cocina/s, garages o pasillos ','SM1','','Viv',null,'vertical',310,1),
('same2014','V5','Los pisos interiores son principalmente de… (G-S)','SM1','','Viv',null,'vertical',320,1),
('same2014','V6','La cubierta exterior del techo es de (G-S)','SM1','','Viv',null,'vertical',330,1),
('same2014','V7','El techo tiene cielorraso/ revestimiento interior ','SM1','','Viv',null,'vertical',340,1),
('same2014','V12','Esta vivienda, ¿dispone de…  (G-S)','SM1','','Viv','(Lea todas las opciones de respuesta hasta obtener una respuesta positiva)','vertical',350,1),
('same2014','H1','¿El baño es... (G-S)','SM1','','Hog',null,'vertical',360,1),
('same2014','H2','Este hogar ¿es... (G-S)','SM1','','Hog',null,'vertical',370,1),
('same2014','H3','¿Cuántas habitaciones/ ambientes tiene en total, esta vivienda? Sin contar baños, cocina/s, garages o pasillos ','SM1','','Hog',null,'vertical',380,1),
('same2014','IT1','¿Cuál es el ingreso total mensual del hogar?  ','SM1','','Hog','(Incluya ingresos provenientes del trabajo, jubilaciones, rentas, seguros de desempleo, becas, cuotas de alimentos, etc.)','vertical',390,1),
('same2014','IT2','¿Me podría indicar en cuál de estos tramos se ubica el ingreso total mensual de su hogar? ','SM1','','Hog','(Incluya ingresos provenientes del trabajo, jubilaciones, rentas, seguros de desempleo, becas, cuotas de alimentos, etc.) Encuestador entregue al entrevistado la TARJETA 1.','vertical',400,1),
('same2014','JHT1','¿ La semana pasada trabajó_____________ por lo menos una hora? (E-S)','SM1','','sitlabjefe',null,'vertical',410,1),
('same2014','JHT2','En esta semana ¿hizo alguna changa, fabricó en su casa algo para vender, ayudó a un familiar o amigo en su negocio? (E-S)','SM1','','sitlabjefe',null,'vertical',420,1),
('same2014','JHT3','La semana pasada … Primero lea todas las opciones y luego marque la respuesta (G-S)','SM1','','sitlabjefe',null,'vertical',430,1),
('same2014','JHT4','¿No concurrió a su trabajo por… (G-S)','SM1','','sitlabjefe',null,'vertical',440,1),
('same2014','JHT5','¿Le siguen pagando durante la suspensión? (E-S)','SM1','','sitlabjefe',null,'vertical',450,1),
('same2014','JHT6','¿Volverá a ese trabajo a lo sumo en un mes? (E-S)','SM1','','sitlabjefe',null,'vertical',460,1),
('same2014','JHT9','Durante los últimos 30 días ¿estuvo buscando trabajo de alguna manera? (E-S)','SM1','','sitlabjefe',null,'vertical',470,1),
('same2014','JHT10','Durante esos 30 días ¿ hizo algo para instalarse por su cuenta/puso carteles/ consulto con parientes, amigos? (E-S)','SM1','','sitlabjefe',null,'vertical',480,1),
('same2014','JHT11','¿No buscó trabajo (ni hizo algo para trabajar) porque… (G-S)','SM1','','sitlabjefe','(Primero lea todas las opciones y luego marque la respuesta)','vertical',490,1),
('same2014','JHT44','¿Ese trabajo___________ lo hace... (G-S)','SM1','','sitlabjefe',null,'vertical',500,1),
('same2014','JHT45','¿Por ese trabajo… (G-S)','SM1','','sitlabjefe',null,'vertical',510,1),
('same2014','JHT46','¿En ese negocio/empresa/actividad, se emplean personas asalariadas? (G-S)','SM1','','sitlabjefe',null,'vertical',520,1),
('same2014','JHT49','¿Ese trabajo tiene tiempo de finalización? (E-S)','SM1','','sitlabjefe',null,'vertical',530,1),
('same2014','JHT51','¿En ese trabajo… (G-S)','SM1','','sitlabjefe',null,'vertical',540,1),
('same2014','JHT29B','¿Cuántas horas semanales trabaja habitualmente en todos sus empleos/ocupaciones? (E-S)','SM1','','sitlabjefe',null,'vertical',550,1),
('same2014','JHT29C','¿Quiere trabajar mas horas? (E-S)','SM1','','sitlabjefe',null,'vertical',560,1),
('same2014','T1','¿ La semana pasada trabajó por lo menos una hora? (E-S)','SMI1','','SitLab',null,'vertical',570,1),
('same2014','T2','En esta semana ¿hizo alguna changa, fabricó en su casa algo para vender, ayudó a un familiar o amigo en su negocio? (E-S)','SMI1','','SitLab',null,'vertical',580,1),
('same2014','T3','La semana pasada … Primero lea todas las opciones y luego marque la respuesta (G-S)','SMI1','','SitLab',null,'vertical',590,1),
('same2014','T4','¿No concurrió a su trabajo por… (G-S)','SMI1','','SitLab',null,'vertical',600,1),
('same2014','T5','¿Le siguen pagando durante la suspensión? (E-S)','SMI1','','SitLab',null,'vertical',610,1),
('same2014','T6','¿Volverá a ese trabajo a lo sumo en un mes? (E-S)','SMI1','','SitLab',null,'vertical',620,1),
('same2014','T9','Durante los últimos 30 días ¿estuvo buscando trabajo de alguna manera? (E-S)','SMI1','','SitLab',null,'vertical',630,1),
('same2014','T10','Durante esos 30 días ¿ hizo algo para instalarse por su cuenta/puso carteles/ consulto con parientes, amigos? (E-S)','SMI1','','SitLab',null,'vertical',640,1),
('same2014','T11','¿No buscó trabajo (ni hizo algo para trabajar) porque… (G-S)','SMI1','','SitLab','(Primero lea todas las opciones y luego marque la respuesta)','vertical',650,1),
('same2014','T44','¿Ese trabajo  lo hace... (G-S)','SMI1','','SitLab',null,'vertical',660,1),
('same2014','T45','¿Por ese trabajo… (G-S)','SMI1','','SitLab',null,'vertical',670,1),
('same2014','T46','¿En ese negocio/empresa/actividad, se emplean personas asalariadas? (G-S)','SMI1','','SitLab',null,'vertical',680,1),
('same2014','T49','¿Ese trabajo tiene tiempo de finalización? (E-S)','SMI1','','SitLab',null,'vertical',690,1),
('same2014','T51','¿En ese trabajo… (G-S)','SMI1','','SitLab',null,'vertical',700,1),
('same2014','T29B','¿Cuántas horas semanales trabaja habitualmente en todos sus empleos/ocupaciones? (E-S)','SMI1','','SitLab',null,'vertical',710,1),
('same2014','T29C','¿Quiere trabajar mas horas? (E-S)','SMI1','','SitLab',null,'vertical',720,1),
('same2014','SN15A','A continuación le voy a leer una lista con una serie de enfermedades o problemas de salud, ¿padece o ha padecido alguna vez alguna de ellas? (G-M)','SMI1','','Salud',null,'vertical',730,1),
('same2014','GHQ_12','Nos gustaria saber si usted ha tenido algunas molestias o trastornos y cómo ha estado de salud en las últimas semanas. Por favor, lea cuidadosamente las preguntas de esta tarjeta y elija las respuestas que mejor pueden aplicarse a su situación. Tenga en cuenta que queremos saber sobre los problemas recientes y actuales, no los del pasado. Es muy importante que usted conteste todas las preguntas. ','SMI1','','Salud','Encuestador, entregue al entrevistado la Tarjeta 2.','vertical',740,1),
('same2014','SN19','En las últimas semanas, ¿Ha tenido algún problema de tipo emocional o nervioso? (E-S) ','SMI1','','Salud',null,'vertical',750,1),
('same2014','SN20','En las últimas semanas,¿ha realizado alguna consulta por problemas de tipo emocional o nervioso? (E-S) ','SMI1','','Salud',null,'vertical',760,1),
('same2014','SN21','En las últimas semanas,¿ha realizado, por problemas emocionales o nerviosos, algún tratamiento con un médico no psiquiatra, que incluya el uso de medicamentos? (E-S) ','SMI1','','Salud',null,'vertical',770,1),
('same2014','SN22','En las últimas semanas,¿ha realizado, por problemas emocionales o nerviosos, algún tratamiento con un psicólogo o psiquiatra, que incluya el uso de medicamentos? (G-S) ','SMI1','','Salud',null,'vertical',780,1),
('same2014','SN23','¿Por qué motivo no consultó? (G-M)','SMI1','','Salud',null,'vertical',790,1),
('same2014','SN24A','¿Ha fumado usted cigarrillos alguna vez en la vida? ','SMI1','','Tabaco',null,'vertical',800,1),
('same2014','SN24B','¿Cuándo fue la ultima vez que fumó un cigarrillo? ','SMI1','','Tabaco',null,'vertical',810,1),
('same2014','SN25A','¿Ha consumido alguna bebida alcoholica, como por ejemplo vino, cerveza, whisky o similares alguna vez en la vida? ','SMI1','','Bebalc',null,'vertical',820,1),
('same2014','SN25B','¿Cuándo fue la ultima vez que tomó alguna de estas bebidas alcoholicas? ','SMI1','','Bebalc',null,'vertical',830,1),
('same2014','SN26A','¿Alguna vez tomó algún tranquilizante o sedante para calmar los nervios o para poder dormir, como Valium, Lexotanil, Alplax, Trapax, Rivotril o similares? ','SMI1','','Tranqui',null,'vertical',840,1),
('same2014','SN26B','¿Los tranquilizantes los tomó... ','SMI1','','Tranqui',null,'vertical',850,1),
('same2014','SN26C','¿Quién se los recetó? ','SMI1','','Tranqui',null,'vertical',860,1),
('same2014','SN26D','¿Cuándo fue la ultima vez que tomó tranquilizantes sin indicación médica? ','SMI1','','Tranqui',null,'vertical',870,1),
('same2014','SN27A','¿Alguna vez tomó algún antidepresivo, como Foxetin, Fluoxetina, prozac, zoloft o similares? ','SMI1','','Antid',null,'vertical',880,1),
('same2014','SN27B','¿Los antidepresivos los tomó... ','SMI1','','Antid',null,'vertical',890,1),
('same2014','SN27C','¿Quién se los recetó? ','SMI1','','Antid',null,'vertical',900,1),
('same2014','SN27D','¿Cuándo fue la ultima vez que tomó antidepresivos sin indicación médica? ','SMI1','','Antid',null,'vertical',910,1),
('same2014','SN28A','¿Alguna vez probó marihuana? ','SMI1','','Marih',null,'vertical',920,1),
('same2014','SN28B','¿Cuándo fue la ultima vez que consumió esta sustancia? ','SMI1','','Marih',null,'vertical',930,1),
('same2014','SN29A','¿Alguna vez probó cocaina? ','SMI1','','Coca',null,'vertical',940,1),
('same2014','SN29B','¿Cuándo fue la ultima vez que consumió esta sustancia? ','SMI1','','Coca',null,'vertical',950,1),
('same2014','SN30A','¿Alguna vez probó paco o pasta base? ','SMI1','','Paco',null,'vertical',960,1),
('same2014','SN30B','¿Cuándo fue la ultima vez que consumió esta sustancia? ','SMI1','','Paco',null,'vertical',970,1),
('same2014','SN31A','¿Alguna vez probó sustancias como pegamento o similares para inhalar o aspirar? ','SMI1','','Inhalables',null,'vertical',980,1),
('same2014','SN31B','¿Cuándo fue la ultima vez que tomó inhalables? ','SMI1','','Inhalables',null,'vertical',990,1),
('same2014','SN32A','¿Alguna vez probó extasis u otras drogas de diseño? ','SMI1','','Extasis',null,'vertical',1000,1),
('same2014','SN32B','¿Cuándo fue la ultima vez que consumió alguna de estas sustancias? ','SMI1','','Extasis',null,'vertical',1010,1),
('same2014','SN33A','¿Consumió alguna vez alucinógenos (como LSD, ácido, ketamina u otros? ','SMI1','','Alucinogenos',null,'vertical',1020,1),
('same2014','SN33B','¿Cuándo fue la ultima vez que consumió? ','SMI1','','Alucinogenos',null,'vertical',1030,1),
('same2014','SN34A','¿Consumió alguna vez opiáceos (como heroína, codeína, klosidol u otros? ','SMI1','','Opiaceos',null,'vertical',1040,1),
('same2014','SN34B','¿Cuándo fue la ultima vez que consumió? ','SMI1','','Opiaceos',null,'vertical',1050,1),
('same2014','SN35','¿Alguna vez ha percibido que el consumo de alguna de estas sustancias interfiere perjudicialmente en su salud, en su vida laboral, en su vida social o en su vida familiar? (E-S)','SMI1','','Opiaceos',null,'vertical',1060,1),
('same2014','TEL','¿Podría usted proveer un número telefónico de contacto por si es necesario confirmar o clarificar alguna de estas preguntas? ','SMI1','','Opiaceos',null,'vertical',1070,1),
('same2014','NOREAIND','RAZON DE NO RESPUESTA INDIVIDUAL ','SMI1','','Opiaceos',null,'vertical',2000,1)
;

--Varables de la Tem y de norea copiadas de la eah2013
insert into encu.bloques 
select 'same2014' as blo_ope, 'SMI1' AS blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
       210 as blo_orden, blo_aclaracion, 1 as blo_tlg 
       from encu.bloques
       where blo_ope='eah2013' and blo_blo ='RAZON';
              ------------------------delete from encu.bloques where blo_ope='same2014' and blo_blo ='RAZON';

insert into encu.bloques       
select 'same2014' as blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
       blo_orden, blo_aclaracion, 1 as blo_tlg 
       from encu.bloques
       where blo_ope='eah2013' and blo_for ='TEM';

insert into encu.preguntas 
SELECT 'same2014' as pre_ope, pre_pre, pre_texto, pre_abreviado, 'SMI1' AS pre_for, pre_mat, 
       pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
       pre_orden, 1 as pre_tlg
  FROM encu.preguntas
  where pre_ope='eah2013' and pre_pre like ('razon%');
  ----------------------------delete from encu.preguntas where pre_ope='same2014' and pre_pre like ('razon%');

insert into encu.preguntas 
SELECT 'same2014' as pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
       pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
       pre_orden, 1 as pre_tlg
from encu.preguntas where pre_ope='eah2013' and pre_for='TEM';

INSERT INTO encu.preguntas(
            pre_ope, pre_pre, pre_texto, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_desp_opc,  
            pre_orden, pre_tlg)
            values           
('same2014','Observaciones','Observaciones ','SMI1','','RAZON',null,'vertical',1010,1);

INSERT INTO encu.con_opc
SELECT 'same2014' as conopc_ope, conopc_conopc, conopc_texto, conopc_despliegue, conopc_tlg
  FROM encu.con_opc
where conopc_ope='eah2013' and conopc_conopc in (select var_conopc from encu.variables where var_for='TEM');
--0 filas

INSERT INTO encu.con_opc
SELECT 'same2014' as conopc_ope, conopc_conopc, conopc_texto, conopc_despliegue, conopc_tlg
FROM encu.con_opc
where conopc_ope='eah2013' and conopc_conopc like 'razon%';


insert into encu.variables
SELECT 'same2014' as var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
       var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
       var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
       var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
       var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
       var_advertencia_inf, var_destino_nsnc, 1 as var_tlg
from encu.variables
where var_ope='eah2013' and  var_for='TEM';

insert into encu.variables
SELECT 'same2014' as var_ope, 'SMI1' as var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
       var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
       var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
       var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
       var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
       var_advertencia_inf, var_destino_nsnc, 1 as var_tlg
from encu.variables
where var_ope='eah2013' and var_var like ('razon%') and var_for = 'S1';

---------------------delete from encu.variables where var_ope='same2014' and var_var like ('razon%') and var_for = 'SM1';

INSERT INTO encu.con_opc VALUES ('same2014','entreaind',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','entrea',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','v1',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','e12a',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','e2',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','e6a',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','ghq_12',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','h1',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','h2',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','it2',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','m1',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','noreaind',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','p4',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','p5',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','sexo',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','si_no',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','si_no_h',null, 'horizontal',1);
INSERT INTO encu.con_opc VALUES ('same2014','si_no_nosabe3',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','si_no_nosabe9',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','sn_medico',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','sn_receta',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','sn_ultvez',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','t11',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','t29b',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','t3',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','t4',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','t44',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','t45',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','t46',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','t49',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','t51',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','v12',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','v2',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','v5',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','v6',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','p2',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','t29c',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','ghq12',null, 'vertical',1);
INSERT INTO encu.con_opc VALUES ('same2014','sn23',null, 'vertical',1);

insert into encu.variables
SELECT 'same2014' as var_ope, 'SM1' as var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
       var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
       var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
       var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
       var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
       var_advertencia_inf, var_destino_nsnc, 1 as var_tlg
from encu.variables
where var_ope='eah2013' and 
var_var in ('h1','h2','h2_esp','h3','v12','v2','v2_esp','v4','v5','v5_esp','v6','v7') and var_for = 'A1';


insert into encu.opciones
SELECT 'same2014' as opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, 
       opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, 1 as opc_tlg
  FROM encu.opciones where opc_ope='eah2013' and opc_conopc in (select var_conopc from encu.variables where var_for='TEM');
--0 filas

insert into encu.opciones
SELECT 'same2014' as opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, 
       opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, 1 as opc_tlg
  FROM encu.opciones where opc_ope='eah2013' and opc_conopc like 'razon%';


insert into encu.opciones
SELECT 'same2014' as opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, 
       opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, 1 as opc_tlg
  FROM encu.opciones where opc_ope='eah2013' and opc_conopc in (select var_conopc from encu.variables where var_var in ('h1','h2','h2_esp','h3','v12','v2','v2_esp','v4','v5','v5_esp','v6','v7') and var_for = 'A1' and var_conopc is not null);



INSERT INTO encu.saltos(
            sal_ope, sal_var, sal_conopc, sal_opc, sal_destino, sal_tlg)
    VALUES 
('same2014','v12','v12','4','H2',1);


INSERT INTO encu.variables(var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion,var_conopc, var_tipovar,var_destino, var_subordinada_var, var_subordinada_opcion, var_expresion_habilitar, var_optativa, var_orden, var_maximo, var_minimo, var_tlg) VALUES
('same2014','SM1','','ENTREA','entrea',null,null,'si_no','si_no',null,null,null,null,'false','10','2','1',1),
('same2014','SM1','','RESPOND','respond',null,null,null,'si_no',null,null,null,null,'true','10','20','1',1),
('same2014','SM1','','NOMBRER','nombrer',null,null,null,'texto',null,null,null,null,'true','10',null,null,1),
('same2014','SM1','','F_REALIZ_O','f_realiz_o',null,null,null,'fecha_corta',null,null,null,null,'false','10',null,null,1),
('same2014','SM1','','V1','v1',null,null,'si_no','si_no',null,null,null,null,'false','10','2','1',1),
('same2014','SM1','','TOTAL_H','total_h',null,null,null,'si_no',null,null,null,null,'false','10','99','1',1),
('same2014','SM1','','TOTAL_M','total_m',null,null,null,'numeros',null,null,null,null,'false','10','20','1',1),
('same2014','SM1','P','P1','p1',null,null,null,'texto',null,null,null,null,'false','10',null,null,1),
('same2014','SM1','P','P2','p2',null,null,'sexo','opciones',null,null,null,null,'false','10','2','1',1),
('same2014','SM1','P','P3A','p3a',null,null,null,'fecha',null,null,null,null,'false','10',null,null,1),
('same2014','SM1','P','P3B','p3b',null,null,null,'anios',null,null,null,null,'false','10','99','0',1),
('same2014','SM1','P','P4','p4',null,null,'p4','opciones',null,null,null,null,'false','10','14','1',1),
('same2014','SM1','P','P5','p5',null,null,'p5','opciones',null,null,null,null,'false','10','8','1',1),
('same2014','SM1','P','L0','l0',null,null,null,'texto',null,null,null,null,'false','10',null,null,1),
('same2014','SM1','','TP','tp',null,null,null,'numeros',null,null,null,null,'false','10',null,null,1),
('same2014','SM1','','CR','cr_num_miembro',null,null,null,'numeros',null,null,null,null,'false','10',null,null,1),
('same2014','SM1','','CR','cr_ningun_miembro',null,null,null,'marcar','fin',null,null,null,'false','20',null,null,1),
('same2014','SM1','P','M1','m1',null,null,'m1','opciones',null,null,null,null,'false','10','4','1',1),
('same2014','SM1','P','E2','e2',null,null,'e2','opciones',null,null,null,null,'false','10','3','1',1),
('same2014','SM1','P','E6A','e6a',null,null,'e6a','opciones',null,null,null,null,'false','10','7','1',1),
('same2014','SM1','P','E12A','e12a',null,null,'e12a','opciones',null,null,null,null,'false','10','7','1',1),
('same2014','SM1','P','E13','e13',null,null,'si_no','si_no',null,null,null,null,'false','10','2','1',1),
('same2014','SM1','P','SN1B','sn1b_1',null,null,'si_no_h','si_no',null,null,null,null,'false','10',null,null,1),
('same2014','SM1','P','SN1B','sn1b_7',null,null,'si_no_h','si_no',null,null,null,null,'false','20',null,null,1),
('same2014','SM1','P','SN1B','sn1b_2',null,null,'si_no_h','si_no',null,null,null,null,'false','30',null,null,1),
('same2014','SM1','P','SN1B','sn1b_3',null,null,'si_no_h','si_no',null,null,null,null,'false','40',null,null,1),
('same2014','SM1','P','SN1B','sn1b_4',null,null,'si_no_h','si_no',null,null,null,null,'false','50',null,null,1),
('same2014','SM1','P','SN1B','sn1b_9',null,null,'si_no_h','si_no',null,null,null,null,'false','60',null,null,1),
('same2014','SM1','','IT1','it1_monto','Monto',null,null,'monetaria','FILTRO_1',null,null,null,'false','10',null,null,1),
('same2014','SM1','','IT1','it1_nsnc','Ns/Nc',null,null,'marcar',null,null,null,null,'false','20',null,null,1),
('same2014','SM1','','IT2','it2',null,null,'it2','opciones',null,null,null,null,'false','10','10','1',1),
('same2014','SM1','','JHT1','jht1',null,null,'si_no','si_no',null,null,null,null,'false','10','2','1',1),
('same2014','SM1','','JHT2','jht2',null,null,'si_no','si_no',null,null,null,null,'false','10','2','1',1),
('same2014','SM1','','JHT3','jht3',null,null,'t3','opciones',null,null,null,null,'false','10','5','1',1),
('same2014','SM1','','JHT4','jht4',null,null,'t4','opciones',null,null,null,null,'false','10','5','1',1),
('same2014','SM1','','JHT5','jht5',null,null,'si_no_nosabe3','si_no',null,null,null,null,'false','10','3','1',1),
('same2014','SM1','','JHT6','jht6',null,null,'si_no_nosabe3','si_no',null,null,null,null,'false','10','3','1',1),
('same2014','SM1','','JHT9','jht9',null,null,'si_no','si_no',null,null,null,null,'false','10','2','1',1),
('same2014','SM1','','JHT10','jht10',null,null,'si_no','si_no',null,null,null,null,'false','10','2','1',1),
('same2014','SM1','','JHT11','jht11',null,null,'t11','opciones',null,null,null,null,'false','10','4','1',1),
('same2014','SM1','','JHT11','jht11_esp',null,null,null,'texto_especificar','Bloind','jht11','4','jht11=4','false','20',null,null,1),
('same2014','SM1','','JHT44','jht44',null,null,'t44','opciones',null,null,null,null,'false','10','3','1',1),
('same2014','SM1','','JHT45','jht45',null,null,'t45','opciones',null,null,null,null,'false','10','3','1',1),
('same2014','SM1','','JHT46','jht46',null,null,'t46','opciones','Bloind',null,null,null,'false','10','3','1',1),
('same2014','SM1','','JHT49','jht49',null,null,'t49','opciones',null,null,null,null,'false','10','3','1',1),
('same2014','SM1','','JHT51','jht51',null,null,'t51','opciones',null,null,null,null,'false','10','3','1',1),
('same2014','SM1','','JHT29B','jht29b',null,null,'t29b','opciones',null,null,null,null,'false','10','3','1',1),
('same2014','SM1','','JHT29C','jht29c',null,null,'si_no','si_no',null,null,null,null,'false','10','2','1',1),
('same2014','SMI1','','T1','t1',null,null,'si_no','si_no',null,null,null,null,'false','10','2','1',1),
('same2014','SMI1','','T2','t2',null,null,'si_no','si_no',null,null,null,null,'false','10','2','1',1),
('same2014','SMI1','','T3','t3',null,null,'t3','opciones',null,null,null,null,'false','10','5','1',1),
('same2014','SMI1','','T4','t4',null,null,'t4','opciones',null,null,null,null,'false','10','5','1',1),
('same2014','SMI1','','T5','t5',null,null,'si_no_nosabe3','si_no',null,null,null,null,'false','10','3','1',1),
('same2014','SMI1','','T6','t6',null,null,'si_no_nosabe3','si_no',null,null,null,null,'false','10','3','1',1),
('same2014','SMI1','','T9','t9',null,null,'si_no','si_no',null,null,null,null,'false','10','2','1',1),
('same2014','SMI1','','T10','t10',null,null,'si_no','si_no',null,null,null,null,'false','10','2','1',1),
('same2014','SMI1','','T11','t11',null,null,'t11','opciones',null,null,null,null,'false','10','4','1',1),
('same2014','SM1','','T11','t11_esp',null,null,null,'texto_especificar','Salud','t11','4','t11=4','false','20',null,null,1),
('same2014','SMI1','','T44','t44',null,null,'t44','opciones',null,null,null,null,'false','10','3','1',1),
('same2014','SMI1','','T45','t45',null,null,'t45','opciones',null,null,null,null,'false','10','3','1',1),
('same2014','SMI1','','T46','t46',null,null,'t46','opciones','Salud',null,null,null,'false','10','3','1',1),
('same2014','SMI1','','T49','t49',null,null,'t49','opciones',null,null,null,null,'false','10','3','1',1),
('same2014','SMI1','','T51','t51',null,null,'t51','opciones',null,null,null,null,'false','10','3','1',1),
('same2014','SMI1','','T29B','t29b',null,null,'t29b','opciones',null,null,null,null,'false','10','3','1',1),
('same2014','SMI1','','T29C','t29c',null,null,'si_no','si_no',null,null,null,null,'false','10','2','1',1),
('same2014','SMI1','','SN15A','SN15a1','Tensión alta',null,'si_no_h','si_no',null,null,null,null,'false','10',null,null,1),
('same2014','SMI1','','SN15A','SN15a2','Infarto de miocardio',null,'si_no_h','si_no',null,null,null,null,'false','20',null,null,1),
('same2014','SMI1','','SN15A','SN15a3','Otras enfermedades del corazón',null,'si_no_h','si_no',null,null,null,null,'false','30',null,null,1),
('same2014','SMI1','','SN15A','SN15a4','Várices en las piernas',null,'si_no_h','si_no',null,null,null,null,'false','40',null,null,1),
('same2014','SMI1','','SN15A','SN15a5','Artrosis, artritis o reumatismo',null,'si_no_h','si_no',null,null,null,null,'false','50',null,null,1),
('same2014','SMI1','','SN15A','SN15a6','Dolor de espalda crónico (cervical)',null,'si_no_h','si_no',null,null,null,null,'false','60',null,null,1),
('same2014','SMI1','','SN15A','SN15a7','Dolor de espalda crónico (lumbar)',null,'si_no_h','si_no',null,null,null,null,'false','70',null,null,1),
('same2014','SMI1','','SN15A','SN15a8','Alergia crónica',null,'si_no_h','si_no',null,null,null,null,'false','80',null,null,1),
('same2014','SMI1','','SN15A','SN15a9','Asma',null,'si_no_h','si_no',null,null,null,null,'false','90',null,null,1),
('same2014','SMI1','','SN15A','SN15a10','Bronquitis crónica',null,'si_no_h','si_no',null,null,null,null,'false','100',null,null,1),
('same2014','SMI1','','SN15A','SN15a11','Diabetes',null,'si_no_h','si_no',null,null,null,null,'false','110',null,null,1),
('same2014','SMI1','','SN15A','SN15a12','Úlcera de estómago o duodeno',null,'si_no_h','si_no',null,null,null,null,'false','120',null,null,1),
('same2014','SMI1','','SN15A','SN15a13','Incontinencia urinaria',null,'si_no_h','si_no',null,null,null,null,'false','130',null,null,1),
('same2014','SMI1','','SN15A','SN15a14','Colesterol alto',null,'si_no_h','si_no',null,null,null,null,'false','140',null,null,1),
('same2014','SMI1','','SN15A','SN15a15','Cataratas',null,'si_no_h','si_no',null,null,null,null,'false','150',null,null,1),
('same2014','SMI1','','SN15A','SN15a16','Problemas crónicos de piel',null,'si_no_h','si_no',null,null,null,null,'false','160',null,null,1),
('same2014','SMI1','','SN15A','SN15a17','Estreñimiento crónico',null,'si_no_h','si_no',null,null,null,null,'false','170',null,null,1),
('same2014','SMI1','','SN15A','SN15a18','Depresión, ansiedad u otros trastornos mentales',null,'si_no_h','si_no',null,null,null,null,'false','180',null,null,1),
('same2014','SMI1','','SN15A','SN15a19','Embolia',null,'si_no_h','si_no',null,null,null,null,'false','190',null,null,1),
('same2014','SMI1','','SN15A','SN15a20','Migraña o dolor de cabeza frecuente',null,'si_no_h','si_no',null,null,null,null,'false','200',null,null,1),
('same2014','SMI1','','SN15A','SN15a21','Hemorroides',null,'si_no_h','si_no',null,null,null,null,'false','210',null,null,1),
('same2014','SMI1','','SN15A','SN15a22','Tumores malignos',null,'si_no_h','si_no',null,null,null,null,'false','220',null,null,1),
('same2014','SMI1','','SN15A','SN15a23','Osteoporosis',null,'si_no_h','si_no',null,null,null,null,'false','230',null,null,1),
('same2014','SMI1','','SN15A','SN15a24','Anemia',null,'si_no_h','si_no',null,null,null,null,'false','240',null,null,1),
('same2014','SMI1','','SN15A','SN15a25','Problemas de tiroides',null,'si_no_h','si_no',null,null,null,null,'false','250',null,null,1),
('same2014','SMI1','','SN15A','SN15a26','Problemas de próstata (solo hombres)',null,'si_no_h','si_no',null,null,null,null,'false','260',null,null,1),
('same2014','SMI1','','SN15A','SN15a27','Problemas del periodo menopáusico (solo mujeres)',null,'si_no_h','si_no',null,null,null,null,'false','270',null,null,1),
('same2014','SMI1','','SN15A','SN15a28','Otra enfermedad (especificar)',null,'si_no_h','si_no',null,null,null,null,'false','280',null,null,1),
('same2014','SMI1','','SN15A','sn15a28_esp',null,null,null,'texto_especificar',null,'sn15a28','1','sn15a28=1','false','290',null,null,1),
('same2014','SMI1','','GHQ_12','ghq_12_1','¿Ha podido concentrarse bien en lo que hacìa?',null,'ghq_12','opciones',null,null,null,null,'false','10','9','0',1),
('same2014','SMI1','','GHQ_12','ghq_12_2','¿Sus preocupaciones le han hecho perder mucho sueño?',null,'ghq_12','opciones',null,null,null,null,'false','20','9','0',1),
('same2014','SMI1','','GHQ_12','ghq_12_3','¿Ha sentido que està desempeñando un papel ùtil en la vida?',null,'ghq_12','opciones',null,null,null,null,'false','30','9','0',1),
('same2014','SMI1','','GHQ_12','ghq_12_4','¿Se ha sentido capaz de tomar decisiones?',null,'ghq_12','opciones',null,null,null,null,'false','40','9','0',1),
('same2014','SMI1','','GHQ_12','ghq_12_5','¿Se ha notado constantemente agobiado y en tensiòn?',null,'ghq_12','opciones',null,null,null,null,'false','50','9','0',1),
('same2014','SMI1','','GHQ_12','ghq_12_6','¿Ha tenido la sensaciòn de que no puede superar sus dificultades?',null,'ghq_12','opciones',null,null,null,null,'false','60','9','0',1),
('same2014','SMI1','','GHQ_12','ghq_12_7','¿Ha sido capaz de disfrutar de sus actividades normales de cada dìa?',null,'ghq_12','opciones',null,null,null,null,'false','70','9','0',1),
('same2014','SMI1','','GHQ_12','ghq_12_8','¿Ha sido capaz de hacer frente adecuadamente a sus problemas?',null,'ghq_12','opciones',null,null,null,null,'false','80','9','0',1),
('same2014','SMI1','','GHQ_12','ghq_12_9','¿Se ha sentido poco feliz o deprimido?',null,'ghq_12','opciones',null,null,null,null,'false','90','9','0',1),
('same2014','SMI1','','GHQ_12','ghq_12_10','¿Ha perdido confianza en sì mismo?',null,'ghq_12','opciones',null,null,null,null,'false','100','9','0',1),
('same2014','SMI1','','GHQ_12','ghq_12_11','¿Ha pensado que usted es una persona que no vale para nada?',null,'ghq_12','opciones',null,null,null,null,'false','110','9','0',1),
('same2014','SMI1','','GHQ_12','ghq_12_12','¿Se siente razonablemente feliz considerando todas las circunstancias?',null,'ghq_12','opciones',null,null,null,null,'false','120','9','0',1),
('same2014','SMI1','','SN19','sn19',null,null,'si_no_nosabe9','si_no',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN20','sn20',null,null,'si_no_nosabe9','si_no',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN21','sn21',null,null,'si_no_nosabe9','si_no',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN22','sn22',null,null,'si_no_nosabe9','si_no','Tabaco',null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN23','sn23_1','No sabía dónde ir',null,'si_no_h','si_no',null,null,null,null,'false','10',null,null,1),
('same2014','SMI1','','SN23','sn23_2','No tenía tiempo',null,'si_no_h','si_no',null,null,null,null,'false','20',null,null,1),
('same2014','SMI1','','SN23','sn23_3','No tenía dinero',null,'si_no_h','si_no',null,null,null,null,'false','30',null,null,1),
('same2014','SMI1','','SN23','sn23_4','El lugar de atención queda muy lejos',null,'si_no_h','si_no',null,null,null,null,'false','40',null,null,1),
('same2014','SMI1','','SN23','sn23_5','El problema no le parecìa tan importante',null,'si_no_h','si_no',null,null,null,null,'false','50',null,null,1),
('same2014','SMI1','','SN23','sn23_6','No cree que un profesional pueda ayudarlo',null,'si_no_h','si_no',null,null,null,null,'false','60',null,null,1),
('same2014','SMI1','','SN23','sn23_7','Va a consultar más adelante',null,'si_no_h','si_no',null,null,null,null,'false','70',null,null,1),
('same2014','SMI1','','SN23','sn23_8','Pidió turno y todavía no lo atendieron',null,'si_no_h','si_no',null,null,null,null,'false','80',null,null,1),
('same2014','SMI1','','SN23','sn23_9','Pidió turno pero no fue porque demoraba mucho tiempo',null,'si_no_h','si_no',null,null,null,null,'false','90',null,null,1),
('same2014','SMI1','','SN23','sn23_10','Pidió turno pero no había',null,'si_no_h','si_no',null,null,null,null,'false','100',null,null,1),
('same2014','SMI1','','SN23','sn23_11','Otra razón (especificar)',null,'si_no_h','si_no',null,null,null,null,'false','110',null,null,1),
('same2014','SMI1','','SN23','sn23_11_esp',null,null,'si_no_h','texto_especificar',null,'sn23_11','1','sn23_11=1','false','120',null,null,1),
('same2014','SMI1','','SN24A','sn24a',null,null,'si_no_nosabe9','si_no',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN24B','sn24b',null,null,'sn_ultvez','opciones',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN25A','sn25a',null,null,'si_no_nosabe9','si_no',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN25B','sn25b',null,null,'sn_ultvez','opciones',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN26A','sn26a',null,null,'si_no_nosabe9','si_no',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN26B','sn26b',null,null,'sn_receta','opciones',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN26C','sn26c',null,null,'sn_medico','opciones','Antid',null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN26D','sn26d',null,null,'sn_ultvez','opciones',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN27A','sn27a',null,null,'si_no_nosabe9','si_no',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN27B','sn27b',null,null,'sn_receta','opciones',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN27C','sn27c',null,null,'sn_medico','opciones','Marih',null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN27D','sn27d',null,null,'sn_ultvez','opciones',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN28A','sn28a',null,null,'si_no_nosabe9','si_no',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN28B','sn28b',null,null,'sn_ultvez','opciones',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN29A','sn29a',null,null,'si_no_nosabe9','si_no',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN29B','sn29b',null,null,'sn_ultvez','opciones',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN30A','sn30a',null,null,'si_no_nosabe9','si_no',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN30B','sn30b',null,null,'sn_ultvez','opciones',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN31A','sn31a',null,null,'si_no_nosabe9','si_no',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN31B','sn31b',null,null,'sn_ultvez','opciones',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN32A','sn32a',null,null,'si_no_nosabe9','si_no',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN32B','sn32b',null,null,'sn_ultvez','opciones',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN33A','sn33a',null,null,'si_no_nosabe9','si_no',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN33B','sn33b',null,null,'sn_ultvez','opciones',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN34A','sn34a',null,null,'si_no_nosabe9','si_no',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN34B','sn34b',null,null,'sn_ultvez','opciones',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','SN35','sn35',null,null,'si_no_nosabe9','si_no',null,null,null,null,'false','10','9','1',1),
('same2014','SMI1','','TEL','tel1','Teléfono fijo',null,null,'Texto',null,null,null,null,'true','10',null,null,1),
('same2014','SMI1','','TEL','tel2','Teléfono móvil',null,null,'Texto',null,null,null,null,'true','20',null,null,1),
('same2014','SMI1','','Observaciones','observaciones',null,null,null,null,null,null,null,null,'true','10',null,null,1),
('same2014','SMI1','','NOREAIND','noreaind',null,null,'noreaind','opciones',null,null,null,null,'false','10','9','7',1),
('same2014','SMI1','','NOREAIND','noreaind_esp',null,null,null,'texto_especificar',null,'noreaind','9','noreaind=9','false','20',null,null,1);


UPDATE encu.variables set var_texto='…una obra social?' where var_var='sn1b_1';
UPDATE encu.variables set var_texto='…una prepaga o mutual via obra social?' where var_var='sn1b_7';
UPDATE encu.variables set var_texto='…una mutual?' where var_var='sn1b_2';
UPDATE encu.variables set var_texto='…un plan de medicina prepaga por contratación voluntaria?' where var_var='sn1b_3';
UPDATE encu.variables set var_texto='…un sistema de emergencias médicas?' where var_var='sn1b_4';
UPDATE encu.variables set var_texto='(No leer) No tiene afiliación' where var_var='sn1b_9';

UPDATE encu.variables set var_texto='No sabía dónde ir' where var_var='sn23_1';
UPDATE encu.variables set var_texto='No tenía tiempo' where var_var='sn23_2';
UPDATE encu.variables set var_texto='No tenía dinero' where var_var='sn23_3';
UPDATE encu.variables set var_texto='El lugar de atención queda muy lejos' where var_var='sn23_4';
UPDATE encu.variables set var_texto='El problema no le parecía tan importante' where var_var='sn23_5';
UPDATE encu.variables set var_texto='No cree que un profesional pueda ayudarlo' where var_var='sn23_6';
UPDATE encu.variables set var_texto='Va a consultar más adelante' where var_var='sn23_7';
UPDATE encu.variables set var_texto='Pidió turno y todavía no lo atendieron' where var_var='sn23_8';
UPDATE encu.variables set var_texto='Pidió turno pero no fue porque demoraba mucho tiempo' where var_var='sn23_9';
UPDATE encu.variables set var_texto='Pidió turno pero no había' where var_var='sn23_10';
UPDATE encu.variables set var_texto='Otra razón (especificar)' where var_var='sn23_11';



INSERT INTO encu.opciones(
            opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, 
            opc_tlg)
VALUES
('same2014','entreaind','1','Sí',null,'1',1),
('same2014','entreaind','2','No',null,'2',1),
('same2014','sexo','1','varón',null,'1',1),
('same2014','sexo','2','mujer',null,'2',1),
('same2014','entrea','1','Sí',null,'1',1),
('same2014','entrea','2','No',null,'2',1),
('same2014','v1','1','Sí',null,'1',1),
('same2014','v1','2','No',null,'2',1),
('same2014','si_no_h','1','Sí',null,'1',1),
('same2014','si_no_h','2','No',null,'2',1),
('same2014','si_no_nosabe3','1','Si',null,'1',1),
('same2014','si_no_nosabe3','2','No',null,'2',1),
('same2014','si_no_nosabe3','3','No sabe',null,'3',1),
('same2014','si_no_nosabe9','1','Si',null,'1',1),
('same2014','si_no_nosabe9','2','No',null,'2',1),
('same2014','si_no_nosabe9','9','No sabe',null,'3',1),
('same2014','p2','1','Varón',null,'1',1),
('same2014','p2','2','Mujer',null,'2',1),
('same2014','m1','1','En esta ciudad',null,'1',1),
('same2014','m1','2','En la provincia de Buenos Aires ','(especificar partido)','2',1),
('same2014','m1','3','En otra provincia ','(especificar provincia)','3',1),
('same2014','m1','4','En otro país ','(especificar país)','4',1),
('same2014','e2','1','Asiste',null,'1',1),
('same2014','e2','2','No asiste pero asistió',null,'2',1),
('same2014','e2','3','Nunca asistió',null,'3',1),
('same2014','e6a','1','Jardín de infantes/ Maternal',null,'1',1),
('same2014','e6a','2','Primario',null,'2',1),
('same2014','e6a','3','Secundario/ Medio común',null,'3',1),
('same2014','e6a','4','Terciario/superior no universitario',null,'4',1),
('same2014','e6a','5','Universitario',null,'5',1),
('same2014','e6a','6','Postgrado',null,'6',1),
('same2014','e6a','7','Educación especial',null,'7',1),
('same2014','e12a','1','Jardín de infantes/ Maternal',null,'1',1),
('same2014','e12a','2','Primario/ EGB',null,'2',1),
('same2014','e12a','3','Secundario/ Medio común/ EGB2/ EGB3',null,'3',1),
('same2014','e12a','4','Terciario/superior no universitario',null,'4',1),
('same2014','e12a','5','Universitario',null,'5',1),
('same2014','e12a','6','Postgrado',null,'6',1),
('same2014','e12a','7','Educación especial',null,'7',1),
('same2014','it2','1','$1 a $2000',null,'1',1),
('same2014','it2','2','$2001 a $3250',null,'2',1),
('same2014','it2','3','$3251 a $4000',null,'3',1),
('same2014','it2','4','$4001 a $5000',null,'4',1),
('same2014','it2','5','$5001 a $6000',null,'5',1),
('same2014','it2','6','$6001 a $7500',null,'6',1),
('same2014','it2','7','$7501 a $9000',null,'7',1),
('same2014','it2','8','$9001 a $11600',null,'8',1),
('same2014','it2','9','$11601 a $16000',null,'9',1),
('same2014','it2','10','$16001 y más',null,'10',1),
('same2014','t3','1','no deseaba, no quería trabajar?',null,'1',1),
('same2014','t3','2','no podía trabajar por razones personales?
(estudio, ciudado del hogar, etc.)',null,'2',1),
('same2014','t3','3','no tuvo pedidos/clientes?',null,'3',1),
('same2014','t3','4','no tenia trabajo y quería trabajar?',null,'4',1),
('same2014','t3','5','tenia un trabajo o negocio al que no concurrió?',null,'5',1),
('same2014','t4','1','licencia, vacaciones o enfermedad?',null,'1',1),
('same2014','t4','2','otras causas personales (viajes, tramites, etc.)?',null,'2',1),
('same2014','t4','3','huelga o conflicto laboral?',null,'3',1),
('same2014','t4','4','suspensión de un trabajo en relación de dependencia?',null,'4',1),
('same2014','t4','5','otras causas laborales (rotura de equipo, falta de materias primas, mal tiempo,etc.)?',null,'5',1),
('same2014','t11','1','tenia un trabajo asegurado?',null,'1',1),
('same2014','t11','2','esta suspendido y espera ser llamado?',null,'2',1),
('same2014','t11','3','se canso de buscar trabajo?',null,'3',1),
('same2014','t11','4','por otras razones? (especificar)',null,'4',1),
('same2014','t44','1','para su propio negocio/empresa/actividad?',null,'1',1),
('same2014','t44','2','para el negocio/empresa/actividad de un familiar?',null,'2',1),
('same2014','t44','3','para un patrón/empresa/institución?',null,'3',1),
('same2014','t45','1','le pagan sueldo (en dinero/especie)?',null,'1',1),
('same2014','t45','2','retira dinero?',null,'2',1),
('same2014','t45','3','no le pagan ni retira dinero?',null,'3',1),
('same2014','t46','1','Si, siempre',null,'1',1),
('same2014','t46','2','Sólo a veces o por temporadas',null,'2',1),
('same2014','t46','3','No emplea ni contrata personal',null,'3',1),
('same2014','t49','1','Sí ','(temporario, contrato por obra, etc.)','1',1),
('same2014','t49','2','No ','( permanente, fijo, estable, etc.)','2',1),
('same2014','t49','3','Ns/ Nc',null,'3',1),
('same2014','t51','1','le descuentan para jubilación?',null,'1',1),
('same2014','t51','2','aporta por si mismo para jubilación?',null,'2',1),
('same2014','t51','3','no le descuentan ni aporta?',null,'3',1),
('same2014','t29b','1','Menos de 35 horas semanales',null,'1',1),
('same2014','t29b','2','Entre 35 y 45 horas semanales',null,'2',1),
('same2014','t29b','3','Mas de 45 horas semanales',null,'3',1),
('same2014','t29c','1','Si',null,'1',1),
('same2014','ghq12','0','Mejor que lo habitual',null,'0',1),
('same2014','ghq12','1','Igual que lo habitual',null,'1',1),
('same2014','ghq12','2','Menos que lo habitual',null,'2',1),
('same2014','ghq12','3','Mucho menos que lo habitual',null,'3',1),
('same2014','ghq12','8','No sabe',null,'8',1),
('same2014','ghq12','9','No contesta',null,'9',1),
('same2014','sn23','1','No sabía dónde ir',null,'1',1),
('same2014','sn23','2','No tenía tiempo',null,'2',1),
('same2014','sn23','3','No tenía dinero',null,'3',1),
('same2014','sn23','4','El lugar de atención queda muy lejos',null,'4',1),
('same2014','sn23','5','El problema no le parecía tan importante',null,'5',1),
('same2014','sn23','6','No cree que un profesional pueda ayudarlo',null,'6',1),
('same2014','sn23','7','Va a consultar más adelante',null,'7',1),
('same2014','sn23','8','Pidió turno y todavía no lo atendieron',null,'8',1),
('same2014','sn23','9','Pidió turno pero no fue porque demoraba mucho tiempo',null,'9',1),
('same2014','sn23','10','Pidió turno pero no había',null,'10',1),
('same2014','sn23','11','Otra razón (especificar)',null,'11',1),
('same2014','sn_ultvez','1','En los últimos 30 días',null,'1',1),
('same2014','sn_ultvez','2','Hace más de un mes pero menos de un año',null,'2',1),
('same2014','sn_ultvez','3','Hace un año o más',null,'3',1),
('same2014','sn_ultvez','9','Ns/ Nc',null,'9',1),
('same2014','sn_receta','1','…con indicación médica?',null,'1',1),
('same2014','sn_receta','2','…por su cuenta?',null,'2',1),
('same2014','sn_receta','3','…primero con indicación médica y luego en mayor cantidad o por más tiempo de lo que le habían indicado?',null,'3',1),
('same2014','sn_receta','9','Ns/ Nc',null,'9',1),
('same2014','sn_medico','1','Médico clínico',null,'1',1),
('same2014','sn_medico','2','Psiquiatra',null,'2',1),
('same2014','sn_medico','3','Otros especialistas',null,'3',1),
('same2014','sn_medico','9','Ns/ Nc',null,'9',1),
('same2014','noreaind','7','Ausencia',null,'7',1),
('same2014','noreaind','8','Rechazo',null,'8',1),
('same2014','noreaind','9','Otras causas (especificar)',null,'9',1);

insert into encu.preguntas (pre_ope, pre_pre, pre_texto, pre_for, pre_blo, pre_desp_opc, pre_orden, pre_tlg)
VALUES
('same2014', 'P0IND' , 'Número (P0)', 'SMI1', 'Bloind', 'horizontal', 100,1), 
('same2014', 'P1IND' , 'Nombre (P1)', 'SMI1', 'Bloind', 'horizontal', 110,1), 
('same2014', 'P2IND' , 'Sexo (P2)'  , 'SMI1', 'Bloind', 'horizontal', 120,1), 
('same2014', 'P3bIND', 'Edad (P3b)' , 'SMI1', 'Bloind', 'horizontal', 130,1),
('same2014', 'ENTREAIND' , 'Apertura de entrevista individual', 'SMI1', 'Bloind', 'vertical', 140,1)
;

INSERT INTO encu.variables
(var_ope   , var_for, var_mat, var_pre,   var_var,  var_conopc, var_tipovar, var_optativa, var_orden, var_maximo, var_minimo, var_tlg)
VALUES
('same2014','SMI1'  ,''      ,'P0IND'    ,'p0ind'     ,null   ,'numeros'   , false       , 100      , null      , null      , 1), 
('same2014','SMI1'  ,''      ,'P1IND'    ,'p1ind'     ,null   ,'texto'     , false       , 110      , null      , null      , 1), 
('same2014','SMI1'  ,''      ,'P2IND'    ,'p2ind'     ,'sexo' ,'opciones'  , false       , 120      , 2         , 1         , 1), 
('same2014','SMI1'  ,''      ,'P3bIND'   ,'p3bind'    ,null   ,'anios'     , false       , 130      , 65        , 16        , 1), 
('same2014','SMI1'  ,''      ,'ENTREAIND','entreaind' ,'si_no','si_no'     , false       , 140      , 2         , 1         , 1);


INSERT INTO encu.saltos(sal_ope, sal_var, sal_conopc, sal_opc, sal_destino, sal_tlg) values 
('same2014','entreaind','entreaind','2','noreaind',1),
('same2014','entrea','entrea','2','razon',1),
('same2014','v1','v1','2','fin',1),
('same2014','e2','e2','2','E12a',1),
('same2014','e2','e2','3','SN1b',1),
('same2014','jht1','si_no','1','JHT44',1),
('same2014','jht2','si_no','1','JHT44',1),
('same2014','jht3','t3','1','Bloind',1),
('same2014','jht3','t3','2','JHT9',1),
('same2014','jht3','t3','3','JHT9',1),
('same2014','jht3','t3','4','JHT9',1),
('same2014','jht4','t4','1','JHT44',1),
('same2014','jht4','t4','2','JHT44',1),
('same2014','jht4','t4','3','JHT44',1),
('same2014','jht4','t4','5','JHT6',1),
('same2014','jht5','si_no_nosabe3','1','JHT44',1),
('same2014','jht5','si_no_nosabe3','2','JHT9',1),
('same2014','jht5','si_no_nosabe3','3','JHT9',1),
('same2014','jht6','si_no_nosabe3','1','JHT44',1),
('same2014','jht6','si_no_nosabe3','2','JHT9',1),
('same2014','jht6','si_no_nosabe3','3','JHT9',1),
('same2014','jht9','si_no','1','Bloind',1),
('same2014','jht10','si_no','1','Bloind',1),
('same2014','jht11','t11','1','Bloind',1),
('same2014','jht11','t11','2','Bloind',1),
('same2014','jht11','t11','3','Bloind',1),
('same2014','jht44','t44','1','JHT46',1),
('same2014','jht44','t44','3','JHT49',1),
('same2014','jht45','t45','1','JHT49',1),
('same2014','jht45','t45','3','Bloind',1),
('same2014','jht46','t46','1','Bloind',1),
('same2014','jht46','t46','2','Bloind',1),
('same2014','jht46','t46','3','Bloind',1),
('same2014','t1','si_no','1','T44',1),
('same2014','t2','si_no','1','T44',1),
('same2014','t3','t3','1','Bloind',1),
('same2014','t3','t3','2','T9',1),
('same2014','t3','t3','3','T9',1),
('same2014','t3','t3','4','T9',1),
('same2014','t4','t4','1','T44',1),
('same2014','t4','t4','2','T44',1),
('same2014','t4','t4','3','T44',1),
('same2014','t4','t4','5','T6',1),
('same2014','t5','si_no_nosabe3','1','T44',1),
('same2014','t5','si_no_nosabe3','2','T9',1),
('same2014','t5','si_no_nosabe3','3','T9',1),
('same2014','t6','si_no_nosabe3','1','T44',1),
('same2014','t6','si_no_nosabe3','2','T9',1),
('same2014','t6','si_no_nosabe3','3','T9',1),
('same2014','t9','si_no','1','Bloind',1),
('same2014','t10','si_no','1','Bloind',1),
('same2014','t11','t11','1','Bloind',1),
('same2014','t11','t11','2','Bloind',1),
('same2014','t11','t11','3','Bloind',1),
('same2014','t44','t44','1','T46',1),
('same2014','t44','t44','3','T49',1),
('same2014','t45','t45','1','T49',1),
('same2014','t45','t45','3','Bloind',1),
('same2014','t46','t46','1','Bloind',1),
('same2014','t46','t46','2','Bloind',1),
('same2014','t46','t46','3','Bloind',1),
('same2014','sn19','si_no_nosabe9','2','Tabaco',1),
('same2014','sn19','si_no_nosabe9','9','Tabaco',1),
('same2014','sn20','si_no_nosabe9','2','SN23',1),
('same2014','sn20','si_no_nosabe9','9','Tabaco',1),
('same2014','sn24a','si_no_nosabe9','2','Bebalc',1),
('same2014','sn24a','si_no_nosabe9','9','Bebalc',1),
('same2014','sn25a','si_no_nosabe9','2','Tranqui',1),
('same2014','sn25a','si_no_nosabe9','9','Tranqui',1),
('same2014','sn26a','si_no_nosabe9','2','Antid',1),
('same2014','sn26a','si_no_nosabe9','9','Antid',1),
('same2014','sn26b','sn_receta','2','SN26d',1),
('same2014','sn26b','sn_receta','3','SN26d',1),
('same2014','sn26b','sn_receta','9','Antid',1),
('same2014','sn27a','si_no_nosabe9','2','Marih',1),
('same2014','sn27a','si_no_nosabe9','9','Marih',1),
('same2014','sn27b','sn_receta','2','SN27d',1),
('same2014','sn27b','sn_receta','3','SN27d',1),
('same2014','sn27b','sn_receta','9','Marih',1),
('same2014','sn28a','si_no_nosabe9','2','Coca',1),
('same2014','sn28a','si_no_nosabe9','9','Coca',1),
('same2014','sn29a','si_no_nosabe9','2','Paco',1),
('same2014','sn29a','si_no_nosabe9','9','Paco',1),
('same2014','sn30a','si_no_nosabe9','2','Inhalables',1),
('same2014','sn30a','si_no_nosabe9','9','Inhalables',1),
('same2014','sn31a','si_no_nosabe9','2','Extasis',1),
('same2014','sn31a','si_no_nosabe9','9','Extasis',1),
('same2014','sn32a','si_no_nosabe9','2','Alucinogenos',1),
('same2014','sn32a','si_no_nosabe9','9','Alucinogenos',1),
('same2014','sn33a','si_no_nosabe9','2','Opiaceos',1),
('same2014','sn33a','si_no_nosabe9','9','Opiaceos',1),
('same2014','sn34a','si_no_nosabe9','2','FILTRO_2',1),
('same2014','sn34a','si_no_nosabe9','9','FILTRO_2',1);

INSERT INTO encu.filtros(
            fil_ope, fil_for, fil_mat, fil_blo, fil_fil, fil_texto, fil_expresion, 
            fil_destino, fil_orden, fil_aclaracion, fil_tlg)
    VALUES 
('same2014', 'SM1', '', 'Hog', 'FILTRO_1','Si el nùmero de miembro seleccionado de 16 a 64 años es igual a 1 pase a bloque individual', 'cr_num_miembro=1', 'Bloind',500, null, 1),
('same2014', 'SMI1', '', 'Opiaceos', 'FILTRO_2','Si en algunas de las preguntas 24a, 25a, 26a, 27a, 28a, 29a, 30a, 31a, 32a, 33a, 34a respondió NO pase a teléfono', 
'SN24a=2 and SN25a=2 and SN26a=2 and SN27a=2 and SN28a=2 and SN29a=2 and SN30a=2 and SN31a=2 and SN32a=2 and SN33a=2 and SN34a=2', 'TEL',1055, null, 1);

    
update encu.preguntas set pre_orden=pre_orden+200 where pre_blo='RAZON' and pre_ope='same2014';


CREATE OR REPLACE FUNCTION dbo.ope_actual()
  RETURNS text AS
$BODY$
begin
	return 'same2014';
end;
$BODY$
  LANGUAGE plpgsql IMMUTABLE
  COST 100;
ALTER FUNCTION dbo.ope_actual()
  OWNER TO tedede_php;

--borrar rastros del operativo eah2013
DELETE FROM encu.saltos where sal_ope = 'eah2013';
DELETE FROM encu.filtros where fil_ope = 'eah2013';
DELETE FROM encu.opciones where opc_ope = 'eah2013';
delete from encu.respuestas where res_ope = 'eah2013';
delete from encu.con_var where convar_ope = 'eah2013';
update encu.estados set est_ope='same2014' where est_ope = 'eah2013';
update encu.est_var set estvar_ope='same2014' where estvar_ope = 'eah2013';
DELETE FROM encu.variables where var_ope = 'eah2013';
DELETE FROM encu.con_opc where conopc_ope = 'eah2013';
DELETE FROM encu.preguntas where pre_ope = 'eah2013';
DELETE FROM encu.bloques where blo_ope = 'eah2013';
DELETE FROM encu.claves where cla_ope = 'eah2013';
DELETE FROM encu.matrices where mat_ope = 'eah2013';
DELETE FROM encu.formularios where for_ope = 'eah2013';
DELETE FROM encu.consistencias where con_ope = 'eah2013';
update encu.personal set per_ope='same2014' where per_ope = 'eah2013';
DELETE FROM encu.ua where ua_ope = 'eah2013';
DELETE FROM encu.operativos where ope_ope = 'eah2013';

