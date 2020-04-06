<?php
//UTF-8:SÍ

require_once "lo_imprescindible.php";
require_once "contextos.php";
require_once "procesos.php";
require_once "proceso_formulario.php";

class Proceso_cambio_de_clave extends Proceso_Formulario {
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Cambiar mi clave de acceso',
            'submenu'=>'usuarios',
            'para_produccion'=>true,
            'parametros'=>array(              
                'tra_usu'        =>array('label'=>'usuario',     'def'=>usuario_actual(),'invisible'=>true),
                'tra_clave_vieja'=>array('label'=>'Clave vieja','type'=>'password'),
                'tra_clave_nueva'=>array('label'=>'Clave nueva','type'=>'password','invisible'=>false),
                'tra_clave_repet'=>array('label'=>'Repetir clave nueva','type'=>'password','invisible'=>false),
            ),
            'boton'=>array('id'=>'boton_cambio_de_clave','value'=>'cambiar clave >>','onclick'=>'boton_cambio_de_clave()')
        ));
    }
    function correr(){
        parent::correr();
        $this->salida->abrir_grupo_interno('div_mensaje_alerta',array('id'=>'divMayus','style'=>'visibility:hidden'));
            $this->salida->enviar_imagen('bloq_mayus.jpg','',array('style'=>'float:left; height:80px'));
            $this->salida->enviar('Atención: Está encendida la tecla de bloqueo de mayúsculas');
        $this->salida->cerrar_grupo_interno();
        if($GLOBALS['login_dual']){
            $this->salida->enviar_script('clave_a_enviar_para_login_dual=true;');
        }
    }
    function registrar($mensaje){
        if($mensaje=='BEGIN'){
            $modo=NULL;
            $ahora=new DateTime();
            $mensaje='BEGIN CHPASS '.$this->argumentos->tra_usu.' '.$ahora->format('Y-m-d H:i:s');
        }else{
            $modo=FILE_APPEND;
        }
        file_put_contents('../logs/chpass '.$this->argumentos->tra_usu.'.log',$mensaje."\n",$modo);
    }
    function responder(){
        global $login_dual;
        $this->registrar('BEGIN');
        $tabla_usuarios=new tabla_usuarios();
        $tabla_usuarios->contexto=$this;
        $razon_de_NO_registro='no se pudo conectar por error interno del sistema';
        $clave_nueva_encriptada=md5(trim($this->argumentos->tra_clave_nueva).strtolower(trim($this->argumentos->tra_usu)));
        if($tabla_usuarios->leer_validando_clave($this->argumentos->tra_usu,$this->argumentos->tra_clave_vieja,$this)){
            if(strlen($this->argumentos->tra_clave_nueva)<4 and strlen($this->argumentos->tra_clave_repet)<=4){
                $razon_de_NO_registro='error la clave nueva debe ser mayor de 4 caracteres';
                Return new Respuesta_Negativa($razon_de_NO_registro);
            }
            if($this->argumentos->tra_clave_nueva == $this->argumentos->tra_clave_repet){
                $tabla_usuarios->valores_para_update=array(
                    'usu_clave'=>$clave_nueva_encriptada,
                    'usu_blanquear_clave'=>false
                );
                $tabla_usuarios->ejecutar_update_unico(array('usu_usu'=>$this->argumentos->tra_usu));
                $rta='clave cambiada';
                if($login_dual){
                    $tabla_usuarios->db_user->ejecutar_sql(new Sql('ALTER ROLE '.json_encode($this->argumentos->tra_usu)." ENCRYPTED PASSWORD 'md5".$clave_nueva_encriptada."'"));
                }
                return new Respuesta_Positiva($rta);
                $razon_de_NO_registro=false;
            }else{
                $razon_de_NO_registro='error las claves nueva y repetida no coinciden';
            }
        }else{
            $razon_de_NO_registro='el usuario o la claves ingresadas no coinciden';
        }
        if($razon_de_NO_registro){
            return new Respuesta_Negativa($razon_de_NO_registro);
        }else{
            //return new Respuesta_Positiva('Entrada al sistema permitido. Redireccionando al menú principal...');
        }
    }

}
?>