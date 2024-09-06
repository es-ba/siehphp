<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_registro_claves extends Grilla_tabla{
    function campos_editables($filtro_para_lectura){
        $editables=array();
        if(tiene_rol('mues_campo') || tiene_rol('procesamiento') ){
            $editables[]='regcla_solucion_mues';
            $editables[]='regcla_fecha_mues';
            $editables[]='regcla_comentario_mues';
        };
        if(tiene_rol('recepcionista')|| tiene_rol('procesamiento')){
            $editables[]='regcla_enc';
            $editables[]='regcla_pedido_recep';
        };
        return $editables;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return array('regcla_ope','regcla_usu', 'regcla_fecha', 'regcla_enc', 'tem_estado', 'tem_area', 'tem_comuna',
                     'tem_dominio', 'tem_id_marco', 'tem_recepcionista', 'tem_cod_enc',
                     'tem_cod_recu', 'tem_rea','tem_norea', 'tem_hog_pre',
                     'tem_hog_tot', 'tem_gh_tot', 'tem_pob_pre', 'tem_pob_tot', 'tem_pob_res',
                     'regcla_pedido_recep', 'regcla_solucion_mues', 'regcla_fecha_mues', 'regcla_comentario_mues');   
    }
    function puede_insertar(){
        return tiene_rol('recepcionista') || tiene_rol('procesamiento');
    }
    function puede_eliminar(){
        return tiene_rol('recepcionista') || tiene_rol('procesamiento') ;
    }

    function iniciar($nombre_del_objeto_base){
        parent::iniciar('registro_claves'); 
        $this->tabla->campos_lookup=array(
            "tem_enc"=>true,
            "tem_estado"=>false,
            "tem_area"=>false,
            "tem_comuna"=>false,
            "tem_dominio"=>false,
            "tem_id_marco"=>false, 
            "tem_recepcionista"=>false, 
            "tem_cod_enc"=>false,
            "tem_cod_recu"=>false, 
            "tem_rea" =>false,
            "tem_norea"=>false, 
            "tem_hog_pre"=>false,
            "tem_hog_tot"=>false, 
            "tem_gh_tot"=>false,
            "tem_pob_pre"=>false, 
            "tem_pob_tot"=>false,
            "tem_pob_res"=>false,

        );
        $es_etoi_gh=((substr($GLOBALS['NOMBRE_APP'],0,4)=='etoi' && (int)(substr($GLOBALS['NOMBRE_APP'],4))>=162 &&(int)(substr($GLOBALS['nombre_app'],4))<=172) || (substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']==2016))?true:false;        
        $v_seleccion=$es_etoi_gh?" , pla_gh_tot as tem_gh_tot":" , null as tem_gh_tot"; 
        $this->tabla->tablas_lookup=array(            
            "(select pla_estado as tem_estado, pla_area as tem_area, pla_comuna as tem_comuna, pla_dominio as tem_dominio,
                     pla_id_marco as tem_id_marco, pla_recepcionista as tem_recepcionista, pla_cod_enc as tem_cod_enc,
                     pla_cod_recu as tem_cod_recu, pla_rea as tem_rea, pla_norea as tem_norea, pla_hog_pre as tem_hog_pre,
                     pla_hog_tot as tem_hog_tot, pla_pob_pre as tem_pob_pre, pla_pob_tot as tem_pob_tot, pla_pob_res as tem_pob_res, pla_enc as tem_enc" . $v_seleccion.
               " from encu.plana_tem_
               ) tem"=>" tem_enc=regcla_enc ",
        );
    }
    
    function obtener_otros_atributos_y_completar_fila(&$fila,&$atributos_fila){
        parent::obtener_otros_atributos_y_completar_fila($fila,$atributos_fila);
        if($fila['tem_estado']){
            $color_proc=200;
            $atributos_fila['tem_estado']['style']='background-color:rgb('.(255-$color_proc).','.($color_proc).','.(255-$fila['tem_estado']*2).')'; 
        }
        else{
            $atributos_fila['tem_estado']['clase']='columna_estado';
        }
    }
}
?>