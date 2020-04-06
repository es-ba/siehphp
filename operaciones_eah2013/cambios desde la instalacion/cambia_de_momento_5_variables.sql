update encu.operativos set ope_en_campo=false where ope_ope='eah2013';


set search_path=encu;

update encu.consistencias set con_momento='Relevamiento 1'
where con_con in (
'EPRI_adu',
'T52_i2', 
'POSGRA',
'i3_11x_min',
'P4=2_No');

update encu.operativos set ope_en_campo=true where ope_ope='eah2013';