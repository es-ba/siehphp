-- para todos los ocupados (se llega por los saltos cuando t29a = si/no  o t33 = no o t34 = si/no 
-- la variable t36 y t36a desaparecen (se indicaba cual de todas las opciones t36_1 a 8 era más importante y se ponía en t36a)
-- como t36b es una variable nueva poner mod(enc,4) + 1
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
r eah2012.plana_i1_%rowtype;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from eah2012.plana_i1_ where ((pla_t29a in (1,2)) or (pla_t33 = 2) or (pla_t34 in (1,2))) and pla_t35 = 1
  LOOP 
    update encu.respuestas set res_valor = (MOD(res_enc, 4) + 1)
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'I1' and res_mat='' and res_var ='t36b';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

-- para todos los mayores a 9 años 
-- si la variable pla_i3_1 esta vacía poner en respuestas i3_1 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select s.pla_enc, s.pla_hog, s.pla_mie, s.pla_exm from  eah2012.plana_i1_ s inner join eah2012.plana_s1_p p 
   on s.pla_enc=p.pla_enc and s.pla_enc=p.pla_enc and s.pla_hog=p.pla_hog and s.pla_mie=p.pla_mie and s.pla_exm=p.pla_exm 
   where pla_i3_1 is distinct  from 1 and pla_edad > 9
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'I1' and res_mat='' and res_var ='i3_1';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

-- para todos los mayores a 9 años 
-- si la variable pla_i3_2 esta vacía poner en respuestas i3_2 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select s.pla_enc, s.pla_hog, s.pla_mie, s.pla_exm from  eah2012.plana_i1_ s inner join eah2012.plana_s1_p p 
   on s.pla_enc=p.pla_enc and s.pla_enc=p.pla_enc and s.pla_hog=p.pla_hog and s.pla_mie=p.pla_mie and s.pla_exm=p.pla_exm 
   where pla_i3_2 is distinct  from 1 and pla_edad > 9
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'I1' and res_mat='' and res_var ='i3_2';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

-- para todos los mayores a 9 años 
-- si la variable pla_i3_3 esta vacía poner en respuestas i3_3 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select s.pla_enc, s.pla_hog, s.pla_mie, s.pla_exm from  eah2012.plana_i1_ s inner join eah2012.plana_s1_p p 
   on s.pla_enc=p.pla_enc and s.pla_enc=p.pla_enc and s.pla_hog=p.pla_hog and s.pla_mie=p.pla_mie and s.pla_exm=p.pla_exm 
   where pla_i3_3 is distinct  from 1 and pla_edad > 9
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'I1' and res_mat='' and res_var ='i3_3';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

-- para todos los mayores a 9 años 
-- si la variable pla_i3_4 esta vacía poner en respuestas i3_4 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select s.pla_enc, s.pla_hog, s.pla_mie, s.pla_exm from  eah2012.plana_i1_ s inner join eah2012.plana_s1_p p 
   on s.pla_enc=p.pla_enc and s.pla_enc=p.pla_enc and s.pla_hog=p.pla_hog and s.pla_mie=p.pla_mie and s.pla_exm=p.pla_exm 
   where pla_i3_4 is distinct  from 1 and pla_edad > 9
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'I1' and res_mat='' and res_var ='i3_4';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

-- para todos los mayores a 9 años 
-- si la variable pla_i3_5 esta vacía poner en respuestas i3_5 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select s.pla_enc, s.pla_hog, s.pla_mie, s.pla_exm from  eah2012.plana_i1_ s inner join eah2012.plana_s1_p p 
   on s.pla_enc=p.pla_enc and s.pla_enc=p.pla_enc and s.pla_hog=p.pla_hog and s.pla_mie=p.pla_mie and s.pla_exm=p.pla_exm 
   where pla_i3_5 is distinct  from 1 and pla_edad > 9
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'I1' and res_mat='' and res_var ='i3_5';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

-- para todos los mayores a 9 años 
-- si la variable pla_i3_6 esta vacía poner en respuestas i3_6 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select s.pla_enc, s.pla_hog, s.pla_mie, s.pla_exm from  eah2012.plana_i1_ s inner join eah2012.plana_s1_p p 
   on s.pla_enc=p.pla_enc and s.pla_enc=p.pla_enc and s.pla_hog=p.pla_hog and s.pla_mie=p.pla_mie and s.pla_exm=p.pla_exm 
   where pla_i3_6 is distinct  from 1 and pla_edad > 9
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'I1' and res_mat='' and res_var ='i3_6';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

-- para todos los mayores a 9 años 
-- si la variable pla_i3_7 esta vacía poner en respuestas i3_7 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select s.pla_enc, s.pla_hog, s.pla_mie, s.pla_exm from  eah2012.plana_i1_ s inner join eah2012.plana_s1_p p 
   on s.pla_enc=p.pla_enc and s.pla_enc=p.pla_enc and s.pla_hog=p.pla_hog and s.pla_mie=p.pla_mie and s.pla_exm=p.pla_exm 
   where pla_i3_7 is distinct  from 1 and pla_edad > 9
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'I1' and res_mat='' and res_var ='i3_7';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

-- para todos los mayores a 9 años 
-- si la variable pla_i3_8 esta vacía poner en respuestas i3_8 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select s.pla_enc, s.pla_hog, s.pla_mie, s.pla_exm from  eah2012.plana_i1_ s inner join eah2012.plana_s1_p p 
   on s.pla_enc=p.pla_enc and s.pla_enc=p.pla_enc and s.pla_hog=p.pla_hog and s.pla_mie=p.pla_mie and s.pla_exm=p.pla_exm 
   where pla_i3_8 is distinct  from 1 and pla_edad > 9
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'I1' and res_mat='' and res_var ='i3_8';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

-- para todos los mayores a 9 años 
-- si la variable pla_i3_11 esta vacía poner en respuestas i3_11 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select s.pla_enc, s.pla_hog, s.pla_mie, s.pla_exm from  eah2012.plana_i1_ s inner join eah2012.plana_s1_p p 
   on s.pla_enc=p.pla_enc and s.pla_enc=p.pla_enc and s.pla_hog=p.pla_hog and s.pla_mie=p.pla_mie and s.pla_exm=p.pla_exm 
   where pla_i3_11 is distinct  from 1 and pla_edad > 9
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'I1' and res_mat='' and res_var ='i3_11';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

-- para todos los mayores a 9 años 
-- si la variable pla_i3_10 esta vacía poner en respuestas i3_10 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select s.pla_enc, s.pla_hog, s.pla_mie, s.pla_exm from  eah2012.plana_i1_ s inner join eah2012.plana_s1_p p 
   on s.pla_enc=p.pla_enc and s.pla_enc=p.pla_enc and s.pla_hog=p.pla_hog and s.pla_mie=p.pla_mie and s.pla_exm=p.pla_exm 
   where pla_i3_10 is distinct  from 1 and pla_edad > 9
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'I1' and res_mat='' and res_var ='i3_10';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

-- para todos los mayores a 9 años 
-- si la variable pla_i3_12 esta vacía poner en respuestas i3_12 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select s.pla_enc, s.pla_hog, s.pla_mie, s.pla_exm from  eah2012.plana_i1_ s inner join eah2012.plana_s1_p p 
   on s.pla_enc=p.pla_enc and s.pla_enc=p.pla_enc and s.pla_hog=p.pla_hog and s.pla_mie=p.pla_mie and s.pla_exm=p.pla_exm 
   where pla_i3_12 is distinct  from 1 and pla_edad > 9
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'I1' and res_mat='' and res_var ='i3_12';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

-- para todas las personas 
-- si la variable pla_sn1_1 esta vacía poner en respuestas sn1_1 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from  eah2012.plana_i1_ 
   where pla_sn1_1 is distinct  from 1 
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'I1' and res_mat='' and res_var ='sn1_1';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

-- para todas las personas 
-- si la variable pla_sn1_2 esta vacía poner en respuestas sn1_2 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from  eah2012.plana_i1_ 
   where pla_sn1_2 is distinct  from 1 
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'I1' and res_mat='' and res_var ='sn1_2';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

-- para todas las personas 
-- si la variable pla_sn1_3 esta vacía poner en respuestas sn1_3 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from  eah2012.plana_i1_ 
   where pla_sn1_3 is distinct  from 1 
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'I1' and res_mat='' and res_var ='sn1_3';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

-- para todas las personas 
-- si la variable pla_sn1_4 esta vacía poner en respuestas sn1_4 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from  eah2012.plana_i1_ 
   where pla_sn1_4 is distinct  from 1 
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'I1' and res_mat='' and res_var ='sn1_4';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

-- para todas las personas 
-- si la variable pla_sn1_5 esta vacía poner en respuestas sn1_5 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from  eah2012.plana_i1_ 
   where pla_sn1_5 is distinct  from 1 
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'I1' and res_mat='' and res_var ='sn1_5';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

-- para todas las personas 
-- si la variable pla_sn1_6 esta vacía poner en respuestas sn1_6 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from  eah2012.plana_i1_ 
   where pla_sn1_6 is distinct  from 1 
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'I1' and res_mat='' and res_var ='sn1_6';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

-- para todas las personas 
-- si la variable pla_sn1_7 esta vacía poner en respuestas sn1_7 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from  eah2012.plana_i1_ 
   where pla_sn1_7 is distinct  from 1 
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'I1' and res_mat='' and res_var ='sn1_7';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

--  a todas las viviendas 
-- si la variable pla_h20_1 esta vacía poner en respuestas h20_1 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from  eah2012.plana_a1_ 
   where pla_h20_1 is distinct  from 1 
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'A1' and res_mat='' and res_var ='h20_1';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

--  a todas las viviendas 
-- si la variable pla_h20_2 esta vacía poner en respuestas h20_2 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from  eah2012.plana_a1_ 
   where pla_h20_2 is distinct  from 1 
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'A1' and res_mat='' and res_var ='h20_2';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

--  a todas las viviendas 
-- si la variable pla_h20_17 esta vacía poner en respuestas h20_17 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from  eah2012.plana_a1_ 
   where pla_h20_17 is distinct  from 1 
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'A1' and res_mat='' and res_var ='h20_17';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

--  a todas las viviendas 
-- si la variable pla_h20_18 esta vacía poner en respuestas h20_18 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from  eah2012.plana_a1_ 
   where pla_h20_18 is distinct  from 1 
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'A1' and res_mat='' and res_var ='h20_18';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();


--  a todas las viviendas 
-- si la variable pla_h20_5 esta vacía poner en respuestas h20_5 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from  eah2012.plana_a1_ 
   where pla_h20_5 is distinct  from 1 
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'A1' and res_mat='' and res_var ='h20_5';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();


--  a todas las viviendas 
-- si la variable pla_h20_6 esta vacía poner en respuestas h20_6 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from  eah2012.plana_a1_ 
   where pla_h20_6 is distinct  from 1 
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'A1' and res_mat='' and res_var ='h20_6';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();


--  a todas las viviendas 
-- si la variable pla_h20_7 esta vacía poner en respuestas h20_7 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from  eah2012.plana_a1_ 
   where pla_h20_7 is distinct  from 1 
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'A1' and res_mat='' and res_var ='h20_7';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();


--  a todas las viviendas 
-- si la variable pla_h20_15 esta vacía poner en respuestas h20_15 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from  eah2012.plana_a1_ 
   where pla_h20_15 is distinct  from 1 
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'A1' and res_mat='' and res_var ='h20_15';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();


--  a todas las viviendas 
-- si la variable pla_h20_8 esta vacía poner en respuestas h20_8 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from  eah2012.plana_a1_ 
   where pla_h20_8 is distinct  from 1 
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'A1' and res_mat='' and res_var ='h20_8';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();


--  a todas las viviendas 
-- si la variable pla_h20_19 esta vacía poner en respuestas h20_19 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from  eah2012.plana_a1_ 
   where pla_h20_19 is distinct  from 1 
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'A1' and res_mat='' and res_var ='h20_19';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();


--  a todas las viviendas 
-- si la variable pla_h20_12 esta vacía poner en respuestas h20_12 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from  eah2012.plana_a1_ 
   where pla_h20_12 is distinct  from 1 
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'A1' and res_mat='' and res_var ='h20_12';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

--  a todas las viviendas 
-- si la variable pla_h20_11 esta vacía poner en respuestas h20_11 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from  eah2012.plana_a1_ 
   where pla_h20_11 is distinct  from 1 
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'A1' and res_mat='' and res_var ='h20_11';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

--  a todas las viviendas 
-- si la variable pla_h20_14 esta vacía poner en respuestas h20_14 valor 2
create or replace function cambiar_datos()
  returns integer 
  language plpgsql
as
$BODY$
declare
v_enc integer;
v_hog integer;
v_mie integer;
v_exm integer;
v_cuantos integer;
begin
 v_cuantos := 0;
 FOR v_enc, v_hog, v_mie, v_exm in
   select pla_enc, pla_hog, pla_mie, pla_exm from  eah2012.plana_a1_ 
   where pla_h20_14 is distinct  from 1 
  LOOP 
    update encu.respuestas set res_valor = 2
    where res_enc = v_enc and res_hog = v_hog and res_mie = v_mie and res_exm = v_exm
    and res_ope='eah2013' and res_for = 'A1' and res_mat='' and res_var ='h20_14';
    v_cuantos := v_cuantos+1;
  END LOOP;
 return v_cuantos;
end;
$BODY$;
select cambiar_datos();
drop function cambiar_datos();

update encu.respuestas set res_valor = 2 where res_ope='eah2013' and res_for = 'A1' and res_mat='' and res_var ='h21';
