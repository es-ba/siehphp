##FUN
controlar_modificacion_semana_trg
##ESQ
encu
##PARA
produccion
##PUBLICA
no
##PAR

##TIPO_DEVUELTO
trigger
##TIPO_FUNCION
plpgsql
##DESCRIPCION
Funcion trigger que permite la modificacion del campo semana en plana_tem_.

##CUERPO
-- DROP FUNCTION encu.controlar_modificacion_semana_trg();
CREATE OR REPLACE FUNCTION encu.controlar_modificacion_semana_trg()
  RETURNS trigger AS
$BODY$
    DECLARE 
        v_rol  text;
    BEGIN
    if new.pla_semana is distinct from old.pla_semana then 
        select  usu_rol  into v_rol
            from encu.tiempo_logico join encu.sesiones on tlg_ses=ses_ses join encu.usuarios on usu_usu=ses_usu
            where tlg_tlg=new.pla_tlg;
          
        if v_rol in ('programador') then    
            if new.pla_dominio =5 and  new.pla_estado in (null, 18,19)  then
                    new.pla_replica=new.pla_semana;
                    update encu.tem set tem_semana=new.pla_semana, tem_replica=new.pla_semana
                      where tem_enc=new.pla_enc and tem_dominio=5;
            else
                raise exception 'No se puede modificar la semana en encuestas que no cumplen: (dominio 5) y estado <=19';    
            end if;
        elseif v_rol in ( 'coor_campo', 'subcoor_campo') then    
            if new.pla_dominio =5 and  new.pla_estado in (null, 18) and new.pla_sel_etoi14_villa is not null then
                    new.pla_replica=new.pla_semana;
                    update encu.tem set tem_semana=new.pla_semana, tem_replica=new.pla_semana
                      where tem_enc=new.pla_enc and tem_dominio=5;
            else
                raise exception 'No se puede modificar la semana en encuestas que no cumplen: (dominio 5) y estado =vacío ó 18 y sel_etoi14_villa con valor';    
            end if;
        else 
                raise exception 'Este rol no cuenta con permisos para modificar la semana: "%"',v_rol;
        end if;
    end if;   
    return new;
    END
  $BODY$
  LANGUAGE plpgsql ;
  
ALTER FUNCTION encu.controlar_modificacion_semana_trg()
  OWNER TO tedede_php;  

--DROP TRIGGER controlar_modificacion_semana_trg ON encu.plana_tem_;
CREATE TRIGGER controlar_modificacion_semana_trg
  BEFORE UPDATE
  ON encu.plana_tem_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.controlar_modificacion_semana_trg();

--CONSTRAINT SEMANA = REPLICA
ALTER TABLE encu.plana_tem_
  DROP CONSTRAINT "SEMANA DEBE SER IGUAL A REPLICA" ;

ALTER TABLE encu.plana_tem_
  ADD CONSTRAINT "SEMANA DEBE SER IGUAL A REPLICA" 
       CHECK (
       (NOT pla_semana IS DISTINCT FROM pla_replica or
          pla_dominio in (4,5) and pla_estado in (null, 18,19) )       
       );  
  