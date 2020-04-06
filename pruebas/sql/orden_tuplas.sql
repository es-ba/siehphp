create table tmp_orden_tuplas(
   a varchar(10),
   b varchar(10)
);

insert into tmp_orden_tuplas values ('A','A');
insert into tmp_orden_tuplas values ('A','B');
insert into tmp_orden_tuplas values ('A','C');
insert into tmp_orden_tuplas values ('B','A');
insert into tmp_orden_tuplas values ('B','B');
insert into tmp_orden_tuplas values ('B','C');
insert into tmp_orden_tuplas values ('C','A');
insert into tmp_orden_tuplas values ('C','B');
insert into tmp_orden_tuplas values ('C','C');

select * 
  from tmp_orden_tuplas
  where (a,b)>=('B','B');
  
/* debe mostrar:
"B";"B"
"B";"C"
"C";"A"
"C";"B"
"C";"C"

ok postgresql
*/

/* ok:
mysql> select *
    ->   from tmp_orden_tuplas
    ->   where (a,b)>=('B','B');
+------+------+
| a    | b    |
+------+------+
| B    | B    |
| B    | C    |
| C    | A    |
| C    | B    |
| C    | C    |
+------+------+
*/