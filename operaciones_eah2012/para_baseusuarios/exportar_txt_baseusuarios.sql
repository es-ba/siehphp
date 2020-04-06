--Exportar tablas base usuarios EAH2012 a archivos de texto, el separador solicitado es ';'

--a)Con copy hay que tener la carpeta definida donde se van a guardar los archivos
  copy bu.eah12_bu_viv to  'C:\Hecho\yeah\fuentes\para_baseusuarios\salida\EAH12_BU_VIV.txt' delimiter ';' null '' csv header;
  copy bu.eah12_bu_ind to  'C:\Hecho\yeah\fuentes\para_baseusuarios\salida\EAH12_BU_IND.txt' delimiter ';' null '' csv header;

--b)Se puede hacer también utilizando los siguientes scripts dentro de pgadmin, para no usar el copy.
--Al exportar los archivos elegir la opción no quoting , column separator ';' y tildar column names;

--eah12_bu_viv
  SELECT *
    FROM bu.eah12_bu_viv
    ORDER BY id, nhogar;
 
--eah12_bu_ind
  SELECT *
    FROM bu.eah12_bu_ind
    ORDER BY id, nhogar, miembro;
    
--eah12_bu_rama
  SELECT *
    FROM bu.eah12_bu_rama
    ORDER BY codigo_rama;
    
--eah12_bu_ocupacion
  SELECT *
    FROM bu.eah12_bu_ocupacion
    ORDER BY codigo_ocupacion;
   
  