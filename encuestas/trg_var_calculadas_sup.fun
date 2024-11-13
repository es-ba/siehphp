-- agregar variables a calcular de supervision a la correspondiente tabla
alter table encu.plana_sup_
  add column pla_sp_cond_activ integer;
alter table encu.plana_sup_
  add column pla_cant_sp19 integer;
alter table encu.plana_sup_
  add column pla_sp_edad_30 integer;
alter table encu.plana_sup_
  add column pla_sp_e_nivela integer;
alter table encu.plana_sup_
  add column pla_sp_e_nivelb integer;
  
  
set search_path= encu, dbo, comun;
CREATE OR REPLACE FUNCTION encu.calculo_variables_calculadas_sup_v3_trg()
  RETURNS trigger AS
$BODY$
    DECLARE
    v_edad integer;
    vsp19_categoria1 integer;
    BEGIN
    /*
     SELECT pla_edad
       INTO v_edad
       FROM encu.plana_s1_p s
       WHERE  s.pla_enc = new.pla_enc and s.pla_hog = new.pla_hog and s.pla_mie = new.pla_mie and s.pla_exm = 0;
    */
     --vsp19_categoria1=enrango(new.pla_sp19_1,1,1);
     vsp19_categoria1=enrango(new.pla_sp19_34,1,1)+enrango(new.pla_sp19_34,1,1)+enrango(new.pla_sp19_35,1,1)+enrango(new.pla_sp19_36,1,1);
     --ademas en sp_cond_activ comenté variables que no estan en eah2024
     new.pla_sp_cond_activ:=case 
        when ((new.pla_sp13<0 and new.pla_sp14<1) or new.pla_sp15<0 or new.pla_sp17<0) then -9
        when ((new.pla_sp13=1 or new.pla_sp14=1 or new.pla_sp15=5) /*and not informado(new.pla_sp16a)*/ and not informado(new.pla_sp17)) then 1
        when ((new.pla_sp13=2 and new.pla_sp14=2 and new.pla_sp15>1 and new.pla_sp15<5 and not new.pla_sp17=2) or new.pla_sp17=1) then 2
        when ((new.pla_sp13=2 and new.pla_sp14=2 and new.pla_sp15=1) /*or (new.pla_sp16a>1 and new.pla_sp16a<6)*/ or new.pla_sp17=2 ) then 3
         else null end;

     new.pla_cant_sp19:=case 
        when (new.pla_sp19_34<0 or new.pla_sp19_35<0 or new.pla_sp19_36<0 or new.pla_sp19_2<0 or new.pla_sp19_3<0 or new.pla_sp19_4<0 or new.pla_sp19_5<0 or new.pla_sp19_6<0 or new.pla_sp19_7<0 or new.pla_sp19_81<0 or new.pla_sp19_82<0 or new.pla_sp19_11<0 or new.pla_sp19_31<0 or new.pla_sp19_12<0 or new.pla_sp19_13<0 or new.pla_sp19_10<0) then -9
        when (true) then  vsp19_categoria1 + (enrango(new.pla_sp19_2,1,1)) + (enrango(new.pla_sp19_3,1,1)) + (enrango(new.pla_sp19_4,1,1)) + (enrango(new.pla_sp19_5,1,1)) + (enrango(new.pla_sp19_6,1,1)) + (enrango(new.pla_sp19_7,1,1)) + (enrango(new.pla_sp19_81,1,1)) + (enrango(new.pla_sp19_82,1,1)) + (enrango(new.pla_sp19_11,1,1)) + (enrango(new.pla_sp19_31,1,1)) + (enrango(new.pla_sp19_12,1,1)) + (enrango(new.pla_sp19_13,1,1)) + (enrango(new.pla_sp19_10,1,1))
         else null end; 

     new.pla_sp_edad_30:=case 
        when (negado(informado(fechadma(boolint(new.pla_sp10_d>0 and new.pla_sp10_d<=31,15,new.pla_sp10_d) , new.pla_sp10_m, new.pla_sp10_a)))) then 999
        when (dbo.texto_a_fecha(fechadma(boolint(new.pla_sp10_d>0 and new.pla_sp10_d<=31,15,new.pla_sp10_d), new.pla_sp10_m, new.pla_sp10_a)) > dbo.texto_a_fecha(dbo.fecha_30junio())) then 888
        when (true) then dbo.edad_a_la_fecha(fechadma(boolint(new.pla_sp10_d>0 and new.pla_sp10_d<=31,15,new.pla_sp10_d), new.pla_sp10_m, new.pla_sp10_a),dbo.fecha_30junio())
         else null end;

     new.pla_sp_e_nivela:=case 
        when (new.pla_sp20=1 and new.pla_sp21=-9) then -9
        when (new.pla_sp20=1 and (new.pla_sp21=2 or new.pla_sp21>15)) then 0
        when (new.pla_sp20=1 and new.pla_sp21=3) then 1
        when (new.pla_sp20=1 and new.pla_sp21=5) then 2
        when (new.pla_sp20=1 and new.pla_sp21=15) then 3
        when (new.pla_sp20=1 and new.pla_sp21=7) then 4
        when (new.pla_sp20=1 and new.pla_sp21=10) then 5
        when (new.pla_sp20=1 and new.pla_sp21=12) then 6
        when (new.pla_sp20=1 and new.pla_sp21=13) then 7
        when (new.pla_sp20=1 and new.pla_sp21=14) then 8
        when (new.pla_sp20=1 and new.pla_sp21=6) then 9
         else null end; 
         
     new.pla_sp_e_nivelb:=case 
        when (new.pla_sp20=2 and (new.pla_sp22=-9 or (new.pla_sp22>2 and new.pla_sp22<16 and new.pla_sp23=-9))) then -9
        when (new.pla_sp20=2 and (new.pla_sp22=2 or new.pla_sp22>15)) then 1
        when (new.pla_sp20=2 and ((new.pla_sp22=3 and new.pla_sp23=1) or (new.pla_sp22=4 and new.pla_sp23=2))) then 2
        when (new.pla_sp20=2 and new.pla_sp22=3 and new.pla_sp23=2) then 3
        when (new.pla_sp20=2 and new.pla_sp22=5 and new.pla_sp23=1) then 4
        when (new.pla_sp20=2 and new.pla_sp22=5 and new.pla_sp23=2) then 5
        when (new.pla_sp20=2 and new.pla_sp22=15 and new.pla_sp23=1) then 6
        when (new.pla_sp20=2 and new.pla_sp22=15 and new.pla_sp23=2) then 7
        when (new.pla_sp20=2 and ((new.pla_sp22=7 or new.pla_sp22=11) and new.pla_sp23=1)) then 8
        when (new.pla_sp20=2 and (((new.pla_sp22=7 or new.pla_sp22=11) and new.pla_sp23=2) or (new.pla_sp22=4 and new.pla_sp23=1))) then 9
        when (new.pla_sp20=2 and new.pla_sp22=10 and new.pla_sp23=1) then 10
        when (new.pla_sp20=2 and new.pla_sp22=10 and new.pla_sp23=2) then 11
        when (new.pla_sp20=2 and new.pla_sp22=12 and new.pla_sp23=1) then 12
        when (new.pla_sp20=2 and new.pla_sp22=12 and new.pla_sp23=2) then 13
        when (new.pla_sp20=2 and new.pla_sp22=13 and new.pla_sp23=1) then 14
        when (new.pla_sp20=2 and new.pla_sp22=13 and new.pla_sp23=2) then 15
        when (new.pla_sp20=2 and new.pla_sp22=14 and new.pla_sp23=1) then 16
        when (new.pla_sp20=2 and new.pla_sp22=14 and new.pla_sp23=2) then 17
        when (new.pla_sp20=2 and new.pla_sp22=6) then 18
         else null end;
    return new;
    END;
    $BODY$
  LANGUAGE plpgsql ;
ALTER FUNCTION encu.calculo_variables_calculadas_sup_v3_trg()
  OWNER TO tedede_php;

DROP TRIGGER IF EXISTS calculo_variables_calculadas_sup_trg ON encu.plana_sup_;
CREATE TRIGGER calculo_variables_calculadas_sup_trg
  BEFORE UPDATE
  ON encu.plana_sup_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.calculo_variables_calculadas_sup_v3_trg();

-- varcal
  INSERT INTO encu.varcal(
            varcal_ope, varcal_varcal, varcal_destino, varcal_orden, varcal_nombre, 
            varcal_comentarios, varcal_tlg, varcal_activa, varcal_tipo, varcal_baseusuario, 
            varcal_nombrevar_baseusuario, varcal_tipodedato, varcal_nombre_dr, varcal_nsnc_atipico, varcal_grupo, varcal_valida)
      VALUES (dbo.ope_actual(),'sp_cond_activ','sup',1,'Condicion de actividad para supervision',
             'Para comparar con casi_cond_activ en grilla de supervisión',1,TRUE,'especial',TRUE,
             null,'entero',null,null,'supervisión', true); 
   INSERT INTO encu.varcal(
            varcal_ope, varcal_varcal, varcal_destino, varcal_orden, varcal_nombre, 
            varcal_comentarios, varcal_tlg, varcal_activa, varcal_tipo, varcal_baseusuario, 
            varcal_nombrevar_baseusuario, varcal_tipodedato, varcal_nombre_dr, varcal_nsnc_atipico, varcal_grupo, varcal_valida)
      VALUES (dbo.ope_actual(),'cant_sp19','sup',1,'Cantidad de fuentes de ingreso no laboral para supervisión',
             'Para comparar con cant_i3 en grilla de supervisión',1,TRUE,'especial',TRUE,
             null,'entero',null,null,'supervisión',true); 
   INSERT INTO encu.varcal(
            varcal_ope, varcal_varcal, varcal_destino, varcal_orden, varcal_nombre, 
            varcal_comentarios, varcal_tlg, varcal_activa, varcal_tipo, varcal_baseusuario, 
            varcal_nombrevar_baseusuario, varcal_tipodedato, varcal_nombre_dr, varcal_nsnc_atipico, varcal_grupo, varcal_valida)
      VALUES (dbo.ope_actual(),'sp_edad_30','sup',1,'Edad al 30 de junio para supervisión',
             'Años cumplidos al 30 de junio del año en curso para comparar con edad_30 en grilla de supervisión',1,TRUE,'especial',TRUE,
             null,'entero',null,null,'supervisión',true); 
   INSERT INTO encu.varcal(
            varcal_ope, varcal_varcal, varcal_destino, varcal_orden, varcal_nombre, 
            varcal_comentarios, varcal_tlg, varcal_activa, varcal_tipo, varcal_baseusuario, 
            varcal_nombrevar_baseusuario, varcal_tipodedato, varcal_nombre_dr, varcal_nsnc_atipico, varcal_grupo, varcal_valida)
      VALUES (dbo.ope_actual(),'sp_e_nivela','sup',1,'Nivel educativo que cursa para supervisión',
             'Para comparar con sp_e_nivela en grilla de supervisión',1,TRUE,'especial',TRUE,
             null,'entero',null,null,'supervisión',true); 
   INSERT INTO encu.varcal(
            varcal_ope, varcal_varcal, varcal_destino, varcal_orden, varcal_nombre, 
            varcal_comentarios, varcal_tlg, varcal_activa, varcal_tipo, varcal_baseusuario, 
            varcal_nombrevar_baseusuario, varcal_tipodedato, varcal_nombre_dr, varcal_nsnc_atipico, varcal_grupo, varcal_valida)
      VALUES (dbo.ope_actual(),'sp_e_nivelb','sup',1,'Nivel educativo que cursó para supervisión',
             'Para comparar con sp_e_nivelb en grilla de supervisión',1,TRUE,'especial',TRUE,
             null,'entero',null,null,'supervisión',true); 
  
-- activar la primera vez
update encu.plana_sup_
  set pla_observaciones=pla_observaciones;

