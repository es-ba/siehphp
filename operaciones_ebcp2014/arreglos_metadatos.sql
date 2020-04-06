update encu.variables set var_tipovar='numeros' where var_tipovar='numero';
update encu.variables set var_destino_nsnc=null where var_destino_nsnc = 'H2';
update encu.variables set var_destino_nsnc=null where var_destino_nsnc = 't39_bis2';
update encu.variables set var_tipovar='si_no' where var_tipovar is not distinct from null;

/*
select var_tipovar, * from encu.variables where var_tipovar is not distinct from null
select * from encu.variables where var_var='i3



select * from encu.variables where var_destino_nsnc like '%P6A%'
select * from encu.variables where var_destino like '%P6A%'

t39_bis2

select * from encu.preguntas where pre_destino like '%P6A%'



select * from encu.saltos where sal_destino like '%P6A%'

select * from encu.filtros where fil_destino like '%t39_bis2%'


select * from encu.variables where var_expresion_habilitar like 
'%i3_12%'
i3_12x 
e11e 
m1_anio
vc3 
v3_2 
vc5 
v5_2 
p0_tit 
ti_7 
t19 
t110 
t112 
t113
p7 
select * from encu.variables where var_var='h2'
select * from encu.preguntas where pre_pre='H2'

*/


Variables con destino_nsnc inexistente las pusimos en nulo:

v12:'H2'
t39:'t39_bis2'
t39_otro:'t39_bis2'
t39_barrio:'t39_bis2'

Sacamos el saltos con destino inexistente ("P6A"):
variable: "p5c" opciòn:"1"
variable: "p5c" opciòn:"2"
variable: "p5c" opciòn:"3"
variable: "p5" opciòn:"4"
variable: "p5" opciòn:"5"
variable: "p5" opciòn:"6"

desactivamos las siguientes consistencias por contener variables "i3_12" o "i3_12x"
"audi_nsnc_i3_12"
"audi_nsnc_i3_12x"
"i03x_Tc"
"i3_12_ns"
"i3_12x_max"
"audi_rango_err_i3_12x"
"i03n_Tc"
"I3_12_H20"
"i00"
"audi_nsnc_i3_12x"
"i3_dato"
"i3_12_dato"
"i3_12x_dato"
"i399_i3x"
"i3_n_dato"
"i3_tot_dato"
"i399_i3"
"i3_suma"

desactivamos las siguientes consistencias por contener variables "m1_anio"
"flujo_sv_m1_anio_nsnc"
"audi_nsnc_m1_anio"
"m1_m1_anio_m3"
"m1_anio_anionac"
"M3_an>=M1_an"

desactivamos las siguientes consistencias por contener variables "p7"
"audi_nsnc_p7"
"P7=3_salto"
"P8"
"P8_0"
"P7=4_a"
"P7=4_b"
"P7=2_P8"
"compl_S1_P"
"ryt_ocu"
"p7NoInd"
"P5b_0"
"P7_datox"
"p6a_dato"
"P7_vacia"
"P7_dato"
"P7_0"
"p6b_dato"
"P7"
"P7_Norea09"
"ryt_deso"
"M1_v"
"P7=3_P8"
"P8_dato"
"T00"
"P4_dato"
"FAM_I1"
"hog_salido"
"Ind_no"
"S1p_si2"
"F_nac_o_v"
"Ind_si"

sacamos de var_expresion_habilitar las siguientes variables que no existen:

where var_var='i3_tot';
where var_var='e11_cuales';
where var_var='e11_especificar';
where var_var='vc4_1';
where var_var='vc4_2';
where var_var='vc6_1';
where var_var='vc6_2';
where var_var='ti1_otra';
where var_var='ti11';
where var_var='p5';
where var_var='p5b';
where var_var='p6_a';
where var_var='p6_b';





update encu.variables set var_expresion_habilitar='i3_1=1 or i3_2=1 or i3_3=1 or i3_4=1 or i3_5=1 or i3_6=1 or i3_7=1 or i3_8=1 or i3_10=1 or i3_11=1' 
where var_var='i3_tot';

update encu.variables set var_expresion_habilitar=null 
where var_var='e11_cuales';

update encu.variables set var_expresion_habilitar=null 
where var_var='e11_especificar';

update encu.variables set var_expresion_habilitar=null 
where var_var='vc4_1';

update encu.variables set var_expresion_habilitar=null 
where var_var='vc4_2';

update encu.variables set var_expresion_habilitar=null 
where var_var='vc6_1';

update encu.variables set var_expresion_habilitar=null 
where var_var='vc6_2';

update encu.variables set var_expresion_habilitar=null 
where var_var='ti1_otra';

update encu.variables set var_expresion_habilitar='ti3=2 or t14=2 or t15=2 or t16=2 or t17=2 or t18=2'
where var_var='ti11';

update encu.variables set var_expresion_habilitar='edad>=14'
where var_var='p5';

update encu.variables set var_expresion_habilitar='(edad>=14) and (p5=1 or p5=2)'
where var_var='p5b';

update encu.variables set var_expresion_habilitar='edad<=24'
where var_var='p6_a';

update encu.variables set var_expresion_habilitar='edad<=24'
where var_var='p6_b';






update encu.consistencias set con_activa=false, con_valida=false where con_con in (
	select con_con from encu.consistencias where con_expresion_sql like '%i3_12x%' 
);

update encu.consistencias set con_activa=false, con_valida=false where con_con in (
	select con_con from encu.consistencias where con_expresion_sql like '%p7%' 
);

alter table encu.consistencias alter column con_postcondicion type varchar (7000);
alter table encu.consistencias alter column con_precondicion type varchar (3000);
alter table encu.consistencias alter column con_explicacion type varchar (3000);
alter table encu.consistencias alter column con_explicacion type varchar (1200);
alter table encu.consistencias alter column con_explicacion type varchar (1200);


update encu.variables set var_expresion_habilitar=null 
where var_var in('f_nac_o','edad','p4');


update encu.filtros set fil_expresion='copia_sexo=1' where fil_expresion like '%copia_p0_tit%';


set search_path=encu, comun, public;
update encu.consistencias set con_activa=false where con_con in (
select con_con from encu.consistencias where con_precondicion||con_postcondicion like '%i3_12%'
);

update encu.consistencias set con_activa=false where con_con in (
select con_con from encu.consistencias where con_precondicion||con_postcondicion like '%m1_anio%'
);




select * from encu.saltos where sal_destino like '%P6A%'

select * from encu.variables where var_var like '%i3_12x%'

delete from encu.saltos where sal_destino like '%P6A%';


