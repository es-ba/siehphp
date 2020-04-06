--EAH2012 desarrollo esquema proc
--
copy proc.eah_hog_2012 from  'C:\base_usuarios\EAHsolo2012_Ultima_Version\base_hog2012.txt' delimiter '|' null '' csv header ;
copy proc.eah_ind_2012 from  'C:\base_usuarios\EAHsolo2012_Ultima_Version\base_ind2012.txt' delimiter '|' null '' csv header ;    

/* Intento hacerlo con scripts de inserción pero al ser tan grande el archivo de individuales 454 columnas y 15452 filas se corta y da el error out of memory
/* Para copiar desde el pgadmin del servidor, previamente reviso y saco los caracteres especiales que puedan llegar a molestar */
copy proc.eah_ind_2012 from  '\\10.32.72.140\\base_usuarios\\EAHsolo2012_Ultima_Version\\tarea\\base_ind2012.txt' delimiter '|' null '' csv header ;