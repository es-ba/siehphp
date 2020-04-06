INSERT INTO filtros (fil_ope, fil_for, fil_mat, fil_blo, fil_fil, fil_texto, fil_expresion, fil_destino, fil_orden, fil_aclaracion, fil_tlg) VALUES 
('eah2014', 'A1', '', '', 'FILTRO_0', 'Vivienda', 'copia_nhogar > 1', 'H1', 2, NULL, 1),
('eah2014', 'I1', '', 'E', 'FILTRO_2', 'CONFRONTE EDAD', 'copia_edad<3', 'E2', 1000, 'menores de 3 años', 1),
('eah2014', 'I1', '', 'SMM', 'FILTRO_3', 'CONFRONTE EDAD', 'copia_edad<14 OR (copia_edad>=14 AND copia_sexo=1)', 'fin', 2000, 'Resto', 1),
('eah2014', 'I1', '', 'T', 'FILTRO_1', 'CONFRONTE EDAD', 'copia_edad<10', 'FILTRO_2', 15, '9 años o menos', 1);