<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";

class Vista_variaciones_maximas_vw extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'              ,array('tipo'=>'texto'  ,  'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('producto'             ,array('tipo'=>'texto' , 'es_pk'=>true, 'origen'=>'producto' ));
        $this->definir_campo('nombreproducto'       ,array('tipo'=>'texto' , 'origen'=>'nombreproducto' ));
        $this->definir_campo('variacion1'           ,array('tipo'=>'decimal', 'origen'=>'variacion1'));
        $this->definir_campo('variacion2'           ,array('tipo'=>'decimal', 'origen'=>'variacion2'));
        $this->definir_campo('variacion3'           ,array('tipo'=>'decimal', 'origen'=>'variacion3'));
        $this->definir_campo('variacion4'           ,array('tipo'=>'decimal', 'origen'=>'variacion4'));
        $this->definir_campo('variacion5'           ,array('tipo'=>'decimal', 'origen'=>'variacion5'));
        $this->definir_campo('variacion6'           ,array('tipo'=>'decimal', 'origen'=>'variacion6'));
        $this->definir_campo('variacion7'           ,array('tipo'=>'decimal', 'origen'=>'variacion7'));
        $this->definir_campo('variacion8'           ,array('tipo'=>'decimal', 'origen'=>'variacion8'));
        $this->definir_campo('variacion9'           ,array('tipo'=>'decimal', 'origen'=>'variacion9'));
        $this->definir_campo('variacion10'          ,array('tipo'=>'decimal', 'origen'=>'variacion10'));
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
        return "variaciones_maximas_vw";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
        'periodo',
        'producto',
        'nombreproducto',
        'variacion1',
        'variacion2',
        'variacion3',
        'variacion4',
        'variacion5',
        'variacion6',
        'variacion7',
        'variacion8',
        'variacion9',
        'variacion10',
        'informantes1',
        'informantes2',
        'informantes3',
        'informantes4',
        'informantes5',
        'informantes6',
        'informantes7',
        'informantes8',
        'informantes9',
        'informantes10'
        );
        return $campos_solo_lectura;
    }
}
?>