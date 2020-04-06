<?php
//UTF-8:SÍ
// tablas para la eah2013
require_once "tablas.php";

class Tabla_operativos extends Tabla{
    var $con_campos_auditoria=false;
    function definicion_estructura(){
        $this->definir_prefijo('');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('operativo',array('tipo'=>'texto','largo'=>50,'es_pk'=>true));
        $this->definir_campo('anio_op',array('tipo'=>'entero','es_pk'=>true));
        $this->definir_campo('tipo_op',array('tipo'=>'entero'));
        $this->definir_campo('continuo',array('tipo'=>'texto'));
        $this->definir_campo('persona_dni',array('tipo'=>'entero','es_pk'=>'true'));
        $this->definir_campo('aprob_do',array('tipo'=>'texto'));
        $this->definir_campo('aprob_subd',array('tipo'=>'texto'));
        $this->definir_campo('fecha',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('puesto_of',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('respuesta',array('tipo'=>'entero'));
        $this->definir_campo('comentarios_ll',array('tipo'=>'texto','largo'=>200));
        $this->definir_campo('capacitacion',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('campo2',array('tipo'=>'texto'));
        $this->definir_campo('campo1',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('alta_periodo',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('baja_periodo',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('puesto_final',array('tipo'=>'texto','largo'=>50,'es_pk'=>true));
        $this->definir_campo('novedades',array('tipo'=>'entero'));
        $this->definir_campo('fecha_nov',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('motivo',array('tipo'=>'texto'));
        $this->definir_campo('nota_capacitacion',array('tipo'=>'real'));
        $this->definir_campo('evaluacion_a',array('tipo'=>'real'));
        $this->definir_campo('evaluacion_b',array('tipo'=>'real'));
        $this->definir_campo('evaluacion_c',array('tipo'=>'real'));
        $this->definir_campo('evaluacion_d',array('tipo'=>'real'));
        $this->definir_campo('evaluacion_e',array('tipo'=>'real'));
        $this->definir_campo('puesto_ig',array('tipo'=>'entero'));
        $this->definir_campo('puesto_mas',array('tipo'=>'entero'));
        $this->definir_campo('puesto_menos',array('tipo'=>'entero'));
        $this->definir_campo('puesto_sugerido',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('ev_abril',array('tipo'=>'entero'));
        $this->definir_campo('ev_junio',array('tipo'=>'entero'));
        $this->definir_campo('ev_diciem',array('tipo'=>'entero'));
        $this->definir_campo('coment_evaluac',array('tipo'=>'texto'));
        $this->definir_campo('coment_evaluado',array('tipo'=>'texto','largo'=>250));
        $this->definir_campo('evaluado_por',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('tipo_de_contrato',array('tipo'=>'texto','largo'=>50));
        }
}
?>