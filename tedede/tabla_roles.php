<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";
// require_once "valores_especiales.php";

function rol_actual(){
    return @$_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_usu_rol"]?:'ninguno';
}

function tiene_rol($rol){
    if(rol_actual()=='programador'){
        return true; // el programador tiene todos los roles
    }
    $todos_los_roles=@$_SESSION["{$GLOBALS['NOMBRE_APP']}_usu_todos_los_roles"]?:array();
    if(in_array($rol,$todos_los_roles)) {
        return true;
    }
    return false;
}

function forzar_rol_actual($nombre_rol){
    $_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_usu_rol"]=$nombre_rol;
}

class Tabla_roles extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('rol');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('rol_rol',array('es_pk'=>true,'tipo'=>'texto','largo'=>30,'not_null'=>true,'validart'=>'codigo'));
        $this->definir_campo('rol_descripcion',array('tipo'=>'texto','largo'=>200,'validart'=>'castellano'));
        $this->definir_campo('rol_ver_con_hasta_nivel',array('tipo'=>'entero'));
        $this->definir_tablas_hijas(array(
            'rol_rol'=>true,
            'usuarios'=>true,/*'personal'=>true,'anoenc'=>true */
            // 'rol_pla'=>true,  
            // 'est_rol'=>true,              
        ));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE roles
  ADD CONSTRAINT "texto invalido en rol_descripcion de tabla roles" CHECK (comun.cadena_valida(rol_descripcion::text, 'castellano'::text));
/*OTRA*/
ALTER TABLE roles
  ADD CONSTRAINT "texto invalido en rol_rol de tabla roles" CHECK (comun.cadena_valida(rol_rol::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }    
}

?>