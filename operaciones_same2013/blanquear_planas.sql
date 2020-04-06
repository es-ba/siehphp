DROP TABLE encu.plana_sm1_ ;
DROP TABLE encu.plana_sm1_p ;
DROP TABLE encu.plana_smi1_ ;
DROP TABLE encu.plana_tem_ ;
delete from encu.respuestas ;
delete from encu.claves ;
delete from encu.con_var ;
--generar: Actualizar Instalación (jsones varios, post cambio metadatos) mas las tablas planas 
INSERT INTO encu.claves(
            cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm, cla_tlg)
select 'same2013', 'TEM', '',  tem_enc, 0, 0, 0, 1 from encu.tem
