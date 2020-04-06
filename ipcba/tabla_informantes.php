<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_informantes extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('informante'           ,array('tipo'=>'entero','not_null'=>true,'es_pk'=>true));
        $this->definir_campo('nombreinformante'     ,array('tipo'=>'texto','largo'=>250));
        $this->definir_campo('tipoinformante'       ,array('hereda'=>'tipoinf','modo'=>'fk_obligatoria'));
        $this->definir_campo('rubroclanae'          ,array('tipo'=>'texto','largo'=>250));
        $this->definir_campo('cadena'               ,array('tipo'=>'texto','largo'=>250));
        $this->definir_campo('direccion'            ,array('tipo'=>'texto','largo'=>250));
        $this->definir_campo('altamanaualperiodo'   ,array('tipo'=>'texto','largo'=>11));
        $this->definir_campo('altamanaualpanel'     ,array('tipo'=>'entero'));
        $this->definir_campo('altamanaualtarea'     ,array('tipo'=>'entero'));
        $this->definir_campo('altamanaualconfirmar' ,array('tipo'=>'timestamp'));
        $this->definir_campo('razonsocial'          ,array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('nombrecalle'          ,array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('altura'               ,array('tipo'=>'texto','largo'=>5));
        $this->definir_campo('piso'                 ,array('tipo'=>'texto','largo'=>3));
        $this->definir_campo('departamento'         ,array('tipo'=>'texto','largo'=>4));
        $this->definir_campo('cuit'                 ,array('tipo'=>'entero'));
        $this->definir_campo('naecba'               ,array('tipo'=>'entero'));
        $this->definir_campo('totalpers'            ,array('tipo'=>'entero'));
        $this->definir_campo('cp'                   ,array('tipo'=>'texto','largo'=>8));
        $this->definir_campo('distrito'             ,array('tipo'=>'entero'));
        $this->definir_campo('fraccion'             ,array('tipo'=>'entero'));
        $this->definir_campo('radio'                ,array('tipo'=>'entero'));
        $this->definir_campo('manzana'              ,array('tipo'=>'entero'));
        $this->definir_campo('lado'                 ,array('tipo'=>'entero'));
        $this->definir_campo('obs_listador'         ,array('tipo'=>'texto','largo'=>1000));
        $this->definir_campo('nr_listador'          ,array('tipo'=>'texto','largo'=>1));
        $this->definir_campo('fecha_listado'        ,array('tipo'=>'fecha'));
        $this->definir_campo('grupo_listado'        ,array('tipo'=>'texto','largo'=>14));
        $this->definir_campo('conjuntomuestral'     ,array('hereda'=>'conjuntomuestral','modo'=>'fk_optativa'));
        $this->definir_campo('rubro'                ,array('hereda'=>'rubros','modo'=>'fk_obligatoria'));
        $this->definir_campo('ordenhdr'             ,array('tipo'=>'entero','not_null'=>true,'def'=>100));
        $this->definir_campo('cue'                  ,array('tipo'=>'entero'));
        $this->definir_campo('idlocal'              ,array('tipo'=>'entero'));
        $this->definir_campo('muestra'              ,array('hereda'=>'muestras','modo'=>'fk_obligatoria','def'=>1));
    }
} 

?>