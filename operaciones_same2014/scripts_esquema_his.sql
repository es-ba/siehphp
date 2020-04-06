create table his.plana_sm1_ as select current_timestamp as momento, * from encu.plana_sm1_ where false;
/*OTRA*/
ALTER TABLE his.plana_sm1_
  OWNER TO tedede_php;
/*OTRA*/
create table his.plana_sm1_p as select current_timestamp as momento, * from encu.plana_sm1_p where false;
/*OTRA*/
ALTER TABLE his.plana_sm1_p
  OWNER TO tedede_php;
/*OTRA*/
create table his.plana_smi1_ as select current_timestamp as momento, * from encu.plana_smi1_ where false;
/*OTRA*/
ALTER TABLE his.plana_smi1_
  OWNER TO tedede_php;
