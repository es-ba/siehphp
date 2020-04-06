<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
class Vista_informantesaltasbajas extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodoanterior'              ,array('tipo'=>'texto', 'origen'=>'periodoanterior'));
        $this->definir_campo('informante'                   ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'informante'));
        $this->definir_campo('visita'                       ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'visita'));
        $this->definir_campo('rubro'                        ,array('tipo'=>'entero', 'origen'=>'rubro'));
        $this->definir_campo('nombrerubro'                  ,array('tipo'=>'texto', 'origen'=>'nombrerubro'));
        $this->definir_campo('formulario'                   ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'formulario'));
        $this->definir_campo('nombreformulario'             ,array('tipo'=>'texto', 'origen'=>'nombreformulario'));
        $this->definir_campo('panelanterior'                ,array('tipo'=>'entero', 'origen'=>'panelanterior'));
        $this->definir_campo('tareaanterior'                ,array('tipo'=>'entero', 'origen'=>'tareaanterior'));
        $this->definir_campo('razonanterior'                ,array('tipo'=>'entero', 'origen'=>'razonanterior'));
        $this->definir_campo('nombrerazonanterior'          ,array('tipo'=>'texto', 'origen'=>'nombrerazonanterior'));
        $this->definir_campo('periodo'                      ,array('tipo'=>'texto', 'origen'=>'periodo'));
        $this->definir_campo('panel'                        ,array('tipo'=>'entero', 'origen'=>'panel'));
        $this->definir_campo('tarea'                        ,array('tipo'=>'entero', 'origen'=>'tarea'));
        $this->definir_campo('razon'                        ,array('tipo'=>'entero', 'origen'=>'razon'));
        $this->definir_campo('nombrerazon'                  ,array('tipo'=>'texto', 'origen'=>'nombrerazon'));
        $this->definir_campo('tipo'                         ,array('tipo'=>'texto', 'origen'=>'tipo'));
        $this->definir_campo('distrito'                     ,array('tipo'=>'entero', 'origen'=>'distrito'));
        $this->definir_campo('fraccion'                     ,array('tipo'=>'entero', 'origen'=>'fraccion'));
        $this->definir_campo('cantformactivos'              ,array('tipo'=>'entero', 'origen'=>'cantformactivos'));
    }
    function clausula_from(){
        return "informantesaltasbajas";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'periodoanterior',
            'informante',
            'visita',
            'rubro',
            'nombrerubro',
            'formulario',
            'nombreformulario',
            'panelanterior',
            'tareaanterior',
            'razonanterior',
            'nombrerazonanterior',
            'periodo',
            'panel',
            'tarea',
            'razon',
            'nombrerazon',
            'tipo',
            'distrito',
            'fraccion',
            'cantformactivos'
             );
        return $campos_solo_lectura;
    }
    
     function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'panel'  
                                                    ,'tarea'       
                                                    ,'informante'
                                                    ,'visita'
                                                    ,'formulario'
                                                     ));
    }
}

/*
class Vista_informantesaltasbajas extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'                      ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('informante'                   ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'informante'));
        $this->definir_campo('visita'                       ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'visita'));
        $this->definir_campo('formulario'                   ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'formulario'));
        $this->definir_campo('nombreformulario'             ,array('tipo'=>'texto', 'origen'=>'nombreformulario'));
        $this->definir_campo('razon'                        ,array('tipo'=>'entero', 'origen'=>'razon'));
        $this->definir_campo('nombrerazon'                  ,array('tipo'=>'texto', 'origen'=>'nombrerazon'));
        $this->definir_campo('panel'                        ,array('tipo'=>'entero', 'origen'=>'panel'));
        $this->definir_campo('tarea'                        ,array('tipo'=>'entero', 'origen'=>'tarea'));
        $this->definir_campo('fechasalida'                  ,array('tipo'=>'timestamp', 'origen'=>'fechasalida'));
        $this->definir_campo('fechaingreso'                 ,array('tipo'=>'timestamp', 'origen'=>'fechaingreso'));
        $this->definir_campo('ingresador'                   ,array('tipo'=>'texto', 'origen'=>'ingresador'));
        $this->definir_campo('encuestador'                  ,array('tipo'=>'texto', 'origen'=>'encuestador'));
        $this->definir_campo('recepcionista'                ,array('tipo'=>'texto', 'origen'=>'recepcionista'));
        $this->definir_campo('alta'                         ,array('tipo'=>'texto', 'origen'=>'alta'));
        $this->definir_campo('nombreinformante'             ,array('tipo'=>'texto', 'origen'=>'nombreinformante'));
        $this->definir_campo('distrito'                     ,array('tipo'=>'entero', 'origen'=>'distrito'));
        $this->definir_campo('fraccion'                     ,array('tipo'=>'entero', 'origen'=>'fraccion'));
        $this->definir_campo('contacto'                     ,array('tipo'=>'texto', 'origen'=>'contacto'));
    }
    function clausula_from(){
        return "informantesaltasbajas";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'periodo',
            'informante',
            'visita',
            'formulario',
            'nombreformulario',
            'razon',
            'nombrerazon',
            'panel',
            'tarea',
            'fechasalida',
            'fechaingreso',
            'ingresador',
            'encuestador',
            'recepcionista',
            'alta',
            'nombreinformante',
            'distrito',
            'fraccion',
            'contacto'
             );
        return $campos_solo_lectura;
    }
    
     function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'panel'  
                                                    ,'tarea'       
                                                    ,'informante'
                                                    ,'visita'
                                                    ,'formulario'
                                                     ));
    }
}
*/
?>