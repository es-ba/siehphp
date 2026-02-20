##FUN
controlar_modificacion_semana_dom35_trg
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
Funcion trigger que permite la modificacion del campo semana en plana_tem_. incluyendo control en dominio3

##CUERPO
-- DROP FUNCTION encu.controlar_modificacion_semana_dom35_trg();
CREATE OR REPLACE FUNCTION encu.controlar_modificacion_semana_dom35_trg()
  RETURNS trigger AS
$BODY$
    DECLARE 
        v_rol  text;
		vpermitido boolean;
    BEGIN
	vpermitido=false;
    if new.pla_semana is distinct from old.pla_semana then 
        select  usu_rol  into v_rol
            from encu.tiempo_logico join encu.sesiones on tlg_ses=ses_ses join encu.usuarios on usu_usu=ses_usu
            where tlg_tlg=new.pla_tlg;
          
        if v_rol in ('programador', 'coor_campo', 'subcoor_campo') then    
            if v_rol in ('programador') and new.pla_dominio =5 then
			    if new.pla_estado in (null, 18,19) then
					vpermitido =true;
				else
				    raise exception 'No se puede modificar la semana en encuestas que no cumplen: (dominio 5) y estado <=19';    
				end if;	
			elsif v_rol in ( 'coor_campo', 'subcoor_campo') and new.pla_dominio =5 then
			    if  new.pla_estado in (null, 18) and new.pla_sel_etoi14_villa is not null then
					vpermitido =true;
				else
					raise exception  'No se puede modificar la semana en encuestas que no cumplen: (dominio 5) y estado =vacío ó 18 y sel_etoi14_villa con valor';
				end if;	
			elsif new.pla_dominio =3 then	
				if new.pla_estado in (19,20,22,32) then
					vpermitido =true;
				else		
					raise exception 'No se puede modificar la semana en encuestas que no cumplen: (dominio 3) y estado 19,20,22,32';
				end if;
			else
			   raise exception 'No se puede modificar la semana en encuestas : (dominio %) no considerado',new.dominio;
			end if;			
        else 
            raise exception 'Este rol no cuenta con permisos para modificar la semana: "%"',v_rol;
        end if;
		if vpermitido then
		    new.pla_replica=new.pla_semana;
            update encu.tem 
				set tem_semana=new.pla_semana, tem_replica=new.pla_semana
                where tem_enc=new.pla_enc and tem_dominio=new.pla_dominio;
		end if;	

    end if;   
    return new;
    END
  $BODY$
  LANGUAGE plpgsql ;
  
ALTER FUNCTION encu.controlar_modificacion_semana_dom35_trg()
  OWNER TO tedede_php;  


--cambiar funcion trigger  
DROP TRIGGER controlar_modificacion_semana_trg ON encu.plana_tem_;
CREATE TRIGGER controlar_modificacion_semana_trg
  BEFORE UPDATE
  ON encu.plana_tem_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.controlar_modificacion_semana_dom35_trg();  

