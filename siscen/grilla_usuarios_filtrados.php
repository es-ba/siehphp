<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "vista_usuarios_filtrados.php";

class Grilla_usuarios_filtrados extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){  
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Vista_usuarios_filtrados");
    }    
}
?>