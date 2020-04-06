<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_relvis extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        //$this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'               ,array('hereda'=>'periodos','modo'=>'pk' ));
        $this->definir_campo('informante'            ,array('hereda'=>'informantes','modo'=>'pk'));
        $this->definir_campo('formulario'            ,array('hereda'=>'formularios','modo'=>'pk'));
        $this->definir_campo('panel'                 ,array('hereda'=>'relpan','modo'=>'fk_obligatoria'));
        $this->definir_campo('tarea'                 ,array('tipo'=>'entero','not_null'=>true));
        $this->definir_campo('fechasalida'           ,array('tipo'=>'fecha'));
        $this->definir_campo('fechaingreso'          ,array('tipo'=>'fecha'));
        $this->definir_campo('ingresador'            ,array('hereda'=>'personal','campo_relacionado'=>'persona','modo'=>'fk_optativa',));
        $this->definir_campo('razon'                 ,array('hereda'=>'razones','modo'=>'fk_optativa'));
        $this->definir_campo('fechageneracion'       ,array('tipo'=>'timestamp'));
        $this->definir_campo('visita'                ,array('es_pk'=>true,'tipo'=>'entero','def'=>1,'not_null'=>true ));
        $this->definir_campo('ultimavisita'          ,array('tipo'=>'entero','def'=>1,'not_null'=>true ));
        $this->definir_campo('comentarios'           ,array('tipo'=>'texto','largo'=>1000));
        $this->definir_campo('encuestador'           ,array('hereda'=>'personal','campo_relacionado'=>'persona','modo'=>'fk_optativa'));
        $this->definir_campo('supervisor'            ,array('hereda'=>'personal','campo_relacionado'=>'persona','modo'=>'fk_optativa'));
        $this->definir_campo('recepcionista'         ,array('hereda'=>'personal','campo_relacionado'=>'persona','modo'=>'fk_optativa'));
        $this->definir_campo('informantereemplazante',array('tipo'=>'entero'));
        $this->definir_campo('ultima_visita'         ,array('tipo'=>'logico' ));
        $this->definir_campo('verificado_rec'        ,array('tipo'=>'texto','def'=>'N'));
        //$this->definir_tablas_hijas(array('relpre'=>false ));
    }
}
?>