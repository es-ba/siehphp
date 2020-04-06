<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_inconsistencias extends Tabla{
    function definicion_estructura(){  
        $this->definir_prefijo('inc');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('inc_ope',array('hereda'=>'operativos','modo'=>'pk','validart'=>'codigo'));
        $this->definir_campo('inc_con',array('hereda'=>'consistencias','modo'=>'pk','validart'=>'formula'));
        foreach(nombres_campos_claves('inc_','N') as $campo){
            $this->definir_campo($campo,array('es_pk'=>true,'tipo'=>'entero'));
        }
        $this->definir_campo('inc_variables_y_valores',array('tipo'=>'texto', 'validart'=>'formula'));
        $this->definir_campo('inc_justificacion',array('tipo'=>'texto','largo'=>500));
        $this->definir_campo('inc_autor_justificacion',array('tipo'=>'texto','largo'=>30,'validart'=>'codigo'));
        $this->definir_campo('inc_falsos_positivos',array('tipo'=>'logico'));
        $this->definir_campo('inc_nivel',array('tipo'=>'entero'));
        $this->definir_campo('inc_obs_consis',array('tipo'=>'texto', 'largo'=>500));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
CREATE OR REPLACE FUNCTION his_inconsistencias_trg()
  RETURNS trigger AS
$BODY$
BEGIN
  INSERT INTO his.his_inconsistencias(
            hisinc_ope, hisinc_con, 
SQL
.implode('',nombres_campos_claves('hisinc_','N',', ')).
<<<SQL
            hisinc_variables_y_valores, 
            hisinc_justificacion, hisinc_autor_justificacion, hisinc_tlg, hisinc_obs_consis)
    VALUES (old.inc_ope, old.inc_con, 
SQL
.implode('',nombres_campos_claves('old.inc_','N',', ')).
<<<SQL
    old.inc_variables_y_valores, 
            old.inc_justificacion, old.inc_autor_justificacion, old.inc_tlg, old.inc_obs_consis);

    return old;
END
$BODY$
LANGUAGE plpgsql VOLATILE
/*OTRA*/
ALTER FUNCTION his_inconsistencias_trg()
  OWNER TO tedede_php;
/*OTRA*/
CREATE TRIGGER his_inconsistencias_trg
    BEFORE DELETE
  ON encu.inconsistencias
  FOR EACH ROW
  EXECUTE PROCEDURE his_inconsistencias_trg();
/*OTRA*/
/*RESCATAR LA JUSTIFICACION*/
CREATE OR REPLACE FUNCTION his_inconsistencias_upd_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_ultima_justificacion text;
  v_ultima_variables_y_valores text;
  v_ultima_obs_consis text;
BEGIN
    if new.inc_justificacion is null then
        SELECT hisinc_justificacion,hisinc_variables_y_valores, hisinc_obs_consis
            INTO v_ultima_justificacion, v_ultima_variables_y_valores,  v_ultima_obs_consis
            FROM his.his_inconsistencias
            WHERE hisinc_ope=new.inc_ope
                AND hisinc_con=new.inc_con
SQL;
foreach(nombres_campos_claves('','N') as $campo_sin_prefijo){
    $todas.=<<<SQL
                AND hisinc_{$campo_sin_prefijo}=new.inc_{$campo_sin_prefijo}
SQL;
}
$todas.=<<<SQL
            ORDER BY hisinc_tlg DESC LIMIT 1;
        if v_ultima_variables_y_valores=new.inc_variables_y_valores then
            if new.inc_justificacion is null then
                new.inc_justificacion:=v_ultima_justificacion;
            end if;    
            if new.inc_obs_consis is null then
               new.inc_obs_consis:=v_ultima_obs_consis;
            end if;   
        end if;
    end if;
    return new;
END
$BODY$
LANGUAGE plpgsql VOLATILE;
/*OTRA*/
ALTER FUNCTION his_inconsistencias_upd_trg()
  OWNER TO tedede_php;
/*OTRA*/
CREATE TRIGGER his_inconsistencias_upd_trg
    BEFORE INSERT
  ON encu.inconsistencias
  FOR EACH ROW
  EXECUTE PROCEDURE his_inconsistencias_upd_trg();
/*OTRA*/
ALTER TABLE inconsistencias
  ADD CONSTRAINT "texto invalido en inc_autor_justificacion de tabla inconsistenc" CHECK (comun.cadena_valida(inc_autor_justificacion::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE inconsistencias
  ADD CONSTRAINT "texto invalido en inc_con de tabla inconsistencias" CHECK (comun.cadena_valida(inc_con, 'formula'::text));
/*OTRA*/
ALTER TABLE inconsistencias
  ADD CONSTRAINT "texto invalido en inc_justificacion de tabla inconsistencias" CHECK (comun.cadena_valida(inc_justificacion::text, 'castellano y formula'::text));
/*OTRA*/
ALTER TABLE inconsistencias
  ADD CONSTRAINT "texto invalido en inc_ope de tabla inconsistencias" CHECK (comun.cadena_valida(inc_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE inconsistencias
  ADD CONSTRAINT "texto invalido en inc_variables_y_valores de tabla inconsistenc" CHECK (comun.cadena_valida(inc_variables_y_valores, 'cualquiera'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}
?>