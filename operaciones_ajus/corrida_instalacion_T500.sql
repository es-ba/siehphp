/*                 control
select * from encu.consistencias where con_con='P9=2_P3b';
select * from encu.consistencias where con_con='P9=4_P3b';
select * from encu.consistencias where con_con='P9=4_P11';
select * from encu.consistencias where con_con='P9=5_P11';
select * from encu.consistencias where con_con='P9_P11_c';
*/

UPDATE encu.consistencias SET con_precondicion='p9=2 and p8=1'  WHERE con_con='P9=2_P3b';
UPDATE encu.consistencias SET con_precondicion='p9=4 and p8=1'  WHERE con_con='P9=4_P3b';
UPDATE encu.consistencias SET con_precondicion='p9=4 and p10=2' WHERE con_con='P9=4_P11';
UPDATE encu.consistencias SET con_precondicion='p9=5 and p10=2' WHERE con_con='P9=5_P11';
UPDATE encu.consistencias SET con_precondicion='p9=8 and p10=2' WHERE con_con='P9_P11_c';