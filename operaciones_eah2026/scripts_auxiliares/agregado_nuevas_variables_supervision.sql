set role tedede_php;
set search_path=encu;
--1. se insertan también bloques (en produc y capa, test ya lo cargaron)
insert into bloques (blo_ope,blo_blo,blo_for,blo_mat, blo_texto,blo_orden,blo_tlg)
values ('eah2026', 'SUP_MASC', 'SUP','','TENENCIA DE PERROS, GATOS Y MASCOTAS',45,1);

2. Fijarse si no hay un hueco en la variable orden (orden dentro de la pregunta)
   hay que modificar los ordenes a 'orden+1' de las variables que van después de donde se insertará la nueva variable
{{{
--en este caso en particular controlamos en test que ya las cargaron y aparte es otro bloque
select pre_pre, pre_blo, pre_for, pre_orden from encu.preguntas
                 where pre_ope='eah2026' and  pre_for='SUP' and pre_blo='SUP_MASC'  and pre_pre like 'SP8A%' ;
--"SP8A"	"SUP_MASC"	"SUP"	10

select var_pre, var_var, var_orden from  encu.variables
                where var_ope='eah2026' and var_for='SUP' and var_pre like 'SP8A%' 
				order by var_orden ;
--"SP8A"	"sp8a_a"	5
--"SP8A"	"sp8a_b"	10
--"SP8A"	"sp8a_c"	15


--actualizar los órdenes si fuese necesario --ejemplo
/*
UPDATE encu.variables
                set var_orden=var_orden +1
                where var_ope='eah2026' and var_for='SUP' and var_pre like 'SP8A%' and var_orden>=3;
*/
}}}

3. Insertar las nuevas variables en la tabla variables 
{{{
--en este caso en particular para los entornos de capa y produc porque test ya lo cargaron
insert into preguntas  (pre_ope, pre_pre, pre_for, pre_blo, pre_texto,pre_aclaracion, pre_desp_opc, pre_orden, pre_tlg)
values ('eah2026','SP8A', 'SUP', 'SUP_MASC','¿Este hogar tiene…','(G-M)','vertical',10,1);

....
INSERT INTO encu.variables(
            var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_conopc,var_tipovar,var_tlg, 
            var_orden, var_optativa, var_maximo, var_minimo, var_nombre_dr) VALUES 
           ('eah2026', 'SUP', '', 'SP8A', 'sp8a_a', 'perros?'           ,'si_no_h', 'si_no',1, 5,  false,2,1,'pygf1a'),
           ('eah2026', 'SUP', '', 'SP8A', 'sp8a_b', 'gatos?'            ,'si_no_h', 'si_no',1, 10, false,2,1,'pygf1b'),
           ('eah2026', 'SUP', '', 'SP8A', 'sp8a_c', 'otra/s mascota/s?' ,'si_no_h', 'si_no',1, 15, false,2,1,'pygf1c');

}}}
4. Agregar la columna correspondiente a la nueva variable en la tabla plana  a la que pertenece. También agregar esa columna en la tabla his de la plana
{{{
ALTER TABLE encu.plana_sup_ ADD COLUMN pla_sp8a_a integer;
ALTER TABLE encu.plana_sup_ ADD COLUMN pla_sp8a_b integer;
ALTER TABLE encu.plana_sup_ ADD COLUMN pla_sp8a_c integer;

ALTER TABLE his.plana_sup_  ADD COLUMN  pla_sp8a_a  integer; 
ALTER TABLE his.plana_sup_  ADD COLUMN  pla_sp8a_b  integer; 
ALTER TABLE his.plana_sup_  ADD COLUMN  pla_sp8a_c  integer; 

5. Controles -(cuando hay info de encuestas ya cargada)
select *
from encu.respuestas
where res_for='SUP' and res_var like 'sp8a%';
select *
from encu.plana_sup_;
select *
from encu.claves
where cla_for='SUP';

6. Setear los valores de la nueva variable en los registros que corresponda de la tabla respuestas si fuese necesario 
/* en este caso no es necesario por eso lo comento 
update encu.respuestas r
  set res_valor=1
  -- select *
  from  encu.respuestas r ,
    (select * from encu.respuestas 
         where res_ope='eah ....' and res_for='SUP ' and res_mat='' and res_var='obs'  --aca poner una variable que tenga info cargada del mismo operativo
    ) as cla
where cla.res_ope=r.res_ope and cla.res_for=r.res_for and cla.res_mat=r.res_mat and cla.res_enc=r.res_enc and
        cla.res_hog=r.res_hog and cla.res_mie=r.res_mie and cla.res_exm=r.res_exm and r.res_var='sp8a....';
*/
7. Desde el sistema Actualizar Instalación (jsones varios, post cambio metadatos)

8. Regenerar consistencias de auditoria y de flujo, si fuera necesario 
   Tener cuidado que desde procesamiento desactivan consistencias. Mantener estas desactivadas.

9. Compilar las consistencias de auditoria y de flujo utilizando el Sistema.