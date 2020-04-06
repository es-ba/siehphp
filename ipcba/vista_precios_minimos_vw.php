<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";

class Vista_precios_minimos_vw extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'              ,array('tipo'=>'texto'  ,  'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('producto'             ,array('tipo'=>'texto' , 'es_pk'=>true, 'origen'=>'producto' ));
        $this->definir_campo('nombreproducto'       ,array('tipo'=>'texto' , 'origen'=>'nombreproducto' ));
        $this->definir_campo('precio1'              ,array('tipo'=>'texto', 'origen'=>'precio1'));
        $this->definir_campo('precio2'              ,array('tipo'=>'texto', 'origen'=>'precio2'));
        $this->definir_campo('precio3'              ,array('tipo'=>'texto', 'origen'=>'precio3'));
        $this->definir_campo('precio4'              ,array('tipo'=>'texto', 'origen'=>'precio4'));
        $this->definir_campo('precio5'              ,array('tipo'=>'texto', 'origen'=>'precio5'));
        $this->definir_campo('precio6'              ,array('tipo'=>'texto', 'origen'=>'precio6'));
        $this->definir_campo('precio7'              ,array('tipo'=>'texto', 'origen'=>'precio7'));
        $this->definir_campo('precio8'              ,array('tipo'=>'texto', 'origen'=>'precio8'));
        $this->definir_campo('precio9'              ,array('tipo'=>'texto', 'origen'=>'precio9'));
        $this->definir_campo('precio10'             ,array('tipo'=>'texto', 'origen'=>'precio10'));
        $this->definir_campo('informantes1'         ,array('tipo'=>'texto', 'origen'=>'informantes1'));
        $this->definir_campo('informantes2'         ,array('tipo'=>'texto', 'origen'=>'informantes2'));
        $this->definir_campo('informantes3'         ,array('tipo'=>'texto', 'origen'=>'informantes3'));
        $this->definir_campo('informantes4'         ,array('tipo'=>'texto', 'origen'=>'informantes4'));
        $this->definir_campo('informantes5'         ,array('tipo'=>'texto', 'origen'=>'informantes5'));
        $this->definir_campo('informantes6'         ,array('tipo'=>'texto', 'origen'=>'informantes6'));
        $this->definir_campo('informantes7'         ,array('tipo'=>'texto', 'origen'=>'informantes7'));
        $this->definir_campo('informantes8'         ,array('tipo'=>'texto', 'origen'=>'informantes8'));
        $this->definir_campo('informantes9'         ,array('tipo'=>'texto', 'origen'=>'informantes9'));
        $this->definir_campo('informantes10'        ,array('tipo'=>'texto', 'origen'=>'informantes10'));
        $this->definir_campos_orden(array('periodo','producto'));
      
    }
     function clausula_from(){
        return "precios_minimos_vw";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
        'periodo',
        'producto',
        'nombreproducto',
        'precio1',
        'precio2',
        'precio3',
        'precio4',
        'precio5',
        'precio6',
        'precio7',
        'precio8',
        'precio9',
        'precio10',
        'informantes1',
        'informantes2',
        'informantes3',
        'informantes4',
        'informantes5',
        'informantes6',
        'informantes7',
        'informantes8',
        'informantes9',
        'informantes10',
        );
        return $campos_solo_lectura;
    }
}
?>