update encu.variables set var_maximo=33, var_minimo=0 where var_ope='pp2012' and var_var in (
't31_j','t31_l','t31_ma','t31_mi','t31_s','t31_v','t31_d','t32_d','t32_j','t32_l','t32_ma','t32_mi','t32_s','t32_v');

INSERT INTO encu.consistencias 
(con_ope, con_con, con_precondicion, con_rel, con_postcondicion, con_activa, con_explicacion, con_tipo, con_momento, con_grupo, con_modulo, con_valida,con_tlg, con_descripcion, con_gravedad, con_estado) 
VALUES ('pp2012', 'T31_l_horas', 'T31_l>0', '=>', 'T31_l<=24 or T31_l>=30', true, 'El día no puede tener más de 24 hs.', 'Conceptual',  'Relevamiento 1', 'Básica y gral',  'TRABAJO', false, 1, 'T31_l>24', 'Error','ok'),
 ('pp2012', 'T31_ma_horas', 'T31_ma>0', '=>', 'T31_ma<=24 or T31_ma>=30', true, 'El día no puede tener más de 24 hs.', 'Conceptual',  'Relevamiento 1', 'Básica y gral',  'TRABAJO', false, 1, 'T31_ma>24', 'Error','ok'),
 ('pp2012', 'T31_mi_horas', 'T31_mi>0', '=>', 'T31_mi<=24 or T31_mi>=30', true, 'El día no puede tener más de 24 hs.', 'Conceptual',  'Relevamiento 1', 'Básica y gral',  'TRABAJO', false, 1, 'T31_mi>24', 'Error','ok'),
 ('pp2012', 'T31_j_horas', 'T31_j>0', '=>', 'T31_j<=24 or T31_j>=30', true, 'El día no puede tener más de 24 hs.', 'Conceptual',  'Relevamiento 1', 'Básica y gral',  'TRABAJO', false, 1, 'T31_j>24', 'Error','ok'),
 ('pp2012', 'T31_v_horas', 'T31_v>0', '=>', 'T31_v<=24 or T31_v>=30', true, 'El día no puede tener más de 24 hs.', 'Conceptual',  'Relevamiento 1', 'Básica y gral',  'TRABAJO', false, 1, 'T31_v>24', 'Error','ok'),
 ('pp2012', 'T31_s_horas', 'T31_s>0', '=>', 'T31_s<=24 or T31_s>=30', true, 'El día no puede tener más de 24 hs.', 'Conceptual',  'Relevamiento 1', 'Básica y gral',  'TRABAJO', false, 1, 'T31_s>24', 'Error','ok'),
 ('pp2012', 'T31_d_horas', 'T31_d>0', '=>', 'T31_d<=24 or T31_d>=30', true, 'El día no puede tener más de 24 hs.', 'Conceptual',  'Relevamiento 1', 'Básica y gral',  'TRABAJO', false, 1, 'T31_d>24', 'Error','ok'),
 ('pp2012', 'T32_l_horas', 'T32_l>0', '=>', 'T32_l<=24 or T32_l>=30', true, 'El día no puede tener más de 24 hs.', 'Conceptual',  'Relevamiento 1', 'Básica y gral',  'TRABAJO', false, 1, 'T32_l>24', 'Error','ok'),
 ('pp2012', 'T32_ma_horas', 'T32_ma>0', '=>', 'T32_ma<=24 or T32_ma>=30', true, 'El día no puede tener más de 24 hs.', 'Conceptual',  'Relevamiento 1', 'Básica y gral',  'TRABAJO', false, 1, 'T32_ma>24', 'Error','ok'),
 ('pp2012', 'T32_mi_horas', 'T32_mi>0', '=>', 'T32_mi<=24 or T32_mi>=30', true, 'El día no puede tener más de 24 hs.', 'Conceptual',  'Relevamiento 1', 'Básica y gral',  'TRABAJO', false, 1, 'T32_mi>24', 'Error','ok'),
 ('pp2012', 'T32_j_horas', 'T32_j>0', '=>', 'T32_j<=24 or T32_j>=30', true, 'El día no puede tener más de 24 hs.', 'Conceptual',  'Relevamiento 1', 'Básica y gral',  'TRABAJO', false, 1, 'T32_j>24', 'Error','ok'),
 ('pp2012', 'T32_v_horas', 'T32_v>0', '=>', 'T32_v<=24 or T32_v>=30', true, 'El día no puede tener más de 24 hs.', 'Conceptual',  'Relevamiento 1', 'Básica y gral',  'TRABAJO', false, 1, 'T32_v>24', 'Error','ok'),
 ('pp2012', 'T32_s_horas', 'T32_s>0', '=>', 'T32_s<=24 or T32_s>=30', true, 'El día no puede tener más de 24 hs.', 'Conceptual',  'Relevamiento 1', 'Básica y gral',  'TRABAJO', false, 1, 'T32_s>24', 'Error','ok'),
 ('pp2012', 'T32_d_horas', 'T32_d>0', '=>', 'T32_d<=24 or T32_d>=30', true, 'El día no puede tener más de 24 hs.', 'Conceptual',  'Relevamiento 1', 'Básica y gral',  'TRABAJO', false, 1, 'T32_d>24', 'Error','ok');