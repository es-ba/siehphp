alter table encu.plana_i1_
    add column pla_t_ocup integer, 
    add column pla_t_desoc integer,
    add column pla_t_ina integer,
    add column pla_cond_activ integer,
    add column pla_tipodes integer,
    add column pla_t_categ integer,
    add column pla_categori integer,
    add column pla_categdes integer;
alter table his.plana_i1_
    add column pla_t_ocup integer, 
    add column pla_t_desoc integer,
    add column pla_t_ina integer,
    add column pla_cond_activ integer,
    add column pla_tipodes integer,
    add column pla_t_categ integer,
    add column pla_categori integer,
    add column pla_categdes integer;
    
-- Function: encu.calcular_varcal_i1_trg()

-- DROP FUNCtION encu.calcular_varcal_i1_trg();

CREAtE OR REPLACE FUNCtION encu.calcular_varcal_i1_trg()
  REtURNS trigger AS
$BODY$
declare 
  v_edad integer;
  v_sexo integer;  
BEGIN
  select pla_edad, pla_sexo 
    from encu.plana_s1_p  p
    where p.pla_enc = new.pla_enc 
      and p.pla_hog = new.pla_hog  
      and p.pla_mie = new.pla_mie
      and p.pla_exm = new.pla_exm
    into v_edad, v_sexo;      
  new.pla_t_ocup:=case
    when (new.pla_t1=1 AND new.pla_t7=1) then 1
    when (new.pla_t1=1 AND new.pla_t7=2 AND (new.pla_t8= 1 oR new.pla_t8 = 2)) then 2
    when (new.pla_t1=2 AND  new.pla_t2=1 AND new.pla_t7=1) then 3
    when (new.pla_t1=2 AND  new.pla_t2=1 AND new.pla_t7=2 AND (new.pla_t8= 1 OR new.pla_t8= 2)) then 4
    when (new.pla_t1=2 AND  new.pla_t2=2 AND new.pla_t3=5 AND (new.pla_t4 >= 1 AND new.pla_t4 <=3)) then 5
    when (new.pla_t1=2 AND  new.pla_t2=2 AND new.pla_t3=5 AND new.pla_t4= 4 AND new.pla_t5=1) then 6
    when (new.pla_t1=2 AND  new.pla_t2=2 AND new.pla_t3=5 AND new.pla_t4= 5 AND new.pla_t6=1) then 7
    else null end;
  new.pla_t_desoc:=case
    when (new.pla_t1= 2 AND new.pla_t2=2 AND (new.pla_t3 >= 2 AND new.pla_t3 <= 4) AND new.pla_t9=1 AND new.pla_t12=1) then 1                                                                        
    when (new.pla_t1= 2 AND new.pla_t2=2 AND (new.pla_t3 >= 2 AND new.pla_t3 <= 4) AND new.pla_t9=2 AND new.pla_t10=1 AND new.pla_t12=1) then 2 
    when (new.pla_t1= 2 AND new.pla_t2=2 AND (new.pla_t3 >= 2 AND new.pla_t3 <= 4) AND new.pla_t9=2 AND new.pla_t10=2 AND (new.pla_t11 >= 1 oR new.pla_t11 <= 2) AND new.pla_t12=1) then 3 
    when (new.pla_t1= 2 AND new.pla_t2=2 AND new.pla_t3= 5 AND new.pla_t4=4 AND (new.pla_t5=2 oR new.pla_t5 = 3) AND new.pla_t9=1 AND new.pla_t12=1) then 4
    when (new.pla_t1= 2 AND new.pla_t2=2 AND new.pla_t3= 5 AND new.pla_t4=4 AND ( new.pla_t5=2 OR new.pla_t5 =  3) AND new.pla_t9=2 AND new.pla_t10=1 AND new.pla_t12=1) then 5
    when (new.pla_t1= 2 AND new.pla_t2=2 AND new.pla_t3= 5 AND new.pla_t4=4 AND (new.pla_t5=2 oR new.pla_t5 = 3) AND new.pla_t10=2 AND (new.pla_t11= 1 oR new.pla_t11 = 2) AND new.pla_t12=1) then 6 
    when (new.pla_t1= 2 AND new.pla_t2=2 AND new.pla_t3= 5 AND new.pla_t4=5 AND (new.pla_t6=2 oR new.pla_t6 = 3) AND new.pla_t9=1  AND new.pla_t12=1) then 7
    when (new.pla_t1= 2 AND new.pla_t2=2 AND new.pla_t3= 5 AND new.pla_t4=5 AND (new.pla_t6=2 oR new.pla_t6 = 3) AND new.pla_t9=2 AND new.pla_t10=1 AND new.pla_t12=1) then 8 
    when (new.pla_t1= 2 AND new.pla_t2=2 AND new.pla_t3= 5 AND new.pla_t4=5 AND (new.pla_t6=2 oR new.pla_t6 = 3) AND new.pla_t10=2 AND (new.pla_t11= 1 OR new.pla_t11 = 2) AND new.pla_t12=1) then 9
    when (new.pla_t1= 1 AND new.pla_t7=2 AND new.pla_t8= 3 AND new.pla_t9=1  AND new.pla_t12=1) then 10 
    when (new.pla_t1= 1 AND new.pla_t7=2 AND new.pla_t8= 3 AND new.pla_t9=2 AND new.pla_t10=1  AND new.pla_t12=1) then 11 
    when (new.pla_t1= 1 AND new.pla_t7=2 AND  new.pla_t8= 3 AND new.pla_t9=2 AND new.pla_t10=2 AND (new.pla_t11= 1 oR new.pla_t11 = 2) AND new.pla_t12=1) then 12 
    when (new.pla_t1= 2 AND new.pla_t2=1 AND new.pla_t7=2 AND new.pla_t8= 3 AND new.pla_t9=1  AND new.pla_t12=1) then 13 
    when (new.pla_t1= 2 AND new.pla_t2=1 AND new.pla_t7=2 AND new.pla_t8= 3 AND new.pla_t9=2 AND new.pla_t10=1 AND new.pla_t12=1) then 14 
    when (new.pla_t1= 2 AND new.pla_t2=1 AND new.pla_t7=2 AND new.pla_t8= 3 AND new.pla_t9=2 AND new.pla_t10=2 AND (new.pla_t11= 1 oR new.pla_t11 = 2) AND new.pla_t12=1) then 15 
    else null end;
  new.pla_t_ina:=case
    when (new.pla_t1=2 AND new.pla_t2=2 AND new.pla_t3=1) then 1
    when (new.pla_t11 = 3 OR new.pla_t11 = 4) then 2
    when (v_edad <= 9) then 3
    when (new.pla_t12 = 2) then 4
    else null end;
  new.pla_cond_activ:=case
    when (new.pla_t_ocup >=1) then 1
    when (new.pla_t_desoc >=1) then 2
    when (new.pla_t_ina >=1) then 3
    else null end;
  new.pla_tipodes:=case
    when (new.pla_cond_activ =2 and (new.pla_t16 = 1 or new.pla_t18 = 1)) then 1
    when (new.pla_cond_activ = 2 and new.pla_t16 = 2 and new.pla_t18= 2) then 2
    when ((new.pla_cond_activ = 2 and (new.pla_t16 = 9 or new.pla_t18 = 9)) OR (new.pla_cond_activ = 2 and new.pla_t16 = 0 and new.pla_t18 = 0) OR (new.pla_cond_activ = 2  and new.pla_t16 = 2 and new.pla_t18 = 0)) then 9
    else null end;
  new.pla_t_categ:=case
    when (new.pla_cond_activ = 1 and new.pla_t46 = 1) then 1
    when (new.pla_cond_activ = 1 and (new.pla_t46 = 2 or new.pla_t46 = 3) and (new.pla_t47 = 2 or (new.pla_t47 = 1 and new.pla_t48 = 2))) then 2
    when (new.pla_cond_activ = 1 and new.pla_t44 = 3 or (new.pla_t44 = 2 and new.pla_t45 =1)) then 3
    when (new.pla_cond_activ = 1 and ( (new.pla_t46 = 2 or new.pla_t46 = 3) and new.pla_t47 = 1 and new.pla_t48 = 1)) then 4
    when (new.pla_cond_activ = 1 and new.pla_t37sd = 1) then 5
    when (new.pla_cond_activ = 1 and new.pla_t44 = 2 and new.pla_t45 = 3) then 6
  else null end;
  new.pla_categori:=case
    when (new.pla_t_categ = 1) then 1
    when (new.pla_t_categ = 2) then 2
    when (new.pla_t_categ >= 3 and new.pla_t_categ <= 5) then 3
    when (new.pla_t_categ = 6) then 4
  else null end;
  new.pla_categdes:=case  
    when (new.pla_cond_activ = 2 and new.pla_t22 = 1) then 1
    when (new.pla_cond_activ = 2 and (new.pla_t22 = 2 or new.pla_t22 = 3)) then 2
    when (new.pla_cond_activ = 2 and new.pla_t20 = 3 or (new.pla_t20 = 2 and new.pla_t21 = 1)) then 3
    when (new.pla_cond_activ = 2 and new.pla_t20 = 2 and new.pla_t21 = 3) then 4
  else null end;
  return new;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION encu.calcular_varcal_i1_trg()
  OWNER TO tedede_php;

-- Trigger: calcular_varcal_i1_trg on encu.plana_i1_

-- DROP TRIGGER calcular_varcal_i1_trg ON encu.plana_i1_;

CREATE TRIGGER calcular_varcal_i1_trg
  BEFORE UPDATE
  ON encu.plana_i1_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.calcular_varcal_i1_trg();
  
-- Function: disparar_variables_calculadas_s1_p_trg()

-- DROP FUNCTION encu.disparar_variables_calculadas_s1_p_trg();

CREATE OR REPLACE FUNCTION encu.disparar_variables_calculadas_s1_p_trg()
  RETURNS trigger AS
$BODY$
    BEGIN  
    if new.pla_edad is distinct from old.pla_edad or new.pla_sexo is distinct from old.pla_sexo then
        --- raise notice 'no, o sea si';
        update encu.plana_i1_ 
                set pla_obs = pla_obs
                where pla_enc = new.pla_enc 
                  and pla_hog = new.pla_hog  
                  and pla_mie = new.pla_mie
                  and pla_exm = 0;
    end if;
    return new;
    END
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION encu.disparar_variables_calculadas_s1_p_trg()
  OWNER TO tedede_php;

-- Trigger: disparar_variables_calculadas_s1_p_trg on encu.plana_s1_p

-- DROP TRIGGER disparar_variables_calculadas_s1_p_trg ON encu.plana_s1_p;

CREATE TRIGGER disparar_variables_calculadas_s1_p_trg
  AFTER UPDATE
  ON encu.plana_s1_p
  FOR EACH ROW
  EXECUTE PROCEDURE encu.disparar_variables_calculadas_s1_p_trg();  


  