ALTER TABLE encu.plana_sm1_ RENAME TO plana_s1_;
ALTER TABLE encu.plana_sm1_p RENAME TO plana_s1_p;
ALTER TABLE encu.plana_smi1_ RENAME TO plana_i1_;

--his
ALTER TABLE his.plana_sm1_ RENAME TO plana_s1_;
ALTER TABLE his.plana_sm1_p RENAME TO plana_s1_p;
ALTER TABLE his.plana_smi1_ RENAME TO plana_i1_;
 
update encu.formularios set for_for = 'S1' WHERE for_for = 'SM1';
update encu.formularios set for_for = 'I1' WHERE for_for = 'SMI1'; --verificar

--Tabla his. his_respuestas.
--select hisres_for, regexp_replace(hisres_for,'SM1','S1','g') from his.his_respuestas where hisres_ope='same2014' and hisres_for like '%SM1%';
--select hisres_for, regexp_replace(hisres_for,'SMI1','I1','g') from his.his_respuestas where hisres_ope='same2014' and hisres_for like '%SMI1%';

update his.his_respuestas set hisres_for=regexp_replace(hisres_for,'SM1','S1','g') where hisres_ope='same2014';
update his.his_respuestas set hisres_for=regexp_replace(hisres_for,'SMI1','I1','g') where hisres_ope='same2014';

set search_path = encu;
/*
SELECT con_ope, con_con, con_precondicion, con_rel, con_postcondicion, 
       con_activa, con_explicacion, con_expl_ok, con_estado, con_tipo, 
       con_falsos_positivos, con_importancia, con_momento, con_grupo, 
       con_descripcion, con_modulo, con_valida, con_junta, con_clausula_from, 
       con_expresion_sql, con_error_compilacion, con_ultima_variable, 
       con_orden, con_gravedad, con_version, con_rev, con_ultima_modificacion, 
       con_ignorar_nulls, con_observaciones, con_variables_contexto, 
       con_demora_compilacion, con_tlg
  FROM encu.consistencias
WHERE con_explicacion LIKE '%SM1%' OR con_explicacion LIKE '%sm1%' or
      con_explicacion LIKE '%SMI1%' OR con_explicacion LIKE '%smi1%';
*/
--con_con
--con_explicacion
--con_junta
--con_clausula_from
--con_expresion_sql
--con_error_compilacion
/*
SELECT con_con,regexp_replace(con_con,'SM1','S1','g') FROM encu.consistencias WHERE con_con LIKE '%SM1%'; 
SELECT con_con,regexp_replace(con_con,'SMI1','I1','g') FROM encu.consistencias WHERE con_con LIKE '%SMI1%'; 
SELECT con_con,regexp_replace(con_con,'SM1_P','S1_P','g') FROM encu.consistencias WHERE con_con LIKE '%SM1_P%'; 
SELECT con_con,regexp_replace(con_con,'sm1','s1','g') FROM encu.consistencias WHERE con_con LIKE '%sm1%'; 
SELECT con_con,regexp_replace(con_con,'smi1','i1','g') FROM encu.consistencias WHERE con_con LIKE '%smi1%'; 
SELECT con_con,regexp_replace(con_con,'sm1_p','s1_p','g') FROM encu.consistencias WHERE con_con LIKE '%sm1_p%'; 
*/
UPDATE encu.consistencias SET con_con = regexp_replace(con_con,'SM1','S1','g');
UPDATE encu.consistencias SET con_con = regexp_replace(con_con,'SMI1','I1','g');
UPDATE encu.consistencias SET con_con = regexp_replace(con_con,'SM1_P','S1_P','g');
UPDATE encu.consistencias SET con_con = regexp_replace(con_con,'sm1','s1','g');
UPDATE encu.consistencias SET con_con = regexp_replace(con_con,'smi1','i1','g');
UPDATE encu.consistencias SET con_con = regexp_replace(con_con,'sm1_P','s1_P','g');
/*
SELECT con_explicacion,regexp_replace(con_explicacion,'SM1','S1','g') FROM encu.consistencias WHERE con_explicacion LIKE '%SM1%'; 
SELECT con_explicacion,regexp_replace(con_explicacion,'SMI1','I1','g') FROM encu.consistencias WHERE con_explicacion LIKE '%SMI1%'; 
SELECT con_explicacion,regexp_replace(con_explicacion,'SM1_P','S1_P','g') FROM encu.consistencias WHERE con_explicacion LIKE '%SM1_P%'; 
SELECT con_explicacion,regexp_replace(con_explicacion,'sm1','s1','g') FROM encu.consistencias WHERE con_explicacion LIKE '%sm1%'; 
SELECT con_explicacion,regexp_replace(con_explicacion,'smi1','i1','g') FROM encu.consistencias WHERE con_explicacion LIKE '%smi1%'; 
SELECT con_explicacion,regexp_replace(con_explicacion,'sm1_p','s1_p','g') FROM encu.consistencias WHERE con_explicacion LIKE '%sm1_p%'; 
*/
UPDATE encu.consistencias SET con_explicacion = regexp_replace(con_explicacion,'SM1','S1','g');
UPDATE encu.consistencias SET con_explicacion = regexp_replace(con_explicacion,'SMI1','I1','g');
UPDATE encu.consistencias SET con_explicacion = regexp_replace(con_explicacion,'SM1_P','S1_P','g');
UPDATE encu.consistencias SET con_explicacion = regexp_replace(con_explicacion,'sm1','s1','g');
UPDATE encu.consistencias SET con_explicacion = regexp_replace(con_explicacion,'smi1','i1','g');
UPDATE encu.consistencias SET con_explicacion = regexp_replace(con_explicacion,'sm1_P','s1_P','g');
/*
SELECT con_junta,regexp_replace(con_junta,'SM1','S1','g') FROM encu.consistencias WHERE con_junta LIKE '%SM1%'; 
SELECT con_junta,regexp_replace(con_junta,'SMI1','I1','g') FROM encu.consistencias WHERE con_junta LIKE '%SMI1%'; 
SELECT con_junta,regexp_replace(con_junta,'SM1_P','S1_P','g') FROM encu.consistencias WHERE con_junta LIKE '%SM1_P%'; 
SELECT con_junta,regexp_replace(con_junta,'sm1','s1','g') FROM encu.consistencias WHERE con_junta LIKE '%sm1%'; 
SELECT con_junta,regexp_replace(con_junta,'smi1','i1','g') FROM encu.consistencias WHERE con_junta LIKE '%smi1%'; 
SELECT con_junta,regexp_replace(con_junta,'sm1_p','s1_p','g') FROM encu.consistencias WHERE con_junta LIKE '%sm1_p%'; 
*/
UPDATE encu.consistencias SET con_junta = regexp_replace(con_junta,'SM1','S1','g');
UPDATE encu.consistencias SET con_junta = regexp_replace(con_junta,'SMI1','I1','g');
UPDATE encu.consistencias SET con_junta = regexp_replace(con_junta,'SM1_P','S1_P','g');
UPDATE encu.consistencias SET con_junta = regexp_replace(con_junta,'sm1','s1','g');
UPDATE encu.consistencias SET con_junta = regexp_replace(con_junta,'smi1','i1','g');
UPDATE encu.consistencias SET con_junta = regexp_replace(con_junta,'sm1_P','s1_P','g');
/*
SELECT con_clausula_from,regexp_replace(con_clausula_from,'SM1','S1','g') FROM encu.consistencias WHERE con_clausula_from LIKE '%SM1%'; 
SELECT con_clausula_from,regexp_replace(con_clausula_from,'SMI1','I1','g') FROM encu.consistencias WHERE con_clausula_from LIKE '%SMI1%'; 
SELECT con_clausula_from,regexp_replace(con_clausula_from,'SM1_P','S1_P','g') FROM encu.consistencias WHERE con_clausula_from LIKE '%SM1_P%'; 
SELECT con_clausula_from,regexp_replace(con_clausula_from,'sm1','s1','g') FROM encu.consistencias WHERE con_clausula_from LIKE '%sm1%'; 
SELECT con_clausula_from,regexp_replace(con_clausula_from,'smi1','i1','g') FROM encu.consistencias WHERE con_clausula_from LIKE '%smi1%'; 
SELECT con_clausula_from,regexp_replace(con_clausula_from,'sm1_p','s1_p','g') FROM encu.consistencias WHERE con_clausula_from LIKE '%sm1_p%'; 
*/
UPDATE encu.consistencias SET con_clausula_from = regexp_replace(con_clausula_from,'SM1','S1','g');
UPDATE encu.consistencias SET con_clausula_from = regexp_replace(con_clausula_from,'SMI1','I1','g');
UPDATE encu.consistencias SET con_clausula_from = regexp_replace(con_clausula_from,'SM1_P','S1_P','g');
UPDATE encu.consistencias SET con_clausula_from = regexp_replace(con_clausula_from,'sm1','s1','g');
UPDATE encu.consistencias SET con_clausula_from = regexp_replace(con_clausula_from,'smi1','i1','g');
UPDATE encu.consistencias SET con_clausula_from = regexp_replace(con_clausula_from,'sm1_P','s1_P','g');
/*
SELECT con_expresion_sql,regexp_replace(con_expresion_sql,'SM1','S1','g') FROM encu.consistencias WHERE con_expresion_sql LIKE '%SM1%'; 
SELECT con_expresion_sql,regexp_replace(con_expresion_sql,'SMI1','I1','g') FROM encu.consistencias WHERE con_expresion_sql LIKE '%SMI1%'; 
SELECT con_expresion_sql,regexp_replace(con_expresion_sql,'SM1_P','S1_P','g') FROM encu.consistencias WHERE con_expresion_sql LIKE '%SM1_P%'; 
SELECT con_expresion_sql,regexp_replace(con_expresion_sql,'sm1','s1','g') FROM encu.consistencias WHERE con_expresion_sql LIKE '%sm1%'; 
SELECT con_expresion_sql,regexp_replace(con_expresion_sql,'smi1','i1','g') FROM encu.consistencias WHERE con_expresion_sql LIKE '%smi1%'; 
SELECT con_expresion_sql,regexp_replace(con_expresion_sql,'sm1_p','s1_p','g') FROM encu.consistencias WHERE con_expresion_sql LIKE '%sm1_p%'; 
*/
UPDATE encu.consistencias SET con_expresion_sql = regexp_replace(con_expresion_sql,'SM1','S1','g');
UPDATE encu.consistencias SET con_expresion_sql = regexp_replace(con_expresion_sql,'SMI1','I1','g');
UPDATE encu.consistencias SET con_expresion_sql = regexp_replace(con_expresion_sql,'SM1_P','S1_P','g');
UPDATE encu.consistencias SET con_expresion_sql = regexp_replace(con_expresion_sql,'sm1','s1','g');
UPDATE encu.consistencias SET con_expresion_sql = regexp_replace(con_expresion_sql,'smi1','i1','g');
UPDATE encu.consistencias SET con_expresion_sql = regexp_replace(con_expresion_sql,'sm1_P','s1_P','g');
/*
SELECT con_error_compilacion,regexp_replace(con_error_compilacion,'SM1','S1','g') FROM encu.consistencias WHERE con_error_compilacion LIKE '%SM1%'; 
SELECT con_error_compilacion,regexp_replace(con_error_compilacion,'SMI1','I1','g') FROM encu.consistencias WHERE con_error_compilacion LIKE '%SMI1%'; 
SELECT con_error_compilacion,regexp_replace(con_error_compilacion,'SM1_P','S1_P','g') FROM encu.consistencias WHERE con_error_compilacion LIKE '%SM1_P%'; 
SELECT con_error_compilacion,regexp_replace(con_error_compilacion,'sm1','s1','g') FROM encu.consistencias WHERE con_error_compilacion LIKE '%sm1%'; 
SELECT con_error_compilacion,regexp_replace(con_error_compilacion,'smi1','i1','g') FROM encu.consistencias WHERE con_error_compilacion LIKE '%smi1%'; 
SELECT con_error_compilacion,regexp_replace(con_error_compilacion,'sm1_p','s1_p','g') FROM encu.consistencias WHERE con_error_compilacion LIKE '%sm1_p%'; 
*/
UPDATE encu.consistencias SET con_error_compilacion = regexp_replace(con_error_compilacion,'SM1','S1','g');
UPDATE encu.consistencias SET con_error_compilacion = regexp_replace(con_error_compilacion,'SMI1','I1','g');
UPDATE encu.consistencias SET con_error_compilacion = regexp_replace(con_error_compilacion,'SM1_P','S1_P','g');
UPDATE encu.consistencias SET con_error_compilacion = regexp_replace(con_error_compilacion,'sm1','s1','g');
UPDATE encu.consistencias SET con_error_compilacion = regexp_replace(con_error_compilacion,'smi1','i1','g');
UPDATE encu.consistencias SET con_error_compilacion = regexp_replace(con_error_compilacion,'sm1_P','s1_P','g');