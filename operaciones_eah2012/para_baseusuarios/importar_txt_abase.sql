--Sube información de los archivos de la EAH2012 a base sie_db en postgresql
--Los archivos originales tienen extensión .dbf, se los pasa a texto delimitado por tab y posteriormente se cambia el delimitador a ;
copy bu.eah12_bu_viv from  'C:\Hecho\yeah\fuentes\para_baseusuarios\EAH12_BU_VIV.txt' delimiter ';' null '' csv header ;
copy bu.eah12_bu_ind from  'C:\Hecho\yeah\fuentes\para_baseusuarios\EAH12_BU_IND.txt' delimiter ';' null '' csv header ;    