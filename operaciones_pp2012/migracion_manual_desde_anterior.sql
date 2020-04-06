--/*
delete from encu.usuarios where usu_usu<>'instalador';
delete from encu.http_user_agent
     where httpua_httpua>1;

update encu.http_user_agent set httpua_texto='instalador'
     where httpua_httpua=1;


insert into encu.usuarios
  select * from encu_anterior.usuarios
    where usu_usu<>'instalador';

insert into encu.http_user_agent
  select * from encu_anterior.http_user_agent
     where httpua_httpua>1;

insert into encu.sesiones
  select * from encu_anterior.sesiones
     where ses_ses>2;

insert into encu.tiempo_logico
  select * from encu_anterior.tiempo_logico
    where tlg_tlg>2;

delete from encu.ano_con;
delete from encu.con_var;
delete from encu.consistencias;
INSERT INTO encu.consistencias(
            con_ope, con_con, con_precondicion, con_rel, con_postcondicion, 
            con_activa, con_explicacion, con_expl_ok, con_estado, con_tipo, 
            con_falsos_positivos, con_importancia, con_momento, con_grupo, 
            con_descripcion, con_modulo, con_valida, con_junta, con_clausula_from, 
            con_expresion_sql, con_error_compilacion, con_ultima_variable, 
            con_orden, con_gravedad, con_version, con_rev, con_ultima_modificacion, 
            con_ignorar_nulls, con_observaciones, con_variables_contexto, 
            con_tlg)
  SELECT
	    con_ope, con_con, con_precondicion, con_rel, con_postcondicion, 
            con_activa, con_explicacion, con_expl_ok, con_estado, con_tipo, 
            con_falsos_positivos, con_importancia, con_momento, con_grupo, 
            con_descripcion, con_modulo, con_valida, con_junta, con_clausula_from, 
            con_expresion_sql, con_error_compilacion, con_ultima_variable, 
            con_orden, con_gravedad, con_version, con_rev, con_ultima_modificacion, 
            con_ignorar_nulls, con_observaciones, con_variables_contexto, 
            con_tlg
     FROM encu_anterior.consistencias;

insert into encu.ano_con
  select * from encu_anterior.ano_con;

insert into his.modificaciones
  select * from his_anterior.modificaciones;

SELECT setval('encu.http_user_agent_httpua_httpua_seq', nextval('encu_anterior.http_user_agent_httpua_httpua_seq')-1, true);
SELECT setval('encu.sesiones_ses_ses_seq', nextval('encu_anterior.sesiones_ses_ses_seq')-1, true);
SELECT setval('encu.tiempo_logico_tlg_tlg_seq', nextval('encu_anterior.tiempo_logico_tlg_tlg_seq')-1, true);
SELECT setval('his.modificaciones_mdf_mdf_seq', nextval('his_anterior.modificaciones_mdf_mdf_seq')-1, true);

update encu.preguntas x set pre_texto=h.pre_texto, pre_aclaracion=h.pre_aclaracion, pre_abreviado=h.pre_abreviado
  from encu_anterior.preguntas h
  where x.pre_ope=h.pre_ope
    and x.pre_pre=h.pre_pre;

update encu.variables x set var_texto=h.var_texto, var_aclaracion=h.var_aclaracion
  from encu_anterior.variables h
  where x.var_ope=h.var_ope
    and x.var_var=h.var_var;    

update encu.opciones x set opc_texto=h.opc_texto, opc_aclaracion=h.opc_aclaracion
  from encu_anterior.opciones h
  where x.opc_ope=h.opc_ope
    and x.opc_conopc=h.opc_conopc
    and x.opc_opc=h.opc_opc;    

update encu.bloques x set blo_texto=h.blo_texto, blo_aclaracion=h.blo_aclaracion
  from encu_anterior.bloques h
  where x.blo_ope=h.blo_ope
    and x.blo_for=h.blo_for
    and x.blo_blo=h.blo_blo;    

--*/ 
