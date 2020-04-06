--Eah2012
--controles sobre campos descripcion_rama y descripcion_ocupacion 

 select position(';' in descripcion_ocupacion), descripcion_ocupacion
  FROM bu.eah12_bu_ocupacion
  where position(';' in descripcion_ocupacion) <> 0;
  
 select position(';' in descripcion_rama), descripcion_rama  --10 casos
  FROM bu.eah12_bu_rama
  where position(';' in descripcion_rama) <> 0;
  
 select replace (descripcion_rama, ';', ','), descripcion_rama
  FROM bu.eah12_bu_rama
  where position(';' in descripcion_rama) <> 0;
  
update bu.eah12_bu_rama  set descripcion_rama= replace (descripcion_rama, ';', ',')
  where position(';' in descripcion_rama) <> 0;
 
select position('¢' in descripcion_ocupacion), descripcion_ocupacion
  FROM bu.eah12_bu_ocupacion
  where position('¢' in descripcion_ocupacion) <> 0;
  
select position('¡' in descripcion_ocupacion), descripcion_ocupacion
  FROM bu.eah12_bu_ocupacion
  where position('¡' in descripcion_ocupacion) <> 0;
 
select replace(descripcion_ocupacion, '¢','ó'), descripcion_ocupacion --33 casos
  FROM bu.eah12_bu_ocupacion
  where position('¢' in descripcion_ocupacion) <> 0; 
 
update bu.eah12_bu_ocupacion
  set descripcion_ocupacion=replace(descripcion_ocupacion, '¡','í') --24 casos
  where position('¡' in descripcion_ocupacion) <> 0;

update bu.eah12_bu_ocupacion
  set descripcion_ocupacion=replace(descripcion_ocupacion, '¢','ó') --33 casos
  where position('¢' in descripcion_ocupacion) <> 0; 
  