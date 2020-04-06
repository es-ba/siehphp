<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
class Vista_control_normalizables_sindato extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'               ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('producto'              ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'producto'));
        $this->definir_campo('nombreproducto'        ,array('tipo'=>'texto', 'origen'=>'nombreproducto'));
        $this->definir_campo('observacion'           ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'observacion'));        
        $this->definir_campo('informante'            ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'informante'));        
        $this->definir_campo('atributo'              ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'atributo'));        
        $this->definir_campo('valor'                 ,array('tipo'=>'texto', 'origen'=>'valor'));        
        $this->definir_campo('visita'                ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'visita'));        
        $this->definir_campo('validar_con_valvalatr' ,array('tipo'=>'logico', 'origen'=>'validar_con_valvalatr'));        
        $this->definir_campo('nombreatributo'        ,array('tipo'=>'texto', 'origen'=>'nombreatributo'));        
        $this->definir_campo('valornormal'           ,array('tipo'=>'decimal', 'origen'=>'valornormal'));        
        $this->definir_campo('orden'                 ,array('tipo'=>'entero', 'origen'=>'orden'));        
        $this->definir_campo('normalizable'          ,array('tipo'=>'texto', 'origen'=>'normalizable'));        
        $this->definir_campo('tiponormalizacion'     ,array('tipo'=>'texto', 'origen'=>'tiponormalizacion'));        
        $this->definir_campo('alterable'             ,array('tipo'=>'texto', 'origen'=>'alterable'));        
        $this->definir_campo('prioridad'             ,array('tipo'=>'entero', 'origen'=>'prioridad'));        
        $this->definir_campo('operacion'             ,array('tipo'=>'texto', 'origen'=>'operacion'));        
        $this->definir_campo('rangodesde'            ,array('tipo'=>'decimal', 'origen'=>'rangodesde'));        
        $this->definir_campo('rangohasta'            ,array('tipo'=>'decimal', 'origen'=>'rangohasta'));        
        $this->definir_campo('orden_calculo_especial',array('tipo'=>'entero', 'origen'=>'orden_calculo_especial'));        
        $this->definir_campo('tipo_promedio'         ,array('tipo'=>'texto', 'origen'=>'tipo_promedio'));        
        $this->definir_campo('formulario'            ,array('tipo'=>'entero', 'origen'=>'formulario'));
        $this->definir_campo('precio'                ,array('tipo'=>'decimal', 'origen'=>'precio'));
        $this->definir_campo('tipoprecio'            ,array('tipo'=>'texto', 'origen'=>'tipoprecio'));
        $this->definir_campo('comentariosrelpre'     ,array('tipo'=>'texto', 'origen'=>'comentariosrelpre'));
        $this->definir_campo('cambio'                ,array('tipo'=>'texto', 'origen'=>'cambio'));        
        $this->definir_campo('precionormalizado'     ,array('tipo'=>'decimal', 'origen'=>'precionormalizado'));
        $this->definir_campo('especificacion'        ,array('tipo'=>'entero', 'origen'=>'especificacion'));
        $this->definir_campo('ultima_visita'         ,array('tipo'=>'logico', 'origen'=>'ultima_visita'));
        $this->definir_campo('panel'                 ,array('tipo'=>'entero', 'origen'=>'panel'));
        $this->definir_campo('tarea'                 ,array('tipo'=>'entero', 'origen'=>'tarea'));
        $this->definir_campo('encuestador'           ,array('tipo'=>'texto', 'origen'=>'encuestador'));
        $this->definir_campo('recepcionista'         ,array('tipo'=>'texto', 'origen'=>'recepcionista'));
    }
    function clausula_from(){
        return "control_normalizables_sindato";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
        'periodo', 
        'producto',
        'nombreproducto',
        'observacion', 
        'informante',
        'atributo', 
        'valor', 
        'visita', 
        'validar_con_valvalatr', 
        'nombreatributo', 
        'valornormal', 
        'orden',
        'normalizable', 
        'tiponormalizacion', 
        'alterable', 
        'prioridad', 
        'operacion', 
        'rangodesde', 
        'rangohasta', 
        'orden_calculo_especial', 
        'tipo_promedio', 
        'formulario', 
        'precio', 
        'tipoprecio',
        'comentariosrelpre', 
        'cambio', 
        'precionormalizado', 
        'especificacion',
        'ultima_visita', 
        'panel', 
        'tarea', 
        'encuestador',
        'recepcionista'
        );
        return $campos_solo_lectura;
    }
    
     function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'producto'
                                                    ,'observacion'
                                                    ,'informante'
                                                    ,'atributo'
                                                    ,'visita'
                                                     ));
    }
}
?>