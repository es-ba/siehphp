/*                 control
select * from encu.consistencias where con_con='P9=4_P11';
select * from encu.consistencias where con_con='P9=2_P11';
*/

UPDATE encu.consistencias SET con_postcondicion='P11>= 0 and P11<7 or P11=99 ' WHERE con_con='P9=4_P11';
UPDATE encu.consistencias SET con_postcondicion='P11>=0 and P11<8 or P11=99' WHERE con_con='P9=2_P11';
