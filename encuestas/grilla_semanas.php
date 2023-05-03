<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_semanas extends Grilla_tabla{
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='sem_ope';
        $heredados[]='sem_sem';
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return true;
    }
    function responder_detallar(){
        return false;
    }   
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('sem_sem'));
    }
    function puede_insertar(){
        return tiene_rol('programador')||tiene_rol('coor_campo');
    }
    function puede_eliminar(){
        return tiene_rol('programador');
    }
    function campos_editables($filtro_para_lectura){
        $editables=array();
        if(tiene_rol('programador')|| tiene_rol('coor_campo')){
            $editables[]='sem_semana_referencia_desde';
            $editables[]='sem_semana_referencia_hasta';
            $editables[]='sem_30dias_referencia_desde';
            $editables[]='sem_30dias_referencia_hasta';
            $editables[]='sem_mes_referencia';
            $editables[]='sem_carga_enc_desde';
            $editables[]='sem_carga_enc_hasta';
            $editables[]='sem_carga_recu_desde';
            $editables[]='sem_carga_recu_hasta';
        };
        return $editables;
    }
}
?>