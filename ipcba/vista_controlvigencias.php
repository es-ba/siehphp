<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
class Vista_controlvigencias extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'                      ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('informante'                   ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'informante'));
        $this->definir_campo('producto'                     ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'producto'));
        $this->definir_campo('nombreproducto'               ,array('tipo'=>'texto', 'origen'=>'nombreproducto'));
        $this->definir_campo('observacion'                  ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'observacion'));
        $this->definir_campo('valor'                        ,array('tipo'=>'texto', 'origen'=>'valor'));
        $this->definir_campo('ultimodiadelmes'              ,array('tipo'=>'entero', 'origen'=>'ultimodiadelmes'));
        $this->definir_campo('cantdias'                     ,array('tipo'=>'entero', 'origen'=>'cantdias'));
        $this->definir_campo('visitas'                      ,array('tipo'=>'entero', 'origen'=>'visitas'));
        $this->definir_campo('vigencias'                    ,array('tipo'=>'entero', 'origen'=>'vigencias'));
        $this->definir_campo('comentarios'                  ,array('tipo'=>'texto', 'origen'=>'comentarios'));
    }
    function clausula_from(){
        return "controlvigencias";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'periodo',
            'informante',
            'producto',
            'nombreproducto',
            'observacion',
            'valor',
            'ultimodiadelmes',
            'cantdias',
            'visitas',
            'vigencias',
            'comentarios'
             );
        return $campos_solo_lectura;
    }
    
     function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'informante'
                                                    ,'producto'
                                                    ,'observacion'
                                                     ));
    }
}
?>