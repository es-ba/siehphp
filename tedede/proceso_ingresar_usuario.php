<?php
//UTF-8:SÍ

require_once "lo_imprescindible.php";
require_once "contextos.php";
require_once "procesos.php";

class Proceso_ingresar_usuario extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $tabla_rol_rol=$this->nuevo_objeto("Tabla_rol_rol");
        $tabla_roles=$this->nuevo_objeto("Tabla_roles");
        $this->definir_parametros(array(
            'titulo'=>'Pedir una cuenta para un usuario nuevo',
            'submenu'=>'usuarios',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_usu'=>array('label'=>'usuario','aclaracion'=>'si el usuario tiene una cuenta en @estadisticaciudad.gob.ar especifique el mismo nombre de usuario'),
                'tra_nombre'=>array('label'=>'nombre'),
                'tra_apellido'=>array('label'=>'apellido'),
                'tra_interno'=>array('label'=>'interno'),
                'tra_rol'=>array('label'=>'rol','def'=>rol_actual(),'opciones'=>tiene_rol('programador')?$tabla_roles->lista_opciones(array()):$tabla_rol_rol->lista_opciones(array('rolrol_principal'=>rol_actual()))),
                'tra_mail'=>array('label'=>'mail','style'=>'width:300px'),
                'tra_clave'=>array('label'=>'clave','id'=>'tra_clave','onkeypress'=>'detectar_capsLock_y_dar_enter(event);'),
                'tra_verificar'=>array('label'=>false,'type'=>'checkbox','label-derecho'=>'Estoy seguro de que el usuario al que le estoy pidiendo una cuenta puede tener los permisos asociados al rol que le estoy pidiendo'),
                'tra_enviar_mail'=>array('label'=>false,'checked'=>true,'type'=>'checkbox','label-derecho'=>'Enviar un mail al nuevo usuario con su usuario, clave y la dirección para acceder a esta página'),
            ),
            'boton'=>array('id'=>'boton_ingresar_usuario','value'=>'ingresar usuario >>')
            ,
        ));
    }
    function responder(){
        global $esta_es_la_base_en_produccion;
        if(!$this->argumentos->tra_verificar){
            return new Respuesta_Negativa('Debe verificar si el rol del usuario nuevo es el correcto');
        }
        if(strlen($this->argumentos->tra_clave)<4){
            return new Respuesta_Negativa('Debe especificar una clave de al menos 4 caracteres');
        }
        if(!$this->argumentos->tra_nombre || !$this->argumentos->tra_apellido){
            return new Respuesta_Negativa('Debe especificar nombre y apellido');
        }
        if($this->argumentos->tra_mail && (strpos($this->argumentos->tra_mail,'@')<=0 || strpos($this->argumentos->tra_mail,'@')>strlen($this->argumentos->tra_mail)-2)){
            return new Respuesta_Negativa('Debe especificar un mail válido '.strpos($this->argumentos->tra_mail,'@').'/'.(strlen($this->argumentos->tra_mail)-2));
        }
        $tabla_usuarios_usu=new tabla_usuarios();
        $tabla_usuarios_usu->contexto=$this;
        $tabla_usuarios_usu->leer_uno_si_hay(array(
            'usu_usu'=>$this->argumentos->tra_usu,
        ));        
        if($tabla_usuarios_usu->obtener_leido()){
            return new Respuesta_Negativa('El usuario ya existe');
        }
        if($this->argumentos->tra_mail){
            $tabla_usuarios_mai=new tabla_usuarios();
            $tabla_usuarios_mai->contexto=$this;
            $tabla_usuarios_mai->leer_uno_si_hay(array(
                'usu_mail'=>$this->argumentos->tra_mail,
            ));
            $razon_de_NO_registro='no se pudo conectar por error interno del sistema';
            if($tabla_usuarios_mai->obtener_leido()){
                return new Respuesta_Negativa('ya existe un usuario con ese mail. Para recuperar esa cuenta debe salir del sistema e indicar que se olvidó la clave');
            }
        }
        $rol_ok=tiene_rol($this->argumentos->tra_rol) || tiene_rol('programador');
        if(!$rol_ok){
            $tabla_rol_rol=new tabla_rol_rol();
            $tabla_rol_rol->contexto=$this;
            $tabla_rol_rol->leer_varios(array(
                'rolrol_principal'=>rol_actual(),
                'rolrol_delegado'=>$this->argumentos->tra_rol,
            ));
            $rol_ok=$tabla_rol_rol->obtener_leido();
            if(!$rol_ok){
                $tabla_roles=new tabla_roles();
                $tabla_roles->contexto=$this;
                $tabla_roles->leer_varios(array('rol_rol'=>$this->argumentos->tra_rol,));
                if(!$tabla_roles->obtener_leido()){
                    return new Respuesta_Negativa('No hay un rol llamado '.$this->argumentos->tra_rol);
                }else{
                    return new Respuesta_Negativa('Su propio rol no le permite asignar el rol '.$this->argumentos->tra_rol.' a otros usuarios');
                }
            }
        }
        if($rol_ok){
            $tabla_usuarios_usu->valores_para_insert=(array(
                'usu_usu'       =>$this->argumentos->tra_usu,
                'usu_nombre'    =>$this->argumentos->tra_nombre,
                'usu_apellido'  =>$this->argumentos->tra_apellido,
                'usu_interno'   =>$this->argumentos->tra_interno,
                'usu_rol'       =>$this->argumentos->tra_rol,
                'usu_mail'      =>$this->argumentos->tra_mail,
                'usu_clave'     =>md5(trim($this->argumentos->tra_clave).strtolower(trim($this->argumentos->tra_usu))),
                'usu_activo'    =>true,
            ));
            $this->db->ejecutar_sqls($tabla_usuarios_usu->sqls_insercion());
            $rta='El usuario se creó con exito';
            if($this->argumentos->tra_enviar_mail && $this->argumentos->tra_mail && $esta_es_la_base_en_produccion){
                $tabla_usuarios=new tabla_usuarios();
                $tabla_usuarios->contexto=$this;
                $tabla_usuarios->leer_unico(array(
                    'usu_usu'=>usuario_actual(),
                ));
                $nombre_y_apellido_solicitante=$tabla_usuarios->datos->usu_nombre.' '.$tabla_usuarios->datos->usu_apellido;
                $rta='Se envió un mail al usuario nuevo';
                $resultado=enviarMail( // ($dirEnviarA,$propietario,$texto, $subject){
                    $this->argumentos->tra_mail,
                    $this->argumentos->tra_nombre,
                    <<<TXT
Hola {$this->argumentos->tra_nombre}:

Se ha creado un usuario para entrar al sistema elegido. 

Para acceder ingrese al google Chrome y visite la página correspondiente

Nombre de usuario: {$this->argumentos->tra_usu}

Clave: {$this->argumentos->tra_clave}

Está recibiendo este mail porque el usuario {$nombre_y_apellido_solicitante} lo solicitó. 


Saludos.


El equipo de desarrollo.

TXT
                    , "Nuevo usuario para el sistema {$GLOBALS['NOMBRE_APP']}"
                );
            }
            return new Respuesta_Positiva($rta);
        }else{
            return new Respuesta_Negativa("No se pudo crear el usuario");
        }    
    }
}
?>