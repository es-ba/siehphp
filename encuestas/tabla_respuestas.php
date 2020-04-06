<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";
require_once "valores_especiales.php";

class Tabla_respuestas extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('res');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('res_ope',array('hereda'=>'operativos','modo'=>'pk'));
        $this->definir_campo('res_for',array('hereda'=>'formularios','modo'=>'pk'));
        $this->definir_campo('res_mat',array('hereda'=>'matrices','modo'=>'pk'));
        foreach(nombres_campos_claves('res_','N') as $campo){
            $this->definir_campo($campo,array('hereda'=>'claves','modo'=>'pk'));
        }
        $this->definir_campo('res_var',array('hereda'=>'variables','modo'=>'pk'));
        $this->definir_campo('res_valor',array('tipo'=>'texto'));
        $this->definir_campo('res_valesp',array('tipo'=>'enumerado','elementos'=>array(NSNC,RELEVAMIENTO_OMITIDO)));
        $this->definir_campo('res_valor_con_error',array('tipo'=>'texto'));
        $this->definir_campo('res_estado',array('hereda'=>'estados_ingreso','modo'=>'fk_optativa'));
        $this->definir_campo('res_anotaciones_marginales',array('tipo'=>'texto'));
    }
    function valor_ingresado(){
        return $this->datos->res_valesp?:$this->datos->res_valor_con_error?:$this->datos->res_valor;
    }
    function restricciones_especificas(){
        global $implode_nombres_campos_claves;
        Loguear('2012-09-09','SI INSTALE');
        $BODY='$BODY';
        $campos=$this->obtener_nombres_campos();
        $campos_his=$this->contexto->db->dame_arreglo_campos('his','his_'.$this->nombre_tabla);
        $faltantes=array_diff($campos,array_map(function($elemento){ return quitar_prefijo($elemento,'his');},$campos_his));
        if(count($faltantes)>0){
        /*
            throw new Exception_Tedede("Fallo el control preparando el trigger para his_".$this->nombre_tabla." campos faltantes: ".implode(', ',$faltantes));
        */
        }
        $sql_insert="  insert into his.his_respuestas (his".implode(', his',$campos)
            .")\n    values (new.".implode(', new.',$campos).");\n";
        $operativo_actual = $GLOBALS['NOMBRE_APP'];
        $todas=<<<SQL
CREATE OR REPLACE FUNCTION respuestas_control_pk_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_mal boolean:=false;
BEGIN
  if new.res_for='AJH1' and new.res_mat='' then
    if new.res_hog is not distinct from 0 or new.res_mie is distinct from 0 then
      v_mal:=true;
    end if;
  elsif new.res_for='AJI1' and new.res_mat='' then
    if new.res_hog is not distinct from 0 or new.res_mie is distinct from 0 then
      v_mal:=true;
    end if;
  elsif new.res_for='TEM' and new.res_mat='' then
    if new.res_hog is distinct from 0 or new.res_mie is distinct from 0 then
      v_mal:=true;
    end if;
  elsif new.res_for='AJH1' and new.res_mat='M' then
    if new.res_hog is not distinct from 0 or new.res_mie is not distinct from 0 then
      v_mal:=true;
    end if;
  end if;
  if v_mal then
    raise 'Violacion de pk en %,%,%,% para %,%',{$implode_nombres_campos_claves(' new.res_@,','N')} new.res_for,new.res_mat;
  end if;
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
/*OTRA*/
ALTER FUNCTION respuestas_control_pk_trg()
  OWNER TO tedede_php;
/*OTRA*/
DROP TRIGGER IF EXISTS respuestas_control_pk_trg
  ON encu.respuestas
/*OTRA*/
CREATE TRIGGER respuestas_control_pk_trg
  AFTER INSERT
  ON encu.respuestas
  FOR EACH ROW
  EXECUTE PROCEDURE respuestas_control_pk_trg();
/*OTRA*/
CREATE OR REPLACE FUNCTION respuestas_a_planas_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_mal boolean:=false;
  v_sentencia text;
  v_sentencia_null text;
  v_valor text;
  v_valor_tsp timestamp without time zone;  
BEGIN
if new.res_ope = '$operativo_actual' then
  v_sentencia:='UPDATE encu.plana_'||new.res_for||'_'||new.res_mat||' SET "pla_'||new.res_var||'"=$1, pla_tlg=$2 WHERE {$implode_nombres_campos_claves('pla_@=$# and ','N','',3)} true';
  v_sentencia_null:='UPDATE encu.plana_'||new.res_for||'_'||new.res_mat||' SET "pla_'||new.res_var||'"=null, pla_tlg=$1 WHERE {$implode_nombres_campos_claves('pla_@=$# and ','N','',2)} true';
  v_valor:=case new.res_valesp when '//' then '-9' when '--' then '-1' else new.res_valor end;
  BEGIN
    if v_valor is null then
      EXECUTE v_sentencia_null USING new.res_tlg {$implode_nombres_campos_claves(', new.res_@','N')};
    elseif comun.es_fecha(v_valor) and new.res_for = 'TEM' then
      v_valor_tsp:=comun.valor_fecha(v_valor);
     EXECUTE v_sentencia USING v_valor_tsp, new.res_tlg {$implode_nombres_campos_claves(', new.res_@','N')};
    elseif comun.es_numero(v_valor) then
      EXECUTE v_sentencia USING v_valor::bigint, new.res_tlg {$implode_nombres_campos_claves(', new.res_@','N')};
    else
      EXECUTE v_sentencia USING v_valor, new.res_tlg {$implode_nombres_campos_claves(', new.res_@','N')};
    end if;
  EXCEPTION 
    WHEN OTHERS THEN
      EXECUTE v_sentencia USING  -5, new.res_tlg {$implode_nombres_campos_claves(', new.res_@','N')};
      new.res_valor_con_error:=new.res_valor;
      new.res_valor:=null;
  END;
  -- Comentar este insert al hacer una instalación:
$sql_insert
  -- */
end if;
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
/*OTRA*/
ALTER FUNCTION respuestas_a_planas_trg()
  OWNER TO tedede_php;
/*OTRA*/
DROP TRIGGER IF EXISTS respuestas_a_planas_trg
  ON encu.respuestas
/*OTRA*/
CREATE TRIGGER respuestas_a_planas_trg
  BEFORE UPDATE
  ON encu.respuestas
  FOR EACH ROW
  EXECUTE PROCEDURE respuestas_a_planas_trg();
SQL;
        // $sqls=new Sqls();
        // foreach(explode('/*OTRA*/',$todas) as $sentencia){
        //     $sqls->agregar(new Sql($sentencia));
        // }
        // return $sqls;
        return new Sqls(explode('/*OTRA*/',$todas));
    }
}

?>