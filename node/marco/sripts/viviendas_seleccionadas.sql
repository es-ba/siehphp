select *
  FROM [BD_Marco].[dbo].[tbMuestra] m 
       INNER JOIN [BD_Marco].[dbo].[tbOperativos] o ON m.idOperativo = o.idOperativo 
       INNER JOIN [BD_Marco].[dbo].[tbSeleccionVivienda] s ON m.id = s.idMuestra
       INNER JOIN [BD_Marco].[dbo].[TbComunas] c ON c.Id_Marco = s.idTbComunas
  WHERE o.codigo='OtrosOp' and m.año=2016 and m.trimestre=0
