select c.id_marco as tem_id_marco, c.COMUNAS as tem_comuna, c.clado as tem_clado, lc.ccodigo as tem_ccodigo, cc.cnombre as tem_cnombre,
  c.ccodigo as tem_ccodigo2, c.cnombre as tem_cnombre2,
  c.hn as tem_hn , c.hp as tem_hp, c.hd as tem_hd, c.hab as tem_hab, c.h4 as tem_h4, c.usp as tem_usp, 
  c.barrio as tem_barrio, c.ident_edif as tem_ident_edif, c.obs as tem_obs, 
  c.frac_comun as tem_frac_comun, c.radio_comu as tem_radio_comu, c.mza_comuna as tem_mza_comuna,
  '3' as tem_dominio, c.marco as tem_marco, a.zona as tem_zona, 1 as tem_participacion, 
   a.estrato_ing as tem_estrato, a.descripcion as tem_areaup, lc.CodPostal as tem_codpos
   , 4 as tem_rotaci_n_etoi
  ,'/////' as basta,  *
  FROM /* [BD_Marco].[dbo].[tbMuestra] m 
       INNER JOIN [BD_Marco].[dbo].[tbOperativos] o ON m.idOperativo = o.idOperativo 
       INNER JOIN [BD_Marco].[dbo].[tbSeleccionVivienda] s ON m.id = s.idMuestra
       INNER JOIN [BD_Marco].[dbo].[TbComunas] c ON c.Id_Marco = s.idTbComunas
	   */
	   [BD_Marco].[dbo].[TbComunas] c
	   INNER JOIN [BD_Marco].[dbo].[tblRelComunasAreaup] ac ON ac.idComuna = c.Id_Marco
	   INNER JOIN [BD_Marco].[dbo].[tbAreasUP] a ON a.idAreaUP = ac.idAreaUP 
	   INNER JOIN [BD_Marco].[dbo].[tblLados] lc ON lc.comuna = c.COMUNAS 
         AND lc.comFraccion = c.FRAC_COMUN
		 AND lc.comRadio = c.RADIO_COMU
		 AND lc.comManzana = c.MZA_COMUNA
		 AND lc.indDpto = c.DPTO
		 AND lc.indFrac = c.FRAC
		 AND lc.indRad = c.RADIO
		 AND lc.indMza = c.MZA
		 AND lc.cLado = c.CLADO
	   INNER JOIN [BD_Marco].[dbo].[tbCalles] cc ON lc.cCodigo = cc.Ccodigo
  WHERE c.id_marco in (
110748
,329841
,330244
,368337
,377114
,391745
,405386
,405708
,418780
,437402
,446222
,452120
,452372
,460727
,461024
,462635
,464323
,467387
,467599
,472333
,472336
,520728
,552219
,557403
,560524
,579240
,579347
,584564
,604677
,604996
,647072
,744352
,1066417
,1070878
,1081441
,1084451
,1122540
,1122668
,1127779
,1127890
,1201109
,1205826
,1206076
,1287483
,1374162
,1435656
,1446306
,1469305
,1472950
,1476845
,1477069
,1480284
,1480514
,1510450
,1517200
,1522996
,1531232
,1835642
,1835753
,1836201
,1840287
,1888697
,1911671
,1911874
,1916444
,1916610
,1921978
,1957134
,1973927
,2023577
,2023594
,2083492
,2095126
,2143636
,2144442
,2146567
,2147523
,2150892
,2160531
,2171057
,2188223
,2188226
,2193764
,2206231
,2206236
,2207608
,2207610
,2208123
,2208715
,2208936
,2208943
,2209434
,2210197
,2212806
,2212880
,2213767
,2213777
,2215075
,2215078
,2215471
,2215545
,2216739
,1527173
,2061442
,1458606
,1458775
,1453164
,1629081
,1454882
,1455133
,2176497
,1469683
,1520203
,1486238
,1521467
,1494014
,1494307
,2052036
,1478772
,106254
,113278
,112056
,2145467
,2062339
,1948115
,464011
,2208096
,1634775
,2062738
,441153
,435952
,467334
,445518
,2208439
,413885
,2063353
,1941138
,2145633
,463800
,424086
,427653
,462105
,2217527
,448996
,1956539
,2184722
,457639
,459917
,2145213
,1119930
,1122117
,1128848
,1074671
,2089732
,2151771
,2211143
,1934647
,1934631
,1932049
,1858509
,1903871
,1904108
,1862117
,1862302
,1876790
,1885558
,1924895
,2102883
,509245
,2153952
,512601
,2083730
,495939
,2212017
,588104
,594945
,609303
,570460
,2214788
,2214838
,2184392
,975380
,2166907
,2214658
,2193821
,1315666
,1377191
,2211616
,2217908
,1619321
,2216681
,1620190
,2216746
,775797
,2159609
,1992317
,2199956
,1271120
,1271322
,2072041
,1246285
,2076218
,1233044
,1225603
,649352
)
  order by c.id_marco
  ;