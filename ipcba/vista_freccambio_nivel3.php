<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
class Vista_freccambio_nivel3 extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodonombre'                ,array('tipo'=>'texto', 'origen'=>'periodonombre'));
        $this->definir_campo('periodo'                      ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('grupo'                        ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'grupo'));
        $this->definir_campo('nombregrupo'                  ,array('tipo'=>'texto', 'origen'=>'nombregrupo'));
        $this->definir_campo('estado'                       ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'estado'));
        $this->definir_campo('promgeoobs'                   ,array('tipo'=>'decimal', 'origen'=>'promgeoobs'));
        $this->definir_campo('promgeoobsant'                ,array('tipo'=>'decimal', 'origen'=>'promgeoobsant'));
        $this->definir_campo('variacion'                    ,array('tipo'=>'decimal', 'origen'=>'variacion'));
        $this->definir_campo('cantobsporestado'             ,array('tipo'=>'entero', 'origen'=>'cantobsporestado'));
        $this->definir_campo('cantobsporgrupo'              ,array('tipo'=>'entero', 'origen'=>'cantobsporgrupo'));
        $this->definir_campo('porcobs'                      ,array('tipo'=>'decimal', 'origen'=>'porcobs'));
    }
    function clausula_from(){
        return "freccambio_nivel3";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'periodonombre',
            'periodo',
            'grupo',
            'nombregrupo',
            'estado',
            'promgeoobs',
            'promgeoobsant',
            'variacion',
            'cantobsporestado',
            'cantobsporgrupo',
            'porcobs'
             );
        return $campos_solo_lectura;
    }
    
     function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'grupo'
                                                    ,'nombregrupo'
                                                    ,'estado'
                                                     ));
    }
}
?>