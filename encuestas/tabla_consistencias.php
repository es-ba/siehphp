<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_consistencias extends Tabla{
    function definicion_estructura(){  
        $this->definir_prefijo('con');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('con_ope',array('hereda'=>'operativos','modo'=>'pk','def'=>$GLOBALS['NOMBRE_APP']));
        $this->definir_campo('con_con',array('tipo'=>'texto','es_pk'=>true));
        $this->definir_campo('con_precondicion',array('tipo'=>'texto','largo'=>3000));
        $this->definir_campo('con_rel',array('hereda'=>'relaciones','modo'=>'fk_optativa', 'def'=>'=>'));        
        $this->definir_campo('con_postcondicion',array('tipo'=>'texto','largo'=>9500));
        $this->definir_campo('con_activa',array('tipo'=>'logico', 'def'=>true,'not_null'=>true));
        $this->definir_campo('con_explicacion',array('tipo'=>'texto','largo'=>4500));
        $this->definir_campo('con_expl_ok',array('tipo'=>'logico', 'def'=>false,'not_null'=>true));
        $this->definir_campo('con_estado',array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('con_tipo',array('tipo'=>'enumerado','elementos'=>array('Revisar','Conceptual','Auditoría','Completitud'),'def'=>'Revisar'));
        $this->definir_campo('con_falsos_positivos',array('tipo'=>'logico'));
        $this->definir_campo('con_importancia',array('tipo'=>'texto','largo'=>100));        
        $this->definir_campo('con_momento',array('tipo'=>'texto','hereda'=>'con_momentos','campo_relacionado'=>'conmom_conmom','modo'=>'fk_optativa','def'=>'Revisar','not_null'=>true));
        $this->definir_campo('con_grupo',array('tipo'=>'texto','largo'=>240));
        $this->definir_campo('con_descripcion',array('tipo'=>'texto','largo'=>240));
        $this->definir_campo('con_modulo',array('tipo'=>'texto','largo'=>240));
        $this->definir_campo('con_valida',array('tipo'=>'logico', 'def'=>false));
        $this->definir_campo('con_junta',array('tipo'=>'texto','largo'=>300));
        $this->definir_campo('con_clausula_from',array('tipo'=>'texto','largo'=>4000));
        $this->definir_campo('con_expresion_sql',array('tipo'=>'texto','largo'=>8000));        
        $this->definir_campo('con_error_compilacion',array('tipo'=>'texto','largo'=>4000));
        $this->definir_campo('con_ultima_variable',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('con_orden',array('tipo'=>'entero'));
        $this->definir_campo('con_gravedad',array('tipo'=>'texto','largo'=>240));
        $this->definir_campo('con_version',array('tipo'=>'texto','largo'=>240));
        $this->definir_campo('con_rev',array('tipo'=>'entero', 'def'=>1,'not_null'=>true));
        $this->definir_campo('con_ultima_modificacion',array('tipo'=>'timestamp'));
        $this->definir_campo('con_ignorar_nulls',array('tipo'=>'logico'));  
        $this->definir_campo('con_observaciones',array('tipo'=>'texto'));          
        $this->definir_campo('con_variables_contexto',array('tipo'=>'texto'));          
        $this->definir_campo('con_demora_compilacion',array('tipo'=>'entero','bytes'=>8));          
        $this->definir_campo('con_origen',array('tipo'=>'texto','def'=>$GLOBALS['NOMBRE_APP'],'largo'=>50));          
        $this->definir_tablas_hijas(array(
            'inconsistencias'=>true,
            'con_var'=>true,
            'ano_con'=>true,
        ));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
CREATE OR REPLACE FUNCTION consistencias_upd_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_en_campo boolean;
BEGIN  
  SELECT ope_en_campo INTO v_en_campo FROM operativos WHERE ope_ope=new.con_ope;
  if v_en_campo
       and ( new.con_momento='Relevamiento 1' or new.con_momento='Relevamiento 2') and new.con_activa is true 
       and ( new.con_con           is distinct from old.con_con
          or new.con_precondicion  is distinct from old.con_precondicion 
          or new.con_rel           is distinct from old.con_rel          
          or new.con_postcondicion is distinct from old.con_postcondicion
          or new.con_activa        is distinct from old.con_activa       
          or new.con_tipo          is distinct from old.con_tipo         
          or new.con_momento       is distinct from old.con_momento  
       )      
  then
    raise exception 'No se pueden modificar las consistencias de Relevamiento mientras la encuesta esta en campo. Solo pueden darse de baja o cambiarlas a momentos posteriores';
  end if;
  if new.con_precondicion is distinct from old.con_precondicion 
    or new.con_postcondicion is distinct from old.con_postcondicion
    or new.con_rel is distinct from old.con_rel
  then
    -- estos campos se anulan ante cualquier cambio, solo pueden ser restaurados por el sistema cambiando en forma simultánea la revision
    -- new.con_junta=null;
    new.con_expresion_sql:=null;
    new.con_clausula_from:=null;
    new.con_error_compilacion:='Modificada desde la compilacion anterior';
    new.con_valida:=false;
  end if;
  if comun.buscar_reemplazar_espacios_raros(new.con_precondicion) is distinct from new.con_precondicion then
    new.con_precondicion=comun.buscar_reemplazar_espacios_raros(new.con_precondicion);
  end if;
  if comun.buscar_reemplazar_espacios_raros(new.con_postcondicion) is distinct from new.con_postcondicion then
    new.con_postcondicion=comun.buscar_reemplazar_espacios_raros(new.con_postcondicion);
  end if;
  return new;
END
$BODY$
LANGUAGE plpgsql VOLATILE;
/*OTRA*/
ALTER FUNCTION consistencias_upd_trg()
  OWNER TO tedede_php;
/*OTRA*/
CREATE TRIGGER consistencias_upd_trg
    BEFORE UPDATE
  ON encu.consistencias
  FOR EACH ROW
  EXECUTE PROCEDURE consistencias_upd_trg();
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_clausula_from de tabla consistencias" CHECK (comun.cadena_valida(con_clausula_from::text, 'formula'::text));
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_con de tabla consistencias" CHECK (comun.cadena_valida(con_con, 'castellano y formula'::text));
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_descripcion de tabla consistencias" CHECK (comun.cadena_valida(con_descripcion::text, 'cualquiera'::text));  
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_error_compilacion de tabla consistencias" CHECK (comun.cadena_valida(con_error_compilacion::text, 'cualquiera'::text));  
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_estado de tabla consistencias" CHECK (comun.cadena_valida(con_estado::text, 'extendido'::text));
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_explicacion de tabla consistencias" CHECK (comun.cadena_valida(con_explicacion::text, 'cualquiera'::text));
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_expresion_sql de tabla consistencias" CHECK (comun.cadena_valida(con_expresion_sql::text, 'formula'::text));  
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_gravedad de tabla consistencias" CHECK (comun.cadena_valida(con_gravedad::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_grupo de tabla consistencias" CHECK (comun.cadena_valida(con_grupo::text, 'castellano'::text));
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_importancia de tabla consistencias" CHECK (comun.cadena_valida(con_importancia::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE consistencias
    ADD CONSTRAINT "texto invalido en con_junta de tabla consistencias" CHECK (comun.cadena_valida(con_junta::text, 'json'::text));
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_modulo de tabla consistencias" CHECK (comun.cadena_valida(con_modulo::text, 'castellano'::text));
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_momento de tabla consistencias" CHECK (comun.cadena_valida(con_momento::text, 'castellano'::text));
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_observaciones de tabla consistencias" CHECK (comun.cadena_valida(con_observaciones, 'castellano'::text));
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_ope de tabla consistencias" CHECK (comun.cadena_valida(con_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_postcondicion de tabla consistencias" CHECK (comun.cadena_valida(con_postcondicion::text, 'formula'::text));  
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_precondicion de tabla consistencias" CHECK (comun.cadena_valida(con_precondicion::text, 'formula'::text));  
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_rel de tabla consistencias" CHECK (comun.cadena_valida(con_rel::text, 'formula'::text));  
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_tipo de tabla consistencias" CHECK (comun.cadena_valida(con_tipo::text, 'castellano'::text));
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_ultima_variable de tabla consistencias" CHECK (comun.cadena_valida(con_ultima_variable::text, 'codigo'::text));  
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_variables_contexto de tabla consistencias" CHECK (comun.cadena_valida(con_variables_contexto, 'extendido'::text));
/*OTRA*/
ALTER TABLE consistencias
  ADD CONSTRAINT "texto invalido en con_version de tabla consistencias" CHECK (comun.cadena_valida(con_version::text, 'castellano y formula'::text));
SQL;
  
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}

?>