<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";

class Vista_up_para_supervision extends Vistas{
    function definicion_estructura(){
        $this->definir_campo('vis_replica'               ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_replica'  ));
        $this->definir_campo('vis_comuna'                ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_comuna'   ));
        $this->definir_campo('vis_up'                    ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_up'));
        $this->definir_campo('vis_cant_rea_encu'         ,array('operacion'=>'cuenta_true','origen'=>'pla_rea_enc=1','title'=>'realizadas por el encuestador'));
        $this->definir_campo('vis_cant_no_rea_encu'      ,array('operacion'=>'cuenta_true','origen'=>'pla_rea_enc=0','title'=>'con razón de no respuesta por el encuestador'));
        $this->definir_campo('vis_tamanno_up'            ,array('operacion'=>'cuenta','origen'=>'*','title'=>'Cantidad de viviendas en la UP'));
        $this->definir_campo('vis_cant_en_relevamiento'  ,array('operacion'=>'cuenta_otro','total'=>'vis_tamanno_up','restan'=>array('vis_cant_rea_encu','vis_cant_no_rea_encu'),'title'=>'sin novedades del encuestador'));
        $this->definir_campo('vis_en_recuperacion'       ,array('operacion'=>'cuenta_true','origen'=>'pla_rea_enc=0 and (pla_razon_enc between 71 and 92)','title'=>'Viviendas encuestables no realizadas'));
        $this->definir_campo('vis_sup_por_no_encuestable',array('operacion'=>'cuenta_true','origen'=>'pla_rea_enc=0 and (pla_razon_enc<63 or pla_razon_enc=64)','title'=>'Supervisión obligatoria por viviendas no encuestables norea 11 a 62 o 64'));
        $this->definir_campo('vis_sup_por_multiple_hogar',array('operacion'=>'cuenta_true','origen'=>'pla_rea_enc=1 and pla_nhogares>1','title'=>'Supervisión obligatoria por haber más de un hogar'));
        $this->definir_campo('vis_sup_dirigidas'         ,array('operacion'=>'cuenta_true','origen'=>'pla_sup_diri=1','title'=>'Supervisión dirigida por decisión de campo'));
        $this->definir_campo('vis_sup_exceptuadas'       ,array('operacion'=>'cuenta_true','origen'=>'pla_sup_diri=3','title'=>'Supervisión exceptuadas por decisión de campo (la no supervisión no fue decidida por el algoritmo de supervisión)'));
        $this->definir_campo('vis_marcadas'              ,array('operacion'=>'cuenta_true','origen'=>'pla_sup_campo is not null','title'=>'Viviendas marcadas por el algoritmo de supervisión'));
        $this->definir_campo('vis_marcar_para_supervisar',array('operacion'=>'cuenta_true','origen'=>'pla_sup_diri=2 and pla_sup_campo is null','title'=>'pendientes de algoritmo de supervisión','boton'=>'marcar'));
        $this->definir_campo('vis_otros_no_supervisables',array('operacion'=>'cuenta_otro','total'=>'vis_tamanno_up','restan'=>array('vis_cant_en_relevamiento','vis_en_recuperacion', 'vis_sup_por_no_encuestable', 'vis_sup_por_multiple_hogar', 'vis_sup_dirigidas', 'vis_sup_exceptuadas','vis_marcadas', 'vis_marcar_para_supervisar')));
        $this->definir_campo('vis_encuestas_marcadas_pre',array('operacion'=>'concato_texto','origen'=>"case when pla_sup_campo=1 then pla_enc||' ' else null end"));
        $this->definir_campo('vis_encuestas_marcadas_tel',array('operacion'=>'concato_texto','origen'=>"case when pla_sup_campo=2 then pla_enc||' ' else null end"));
    }
    function clausula_from(){
        return "plana_tem_";
    }
}

?>