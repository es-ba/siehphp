<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_registro_claves extends Tabla{
    function definicion_estructura(){ 
        global $ahora;    
        $this->definir_prefijo('regcla');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('regcla_ope',array('hereda'=>'operativos','modo'=>'pk','def'=>$GLOBALS['NOMBRE_APP'],'validart'=>'codigo'));
        $this->definir_campo('regcla_usu',array('es_pk'=>true,'hereda'=>'usuarios','modo'=>'pk' ,'def'=>$_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_usu_usu"])); //NOTA: comentar def para inst. de un nuevo operativo.
        $this->definir_campo('regcla_fecha',array('es_pk'=>true, 'tipo'=>'fecha','def'=>$ahora->format('Y-m-d')));
        $this->definir_campo('regcla_enc',array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('regcla_pedido_recep',array('tipo'=>'texto','validart'=>'castellano'));
        $this->definir_campo('regcla_solucion_mues',array('tipo'=>'entero'));
        $this->definir_campo('regcla_fecha_mues',array('tipo'=>'fecha'));
        $this->definir_campo('regcla_comentario_mues',array('tipo'=>'texto','validart'=>'castellano'));
        $this->definir_campos_orden(array('regcla_ope','regcla_fecha','regcla_usu','regcla_enc'));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE registro_claves
  ADD CONSTRAINT "texto invalido en regcla_pedido_recep de tabla registro_claves" CHECK (comun.cadena_valida(regcla_pedido_recep::text, 'cualquiera'::text));
/*OTRA*/                            
ALTER TABLE registro_claves            
  ADD CONSTRAINT "texto invalido en regcla_comentario_mues de registro_claves" CHECK (comun.cadena_valida(regcla_comentario_mues::text, 'cualquiera'::text));
/*OTRA*/                            
ALTER TABLE registro_claves            
  ADD CONSTRAINT "texto invalido en regcla_ope de tabla registro_claves" CHECK (comun.cadena_valida(regcla_ope::text, 'codigo'::text));
/*OTRA*/                            
ALTER TABLE registro_claves            
  ADD CONSTRAINT "valor invalido en solucion_mues(1:Pendiente,2:Resuelto,3:No corresp.)"  CHECK (regcla_solucion_mues::integer in (1, 2, 3));
/*OTRA*/
 ALTER TABLE registro_claves 
  ALTER COLUMN regcla_fecha set DEFAULT ('now'::text)::date;
                            
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }

}

?>