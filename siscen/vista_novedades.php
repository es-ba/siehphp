<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";

class Vista_novedades extends Vistas{
    function definicion_estructura(){
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('reqnov_proy',array('tipo'=>'texto','es_pk'=>true));
        $this->definir_campo('reqnov_req' ,array('tipo'=>'texto', 'es_pk'=>true, 'largo'=>10));
        $this->definir_campo('reqnov_reqnov',array('tipo'=>'entero', 'es_pk'=>true));
        $this->definir_campo('reqnov_comentario',array('tipo'=>'texto', 'largo'=>1000));
        $this->definir_campo('reqnov_reqest',array('tipo'=>'texto', 'largo'=>50));
        $this->definir_campo('reqnov_campo',array('tipo'=>'texto','largo'=>30));
        $this->definir_campo('reqnov_anterior',array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('reqnov_actual',array('tipo'=>'texto','largo'=>100));
        //$this->definir_campo('reqnov_usu',array('tipo'=>'texto','largo'=>30, 'origen'=>'usu_usu'));
        //$this->definir_campo('reqnov_rol',array('tipo'=>'texto','largo'=>30, 'origen'=>'usu_rol'));
        $this->definir_campos_orden(array('reqnov_proy','reqnov_req', 'reqnov_reqnov'));
    }
    function clausula_from(){
        return "(select reqnov_proy, reqnov_req, reqnov_reqnov, reqnov_comentario, reqnov_reqest, reqnov_campo, reqnov_anterior, reqnov_actual, usu_usu, usu_rol 
        from siscen.req_nov inner join siscen.tiempo_logico on reqnov_tlg = tlg_tlg 
        inner join siscen.sesiones on tlg_ses = ses_ses 
        inner join siscen.usuarios on usu_usu = ses_usu) a
        ";
    }
    function clausula_where_agregada(){
        return " and (usu_usu = '".usuario_actual()."' or usu_rol in (select rolrol_delegado from siscen.rol_rol inner join siscen.usuarios on rolrol_principal = usu_rol where usu_usu = '".usuario_actual()."'))";
    }  
}

?>