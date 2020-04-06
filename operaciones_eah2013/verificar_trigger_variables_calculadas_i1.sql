update encu.plana_i1_ set pla_s31_mes = pla_s31_mes; 

/*
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

*/

select count(*) as total, pla_t1, pla_t2, pla_t3, pla_t4, pla_t5, pla_t6, pla_t7, pla_t8, pla_t_ocup  from encu.plana_i1_ i
    inner join encu.plana_tem_ t on i.pla_enc=t.pla_enc 
    where pla_estado=73 
    group by pla_t1, pla_t2, pla_t3, pla_t4, pla_t5, pla_t6, pla_t7, pla_t8, pla_t_ocup order by pla_t_ocup;

select count(*) as total, pla_t1, pla_t2, pla_t3, pla_t4, pla_t5, pla_t6, pla_t7, pla_t8, pla_t9, pla_t10, pla_t11, pla_t12, pla_t_desoc  from encu.plana_i1_  i
    inner join encu.plana_tem_ t on i.pla_enc=t.pla_enc 
    where pla_estado=73 
    group by pla_t1, pla_t2, pla_t3, pla_t4, pla_t5, pla_t6, pla_t7, pla_t8, pla_t9, pla_t10, pla_t11, pla_t12, pla_t_desoc order by pla_t_desoc;

select count(*) as total, pla_t1, pla_t2, pla_t3, pla_t11, pla_t12, pla_edad, pla_t_ina from encu.plana_i1_ i 
    inner join encu.plana_s1_p p on  i.pla_enc = p.pla_enc and i.pla_hog = p.pla_hog and i.pla_mie = p.pla_mie and i.pla_exm = p.pla_exm
    inner join encu.plana_tem_ t on i.pla_enc=t.pla_enc 
    where pla_estado=73 
    group by pla_t1, pla_t2, pla_t3, pla_t11, pla_t12, pla_edad, pla_t_ina order by pla_t_ina;  

select count(*) as total, pla_t_ocup, pla_t_desoc, pla_t_ina, pla_cond_activ from encu.plana_i1_ i 
    inner join encu.plana_tem_ t on i.pla_enc=t.pla_enc 
    where pla_estado=73 
    group by pla_t_ocup, pla_t_desoc, pla_t_ina, pla_cond_activ order by pla_cond_activ;  

select count(*) as total, pla_cond_activ, pla_t16, pla_t18, pla_tipodes from encu.plana_i1_ i 
    inner join encu.plana_tem_ t on i.pla_enc=t.pla_enc 
    where pla_estado=73 
    group by pla_cond_activ, pla_t16, pla_t18, pla_tipodes order by pla_tipodes;  

select count(*) as total, pla_cond_activ, pla_t37sd, pla_t44, pla_t45, pla_t46, pla_t47, pla_t48, pla_t_categ from encu.plana_i1_ i
    inner join encu.plana_tem_ t on i.pla_enc=t.pla_enc 
    where pla_estado=73 
    group by pla_cond_activ, pla_t37sd, pla_t44, pla_t45, pla_t46, pla_t47, pla_t48, pla_t_categ order by pla_t_categ;  

select count(*) as total, pla_t_categ, pla_categori from encu.plana_i1_ i
    inner join encu.plana_tem_ t on i.pla_enc=t.pla_enc 
    where pla_estado=73 
    group by pla_t_categ, pla_categori order by pla_categori; 

select count(*) as total, pla_cond_activ, pla_t20, pla_t21, pla_t22, pla_categdes from encu.plana_i1_ i
    inner join encu.plana_tem_ t on i.pla_enc=t.pla_enc 
    where pla_estado=73 
    group by pla_cond_activ, pla_t20, pla_t21, pla_t22, pla_categdes order by pla_categdes; 