<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_anoenc extends Tabla{
    function definicion_estructura(){  
        global $ahora;
        $this->definir_prefijo('anoenc');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('anoenc_ope',array('hereda'=>'operativos', 'modo'=>'pk', 'def'=>$GLOBALS['NOMBRE_APP']));
        $this->definir_campo('anoenc_enc',array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('anoenc_anoenc',array('es_pk'=>true,'tipo'=>'entero','def_calculado'=>'autoincremento'));
        $this->definir_campo('anoenc_rol',array('hereda'=>'roles','def'=>rol_actual()));
        $this->definir_campo('anoenc_per',array('tipo'=>'entero'));
        $this->definir_campo('anoenc_usu',array('hereda'=>'usuarios','def'=>usuario_actual()));
        $this->definir_campo('anoenc_fecha',array('tipo'=>'texto','largo'=>50, 'def'=>$ahora->format("Y-m-d")));
        $this->definir_campo('anoenc_hora',array('tipo'=>'texto','largo'=>50, 'def'=>$ahora->format("H:i:s")));
        $this->definir_campo('anoenc_anotacion',array('tipo'=>'texto','largo'=>1000));
        $this->definir_campos_orden('anoenc_enc');
    }
}

?>