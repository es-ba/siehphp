select top 10 c.id_marco as tem_id_marco, c.COMUNAS as tem_comuna, c.clado as tem_clado, c.ccodigo as tem_ccodigo, c.cnombre as tem_cnombre,
  c.hn as tem_hn , c.hp as tem_hp, c.hd as tem_hd, c.hab as tem_hab, c.h4 as tem_h4, c.usp as tem_usp, 
  c.barrio as tem_barrio, c.ident_edif as tem_ident_edif, c.obs as tem_obs, 
  c.frac_comun as tem_frac_comun, c.radio_comu as tem_radio_comu, c.mza_comuna as tem_mza_comuna,
  '3' as tem_dominio, c.marco as tem_marco, a.zona as tem_zona, 1 as tem_participacion, 
   a.estrato_ing as tem_estrato, a.descripcion as tem_areaup, 
  '/////' as basta,  *
  FROM [BD_Marco].[dbo].[tbMuestra] m 
       INNER JOIN [BD_Marco].[dbo].[tbOperativos] o ON m.idOperativo = o.idOperativo 
       INNER JOIN [BD_Marco].[dbo].[tbSeleccionVivienda] s ON m.id = s.idMuestra
       INNER JOIN [BD_Marco].[dbo].[TbComunas] c ON c.Id_Marco = s.idTbComunas
	   INNER JOIN [BD_Marco].[dbo].[tblRelComunasAreaup] ac ON ac.idComuna = c.Id_Marco
	   INNER JOIN [BD_Marco].[dbo].[tbAreasUP] a ON a.idAreaUP = ac.idAreaUP 
  WHERE o.codigo in ('EAH','ETOI') and m.año=2017 and m.trimestre=4
  order by c.id_marco
  ;