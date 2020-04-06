<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
class Vista_relpre_1_sn extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'                      ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('producto'                     ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'producto'));
        $this->definir_campo('observacion'                  ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'observacion'));
        $this->definir_campo('informante'                   ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'informante'));
        $this->definir_campo('formulario'                   ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'formulario'));
        $this->definir_campo('visita'                       ,array('tipo'=>'entero', 'es_pk'=>true,  'origen'=>'visita'));
        $this->definir_campo('precio'                       ,array('tipo'=>'decimal', 'origen'=>'precio'));
        $this->definir_campo('tipoprecio'                   ,array('tipo'=>'texto', 'origen'=>'tipoprecio'));
        $this->definir_campo('cambio'                       ,array('tipo'=>'texto', 'origen'=>'cambio'));
        $this->definir_campo('precionormalizado'            ,array('tipo'=>'decimal', 'origen'=>'precionormalizado'));
        $this->definir_campo('comentarios'                  ,array('tipo'=>'texto', 'origen'=>'comentarios'));
        $this->definir_campo('observaciones'                ,array('tipo'=>'texto', 'origen'=>'observaciones'));      
        $this->definir_campo('periodo1'                     ,array('tipo'=>'texto', 'origen'=>'periodo1'));
        $this->definir_campo('visita1'                      ,array('tipo'=>'entero', 'origen'=>'visita1'));
        $this->definir_campo('precio1'                      ,array('tipo'=>'decimal', 'origen'=>'precio1'));
        $this->definir_campo('tipoprecio1'                  ,array('tipo'=>'texto', 'origen'=>'tipoprecio1'));
        $this->definir_campo('cambio1'                      ,array('tipo'=>'texto', 'origen'=>'cambio1'));
        $this->definir_campo('precionormalizado1'           ,array('tipo'=>'decimal', 'origen'=>'precionormalizado1'));
        $this->definir_campo('comentarios1'                 ,array('tipo'=>'texto', 'origen'=>'comentarios1'));
        $this->definir_campo('panel'                        ,array('tipo'=>'entero', 'origen'=>'panel'));
        $this->definir_campo('tarea'                        ,array('tipo'=>'entero', 'origen'=>'tarea'));
        $this->definir_campo('encuestador'                  ,array('tipo'=>'texto', 'origen'=>'encuestador'));
        $this->definir_campo('encuestadornombre'            ,array('tipo'=>'texto', 'origen'=>'encuestadornombre'));
    }
    function clausula_from(){
        return "(SELECT r.periodo, r.producto, r.observacion, r.informante, r.formulario, r.visita, r.precio, r.tipoprecio, r.cambio, r.precionormalizado, 
                 r.comentariosrelpre as comentarios, r.observaciones, r.periodo_1 as periodo1, r.visita_1 as visita1, r.precio_1 as precio1, r.tipoprecio_1 as tipoprecio1, 
                 r.cambio_1 as cambio1, r.precionormalizado_1 as precionormalizado1, r.comentariosrelpre_1 as comentarios1, v.panel, v.tarea, v.encuestador, 
                 p.nombre||' '||p.apellido AS encuestadornombre
                 FROM relpre_1 r left join relvis v on r.periodo = v.periodo and r.informante = v.informante and r.formulario = v.formulario and r.visita = v.visita
                 left join personal p on v.encuestador = p.persona
                 where r.tipoprecio_1 in ('S','N')) as reg";
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
?>