<?php
//UTF-8:SÍ
require_once "tablas.php";

function sesion_actual(){
    return @$_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_ses"];
}

function forzar_sesion_actual($sesion_numero){
    $_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_ses"]=$sesion_numero;
}

class Tabla_sesiones extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('ses');
        $this->con_campos_auditoria=false;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('ses_ses',array('es_pk'=>true,'tipo'=>'serial','bytes'=>8));
        $this->definir_campo('ses_usu',array('hereda'=>'usuarios','modo'=>'fk_obligatoria'));
        $this->definir_campo('ses_momento',array('tipo'=>'timestamp','def'=>array('funcion'=>'now()')));
        $this->definir_campo('ses_borro_localstorage',array('tipo'=>'logico','not_null'=>true));
        $this->definir_campo('ses_activa',array('tipo'=>'logico','def'=>true,'not_null'=>true));
        $this->definir_campo('ses_phpsessid',array('tipo'=>'texto','largo'=>100,'not_null'=>true));
        $this->definir_campo('ses_httpua',array('hereda'=>'http_user_agent','modo'=>'fk_obligatoria'));
        $this->definir_campo('ses_remote_addr',array('tipo'=>'texto','largo'=>100,'not_null'=>true));
        $this->definir_campo('ses_momento_finalizada',array('tipo'=>'timestamp'));
        $this->definir_campo('ses_razon_finalizada',array('tipo'=>'texto'));
    }
    function ejecutar_instalacion($con_dependientes=TRUE){
        parent::ejecutar_instalacion($con_dependientes);
        $this->insertar_nueva_sesion('instalador',false);
        $this->ejecutar_insercion();
    }
    function insertar_nueva_sesion($usuario,$borro_localstorage){
        global $HTTP_USER_AGENT;
        $tabla_http_user_agent=$this->definicion_tabla('http_user_agent');
        $httpua_array=array(
            'httpua_texto'=>$HTTP_USER_AGENT
        );
        $tabla_http_user_agent->leer_uno_si_hay($httpua_array);
        if(!$tabla_http_user_agent->obtener_leido()){
            $tabla_http_user_agent->valores_para_insert=$httpua_array;
            $tabla_http_user_agent->ejecutar_insercion();
            $tabla_http_user_agent->leer_uno_si_hay($httpua_array);
            $tabla_http_user_agent->obtener_leido();
        }
        if(!$tabla_http_user_agent->datos->httpua_httpua){
            $razon_de_NO_login="Problema guardando el http_user_agent de la sesión";
        }else{
            $this->expresiones_returning=array('ses_ses');
            $this->valores_para_insert=array(
                'ses_usu'=>$usuario,
                'ses_borro_localstorage'=>$borro_localstorage,
                'ses_phpsessid'=>session_id(),
                'ses_httpua'=>$tabla_http_user_agent->datos->httpua_httpua, 
                'ses_remote_addr'=>$_SERVER["REMOTE_ADDR"],
            );
            $this->ejecutar_insercion();
        }
    }
    function registrar_logout($razon){
        if(isset($_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_ses"])){
            $this->valores_para_update=array(
                'ses_momento_finalizada'=>array('expresion'=>'now()'),
                'ses_razon_finalizada'=>$razon,
            );
            $this->ejecutar_update_varios(array('ses_ses'=>$_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_ses"]));
            unset($_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_ses"]);
        }
    }
}

?>