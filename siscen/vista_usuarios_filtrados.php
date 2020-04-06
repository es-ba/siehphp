<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";

class Vista_usuarios_filtrados extends Vistas{
    function definicion_estructura(){    
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('usu_usu',array('tipo'=>'texto','es_pk'=>true));
        $this->definir_campo('usu_rol' ,array('tipo'=>'texto','largo'=>30));
        $this->definir_campo('usu_activo',array('tipo'=>'logico'));
        $this->definir_campo('usu_nombre',array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('usu_apellido',array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('usu_blanquear_clave',array('tipo'=>'logico'));
        $this->definir_campo('usu_interno',array('tipo'=>'texto','largo'=>30));
        $this->definir_campo('usu_mail',array('tipo'=>'texto','largo'=>200));
        $this->definir_campo('usu_mail_alternativo',array('tipo'=>'texto','largo'=>200));
        $this->definir_campo('usu_rol_secundario',array('tipo'=>'texto','largo'=>30));
		if(tiene_rol("programador")){
		}
    }
    function clausula_from(){
        return "usuarios inner join proy_usu on usu_usu=proyusu_usu where proyusu_proy in (select proyusu_proy from proy_usu ";
    }    
    function clausula_where_agregada(){
		if(tiene_rol("programador")){
			return ")";
		}
        return " and proyusu_usu='".usuario_actual()."')";
    }
}

?>