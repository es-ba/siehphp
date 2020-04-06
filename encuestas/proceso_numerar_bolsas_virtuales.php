<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_numerar_bolsas_virtuales extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Numerar bolsas virtuales',
            'submenu'=>'procesamiento',
            'permisos'=>array('grupo'=>'procesamiento'),
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_cant_enc_por_bolsa'=>array('tipo'=>'entero', 'def'=>20, 'label'=>'Cantidad de encuestas por bolsa','style'=>'width:30px'),
                'tra_solo_bolsas_completas'=>array('type'=>'checkbox','label'=>'Sólo bolsas completas','label-derecho'=>'las encuestas que no entren en una bolsa completa entrarán en la próxima numeración', 'def'=>true),
                'tra_bolsa_rea'=>array('type'=>'checkbox','label'=>'encuestas realizadas','label-derecho'=>'si la opción queda destildada se incluirán sólo encuestas no realizadas', 'def'=>true),                
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'numerar'),
        ));
    }
    function responder(){
        //Loguear('2012-04-02','///////////////// Datos recibidos: '.json_encode($this->argumentos));
        //$this->db->ejecutar_sql(new Sql(file_get_contents('../encuestas/proceso_numerar_bolsas_virtuales.sql')));
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            select numerar_bolsas_virtuales(:p_cant_enc_por_bolsa, :p_solo_bolsas_completas, :p_bolsa_rea, :p_sesion) as respuesta
SQL
        , array(
            ':p_cant_enc_por_bolsa'=>$this->argumentos->tra_cant_enc_por_bolsa,
            ':p_solo_bolsas_completas'=>$this->argumentos->tra_solo_bolsas_completas,
            ':p_bolsa_rea'=>$this->argumentos->tra_bolsa_rea,
            ':p_sesion'=>sesion_actual(),
        )));
        $fila=$cursor->fetchObject();
        $rta=$fila->respuesta;
        return new Respuesta_Positiva($rta);
    }
    /*
    function instalar(){
        $this->db->ejecutar(new Sql(file_get_contents('../encuestas/proceso_numerar_bolsas_virtuales.sql')));
    }
    */    
}

?>