<?php

class Tabla_tem__ebcp2014 extends Tabla_tem{
    function definicion_estructura(){
        parent::definicion_estructura();
        $this->definir_campo('tem_ntituf',array('tipo'=>'entero'));
        $this->definir_campo('tem_xvilla',array('tipo'=>'entero'));
        $this->definir_campo('tem_mm2011',array('tipo'=>'entero'));
        $this->definir_campo('tem_brrionof',array('tipo'=>'texto','largo'=>255));
        $this->definir_campo('tem_eet',array('tipo'=>'entero'));
        $this->definir_campo('tem_embar',array('tipo'=>'entero'));
        $this->definir_campo('tem_embarred',array('tipo'=>'entero'));
        $this->definir_campo('tem_menor',array('tipo'=>'entero'));
        $this->definir_campo('tem_menorred',array('tipo'=>'entero'));
        $this->definir_campo('tem_mue2011',array('tipo'=>'entero'));
        $this->definir_campo('tem_orden_reserva',array('tipo'=>'entero'));
        $this->definir_campo('tem_nrosec',array('tipo'=>'entero'));
        $this->definir_campo('tem_tit_sup',array('tipo'=>'texto','largo'=>255));
        $this->definir_campo('tem_tipo_benef',array('tipo'=>'texto','largo'=>255));
        $this->definir_campo('tem_reserva',array('tipo'=>'entero'));
        $this->definir_campo('tem_nro_enc_de_baja',array('tipo'=>'entero'));
        $this->definir_campo('tem_fnac',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('tem_tdoc',array('tipo'=>'texto','largo'=>255));
        $this->definir_campo('tem_ndoc',array('tipo'=>'entero'));
        $this->definir_campo('tem_titu_apellido',array('tipo'=>'texto','largo'=>255));
        $this->definir_campo('tem_titu_nombre',array('tipo'=>'texto','largo'=>255));
        $this->definir_campo('tem_sexo_b',array('tipo'=>'texto','largo'=>1));
        $this->definir_campo('tem_teltit',array('tipo'=>'texto','largo'=>255));
        $this->definir_campo('tem_nrobloque',array('tipo'=>'texto','largo'=>255));
        $this->definir_campo('tem_escalera',array('tipo'=>'texto','largo'=>255));
        $this->definir_campo('tem_parador',array('tipo'=>'texto','largo'=>255));
        $this->definir_campo('tem_resumen',array('tipo'=>'texto','largo'=>255));
        $this->definir_campo('tem_descripcion_de_campo',array('tipo'=>'texto','largo'=>255));
 //       $this->definir_campo('tem_manzana',array('tipo'=>'texto','largo'=>255));
 //       $this->definir_campo('tem_casa',array('tipo'=>'texto','largo'=>255));
        $this->definir_campo('tem_informacion_adicional',array('tipo'=>'texto','largo'=>255));
        $this->definir_campo('tem_baja',array('tipo'=>'texto','largo'=>255));
    }
}

?>