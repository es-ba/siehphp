--995124

--INSERT INTO encu.tem VALUES (995124, NULL, 4, 6, 674, 44, 1, 1655, 'CACHI', 1101, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 9, 3, 39, 1, 2, 'sur', 'ipad', 1);

INSERT INTO encu.plana_tem_ VALUES 
(995124, 0, 0, 0, NULL, 4, 6, 674, 44, 1, 1655, 'CACHI',
 1101, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 9, 3, 39,
  1, 2, 'sur', 'ipad', 1, NULL, 2, 59, 1, 4154,
   1, 1, 1, 1, 3, 3, NULL, 1, NULL, 9, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[{"fecha":"25\/07","hora":"11.30","observaciones":"Efectiva"}]', NULL, 1, 1, 0, NULL, NULL, 59, NULL, NULL);

INSERT INTO encu.claves VALUES ('pp2012', 'S1', 'P', 995124, 1, 1, 0, NULL, NULL, true, NULL, 7114, 1);
INSERT INTO encu.claves VALUES ('pp2012', 'S1', '', 995124, 1, 0, 0, NULL, true, NULL, NULL, 7151, 1);
INSERT INTO encu.claves VALUES ('pp2012', 'A1', '', 995124, 1, 0, 0, NULL, true, NULL, NULL, 7117, 1);
INSERT INTO encu.claves VALUES ('pp2012', 'I1', '', 995124, 1, 1, 0, NULL, NULL, true, NULL, 10323, 1);
--INSERT INTO encu.claves VALUES ('pp2012', 'TEM', '', 995124, 1, 0, 0, NULL, true, NULL, NULL, 7151, 1);

INSERT INTO encu.plana_s1_ VALUES (995124, 1, 0, 0, 1, 1, '4911-3435', 'Natalia', '25/07/2012', 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'la respondente declara no tener ningún plan de salud, ni ayuda del gobierno de la ciudad', 1);
INSERT INTO encu.plana_s1_p VALUES (995124, 1, 1, 0, 'Natalia', 2, 1, NULL, '26/12/1979', 32, 1, 3, NULL, NULL, NULL, 1);
INSERT INTO encu.plana_a1_ VALUES (995124, 1, 0, 0, 1, NULL, 4, NULL, 1, 4, 1, 1, 1, 5, NULL, 4, 1, 1, '4911-3435', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL, 3, 3, 3, 1, 3, 3, 3, 3, 1, 1, 2, 2, 2, 2, 1, 1);	
INSERT INTO encu.plana_i1_ VALUES (995124, 1, 1, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 6, 0, 6, 0, 6, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Servicio de limpieza en casa de familia', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 2, 2, 2, 2, 2, 3, 2, 2, 2, 1800, 2, 3, NULL, 6, 3, NULL, NULL, 2, 18, 1, 1800, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 390, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 390, NULL, 1, 2, NULL, NULL, NULL, NULL, NULL, 22, NULL, 1, 12, 2, 2, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, 'Isidro casanova', NULL, NULL, NULL, 2, 'Virrey del pino', NULL, NULL, 2, 2009, 1, 'Virrey del pino', NULL, NULL, 3, 1, 'osba', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL, 2, 3, NULL, 1, NULL, 2, NULL, NULL, NULL, 2, NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, NULL, 3, 1, 2, 2, 2011, 5, 1, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 1, 3, 3, 1, 1, 4, 2, 2, NULL, 2, NULL, 2, NULL, 2, NULL, 2, NULL, 2, NULL, 2, NULL, 1);

-----
select * from encu.plana_s1_ where pla_enc=995124
select * from encu.claves where cla_enc=995124
select * from encu.claves where cla_enc=695124 and cla_ope='pp2012'

