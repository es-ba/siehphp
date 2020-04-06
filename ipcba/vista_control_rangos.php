<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
class Vista_control_rangos extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'                      ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('producto'                     ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'producto'));
        $this->definir_campo('nombreproducto'               ,array('tipo'=>'texto', 'origen'=>'nombreproducto'));
        $this->definir_campo('informante'                   ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'informante'));
        $this->definir_campo('tipoinformante'               ,array('tipo'=>'entero', 'origen'=>'tipoinformante'));
        $this->definir_campo('observacion'                  ,array('tipo'=>'entero', 'es_pk'=>true,  'origen'=>'observacion'));
        $this->definir_campo('visita'                       ,array('tipo'=>'entero', 'es_pk'=>true,  'origen'=>'visita'));
        $this->definir_campo('panel'                        ,array('tipo'=>'entero', 'origen'=>'panel'));
        $this->definir_campo('tarea'                        ,array('tipo'=>'entero', 'origen'=>'tarea'));
        $this->definir_campo('encuestador'                  ,array('tipo'=>'texto', 'origen'=>'encuestador'));
        $this->definir_campo('formulario'                   ,array('tipo'=>'entero', 'origen'=>'formulario'));
        $this->definir_campo('precionormalizado'            ,array('tipo'=>'decimal', 'origen'=>'precionormalizado'));
        $this->definir_campo('tipoprecio'                   ,array('tipo'=>'texto', 'origen'=>'tipoprecio'));
        $this->definir_campo('cambio'                       ,array('tipo'=>'texto', 'origen'=>'cambio'));
        $this->definir_campo('repregunta'                   ,array('tipo'=>'texto', 'origen'=>'repregunta'));
        $this->definir_campo('impobs'                       ,array('tipo'=>'texto', 'origen'=>'impobs'));
        $this->definir_campo('precioant'                    ,array('tipo'=>'decimal', 'origen'=>'precioant'));
        $this->definir_campo('tipoprecioant'                ,array('tipo'=>'texto', 'origen'=>'tipoprecioant'));
        $this->definir_campo('antiguedadsinprecioant'       ,array('tipo'=>'entero', 'origen'=>'antiguedadsinprecioant'));
        $this->definir_campo('variac'                       ,array('tipo'=>'decimal', 'origen'=>'variac'));
        $this->definir_campo('comentariosrelpre'            ,array('tipo'=>'texto', 'origen'=>'comentariosrelpre'));
        $this->definir_campo('observaciones'                ,array('tipo'=>'texto', 'origen'=>'observaciones'));
        $this->definir_campo('promvar'                      ,array('tipo'=>'decimal', 'origen'=>'promvar'));
        $this->definir_campo('desvvar'                      ,array('tipo'=>'decimal', 'origen'=>'desvvar'));
        $this->definir_campo('promrotativo'                 ,array('tipo'=>'decimal', 'origen'=>'promrotativo'));
        $this->definir_campo('desvprot'                     ,array('tipo'=>'decimal', 'origen'=>'desvprot'));
        $this->definir_campo('razon_impobs_ant'             ,array('tipo'=>'texto', 'origen'=>'razon_impobs_ant'));
    }
    function clausula_from(){
        return "control_rangos";
    }
    function puede_detallar(){
        return false;
    }
    function campos_editables($filtro_para_lectura){
        //if(tiene_rol('coordinador') or tiene_rol('analista')){
            return array('observaciones');
        //};
    }    
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'periodo'                ,
            'producto'               ,
            'nombreproducto'         ,
            'informante'             ,
            'tipoinformante'         ,
            'observacion'            ,
            'visita'                 ,
            'panel'                  ,
            'tarea'                  ,
            'encuestador'            ,
            'formulario'             ,
            'precionormalizado'      ,
            'tipoprecio'             ,
            'cambio'                 ,
            'repregunta'             ,
            'impobs'                 ,
            'precioant'              ,
            'tipoprecioant'          ,
            'antiguedadsinprecioant' ,
            'variac'                 ,
            'comentariosrelpre'      ,
            'promvar'                ,
            'desvvar'                ,
            'promrotativo'           ,
            'desvprot'               ,
            'razon_impobs_ant'                    
            );
        return $campos_solo_lectura;
    }
    
     function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'
                                                   ,'producto'
                                                   ,'informante'
                                                   ,'observacion'
                                                   ,'visita'
                                                   ));
    }
}
?>