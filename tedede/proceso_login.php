<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "contextos.php";
require_once "proceso_login_base.php";

class Proceso_login extends Proceso_Formulario{
    function __construct(){
        global $soy_un_ipad,$hoy,$user_auto_login;
        parent::__construct(array(
            'titulo'=>'Entrada al sistema',
            'submenu'=>PROCESO_INTERNO,
            'parametros'=>array(
                'tra_usu'=>array('label'=>'usuario','def'=>@$user_auto_login?'auto':''),
                'tra_clave'=>array('label'=>'clave','id'=>'tra_clave','type'=>'password','onkeypress'=>'detectar_capsLock_y_dar_enter(event);'),
                'tra_borrar_localstorage'=>array(
                    'label'=>false,
                    'checked'=>!$soy_un_ipad,
                    'invisible'=>$soy_un_ipad && $hoy!=new DateTime('2012-10-24'), 
                    'type'=>'checkbox',
                    'label-derecho'=>$soy_un_ipad?'Borrar todas las encuestas ingresadas (y demás datos del localStorage)':'No tengo otras ventanas abiertas ahora en esta aplicación',
                ),
                'tra_mail'=>array('label'=>'','style'=>'visibility:hidden; width:500px','placeholder'=>'mail_del_usuario@dominio.gob.ar'),
            ),
            'botones'=>array(
                'boton1'=>array('id'=>'boton_login','value'=>'navegador no soportado','onclick'=>'boton_login()','disabled'=>true),
                'boton2'=>array('id'=>'boton_sin_pass','value'=>'olvidé la clave','onclick'=>'boton_sin_pass()','style'=>'visibility:hidden'),
                'boton3'=>array('id'=>'boton_mandar_mail','value'=>'mandenme un mail con una nueva','onclick'=>'boton_mandar_mail()','style'=>'visibility:hidden'),
            ),
        ));
    }
    function correr(){
        unset($_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_usu_usu"]);
        $tabla_sesiones=$this->nuevo_objeto('Tabla_sesiones');
        $tabla_sesiones->registrar_logout('no login');
        parent::correr();
        $this->salida->abrir_grupo_interno('div_mensaje_alerta',array('id'=>'divMayus','style'=>'visibility:hidden'));
            $this->salida->enviar_imagen('../imagenes/bloq_mayus.jpg','',array('style'=>'float:left; height:80px'));
            $this->salida->enviar('Atención: Está encendida la tecla de bloqueo de mayúsculas');
        $this->salida->cerrar_grupo_interno();
        $this->salida->agregar_js('../tedede/compatibilidad.js');
        $this->salida->enviar_script('controlar_compatibilidad("proceso_formulario_respuesta");');
        $this->salida->enviar('Este navegador no se puede usar porque no tiene habilitada la opción de ejecutar Javascript. Puede ser que la versión del navegador sea muy antigua o puede ser que en las opciones se haya deshabilitado.','',array('tipo'=>'noscript'));
        if($GLOBALS['login_dual']){
            $this->salida->enviar_script('clave_a_enviar_para_login_dual=true;');
        }
    }
    function registrar($mensaje){
        if($mensaje=='BEGIN'){
            $modo=NULL;
            $ahora=new DateTime();
            $mensaje='BEGIN LOGIN '.$this->argumentos->tra_usu.' '.$ahora->format('Y-m-d H:i:s');
        }else{
            $modo=FILE_APPEND;
        }
        file_put_contents('../logs/login '.$this->argumentos->tra_usu.'.log',$mensaje."\n",$modo);
    }
    function responder(){
        global $user_auto_login;
        $auto_login=@$user_auto_login && $this->argumentos->tra_usu=='auto';
        if($auto_login){
            $this->argumentos->tra_usu=$user_auto_login;
        }
        $tabla_usuarios=new tabla_usuarios();
        $tabla_usuarios->contexto=$this;
        $razon_de_NO_login='no se pudo conectar por error interno del sistema';
        $this->registrar('BEGIN');
        if(!$tabla_usuarios->leer_validando_clave($this->argumentos->tra_usu,$this->argumentos->tra_clave,$this,$auto_login)){
            $this->registrar('no validó');
            $razon_de_NO_login='No se encuentra el usuario o no coincide la clave';
        }elseif(!$tabla_usuarios->datos->usu_activo){
            $this->registrar('inactivo');
            $razon_de_NO_login="El usuario está marcado como inactivo para esta base de datos";
        }else{
            $this->registrar('nueva sesion');
            $tabla_sesiones=$this->nuevo_objeto('Tabla_sesiones');
            $tabla_sesiones->insertar_nueva_sesion($tabla_usuarios->datos->usu_usu,$this->argumentos->tra_borrar_localstorage);
            $_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_ses"]=$tabla_sesiones->retorno->ses_ses;
            $razon_de_NO_login=false;
            $this->registrar('nueva ok');
        }
        if($razon_de_NO_login){
            $tabla_sesiones=$this->nuevo_objeto('Tabla_sesiones');
            $tabla_sesiones->registrar_logout('fail '.$razon_de_NO_login);
            unset($_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_usu_usu"]);
            $this->registrar('fallida: '.$razon_de_NO_login);
            return new Respuesta_Negativa($razon_de_NO_login);
        }else{
            $this->registrar('fallida: '.$razon_de_NO_login);
            forzar_usuario_actual($tabla_usuarios->datos->usu_usu);
            forzar_rol_actual($tabla_usuarios->datos->usu_rol);
            $_SESSION["{$GLOBALS['NOMBRE_APP']}_usu_nombre"]=$tabla_usuarios->datos->usu_nombre;
            $_SESSION["{$GLOBALS['NOMBRE_APP']}_usu_blanquear_clave"]=$tabla_usuarios->datos->usu_blanquear_clave;
            $todos_los_roles[0]=$tabla_usuarios->datos->usu_rol;
            $tabla_rol_rol=$this->nuevo_objeto('Tabla_rol_rol');
            $filtro=array(
                'rolrol_principal'=>$tabla_usuarios->datos->usu_rol,
            );
            $this->registrar('leyendo roles para: '.json_encode($filtro));
            $tabla_rol_rol->leer_varios($filtro);
            while($tabla_rol_rol->obtener_leido()){
                $todos_los_roles[]=$tabla_rol_rol->datos->rolrol_delegado;
            }
            if($tabla_usuarios->datos->usu_rol_secundario){
                $todos_los_roles[]=$tabla_usuarios->datos->usu_rol_secundario;
                $filtro_secundario=array(
                    'rolrol_principal'=>$tabla_usuarios->datos->usu_rol_secundario,
                );
                $tabla_rol_rol->leer_varios($filtro_secundario);
                while($tabla_rol_rol->obtener_leido()){
                    if(!in_array($tabla_rol_rol->datos->rolrol_delegado,$todos_los_roles)) {
                        $todos_los_roles[]=$tabla_rol_rol->datos->rolrol_delegado;
                    }
                }
            }
            $_SESSION["{$GLOBALS['NOMBRE_APP']}_usu_todos_los_roles"]=$todos_los_roles;
            $this->registrar('login ok');
            return new Respuesta_Positiva('Entrada al sistema permitido. Redireccionando al menú principal...');
        }
    }
}

?>