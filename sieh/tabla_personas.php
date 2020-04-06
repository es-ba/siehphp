<?php
//UTF-8:SÍ
// tablas para la eah2013
require_once "tablas.php";

class Tabla_personas extends Tabla{
    var $con_campos_auditoria=false;
    function definicion_estructura(){
        $this->definir_prefijo('');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('dni',array('tipo'=>'entero','es_pk'=>true));
        $this->definir_campo('seleccionado',array('tipo'=>'texto'));
        $this->definir_campo('estado_de_seleccion',array('tipo'=>'entero'));
        $this->definir_campo('nombre',array('tipo'=>'texto','largo'=>80));
        $this->definir_campo('telefono',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('direccion',array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('barrio',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('cuit_l',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('cuit_l_verif',array('tipo'=>'texto'));
        $this->definir_campo('fecha_nacim',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('mail',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('cod_niv_estud',array('tipo'=>'entero'));
        $this->definir_campo('cod_area_estud',array('tipo'=>'entero'));
        $this->definir_campo('estudios',array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('orien_secundario',array('tipo'=>'entero'));
        $this->definir_campo('fecha_rec_cv',array('tipo'=>'fecha'));
        $this->definir_campo('fecha_ult_cv',array('tipo'=>'fecha'));
        $this->definir_campo('cod_exper_e',array('tipo'=>'entero'));
        $this->definir_campo('cod_exper_r',array('tipo'=>'entero'));
        $this->definir_campo('cod_exper_sup',array('tipo'=>'entero'));
        $this->definir_campo('cod_exper_i',array('tipo'=>'entero'));
        $this->definir_campo('cod_exper_in',array('tipo'=>'entero'));
        $this->definir_campo('tipo_experiencia',array('tipo'=>'texto'));
        $this->definir_campo('cod_tipo_operativo',array('tipo'=>'entero'));
        $this->definir_campo('referente',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('procedencia',array('tipo'=>'texto'));
        $this->definir_campo('observaciones',array('tipo'=>'texto','largo'=>250));
        $this->definir_campo('se_postula_para',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('llamar',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('fecha_llamada',array('tipo'=>'fecha'));
        $this->definir_campo('cod_resul_llamada',array('tipo'=>'entero'));
        $this->definir_campo('comentarios_llam',array('tipo'=>'texto','largo'=>255));
        $this->definir_campo('fe_entrev',array('tipo'=>'fecha'));
        $this->definir_campo('hora_entrev',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('fecha_hora_entrev',array('tipo'=>'fecha'));
        $this->definir_campo('cod_entrevistador',array('tipo'=>'entero'));
        $this->definir_campo('result_entrevista',array('tipo'=>'entero'));
        $this->definir_campo('cod_entr_perfil',array('tipo'=>'entero'));
        $this->definir_campo('cod_puesto_recom',array('tipo'=>'texto','largo'=>20));
        $this->definir_campo('cod_puesto_alter',array('tipo'=>'texto','largo'=>20));
        $this->definir_campo('comentarios_entrev',array('tipo'=>'texto'));
        $this->definir_campo('otro_entrev',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('result_ot_entr',array('tipo'=>'entero'));
        $this->definir_campo('otros_comentarios',array('tipo'=>'texto'));
        $this->definir_campo('cod_ult_situacion',array('tipo'=>'entero'));
        $this->definir_campo('ubicacion_dgeyc',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('no',array('tipo'=>'texto'));
        $this->definir_campo('fecha_ing',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('tipo_contrato',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('log',array('tipo'=>'fecha'));
        $this->definir_campo('seleccion',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('f48',array('tipo'=>'texto','largo'=>250));
        $this->definir_campo('formulario',array('tipo'=>'texto'));
        $this->definir_campo('procencia',array('tipo'=>'texto','largo'=>255));
        $this->definir_campo('sexo',array('tipo'=>'texto','largo'=>255));
        }
}
?>