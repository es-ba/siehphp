<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_glosario_tem extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('glotem');
        //$this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('glotem_var',array('es_pk'=>true,'tipo'=>'texto','largo'=>200, 'validart'=>'codigo', 'title'=>'Variable' ));
        $this->definir_campo('glotem_en_dominio3',array('tipo'=>'logico', 'title'=>'Interviene en dominio3'));
        $this->definir_campo('glotem_en_dominio4',array('tipo'=>'logico', 'title'=>'Interviene en dominio4'));
        $this->definir_campo('glotem_en_dominio5',array('tipo'=>'logico', 'title'=>'Interviene en dominio5'));
        $this->definir_campo('glotem_definicion',array('tipo'=>'texto','largo'=>2000,'not_null'=>true));
        $this->definir_campo('glotem_val_valido',array('tipo'=>'texto','largo'=>500,'not_null'=>true, 'title'=>'Valores aceptados'));         
        $this->definir_campo('glotem_planilla',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('glotem_rol',array('tipo'=>'texto','largo'=>200));
        $this->definir_campo('glotem_rangos',array('tipo'=>'texto','largo'=>200));         
        $this->definir_campo('glotem_cant_digitos',array('tipo'=>'texto','largo'=>200));        
        $this->definir_campo('glotem_editable',array('tipo'=>'texto','largo'=>200));
        $this->definir_campo('glotem_muestreo',array('tipo'=>'logico','def'=>false, 'title'=>'de muestreo'));
    }
}
/*
create table encu.glosario_tem(
  glotem_var            character varying(50) NOT NULL,
  glotem_en_dominio3    boolean,
  glotem_en_dominio4    boolean,
  glotem_en_dominio5    boolean,
  glotem_definicion     character varying(2000) NOT NULL,
  glotem_val_valido     character varying(500) NOT NULL,
  glotem_planilla       character varying(50),
  glotem_rol            character varying(50),
  glotem_rangos         character varying(50),
  glotem_cant_digitos   character varying(50),
  glotem_editable       character varying(50),
  glotem_tlg            bigint NOT NULL,
  CONSTRAINT glotem_pkey PRIMARY KEY (glotem_var),
  CONSTRAINT glotem_tiempo_logico_fk FOREIGN KEY (glotem_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION  
);
ALTER TABLE encu.glosario_tem
  OWNER TO tedede_php;
*/

?>
