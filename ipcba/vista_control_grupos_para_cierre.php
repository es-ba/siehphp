<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
class Vista_control_grupos_para_cierre extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'                       ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('calculo'                       ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'calculo'));
        $this->definir_campo('agrupacion'                    ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'agrupacion'));
        $this->definir_campo('grupo'                         ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'grupo'));
        $this->definir_campo('nombre'                        ,array('tipo'=>'texto', 'origen'=>'nombre'));
        $this->definir_campo('nivel'                         ,array('tipo'=>'entero', 'origen'=>'nivel'));
        $this->definir_campo('variacion'                     ,array('tipo'=>'decimal', 'origen'=>'variacion'));
        $this->definir_campo('incidencia'                    ,array('tipo'=>'decimal', 'origen'=>'incidencia'));
        $this->definir_campo('variacioninteranualredondeada' ,array('tipo'=>'decimal', 'origen'=>'variacioninteranualredondeada'));
        $this->definir_campo('incidenciainteranual'          ,array('tipo'=>'decimal', 'origen'=>'incidenciainteranual'));
        $this->definir_campo('ponderador'                    ,array('tipo'=>'decimal', 'origen'=>'ponderador'));
        $this->definir_campo('ordenpor'                      ,array('tipo'=>'texto', 'origen'=>'ordenpor')); 
        $this->definir_campo('cantincluidos'                 ,array('tipo'=>'entero', 'origen'=>'cantincluidos'));
        $this->definir_campo('cantrealesincluidos'           ,array('tipo'=>'entero', 'origen'=>'cantrealesincluidos'));
        $this->definir_campo('cantimputados'                 ,array('tipo'=>'entero', 'origen'=>'cantimputados'));        
    }
    function clausula_from(){
        return "control_grupos_para_cierre";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'periodo',
            'calculo',
            'agrupacion',
            'grupo',
            'nombre',
            'nivel',
            'variacion',
            'incidencia',
            'variacioninteranualredondeada',
            'incidenciainteranual',
            'ponderador',
            'orenpor',
            'cantincluidos',
            'cantrealesincluidos',
            'cantimputados'
             );
        return $campos_solo_lectura;
    }
    
     function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'calculo'
                                                    ,'agrupacion'
                                                    ,'grupo'
                                                     ));
    }
}
?>