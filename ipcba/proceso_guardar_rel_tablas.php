<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_guardar_rel_tablas extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $this->definir_parametros(array(
            'titulo'=>'Guardar un registro en '.$this->nombre_tabla,
            'permisos'=>array('grupo'=>'ingresador'),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'parametros'=>array_merge($this->parametros_separados['pk'],$this->parametros_separados['cambiar'],$this->parametros_separados['controlar']),
            'bitacora'=>true, // provisorio
            // 'bitacora'=>false, // provisorio
            'boton'=>array('id'=>'grabar'),
        ));
    }
    function responder(){
        $tabla=$this->nuevo_objeto('Tabla_'.$this->nombre_tabla);
        $filtro_update=array();
        $parametros_select=array();
        foreach($this->parametros_separados['pk'] as $nombre_campo=>$def_campo){
            $filtro_update[cambiar_prefijo($nombre_campo,'tra_','')]=$this->argumentos->{$nombre_campo};
            $parametros_select[":".$nombre_campo]=$this->argumentos->{$nombre_campo};
        }
        foreach($this->parametros_separados['controlar'] as $nombre_campo=>$def_campo){
            $valor=$this->argumentos->{$nombre_campo};
            if($valor===''){
                $valor=null;
            }
            $filtro_update[cambiar_prefijo($nombre_campo,'tra_ant_','')]=$valor;
        }
        $tabla->valores_para_update=array();
        foreach($this->parametros_separados['cambiar'] as $nombre_campo=>$def_campo){
            $valor=$this->argumentos->{$nombre_campo};
            if($valor===''){
                $valor=null;
            }
            $tabla->valores_para_update[cambiar_prefijo($nombre_campo,'tra_','')]=$valor;
        }
        try{
            $tabla->ejecutar_update_unico($filtro_update);
        }catch(Exception $err){
            return new Respuesta_Negativa('NO SE PUDO GRABAR, PROBABLEMENTE OTRO USUARIO MODIFICO EL REGISTRO. Mas detalles del error: '.$err->getMessage());
        }
        $cursor=$this->db->ejecutar_sql(new Sql($this->sql_select($parametros_select),$parametros_select));
        return new Respuesta_Positiva(array('nueva_fila'=>$cursor->fetchObject()));
    }
}
?>