<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";

class Vista_canasta_producto extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'              ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('calculo'              ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'calculo'));
        $this->definir_campo('agrupacion'           ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'agrupacion' ));
        $this->definir_campo('producto'             ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'producto'));
        $this->definir_campo('nombreproducto'       ,array('tipo'=>'texto', 'origen'=>'nombreproducto'));
        $this->definir_campo('valorprod'            ,array('tipo'=>'decimal', 'origen'=>'valorprod'));
        $this->definir_campo('grupopadre'           ,array('tipo'=>'texto', 'origen'=>'grupopadre'));
        $this->definir_campo('grupoparametro'       ,array('tipo'=>'texto', 'origen'=>'grupoparametro'));
        $this->definir_campo('parametro'            ,array('tipo'=>'texto', 'origen'=>'parametro'));
        $this->definir_campo('nombreparametro'      ,array('tipo'=>'texto', 'origen'=>'nombreparametro'));
        $this->definir_campo('hogar'                ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'hogar'));
        $this->definir_campo('coefhoggru'           ,array('tipo'=>'decimal', 'origen'=>'coefhoggru'));
        $this->definir_campo('valorhogprod'         ,array('tipo'=>'decimal', 'origen'=>'valorhogprod'));
        $this->definir_campo('divisioncanasta'      ,array('tipo'=>'texto', 'origen'=>'divisioncanasta'));
        $this->definir_campo('agrupo1'              ,array('tipo'=>'texto', 'origen'=>'agrupo1'));
        $this->definir_campo('agrupo2'              ,array('tipo'=>'texto', 'origen'=>'agrupo2'));
        $this->definir_campo('agrupo3'              ,array('tipo'=>'texto', 'origen'=>'agrupo3'));
        $this->definir_campo('agrupo4'              ,array('tipo'=>'texto', 'origen'=>'agrupo4'));
        $this->definir_campo('bgrupo0'              ,array('tipo'=>'texto', 'origen'=>'bgrupo0'));
        $this->definir_campo('bgrupo1'              ,array('tipo'=>'texto', 'origen'=>'bgrupo1'));
        $this->definir_campo('bgrupo2'              ,array('tipo'=>'texto', 'origen'=>'bgrupo2'));
        $this->definir_campo('bgrupo3'              ,array('tipo'=>'texto', 'origen'=>'bgrupo3'));
        $this->definir_campo('bgrupo4'              ,array('tipo'=>'texto', 'origen'=>'bgrupo4'));
    }
     function clausula_from(){
        return "canasta_producto";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'periodo'    ,
            'calculo'    ,
            'agrupacion'    ,
            'producto'    ,
            'nombreproducto' ,
            'valorprod'      ,
            'grupopadre'     ,
            'grupoparametro'  ,
            'parametro'     ,
            'nombreparametro',
            'hogar',
            'coefhoggru',
            'valorhogprod',
            'divisioncanasta',
            'agrupo1',
            'agrupo2',
            'agrupo3',
            'agrupo4',
            'bgrupo0',
            'bgrupo1',
            'bgrupo2',
            'bgrupo3',
            'bgrupo4'
             );
        return $campos_solo_lectura;
    }
    
     function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'calculo'  
                                                    ,'agrupacion'       
                                                    ,'hogar'
                                                    ,'producto'
                                                     ));
    }
}
?>