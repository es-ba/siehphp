<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_relpan extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        //$this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo',array('hereda'=>'periodos','modo'=>'pk'));
        $this->definir_campo('panel',array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('fechasalida',array('tipo'=>'fecha'));
        $this->definir_campo('fechageneracionpanel',array('tipo'=>'timestamp'));
        $this->definir_campo('periodoparapanelrotativo',array('tipo'=>'texto','largo'=>11));
        $this->definir_campo('generacionsupervisiones',array('tipo'=>'timestamp'));
    }
}

class Grilla_relpan extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="relpan";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_relpan");
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
                'periodo',        
                'panel',
                'fechageneracionpanel',
                'periodoparapanelrotativo',
                'generacionsupervisiones'
        );
        return $campos_solo_lectura;
    }
    function campos_editables($filtro_para_lectura){
        $editables=array('fechasalida');
        return $editables;
    }
    function campos_a_excluir($filtro_para_lectura){
        return array();
    }
    function permite_grilla_sin_filtro(){
            return false;
    }
    function puede_insertar(){
        return false;
    }
    function boton_enviar(){
        return array(
            'leyenda'=>'ver',
            'title'=>'Ver Ingreso visitas',
            'proceso'=>'ingreso',
            'campos_parametros'=>array('tra_periodo'=>null,'tra_panel'=>null),
            'y_luego'=>'ver'
        );
    }
}
?>