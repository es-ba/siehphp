<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_prodatr extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('producto'              ,array('hereda'=>'productos','modo'=>'pk'));
        $this->definir_campo('atributo'              ,array('hereda'=>'atributos','modo'=>'pk'));
        $this->definir_campo('valornormal'           ,array('tipo'=>'real'));
        $this->definir_campo('orden'                 ,array('tipo'=>'entero'));
        $this->definir_campo('normalizable'          ,array('tipo'=>'texto'));
        $this->definir_campo('tiponormalizacion'     ,array('tipo'=>'texto'));
        $this->definir_campo('alterable'             ,array('tipo'=>'texto'));
        $this->definir_campo('prioridad'             ,array('tipo'=>'entero'));
        $this->definir_campo('operacion'             ,array('tipo'=>'texto'));
        $this->definir_campo('rangodesde'            ,array('tipo'=>'real'));
        $this->definir_campo('rangohasta'            ,array('tipo'=>'real'));
        $this->definir_campo('orden_calculo_especial',array('tipo'=>'entero'));
        $this->definir_campo('tipo_promedio'         ,array('tipo'=>'texto'));
    }
} 

class Grilla_prodatr extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_prodatr");
        $this->tabla->campos_lookup=array(
            "nombreatributo"=>false,
            "tipodato"=>false,
            "abratributo"=>false,
            "escantidad"=>false,
            "unidaddemedida"=>false,
            "es_vigencia"=>false,
            "valorinicial"=>false
        );
        $this->tabla->tablas_lookup=array(            
            '(select atributo as atr, nombreatributo,tipodato,abratributo,escantidad,unidaddemedida,es_vigencia,valorinicial  from atributos) atr'=>'atr=atributo',
             );
    }
    function campos_editables($filtro_para_lectura){
        if(tiene_rol('coordinador')){
            return array('rangodesde','rangohasta','orden');
        };
        return array();
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return array('*');
        return $this->ordenar_campos_a_listar(array('producto'       
                                                    ,'atributo'));
    }
    function boton_enviar(){
        return array(
            'leyenda'=>'ver',
            'title'=>'Ver ficha del producto',
            'proceso'=>'ficha_producto',
            'campos_parametros'=>array('tra_producto'=>null),
            'y_luego'=>'ver'
        );
    }
}

?>