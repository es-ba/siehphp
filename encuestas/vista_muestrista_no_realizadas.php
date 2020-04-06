<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";

class Vista_muestrista_no_realizadas extends Vistas{
    function definicion_estructura(){
    $this->definir_campo('vis_enc'                    ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'t.pla_enc'                         ));
    $this->definir_campo('vis_id_marco'               ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_id_marco'                      ));
    $this->definir_campo('vis_comuna'                 ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_comuna'                        ));
    $this->definir_campo('vis_rotaci_n_etoi'          ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_rotaci_n_etoi'                 ));
    $this->definir_campo('vis_rotaci_n_eah'           ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_rotaci_n_eah'                  ));
    $this->definir_campo('vis_trimestre'              ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_trimestre'                     ));
    $this->definir_campo('vis_semana'                 ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_semana'                        ));
    $this->definir_campo('vis_dominio'                ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_dominio'                          ));
    $this->definir_campo('vis_zona'                   ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_zona'                          ));
    $this->definir_campo('vis_areaup'                 ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_areaup'                        ));
    if ($GLOBALS['NOMBRE_APP']=='same2014'){
        /*para same, no se si para el resto:*/ 
        $this->definir_campo('vis_up_comuna'          ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_up_comuna'                     ));
    }
    $this->definir_campo('vis_estrato'                ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_estrato'                       ));
    $this->definir_campo('vis_rea'                    ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_rea'                           ));        
    $this->definir_campo('vis_razon'                  ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_norea'                         ));        
    $this->definir_campo('vis_cnombre'                ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_cnombre'                       ));
    $this->definir_campo('vis_hn'                     ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_hn'                            ));
    $this->definir_campo('vis_hp'                     ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_hp'                            ));
    $this->definir_campo('vis_hd'                     ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_hd'                            ));
    $this->definir_campo('vis_hab'                    ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_hab'                           ));
    $this->definir_campo('vis_estado'                 ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_estado'                        ));
    //$this->definir_campo('vis_h2_6'                   ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_h2_6'                         ));
    $this->definir_campo('vis_obs'                    ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_s1a1_obs'                      ));
    }
    function clausula_from(){
        return "plana_tem_ t left join plana_s1_ s1 on t.pla_enc = s1.pla_enc ";
    }
    function clausula_where_agregada(){
        return " and pla_rea in (0,2) and pla_estado<>98 and s1.pla_hog=1";
    }
    function puede_detallar(){
        return false;
    }    
}

?>