SET search_path TO encu, comun, public;

select * /*distinct pla_t24_cod*/ from encu.plana_i1_ where pla_t24_cod not in (select ocu_ocu from encu.ocupacion) order by pla_t24_cod;
--32414
--47114
--55114
--11 filas

select * /*distinct pla_t41_cod*/ from encu.plana_i1_ where pla_t41_cod not in (select ocu_ocu from encu.ocupacion) order by pla_t41_cod ;
--30114
--53114
--55114
--56114
--58114
--80114
--13 filas

select * /*distinct pla_t23_cod*/ from encu.plana_i1_ where pla_t23_cod not in (select ram_ram from encu.rama) order by pla_t23_cod;
--9101
--1 fila

select distinct pla_t37_cod from encu.plana_i1_ where pla_t37_cod not in (select ram_ram from encu.rama) order by pla_t37_cod;
--0 filas

ALTER TABLE encu.plana_i1_
  ADD CONSTRAINT "CODIGO DE OCUPACION NO VALIDO EN t24_cod" FOREIGN KEY (pla_t24_cod)
      REFERENCES encu.ocupacion (ocu_ocu);

ALTER TABLE encu.plana_i1_
  ADD CONSTRAINT "CODIGO DE OCUPACION NO VALIDO EN t41_cod" FOREIGN KEY (pla_t41_cod)
      REFERENCES encu.ocupacion (ocu_ocu);

ALTER TABLE encu.plana_i1_
  ADD CONSTRAINT "CODIGO DE RAMA NO VALIDO EN t23_cod" FOREIGN KEY (pla_t23_cod)
      REFERENCES encu.rama (ram_ram);

ALTER TABLE encu.plana_i1_
  ADD CONSTRAINT "CODIGO DE RAMA NO VALIDO EN t37_cod" FOREIGN KEY (pla_t37_cod)
      REFERENCES encu.rama (ram_ram);

		UPDATE encu.plana_i1_ SET pla_t37_cod = 5300 WHERE pla_enc = 900004 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 35314 WHERE pla_enc = 900004 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900006 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900006 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 900006 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 900006 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900007 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 900007 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900011 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 900011 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2500 WHERE pla_enc = 900011 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80132 WHERE pla_enc = 900011 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5202 WHERE pla_enc = 900012 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36114 WHERE pla_enc = 900012 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900012 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900012 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900012 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900012 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900014 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 900014 and pla_hog = 1 and pla_mie = 1;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 900016 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 900016 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 900016 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34323 WHERE pla_enc = 900016 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4807 WHERE pla_enc = 900016 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 900016 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5201 WHERE pla_enc = 900017 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34323 WHERE pla_enc = 900017 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 900021 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41312 WHERE pla_enc = 900021 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900024 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900024 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900026 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900026 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900026 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900026 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 900026 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34113 WHERE pla_enc = 900026 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900026 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900026 and pla_hog = 1 and pla_mie = 4;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900028 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 900028 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 900034 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 900034 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900035 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900035 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900035 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 900035 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 900039 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900039 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900039 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 900039 and pla_hog = 1 and pla_mie = 2;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4502 WHERE pla_enc = 900039 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 900039 and pla_hog = 1 and pla_mie = 6;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900041 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900041 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900045 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 900045 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 900046 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900046 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4807 WHERE pla_enc = 900046 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900046 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4810 WHERE pla_enc = 900046 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 36314 WHERE pla_enc = 900046 and pla_hog = 1 and pla_mie = 3;		
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 900047 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82313 WHERE pla_enc = 900047 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900050 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900050 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 900050 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72113 WHERE pla_enc = 900050 and pla_hog = 1 and pla_mie = 2;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900051 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900051 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 8000 WHERE pla_enc = 900051 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 47114 WHERE pla_enc = 900051 and pla_hog = 1 and pla_mie = 3;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900052 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900052 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 900052 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900052 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4502 WHERE pla_enc = 900052 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82312 WHERE pla_enc = 900052 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 8600 WHERE pla_enc = 900054 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 40314 WHERE pla_enc = 900054 and pla_hog = 1 and pla_mie = 1;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9302 WHERE pla_enc = 900057 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 900057 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9302 WHERE pla_enc = 900057 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 900057 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900058 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900058 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4502 WHERE pla_enc = 900059 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 20313 WHERE pla_enc = 900059 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900060 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53203 WHERE pla_enc = 900060 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900060 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 900060 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4502 WHERE pla_enc = 900061 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900061 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900061 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900061 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 900065 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 900065 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4807 WHERE pla_enc = 900065 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 900065 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 900066 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34113 WHERE pla_enc = 900066 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9602 WHERE pla_enc = 900066 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 57113 WHERE pla_enc = 900066 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900067 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900067 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900069 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900069 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6900 WHERE pla_enc = 900075 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 11131 WHERE pla_enc = 900075 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900076 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900076 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900076 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36314 WHERE pla_enc = 900076 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 900077 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56313 WHERE pla_enc = 900077 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900077 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 900077 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2009 WHERE pla_enc = 900080 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 47314 WHERE pla_enc = 900080 and pla_hog = 1 and pla_mie = 1;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 900081 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53314 WHERE pla_enc = 900081 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900081 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10332 WHERE pla_enc = 900081 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900082 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900082 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900082 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 900082 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 900084 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72113 WHERE pla_enc = 900084 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900084 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900084 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 7701 WHERE pla_enc = 900084 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 81331 WHERE pla_enc = 900084 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900085 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900085 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900086 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900086 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9609 WHERE pla_enc = 900086 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56114 WHERE pla_enc = 900086 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 900087 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53312 WHERE pla_enc = 900087 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900088 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900088 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900088 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 900088 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 900089 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40331 WHERE pla_enc = 900089 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 900089 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900089 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900093 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 900093 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900093 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900093 and pla_hog = 1 and pla_mie = 2;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 900096 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 32314 WHERE pla_enc = 900096 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900100 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900100 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 900103 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 900103 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 900106 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 900106 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900107 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 900107 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900107 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900107 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9000 WHERE pla_enc = 900107 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 47314 WHERE pla_enc = 900107 and pla_hog = 1 and pla_mie = 3;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9302 WHERE pla_enc = 900107 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 52203 WHERE pla_enc = 900107 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9302 WHERE pla_enc = 900107 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 900107 and pla_hog = 1 and pla_mie = 5;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900110 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 900110 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900110 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900110 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900111 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53313 WHERE pla_enc = 900111 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900111 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 900111 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 900115 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40112 WHERE pla_enc = 900115 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 5300 WHERE pla_enc = 900115 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10333 WHERE pla_enc = 900115 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3200 WHERE pla_enc = 900116 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 900116 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900120 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900120 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 900121 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900121 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900121 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 900121 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900125 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900125 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900127 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10313 WHERE pla_enc = 900127 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900127 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 5002 WHERE pla_enc = 900127 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 900127 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41314 WHERE pla_enc = 900127 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900127 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10313 WHERE pla_enc = 900127 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900127 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900127 and pla_hog = 1 and pla_mie = 5;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2500 WHERE pla_enc = 900134 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 900134 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900134 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 900134 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 900134 and pla_hog = 1 and pla_mie = 7;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72113 WHERE pla_enc = 900134 and pla_hog = 1 and pla_mie = 7;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900134 and pla_hog = 1 and pla_mie = 8;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900134 and pla_hog = 1 and pla_mie = 8;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900135 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900135 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900136 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 900136 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5202 WHERE pla_enc = 900139 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900139 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900139 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900139 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900139 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900139 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900140 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900140 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 8101 WHERE pla_enc = 900140 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 900140 and pla_hog = 1 and pla_mie = 2;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 900140 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 32314 WHERE pla_enc = 900140 and pla_hog = 1 and pla_mie = 3;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9609 WHERE pla_enc = 900140 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 58313 WHERE pla_enc = 900140 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900141 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 5002 WHERE pla_enc = 900141 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900141 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 5002 WHERE pla_enc = 900141 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900145 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 900145 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900145 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 900145 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 900150 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 20323 WHERE pla_enc = 900150 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900151 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 900151 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2900 WHERE pla_enc = 900152 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30333 WHERE pla_enc = 900152 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900154 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 900154 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4807 WHERE pla_enc = 900157 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33113 WHERE pla_enc = 900157 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900164 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 900164 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900164 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 900164 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900165 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900165 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900166 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900166 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900166 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900166 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9602 WHERE pla_enc = 900166 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 57113 WHERE pla_enc = 900166 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900167 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900167 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900168 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900168 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4808 WHERE pla_enc = 900168 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 20323 WHERE pla_enc = 900168 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900170 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34123 WHERE pla_enc = 900170 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 900173 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900173 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 900173 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900173 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 900174 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900174 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 7702 WHERE pla_enc = 900174 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 36314 WHERE pla_enc = 900174 and pla_hog = 1 and pla_mie = 2;		
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900174 and pla_hog = 1 and pla_mie = 8;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900174 and pla_hog = 1 and pla_mie = 8;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 900176 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900176 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900176 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 900176 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900177 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900177 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900177 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 900177 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900178 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53113 WHERE pla_enc = 900178 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900178 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 900178 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 900178 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 900178 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900179 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 900179 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900180 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900180 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900180 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36314 WHERE pla_enc = 900180 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 900181 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 900181 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900184 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900184 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900185 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900185 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900185 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900185 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900186 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900186 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900186 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900186 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900187 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900187 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 900187 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 900187 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900187 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900187 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8102 WHERE pla_enc = 900188 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 58113 WHERE pla_enc = 900188 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9602 WHERE pla_enc = 900188 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 57113 WHERE pla_enc = 900188 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900191 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 900191 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900191 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53113 WHERE pla_enc = 900191 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900192 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900192 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8401 WHERE pla_enc = 900194 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 47313 WHERE pla_enc = 900194 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9501 WHERE pla_enc = 900194 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 81132 WHERE pla_enc = 900194 and pla_hog = 1 and pla_mie = 3;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900197 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900197 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900197 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10314 WHERE pla_enc = 900197 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900201 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 900201 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900201 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900201 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9501 WHERE pla_enc = 900201 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10314 WHERE pla_enc = 900201 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3100 WHERE pla_enc = 900205 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 900205 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 900205 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900205 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 7900 WHERE pla_enc = 900207 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900207 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9302 WHERE pla_enc = 900207 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 900207 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 900220 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900220 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900223 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900223 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900224 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 900224 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900226 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900226 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9602 WHERE pla_enc = 900226 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900226 and pla_hog = 1 and pla_mie = 3;
UPDATE encu.plana_i1_ SET pla_t23_cod = 3200 WHERE pla_enc = 900226 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80313 WHERE pla_enc = 900226 and pla_hog = 1 and pla_mie = 4;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900231 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900231 and pla_hog = 1 and pla_mie = 2;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 900232 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 900232 and pla_hog = 1 and pla_mie = 1;		
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 900233 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55114 WHERE pla_enc = 900233 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900235 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900235 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 900241 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 900241 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8502 WHERE pla_enc = 900241 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41132 WHERE pla_enc = 900241 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4806 WHERE pla_enc = 900241 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 32314 WHERE pla_enc = 900241 and pla_hog = 1 and pla_mie = 3;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4806 WHERE pla_enc = 900241 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30314 WHERE pla_enc = 900241 and pla_hog = 1 and pla_mie = 5;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900242 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900242 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5602 WHERE pla_enc = 900243 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900243 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5500 WHERE pla_enc = 900243 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56203 WHERE pla_enc = 900243 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900245 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900245 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900247 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900247 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900247 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 900247 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 900250 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56313 WHERE pla_enc = 900250 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 900250 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40113 WHERE pla_enc = 900250 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900251 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900251 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6900 WHERE pla_enc = 900252 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 900252 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 900254 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56313 WHERE pla_enc = 900254 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 900259 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 900259 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900260 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900260 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9602 WHERE pla_enc = 900263 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 57113 WHERE pla_enc = 900263 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900263 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 900263 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 900264 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56313 WHERE pla_enc = 900264 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900264 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34314 WHERE pla_enc = 900264 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 1400 WHERE pla_enc = 900264 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 900264 and pla_hog = 1 and pla_mie = 3;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2900 WHERE pla_enc = 900266 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900266 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900266 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900266 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5202 WHERE pla_enc = 900271 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 58203 WHERE pla_enc = 900271 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 900271 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 900271 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900272 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900272 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5800 WHERE pla_enc = 900272 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34323 WHERE pla_enc = 900272 and pla_hog = 1 and pla_mie = 2;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 900272 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53313 WHERE pla_enc = 900272 and pla_hog = 1 and pla_mie = 4;		
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 2500 WHERE pla_enc = 900273 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80333 WHERE pla_enc = 900273 and pla_hog = 1 and pla_mie = 1;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900274 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900274 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900274 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900274 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900275 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900275 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900278 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900278 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8502 WHERE pla_enc = 900280 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41112 WHERE pla_enc = 900280 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1800 WHERE pla_enc = 900280 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10314 WHERE pla_enc = 900280 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900284 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 900284 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 900286 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40312 WHERE pla_enc = 900286 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2309 WHERE pla_enc = 900286 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 900286 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900287 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 900287 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900289 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900289 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900289 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 900289 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4804 WHERE pla_enc = 900290 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10313 WHERE pla_enc = 900290 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900290 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 900290 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900290 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 900290 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 900464 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900464 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900466 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900466 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 900467 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53312 WHERE pla_enc = 900467 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900469 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900469 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900469 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900469 and pla_hog = 1 and pla_mie = 2;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 900471 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 900471 and pla_hog = 1 and pla_mie = 1;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 900471 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53313 WHERE pla_enc = 900471 and pla_hog = 1 and pla_mie = 2;		
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900473 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900473 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900473 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900473 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900474 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 900474 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 900477 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900477 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4903 WHERE pla_enc = 900477 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10123 WHERE pla_enc = 900477 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 900478 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900478 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4808 WHERE pla_enc = 900479 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53313 WHERE pla_enc = 900479 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4808 WHERE pla_enc = 900480 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 900480 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4805 WHERE pla_enc = 900480 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 900480 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900481 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900481 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5201 WHERE pla_enc = 900481 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36314 WHERE pla_enc = 900481 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 900483 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82123 WHERE pla_enc = 900483 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900484 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 900484 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900485 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 900485 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900485 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900485 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6400 WHERE pla_enc = 900485 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 20312 WHERE pla_enc = 900485 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900488 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900488 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900488 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 900488 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900489 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 900489 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900489 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 900489 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900490 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900490 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900490 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900490 and pla_hog = 1 and pla_mie = 4;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900490 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 900490 and pla_hog = 1 and pla_mie = 6;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900492 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900492 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900492 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 900492 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2309 WHERE pla_enc = 900492 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 900492 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900493 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 900493 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900493 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900493 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900496 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 900496 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900496 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 900496 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4502 WHERE pla_enc = 900497 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900497 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900499 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 900499 and pla_hog = 1 and pla_mie = 1;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4805 WHERE pla_enc = 900499 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 900499 and pla_hog = 1 and pla_mie = 4;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 900500 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900500 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900500 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900500 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 900503 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82123 WHERE pla_enc = 900503 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 900504 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900504 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 8502 WHERE pla_enc = 900504 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 41113 WHERE pla_enc = 900504 and pla_hog = 1 and pla_mie = 2;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900505 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 900505 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900505 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900505 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900506 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 900506 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 900506 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82123 WHERE pla_enc = 900506 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9000 WHERE pla_enc = 900506 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 50111 WHERE pla_enc = 900506 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900507 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 900507 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900507 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 900507 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900508 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900508 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900508 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 900508 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900509 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900509 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 900510 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 900510 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 900512 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82113 WHERE pla_enc = 900512 and pla_hog = 1 and pla_mie = 2;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 900513 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 900513 and pla_hog = 1 and pla_mie = 1;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 4804 WHERE pla_enc = 900513 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10333 WHERE pla_enc = 900513 and pla_hog = 1 and pla_mie = 2;		
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2500 WHERE pla_enc = 900514 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 900514 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900514 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900514 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4805 WHERE pla_enc = 900514 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 900514 and pla_hog = 1 and pla_mie = 4;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900516 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900516 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 900516 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72113 WHERE pla_enc = 900516 and pla_hog = 1 and pla_mie = 2;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 900518 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900518 and pla_hog = 1 and pla_mie = 1;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 1400 WHERE pla_enc = 900519 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80323 WHERE pla_enc = 900519 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900519 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 900519 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 900520 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40314 WHERE pla_enc = 900520 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900520 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900520 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 900520 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10332 WHERE pla_enc = 900520 and pla_hog = 1 and pla_mie = 4;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900521 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 900521 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900521 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 900521 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900522 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900522 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900528 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 900528 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900528 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900528 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900528 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900528 and pla_hog = 1 and pla_mie = 4;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900535 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900535 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900535 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900535 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 900538 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82112 WHERE pla_enc = 900538 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 900538 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82112 WHERE pla_enc = 900538 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900538 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900538 and pla_hog = 1 and pla_mie = 4;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 900540 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900540 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900541 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900541 and pla_hog = 1 and pla_mie = 5;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900542 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900542 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900543 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900543 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900543 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900543 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900543 and pla_hog = 1 and pla_mie = 7;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53113 WHERE pla_enc = 900543 and pla_hog = 1 and pla_mie = 7;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900544 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900544 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900544 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 900544 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6900 WHERE pla_enc = 900544 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10323 WHERE pla_enc = 900544 and pla_hog = 1 and pla_mie = 3;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 900545 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 900545 and pla_hog = 1 and pla_mie = 1;		
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900548 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 900548 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900548 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900548 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 900548 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 900548 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9609 WHERE pla_enc = 900550 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 58113 WHERE pla_enc = 900550 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 900550 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 900550 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900554 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900554 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900554 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900554 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900555 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 900555 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900558 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900558 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 900558 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900558 and pla_hog = 1 and pla_mie = 2;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 1400 WHERE pla_enc = 900558 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80323 WHERE pla_enc = 900558 and pla_hog = 1 and pla_mie = 4;		
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4901 WHERE pla_enc = 900559 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900559 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900561 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900561 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900562 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 900562 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5300 WHERE pla_enc = 900562 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 35314 WHERE pla_enc = 900562 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 900563 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 900563 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 7800 WHERE pla_enc = 900564 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900564 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9101 WHERE pla_enc = 900564 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 900564 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900564 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 900564 and pla_hog = 1 and pla_mie = 3;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 8502 WHERE pla_enc = 900564 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t24_cod = 41313 WHERE pla_enc = 900564 and pla_hog = 1 and pla_mie = 5;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 900564 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 900564 and pla_hog = 1 and pla_mie = 6;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900564 and pla_hog = 1 and pla_mie = 7;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 900564 and pla_hog = 1 and pla_mie = 7;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2800 WHERE pla_enc = 900566 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 900566 and pla_hog = 1 and pla_mie = 1;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4904 WHERE pla_enc = 900566 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t24_cod = 36324 WHERE pla_enc = 900566 and pla_hog = 1 and pla_mie = 5;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 104 WHERE pla_enc = 900566 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t24_cod = 62113 WHERE pla_enc = 900566 and pla_hog = 1 and pla_mie = 6;		
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900566 and pla_hog = 1 and pla_mie = 11;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 900566 and pla_hog = 1 and pla_mie = 11;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9301 WHERE pla_enc = 900566 and pla_hog = 1 and pla_mie = 14;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900566 and pla_hog = 1 and pla_mie = 14;
UPDATE encu.plana_i1_ SET pla_t23_cod = 8101 WHERE pla_enc = 900566 and pla_hog = 1 and pla_mie = 15;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 900566 and pla_hog = 1 and pla_mie = 15;		
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900567 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 900567 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 900569 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900569 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900569 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 900569 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900569 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 900569 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3900 WHERE pla_enc = 900569 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900569 and pla_hog = 1 and pla_mie = 4;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900571 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53113 WHERE pla_enc = 900571 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8000 WHERE pla_enc = 900571 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 47313 WHERE pla_enc = 900571 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900575 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80324 WHERE pla_enc = 900575 and pla_hog = 1 and pla_mie = 4;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 900575 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900575 and pla_hog = 1 and pla_mie = 6;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9609 WHERE pla_enc = 900576 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10314 WHERE pla_enc = 900576 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900577 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900577 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900578 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 900578 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4903 WHERE pla_enc = 900580 and pla_hog = 1 and pla_mie = 8;	UPDATE encu.plana_i1_ SET pla_t24_cod = 34123 WHERE pla_enc = 900580 and pla_hog = 1 and pla_mie = 8;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 900580 and pla_hog = 1 and pla_mie = 9;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72313 WHERE pla_enc = 900580 and pla_hog = 1 and pla_mie = 9;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900581 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900581 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900581 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 900581 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900586 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 900586 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900586 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900586 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2500 WHERE pla_enc = 900590 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 900590 and pla_hog = 1 and pla_mie = 3;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 900590 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72314 WHERE pla_enc = 900590 and pla_hog = 1 and pla_mie = 4;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900592 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900592 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900593 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900593 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3200 WHERE pla_enc = 900593 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 900593 and pla_hog = 1 and pla_mie = 2;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 900596 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72313 WHERE pla_enc = 900596 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9200 WHERE pla_enc = 900600 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 20333 WHERE pla_enc = 900600 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4903 WHERE pla_enc = 900600 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 34323 WHERE pla_enc = 900600 and pla_hog = 1 and pla_mie = 2;		
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 7301 WHERE pla_enc = 900606 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 900606 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900612 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 900612 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900612 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900612 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1800 WHERE pla_enc = 900613 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 900613 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900613 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900613 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900615 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900615 and pla_hog = 1 and pla_mie = 1;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4803 WHERE pla_enc = 900615 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 36314 WHERE pla_enc = 900615 and pla_hog = 1 and pla_mie = 4;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900616 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900616 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 900616 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34314 WHERE pla_enc = 900616 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 900618 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 900618 and pla_hog = 1 and pla_mie = 1;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900618 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 900618 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 900829 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 900829 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 900830 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34123 WHERE pla_enc = 900830 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900831 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 900831 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 8600 WHERE pla_enc = 900837 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 40112 WHERE pla_enc = 900837 and pla_hog = 1 and pla_mie = 1;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900837 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900837 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900838 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900838 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900840 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900840 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900841 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900841 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900845 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900845 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 900845 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72113 WHERE pla_enc = 900845 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900845 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900845 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
			
			
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4804 WHERE pla_enc = 900848 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10113 WHERE pla_enc = 900848 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900850 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900850 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 900850 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53314 WHERE pla_enc = 900850 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900851 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900851 and pla_hog = 1 and pla_mie = 1;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 1400 WHERE pla_enc = 900852 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80323 WHERE pla_enc = 900852 and pla_hog = 1 and pla_mie = 1;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900853 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900853 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900854 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 900854 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900856 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 900856 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4805 WHERE pla_enc = 900858 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33113 WHERE pla_enc = 900858 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900859 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 900859 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900861 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900861 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900864 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 900864 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900864 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 900864 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900866 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 900866 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900866 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 900866 and pla_hog = 1 and pla_mie = 2;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 8401 WHERE pla_enc = 900867 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 900867 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900868 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 900868 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2500 WHERE pla_enc = 900868 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 900868 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900868 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 900868 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900869 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53113 WHERE pla_enc = 900869 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 7702 WHERE pla_enc = 900869 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 900869 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 7702 WHERE pla_enc = 900869 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32333 WHERE pla_enc = 900869 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900870 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 900870 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6400 WHERE pla_enc = 900872 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 20323 WHERE pla_enc = 900872 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8200 WHERE pla_enc = 900872 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 900872 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2009 WHERE pla_enc = 900878 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 900878 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4805 WHERE pla_enc = 900884 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10323 WHERE pla_enc = 900884 and pla_hog = 1 and pla_mie = 1;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900886 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30114 WHERE pla_enc = 900886 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900887 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900887 and pla_hog = 1 and pla_mie = 2;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 900888 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 900888 and pla_hog = 1 and pla_mie = 2;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900890 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900890 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900893 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 900893 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900896 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900896 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900899 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900899 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6800 WHERE pla_enc = 900900 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 900900 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9601 WHERE pla_enc = 900901 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56313 WHERE pla_enc = 900901 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900901 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900901 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900903 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900903 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900904 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 900904 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900904 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 900904 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900905 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900905 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900905 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 900905 and pla_hog = 1 and pla_mie = 2;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4804 WHERE pla_enc = 900907 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10313 WHERE pla_enc = 900907 and pla_hog = 1 and pla_mie = 1;		
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900911 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900911 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900915 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900915 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4502 WHERE pla_enc = 900920 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82313 WHERE pla_enc = 900920 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900923 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900923 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900928 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30133 WHERE pla_enc = 900928 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900930 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32323 WHERE pla_enc = 900930 and pla_hog = 1 and pla_mie = 1;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 900931 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 32323 WHERE pla_enc = 900931 and pla_hog = 1 and pla_mie = 1;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900932 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900932 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900935 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900935 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900935 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 900935 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900936 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 900936 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900937 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 900937 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900937 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 900937 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9000 WHERE pla_enc = 900937 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36314 WHERE pla_enc = 900937 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900939 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 900939 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900942 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900942 and pla_hog = 1 and pla_mie = 1;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4502 WHERE pla_enc = 900943 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 82113 WHERE pla_enc = 900943 and pla_hog = 1 and pla_mie = 1;		
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 8101 WHERE pla_enc = 900945 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 20333 WHERE pla_enc = 900945 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900946 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900946 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900949 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900949 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 900952 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 900952 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 900958 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 900958 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 900961 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 900961 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 900965 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 900965 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 900968 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900968 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900970 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900970 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5300 WHERE pla_enc = 900970 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 35123 WHERE pla_enc = 900970 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900971 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900971 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9609 WHERE pla_enc = 900971 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 58113 WHERE pla_enc = 900971 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900975 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 900975 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4904 WHERE pla_enc = 900975 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34323 WHERE pla_enc = 900975 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 3200 WHERE pla_enc = 900975 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80314 WHERE pla_enc = 900975 and pla_hog = 1 and pla_mie = 3;		
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900976 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 900976 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 900976 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 900976 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9302 WHERE pla_enc = 900976 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 52313 WHERE pla_enc = 900976 and pla_hog = 1 and pla_mie = 3;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900977 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900977 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 900978 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 900978 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5602 WHERE pla_enc = 900978 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 900978 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5602 WHERE pla_enc = 900978 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30314 WHERE pla_enc = 900978 and pla_hog = 1 and pla_mie = 3;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 900978 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72314 WHERE pla_enc = 900978 and pla_hog = 1 and pla_mie = 4;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 900979 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 900979 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 900979 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 32323 WHERE pla_enc = 900979 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900980 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900980 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 900980 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72314 WHERE pla_enc = 900980 and pla_hog = 1 and pla_mie = 2;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 8700 WHERE pla_enc = 900980 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 52313 WHERE pla_enc = 900980 and pla_hog = 1 and pla_mie = 3;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 900983 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 900983 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 901166 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 901166 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 901166 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 901166 and pla_hog = 1 and pla_mie = 5;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 901168 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 901168 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 901171 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 901171 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 901172 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 901172 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 901173 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 901173 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 901174 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 901174 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 901176 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 901176 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 901176 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 901176 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 901176 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82313 WHERE pla_enc = 901176 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 901180 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 901180 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 901180 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 901180 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 901181 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 901181 and pla_hog = 1 and pla_mie = 1;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 901184 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 901184 and pla_hog = 1 and pla_mie = 1;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 901185 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 901185 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 901185 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 901185 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 901186 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 901186 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 901187 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 901187 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 901187 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 901187 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 901189 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 901189 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 901189 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 901189 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 901190 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 901190 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 901190 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 901190 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 901194 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 901194 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 901194 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 901194 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 901194 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 5002 WHERE pla_enc = 901194 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 901197 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 901197 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 901197 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 901197 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 901198 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 901198 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 901201 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 901201 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 901205 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 901205 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 901205 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 901205 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 901208 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 901208 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 901213 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 901213 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 901214 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 901214 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 901215 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 901215 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 901215 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 901215 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 901216 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 901216 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 901218 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 901218 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 901219 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 901219 and pla_hog = 1 and pla_mie = 2;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 901220 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 901220 and pla_hog = 1 and pla_mie = 1;		
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 901222 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 901222 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 901222 and pla_hog = 1 and pla_mie = 7;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 901222 and pla_hog = 1 and pla_mie = 7;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 901223 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 901223 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 901223 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 901223 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 901224 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 901224 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 901227 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 901227 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 901227 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 901227 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 901227 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 901227 and pla_hog = 1 and pla_mie = 5;
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 901233 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 901233 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 901233 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 901233 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 901234 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 901234 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9502 WHERE pla_enc = 901236 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10314 WHERE pla_enc = 901236 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 901237 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 901237 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 901240 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53313 WHERE pla_enc = 901240 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8200 WHERE pla_enc = 901240 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10323 WHERE pla_enc = 901240 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 901241 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 901241 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 901243 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 901243 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 901248 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 901248 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 901248 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 901248 and pla_hog = 1 and pla_mie = 2;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3200 WHERE pla_enc = 901249 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 901249 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 901255 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 901255 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 901255 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 901255 and pla_hog = 1 and pla_mie = 2;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 901255 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53314 WHERE pla_enc = 901255 and pla_hog = 1 and pla_mie = 5;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 901256 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 901256 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 901258 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 901258 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 901258 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 901258 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 901262 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 901262 and pla_hog = 1 and pla_mie = 1;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 901263 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 901263 and pla_hog = 1 and pla_mie = 1;		
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 901264 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 901264 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 901264 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 901264 and pla_hog = 1 and pla_mie = 2;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4903 WHERE pla_enc = 901266 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 34323 WHERE pla_enc = 901266 and pla_hog = 1 and pla_mie = 1;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 901267 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 901267 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 901267 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 901267 and pla_hog = 1 and pla_mie = 5;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 901269 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 901269 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 901269 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 901269 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 901271 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 901271 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 910007 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 910007 and pla_hog = 1 and pla_mie = 2;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 910007 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 32323 WHERE pla_enc = 910007 and pla_hog = 1 and pla_mie = 4;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910014 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910014 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 910014 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53312 WHERE pla_enc = 910014 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 910014 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 910014 and pla_hog = 1 and pla_mie = 3;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 910015 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 910015 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 910015 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 910015 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 910026 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 910026 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 910028 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 99999 WHERE pla_enc = 910028 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2500 WHERE pla_enc = 910029 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 910029 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4804 WHERE pla_enc = 910035 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10113 WHERE pla_enc = 910035 and pla_hog = 1 and pla_mie = 1;		
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 910038 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72313 WHERE pla_enc = 910038 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 910038 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 910038 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 910043 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 910043 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4808 WHERE pla_enc = 910043 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 20313 WHERE pla_enc = 910043 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 910046 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 910046 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3200 WHERE pla_enc = 910047 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 910047 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 910050 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 910050 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3200 WHERE pla_enc = 910050 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 910050 and pla_hog = 1 and pla_mie = 3;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 910051 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 910051 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910051 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 910051 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5602 WHERE pla_enc = 910056 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 910056 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 910059 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30314 WHERE pla_enc = 910059 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910061 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910061 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 7702 WHERE pla_enc = 910061 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 910061 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5202 WHERE pla_enc = 910062 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36314 WHERE pla_enc = 910062 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9602 WHERE pla_enc = 910063 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 57313 WHERE pla_enc = 910063 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8200 WHERE pla_enc = 910063 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 910063 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 910065 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 910065 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 910065 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10313 WHERE pla_enc = 910065 and pla_hog = 1 and pla_mie = 2;		
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910068 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910068 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910075 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910075 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910075 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 910075 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 1400 WHERE pla_enc = 910075 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80314 WHERE pla_enc = 910075 and pla_hog = 1 and pla_mie = 3;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6100 WHERE pla_enc = 910077 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 35113 WHERE pla_enc = 910077 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6000 WHERE pla_enc = 910077 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 45332 WHERE pla_enc = 910077 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 910080 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 910080 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8000 WHERE pla_enc = 910089 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 47313 WHERE pla_enc = 910089 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 910091 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56313 WHERE pla_enc = 910091 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910093 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910093 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910104 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910104 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5202 WHERE pla_enc = 910108 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 910108 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4803 WHERE pla_enc = 910108 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 30313 WHERE pla_enc = 910108 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910110 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910110 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5500 WHERE pla_enc = 910110 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 910110 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910112 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910112 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 910112 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82112 WHERE pla_enc = 910112 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910112 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910112 and pla_hog = 1 and pla_mie = 5;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6800 WHERE pla_enc = 910121 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30332 WHERE pla_enc = 910121 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910121 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 910121 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 910121 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72113 WHERE pla_enc = 910121 and pla_hog = 1 and pla_mie = 3;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 4803 WHERE pla_enc = 910121 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 34323 WHERE pla_enc = 910121 and pla_hog = 1 and pla_mie = 4;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910126 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910126 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910129 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910129 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910129 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910129 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 910129 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41312 WHERE pla_enc = 910129 and pla_hog = 1 and pla_mie = 5;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910129 and pla_hog = 1 and pla_mie = 7;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 910129 and pla_hog = 1 and pla_mie = 7;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910130 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910130 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910132 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910132 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 910132 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36314 WHERE pla_enc = 910132 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910138 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910138 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910138 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 910138 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 910142 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 910142 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 910142 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 910142 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910147 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 910147 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910147 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910147 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910157 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910157 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910159 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910159 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 910159 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53314 WHERE pla_enc = 910159 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 910159 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 910159 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910159 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 910159 and pla_hog = 1 and pla_mie = 4;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910160 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910160 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 910167 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34313 WHERE pla_enc = 910167 and pla_hog = 1 and pla_mie = 2;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 1400 WHERE pla_enc = 910170 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80323 WHERE pla_enc = 910170 and pla_hog = 1 and pla_mie = 1;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910170 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910170 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910171 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910171 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910171 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 910171 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910172 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910172 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910172 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 910172 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2201 WHERE pla_enc = 910172 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 910172 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3100 WHERE pla_enc = 910172 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 910172 and pla_hog = 1 and pla_mie = 4;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 910185 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 57113 WHERE pla_enc = 910185 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 910185 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53113 WHERE pla_enc = 910185 and pla_hog = 1 and pla_mie = 4;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 910198 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 910198 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910198 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 910198 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9302 WHERE pla_enc = 910200 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10323 WHERE pla_enc = 910200 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 910201 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56313 WHERE pla_enc = 910201 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 910201 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53314 WHERE pla_enc = 910201 and pla_hog = 1 and pla_mie = 2;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9601 WHERE pla_enc = 910203 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56313 WHERE pla_enc = 910203 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 910203 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82112 WHERE pla_enc = 910203 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910206 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910206 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1502 WHERE pla_enc = 910210 and pla_hog = 1 and pla_mie = 7;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910210 and pla_hog = 1 and pla_mie = 7;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9409 WHERE pla_enc = 910211 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 910211 and pla_hog = 1 and pla_mie = 1;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910303 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910303 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 910304 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 910304 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910319 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910319 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910322 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910322 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 910322 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53312 WHERE pla_enc = 910322 and pla_hog = 1 and pla_mie = 2;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 910322 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 910322 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 910329 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34113 WHERE pla_enc = 910329 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 910330 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 910330 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910331 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910331 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4502 WHERE pla_enc = 910331 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 910331 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2002 WHERE pla_enc = 910335 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 910335 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2100 WHERE pla_enc = 910335 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 910335 and pla_hog = 1 and pla_mie = 2;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4803 WHERE pla_enc = 910338 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 30313 WHERE pla_enc = 910338 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910340 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910340 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910342 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910342 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910342 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 910342 and pla_hog = 1 and pla_mie = 2;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 910345 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72113 WHERE pla_enc = 910345 and pla_hog = 1 and pla_mie = 1;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 910345 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55114 WHERE pla_enc = 910345 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8200 WHERE pla_enc = 910345 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 910345 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910346 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910346 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910347 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 910347 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 910349 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53313 WHERE pla_enc = 910349 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910352 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910352 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 910354 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 910354 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910354 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 910354 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910360 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910360 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4808 WHERE pla_enc = 910360 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 32314 WHERE pla_enc = 910360 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910362 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910362 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910364 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910364 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4808 WHERE pla_enc = 910364 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36114 WHERE pla_enc = 910364 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 910364 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 910364 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910370 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910370 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910370 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80123 WHERE pla_enc = 910370 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910371 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910371 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910374 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910374 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4808 WHERE pla_enc = 910374 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 20323 WHERE pla_enc = 910374 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9301 WHERE pla_enc = 910374 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 51312 WHERE pla_enc = 910374 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910379 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910379 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910379 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 910379 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910383 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910383 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1502 WHERE pla_enc = 910383 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910383 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910386 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 910386 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 910394 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 910394 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 910394 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 910394 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3100 WHERE pla_enc = 910394 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 910394 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8502 WHERE pla_enc = 910397 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41112 WHERE pla_enc = 910397 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2500 WHERE pla_enc = 910397 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 910397 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 910402 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 910402 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910403 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910403 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910407 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910407 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910407 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910407 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910408 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 910408 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2604 WHERE pla_enc = 910408 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 910408 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 910410 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 910410 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910410 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910410 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 910413 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40312 WHERE pla_enc = 910413 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5500 WHERE pla_enc = 910413 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 54202 WHERE pla_enc = 910413 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910415 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910415 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910415 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910415 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2009 WHERE pla_enc = 910418 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34323 WHERE pla_enc = 910418 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910418 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910418 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910420 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 910420 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910420 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910420 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 910425 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 910425 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910426 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910426 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910427 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910427 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910432 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910432 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910432 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 910432 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910434 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910434 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 910436 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 910436 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8000 WHERE pla_enc = 910436 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 47313 WHERE pla_enc = 910436 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2001 WHERE pla_enc = 910436 and pla_hog = 1 and pla_mie = 9;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 910436 and pla_hog = 1 and pla_mie = 9;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910445 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 910445 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 910446 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34323 WHERE pla_enc = 910446 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 910446 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 910446 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 910447 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 910447 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910452 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910452 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 8101 WHERE pla_enc = 910452 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 910452 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1600 WHERE pla_enc = 910453 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 910453 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910454 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910454 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910455 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910455 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910455 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 910455 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2500 WHERE pla_enc = 910456 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 910456 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 910462 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 910462 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910464 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910464 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910464 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 910464 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910467 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910467 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 910468 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 910468 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 910468 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 910468 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910471 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910471 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 910471 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53314 WHERE pla_enc = 910471 and pla_hog = 1 and pla_mie = 2;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 910474 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 910474 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 910474 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 910474 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910475 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910475 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 910482 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40314 WHERE pla_enc = 910482 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 910482 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 910482 and pla_hog = 1 and pla_mie = 2;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9602 WHERE pla_enc = 910483 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 57313 WHERE pla_enc = 910483 and pla_hog = 1 and pla_mie = 1;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2604 WHERE pla_enc = 910483 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 910483 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 910484 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 910484 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 910484 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 910484 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 910490 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 910490 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 910490 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 910490 and pla_hog = 1 and pla_mie = 4;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910495 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910495 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910500 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910500 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910500 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 910500 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910500 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910500 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910505 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910505 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 910505 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30314 WHERE pla_enc = 910505 and pla_hog = 1 and pla_mie = 3;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 910506 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 910506 and pla_hog = 1 and pla_mie = 2;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 910508 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 910508 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910511 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910511 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910512 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 910512 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910518 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910518 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 910518 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 910518 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910524 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 910524 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910525 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910525 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910527 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 910527 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910527 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910527 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910530 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910530 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910532 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910532 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 910532 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34323 WHERE pla_enc = 910532 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910532 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 910532 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 910533 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 910533 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910533 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 910533 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 910533 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53313 WHERE pla_enc = 910533 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910533 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910533 and pla_hog = 1 and pla_mie = 5;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910533 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910533 and pla_hog = 1 and pla_mie = 6;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910537 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910537 and pla_hog = 1 and pla_mie = 1;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4803 WHERE pla_enc = 910538 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53313 WHERE pla_enc = 910538 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910538 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 910538 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1502 WHERE pla_enc = 910538 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910538 and pla_hog = 1 and pla_mie = 4;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910540 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910540 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 910540 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 910540 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 910547 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36314 WHERE pla_enc = 910547 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 910547 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 910547 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 910551 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 910551 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 910551 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 910551 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910558 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910558 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910559 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910559 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6900 WHERE pla_enc = 910560 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 910560 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910562 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910562 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910563 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 910563 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910563 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910563 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 910566 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34323 WHERE pla_enc = 910566 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910567 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910567 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 910567 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 910567 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910576 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910576 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910579 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910579 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9601 WHERE pla_enc = 910581 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56313 WHERE pla_enc = 910581 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 910581 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 910581 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910586 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 910586 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910586 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 910586 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910589 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 910589 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 910590 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41314 WHERE pla_enc = 910590 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4504 WHERE pla_enc = 910590 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82113 WHERE pla_enc = 910590 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 910590 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 910590 and pla_hog = 1 and pla_mie = 3;		
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 910599 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40313 WHERE pla_enc = 910599 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 910599 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40313 WHERE pla_enc = 910599 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9602 WHERE pla_enc = 910604 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 57113 WHERE pla_enc = 910604 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9409 WHERE pla_enc = 910607 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56313 WHERE pla_enc = 910607 and pla_hog = 1 and pla_mie = 1;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910612 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910612 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 910613 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 910613 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4904 WHERE pla_enc = 910621 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36313 WHERE pla_enc = 910621 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 1009 WHERE pla_enc = 910621 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53314 WHERE pla_enc = 910621 and pla_hog = 1 and pla_mie = 3;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 910622 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 910622 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910622 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910622 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 910624 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 910624 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9601 WHERE pla_enc = 910628 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56313 WHERE pla_enc = 910628 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910637 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910637 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 910637 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 910637 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910638 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910638 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910652 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 910652 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910655 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910655 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910655 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 910655 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910657 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910657 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910657 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910657 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 910658 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10313 WHERE pla_enc = 910658 and pla_hog = 1 and pla_mie = 1;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 5202 WHERE pla_enc = 910659 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 36314 WHERE pla_enc = 910659 and pla_hog = 1 and pla_mie = 2;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 910659 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55114 WHERE pla_enc = 910659 and pla_hog = 1 and pla_mie = 3;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910660 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910660 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910667 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910667 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910667 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910667 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 910667 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40312 WHERE pla_enc = 910667 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 910670 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 910670 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 910670 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82323 WHERE pla_enc = 910670 and pla_hog = 1 and pla_mie = 6;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910673 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910673 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 910673 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 910673 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910674 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910674 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 910674 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82112 WHERE pla_enc = 910674 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2202 WHERE pla_enc = 910674 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 910674 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910674 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910674 and pla_hog = 1 and pla_mie = 5;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910675 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 910675 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910679 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 910679 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 910681 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 910681 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 910681 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82113 WHERE pla_enc = 910681 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910683 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910683 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910683 and pla_hog = 1 and pla_mie = 8;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 910683 and pla_hog = 1 and pla_mie = 8;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 910684 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53113 WHERE pla_enc = 910684 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 910684 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53113 WHERE pla_enc = 910684 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2900 WHERE pla_enc = 910715 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 910715 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8401 WHERE pla_enc = 910715 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 910715 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 910719 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 910719 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 910719 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40313 WHERE pla_enc = 910719 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 910719 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40312 WHERE pla_enc = 910719 and pla_hog = 1 and pla_mie = 4;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910726 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910726 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 910726 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 910726 and pla_hog = 1 and pla_mie = 2;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 7400 WHERE pla_enc = 910732 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10333 WHERE pla_enc = 910732 and pla_hog = 1 and pla_mie = 1;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910735 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910735 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1700 WHERE pla_enc = 910735 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 910735 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 910739 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 910739 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910739 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 910739 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910741 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55114 WHERE pla_enc = 910741 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910748 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910748 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910749 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910749 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910754 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910754 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910758 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910758 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910758 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 910758 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910758 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 910758 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910770 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910770 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 101 WHERE pla_enc = 910770 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 910770 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910770 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910770 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910774 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910774 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 7800 WHERE pla_enc = 910774 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 910774 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910774 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 910774 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910776 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910776 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 910777 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 910777 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910777 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910777 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 910777 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 910777 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2202 WHERE pla_enc = 910781 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 910781 and pla_hog = 1 and pla_mie = 2;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 910781 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53313 WHERE pla_enc = 910781 and pla_hog = 1 and pla_mie = 4;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910790 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910790 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9501 WHERE pla_enc = 910790 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 81132 WHERE pla_enc = 910790 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910793 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910793 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 910797 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 910797 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 911001 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 911001 and pla_hog = 1 and pla_mie = 3;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911014 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911014 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 911026 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 911026 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 911058 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53313 WHERE pla_enc = 911058 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 911067 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34323 WHERE pla_enc = 911067 and pla_hog = 1 and pla_mie = 2;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 8600 WHERE pla_enc = 911078 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 911078 and pla_hog = 1 and pla_mie = 2;		
			
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 6900 WHERE pla_enc = 911084 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 32314 WHERE pla_enc = 911084 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911089 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911089 and pla_hog = 1 and pla_mie = 1;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 8600 WHERE pla_enc = 911101 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 40113 WHERE pla_enc = 911101 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 7702 WHERE pla_enc = 911101 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 911101 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 911105 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 911105 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911119 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911119 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9301 WHERE pla_enc = 911119 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 51313 WHERE pla_enc = 911119 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 7900 WHERE pla_enc = 911119 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30333 WHERE pla_enc = 911119 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 911133 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 911133 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 911133 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 911133 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2500 WHERE pla_enc = 911135 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 911135 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911135 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911135 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911146 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911146 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4805 WHERE pla_enc = 911146 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 20203 WHERE pla_enc = 911146 and pla_hog = 1 and pla_mie = 3;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 911146 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 911146 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4805 WHERE pla_enc = 911146 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 911146 and pla_hog = 1 and pla_mie = 5;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 911147 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 911147 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 911148 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 911148 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911154 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911154 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 911157 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53114 WHERE pla_enc = 911157 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 911157 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53114 WHERE pla_enc = 911157 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3200 WHERE pla_enc = 911165 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 911165 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 911165 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10323 WHERE pla_enc = 911165 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 911165 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 911165 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911169 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911169 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911169 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 911169 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3200 WHERE pla_enc = 911185 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 911185 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 911187 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40314 WHERE pla_enc = 911187 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9501 WHERE pla_enc = 911187 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 81332 WHERE pla_enc = 911187 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4502 WHERE pla_enc = 911187 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82313 WHERE pla_enc = 911187 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 911190 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 911190 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 911190 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 911190 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8000 WHERE pla_enc = 911190 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 47313 WHERE pla_enc = 911190 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8401 WHERE pla_enc = 911190 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 49314 WHERE pla_enc = 911190 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9501 WHERE pla_enc = 911190 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 81132 WHERE pla_enc = 911190 and pla_hog = 1 and pla_mie = 5;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 911195 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 911195 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 911195 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 911195 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911195 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 911195 and pla_hog = 1 and pla_mie = 5;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 911205 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 911205 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4805 WHERE pla_enc = 911205 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 32314 WHERE pla_enc = 911205 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2202 WHERE pla_enc = 911207 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 911207 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911207 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911207 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8000 WHERE pla_enc = 911213 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 47313 WHERE pla_enc = 911213 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 911213 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 911213 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 911214 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 911214 and pla_hog = 1 and pla_mie = 1;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 911218 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72113 WHERE pla_enc = 911218 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911218 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911218 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 911218 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72313 WHERE pla_enc = 911218 and pla_hog = 1 and pla_mie = 3;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 911218 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 911218 and pla_hog = 1 and pla_mie = 4;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 911225 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 911225 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911234 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911234 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4803 WHERE pla_enc = 911234 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 20323 WHERE pla_enc = 911234 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 911234 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 911234 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911247 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911247 and pla_hog = 1 and pla_mie = 4;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911247 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 911247 and pla_hog = 1 and pla_mie = 6;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911253 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911253 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911253 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911253 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911258 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911258 and pla_hog = 1 and pla_mie = 1;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9601 WHERE pla_enc = 911265 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80123 WHERE pla_enc = 911265 and pla_hog = 1 and pla_mie = 1;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 5202 WHERE pla_enc = 911265 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10314 WHERE pla_enc = 911265 and pla_hog = 1 and pla_mie = 2;		
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 911276 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 911276 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911281 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 911281 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911281 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 911281 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4904 WHERE pla_enc = 911286 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36314 WHERE pla_enc = 911286 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911289 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911289 and pla_hog = 1 and pla_mie = 1;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9502 WHERE pla_enc = 911289 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 81132 WHERE pla_enc = 911289 and pla_hog = 1 and pla_mie = 3;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 911302 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 911302 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911311 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911311 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4808 WHERE pla_enc = 911321 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10314 WHERE pla_enc = 911321 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4808 WHERE pla_enc = 911321 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 20323 WHERE pla_enc = 911321 and pla_hog = 1 and pla_mie = 4;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6800 WHERE pla_enc = 911324 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 911324 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911328 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911328 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911332 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 911332 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9602 WHERE pla_enc = 911333 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 57113 WHERE pla_enc = 911333 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 8200 WHERE pla_enc = 911333 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10333 WHERE pla_enc = 911333 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911337 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 911337 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 911337 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72314 WHERE pla_enc = 911337 and pla_hog = 1 and pla_mie = 3;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8401 WHERE pla_enc = 911352 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10313 WHERE pla_enc = 911352 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911352 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 911352 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2800 WHERE pla_enc = 911352 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 911352 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911355 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 911355 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 911355 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 911355 and pla_hog = 1 and pla_mie = 5;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 911355 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 911355 and pla_hog = 1 and pla_mie = 6;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911362 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911362 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 911362 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 911362 and pla_hog = 1 and pla_mie = 6;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8000 WHERE pla_enc = 911387 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 47313 WHERE pla_enc = 911387 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9503 WHERE pla_enc = 911387 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80123 WHERE pla_enc = 911387 and pla_hog = 1 and pla_mie = 2;		
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 911392 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53313 WHERE pla_enc = 911392 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8401 WHERE pla_enc = 911396 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 43331 WHERE pla_enc = 911396 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911426 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911426 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911426 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 911426 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911429 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911429 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 911429 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 911429 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 911432 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 911432 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 911442 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 911442 and pla_hog = 1 and pla_mie = 1;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9409 WHERE pla_enc = 911452 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 911452 and pla_hog = 1 and pla_mie = 1;		
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3200 WHERE pla_enc = 911464 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 911464 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5500 WHERE pla_enc = 911465 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56203 WHERE pla_enc = 911465 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911465 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911465 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9501 WHERE pla_enc = 911465 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 81132 WHERE pla_enc = 911465 and pla_hog = 1 and pla_mie = 3;
UPDATE encu.plana_i1_ SET pla_t23_cod = 1400 WHERE pla_enc = 911465 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10314 WHERE pla_enc = 911465 and pla_hog = 1 and pla_mie = 4;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 911468 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 911468 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911468 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911468 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911471 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 911471 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911471 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911471 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911472 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911472 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911473 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911473 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 911479 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53312 WHERE pla_enc = 911479 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911479 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 911479 and pla_hog = 1 and pla_mie = 2;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 911479 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 911479 and pla_hog = 1 and pla_mie = 5;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911480 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911480 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 911480 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 911480 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 911480 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 911480 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 911480 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82313 WHERE pla_enc = 911480 and pla_hog = 1 and pla_mie = 4;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 911481 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 911481 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 911485 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 911485 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911486 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911486 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9301 WHERE pla_enc = 911486 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 911486 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911497 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 911497 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 911497 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40312 WHERE pla_enc = 911497 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911498 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911498 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 911501 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30314 WHERE pla_enc = 911501 and pla_hog = 1 and pla_mie = 1;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 911505 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 911505 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 911505 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41313 WHERE pla_enc = 911505 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 911505 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 20333 WHERE pla_enc = 911505 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 911508 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 911508 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 911508 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80114 WHERE pla_enc = 911508 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 911508 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40312 WHERE pla_enc = 911508 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4502 WHERE pla_enc = 911508 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82313 WHERE pla_enc = 911508 and pla_hog = 1 and pla_mie = 5;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4502 WHERE pla_enc = 911508 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82313 WHERE pla_enc = 911508 and pla_hog = 1 and pla_mie = 6;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4808 WHERE pla_enc = 911508 and pla_hog = 1 and pla_mie = 8;	UPDATE encu.plana_i1_ SET pla_t24_cod = 32314 WHERE pla_enc = 911508 and pla_hog = 1 and pla_mie = 8;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 911508 and pla_hog = 1 and pla_mie = 10;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 911508 and pla_hog = 1 and pla_mie = 10;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911508 and pla_hog = 1 and pla_mie = 13;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911508 and pla_hog = 1 and pla_mie = 13;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911512 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911512 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 911512 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 911512 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 911514 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 911514 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 911514 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 911514 and pla_hog = 1 and pla_mie = 2;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 911517 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72113 WHERE pla_enc = 911517 and pla_hog = 1 and pla_mie = 2;		
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 911518 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 911518 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 911543 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 911543 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 911543 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 911543 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
			
			
			
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9409 WHERE pla_enc = 911546 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53313 WHERE pla_enc = 911546 and pla_hog = 1 and pla_mie = 2;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911546 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 911546 and pla_hog = 1 and pla_mie = 5;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911564 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911564 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 911564 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 911564 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 911564 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 911564 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 911564 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 911564 and pla_hog = 1 and pla_mie = 5;
			
			
			
			
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 1400 WHERE pla_enc = 911569 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80323 WHERE pla_enc = 911569 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911569 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 911569 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 911580 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80123 WHERE pla_enc = 911580 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 911580 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 911580 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 911582 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 911582 and pla_hog = 1 and pla_mie = 1;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 911591 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 911591 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 911591 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82313 WHERE pla_enc = 911591 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9602 WHERE pla_enc = 911599 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 57313 WHERE pla_enc = 911599 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 911599 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53313 WHERE pla_enc = 911599 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911600 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 911600 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911609 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911609 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911609 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 911609 and pla_hog = 1 and pla_mie = 4;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9503 WHERE pla_enc = 911612 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80123 WHERE pla_enc = 911612 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 911614 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 911614 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 911614 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 911614 and pla_hog = 1 and pla_mie = 4;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911631 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911631 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5202 WHERE pla_enc = 911631 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 58313 WHERE pla_enc = 911631 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911631 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911631 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 911639 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 911639 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 911639 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53313 WHERE pla_enc = 911639 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 911645 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 911645 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911666 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911666 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 911667 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 911667 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911687 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 911687 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911687 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911687 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911688 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 911688 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 911692 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 5002 WHERE pla_enc = 911692 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 911692 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 911692 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 911692 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 911692 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 911692 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 911692 and pla_hog = 1 and pla_mie = 4;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 911698 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34323 WHERE pla_enc = 911698 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 911715 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 911715 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 911719 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 911719 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911726 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911726 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 911726 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 911726 and pla_hog = 1 and pla_mie = 2;		
			
			
			
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911751 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911751 and pla_hog = 1 and pla_mie = 1;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9302 WHERE pla_enc = 911751 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53314 WHERE pla_enc = 911751 and pla_hog = 1 and pla_mie = 4;		
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 6900 WHERE pla_enc = 911753 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10332 WHERE pla_enc = 911753 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2604 WHERE pla_enc = 911753 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 911753 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 911755 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 911755 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 911794 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 911794 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911803 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911803 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 911803 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53313 WHERE pla_enc = 911803 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6000 WHERE pla_enc = 911803 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 45312 WHERE pla_enc = 911803 and pla_hog = 1 and pla_mie = 4;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 911803 and pla_hog = 1 and pla_mie = 7;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55114 WHERE pla_enc = 911803 and pla_hog = 1 and pla_mie = 7;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5500 WHERE pla_enc = 911812 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 911812 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9602 WHERE pla_enc = 911827 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 57113 WHERE pla_enc = 911827 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8502 WHERE pla_enc = 911827 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41312 WHERE pla_enc = 911827 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 911827 and pla_hog = 1 and pla_mie = 7;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 911827 and pla_hog = 1 and pla_mie = 7;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3200 WHERE pla_enc = 911842 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 911842 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911842 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911842 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911844 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911844 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 911854 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10314 WHERE pla_enc = 911854 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 6400 WHERE pla_enc = 911854 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 32314 WHERE pla_enc = 911854 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911856 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911856 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8000 WHERE pla_enc = 911856 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 47313 WHERE pla_enc = 911856 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911857 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911857 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4502 WHERE pla_enc = 911857 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30203 WHERE pla_enc = 911857 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911870 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911870 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4804 WHERE pla_enc = 911870 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10333 WHERE pla_enc = 911870 and pla_hog = 1 and pla_mie = 2;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 4804 WHERE pla_enc = 911870 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10313 WHERE pla_enc = 911870 and pla_hog = 1 and pla_mie = 3;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 911895 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 47313 WHERE pla_enc = 911895 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9301 WHERE pla_enc = 911901 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41113 WHERE pla_enc = 911901 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911901 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 911901 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6900 WHERE pla_enc = 911909 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10332 WHERE pla_enc = 911909 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 911909 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41313 WHERE pla_enc = 911909 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 911918 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 911918 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911918 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911918 and pla_hog = 1 and pla_mie = 5;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911923 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911923 and pla_hog = 1 and pla_mie = 1;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 911934 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72313 WHERE pla_enc = 911934 and pla_hog = 1 and pla_mie = 1;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 911934 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72313 WHERE pla_enc = 911934 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911936 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911936 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 911936 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 911936 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 911936 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 911936 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 911947 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 911947 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5500 WHERE pla_enc = 911948 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 911948 and pla_hog = 1 and pla_mie = 2;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 1700 WHERE pla_enc = 911959 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80323 WHERE pla_enc = 911959 and pla_hog = 1 and pla_mie = 1;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 911973 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 911973 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 911973 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 911973 and pla_hog = 1 and pla_mie = 6;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911977 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911977 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911977 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 911977 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 911989 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 911989 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 911989 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 911989 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 912003 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53113 WHERE pla_enc = 912003 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 912003 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72313 WHERE pla_enc = 912003 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 912003 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 912003 and pla_hog = 1 and pla_mie = 6;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 912003 and pla_hog = 1 and pla_mie = 7;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 912003 and pla_hog = 1 and pla_mie = 7;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 912003 and pla_hog = 1 and pla_mie = 8;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30314 WHERE pla_enc = 912003 and pla_hog = 1 and pla_mie = 8;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 912003 and pla_hog = 1 and pla_mie = 11;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 912003 and pla_hog = 1 and pla_mie = 11;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912007 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912007 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 912007 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 912007 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912008 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912008 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5602 WHERE pla_enc = 912008 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 912008 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 912010 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 912010 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912010 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912010 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912028 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912028 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 912028 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 912028 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 912043 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 912043 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 912043 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 912043 and pla_hog = 1 and pla_mie = 3;
UPDATE encu.plana_i1_ SET pla_t23_cod = 1400 WHERE pla_enc = 912043 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10314 WHERE pla_enc = 912043 and pla_hog = 1 and pla_mie = 4;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 912044 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32313 WHERE pla_enc = 912044 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 912044 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32313 WHERE pla_enc = 912044 and pla_hog = 1 and pla_mie = 4;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 912045 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72113 WHERE pla_enc = 912045 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912045 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912045 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912045 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912045 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912057 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912057 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 912057 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34323 WHERE pla_enc = 912057 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 912061 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10313 WHERE pla_enc = 912061 and pla_hog = 1 and pla_mie = 1;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 912067 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 912067 and pla_hog = 1 and pla_mie = 1;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2500 WHERE pla_enc = 912067 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 912067 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912069 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912069 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 912069 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 912069 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4805 WHERE pla_enc = 912069 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 912069 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 912069 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 912069 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1800 WHERE pla_enc = 912069 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 912069 and pla_hog = 1 and pla_mie = 5;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 912071 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 912071 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 912071 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 912071 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1502 WHERE pla_enc = 912075 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 912075 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 912077 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 912077 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 912077 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 912077 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 912080 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34113 WHERE pla_enc = 912080 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4808 WHERE pla_enc = 912080 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 20323 WHERE pla_enc = 912080 and pla_hog = 1 and pla_mie = 3;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 912081 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 912081 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 912084 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 912084 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 912091 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 912091 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 912091 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 912091 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912093 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912093 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912108 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912108 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 912111 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 912111 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 912111 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 912111 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 912111 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 912111 and pla_hog = 1 and pla_mie = 5;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 912116 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34323 WHERE pla_enc = 912116 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 1400 WHERE pla_enc = 912116 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80323 WHERE pla_enc = 912116 and pla_hog = 1 and pla_mie = 2;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 912130 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40312 WHERE pla_enc = 912130 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 912132 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 912132 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 912132 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 912132 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 912138 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 912138 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 912146 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 99999 WHERE pla_enc = 912146 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 912146 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 912146 and pla_hog = 1 and pla_mie = 5;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912149 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912149 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 912149 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 912149 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912160 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912160 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 1400 WHERE pla_enc = 912161 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80314 WHERE pla_enc = 912161 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 912161 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 912161 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912167 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912167 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 912170 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 912170 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 912188 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 912188 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 912190 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 912190 and pla_hog = 1 and pla_mie = 1;		
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 912192 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 912192 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912196 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912196 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 912197 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 912197 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912199 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912199 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912207 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912207 and pla_hog = 1 and pla_mie = 1;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 912207 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53313 WHERE pla_enc = 912207 and pla_hog = 1 and pla_mie = 4;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912209 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912209 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 912222 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 912222 and pla_hog = 1 and pla_mie = 2;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 2701 WHERE pla_enc = 912226 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 20313 WHERE pla_enc = 912226 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5900 WHERE pla_enc = 912226 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10203 WHERE pla_enc = 912226 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5900 WHERE pla_enc = 912226 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34323 WHERE pla_enc = 912226 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912228 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912228 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 8000 WHERE pla_enc = 912228 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 47314 WHERE pla_enc = 912228 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 912230 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80123 WHERE pla_enc = 912230 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 912230 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80114 WHERE pla_enc = 912230 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912238 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912238 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 912239 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56203 WHERE pla_enc = 912239 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4502 WHERE pla_enc = 912252 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82313 WHERE pla_enc = 912252 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 912253 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 912253 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912253 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912253 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4808 WHERE pla_enc = 912253 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 912253 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 912262 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34113 WHERE pla_enc = 912262 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912268 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912268 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 912268 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72113 WHERE pla_enc = 912268 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 912272 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 912272 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912273 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912273 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 912273 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 912273 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912279 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912279 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 912279 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 912279 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912279 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912279 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912291 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912291 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 912291 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 912291 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 8700 WHERE pla_enc = 912291 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 52313 WHERE pla_enc = 912291 and pla_hog = 1 and pla_mie = 3;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 912293 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 912293 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 912296 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 912296 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912301 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912301 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4903 WHERE pla_enc = 912301 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10323 WHERE pla_enc = 912301 and pla_hog = 1 and pla_mie = 2;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 912305 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53113 WHERE pla_enc = 912305 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912305 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912305 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 912305 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 32314 WHERE pla_enc = 912305 and pla_hog = 1 and pla_mie = 3;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 912312 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 912312 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 912315 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 912315 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 912315 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 912315 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 912315 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 912315 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 912315 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 912315 and pla_hog = 1 and pla_mie = 4;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912318 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912318 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4805 WHERE pla_enc = 912318 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 912318 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 912333 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 912333 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912340 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912340 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4502 WHERE pla_enc = 912342 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82113 WHERE pla_enc = 912342 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2202 WHERE pla_enc = 912342 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 912342 and pla_hog = 1 and pla_mie = 5;
			
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 8101 WHERE pla_enc = 912351 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 912351 and pla_hog = 1 and pla_mie = 1;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 912353 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72314 WHERE pla_enc = 912353 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8401 WHERE pla_enc = 912358 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40314 WHERE pla_enc = 912358 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 912366 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 912366 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1502 WHERE pla_enc = 912375 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 912375 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 912375 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40314 WHERE pla_enc = 912375 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 912378 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 912378 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4808 WHERE pla_enc = 912378 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 912378 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 912385 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 912385 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 912389 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 912389 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4808 WHERE pla_enc = 912389 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 912389 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912390 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912390 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 912390 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 912390 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912424 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912424 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9602 WHERE pla_enc = 912436 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 57113 WHERE pla_enc = 912436 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 912443 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 912443 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 912443 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 912443 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 912450 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56313 WHERE pla_enc = 912450 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 912470 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 912470 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 912475 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 912475 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914001 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914001 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 914001 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 914001 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914002 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 914002 and pla_hog = 1 and pla_mie = 1;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 8501 WHERE pla_enc = 914003 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10333 WHERE pla_enc = 914003 and pla_hog = 1 and pla_mie = 1;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914006 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914006 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914007 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914007 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914007 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 914007 and pla_hog = 1 and pla_mie = 2;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 914008 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72314 WHERE pla_enc = 914008 and pla_hog = 1 and pla_mie = 1;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914011 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914011 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914011 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 914011 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3300 WHERE pla_enc = 914011 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82312 WHERE pla_enc = 914011 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 914013 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56313 WHERE pla_enc = 914013 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914013 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914013 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914013 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914013 and pla_hog = 1 and pla_mie = 4;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9302 WHERE pla_enc = 914016 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 52113 WHERE pla_enc = 914016 and pla_hog = 1 and pla_mie = 1;		
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914017 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914017 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914021 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914021 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914021 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914021 and pla_hog = 1 and pla_mie = 2;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9601 WHERE pla_enc = 914022 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56203 WHERE pla_enc = 914022 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914023 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 914023 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 914025 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82123 WHERE pla_enc = 914025 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914026 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914026 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914026 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914026 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 914028 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 914028 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1800 WHERE pla_enc = 914028 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 914028 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4808 WHERE pla_enc = 914031 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30314 WHERE pla_enc = 914031 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914034 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914034 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 914042 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40313 WHERE pla_enc = 914042 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8102 WHERE pla_enc = 914045 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 58113 WHERE pla_enc = 914045 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 8200 WHERE pla_enc = 914045 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10333 WHERE pla_enc = 914045 and pla_hog = 1 and pla_mie = 3;		
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914050 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914050 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914054 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 914054 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2500 WHERE pla_enc = 914055 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 914055 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 914058 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 914058 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 914058 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 914058 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914059 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914059 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914062 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914062 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8502 WHERE pla_enc = 914063 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30203 WHERE pla_enc = 914063 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 914063 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53313 WHERE pla_enc = 914063 and pla_hog = 1 and pla_mie = 3;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 914063 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 914063 and pla_hog = 1 and pla_mie = 4;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 914067 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 914067 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5300 WHERE pla_enc = 914068 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 35314 WHERE pla_enc = 914068 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914068 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914068 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914068 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914068 and pla_hog = 1 and pla_mie = 4;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 914069 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55114 WHERE pla_enc = 914069 and pla_hog = 1 and pla_mie = 1;		
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914071 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914071 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914071 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 914071 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914073 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 914073 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914082 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914082 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 914082 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40313 WHERE pla_enc = 914082 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914082 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 914082 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 914083 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53313 WHERE pla_enc = 914083 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914084 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914084 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914085 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914085 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 914085 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41312 WHERE pla_enc = 914085 and pla_hog = 1 and pla_mie = 5;
UPDATE encu.plana_i1_ SET pla_t23_cod = 7100 WHERE pla_enc = 914085 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72314 WHERE pla_enc = 914085 and pla_hog = 1 and pla_mie = 6;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 914087 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56313 WHERE pla_enc = 914087 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 914089 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30314 WHERE pla_enc = 914089 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914091 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 914091 and pla_hog = 1 and pla_mie = 1;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 6900 WHERE pla_enc = 914091 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 914091 and pla_hog = 1 and pla_mie = 4;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 914092 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 914092 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914096 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914096 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 8502 WHERE pla_enc = 914096 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 41113 WHERE pla_enc = 914096 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914098 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914098 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914099 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914099 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914103 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 914103 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 914103 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40313 WHERE pla_enc = 914103 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914104 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 914104 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914105 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914105 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914111 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914111 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 914112 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30314 WHERE pla_enc = 914112 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914112 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914112 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914115 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914115 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4903 WHERE pla_enc = 914116 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 34323 WHERE pla_enc = 914116 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914117 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914117 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914120 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914120 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914120 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 914120 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9602 WHERE pla_enc = 914125 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 57113 WHERE pla_enc = 914125 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914125 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914125 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 914126 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 914126 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914127 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 914127 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914134 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914134 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 914142 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 914142 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914143 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914143 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914146 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914146 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4805 WHERE pla_enc = 914146 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36314 WHERE pla_enc = 914146 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4904 WHERE pla_enc = 914147 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34123 WHERE pla_enc = 914147 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914149 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914149 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914151 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914151 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 914154 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53314 WHERE pla_enc = 914154 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914156 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 914156 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914156 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914156 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 914158 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 914158 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 914159 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 914159 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 914160 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 914160 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8401 WHERE pla_enc = 914160 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 81331 WHERE pla_enc = 914160 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914162 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 914162 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3100 WHERE pla_enc = 914163 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 914163 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 914164 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 914164 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914170 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914170 and pla_hog = 1 and pla_mie = 1;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9601 WHERE pla_enc = 914173 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 914173 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6500 WHERE pla_enc = 914173 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10332 WHERE pla_enc = 914173 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6900 WHERE pla_enc = 914173 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 20333 WHERE pla_enc = 914173 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914174 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914174 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914179 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914179 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 8600 WHERE pla_enc = 914183 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 40312 WHERE pla_enc = 914183 and pla_hog = 1 and pla_mie = 1;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914186 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914186 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914187 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 914187 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914187 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 914187 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914189 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914189 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 914190 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 914190 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5900 WHERE pla_enc = 914191 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 914191 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4805 WHERE pla_enc = 914192 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33113 WHERE pla_enc = 914192 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4805 WHERE pla_enc = 914192 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33113 WHERE pla_enc = 914192 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914193 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914193 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 914193 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 20313 WHERE pla_enc = 914193 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 914193 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 32314 WHERE pla_enc = 914193 and pla_hog = 1 and pla_mie = 3;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914194 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914194 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914195 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914195 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4805 WHERE pla_enc = 914196 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 914196 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4801 WHERE pla_enc = 914197 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56203 WHERE pla_enc = 914197 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914198 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914198 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 914199 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10313 WHERE pla_enc = 914199 and pla_hog = 1 and pla_mie = 1;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 2002 WHERE pla_enc = 914199 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80313 WHERE pla_enc = 914199 and pla_hog = 1 and pla_mie = 2;		
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 8600 WHERE pla_enc = 914199 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 914199 and pla_hog = 1 and pla_mie = 5;		
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 914200 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72113 WHERE pla_enc = 914200 and pla_hog = 1 and pla_mie = 1;		
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 8401 WHERE pla_enc = 914201 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10334 WHERE pla_enc = 914201 and pla_hog = 1 and pla_mie = 3;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 914204 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53313 WHERE pla_enc = 914204 and pla_hog = 1 and pla_mie = 1;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 1400 WHERE pla_enc = 914204 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80313 WHERE pla_enc = 914204 and pla_hog = 1 and pla_mie = 3;		
			
			
			
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914206 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914206 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 914213 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36314 WHERE pla_enc = 914213 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914213 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914213 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914214 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914214 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914215 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 914215 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914216 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914216 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914219 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 914219 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 914220 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55114 WHERE pla_enc = 914220 and pla_hog = 1 and pla_mie = 1;		
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4810 WHERE pla_enc = 914223 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 33114 WHERE pla_enc = 914223 and pla_hog = 1 and pla_mie = 1;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8401 WHERE pla_enc = 914224 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10203 WHERE pla_enc = 914224 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914225 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914225 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914228 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914228 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 914229 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82113 WHERE pla_enc = 914229 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914235 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914235 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914236 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914236 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 914236 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 914236 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914237 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914237 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914237 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 914237 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9000 WHERE pla_enc = 914239 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 50311 WHERE pla_enc = 914239 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914240 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914240 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914241 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 914241 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914241 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914241 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914243 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914243 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 8700 WHERE pla_enc = 914243 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 40313 WHERE pla_enc = 914243 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914246 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914246 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914247 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914247 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 914250 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56313 WHERE pla_enc = 914250 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914250 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914250 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4808 WHERE pla_enc = 914252 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 20313 WHERE pla_enc = 914252 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 914252 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34323 WHERE pla_enc = 914252 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4805 WHERE pla_enc = 914252 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 914252 and pla_hog = 1 and pla_mie = 5;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914252 and pla_hog = 1 and pla_mie = 7;	UPDATE encu.plana_i1_ SET pla_t41_cod = 47313 WHERE pla_enc = 914252 and pla_hog = 1 and pla_mie = 7;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914255 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914255 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 914255 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32323 WHERE pla_enc = 914255 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 914255 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 914255 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914256 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914256 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 914257 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40112 WHERE pla_enc = 914257 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914258 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 914258 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914262 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914262 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914262 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 914262 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914267 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914267 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914268 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914268 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 914269 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 914269 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 914269 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 20313 WHERE pla_enc = 914269 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914270 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914270 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4804 WHERE pla_enc = 914270 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10323 WHERE pla_enc = 914270 and pla_hog = 1 and pla_mie = 2;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4904 WHERE pla_enc = 914277 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36314 WHERE pla_enc = 914277 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4804 WHERE pla_enc = 914280 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10313 WHERE pla_enc = 914280 and pla_hog = 1 and pla_mie = 1;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 914282 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56203 WHERE pla_enc = 914282 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914283 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914283 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914285 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 914285 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 914286 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 914286 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914288 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914288 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 914288 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 914288 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5602 WHERE pla_enc = 914291 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914291 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914291 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 914291 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 914294 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56323 WHERE pla_enc = 914294 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914294 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914294 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914295 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 914295 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 8600 WHERE pla_enc = 914298 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10313 WHERE pla_enc = 914298 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 914299 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56203 WHERE pla_enc = 914299 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914299 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914299 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914304 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914304 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4808 WHERE pla_enc = 914305 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36314 WHERE pla_enc = 914305 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914306 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914306 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9301 WHERE pla_enc = 914308 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 914308 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 914308 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 914308 and pla_hog = 1 and pla_mie = 2;		
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9409 WHERE pla_enc = 914309 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53314 WHERE pla_enc = 914309 and pla_hog = 1 and pla_mie = 1;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914311 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914311 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914311 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914311 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4805 WHERE pla_enc = 914313 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 914313 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914313 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914313 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9100 WHERE pla_enc = 914317 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41313 WHERE pla_enc = 914317 and pla_hog = 1 and pla_mie = 1;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9409 WHERE pla_enc = 914322 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10333 WHERE pla_enc = 914322 and pla_hog = 1 and pla_mie = 1;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8502 WHERE pla_enc = 914324 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41112 WHERE pla_enc = 914324 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 914324 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 914324 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914325 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914325 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8502 WHERE pla_enc = 914326 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41112 WHERE pla_enc = 914326 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914330 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 914330 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914330 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914330 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914333 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914333 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9602 WHERE pla_enc = 914335 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 57113 WHERE pla_enc = 914335 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914339 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914339 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914340 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 914340 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4502 WHERE pla_enc = 914340 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 82314 WHERE pla_enc = 914340 and pla_hog = 1 and pla_mie = 3;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914345 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914345 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5602 WHERE pla_enc = 914346 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53113 WHERE pla_enc = 914346 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914347 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914347 and pla_hog = 1 and pla_mie = 1;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 1400 WHERE pla_enc = 914349 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80314 WHERE pla_enc = 914349 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914349 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 914349 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4502 WHERE pla_enc = 914349 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82314 WHERE pla_enc = 914349 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 914350 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 914350 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914350 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 914350 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914352 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 914352 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 914353 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 914353 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 914357 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 914357 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914358 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55114 WHERE pla_enc = 914358 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9000 WHERE pla_enc = 914358 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 50311 WHERE pla_enc = 914358 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3200 WHERE pla_enc = 914358 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 914358 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914358 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 914358 and pla_hog = 1 and pla_mie = 5;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914359 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914359 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914361 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914361 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4810 WHERE pla_enc = 914361 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 30313 WHERE pla_enc = 914361 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914361 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 914361 and pla_hog = 1 and pla_mie = 6;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914362 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914362 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914364 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914364 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 914364 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72113 WHERE pla_enc = 914364 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 914364 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 914364 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914365 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 914365 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914366 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914366 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9301 WHERE pla_enc = 914368 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 51314 WHERE pla_enc = 914368 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914370 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914370 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914370 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 914370 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914372 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 914372 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 914372 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 914372 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914373 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914373 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914373 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 914373 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5602 WHERE pla_enc = 914375 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 914375 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914375 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 914375 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3200 WHERE pla_enc = 914378 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 914378 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914382 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914382 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 914383 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 47313 WHERE pla_enc = 914383 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9601 WHERE pla_enc = 914383 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56113 WHERE pla_enc = 914383 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9601 WHERE pla_enc = 914385 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56113 WHERE pla_enc = 914385 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914387 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 914387 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914388 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 914388 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914388 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 914388 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914389 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 914389 and pla_hog = 1 and pla_mie = 2;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4808 WHERE pla_enc = 914391 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 32314 WHERE pla_enc = 914391 and pla_hog = 1 and pla_mie = 1;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 4810 WHERE pla_enc = 914391 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 33114 WHERE pla_enc = 914391 and pla_hog = 1 and pla_mie = 2;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 4804 WHERE pla_enc = 914391 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10113 WHERE pla_enc = 914391 and pla_hog = 1 and pla_mie = 3;		
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914392 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 914392 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914392 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914392 and pla_hog = 1 and pla_mie = 4;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 914393 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 914393 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914395 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 914395 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5602 WHERE pla_enc = 914396 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 914396 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5602 WHERE pla_enc = 914396 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 914396 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914398 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914398 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914398 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914398 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914398 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 914398 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914401 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 914401 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5602 WHERE pla_enc = 914404 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914404 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914405 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 914405 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914406 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914406 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914406 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914406 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914408 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 914408 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
			
			
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 914411 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72113 WHERE pla_enc = 914411 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914411 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 914411 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914412 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 914412 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914413 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914413 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5602 WHERE pla_enc = 914415 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53113 WHERE pla_enc = 914415 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914415 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 914415 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914416 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914416 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 914416 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 914416 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 914416 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72314 WHERE pla_enc = 914416 and pla_hog = 1 and pla_mie = 3;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914417 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914417 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 914418 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 914418 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914419 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914419 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 914419 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82123 WHERE pla_enc = 914419 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9603 WHERE pla_enc = 914421 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 914421 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5602 WHERE pla_enc = 914421 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 914421 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914424 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 914424 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914424 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 914424 and pla_hog = 1 and pla_mie = 3;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4810 WHERE pla_enc = 914424 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 20313 WHERE pla_enc = 914424 and pla_hog = 1 and pla_mie = 4;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9601 WHERE pla_enc = 914426 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56113 WHERE pla_enc = 914426 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9601 WHERE pla_enc = 914426 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56113 WHERE pla_enc = 914426 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914427 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 914427 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 914428 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 914428 and pla_hog = 1 and pla_mie = 1;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 914429 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72313 WHERE pla_enc = 914429 and pla_hog = 1 and pla_mie = 2;		
			
			
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914435 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914435 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 914436 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 914436 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914439 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 914439 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914439 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 914439 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914440 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914440 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914442 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 914442 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914443 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914443 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 914443 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72313 WHERE pla_enc = 914443 and pla_hog = 1 and pla_mie = 2;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914445 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914445 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914446 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 914446 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914446 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 914446 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8102 WHERE pla_enc = 914446 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 58113 WHERE pla_enc = 914446 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914447 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914447 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914448 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914448 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914448 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 914448 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914450 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 914450 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 914451 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 914451 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 914451 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 914451 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914451 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914451 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914454 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 914454 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914455 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914455 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4502 WHERE pla_enc = 914455 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 914455 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914456 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914456 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 914457 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72113 WHERE pla_enc = 914457 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914458 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914458 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914460 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 914460 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914461 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914461 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 914463 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 914463 and pla_hog = 1 and pla_mie = 1;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2603 WHERE pla_enc = 914463 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82113 WHERE pla_enc = 914463 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914464 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914464 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914465 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914465 and pla_hog = 1 and pla_mie = 1;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 914466 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55114 WHERE pla_enc = 914466 and pla_hog = 1 and pla_mie = 1;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4904 WHERE pla_enc = 914467 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36314 WHERE pla_enc = 914467 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914467 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914467 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914472 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914472 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9601 WHERE pla_enc = 914474 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56113 WHERE pla_enc = 914474 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 914474 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72314 WHERE pla_enc = 914474 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914475 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914475 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 914476 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 914476 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914477 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 914477 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914477 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914477 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914478 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 914478 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9601 WHERE pla_enc = 914483 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56113 WHERE pla_enc = 914483 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914483 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914483 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914484 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914484 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914487 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55114 WHERE pla_enc = 914487 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 914487 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 914487 and pla_hog = 1 and pla_mie = 6;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4808 WHERE pla_enc = 914487 and pla_hog = 1 and pla_mie = 8;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 914487 and pla_hog = 1 and pla_mie = 8;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914488 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914488 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 914489 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 914489 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 914489 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56203 WHERE pla_enc = 914489 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 914491 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 914491 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914492 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 914492 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 914495 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 914495 and pla_hog = 1 and pla_mie = 2;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 1400 WHERE pla_enc = 914496 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80314 WHERE pla_enc = 914496 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 914496 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 914496 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 960007 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 960007 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 960007 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 960007 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960007 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960007 and pla_hog = 1 and pla_mie = 4;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960022 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960022 and pla_hog = 1 and pla_mie = 1;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4803 WHERE pla_enc = 960025 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10313 WHERE pla_enc = 960025 and pla_hog = 1 and pla_mie = 1;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 960025 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 32414 WHERE pla_enc = 960025 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 960025 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 960025 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960028 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960028 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 960028 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 960028 and pla_hog = 1 and pla_mie = 5;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 960039 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 960039 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 960050 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 960050 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 960050 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 960050 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 960050 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53314 WHERE pla_enc = 960050 and pla_hog = 1 and pla_mie = 3;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 960050 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 960050 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 960053 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 960053 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 960053 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 960053 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4502 WHERE pla_enc = 960053 and pla_hog = 1 and pla_mie = 8;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 960053 and pla_hog = 1 and pla_mie = 8;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 960055 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 960055 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4903 WHERE pla_enc = 960055 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 32314 WHERE pla_enc = 960055 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 960056 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 960056 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 1009 WHERE pla_enc = 960057 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80113 WHERE pla_enc = 960057 and pla_hog = 1 and pla_mie = 1;		
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4803 WHERE pla_enc = 960058 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10313 WHERE pla_enc = 960058 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960061 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960061 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3200 WHERE pla_enc = 960064 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 960064 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2601 WHERE pla_enc = 960064 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 960064 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 960064 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 960064 and pla_hog = 1 and pla_mie = 5;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 960073 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 960073 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960073 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960073 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 960074 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40312 WHERE pla_enc = 960074 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 960090 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40112 WHERE pla_enc = 960090 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5300 WHERE pla_enc = 960090 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 35123 WHERE pla_enc = 960090 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4904 WHERE pla_enc = 960095 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34323 WHERE pla_enc = 960095 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 960095 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 960095 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4502 WHERE pla_enc = 960095 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 960095 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 960095 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 960095 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4904 WHERE pla_enc = 960095 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36314 WHERE pla_enc = 960095 and pla_hog = 1 and pla_mie = 5;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4904 WHERE pla_enc = 960095 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36314 WHERE pla_enc = 960095 and pla_hog = 1 and pla_mie = 6;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960096 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960096 and pla_hog = 1 and pla_mie = 1;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 8200 WHERE pla_enc = 960102 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10333 WHERE pla_enc = 960102 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 960102 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34323 WHERE pla_enc = 960102 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960108 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960108 and pla_hog = 1 and pla_mie = 1;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 960121 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 960121 and pla_hog = 1 and pla_mie = 1;		
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 960127 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 960127 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4805 WHERE pla_enc = 960127 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 960127 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960130 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960130 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4904 WHERE pla_enc = 960138 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 960138 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960141 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960141 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5202 WHERE pla_enc = 960143 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 58313 WHERE pla_enc = 960143 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 960148 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 960148 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960154 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960154 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 960154 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 960154 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 8101 WHERE pla_enc = 960154 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 960154 and pla_hog = 1 and pla_mie = 3;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 960162 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40112 WHERE pla_enc = 960162 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2500 WHERE pla_enc = 960178 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 960178 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9602 WHERE pla_enc = 960198 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 57113 WHERE pla_enc = 960198 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 960199 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 960199 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6600 WHERE pla_enc = 960199 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10314 WHERE pla_enc = 960199 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 960199 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30203 WHERE pla_enc = 960199 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960204 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960204 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 960204 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72113 WHERE pla_enc = 960204 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 960216 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 960216 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 960216 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 960216 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4804 WHERE pla_enc = 960216 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10314 WHERE pla_enc = 960216 and pla_hog = 1 and pla_mie = 3;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 960218 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 960218 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960224 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960224 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 960224 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30314 WHERE pla_enc = 960224 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 960245 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 960245 and pla_hog = 1 and pla_mie = 1;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960266 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960266 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4904 WHERE pla_enc = 960266 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34323 WHERE pla_enc = 960266 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9301 WHERE pla_enc = 960266 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 51312 WHERE pla_enc = 960266 and pla_hog = 1 and pla_mie = 3;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 9302 WHERE pla_enc = 960266 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 960266 and pla_hog = 1 and pla_mie = 4;		
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 8700 WHERE pla_enc = 960272 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53313 WHERE pla_enc = 960272 and pla_hog = 1 and pla_mie = 1;		
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 960275 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53314 WHERE pla_enc = 960275 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 960275 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34113 WHERE pla_enc = 960275 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960289 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960289 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 960298 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 960298 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 960298 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 960298 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960322 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960322 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 960322 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40312 WHERE pla_enc = 960322 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960324 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960324 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960331 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960331 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 960338 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 960338 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960340 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960340 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8502 WHERE pla_enc = 960340 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41312 WHERE pla_enc = 960340 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960348 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960348 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 960348 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 960348 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960391 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960391 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1502 WHERE pla_enc = 960393 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 960393 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 960417 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 960417 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 960417 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82313 WHERE pla_enc = 960417 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 960428 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 960428 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 8600 WHERE pla_enc = 960428 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 40312 WHERE pla_enc = 960428 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9602 WHERE pla_enc = 960455 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 57113 WHERE pla_enc = 960455 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960456 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960456 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 960491 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 960491 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 960494 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 960494 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9000 WHERE pla_enc = 960494 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 47314 WHERE pla_enc = 960494 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960494 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960494 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 960495 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 960495 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 960495 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 960495 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960496 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960496 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 960498 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 960498 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 960504 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40312 WHERE pla_enc = 960504 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9609 WHERE pla_enc = 960518 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10112 WHERE pla_enc = 960518 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 960519 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 960519 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960535 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960535 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960545 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960545 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6900 WHERE pla_enc = 960545 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 960545 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960551 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960551 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 960551 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 960551 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960564 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960564 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6900 WHERE pla_enc = 960564 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 960564 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8502 WHERE pla_enc = 960575 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41112 WHERE pla_enc = 960575 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960576 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960576 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4502 WHERE pla_enc = 960576 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 960576 and pla_hog = 1 and pla_mie = 2;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 960576 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72314 WHERE pla_enc = 960576 and pla_hog = 1 and pla_mie = 3;		
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 960582 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40313 WHERE pla_enc = 960582 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 960582 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 960582 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 960595 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 960595 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9100 WHERE pla_enc = 960595 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 20313 WHERE pla_enc = 960595 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1502 WHERE pla_enc = 960596 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 960596 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1502 WHERE pla_enc = 960596 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 960596 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 960598 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 960598 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8502 WHERE pla_enc = 960598 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41112 WHERE pla_enc = 960598 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 960613 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 960613 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 960623 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 960623 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 960625 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 960625 and pla_hog = 1 and pla_mie = 1;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 960632 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 960632 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2701 WHERE pla_enc = 960632 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80312 WHERE pla_enc = 960632 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960646 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960646 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 960654 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 960654 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 960654 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 960654 and pla_hog = 1 and pla_mie = 3;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4810 WHERE pla_enc = 960654 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 33114 WHERE pla_enc = 960654 and pla_hog = 1 and pla_mie = 4;		
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6900 WHERE pla_enc = 960675 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 11131 WHERE pla_enc = 960675 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 7000 WHERE pla_enc = 960675 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10112 WHERE pla_enc = 960675 and pla_hog = 1 and pla_mie = 2;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 960675 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53314 WHERE pla_enc = 960675 and pla_hog = 1 and pla_mie = 3;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 960677 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82123 WHERE pla_enc = 960677 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2500 WHERE pla_enc = 960677 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 960677 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2900 WHERE pla_enc = 960677 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 960677 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960687 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960687 and pla_hog = 1 and pla_mie = 1;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 1400 WHERE pla_enc = 960687 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80313 WHERE pla_enc = 960687 and pla_hog = 1 and pla_mie = 3;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960702 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960702 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4807 WHERE pla_enc = 960707 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30314 WHERE pla_enc = 960707 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4807 WHERE pla_enc = 960707 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 960707 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960721 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960721 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8102 WHERE pla_enc = 960724 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 58113 WHERE pla_enc = 960724 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960741 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960741 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960744 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960744 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6500 WHERE pla_enc = 960753 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 960753 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 960755 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 960755 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 960755 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 81332 WHERE pla_enc = 960755 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 960759 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 960759 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 960764 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 960764 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 965020 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 965020 and pla_hog = 1 and pla_mie = 1;		
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4502 WHERE pla_enc = 965021 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82314 WHERE pla_enc = 965021 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 965028 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 965028 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 965028 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72314 WHERE pla_enc = 965028 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 965038 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 965038 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 965043 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 965043 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5202 WHERE pla_enc = 965043 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34313 WHERE pla_enc = 965043 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 965043 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 965043 and pla_hog = 1 and pla_mie = 4;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 965056 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 965056 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 965056 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 965056 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 965064 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 965064 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 965064 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 965064 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 965083 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 965083 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 965090 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 965090 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 965092 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 965092 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 965097 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 965097 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 965097 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 965097 and pla_hog = 1 and pla_mie = 3;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 965097 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 965097 and pla_hog = 1 and pla_mie = 4;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 965099 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 965099 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 965099 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 965099 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 965101 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 965101 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 965103 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 965103 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 965137 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 965137 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 965137 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 965137 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 965137 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 965137 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 965137 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 965137 and pla_hog = 1 and pla_mie = 4;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5602 WHERE pla_enc = 965143 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 965143 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 965143 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 965143 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 965144 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 965144 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 965144 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 965144 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 965144 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 965144 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 965151 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 965151 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4804 WHERE pla_enc = 965151 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10313 WHERE pla_enc = 965151 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 965152 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 965152 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8401 WHERE pla_enc = 965152 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 965152 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 965152 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 20323 WHERE pla_enc = 965152 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 965160 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82313 WHERE pla_enc = 965160 and pla_hog = 1 and pla_mie = 2;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 3200 WHERE pla_enc = 965167 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80113 WHERE pla_enc = 965167 and pla_hog = 1 and pla_mie = 1;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9602 WHERE pla_enc = 965200 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 965200 and pla_hog = 1 and pla_mie = 1;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 965212 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 965212 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4502 WHERE pla_enc = 965212 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82313 WHERE pla_enc = 965212 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 965215 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 965215 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 965217 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 965217 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 965217 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 965217 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 965219 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 965219 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 965219 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 20323 WHERE pla_enc = 965219 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 965224 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 965224 and pla_hog = 1 and pla_mie = 1;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 1400 WHERE pla_enc = 965224 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80323 WHERE pla_enc = 965224 and pla_hog = 1 and pla_mie = 3;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 965226 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 965226 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 965226 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 965226 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 965246 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 965246 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 965246 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 965246 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 965246 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36314 WHERE pla_enc = 965246 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 965250 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 965250 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 965250 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 965250 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 965253 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 965253 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 965253 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 965253 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 965253 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40312 WHERE pla_enc = 965253 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 965255 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 965255 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 965255 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 965255 and pla_hog = 1 and pla_mie = 4;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4810 WHERE pla_enc = 965255 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t24_cod = 33114 WHERE pla_enc = 965255 and pla_hog = 1 and pla_mie = 5;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1100 WHERE pla_enc = 965258 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30114 WHERE pla_enc = 965258 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 965258 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72313 WHERE pla_enc = 965258 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 965258 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 965258 and pla_hog = 1 and pla_mie = 6;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 965261 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 965261 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 965261 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 965261 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1502 WHERE pla_enc = 965261 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 965261 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 965265 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40313 WHERE pla_enc = 965265 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 2500 WHERE pla_enc = 965265 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80314 WHERE pla_enc = 965265 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3200 WHERE pla_enc = 965272 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 965272 and pla_hog = 1 and pla_mie = 1;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 965276 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 965276 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 965277 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40313 WHERE pla_enc = 965277 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 965293 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 965293 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 965293 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 965293 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 965298 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 965298 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 965298 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 965298 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 965298 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 20323 WHERE pla_enc = 965298 and pla_hog = 1 and pla_mie = 3;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1502 WHERE pla_enc = 965300 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 965300 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4805 WHERE pla_enc = 965301 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 965301 and pla_hog = 1 and pla_mie = 2;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 965304 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72313 WHERE pla_enc = 965304 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 965304 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 965304 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 965309 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 965309 and pla_hog = 1 and pla_mie = 1;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 1400 WHERE pla_enc = 965319 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80323 WHERE pla_enc = 965319 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 965319 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 965319 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 965511 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 965511 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9301 WHERE pla_enc = 965511 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 965511 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 965511 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 965511 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9602 WHERE pla_enc = 965512 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 965512 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 965516 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53113 WHERE pla_enc = 965516 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 965519 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 965519 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 965519 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 965519 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 965527 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 965527 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 965527 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 965527 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 965528 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 965528 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 965528 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 965528 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 965535 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 965535 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5602 WHERE pla_enc = 965535 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 965535 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5602 WHERE pla_enc = 965535 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 965535 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 965540 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 965540 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 966024 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82123 WHERE pla_enc = 966024 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9502 WHERE pla_enc = 966024 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 81132 WHERE pla_enc = 966024 and pla_hog = 1 and pla_mie = 2;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 966034 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 966034 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 966034 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 966034 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 966035 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 966035 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 966040 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 966040 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 966040 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 20323 WHERE pla_enc = 966040 and pla_hog = 1 and pla_mie = 4;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 966040 and pla_hog = 1 and pla_mie = 9;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 966040 and pla_hog = 1 and pla_mie = 9;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 966044 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72313 WHERE pla_enc = 966044 and pla_hog = 1 and pla_mie = 1;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3200 WHERE pla_enc = 966046 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 966046 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 966046 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 966046 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 966053 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 966053 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 966054 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53113 WHERE pla_enc = 966054 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 966054 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53113 WHERE pla_enc = 966054 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 990001 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 990001 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990003 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990003 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 990024 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53313 WHERE pla_enc = 990024 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 990024 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53313 WHERE pla_enc = 990024 and pla_hog = 1 and pla_mie = 3;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990038 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990038 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9301 WHERE pla_enc = 990038 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41313 WHERE pla_enc = 990038 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 990041 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10333 WHERE pla_enc = 990041 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 990051 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 990051 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 990054 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30133 WHERE pla_enc = 990054 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 990054 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 990054 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990065 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990065 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 990065 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 990065 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 990070 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 990070 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990074 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990074 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990090 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990090 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 990090 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 990090 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990093 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990093 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5602 WHERE pla_enc = 990097 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53113 WHERE pla_enc = 990097 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990104 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990104 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990111 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990111 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 990111 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 990111 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990112 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990112 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 990118 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53113 WHERE pla_enc = 990118 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 990118 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 990118 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 990118 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53313 WHERE pla_enc = 990118 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1009 WHERE pla_enc = 990118 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 990118 and pla_hog = 1 and pla_mie = 4;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9609 WHERE pla_enc = 990129 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 58114 WHERE pla_enc = 990129 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4904 WHERE pla_enc = 990129 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36314 WHERE pla_enc = 990129 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 990132 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34313 WHERE pla_enc = 990132 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2500 WHERE pla_enc = 990132 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 990132 and pla_hog = 1 and pla_mie = 3;
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 990132 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53314 WHERE pla_enc = 990132 and pla_hog = 1 and pla_mie = 4;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 5601 WHERE pla_enc = 990132 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t24_cod = 53313 WHERE pla_enc = 990132 and pla_hog = 1 and pla_mie = 5;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4502 WHERE pla_enc = 990132 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82314 WHERE pla_enc = 990132 and pla_hog = 1 and pla_mie = 6;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4502 WHERE pla_enc = 990132 and pla_hog = 1 and pla_mie = 7;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82313 WHERE pla_enc = 990132 and pla_hog = 1 and pla_mie = 7;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 990136 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 990136 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 5202 WHERE pla_enc = 990136 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 36314 WHERE pla_enc = 990136 and pla_hog = 1 and pla_mie = 3;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990137 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990137 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 990137 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 990137 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 990140 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53113 WHERE pla_enc = 990140 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 990140 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34323 WHERE pla_enc = 990140 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 990144 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 990144 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 990144 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72313 WHERE pla_enc = 990144 and pla_hog = 1 and pla_mie = 2;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 4502 WHERE pla_enc = 990144 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 990144 and pla_hog = 1 and pla_mie = 3;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 990144 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 990144 and pla_hog = 1 and pla_mie = 4;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990146 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990146 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8700 WHERE pla_enc = 990146 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 990146 and pla_hog = 1 and pla_mie = 2;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 8101 WHERE pla_enc = 990151 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 990151 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 990151 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 990151 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 7800 WHERE pla_enc = 990162 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 990162 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 990162 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 990162 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 990166 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55114 WHERE pla_enc = 990166 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 990166 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 990166 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9409 WHERE pla_enc = 990166 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 990166 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3300 WHERE pla_enc = 990173 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 990173 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 990176 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 990176 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9609 WHERE pla_enc = 990190 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56114 WHERE pla_enc = 990190 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990194 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990194 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 990198 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 990198 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3800 WHERE pla_enc = 990198 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 35314 WHERE pla_enc = 990198 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4808 WHERE pla_enc = 990200 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 990200 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3200 WHERE pla_enc = 990212 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 990212 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990222 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990222 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8401 WHERE pla_enc = 990227 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10313 WHERE pla_enc = 990227 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8401 WHERE pla_enc = 990227 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10314 WHERE pla_enc = 990227 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 990227 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 990227 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 990227 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 990227 and pla_hog = 1 and pla_mie = 4;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 990227 and pla_hog = 1 and pla_mie = 8;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 990227 and pla_hog = 1 and pla_mie = 8;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8101 WHERE pla_enc = 990227 and pla_hog = 1 and pla_mie = 9;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 990227 and pla_hog = 1 and pla_mie = 9;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 990227 and pla_hog = 1 and pla_mie = 12;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56314 WHERE pla_enc = 990227 and pla_hog = 1 and pla_mie = 12;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 990227 and pla_hog = 1 and pla_mie = 13;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 990227 and pla_hog = 1 and pla_mie = 13;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 990228 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 990228 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990242 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990242 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 8101 WHERE pla_enc = 990242 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 56314 WHERE pla_enc = 990242 and pla_hog = 1 and pla_mie = 2;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 990246 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82112 WHERE pla_enc = 990246 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9503 WHERE pla_enc = 990250 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82112 WHERE pla_enc = 990250 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990250 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990250 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 990250 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53313 WHERE pla_enc = 990250 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5602 WHERE pla_enc = 990251 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 990251 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9609 WHERE pla_enc = 990251 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56114 WHERE pla_enc = 990251 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 990257 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 990257 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 990257 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53113 WHERE pla_enc = 990257 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8401 WHERE pla_enc = 990257 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 10314 WHERE pla_enc = 990257 and pla_hog = 1 and pla_mie = 3;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 1400 WHERE pla_enc = 990263 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80323 WHERE pla_enc = 990263 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 990263 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 990263 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 990269 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 990269 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9302 WHERE pla_enc = 990269 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 47314 WHERE pla_enc = 990269 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990269 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990269 and pla_hog = 1 and pla_mie = 4;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 990273 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 990273 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 990273 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 990273 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 990284 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 990284 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 990284 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 990284 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 990286 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 990286 and pla_hog = 1 and pla_mie = 2;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 990290 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72313 WHERE pla_enc = 990290 and pla_hog = 1 and pla_mie = 2;		
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990295 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990295 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 990297 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 990297 and pla_hog = 1 and pla_mie = 2;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4810 WHERE pla_enc = 990297 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 30313 WHERE pla_enc = 990297 and pla_hog = 1 and pla_mie = 4;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990301 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990301 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 990304 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80313 WHERE pla_enc = 990304 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 990304 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 990304 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990317 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990317 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990321 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990321 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 990331 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80333 WHERE pla_enc = 990331 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990331 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990331 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990332 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990332 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4810 WHERE pla_enc = 990332 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 30313 WHERE pla_enc = 990332 and pla_hog = 1 and pla_mie = 2;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 4810 WHERE pla_enc = 990332 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 30313 WHERE pla_enc = 990332 and pla_hog = 1 and pla_mie = 3;		
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 990332 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 990332 and pla_hog = 1 and pla_mie = 4;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 7800 WHERE pla_enc = 990336 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32314 WHERE pla_enc = 990336 and pla_hog = 1 and pla_mie = 3;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 990339 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 990339 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4803 WHERE pla_enc = 990339 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 990339 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 990341 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 990341 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 990343 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 990343 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 990343 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 990343 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 990343 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 81333 WHERE pla_enc = 990343 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 990347 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 990347 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 990351 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 990351 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 990374 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 990374 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 990374 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 990374 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 990380 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 990380 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 990384 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 990384 and pla_hog = 1 and pla_mie = 1;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4810 WHERE pla_enc = 990384 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 36314 WHERE pla_enc = 990384 and pla_hog = 1 and pla_mie = 3;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990386 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990386 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 990404 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 990404 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990406 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990406 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4904 WHERE pla_enc = 990406 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36314 WHERE pla_enc = 990406 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9602 WHERE pla_enc = 990413 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 57313 WHERE pla_enc = 990413 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 990413 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 32323 WHERE pla_enc = 990413 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 990413 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34323 WHERE pla_enc = 990413 and pla_hog = 1 and pla_mie = 4;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 990419 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33314 WHERE pla_enc = 990419 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990423 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990423 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 990423 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 990423 and pla_hog = 1 and pla_mie = 2;
UPDATE encu.plana_i1_ SET pla_t23_cod = 4804 WHERE pla_enc = 990423 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t24_cod = 10313 WHERE pla_enc = 990423 and pla_hog = 1 and pla_mie = 3;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5602 WHERE pla_enc = 990425 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 990425 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5602 WHERE pla_enc = 990425 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 990425 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990432 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990432 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5300 WHERE pla_enc = 990436 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 35123 WHERE pla_enc = 990436 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 990436 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 990436 and pla_hog = 1 and pla_mie = 3;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990438 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990438 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 990438 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 990438 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 990438 and pla_hog = 1 and pla_mie = 8;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 990438 and pla_hog = 1 and pla_mie = 8;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 990439 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30113 WHERE pla_enc = 990439 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 990448 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 990448 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990451 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990451 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 990451 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 990451 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990453 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990453 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 990453 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 990453 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 990453 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 990453 and pla_hog = 1 and pla_mie = 3;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 990454 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 990454 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 990454 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 990454 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 995027 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 995027 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 995074 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80323 WHERE pla_enc = 995074 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 995074 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 995074 and pla_hog = 1 and pla_mie = 2;
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 995161 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 995161 and pla_hog = 1 and pla_mie = 1;		
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 995164 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53313 WHERE pla_enc = 995164 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 995324 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 995324 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 995324 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 995324 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5601 WHERE pla_enc = 995324 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 53314 WHERE pla_enc = 995324 and pla_hog = 1 and pla_mie = 3;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4803 WHERE pla_enc = 995522 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 30313 WHERE pla_enc = 995522 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 995522 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 995522 and pla_hog = 1 and pla_mie = 2;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9301 WHERE pla_enc = 995538 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41313 WHERE pla_enc = 995538 and pla_hog = 1 and pla_mie = 1;
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 995614 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55114 WHERE pla_enc = 995614 and pla_hog = 1 and pla_mie = 1;		
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5202 WHERE pla_enc = 995614 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82313 WHERE pla_enc = 995614 and pla_hog = 1 and pla_mie = 3;
UPDATE encu.plana_i1_ SET pla_t23_cod = 8600 WHERE pla_enc = 995614 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 57112 WHERE pla_enc = 995614 and pla_hog = 1 and pla_mie = 4;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6400 WHERE pla_enc = 995614 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 995614 and pla_hog = 1 and pla_mie = 5;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8502 WHERE pla_enc = 995710 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41112 WHERE pla_enc = 995710 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 996009 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 996009 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 3300 WHERE pla_enc = 996009 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80112 WHERE pla_enc = 996009 and pla_hog = 1 and pla_mie = 4;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2500 WHERE pla_enc = 996031 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 996031 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 996031 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 996031 and pla_hog = 1 and pla_mie = 2;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 2500 WHERE pla_enc = 996031 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80314 WHERE pla_enc = 996031 and pla_hog = 1 and pla_mie = 4;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 996031 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t41_cod = 82314 WHERE pla_enc = 996031 and pla_hog = 1 and pla_mie = 6;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 996031 and pla_hog = 1 and pla_mie = 7;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 996031 and pla_hog = 1 and pla_mie = 7;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 1400 WHERE pla_enc = 996060 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 80113 WHERE pla_enc = 996060 and pla_hog = 1 and pla_mie = 1;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8000 WHERE pla_enc = 996087 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 47313 WHERE pla_enc = 996087 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 996087 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 996087 and pla_hog = 1 and pla_mie = 2;		
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 996100 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 996100 and pla_hog = 1 and pla_mie = 1;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 996115 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 996115 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
			
			
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 996214 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 996214 and pla_hog = 1 and pla_mie = 1;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 996214 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 996214 and pla_hog = 1 and pla_mie = 2;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 4000 WHERE pla_enc = 996214 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 72314 WHERE pla_enc = 996214 and pla_hog = 1 and pla_mie = 4;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 6800 WHERE pla_enc = 996215 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 30313 WHERE pla_enc = 996215 and pla_hog = 1 and pla_mie = 1;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 996220 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 996220 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 996220 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 996220 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 996220 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 996220 and pla_hog = 1 and pla_mie = 5;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 996220 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 996220 and pla_hog = 1 and pla_mie = 6;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 996220 and pla_hog = 1 and pla_mie = 7;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 996220 and pla_hog = 1 and pla_mie = 7;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 996220 and pla_hog = 1 and pla_mie = 8;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 996220 and pla_hog = 1 and pla_mie = 8;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 996244 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 996244 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8501 WHERE pla_enc = 996298 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 41313 WHERE pla_enc = 996298 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4903 WHERE pla_enc = 996298 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 34323 WHERE pla_enc = 996298 and pla_hog = 1 and pla_mie = 2;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 996302 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 996302 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 9700 WHERE pla_enc = 996302 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 55314 WHERE pla_enc = 996302 and pla_hog = 1 and pla_mie = 2;		
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 996302 and pla_hog = 1 and pla_mie = 5;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 996302 and pla_hog = 1 and pla_mie = 5;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 996302 and pla_hog = 1 and pla_mie = 6;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 996302 and pla_hog = 1 and pla_mie = 6;
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 996312 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 996312 and pla_hog = 1 and pla_mie = 2;
			
UPDATE encu.plana_i1_ SET pla_t23_cod = 1400 WHERE pla_enc = 996312 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80323 WHERE pla_enc = 996312 and pla_hog = 1 and pla_mie = 4;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 996330 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 996330 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 6400 WHERE pla_enc = 996330 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 30313 WHERE pla_enc = 996330 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 5202 WHERE pla_enc = 996330 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 36314 WHERE pla_enc = 996330 and pla_hog = 1 and pla_mie = 3;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4804 WHERE pla_enc = 996388 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 56203 WHERE pla_enc = 996388 and pla_hog = 1 and pla_mie = 1;
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 8600 WHERE pla_enc = 996420 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 40312 WHERE pla_enc = 996420 and pla_hog = 1 and pla_mie = 1;
UPDATE encu.plana_i1_ SET pla_t23_cod = 1400 WHERE pla_enc = 996420 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t24_cod = 80313 WHERE pla_enc = 996420 and pla_hog = 1 and pla_mie = 2;		
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 996420 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 996420 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 996420 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 996420 and pla_hog = 1 and pla_mie = 4;
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4810 WHERE pla_enc = 996458 and pla_hog = 1 and pla_mie = 1;	UPDATE encu.plana_i1_ SET pla_t41_cod = 33114 WHERE pla_enc = 996458 and pla_hog = 1 and pla_mie = 1;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 996458 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72113 WHERE pla_enc = 996458 and pla_hog = 1 and pla_mie = 2;
			
			
			
			
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 998168 and pla_hog = 1 and pla_mie = 2;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72314 WHERE pla_enc = 998168 and pla_hog = 1 and pla_mie = 2;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 4000 WHERE pla_enc = 998168 and pla_hog = 1 and pla_mie = 3;	UPDATE encu.plana_i1_ SET pla_t41_cod = 72313 WHERE pla_enc = 998168 and pla_hog = 1 and pla_mie = 3;
		UPDATE encu.plana_i1_ SET pla_t37_cod = 9700 WHERE pla_enc = 998168 and pla_hog = 1 and pla_mie = 4;	UPDATE encu.plana_i1_ SET pla_t41_cod = 55314 WHERE pla_enc = 998168 and pla_hog = 1 and pla_mie = 4;
