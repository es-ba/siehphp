/* UT8:Sí
CASOS DE PRUEBA YEAH EN POSTGRES. Para que ande poner en la base en cada máquina:
Poner esto en cada máquina pero desde del usuario postgres:

CREATE USER yeah_test with password 'laclave';
grant all privileges on schema test to yeah_test;
grant usage on schema comun     to yeah_test;
grant usage on schema yeah      to yeah_test;
grant usage on schema yeah_2011 to yeah_test;
grant usage on schema his       to yeah_test;
grant select on all tables in schema comun     to yeah_test;
grant select on all tables in schema yeah      to yeah_test;
grant select on all tables in schema yeah_2011 to yeah_test;
grant select on all tables in schema his       to yeah_test;
*/

set search_path=test,yeah_2011,yeah,comun,public;

--------- SECCION PROBAR tem11 y sus estados -------------
  
drop table if exists test.tem11 cascade;
drop table if exists test.comunas;
drop table if exists test.bolsas;
drop table if exists test.modificaciones;
drop table if exists test.usuarios;

create table test.tem11          as select * from yeah_2011.tem11    where false;
create table test.comunas        as select * from yeah_2011.comunas  where false;
create table test.bolsas         as select * from yeah_2011.bolsas   where false;
create table test.modificaciones as select * from his.modificaciones where false;
create table test.usuarios       as select * from yeah.usuarios      where false;

alter table test.tem11 add primary key (encues);

CREATE TRIGGER tem_estado_2011_trg
	BEFORE UPDATE
	ON test.tem11
	FOR EACH ROW
	EXECUTE PROCEDURE yeah_2011.tem_estado_trg();

INSERT INTO test.comunas(
		comuna_comuna, comuna_cod_recep, comuna_cod_sup, comuna_cod_subcoor, comuna_cod_recu)
VALUES (1            , null            , null          , null              , null),            
	   (2            , 201             , 401           , 501               , 301 );

INSERT INTO test.usuarios(usu_usu, usu_rol) 
       VALUES ('u_ingresador'    ,'ingresador')  
            , ('u_ingresador2'   ,'ingresador')  
            , ('u_ana_ing'       ,'ana_ing')  
            , ('u_ana_campo'     ,'ana_campo')  
            , ('u_procesamiento' ,'procesamiento');
   
create or replace function probar_que_falle(p_sentencia text, p_razon text) returns text
as
$BODY$
declare
  v_fallo boolean:=false;
  v_algo double precision;
begin
  begin
	execute p_sentencia;
  exception
    when others then
	  v_fallo:=true;
  end; 
  if not v_fallo then
    raise exception 'ERROR. No fallo en la sentencia % y debia fallar porque %',p_sentencia,p_razon;
  end if;
  return 'ok, fallo porque '||p_razon;
end;
$BODY$
  language plpgsql;
  
create or replace function probar_tem(p_encues integer,p_update text,p_valor_esperado decimal,p_campo_de_donde_sacar_el_valor text) returns text
as
$body$
declare
  v_existe boolean;
  v_rta text;
begin
  select true into v_existe from tem11 where encues=p_encues;
  if v_existe then
	null; -- no hay que insertar
  else
    insert into test.tem11(encues,comuna,replica) values (p_encues,1,1);
  end if;
  execute ('update tem11 set '||p_update||' where encues='||p_encues);
  select 'ERROR. Haciendo "'||p_update||'" esperaba estado '||p_valor_esperado||' y obtuve '||estado
	into v_rta
	from tem11 
	where encues=p_encues 
		and case p_campo_de_donde_sacar_el_valor 
			when 'estado' then estado 
			when 'bolsa' then bolsa
			end is distinct from p_valor_esperado;
  return v_rta;
end;
$body$
  language plpgsql;

create or replace function probar_estados_tem(p_encues integer,p_update text,p_estado_esperado decimal) returns text
as
$body$
begin
  return probar_tem(p_encues,p_update,p_estado_esperado,'estado');
end;
$body$
  language plpgsql;
  
create or replace function probar_estadosp_tem(p_encues integer,p_update text,p_estado_esperado integer) returns text
as
$body$
declare
  v_existe boolean;
begin
  select true into v_existe from tem11 where encues=p_encues;
  if v_existe then
	null; -- no hay que insertar
  else
    insert into test.tem11(encues,comuna,cod_enc,rea,bolsa,replica) values (p_encues,1,1,1,1,1);
  end if;
  return probar_tem(p_encues,p_update,p_estado_esperado,'estado');
end;
$body$
  language plpgsql;

create or replace function probar_abrir_encuesta(p_encues integer,p_usu_usu text,p_ok boolean,p_cod_ing text) returns text
as
$body$
declare
  v_existe boolean;
  v_respuesta_obtenida text;
  v_cod_ing text;
  v_rta text;
  v_contexto text;
begin
  select true into v_existe from tem11 where encues=p_encues;
  if v_existe then
    null; -- no hay que insertar
  else
    insert into test.tem11(encues,comuna,cod_enc,rea,bolsa,replica,bolsa_ok,estado,sup_campo) values (p_encues,1,1,1,11,1,1,21,0);
  end if;
  select abrir_encuesta(p_encues,p_usu_usu) into v_respuesta_obtenida;
  v_contexto:='encues '||p_encues
             ||' usu_usu '||coalesce(p_usu_usu,'')
             ||' ok '||p_ok
             ||' cod_ing '||coalesce(p_cod_ing,'');
  if (v_respuesta_obtenida is null) is distinct from p_ok then
    return 'ERROR esperabar que abrir_encuesta '||case when p_ok then 'NO FALLE' else 'FALLE' end||' y obtuve '||coalesce(v_respuesta_obtenida,' que no fallo')||' en '||v_contexto;
  else
    select cod_ing
      into v_cod_ing
      from tem11 
      where encues=p_encues;
    v_rta:=''; 
    if v_cod_ing is distinct from p_cod_ing then
      v_rta:=v_rta||' en cod_ing obtuve '||coalesce(v_cod_ing,'NULL')||' y esperaba '||coalesce(p_cod_ing,'NULL');
    end if;
    if v_rta<>'' then
      return 'ERROR'||v_rta||' en '||v_contexto;
    end if;
  end if;
  return null;
end;
$body$
  language plpgsql;

create or replace function probar_fin_etapa_encuesta(p_encuesta integer,p_usu_usu text, p_poner_fin integer, p_estado integer, p_fin_ingreso integer, p_fin_anal_ing integer, p_fin_anal_campo integer, p_fin_anal_proc integer) 
returns text
as
$body$
declare
  v_nomeimporta text;
  v_estado         integer;
  v_fin_ingreso    integer;
  v_fin_anal_ing   integer;
  v_fin_anal_campo integer;
  v_fin_anal_proc  integer;
  v_rta text;
begin
  select fin_etapa_encuesta(p_encuesta, p_usu_usu, p_poner_fin)::text into v_nomeimporta;
  select estado        
       , fin_ingreso   
       , fin_anal_ing  
       , fin_anal_campo
       , fin_anal_proc 
       INTO  v_estado        
           , v_fin_ingreso   
           , v_fin_anal_ing  
           , v_fin_anal_campo
           , v_fin_anal_proc 
    from tem11
	where encues=p_encuesta;
  v_rta:='';
  if v_estado         is distinct from p_estado          then v_rta:=v_rta||' difiere estado         obtuve '||coalesce(v_estado        ::TEXT,'NULL') ||' esperaba '||coalesce(p_estado        ::TEXT,'NULL') ; end if;
  if v_fin_ingreso    is distinct from p_fin_ingreso     then v_rta:=v_rta||' difiere fin_ingreso    obtuve '||coalesce(v_fin_ingreso   ::TEXT,'NULL') ||' esperaba '||coalesce(p_fin_ingreso   ::TEXT,'NULL') ; end if;
  if v_fin_anal_ing   is distinct from p_fin_anal_ing    then v_rta:=v_rta||' difiere fin_anal_ing   obtuve '||coalesce(v_fin_anal_ing  ::TEXT,'NULL') ||' esperaba '||coalesce(p_fin_anal_ing  ::TEXT,'NULL') ; end if;
  if v_fin_anal_campo is distinct from p_fin_anal_campo  then v_rta:=v_rta||' difiere fin_anal_campo obtuve '||coalesce(v_fin_anal_campo::TEXT,'NULL') ||' esperaba '||coalesce(p_fin_anal_campo::TEXT,'NULL') ; end if;
  if v_fin_anal_proc  is distinct from p_fin_anal_proc   then v_rta:=v_rta||' difiere fin_anal_proc  obtuve '||coalesce(v_fin_anal_proc ::TEXT,'NULL') ||' esperaba '||coalesce(p_fin_anal_proc ::TEXT,'NULL') ; end if;
  if v_rta<>'' then
    RAISE EXCEPTION 'ERROR %',v_rta;
  end if;
  return '';
end;
$body$
  language plpgsql;
  
  
create or replace function probar_reabrir_encuesta(p_fin_ing boolean, p_enc integer, p_anal_ing boolean, p_anal_campo boolean, p_anal_proc boolean, v_caso integer)
returns text
as
$body$
declare
	v_resp text;
    v_viejo_estado text;
    v_nuevo_estado text;
begin
 begin
  CASE v_caso
	WHEN 0 THEN 
		insert into test.tem11(encues,comuna,cod_enc,rea,bolsa,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
		               values (p_enc,      1,      1,  1,   11,      1,       1,        0,          2,        null,          null,     null,      1,      111,'2011-11-25 00:00:00');
	WHEN 1 THEN 
		insert into test.tem11(encues,comuna,cod_enc,rea,bolsa,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
		               values (p_enc,      1,      1,  1,   11,      1,       1,        0,          3,           4,             5,            6,      1,      111,'2011-11-25 00:00:00');
	WHEN 2 THEN 
		insert into test.tem11(encues,comuna,cod_enc,rea,bolsa,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
		               values (p_enc,      1,      1,  1,   11,      1,       1,        0,          3,           5,          null,            6,      1,    111,'2011-11-25 00:00:00');  
	WHEN 3 THEN 
		insert into test.tem11(encues,comuna,cod_enc,rea,bolsa,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
		               values (p_enc,      1,      1,  1,   11,      1,       1,        0,          3,           4,             5,            2,      1,    111,'2011-11-25 00:00:00');   
	WHEN 4 THEN 
		insert into test.tem11(encues,comuna,cod_enc,rea,bolsa,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
		               values (p_enc,      1,      1,  1,   11,      1,       1,        0,          3,           5,          null,            2,      1,    111,'2011-11-25 00:00:00');   
	WHEN 5 THEN 
		insert into test.tem11(encues,comuna,cod_enc,rea,bolsa,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
		               values (p_enc,      1,      1,  1,   11,      1,       1,        0,          3,           4,             2,         null,     1,     111,'2011-11-25 00:00:00');  
	WHEN 6 THEN 
		insert into test.tem11(encues,comuna,cod_enc,rea,bolsa,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
		               values (p_enc,      1,      1,  1,   11,      1,       1,        0,          3,           2,          null,         null,      1,    111,'2011-11-25 00:00:00');  
    END CASE;		
   exception
     when unique_violation then
       null; -- para no insertar dos veces el mismo registro acá en prueba
   end;
  update tem11 set estado=estado where encues=p_enc;
  select estado into v_viejo_estado from tem11 where encues=p_enc;
  select yeah_2011.reabrir_encuesta(p_enc,1,p_fin_ing,p_anal_ing, p_anal_campo, p_anal_proc)::text into v_resp;
  select estado into v_nuevo_estado from tem11 where encues=p_enc;
  if v_nuevo_estado=v_viejo_estado then
    return 'Encuesta '||p_enc||' sigue en estado '||v_nuevo_estado;
  end if;
  if v_nuevo_estado='29' then
    return 'Encuesta '||p_enc||' esta en estado '||v_nuevo_estado||' (estaba en estado '||v_viejo_estado||')';
  end if;
  return v_resp;
end;
$body$
  language plpgsql;  

create or replace function test.probar_reabrir_bolsas(p_des integer, p_has integer)
returns text
as
$body$
declare
	v_resp text;
begin
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   173,p_des,     1,      1,  1,      1,       1,        0,          1,           1,             1,            1,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   174,p_has,     1,      1,  1,      1,       1,        0,          1,           1,             1,            2,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   175,p_des,     1,      1,  1,      1,       1,        0,          1,           1,             1,            6,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   176,p_has,     1,      1,  1,      1,       1,        0,          1,           1,             2,            1,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   177,p_des,     1,      1,  1,      1,       1,        0,          1,           1,             2,            2,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   178,p_has,     1,      1,  1,      1,       1,        0,          1,           1,             2,            6,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   179,p_des,     1,      1,  1,      1,       1,        0,          1,           2,             1,            1,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   180,p_has,     1,      1,  1,      1,       1,        0,          1,           2,             1,            2,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   181,p_des,     1,      1,  1,      1,       1,        0,          1,           2,             1,            6,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   182,p_has,     1,      1,  1,      1,       1,        0,          1,           2,             2,            1,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   183,p_des,     1,      1,  1,      1,       1,        0,          1,           2,             2,            2,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   184,p_has,     1,      1,  1,      1,       1,        0,          1,           2,             2,            6,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   185,p_des,     1,      1,  1,      1,       1,        0,          2,           1,             1,            1,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   186,p_has,     1,      1,  1,      1,       1,        0,          2,           1,             1,            2,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   187,p_des,     1,      1,  1,      1,       1,        0,          2,           1,             1,            6,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   188,p_has,     1,      1,  1,      1,       1,        0,          2,           1,             2,            1,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   189,p_des,     1,      1,  1,      1,       1,        0,          2,           1,             2,            2,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   190,p_has,     1,      1,  1,      1,       1,        0,          2,           1,             2,            6,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   191,p_des,     1,      1,  1,      1,       1,        0,          2,           2,             1,            1,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   192,p_has,     1,      1,  1,      1,       1,        0,          2,           2,             1,            2,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   193,p_des,     1,      1,  1,      1,       1,        0,          2,           2,             1,            6,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   194,p_has,     1,      1,  1,      1,       1,        0,          2,           2,             2,            1,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   195,p_des,     1,      1,  1,      1,       1,        0,          2,           2,             2,            2,      1,    111,'2011-11-25 00:00:00');  
insert into test.tem11(encues,bolsa,comuna,cod_enc,rea,replica,bolsa_ok,sup_campo,fin_ingreso,fin_anal_ing,fin_anal_campo,fin_anal_proc,id_proc,cod_ing,ingresando) 
               values (   196,p_has,     1,      1,  1,      1,       1,        0,          2,           2,             2,            6,      1,    111,'2011-11-25 00:00:00');  
exception
     when unique_violation then
       null; -- para no insertar dos veces el mismo registro acá en prueba
select yeah_2011.reabrir_bolsas(p_des,p_has)::text into v_resp;
return v_resp;
   
end;
$body$
  language plpgsql;  
  
select probar_estados_tem(1,'cod_enc=null,sup_campo=0',0);
select probar_estados_tem(1,'cod_enc=1',1);
select probar_estados_tem(1,'rea=1',9);
select probar_estados_tem(1,'rea=0, norea_enc=21',5);
select probar_estados_tem(1,'rea=0, norea_enc=71',2);
select probar_estados_tem(1,'rea=0, norea_enc=10',2);
--select probar_estados_tem(1,'rea=0, norea_enc=61',9);
select probar_estados_tem(1,'rea=0, norea_enc=61',10);

------------estado pendiente de decidir si se supervisa ----------------------
-- 1 -> 1.5 -> 4
select probar_estados_tem(150,'cod_enc=44',1);
select probar_estados_tem(150,'rea=1',1.5);
select probar_estados_tem(150,'sup_tel=1',4);

-- 1 -> 1.5 -> 5
select probar_estados_tem(154,'cod_enc=55',1);
select probar_estados_tem(154,'rea=1,hog=1',1.5);
select probar_estados_tem(154,'sup_campo=1',5);
-- 1 -> 1.5 -> 9
select probar_estados_tem(153,'cod_enc=55',1);
select probar_estados_tem(153,'rea=1,hog=1',1.5);
select probar_estados_tem(153,'sup_tel=0',9);

-- 1 -> 2 -> -> 3 -> 3.5 -> 7
select probar_estados_tem(151,'cod_enc=44',1);
select probar_estados_tem(151,'rea=0,norea_enc=71',2);
select probar_estados_tem(151,'cod_recu=123',3);
select probar_estados_tem(151,'rea=3',3.5);
-- 1 -> 2 -> -> 3 -> 3.5 -> 9
select probar_estados_tem(152,'cod_enc=44',1);
select probar_estados_tem(152,'rea=0,norea_enc=71',2);
select probar_estados_tem(152,'cod_recu=123',3);
select probar_estados_tem(152,'rea=3',3.5);
select probar_estados_tem(152,'sup_recu_campo=0',9);
----------------------------------

-- 0 -> 1 -> 5 -> 6 -> 9
-- se asigna a un encuestador
-- asigno la encuesta=2 al cod_enc=1, el estado pasa a 1
select probar_estados_tem(2,'cod_enc=1,sup_campo=0',1);
-- vuelve realizada y tiene supervision
-- rea=1 y sup_campo=1, estad = 5
select probar_estados_tem(2,'rea=1,sup_campo=1',5);
-- le asigno supervisor
select probar_estados_tem(2,'cod_sup=15',6);
-- fin supervicion
select probar_estados_tem(2,'fin_sup=1',9);

-- 0 -> 1 -> 2 -> 3 -> 7 -> 8 -> 9
-- asigno a un encuestador
select probar_estados_tem(3,'cod_enc=33,sup_campo=0',1);
-- vuelve sin realizar, motivo 7.1
select probar_estados_tem(3,'rea=0,norea_enc=71',2);
-- asigno a recuperador
select probar_estados_tem(3,'cod_recu=123',3);
-- con supervision de recuperador. y no rea recuperador
select probar_estados_tem(3,'sup_recu_campo=1,rea=3',7);
-- asigno supervisor
select probar_estados_tem(3,'cod_sup=233,rea=3',8);
-- termina la recuperacion
select probar_estados_tem(3,'fin_sup=1',9);

-- 0 -> 1 -> 4 -> 9
-- asigno a un encuestador
select probar_estados_tem(4,'cod_enc=44,sup_campo=0',1);
-- vuelve realizada, tiene supervisor telefonico
select probar_estados_tem(4,'rea=1,sup_tel=14',4);
-- termina la sup telefonica
select probar_estados_tem(4,'fin_sup=1',9);

-- 0 -> 1 -> 9
-- asigno a un encuestador
select * from probar_que_falle($$ select probar_estados_tem(5,'rea=1,hog=1',9); $$,'no puede estar rea sin encuestador');
select probar_estados_tem(5,'cod_enc=55,sup_campo=0',1);
-- vuelve realizada, sin supervision ni de campo ni telefonica
select * from probar_que_falle($$ select probar_estados_tem(5,'rea=1,hog=2,sup_tel=1',4); $$,'si hog>1 va a supervision de campo');
select probar_estados_tem(5,'rea=1,hog=1',9);

-- 0 -> 1 -> 5
select probar_estados_tem(55,'cod_enc=55,sup_campo=0',1);
select probar_estados_tem(55,'rea=1,hog=2',5);

-- 0 -> 1 -> 2 -> 3 -> 9
-- asigno a un encuestador
select probar_estados_tem(6,'cod_enc=33',1);
-- vuelve sin realizar, motivo 7.1
select probar_estados_tem(6,'rea=0,norea_enc=71',2);
-- asigni a recuperador
select probar_estados_tem(6,'cod_recu=123',3);
-- encuesta realizada
select probar_estados_tem(6,'sup_recu_campo=0,rea=3',9);

-- 0 -> 1 -> 2 -> 3 ->4 -> 9
-- asigno a un encuestador
select probar_estados_tem(1006,'cod_enc=33',1);
-- vuelve sin realizar, motivo 7.1
select probar_estados_tem(1006,'rea=0,norea_enc=95',2);
-- asigni a recuperador
select probar_estados_tem(1006,'cod_recu=123',3);
-- encuesta realizada
select probar_estados_tem(1006,'sup_recu_campo=0,rea=4',9);

-- 0 -> 1 -> 9 vía rea=4
-- sin supervisión
select probar_estados_tem(7,'cod_enc=33,sup_campo=0, sup_recu_campo=0',1);
select probar_estados_tem(7,'rea=4',9);
-- con supervisión telefónica
select probar_estados_tem(8,'sup_tel=1, cod_enc=33, sup_recu_campo=0',1);
select probar_estados_tem(8,'rea=4',9);
-- con supervisión en campo
select probar_estados_tem(9,'sup_campo=1, cod_enc=33, sup_recu_campo=0',1);
select probar_estados_tem(9,'rea=4',9);

------------- Réplica 8 sin recuperación -------------------

-- 0 -> 1 -> 10
-- asigno a un encuestador
select probar_estados_tem(15,'cod_enc=33, replica=8,sup_campo=0',1);
-- vuelve sin realizar, motivo 7.1
--select probar_estados_tem(15,'rea=0,norea_enc=71',9);
select probar_estados_tem(15,'rea=0,norea_enc=71',10);

-- 0 -> 1 -> 9
select probar_estados_tem(16,'cod_enc=33, replica=8,sup_campo=0',1);
-- vuelve sin realizar, motivo 7.1
--select probar_estados_tem(15,'rea=0,norea_enc=71',9);
select probar_estados_tem(16,'rea=1',9);


------------- Estado 10 "para bolsa no rea" -----------------
-- 0 -> 1 -> 5 -> 6 -> 10 
select probar_estados_tem(33,'cod_enc=155,sup_campo=0',1);
select probar_estados_tem(33,'rea=2,sup_campo=1,norea_enc=6',5);
select probar_estados_tem(33,'cod_sup=43',6);
select probar_estados_tem(33,'fin_sup=1',10);

-- 0 -> 1 -> 2 -> 3 -> 10 llega a 9 aunque no este rea
-- asigno a un encuestador
select probar_estados_tem(66,'cod_enc=33,sup_campo=0',1);
-- vuelve sin realizar, motivo 7.1
select probar_estados_tem(66,'rea=0,norea_enc=71',2);
-- asigni a recuperador
select probar_estados_tem(66,'cod_recu=123',3);
-- encuesta no realizada, sin sup
select probar_estados_tem(66,'sup_recu_campo=0,norea_recu=71,rea=2',10);

------------- Meter en bolsas -------------------------------
insert into bolsas (bolsa_bolsa,bolsa_cerrada,bolsa_rea) values (1,1,1);
insert into bolsas (bolsa_bolsa,bolsa_rea) values (2,1);
insert into bolsas (bolsa_bolsa,bolsa_cerrada,bolsa_rea,bolsa_revisada) values (11,1,1,1);
select probar_estados_tem(99,'cod_enc=1,rea=1,sup_campo=0',9);
select probar_tem(99,'bolsa=2',2,'bolsa');
select probar_tem(98,'cod_enc=1,rea=1,bolsa=0,sup_campo=0',2,'bolsa');
insert into tem11(encues,cod_enc,rea,bolsa,estado) values (91,1,1,1,9);
select * from probar_que_falle($$ select * from probar_tem(91,'bolsa=null',null,'bolsa'); $$,'porque la bolsa esta cerrada no se le pueden sacar encuestas');
select * from probar_que_falle($$ select * from probar_tem(97,'cod_enc=1,rea=0,bolsa=0',2,'bolsa'); $$,'porque no está en estado 9');
------------ Estados de procesamiento ------------------------
select probar_estadosp_tem(11,'hp=2,sup_campo=0',20);
select * from probar_que_falle($$ select probar_estados_tem(12,'cod_enc=14, bolsa_ok=1',21); $$,'no estaba en estado 20, entonces no se puede poner bolsa_ok');
select probar_estadosp_tem(13,'bolsa_ok=1,sup_campo=0',21);
select probar_estadosp_tem(13,'cod_ing=99',22);
select probar_estadosp_tem(13,'ingresando=current_timestamp',23);
select * from probar_que_falle($$ select probar_estadosp_tem(14,'cod_ing=99',22); $$,'no está la bolsa_ok no se puede asignar');

insert into bolsas (bolsa_bolsa,bolsa_cerrada,bolsa_rea) values (10,0,1);
-- 0 -> 1 -> 20 -> 21 -> 22 -> 23
select * from probar_estados_tem(22,'cod_enc=1,rea=1,sup_campo=0',9);
select * from probar_estados_tem(22,'bolsa=10',20);
select * from probar_estados_tem(22,'bolsa_ok=1',21);
select * from probar_estados_tem(22,'cod_ing=111',22);
select * from probar_que_falle($$ select probar_estados_tem(22,'fin_ingreso=1',23); $$,'no estaba en estado 23, entonces no se puede poner fin_ingreso=1');
select * from probar_estados_tem(22,'ingresando=date(''25/12/2011'')',23);
select * from probar_estados_tem(22,'fin_ingreso=1',29);

-- 23 -> 24 -> 25 -> 26 -> 29
select * from probar_estados_tem(23,'cod_enc=1,rea=1,bolsa=10,bolsa_ok=1,cod_ing=111,ingresando=date(''25/12/2011''),sup_campo=0',23);
select * from probar_que_falle($$ select probar_estados_tem(23,'fin_anal_ing=1',24); $$,'no estaba en estado 24, entonces no se puede poner fin_anal_ing=1');
select * from probar_estados_tem(23,'fin_ingreso=3',24);
select * from probar_que_falle($$ select probar_estados_tem(23,'fin_anal_campo=5',24); $$,'no estaba en estado 25, entonces no se puede poner fin_anal_campo=5');
select * from probar_estados_tem(23,'fin_anal_ing=4',25);
select * from probar_que_falle($$ select probar_estados_tem(23,'fin_anal_proc=6',24); $$,'no estaba en estado 26, entonces no se puede poner fin_anal_proc=6');
select * from probar_estados_tem(23,'fin_anal_campo=5',26);
select * from probar_estados_tem(23,'fin_anal_proc=6',29);

-- 23 -> 24 -> 25 -> 29
select * from probar_estados_tem(25,'cod_enc=1,rea=1,bolsa=10,bolsa_ok=1,cod_ing=111,ingresando=date(''25/12/2011''),sup_campo=0',23);
select * from probar_estados_tem(25,'fin_ingreso=3',24);
select * from probar_estados_tem(25,'fin_anal_ing=4',25);
select * from probar_estados_tem(25,'fin_anal_campo=2',29);

-- 23 -> 24 -> 26 -> 25 -> 26 -> 29
select * from probar_estados_tem(24,'cod_enc=1,rea=1,bolsa=10,bolsa_ok=1,cod_ing=111,ingresando=date(''25/12/2011''),sup_campo=0',23);
select * from probar_estados_tem(24,'fin_ingreso=3',24);
select * from probar_estados_tem(24,'fin_anal_ing=5',26);
select * from probar_estados_tem(24,'fin_anal_proc=4',25);
select * from probar_estados_tem(24,'fin_anal_campo=5',26);
select * from probar_estados_tem(24,'fin_anal_proc=2',29);

-- Si la encuesta tiene dos hogares y el fin_sup=4 no debe supervisarse #292
-- Este código se usa para marcar las encuestas que, como el programa no mandaba a supervisar las hog>1, ya no se pueden mandar. 
select * from probar_estados_tem(26,'cod_enc=1,rea=1,hog=2,fin_sup=4',9);

------------ Abrir encuesta ------------------------
select * from probar_abrir_encuesta(40,'u_ingresador'    ,true,'u_ingresador'   );
select * from probar_estados_tem(40,'fin_ingreso=1,sup_campo=0',29);
select * from probar_estados_tem(40,'fin_ingreso=2',29);
select * from probar_abrir_encuesta(40,'u_ingresador2'   ,false,'u_ingresador'   );
select * from probar_estados_tem(40,'fin_ingreso=3',24);
-- puede si es el mismo día
select * from probar_abrir_encuesta(40,'u_ingresador'   ,true,'u_ingresador'   ); 
update tem11 set ingresando=ingresando-interval '1 day' where encues=40;
select * from probar_abrir_encuesta(40,'u_ingresador'   ,false,'u_ingresador'   ); 

select * from probar_abrir_encuesta(41,'u_ana_ing'       ,true,'u_ana_ing'      );
select * from probar_abrir_encuesta(42,'u_ana_campo'     ,false,null            );
select * from probar_abrir_encuesta(43,'u_procesamiento' ,true,'u_procesamiento');

------------ fin_etapa_encuesta ------------------------
select probar_estadosp_tem(49,'bolsa_ok=1,sup_campo=0',21);
select * from probar_que_falle($$select * from probar_fin_etapa_encuesta(49,'u_ingresador', 1, 29, 1, null, null, null);$$,'no está abierta o asignada a ningún ingresador');

select probar_fin_etapa_encuesta(40,'u_ingresador', 1, 29, 1, null, null, null);
       
select probar_fin_etapa_encuesta(40,'u_ingresador', 1, 29, 1, null, null, null);
select probar_fin_etapa_encuesta(40,'u_ingresador', 2, 29, 2, null, null, null);
select probar_fin_etapa_encuesta(40,'u_ingresador', 3, 24, 3, null, null, null);
select * from probar_que_falle($$select * from probar_fin_etapa_encuesta(40,'u_ingresador', 4, 21, null, null, null, null);$$,'porque el 4 no es un fin permitido al ingresador');

select probar_fin_etapa_encuesta(41,'u_ana_ing'   , 1, 29, 1, null, null, null);

select * from probar_abrir_encuesta(44,'u_ana_ing'       ,true,'u_ana_ing'      );
select probar_fin_etapa_encuesta(44,'u_ana_ing'   , 5, 26, 3, 5   , null, null);
       
select probar_abrir_encuesta(42,'u_ana_ing'       ,true,'u_ana_ing'      );
select probar_fin_etapa_encuesta(42,'u_ana_ing'   , 3, 24, 3, null, null, null);
select probar_fin_etapa_encuesta(42,'u_ana_ing'   , 1, 29, 3, 1   , null, null);
select probar_fin_etapa_encuesta(42,'u_ana_ing'   , 4, 25, 3, 4   , null, null);
select probar_abrir_encuesta(42,'u_ana_ing'       ,false,'u_ana_ing'      );
select probar_abrir_encuesta(42,'u_procesamiento' ,false,'u_ana_ing'      );

select * from probar_que_falle($$select * from probar_fin_etapa_encuesta(41,'u_ana_campo'   , 1, 26, 1, 5   , null, null);$$,'porque el analista de campo solo puede intervenir en estado 25');
select probar_fin_etapa_encuesta(42,'u_ana_campo' , 2, 29, 3, 4   , 2   , null);

select * from probar_abrir_encuesta(45,'u_ana_ing'       ,true,'u_ana_ing'      );
select probar_fin_etapa_encuesta(45,'u_ana_ing'   , 4, 25, 3, 4   , null, null);
select probar_fin_etapa_encuesta(45,'u_ana_campo' , 5, 26, 3, 4   , 5   , null);

select probar_fin_etapa_encuesta(45,'u_procesamiento', 6, 29, 3, 4   , 5   , 6);
select probar_fin_etapa_encuesta(45,'u_procesamiento', 4, 25, 3, 7   , null, null);
select probar_fin_etapa_encuesta(45,'u_procesamiento', 4, 25, 3, 7   , null, null);

select * from probar_abrir_encuesta(46,'u_ana_ing'       ,true,'u_ana_ing'      );
select probar_fin_etapa_encuesta(46,'u_ana_ing'   , 5, 26, 3, 5   , null, null);
select probar_fin_etapa_encuesta(46,'u_procesamiento', 6, 29, 3, 5   , null, 6);
select probar_fin_etapa_encuesta(46,'u_procesamiento', 1, 29, 3, 5   , null, 1);
select probar_fin_etapa_encuesta(46,'u_procesamiento', 4, 25, 3, 7   , null, null);

select * from probar_abrir_encuesta(47,'u_ingresador'   ,true,'u_ingresador'   ); 
select probar_fin_etapa_encuesta(47,'u_ingresador'   , 3, 24, 3, null, null, null);
select probar_fin_etapa_encuesta(47,'u_procesamiento', 4, 25, 3, 7   , null, null);

select * from probar_abrir_encuesta(48,'u_ingresador'   ,true,'u_ingresador'   ); 
select probar_fin_etapa_encuesta(48,'u_ingresador'   , 3, 24, 3, null, null, null);
--select probar_fin_etapa_encuesta(48,'u_procesamiento', 2, 29, 3, null, null, 2); --probar_fin_etapa_encuesta(p_encuesta integer,p_usu_usu text, p_poner_fin integer, p_estado integer, p_fin_ingreso integer, p_fin_anal_ing integer, p_fin_anal_campo integer, p_fin_anal_proc integer)
--probar_fin_etapa_encuesta(p_encuesta ,p_usu_usu,        p_poner_fin, p_estado, p_fin_ingreso, p_fin_anal_ing , p_fin_anal_campo , p_fin_anal_proc)
select probar_fin_etapa_encuesta(48    ,'u_procesamiento', 2         , 29      , 3            , null           , null             , 2);

select * from probar_abrir_encuesta(49,'u_ingresador'   ,true,'u_ingresador'   ); 
select probar_fin_etapa_encuesta(49   ,'u_procesamiento', 1         , 29      , 1            , null           , null             , null);

select * from probar_abrir_encuesta(50,'u_ingresador'   ,true,'u_ingresador'   ); 
select probar_fin_etapa_encuesta(50   ,'u_procesamiento', 3         , 24      , 3            , null           , null             , null);


------------- dbo.es_fecha

select 'ERROR en dbo.esfecha',fecha,'esperaba',resultado,'y obtuve',dbo.es_fecha(fecha)
  from (
	select '01/01/2001' as fecha, 1 as resultado
	union select 'blah', 0
	union select '///', 0
	union select '01/01/01', 1
	union select '01//01', 0
	union select '01/01', 1
	union select null, 0) todo_esto
  where resultado is distinct from dbo.es_fecha(fecha);
---dbo.edad_a_la_fecha(fecha de nacimiento,fecha de realizacion)
select 'ERROR en dbo.edad_a_la_fecha',fecha1||'-'||fecha2,'esperaba',resultado,'y obtuve',dbo.edad_a_la_fecha(fecha1,fecha2)
  from (
	select '01/01/2001' as fecha1,'01/02/2002' as fecha2, 1 as resultado
	union select '01/02/2001' ,'01/01/2010', 8 
	union select '01/02/2001' ,'01/01/2001', null
	union select '01/01/2001' ,'01/02/2001', 0
	union select '01/02/2001' ,'01/01/1998', null
	union select '01/02/2001' ,'01//2001', null
	union select '01/' ,'01/10/2001', null
	union select '01/01/9999' ,'01/10/2011', null
	union select '01/01/99' ,'01/10/2011', 12
	union select '17/11/47' ,'13/10/2011', 63
	union select '2/11/55' ,'31/10/2011', 55
	) todo_esto
  where resultado is distinct from dbo.edad_a_la_fecha(fecha1,fecha2);
------------- dbo.existemiembro
  
select 'ERROR en dbo.existemiembro',enc, nhog, miem,'esperaba',resultado,'y obtuve',dbo.existemiembro(enc, nhog, miem)
  from (
	select 100163 as enc,1 as nhog,3 as miem, 1 as resultado
	union select 1, null, null, 0
	union select 100163, 1, null, 0
	union select null, null, 3, 0
	union select null, null, null, 0) todo_esto
  where resultado is distinct from dbo.existemiembro(enc, nhog, miem);  

 ------------- Reabrir encuesta ----------------------
select 'ERROR en yeah_2011.reabrir_encuesta','esperaba','Listo. Encuesta reabierta' as resultado,'y obtuve',probar_reabrir_encuesta(false,155,false,false,true,1)
  where 'Listo. Encuesta reabierta' is distinct from probar_reabrir_encuesta(false,155,false,false,true,1);  
select 'ERROR en yeah_2011.reabrir_encuesta','esperaba','Listo. Encuesta reabierta' as resultado,'y obtuve',probar_reabrir_encuesta(false,156,false,true,true,2)
  where 'Listo. Encuesta reabierta' is distinct from probar_reabrir_encuesta(false,156,false,true,true,1); 
select 'ERROR en yeah_2011.reabrir_encuesta','esperaba','Listo. Encuesta reabierta' as resultado,'y obtuve',probar_reabrir_encuesta(false,157,true,true,true,3)
  where 'Listo. Encuesta reabierta' is distinct from probar_reabrir_encuesta(false,157,true,true,true,1);   
select 'ERROR en yeah_2011.reabrir_encuesta','esperaba','Listo. Encuesta reabierta' as resultado,'y obtuve',probar_reabrir_encuesta(false,158,false,false,true,1)
  where 'Listo. Encuesta reabierta' is distinct from probar_reabrir_encuesta(false,158,false,false,true,2);  
select 'ERROR en yeah_2011.reabrir_encuesta','esperaba','Listo. Encuesta reabierta' as resultado,'y obtuve',probar_reabrir_encuesta(false,159,false,true,true,2)
  where 'Listo. Encuesta reabierta' is distinct from probar_reabrir_encuesta(false,159,false,true,true,2); 
select 'ERROR en yeah_2011.reabrir_encuesta','esperaba','Listo. Encuesta reabierta' as resultado,'y obtuve',probar_reabrir_encuesta(false,160,true,true,true,3)
  where 'Listo. Encuesta reabierta' is distinct from probar_reabrir_encuesta(false,160,true,true,true,2); 
select 'ERROR en yeah_2011.reabrir_encuesta','esperaba','Listo. Encuesta reabierta' as resultado,'y obtuve',probar_reabrir_encuesta(false,161,false,false,true,1)
  where 'Listo. Encuesta reabierta' is distinct from probar_reabrir_encuesta(false,161,false,false,true,3);  
select 'ERROR en yeah_2011.reabrir_encuesta','esperaba','Listo. Encuesta reabierta' as resultado,'y obtuve',probar_reabrir_encuesta(false,162,false,true,true,2)
  where 'Listo. Encuesta reabierta' is distinct from probar_reabrir_encuesta(false,162,false,true,true,3); 
select 'ERROR en yeah_2011.reabrir_encuesta','esperaba','Listo. Encuesta reabierta' as resultado,'y obtuve',probar_reabrir_encuesta(false,163,true,true,true,3)
  where 'Listo. Encuesta reabierta' is distinct from probar_reabrir_encuesta(false,163,true,true,true,3); 
select 'ERROR en yeah_2011.reabrir_encuesta','esperaba','Listo. Encuesta reabierta' as resultado,'y obtuve',probar_reabrir_encuesta(false,164,false,false,true,1)
  where 'Listo. Encuesta reabierta' is distinct from probar_reabrir_encuesta(false,164,false,false,true,4);  
select 'ERROR en yeah_2011.reabrir_encuesta','esperaba','Listo. Encuesta reabierta' as resultado,'y obtuve',probar_reabrir_encuesta(false,165,false,true,true,2)
  where 'Listo. Encuesta reabierta' is distinct from probar_reabrir_encuesta(false,165,false,true,true,4); 
select 'ERROR en yeah_2011.reabrir_encuesta','esperaba','Listo. Encuesta reabierta' as resultado,'y obtuve',probar_reabrir_encuesta(false,166,true,true,true,3)
  where 'Listo. Encuesta reabierta' is distinct from probar_reabrir_encuesta(false,166,true,true,true,4); 
select 'ERROR en yeah_2011.reabrir_encuesta','esperaba','Listo. Encuesta reabierta' as resultado,'y obtuve',probar_reabrir_encuesta(false,167,false,false,true,1)
  where probar_reabrir_encuesta(false,167,false,false,true,5) not like 'Encuesta%sigue en estado%';  
select 'ERROR en yeah_2011.reabrir_encuesta','esperaba','Listo. Encuesta reabierta' as resultado,'y obtuve',probar_reabrir_encuesta(false,168,false,true,true,2)
  where 'Listo. Encuesta reabierta' is distinct from probar_reabrir_encuesta(false,168,false,true,true,5); 
select 'ERROR en yeah_2011.reabrir_encuesta','esperaba','Listo. Encuesta reabierta' as resultado,'y obtuve',probar_reabrir_encuesta(false,169,true,true,true,3)
  where 'Listo. Encuesta reabierta' is distinct from probar_reabrir_encuesta(false,169,true,true,true,5); 
select 'ERROR en yeah_2011.reabrir_encuesta','esperaba','Listo. Encuesta reabierta' as resultado,'y obtuve',probar_reabrir_encuesta(false,170,false,false,true,1)
  where probar_reabrir_encuesta(false,170,false,false,true,6) not like 'Encuesta%sigue en estado%';  
select 'ERROR en yeah_2011.reabrir_encuesta','esperaba','Listo. Encuesta reabierta' as resultado,'y obtuve',probar_reabrir_encuesta(false,171,false,true,true,2)
  where probar_reabrir_encuesta(false,171,false,true,true,6) not like 'Encuesta%sigue en estado%'; 
select 'ERROR en yeah_2011.reabrir_encuesta','esperaba','Listo. Encuesta reabierta' as resultado,'y obtuve',probar_reabrir_encuesta(false,172,true,true,true,3)
  where 'Listo. Encuesta reabierta' is distinct from probar_reabrir_encuesta(false,172,true,true,true,6);   
select 'ERROR en yeah_2011.reabrir_encuesta','esperaba','Listo. Encuesta reabierta' as resultado,'y obtuve',probar_reabrir_encuesta(true,173,false,false,false,0)
  where 'Listo. Encuesta reabierta' is distinct from probar_reabrir_encuesta(true,173,false,false,false,0); 

  ------------- Reabrir bolsas ----------------------
select 'ERROR en yeah_2011.reabrir_bolsas','esperaba','Listo. Encuestas reabiertas' as resultado,'y obtuve',probar_reabrir_bolsas(10,11)
  where 'Listo. Encuestas reabiertas' is distinct from probar_reabrir_bolsas(10,11);  

  
------------- No poner nada abajo de esta línea -------------
SELECT 'si no hay otros renglones con ERROR es porque estA todo bien';