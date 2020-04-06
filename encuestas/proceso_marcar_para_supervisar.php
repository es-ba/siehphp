<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_marcar_para_supervisar extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Marcar encuestas para supervisar según UP',
            'submenu'=>'campo',
            'permisos'=>array('grupo'=>'mues_campo'),
            'para_produccion'=>false,
            'parametros'=>array(
                'tra_replica'=>array('tipo'=>'entero'),
                'tra_comuna'=>array('tipo'=>'entero'),
                'tra_up'=>array('tipo'=>'entero','label'=>'up'),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'proceder'),
        ));
    }
    function responder(){
        Loguear('2012-04-02','///////////////// Datos recibidos: '.json_encode($this->argumentos));
        $this->db->ejecutar_sql(new Sql(file_get_contents('../encuestas/proceso_marcar_para_supervisar.sql')));
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            select marcar_para_supervisar(:p_replica, :p_comuna, :p_up) as respuesta
SQL
        , array(
            ':p_replica'=>$this->argumentos->tra_replica,
            ':p_comuna'=>$this->argumentos->tra_comuna,
            ':p_up'=>$this->argumentos->tra_up,
        )));
        $fila=$cursor->fetchObject();
        $grilla=grilla('vista_up_para_supervision',$this);
        $rta=$grilla->obtener_datos(array(
            'vis_replica'=>$this->argumentos->tra_replica,
            'vis_comuna'=>$this->argumentos->tra_comuna,
            'vis_up'=>$this->argumentos->tra_up,
        ));
        $rta['al_boton']=$fila->respuesta;
        $rta['a_la_fila']=array('vis_encuestas_marcadas_tel'=>'44444','vis_encuestas_marcadas_pre'=>'esto');
        // $rta=$fila->respuesta;
        return new Respuesta_Positiva($rta);
    }
    /*
    function instalar(){
        $this->db->ejecutar(new Sql(file_get_contents('../encuestas/proceso_marcar_para_supervisar.sql')));
    }
    */
}

?>