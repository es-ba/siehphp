INSERT INTO cvp.selprod (producto,sel_nro, descripcion,rubro, proveedor,cantidad,observaciones,especificacion,valordesde,valorhasta,excluir) VALUES ('P0117531',1,'Arvejas', 'Almacén','Alco  Canale ','350 GR','SE PIDE DE 200 A 205 PESO ESCURIDO - SEGÚN COTO DIGITAL EQUIVALE A 350 GR LA DE 203 GR PESO ESCURRIDO','lata x 205 g.',200,205,'frescas cocidas');
INSERT INTO cvp.selprod (producto,sel_nro, descripcion,rubro, proveedor,cantidad,observaciones,especificacion,valordesde,valorhasta,excluir) VALUES ('P0117531',2,'Arvejas', 'Almacén','Arcor','300 GR','SE PIDE DE 200 A 205 PESO ESCURIDO - SEGÚN COTO DIGITAL EQUIVALE A 300 GR LA DE 200 GR PESO ESCURRIDO','lata x 205 g.',200,205,'frescas cocidas');
INSERT INTO cvp.selprod (producto,sel_nro, descripcion,rubro, proveedor,cantidad,observaciones,especificacion,valordesde,valorhasta,excluir) VALUES ('P0113211',1,'Atun Al Natural', 'Almacén','Arcor','170 GR','SE PIDE DE 110 A 125 PESO ESCURIDO - SEGÚN COTO DIGITAL EQUIVALE 170 GR LA DE 120 GR PESO ESCURRIDO','lata 125 g.',110,125,'desmenuzado, al  aceite, con aditamentos, saborizados.');
INSERT INTO cvp.selprod (producto,sel_nro, descripcion,rubro, proveedor,cantidad,observaciones,especificacion,valordesde,valorhasta,excluir) VALUES ('P0113211',2,'Atun Al Natural', 'Almacén','Gdc Argentina Grupo Calvo','170 GR','SE PIDE DE 110 A 125 PESO ESCURIDO - SEGÚN COTO DIGITAL EQUIVALE 170 GR LA DE 120 GR PESO ESCURRIDO','lata 125 g.',110,125,'desmenuzado, al  aceite, con aditamentos, saborizados.');
INSERT INTO cvp.selprod (producto,sel_nro, descripcion,rubro, proveedor,cantidad,observaciones,especificacion,valordesde,valorhasta,excluir) VALUES ('P0119311',1,'Caldo', 'Almacén','Nestlé Argentina','114 GR','SE PIDE DE 6 A 12 UNIDADES - OTRA UNIDAD DE MEDIDA EQUIVALE 12 UNIDADES LOS 114 G SEGÚN COTO DIGITAL','caja x 12 u.',6,12,'diet, sin sal, en polvo, para saborizar, aderezar');
INSERT INTO cvp.selprod (producto,sel_nro, descripcion,rubro, proveedor,cantidad,observaciones,especificacion,valordesde,valorhasta,excluir) VALUES ('P0119311',2,'Caldo', 'Almacén','Unilever','114 GR','SE PIDE DE 6 A 12 UNIDADES - OTRA UNIDAD DE MEDIDA EQUIVALE 12 UNIDADES LOS 114 G SEGÚN COTO DIGITAL','caja x 12 u.',6,12,'diet, sin sal, en polvo, para saborizar, aderezar');
INSERT INTO cvp.selprod (producto,sel_nro, descripcion,rubro, proveedor,cantidad,observaciones,especificacion,valordesde,valorhasta,excluir) VALUES ('P1213234',1,'Crema De Enjuague O Acondicionador Familiar', 'Perfumería','Alicorp Argentina S.C.A.','1 Lt','SE PIDE DE 200 A 400 ML','200 ml.',200,400,'para tratamientos especiales (extremé, renutrición, etc) para bebe');
INSERT INTO cvp.selprod (producto,sel_nro, descripcion,rubro, proveedor,cantidad,observaciones,especificacion,valordesde,valorhasta,excluir) VALUES ('P0112141',2,'Hamburguesas De Carne Tradicionales', 'Refrigerados','Quickfood','4 UN','SE PIDE DE 275 A 350 G - OTRA UNIDAD DE MEDIDA - LA CAJA CON PRECIO CONGELADO ES DE 334G (SEGÚN COTO DIGILTAL)','caja x 334 g',275,350,'saborizadas, light, precocidas, rebozadas.');

INSERT INTO cvp.selprodatr (producto,sel_nro,atributo,valorsinsimplificar) VALUES ('P0117531',1,13,'Alco');
INSERT INTO cvp.selprodatr (producto,sel_nro,atributo,valorsinsimplificar) VALUES ('P0117531',2,13,'Noel');
INSERT INTO cvp.selprodatr (producto,sel_nro,atributo,valorsinsimplificar) VALUES ('P0113211',1,13,'La Campagnola');
INSERT INTO cvp.selprodatr (producto,sel_nro,atributo,valorsinsimplificar) VALUES ('P0113211',2,13,'Gomes Da Costa');
INSERT INTO cvp.selprodatr (producto,sel_nro,atributo,valorsinsimplificar) VALUES ('P0119311',1,13,'Maggi');
INSERT INTO cvp.selprodatr (producto,sel_nro,atributo,valorsinsimplificar) VALUES ('P0119311',2,13,'Wilde');
INSERT INTO cvp.selprodatr (producto,sel_nro,atributo,valorsinsimplificar) VALUES ('P1213234',1,13,'Plusbelle');
INSERT INTO cvp.selprodatr (producto,sel_nro,atributo,valorsinsimplificar) VALUES ('P0112141',2,13,'Paty');

INSERT INTO cvp.selprodatr (producto,sel_nro,atributo,valorsinsimplificar) VALUES ('P0117531',1,17,'203');
INSERT INTO cvp.selprodatr (producto,sel_nro,atributo,valorsinsimplificar) VALUES ('P0117531',2,17,'200');
INSERT INTO cvp.selprodatr (producto,sel_nro,atributo,valorsinsimplificar) VALUES ('P0113211',1,17,'120');
INSERT INTO cvp.selprodatr (producto,sel_nro,atributo,valorsinsimplificar) VALUES ('P0113211',2,17,'120');
INSERT INTO cvp.selprodatr (producto,sel_nro,atributo,valorsinsimplificar) VALUES ('P0119311',1,1,'12');
INSERT INTO cvp.selprodatr (producto,sel_nro,atributo,valorsinsimplificar) VALUES ('P0119311',2,1,'12');
INSERT INTO cvp.selprodatr (producto,sel_nro,atributo,valorsinsimplificar) VALUES ('P1213234',1,61,'1000');
INSERT INTO cvp.selprodatr (producto,sel_nro,atributo,valorsinsimplificar) VALUES ('P0112141',2,16,'334');

update cvp.selprodatr set valor=comun.cadena_normalizar(valorsinsimplificar)
where producto in ('P0117531',
                   'P0113211',
                   'P0119311',
                   'P1213234',
                   'P0112141');
