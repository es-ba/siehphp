-- crear tablas his planas desde las tablas planas
set search_path=encu,dbo, comun;

/* -- que planas?
select *
from encu.matrices
where mat_ope=dbo.ope_actual()
  and mat_for!='TEM'
order by 1,2;
--revisar si hay que agregar otras  his planas

*/
CREATE TABLE his.plana_s1_ AS
SELECT
    null::timestamp with time zone AS momento, 
    p.*
  FROM plana_s1_ p where false;
CREATE TABLE his.plana_a1_ AS 
  SELECT 
    null::timestamp with time zone AS momento, 
    p.*
  FROM plana_a1_ p where false;
  
CREATE TABLE his.plana_s1_p AS 
SELECT 
    null::timestamp with time zone AS momento, 
    p.*
FROM plana_s1_p p where false;
CREATE TABLE his.plana_i1_ AS 
  SELECT 
    null::timestamp with time zone AS momento, 
    p.*
  FROM plana_i1_ p where false;
CREATE TABLE his.plana_sup_ AS 
  SELECT 
    null::timestamp with time zone AS momento, 
    p.*
  FROM plana_sup_ p where false;

ALTER TABLE IF EXISTS his.plana_a1_
    OWNER to tedede_php;
ALTER TABLE IF EXISTS his.plana_i1_
    OWNER to tedede_php;
ALTER TABLE IF EXISTS his.plana_s1_
    OWNER to tedede_php;
ALTER TABLE IF EXISTS his.plana_s1_p
    OWNER to tedede_php;
ALTER TABLE IF EXISTS his.plana_sup_
    OWNER to tedede_php;

