<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";

class Vista_exportar_hdr_efectivossinprecio extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'                      ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('panel'                        ,array('tipo'=>'entero', 'origen'=>'panel'));
        $this->definir_campo('tarea'                        ,array('tipo'=>'entero', 'origen'=>'tarea'));
        $this->definir_campo('fechasalida'                  ,array('tipo'=>'timestamp', 'origen'=>'fechasalida'));
        $this->definir_campo('informante'                   ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'informante'));
        $this->definir_campo('encuestador'                  ,array('tipo'=>'texto', 'origen'=>'encuestador'));
        $this->definir_campo('nombreencuestador'            ,array('tipo'=>'texto', 'origen'=>'nombreencuestador'));
        $this->definir_campo('recepcionista'                ,array('tipo'=>'texto', 'origen'=>'recepcionista'));
        $this->definir_campo('nombrerecepcionista'          ,array('tipo'=>'texto', 'origen'=>'nombrerecepcionista'));
        $this->definir_campo('razon'                        ,array('tipo'=>'entero', 'origen'=>'razon'));
        $this->definir_campo('visita'                       ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'visita'));
        $this->definir_campo('nombreinformante'             ,array('tipo'=>'texto', 'origen'=>'nombreinformante'));
        $this->definir_campo('direccion'                    ,array('tipo'=>'texto', 'origen'=>'direccion'));
        $this->definir_campo('formulario'                   ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'formulario'));
        $this->definir_campo('nombreformulario'             ,array('tipo'=>'texto',  'origen'=>'nombreformulario'));
        $this->definir_campo('contacto'                     ,array('tipo'=>'texto', 'origen'=>'contacto'));
        $this->definir_campo('conjuntomuestral'             ,array('tipo'=>'entero', 'origen'=>'conjuntomuestral'));
        $this->definir_campo('ordenhdr'                     ,array('tipo'=>'entero', 'origen'=>'ordenhdr'));
        $this->definir_campo('distrito'                     ,array('tipo'=>'entero', 'origen'=>'distrito'));
        $this->definir_campo('fraccion'                     ,array('tipo'=>'entero', 'origen'=>'fraccion'));
        $this->definir_campo('rubro'                        ,array('tipo'=>'entero', 'origen'=>'rubro'));
        $this->definir_campo('nombrerubro'                  ,array('tipo'=>'texto', 'origen'=>'nombrerubro'));
        $this->definir_campo('maxperiodoinformado'          ,array('tipo'=>'texto', 'origen'=>'maxperiodoinformado'));
        $this->definir_campo('tipoprecios'                  ,array('tipo'=>'texto', 'origen'=>'tipoprecios'));
    }
    function clausula_from(){
        return "hdrexportarefectivossinprecio";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'periodo',
            'panel',
            'tarea',
            'fechasalida',
            'informante',
            'encuestador',
            'nombreencuestador',
            'recepcionista',
            'nombrerecepcionista',
            'razon',
            'visita',
            'nombreinformante',
            'direccion',
            'formulario',
            'nombreformulario',
            'contacto',
            'conjuntomuestral',
            'ordenhdr',
            'distrito',
            'fraccion',
            'rubro',
            'nombrerubro',
            'maxperiodoinformado',
            'tipoprecios'
             );
        return $campos_solo_lectura;
    }
    
     function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'panel'  
                                                    ,'tarea'       
                                                    ,'informante'
                                                    ,'formulario'
                                                     ));
    }
}
?>