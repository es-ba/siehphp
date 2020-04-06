<?php
//UTF-8:SÍ
require_once "tablas.php";
define('PRIMER_TLG',1);

class Tabla_tiempo_logico extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('tlg'); // transacción local globalizada
        $this->con_campos_auditoria=false;
        $this->muchas_hijas=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('tlg_tlg',array('es_pk'=>true,'tipo'=>'serial','bytes'=>8));
        /* debería ser pero la barranca no lo permite: 
            $this->definir_campo('tlg_ses',array('hereda'=>'sesiones','modo'=>'fk_obligatoria'));
           entonces es: */
        $this->definir_campo('tlg_ses',array('tipo'=>'entero','bytes'=>8));
        $this->definir_campo('tlg_momento',array('tipo'=>'timestamp','def'=>array('funcion'=>'now()')));
        $this->definir_campo('tlg_momento_finalizada',array('tipo'=>'timestamp'));
    }
    function ejecutar_instalacion($con_dependientes=true){
        parent::ejecutar_instalacion($con_dependientes);
        $this->valores_para_insert=array(
            'tlg_ses'=>1,
        );
        $this->ejecutar_insercion();
    }
}

?>