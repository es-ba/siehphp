<?php
//UTF-8:SÍ
// tablas para la eah2013
require_once "tablas.php";

class Tablas_codigo_descripcion extends Tabla{
    var $con_campos_auditoria=false;
    function definicion_estructura(){
        $this->definir_prefijo('');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('codigo', array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('descripcion', array('tipo'=>'texto','largo'=>50));
    }
}

class Tabla_cod_area_estud      extends Tablas_codigo_descripcion {}
class Tabla_cod_entr_entrvdor   extends Tablas_codigo_descripcion {}
class Tabla_cod_entr_perfil     extends Tablas_codigo_descripcion {}
class Tabla_cod_exp             extends Tablas_codigo_descripcion {}
class Tabla_cod_exp1            extends Tablas_codigo_descripcion {}
class Tabla_cod_niv_est         extends Tablas_codigo_descripcion {}
class Tabla_cod_op_ev_anual     extends Tablas_codigo_descripcion {}
class Tabla_cod_op_ev_puest_rec extends Tablas_codigo_descripcion {}
class Tabla_cod_op_nov          extends Tablas_codigo_descripcion {}
class Tabla_cod_op_resp_llam    extends Tablas_codigo_descripcion {}
class Tabla_cod_op_tip_enc      extends Tablas_codigo_descripcion {}
class Tabla_cod_or_sec          extends Tablas_codigo_descripcion {}
class Tabla_cod_puestos         extends Tablas_codigo_descripcion {}
class Tabla_cod_resul_entrev    extends Tablas_codigo_descripcion {}
class Tabla_cod_resul_llam      extends Tablas_codigo_descripcion {}
class Tabla_cod_tipo_contr      extends Tablas_codigo_descripcion {}
class Tabla_cod_tipo_operativo  extends Tablas_codigo_descripcion {}
class Tabla_cod_ubic_dgeyc      extends Tablas_codigo_descripcion {}
class Tabla_cod_ult_situacion   extends Tablas_codigo_descripcion {}
?>