<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "vista_novedades.php";

class Grilla_novedades extends Grilla_vistas{
    function iniciar($nombre_del_objeto_base){
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Vista_novedades");
    }
    function puede_eliminar(){
        return true;
    }
    function boton_enviar(){
        return array(
            'leyenda'=>'A',
            'title'=>'Adjuntar',
            'proceso'=>'agregar_adjuntos_a_un_requerimiento',
            'campos_parametros'=>array('tra_proy'=>null, 'tra_req'=>null),
            //'y_luego'=>'adjuntar'
        );
    }
}
?>