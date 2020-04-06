<?php
//UTF-8:SÍ 
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";
require_once "tablas.php";

class Tabla_periodos extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'                ,array('tipo'=>'texto'  ,'es_pk'=>true));
        $this->definir_campo('ano'                    ,array('tipo'=>'entero'));
        $this->definir_campo('mes'                    ,array('tipo'=>'entero'));
        $this->definir_campo('visita'                 ,array('tipo'=>'entero','def'=>1));
        $this->definir_campo('ingresando'             ,array('tipo'=>'texto','def'=>'S'));
        $this->definir_campo('fechageneracionperiodo' ,array('tipo'=>'timestamp'));
        $this->definir_campo('cerraringresocampohastapanel' ,array('tipo'=>'entero'));
        }
} 

class Grilla_periodos extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="periodos";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_periodos");
    }
    function campos_editables($filtro_para_lectura){
        $editables=array('cerraringresocampohastapanel');
        if(tiene_rol('coordinador')){
            $editables[]='ingresando';
        }
        return $editables;
    }
    function puede_insertar(){
        return true;
    }
    function campos_a_listar($filtro_para_lectura){
        return array('periodo', 'ano', 'mes', 'ingresando','fechageneracionperiodo','cerraringresocampohastapanel');
    }
    function pks(){
        return array('periodo');
    }
    function responder_detallar(){
        return false;
    }
    function boton_enviar(){
        return array(
            'leyenda'=>'ver',
            'title'=>'Ver paneles',
            'proceso'=>'relpan',
            'campos_parametros'=>array('tra_periodo'=>null),
            //'campos_parametros'=>array('agrupacion'=>$tra_agrupacion, 'grupo'=>$tra_grupo),
            'y_luego'=>'ver'
        );
    }
}
?>