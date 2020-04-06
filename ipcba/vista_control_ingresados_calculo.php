<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";

class Vista_control_ingresados_calculo extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'                      ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('producto'                     ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'producto'));
        $this->definir_campo('nombreproducto'               ,array('tipo'=>'texto', 'origen'=>'nombreproducto'));
        $this->definir_campo('informante'                   ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'informante'));
        $this->definir_campo('nombreinformante'             ,array('tipo'=>'texto', 'origen'=>'nombreinformante'));
        $this->definir_campo('observacion'                  ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'observacion'));
        $this->definir_campo('tipoinformante'               ,array('tipo'=>'texto', 'origen'=>'tipoinformante'));
        $this->definir_campo('divisionesdelproducto'        ,array('tipo'=>'texto', 'origen'=>'divisionesdelproducto'));
        $this->definir_campo('fechamodificacioninformante'  ,array('tipo'=>'timestamp', 'origen'=>'fechamodificacioninformante'));
    }
 //i.tipoinformante, pd.divisionesdelproducto,fechamodificacioninformante
    function clausula_from(){
        return "control_ingresados_calculo";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'periodo'    ,
            'producto'    ,
            'nombreproducto' ,
            'informante'      ,
            'nombreinformante'      ,
            'observacion'     ,
            'tipoinformante'  ,
            'divisionesdelproducto'     ,
            'fechamodificacioninformante'     
             );
        return $campos_solo_lectura;
    }
    
     function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'producto'  
                                                    ,'informante'       
                                                    ,'observacion'
                                                     ));
    }
}
?>