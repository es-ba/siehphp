select * from encu.variables  
WHERE var_ope='pp2012' and var_pre='X5' ;
UPDATE encu.variables SET var_destino_nsnc='H30' 
where var_ope='pp2012' and var_pre='X5' ;

select * from encu.variables  
WHERE var_ope='pp2012' and var_pre='T3' ;
UPDATE encu.variables SET var_destino_nsnc='HIT' 
WHERE var_ope='pp2012' and var_pre='T3' ;

select * from encu.variables  
WHERE var_ope='pp2012' and var_pre='T4' ;
UPDATE encu.variables SET var_destino_nsnc='HIT' 
WHERE var_ope='pp2012' and var_pre='T4' ;

select * from encu.variables  
WHERE var_ope='pp2012' and var_pre='T5' ;
UPDATE encu.variables SET var_destino_nsnc=NULL 
WHERE var_ope='pp2012' and var_pre='T5' ;

select * from encu.variables  
WHERE var_ope='pp2012' and var_pre='T6' ;
UPDATE encu.variables SET var_destino_nsnc=NULL 
WHERE var_ope='pp2012' and var_pre='T6' ;

select * from encu.variables  
WHERE var_ope='pp2012' and var_pre='T10' ;
UPDATE encu.variables SET var_destino_nsnc='HIT' 
WHERE var_ope='pp2012' and var_pre='T10' ;

select * from encu.variables  
WHERE var_ope='pp2012' and var_pre='T12' ;
UPDATE encu.variables SET var_destino_nsnc='HIT' 
WHERE var_ope='pp2012' and var_pre='T12' ;

select * from encu.variables  
WHERE var_ope='pp2012' and (var_pre='T7' or var_pre='T8') and (var_var='t7' or var_var='t8');
UPDATE encu.variables SET var_destino_nsnc='T30' 
WHERE var_ope='pp2012' and (var_pre='T7' or var_pre='T8') and (var_var='t7' or var_var='t8');

------------------------------------

select * from encu.variables  
WHERE var_ope='pp2012' and var_pre='T14' ;
UPDATE encu.variables SET var_destino_nsnc='HIT' 
WHERE var_ope='pp2012' and var_pre='T14' ;

select * from encu.variables  
WHERE var_ope='pp2012' and var_pre='T16' ;
UPDATE encu.variables SET var_destino_nsnc='T18' 
WHERE var_ope='pp2012' and var_pre='T16' ;

select * from encu.variables  
WHERE var_ope='pp2012' and var_pre='T18' ;
UPDATE encu.variables SET var_destino_nsnc='HIT' 
WHERE var_ope='pp2012' and var_pre='T18' ;

select * from encu.variables  
WHERE var_ope='pp2012' and var_pre='T35' ;
UPDATE encu.variables SET var_destino_nsnc='T37' 
WHERE var_ope='pp2012' and var_pre='T35' ;

select * from encu.variables  
WHERE var_ope='pp2012' and var_pre='I1' ;
UPDATE encu.variables SET var_destino_nsnc='I3' 
WHERE var_ope='pp2012' and var_pre='I1' ;

select * from encu.variables  
WHERE var_ope='pp2012' and var_pre='E2' ;
UPDATE encu.variables SET var_destino_nsnc='MIG' 
WHERE var_ope='pp2012' and var_pre='E2' ;
------------------------------------------------
