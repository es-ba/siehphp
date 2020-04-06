<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "contextos.php";
require_once "procesos.php";
require_once "mail.php";
require_once "proceso_formulario.php";

function clave_aleatoria(){
    $vocales=array('a','e','i','o','u');
    $clave="";
    for($i=1; $i<10; $i++){
        if(mt_rand(0,10)<5){
            $clave.=$vocales[mt_rand(0,4)];
        }else{
            $clave.=chr(ord('a')+mt_rand(0,25));
        }
    }
    return $clave;
}

class Proceso_mandar_nueva_clave extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Mandar mail con nueva clave',
            'submenu'=>PROCESO_INTERNO,
            'parametros'=>array(
                'tra_mail'=>array('label'=>'mail del usuario'),
            ),
            'botones'=>array(
                'boton1'=>array('id'=>'enviar','value'=>'enviar'),
            ),
        ));
    }
    function responder(){
        if(sesion_actual()){
            forzar_sesion_actual(1);
        }
        $tabla_usuarios=new tabla_usuarios();
        $tabla_usuarios->contexto=$this;
        $filtro_usuario=array(
            'usu_mail'=>$this->argumentos->tra_mail,
        );
        $tabla_usuarios->leer_unico($filtro_usuario);
        $clave=clave_aleatoria();
        $tabla_usuarios->valores_para_update=array(
            'usu_clave'=>md5(trim($clave).strtolower(trim($tabla_usuarios->datos->usu_usu)))
        );
        $tabla_usuarios->ejecutar_update_unico($filtro_usuario);
        $resultado=enviarMail( // ($dirEnviarA,$propietario,$texto, $subject){
            $tabla_usuarios->datos->usu_mail,
            $tabla_usuarios->datos->usu_nombre,
            <<<TXT
Hola {$tabla_usuarios->datos->usu_nombre}:


Su nueva clave para entrar al sistema es: $clave


Su nombre de usuario: {$tabla_usuarios->datos->usu_usu}


Si recibe este mail es porque alguien puso su nombre en la pantalla de olvido de claves.


Saludos.


El equipo de desarrollo.

TXT
            , "Cambio de clave para el sistema {$GLOBALS['NOMBRE_APP']}"
        );
        return new Respuesta_Positiva('Se envió el mail a la dirección registrada en su usuario (resultado '.$resultado.')');
    }

}
?>