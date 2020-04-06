<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
class Vista_control_tipoprecio extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'                      ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('producto'                     ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'producto'));
        $this->definir_campo('nombreproducto'               ,array('tipo'=>'texto', 'origen'=>'nombreproducto'));
        $this->definir_campo('tipoinformante'               ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'tipoinformante'));
        $this->definir_campo('rubro'                        ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'rubro'));
        $this->definir_campo('nombrerubro'                  ,array('tipo'=>'texto', 'origen'=>'nombrerubro'));
        $this->definir_campo('tipoprecio'                   ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'tipoprecio'));
        $this->definir_campo('nombretipoprecio'             ,array('tipo'=>'texto', 'origen'=>'nombretipoprecio'));
        $this->definir_campo('cantidad'                     ,array('tipo'=>'entero', 'origen'=>'cantidad'));
    }
    function clausula_from(){
        return "control_tipoprecio";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'periodo',
            'producto',
            'nombreproducto',
            'tipoinformante',
            'rubro',
            'nombrerubro',
            'tipoprecio',
            'nombretipoprecio',
            'cantidad'
             );
        return $campos_solo_lectura;
    }
    
     function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'
                                                    ,'producto'        
                                                    ,'tipoinformante'
                                                    ,'rubro'
                                                    ,'tipoprecio'
                                                     ));
    }
}
?>