<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_destrabar_descarga_dispositivo extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Destrabar descarga de dispositivo',
            'permisos'=>array('grupo'=>'coor_campo'),
            'submenu'=>'coordinación de campo',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_per'=>array('tipo'=>'entero','label'=>'Número de la persona','style'=>'width:60px'),
                'tra_enc'=>array('tipo'=>'entero','label'=>'Número de encuesta','style'=>'width:100px'),
                'tra_estado'=>array('tipo'=>'entero','label'=>'Estado actual','style'=>'width:50px'),
                'tra_observaciones'=>array('tipo'=>'texto','label'=>'Observaciones (optativo)','style'=>'width:550px'),
                'tra_confirmar1'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Veo que el dispositivo móvil no dice que haya encuestas descargadas'),
                'tra_confirmar2'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Verifiqué que las demás encuestas de la carga están en estado 23'),
                'tra_confirmar3'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Sé que si bajo dos veces un dispositivo móvil los datos de la base de datos se pisan al bajar'),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'boton_destrabar','value'=>'destrabar'),
        ));
    }
    function responder(){
        if(!$this->argumentos->tra_confirmar1
            || !$this->argumentos->tra_confirmar2
            || !$this->argumentos->tra_confirmar3
        ){
            return new Respuesta_Negativa("No contesto afirmativamente todas las preguntas");
        }else{
            $this->db->ejecutar_sql(new Sql(<<<SQL
update encu.respuestas set res_valor=null
  where res_ope='{$GLOBALS['nombre_app']}'
    and res_for='TEM'
    and res_hog=0
    and res_var in ('comenzo_ingreso','con_dato_enc')         
    and res_enc in (
        select pla_enc 
          from plana_tem_ 
          where pla_per=:pla_per
            and pla_estado=:pla_estado
            and pla_enc=:pla_enc 
    )
SQL
                ,array(
                    'pla_enc'=>$this->argumentos->tra_enc,
                    'pla_per'=>$this->argumentos->tra_per,
                    'pla_estado'=>$this->argumentos->tra_estado,
                )
            ));
        }
        $cantidad_de_variables_del_update=2;
        return new Respuesta_Positiva("Se destrabó ".($this->db->ultima_consulta->rowCount()/$cantidad_de_variables_del_update));
    }
}
?>