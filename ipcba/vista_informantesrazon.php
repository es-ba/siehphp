<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
class Vista_informantesrazon extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'                      ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('razon'                        ,array('tipo'=>'entero', 'es_pk'=>true,'origen'=>'razon'));
        $this->definir_campo('nombrerazon'                  ,array('tipo'=>'texto', 'origen'=>'nombrerazon'));
        $this->definir_campo('cantformularios'              ,array('tipo'=>'entero', 'origen'=>'cantformularios'));
        $this->definir_campo('cantinformantes'              ,array('tipo'=>'entero', 'origen'=>'cantinformantes'));
    }
    function clausula_from(){
        return "informantesrazon";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'periodo',
            'razon',
            'nombrerazon',
            'cantformularios',
            'cantinformantes'
             );
        return $campos_solo_lectura;
    }
    
     function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'razon'  
                                                     ));
    }
}
?>