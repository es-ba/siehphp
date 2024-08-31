<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_cuadros extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('cuadro'       ,array('es_pk'=>true,'tipo'=>'texto','largo'=>10));
        $this->definir_campo('descripcion'  ,array('tipo'=>'texto','largo'=>200,'not_null'=>true, 'mostrar_al_elegir'=>true));
        $this->definir_campo('funcion'      ,array('tipo'=>'texto','largo'=>30, 'not_null'=>true));
        $this->definir_campo('parametro1'   ,array('tipo'=>'texto','largo'=>100,'not_null'=>false));
        $this->definir_campo('periodo'      ,array('tipo'=>'texto','largo'=>20 ,'not_null'=>false));
        $this->definir_campo('nivel'        ,array('tipo'=>'entero'            ,'not_null'=>false));
        $this->definir_campo('grupo'        ,array('tipo'=>'texto','largo'=>9  ,'not_null'=>false));
        $this->definir_campo('agrupacion'   ,array('tipo'=>'texto','largo'=>9  ,'not_null'=>false));
        $this->definir_campo('encabezado'   ,array('tipo'=>'texto','largo'=>500,'not_null'=>false));
        $this->definir_campo('pie'          ,array('tipo'=>'texto','largo'=>300,'not_null'=>false));
        $this->definir_campo('ponercodigos' ,array('tipo'=>'logico'            ,'not_null'=>false));
        $this->definir_campo('agrupacion2'  ,array('tipo'=>'texto','largo'=>9  ,'not_null'=>false));
        $this->definir_campo('hogares'      ,array('tipo'=>'entero'            ,'not_null'=>false));
        $this->definir_campo('pie1'         ,array('tipo'=>'texto','largo'=>300,'not_null'=>false));
        $this->definir_campo('cantdecimales',array('tipo'=>'entero'            ,'not_null'=>false));
        $this->definir_campo('activo'       ,array('tipo'=>'texto','largo'=>1  ,'not_null'=>true));
        $this->definir_campos_orden(array('para_ordenar_numeros(cuadro)'));

    }
}

class Grilla_cuadros extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="cuadros";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_cuadros");
    }
    function campos_editables($filtro_para_lectura){
        $editables=array('descripcion','encabezado','pie','pie1');
        /*
        if(tiene_rol('coordinador')){
            $editables[]='ingresando';
        }
        */
        return $editables;
    }    
    function campos_a_listar($filtro_para_lectura){
        return array('cuadro', 'descripcion', 'funcion', 'parametro1','periodo','nivel','grupo','agrupacion','encabezado','pie',
                     'ponercodigos','agrupacion','hogares','pie1','cantdecimales');
    }
    function pks(){
        return array('cuadro');
    }

}
    
?>