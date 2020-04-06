<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";

class Proceso_control_encuesta extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Controlar encuesta',
            'submenu'=>PROCESO_INTERNO,
            'parametros'=>array(
                'tra_ope'=>array('label'=>'nombre del operativo','def'=>$GLOBALS['NOMBRE_APP']),
                'tra_enc'=>array('label'=>'número de encuesta'),
            ),
            'boton'=>array('id'=>'hacer el control'),
            'bitacora'=>true,
        ));
    }
    function controlar_inconsistencias(){
        $filtro_para_consistir=array('tra_ope'=>$GLOBALS['NOMBRE_APP'], 'tra_enc'=>$this->argumentos->tra_enc);
        // $array_problemas=correr_consistencias_segun_filtro($this, $filtro_para_consistir, false);
        $proceso=$this->nuevo_objeto('Proceso_correr_consistencias');
        $proceso->argumentos=$this->argumentos;
        $proceso->argumentos->tra_con='#todo';
        $respuesta=$proceso->responder();
        /*
        $array_problemas=$respuesta->obtener_mensaje();
        foreach($array_problemas as $problema){
            $this->problemas++;
            $this->salida->enviar('* Problema '.$this->problemas.' '.$problema);
        }
        */
    }
    function responder(){
        // $this->salida=new Armador_de_salida(true);
        $this->problemas=0;
        $ahora=date_format(new DateTime(), "Y-m-d H:i:s");
        marcar_tabla($this, $this->argumentos->tra_ope, $this->argumentos->tra_enc, 'Tabla_respuestas', 'TEM','res_var','comenzo_consistencias','res_valor',$ahora);
        $this->controlar_inconsistencias();
        marcar_tabla($this, $this->argumentos->tra_ope, $this->argumentos->tra_enc, 'Tabla_respuestas', 'TEM','res_var','cantidad_inconsistencias','res_valor',$this->problemas);
        /*
        if($this->problemas>0){
            $this->salida->enviar('Problemas detectados: '.$this->problemas,'pro_detec');
        }else{
            $this->salida->enviar('Ningún problema detectado','pro_detec');
        }
        return $this->salida->obtener_una_respuesta_HTML();
        */
        return new Respuesta_Positiva('listo, trayendo la grilla...');
    }    
}
?>