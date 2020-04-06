<?php
//UTF-8:SÍ
require_once "tablas.php";

class Tabla_claves extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('cla');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('cla_ope',array('hereda'=>'operativos','modo'=>'pk'));
        $this->definir_campo('cla_for',array('hereda'=>'formularios','modo'=>'pk'));
        $this->definir_campo('cla_mat',array('hereda'=>'matrices','modo'=>'pk'));
        foreach(nombres_campos_claves('cla_','N') as $campo){
            $this->definir_campo($campo,array('es_pk'=>true,'tipo'=>'entero','def'=>0));
        }
        foreach(nombres_campos_claves('cla_aux_es_','N') as $campo){
            $this->definir_campo($campo,array('tipo'=>'solo_true'));
        }
        $this->definir_campo('cla_ultimo_coloreo_tlg',array('tipo'=>'entero','bytes'=>8));
        // OJO: Faltan agregar las constraints:
        // cla_enc<>0
        // cla_aux_xxx tiene que calcularse
        $this->definir_tablas_hijas(array(
            'respuestas'=>true,
        ));
    }
    function restricciones_especificas(){
        global $implode_nombres_campos_claves;
        $BODY='$BODY';
        $todas=<<<SQL
CREATE OR REPLACE FUNCTION claves_campos_aux_trg()
  RETURNS trigger AS
$BODY$
BEGIN
{$implode_nombres_campos_claves("\n    new.cla_aux_es_",'N',':=null;')}
  if new.cla_hog=0 then
    new.cla_aux_es_enc:=true;
    if new.cla_mie=0 then
      null;
    else
      raise 'si la clave es de hogar no puede tener especificado el miembro (en encuesta %)',new.cla_enc;
    end if;
    if new.cla_exm=0 then
      null;
    else
      raise 'si la clave es de hogar no puede tener especificado el emigrante (en encuesta %)',new.cla_enc;
    end if;
  elsif new.cla_mie=0 then
    new.cla_aux_es_hog:=true;
    if new.cla_exm=0 then
      new.cla_aux_es_hog:=true;
    else
      new.cla_aux_es_hog:=null;
      new.cla_aux_es_exm:=null;
    end if;
  else
    if new.cla_exm=0 then
      null;
    else
      raise 'si la clave es de hogar no puede tener especificado el emigrante y el miembro (en encuesta %)',new.cla_enc;
    end if;
    new.cla_aux_es_mie:=true;
  end if;
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
/*OTRA*/
ALTER FUNCTION claves_campos_aux_trg()
  OWNER TO tedede_php;
/*OTRA*/
CREATE TRIGGER claves_campos_aux_trg
  BEFORE INSERT
  ON encu.claves
  FOR EACH ROW
  EXECUTE PROCEDURE claves_campos_aux_trg();
/*OTRA*/
alter table claves add unique (cla_ope, cla_for, cla_mat, cla_enc, cla_aux_es_enc);
/*OTRA*/
alter table claves add unique (cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_aux_es_hog);
/*OTRA*/
alter table claves add unique (cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_aux_es_mie);
/*OTRA*/
alter table claves add unique (cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_exm, cla_aux_es_exm);
  -- // AGREGAR A MANO UNA CAMPO NUEVO EN LA pk DE RESPUESTAS
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}

?>