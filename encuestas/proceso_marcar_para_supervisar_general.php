<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_marcar_para_supervisar_general extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Marcar encuestas para supervisar por comuna',
            'submenu'=>'campo',
            'permisos'=>array('grupo'=>'mues_campo'),
            'para_produccion'=>false,
            'parametros'=>array(
                'tra_comuna'=>array('tipo'=>'entero','label'=>'comuna','def'=>0,'aclaracion'=>'(poner 0 para marcar todas las comunas)'),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'proceder'),
        ));
    }
    function responder(){
        Loguear('2012-04-02','///////////////// Datos recibidos: '.json_encode($this->argumentos));
        $this->db->ejecutar_sql(new Sql(file_get_contents('../encuestas/proceso_marcar_para_supervisar_general.sql')));
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            select marcar_para_supervisar_general(:p_comuna, :p_sesion) as respuesta
SQL
        , array(
            ':p_comuna'=>$this->argumentos->tra_comuna,
            ':p_sesion'=>sesion_actual(),
        )));
        $fila=$cursor->fetchObject();
        $rta=$fila->respuesta;
        return new Respuesta_Positiva($rta);
    }
    /*
    function instalar(){
        $this->db->ejecutar(new Sql(file_get_contents('../encuestas/proceso_marcar_para_supervisar.sql')));
    }
    */
}

?>