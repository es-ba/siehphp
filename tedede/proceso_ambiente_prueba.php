<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "contextos.php";
require_once "proceso_formulario.php";

class Proceso_ambiente_prueba extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Control del ambiente de prueba',
            'submenu'=>'mantenimiento',
            'para_produccion'=>true,
            'permisos'=>array('grupo'=>'programador'),
            'parametros'=>array(
                'tra_var'=>array(),
                'tra_val'=>array(),
                'tra_set'=>array('label'=>false,'type'=>'checkbox','label-derecho'=>'modificar'),
            ),
            'boton'=>array('id'=>'enviar'),
        ));
    }
    function correr(){
        parent::correr();
        $this->salida->enviar('sin cookies','',array('id'=>'ver_cookies'));
        $this->salida->enviar('sin cookies','',array('id'=>'ver_cookies_j'));
        $this->salida->enviar_script("ver_cookies.textContent=document.cookie;");
        $this->salida->enviar_script("ver_cookies_j.textContent=JSON.stringify(las_cookies);");
    }
    function responder(){
        $var=$this->argumentos->tra_var;
        if(!$this->argumentos->tra_set){
            if(isset($_COOKIE[$var])){
                $rta='había '.$_COOKIE[$var];
            }else{
                $rta='no está definido '.$var;
            }
        }else{
            $rta=(setcookie($var,$this->argumentos->tra_val,time()+60*60*24*365)?'CAMBIADO A ':'NO PUDE CAMBIAR A ').$this->argumentos->tra_val;
        }
        return new Respuesta_Positiva($rta);
    }

}
?>