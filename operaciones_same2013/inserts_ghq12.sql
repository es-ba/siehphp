--select * from encu.variables where var_pre like 'G%';
--select * from encu.con_opc

INSERT INTO encu.con_opc VALUES 
('same2013','ghq_12_a',null, 'vertical',1),
('same2013','ghq_12_b',null, 'vertical',1),
('same2013','ghq_12_c',null, 'vertical',1),
('same2013','ghq_12_d',null, 'vertical',1),
('same2013','ghq_12_e',null, 'vertical',1);

update encu.opciones set opc_conopc='ghq_12_a' where opc_conopc='ghq_12';
update encu.variables set var_conopc='ghq_12_a' where var_pre like 'G%';
delete from encu.opciones where opc_conopc = 'ghq12';
delete from encu.con_opc where conopc_conopc = 'ghq12';
delete from encu.con_opc where conopc_conopc like 'ghq%' and conopc_conopc not in ('ghq_12_a','ghq12');

update encu.variables set var_conopc='ghq_12_b' where var_var in(
'ghq_12_2',
'ghq_12_5',
'ghq_12_6',
'ghq_12_9',
'ghq_12_10',
'ghq_12_11'
);

update encu.variables set var_conopc='ghq_12_c' where var_var in(
'ghq_12_3'
);

update encu.variables set var_conopc='ghq_12_d' where var_var in(
'ghq_12_4',
'ghq_12_7',
'ghq_12_12'
);

update encu.variables set var_conopc='ghq_12_e' where var_var in(
'ghq_12_8'
);

--select * from encu.opciones where opc_conopc like ('gh%');
INSERT INTO encu.opciones(
            opc_ope, opc_conopc, opc_opc, opc_texto, opc_orden, 
            opc_tlg)
VALUES
('same2013','ghq_12_b','0','No, en absoluto',0,1),
('same2013','ghq_12_b','1','No más que lo habitual',1,1),
('same2013','ghq_12_b','2','Algo más que lo habitual',2,1),
('same2013','ghq_12_b','3','Mucho más que lo habitual',3,1),
('same2013','ghq_12_b','8','No sabe',8,1),
('same2013','ghq_12_b','9','No contesta',9,1),

('same2013','ghq_12_c','0','Más útil que lo habitual',0,1),
('same2013','ghq_12_c','1','Igual que lo habitual',1,1),
('same2013','ghq_12_c','2','Menos útil que lo habitual',2,1),
('same2013','ghq_12_c','3','Mucho menos útil que lo habitual',3,1),
('same2013','ghq_12_c','8','No sabe',8,1),
('same2013','ghq_12_c','9','No contesta',9,1),

('same2013','ghq_12_d','0','Más que lo habitual',0,1),
('same2013','ghq_12_d','1','Igual que lo habitual',1,1),
('same2013','ghq_12_d','2','Menos que lo habitual',2,1),
('same2013','ghq_12_d','3','Mucho menos que lo habitual',3,1),
('same2013','ghq_12_d','8','No sabe',8,1),
('same2013','ghq_12_d','9','No contesta',9,1),

('same2013','ghq_12_e','0','Más capaz que lo habitual',0,1),
('same2013','ghq_12_e','1','Igual que lo habitual',1,1),
('same2013','ghq_12_e','2','Menos capaz que lo habitual',2,1),
('same2013','ghq_12_e','3','Mucho menos capaz que lo habitual',3,1),
('same2013','ghq_12_e','8','No sabe',8,1),
('same2013','ghq_12_e','9','No contesta',9,1);



