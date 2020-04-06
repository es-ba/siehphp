--tem
select count(*)
from encu.tem
where participacion=1

select tem_clado, count(*)
                         from encu.tem
                         where tem_participacion=1
                         group by 1
                         order by 1


--buscar los campos de la tabla tem en etoi162
SELECT substr(column_name,5) as campo,* --table_name, column_name, substr(column_name,5) as infovariable, data_type
                         FROM information_schema.columns
                         WHERE table_schema='encu' and table_name ='tem'
                         order by ordinal_position

-- tbComunas en la base tbmarco del servidor remoto
SELECT TOP 1000 [Id_Marco]
      ,[IDD]
      ,[DPTO]
      ,[FRAC]
      ,[RADIO]
      ,[MZA]
      ,[CLADO]
      ,[SEG]
      ,[NCED]
      ,[HN]
      ,[ORDEN_ALTURA]
      ,[HP]
      ,[PisoAux]
      ,[HD]
      ,[H0]
      ,[H4]
      ,[H1]
      ,[USP]
      ,[CCODIGO]
      ,[CNOMBRE]
      ,[OBS]
      ,[IDENT_EDIF]
      ,[IdCuerpo]
      ,[REP]
      ,[BARRIO]
      ,[CUIT]
      ,[RAMA_ACT]
      ,[NOMB_INST]
      ,[TOT_HAB]
      ,[PZAS]
      ,[HAB]
      ,[ELI]
      ,[TE]
      ,[FUENTE_ant]
      ,[FUENTE]
      ,[FEC_MOD]
      ,[COMUNAS]
      ,[FRAC_COMUN]
      ,[RADIO_COMU]
      ,[MZA_COMUNA]
      ,[UP_COMUNA]
      ,[anio_list_ant]
      ,[anio_list]
      ,[REPLICA_CM_2007]
      ,[MARCO]
      ,[MARCO_ANIO]
      ,[nro_orden]
      ,[Incluido]
      ,[Operacion]
      ,[Usuario]
      ,[Ok]
      ,[yearFuente]
      ,[idProcedencia]
      ,[codOrd]
      ,[idPasillo]
      ,[nroCasa]
  FROM [BD_Marco].[dbo].[TbComunas]
 
-- saco enc y tlg  ,'obs_historico'

'id_marco'
,'comuna'
,'replica'
,'up'
,'lote'
,'clado'
,'ccodigo'
,'cnombre'
,'hn'
,'hp'
,'hd'
,'hab'
,'h4'
,'usp'
,'barrio'
,'ident_edif'
,'obs'
,'frac_comun'
,'radio_comu'
,'mza_comuna'
,'dominio'
,'marco'
,'titular'
,'zona'
,'lote2011'
,'para_asignar'
,'participacion'
,'codpos'
,'etiquetas'
,'tipounidad'
,'tot_hab'
,'estrato'
,'fexp'
,'areaup'
,'trimestre'
,'semana'
,'rotaci_n_etoi'
,'rotaci_n_eah'
,'idtipounidad'
,'h1_mues'
,'idcuerpo'
,'cuerpo'
,'cuit'
,'rama_act'
,'nomb_inst'
,'pzas'
,'te'
,'idprocedencia'
,'procedencia'
,'yearfuente'
,'anio_list'
,'marco_anio'
,'nro_orden'
,'operacion'
,'area'
,'reserva'
,'up_comuna'
,'h4_mues'
,'ups'
,'sel_etoi14_villa'
,'obs_campo'
,'inq_tot_hab'
,'inq_ocu_flia'

-- consultar el catalogo
SELECT [TABLE_CATALOG]
      ,[TABLE_SCHEMA]
      ,[TABLE_NAME]
      ,[COLUMN_NAME]
      ,[ORDINAL_POSITION]
      ,[COLUMN_DEFAULT]
      ,[IS_NULLABLE]
      ,[DATA_TYPE]
      ,[CHARACTER_MAXIMUM_LENGTH]
      ,[CHARACTER_OCTET_LENGTH]
      ,[NUMERIC_PRECISION]
      ,[NUMERIC_PRECISION_RADIX]
      ,[NUMERIC_SCALE]
      ,[DATETIME_PRECISION]
      ,[CHARACTER_SET_CATALOG]
      ,[CHARACTER_SET_SCHEMA]
      ,[CHARACTER_SET_NAME]
      ,[COLLATION_CATALOG]
      ,[COLLATION_SCHEMA]
      ,[COLLATION_NAME]
      ,[DOMAIN_CATALOG]
      ,[DOMAIN_SCHEMA]
      ,[DOMAIN_NAME]
  FROM [BD_Marco].[INFORMATION_SCHEMA].[COLUMNS]
  where table_catalog='bd_marco' and table_schema='dbo' and  COLUMN_NAME in (
    'id_marco'
    ,'comuna'
    ,'replica'
    ,'up'
    ,'lote'
    ,'clado'
    ,'ccodigo'
    ,'cnombre'
    ,'hn'
    ,'hp'
    ,'hd'
    ,'hab'
    ,'h4'
    ,'usp'
    ,'barrio'
    ,'ident_edif'
    ,'obs'
    ,'frac_comun'
    ,'radio_comu'
    ,'mza_comuna'
    ,'dominio'
    ,'marco'
    ,'titular'
    ,'zona'
    ,'lote2011'
    ,'para_asignar'
    ,'participacion'
    ,'codpos'
    ,'etiquetas'
    ,'tipounidad'
    ,'tot_hab'
    ,'estrato'
    ,'fexp'
    ,'areaup'
    ,'trimestre'
    ,'semana'
    ,'rotaci_n_etoi'
    ,'rotaci_n_eah'
    ,'idtipounidad'
    ,'h1_mues'
    ,'idcuerpo'
    ,'cuerpo'
    ,'cuit'
    ,'rama_act'
    ,'nomb_inst'
    ,'pzas'
    ,'te'
    ,'idprocedencia'
    ,'procedencia'
    ,'yearfuente'
    ,'anio_list'
    ,'marco_anio'
    ,'nro_orden'
    ,'operacion'
    ,'area'
    ,'reserva'
    ,'up_comuna'
    ,'h4_mues'
    ,'ups'
    ,'sel_etoi14_villa'
    ,'obs_campo'
    ,'inq_tot_hab'
    ,'inq_ocu_flia'
)
order by column_name, table_name;

-- por tabla
SELECT  [TABLE_CATALOG]
      ,[TABLE_SCHEMA]
      ,[TABLE_NAME]
      ,count(*) cant
  FROM [BD_Marco].[INFORMATION_SCHEMA].[COLUMNS]
  where table_catalog='bd_marco' and table_schema='dbo' and  COLUMN_NAME in (
  'id_marco'
,'comuna'
,'replica'
,'up'
,'lote'
,'clado'
,'ccodigo'
,'cnombre'
,'hn'
,'hp'
,'hd'
,'hab'
,'h4'
,'usp'
,'barrio'
,'ident_edif'
,'obs'
,'frac_comun'
,'radio_comu'
,'mza_comuna'
,'dominio'
,'marco'
,'titular'
,'zona'
,'lote2011'
,'para_asignar'
,'participacion'
,'codpos'
,'etiquetas'
,'tipounidad'
,'tot_hab'
,'estrato'
,'fexp'
,'areaup'
,'trimestre'
,'semana'
,'rotaci_n_etoi'
,'rotaci_n_eah'
,'idtipounidad'
,'h1_mues'
,'idcuerpo'
,'cuerpo'
,'cuit'
,'rama_act'
,'nomb_inst'
,'pzas'
,'te'
,'idprocedencia'
,'procedencia'
,'yearfuente'
,'anio_list'
,'marco_anio'
,'nro_orden'
,'operacion'
,'area'
,'reserva'
,'up_comuna'
,'h4_mues'
,'ups'
,'sel_etoi14_villa'
,'obs_campo'
,'inq_tot_hab'
,'inq_ocu_flia'
)
group by TABLE_CATALOG
      ,TABLE_SCHEMA
      ,TABLE_NAME
order by cant desc;


-- columnas que no estan en la base db_marco
select * from 
(select 'tem' base , 'id_marco'
columna union select 'tem' base,'comuna'
columna union select 'tem' base,'replica'
columna union select 'tem' base,'up'
columna union select 'tem' base,'lote'
columna union select 'tem' base,'clado'
columna union select 'tem' base,'ccodigo'
columna union select 'tem' base,'cnombre'
columna union select 'tem' base,'hn'
columna union select 'tem' base,'hp'
columna union select 'tem' base,'hd'
columna union select 'tem' base,'hab'
columna union select 'tem' base,'h4'
columna union select 'tem' base,'usp'
columna union select 'tem' base,'barrio'
columna union select 'tem' base,'ident_edif'
columna union select 'tem' base,'obs'
columna union select 'tem' base,'frac_comun'
columna union select 'tem' base,'radio_comu'
columna union select 'tem' base,'mza_comuna'
columna union select 'tem' base,'dominio'
columna union select 'tem' base,'marco'
columna union select 'tem' base,'titular'
columna union select 'tem' base,'zona'
columna union select 'tem' base,'lote2011'
columna union select 'tem' base,'para_asignar'
columna union select 'tem' base,'participacion'
columna union select 'tem' base,'codpos'
columna union select 'tem' base,'etiquetas'
columna union select 'tem' base,'tipounidad'
columna union select 'tem' base,'tot_hab'
columna union select 'tem' base,'estrato'
columna union select 'tem' base,'fexp'
columna union select 'tem' base,'areaup'
columna union select 'tem' base,'trimestre'
columna union select 'tem' base,'semana'
columna union select 'tem' base,'rotaci_n_etoi'
columna union select 'tem' base,'rotaci_n_eah'
columna union select 'tem' base,'idtipounidad'
columna union select 'tem' base,'h1_mues'
columna union select 'tem' base,'idcuerpo'
columna union select 'tem' base,'cuerpo'
columna union select 'tem' base,'cuit'
columna union select 'tem' base,'rama_act'
columna union select 'tem' base,'nomb_inst'
columna union select 'tem' base,'pzas'
columna union select 'tem' base,'te'
columna union select 'tem' base,'idprocedencia'
columna union select 'tem' base,'procedencia'
columna union select 'tem' base,'yearfuente'
columna union select 'tem' base,'anio_list'
columna union select 'tem' base,'marco_anio'
columna union select 'tem' base,'nro_orden'
columna union select 'tem' base,'operacion'
columna union select 'tem' base,'area'
columna union select 'tem' base,'reserva'
columna union select 'tem' base,'up_comuna'
columna union select 'tem' base,'h4_mues'
columna union select 'tem' base,'ups'
columna union select 'tem' base,'sel_etoi14_villa'
columna union select 'tem' base,'obs_campo'
columna union select 'tem' base,'inq_tot_hab'
columna union select 'tem' base,'inq_ocu_flia') as t
 where not exists (SELECT  [TABLE_CATALOG] base
      
      ,[COLUMN_NAME] AS columna
  FROM [BD_Marco].[INFORMATION_SCHEMA].[COLUMNS]
  where table_catalog='bd_marco' and table_schema='dbo' and  COLUMN_NAME= t.columna )

--filas de comuna seleccionadas para ETOI153
SELECT  [Id_Marco]
      ,[IDD]
      ,[DPTO]
      ,[FRAC]
      ,[RADIO]
      ,[MZA]
      ,[CLADO]
      ,[SEG]
      ,[NCED]
      ,[HN]
      ,[ORDEN_ALTURA]
      ,[HP]
      ,[PisoAux]
      ,[HD]
      ,[H0]
      ,[H4]
      ,[H1]
      ,[USP]
      ,[CCODIGO]
      ,[CNOMBRE]
      ,[OBS]
      ,[IDENT_EDIF]
      ,[IdCuerpo]
      ,[REP]
      ,[BARRIO]
      ,[CUIT]
      ,[RAMA_ACT]
      ,[NOMB_INST]
      ,[TOT_HAB]
      ,[PZAS]
      ,[HAB]
      ,[ELI]
      ,[TE]
      ,[FUENTE_ant]
      ,[FUENTE]
      ,[FEC_MOD]
      ,[COMUNAS]
      ,[FRAC_COMUN]
      ,[RADIO_COMU]
      ,[MZA_COMUNA]
      ,[UP_COMUNA]
      ,[anio_list_ant]
      ,[anio_list]
      ,[REPLICA_CM_2007]
      ,[MARCO]
      ,[MARCO_ANIO]
      ,[nro_orden]
      ,[Incluido]
      ,[Operacion]
      ,[Usuario]
      ,[Ok]
      ,[yearFuente]
      ,[idProcedencia]
      ,[codOrd]
      ,[idPasillo]
      ,[nroCasa]
  FROM [BD_Marco].[dbo].[TbComunas] c
  join [BD_Marco].[dbo].[tbSeleccionVivienda] v on  c.id_marco = v.idtbcomunas
  where v.idmuestra=8