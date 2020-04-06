INSERT INTO encu.saltos(
            sal_ope, sal_var, sal_conopc, sal_opc, sal_destino, sal_tlg)
    VALUES ('ebcp2014','bcp1','bcp1', 2, 'entrea', 1);

INSERT INTO encu.bloques(
    blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
    blo_orden, blo_aclaracion, blo_tlg)
VALUES ('ebcp2014', 'S1', 'S1.2','', '', null, 
    850, null, 1);
    
UPDATE encu.preguntas set pre_blo='S1.2' where pre_ope='ebcp2014' and pre_for='S1' and pre_mat='' and pre_pre in ('nmiembro_titular','total_m');

update encu.variables set var_expresion_habilitar='p5=3' where var_for='S1' and var_mat='P' and var_ope='ebcp2014' and var_var ='p5c';

update encu.variables set var_tipovar='numeros' where var_for='A1' and var_ope='ebcp2014' and var_var in ('h2d', 'h2e', 'h2c');

delete from encu.saltos where sal_conopc='t39' and sal_opc in ('2','4');

update encu.variables set var_destino='T40' where var_ope='ebcp2014'  and var_var in ('t39_barrio', 't39_otro');


delete from encu.variables  where var_ope='ebcp2014' and var_var='t53_nop';

insert into encu.variables
         (var_ope   , var_for, var_mat, var_pre, var_var, var_texto              , var_conopc, var_tipovar, var_orden, var_tlg)
  values ('ebcp2014', 'I1',    ''     , 'E11'  , 'e11_1', 'Terminó los estudios' , 'si_no_h' , 'si_no'    , 1, 1);

UPDATE encu.filtros
   SET fil_expresion='copia_edad<18 OR copia_edad>29', fil_aclaracion='Personas menores a 18 y mayores a 29'
 WHERE fil_ope='ebcp2014' and  fil_for='I1' and fil_fil='FILTRO_5';

update encu.variables set var_destino='M1a'
  where var_var in ('m1_esp2','m1_esp3') and var_ope='ebcp2014';

delete from encu.saltos
  where sal_ope='ebcp2014' and sal_var='m1' and sal_opc>'1';

update encu.variables
  set var_conopc='e11a'
  where var_var='e11a' and var_ope='ebcp2014';

update encu.filtros set fil_expresion=replace(fil_expresion,'=9','=3');
