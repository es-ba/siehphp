<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tabla_tiempo_logico.php";

function esta_da_error(){
    throw new Exception('probando errores 1');
}

function usuario_actual(){
    global $auto_capa,$user_auto_login;
    if(isset($_REQUEST['lanzar_error'])){
        esta_da_error();
    }
    //descomentar para probrar proceso_reporte_errores
    $usuario_actual=@$_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_usu_usu"];
    if(!$usuario_actual && @$auto_capa && @$user_auto_login){
        $_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_usu_usu"]=$usuario_actual=$user_auto_login;
    }
    return $usuario_actual;
}

function forzar_usuario_actual($nombre_usuario){
    $_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_usu_usu"]=$nombre_usuario;
}

class Tabla_usuarios extends Tabla{
    public $db_user=false;
    function definicion_estructura(){
        $this->definir_prefijo('usu');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('usu_usu',array('es_pk'=>true,'tipo'=>'texto','largo'=>30,'not_null'=>true,'solo_lectura'=>true));
        $this->definir_campo('usu_rol',array('hereda'=>'roles','modo'=>'fk_optativa'));
        $this->definir_campo('usu_clave',array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('usu_activo',array('tipo'=>'logico', 'def'=>false,'not_null'=>true));
        $this->definir_campo('usu_nombre',array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('usu_apellido',array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('usu_clave',array('tipo'=>'texto','largo'=>50,'invisible'=>true));
        $this->definir_campo('usu_blanquear_clave',array('tipo'=>'logico','def'=>false,'not_null'=>true));
        $this->definir_campo('usu_interno',array('tipo'=>'texto','largo'=>30));
        $this->definir_campo('usu_mail',array('tipo'=>'texto','largo'=>200));
        $this->definir_campo('usu_mail_alternativo',array('tipo'=>'texto','largo'=>200));
        //$this->definir_campo('usu_rol_secundario',array('hereda'=>'roles','modo'=>'pk'));
        $this->definir_campo('usu_rol_secundario',array('tipo'=>'texto','largo'=>30));
        $this->definir_tablas_hijas(array('sesiones'=>false /*, 'anoenc'=>true*/));
    }
    function ejecutar_instalacion_agregar_datos(){
        $this->valores_para_insert=array(
            'usu_usu'=>'instalador',
            'usu_activo'=>false,
            'usu_tlg'=>PRIMER_TLG,
        );
        $this->ejecutar_insercion();
    }
    function filtro_registros_editables(){
        if(tiene_rol('programador')){
            return false; // puede editar todos
        }
        return new Filtro_OR(array(
            array("usu_usu"=>usuario_actual()),
            array("usu_rol"=>new Expresion_Literal(" in (select rolrol_delegado from rol_rol where rolrol_principal=".$this->contexto->db->quote(rol_actual()).' and rolrol_principal<>rolrol_delegado)'))
        ));
    }
    function leer_validando_clave($tra_usu,$tra_clave,$registrando,$auto_login){
        global $parametros_db,$login_dual;
        if($login_dual){
            $registrando->registrar('dual');
            try{
                $this->db_user=new PDO_con_excepciones("pgsql:dbname={$parametros_db->base_de_datos};host={$parametros_db->host};port={$parametros_db->port}", $tra_usu, $tra_clave);
                $registrando->registrar('conectado');
                $pude_conectar=true;
            }catch(Exception $err){
                $pude_conectar=false;
                $registrando->registrar('sin conexión: '.$err->getMessage());
            }
            if($pude_conectar){
                $this->leer_uno_si_hay(array(
                    'usu_usu'  =>$tra_usu,
                ));
            }
        }else{
            if($auto_login){
                $this->leer_uno_si_hay(array(
                    'usu_usu'  =>$tra_usu,
                ));
            }else{
                $this->leer_uno_si_hay(array(
                    'usu_usu'  =>$tra_usu,
                    'usu_clave'=>$tra_clave,
                ));
            }
            $pude_conectar=true;
        }
        if($pude_conectar){
            $hay_usuario=$this->obtener_leido();
            $registrando->registrar('hay usuario: '.($hay_usuario?'sí':'NO'));
            return $pude_conectar && $hay_usuario;
        }
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE usuarios
  ADD CONSTRAINT "texto invalido en usu_apellido de tabla usuarios" CHECK (comun.cadena_valida(usu_apellido::text, 'castellano'::text));
/*OTRA*/
ALTER TABLE usuarios
  ADD CONSTRAINT "texto invalido en usu_clave de tabla usuarios" CHECK (comun.cadena_valida(usu_clave::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE usuarios
  ADD CONSTRAINT "texto invalido en usu_interno de tabla usuarios" CHECK (comun.cadena_valida(usu_interno::text, 'extendido'::text));
/*OTRA*/
ALTER TABLE usuarios
  ADD CONSTRAINT "texto invalido en usu_mail de tabla usuarios" CHECK (comun.cadena_valida(usu_mail::text, 'extendido'::text));
/*OTRA*/
ALTER TABLE usuarios
  ADD CONSTRAINT "texto invalido en usu_mail_alternativo de tabla usuarios" CHECK (comun.cadena_valida(usu_mail_alternativo::text, 'extendido'::text));
/*OTRA*/
ALTER TABLE usuarios
  ADD CONSTRAINT "texto invalido en usu_nombre de tabla usuarios" CHECK (comun.cadena_valida(usu_nombre::text, 'castellano'::text));
/*OTRA*/
ALTER TABLE usuarios
  ADD CONSTRAINT "texto invalido en usu_rol de tabla usuarios" CHECK (comun.cadena_valida(usu_rol::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE usuarios
  ADD CONSTRAINT "texto invalido en usu_rol_secundario de tabla usuarios" CHECK (comun.cadena_valida(usu_rol_secundario::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE usuarios
  ADD CONSTRAINT "texto invalido en usu_usu de tabla usuarios" CHECK (comun.cadena_valida(usu_usu::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}

?>