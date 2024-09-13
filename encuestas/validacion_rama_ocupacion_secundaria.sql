set search_path=encu;

insert into varcal (varcal_ope,varcal_varcal,varcal_destino,varcal_orden,varcal_nombre,varcal_comentarios,varcal_activa,varcal_tipo,varcal_baseusuario,varcal_nombrevar_baseusuario,varcal_tipodedato,varcal_nombre_dr,varcal_nsnc_atipico,varcal_grupo,varcal_tem,varcal_valida,varcal_opciones_excluyentes,varcal_filtro,varcal_cerrado,varcal_tlg)
select varcal_ope,varcal_varcal||'_sec',varcal_destino,varcal_orden,varcal_nombre||' SEC',varcal_comentarios,varcal_activa,varcal_tipo,varcal_baseusuario,varcal_nombrevar_baseusuario,varcal_tipodedato,varcal_nombre_dr,varcal_nsnc_atipico,varcal_grupo,varcal_tem,varcal_valida,varcal_opciones_excluyentes,varcal_filtro,varcal_cerrado,varcal_tlg 
from varcal
where varcal_varcal ~ '^(rama1|rama2|obsrama|ocu1|ocu2|ocu3|ocu4|ocu5|obsocu)$'

insert into varcal (varcal_ope,varcal_varcal,varcal_destino,varcal_orden,varcal_nombre,varcal_comentarios,varcal_activa,varcal_tipo,varcal_baseusuario,varcal_nombrevar_baseusuario,varcal_tipodedato,varcal_nombre_dr,varcal_nsnc_atipico,varcal_grupo,varcal_tem,varcal_valida,varcal_opciones_excluyentes,varcal_filtro,varcal_cerrado,varcal_tlg)
values 
('eah2024','cptso37_cod','mie',1,'Código rama de actividad para ocupados SEC',null,true,'especial',true,'cptso37_cod','entero',null,null,'ocupacion',null,true,false,null,true,1)

insert into varcal (varcal_ope,varcal_varcal,varcal_destino,varcal_orden,varcal_nombre,varcal_comentarios,varcal_activa,varcal_tipo,varcal_baseusuario,varcal_nombrevar_baseusuario,varcal_tipodedato,varcal_nombre_dr,varcal_nsnc_atipico,varcal_grupo,varcal_tem,varcal_valida,varcal_opciones_excluyentes,varcal_filtro,varcal_cerrado,varcal_tlg)
values 
('eah2024','tso41_cod2','mie',1,'Código ocupación para ocupados SEC',null,true,'especial',true,'tso41_cod2','entero',null,null,'ocupacion',null,true,false,null,true,1)

alter table plana_i1_ add column pla_rama1_sec text;
alter table plana_i1_ add column pla_rama2_sec text;
alter table plana_i1_ add column pla_obsrama_sec text;
alter table plana_i1_ add column pla_ocu1_sec text;
alter table plana_i1_ add column pla_ocu2_sec text;
alter table plana_i1_ add column pla_ocu3_sec text;
alter table plana_i1_ add column pla_ocu4_sec text;
alter table plana_i1_ add column pla_ocu5_sec text;
alter table plana_i1_ add column pla_obsocu_sec text;

alter table plana_i1_ add column pla_cptso37_cod integer;
alter table plana_i1_ add column pla_tso41_cod2 integer;

CREATE OR REPLACE FUNCTION encu.unir_rama_ocupacion_sec_trg()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
  if (new.pla_ocu1_sec is distinct from old.pla_ocu1_sec or new.pla_ocu2_sec  is distinct from old.pla_ocu2_sec or new.pla_ocu3_sec is distinct from old.pla_ocu3_sec  or new.pla_ocu4_sec is distinct from old.pla_ocu4_sec or new.pla_ocu5_sec is distinct from old.pla_ocu5_sec) then  
    if length(new.pla_ocu1_sec||new.pla_ocu2_sec||new.pla_ocu3_sec||new.pla_ocu4_sec||new.pla_ocu5_sec)=5 then 
         new.pla_tso41_cod2:=reemplazar_espacios_por_x_o_blanco_total(digitos(new.pla_ocu1_sec)||digitos(new.pla_ocu2_sec)||digitos(new.pla_ocu3_sec)||digitos(new.pla_ocu4_sec)||digitos(new.pla_ocu5_sec));
    else
        new.pla_tso41_cod2:=null; 
    end if; 
  end if;   

  if (new.pla_rama1_sec is distinct from old.pla_rama1_sec or new.pla_rama2_sec is distinct from old.pla_rama2_sec) then  
    if length(new.pla_rama1_sec||new.pla_rama2_sec)=4 then
         new.pla_cptso37_cod:=reemplazar_espacios_por_x_o_blanco_total(digitos(new.pla_rama1_sec,2)||digitos(new.pla_rama2_sec,2));
    else
        new.pla_cptso37_cod:=null;  
    end if; 
  end if;   
 
  return new;
END
$BODY$;

ALTER FUNCTION encu.unir_rama_ocupacion_sec_trg()
    OWNER TO tedede_php;

CREATE OR REPLACE TRIGGER xunir_rama_ocupacion_sec_i1_trg
BEFORE UPDATE 
ON encu.plana_i1_
FOR EACH ROW
EXECUTE FUNCTION encu.unir_rama_ocupacion_sec_trg();