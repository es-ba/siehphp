select m.id, o.codigo, m.año, m.trimestre 
      , count(*)
  FROM [BD_Marco].[dbo].[tbMuestra] m 
       INNER JOIN [BD_Marco].[dbo].[tbOperativos] o ON m.idOperativo = o.idOperativo 
       INNER JOIN [BD_Marco].[dbo].[tbSeleccionVivienda] s ON m.id = s.idMuestra
  GROUP BY m.id, o.codigo, m.año, m.trimestre
  ORDER BY 1,2,3,4