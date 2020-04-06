<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_destrabar_carga_dispositivo extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Destrabar carga de dispositivo',
            'permisos'=>array('grupo'=>'coor_campo'),
            'submenu'=>'coordinación de campo',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_per'=>array('tipo'=>'entero','label'=>'Número de la persona'),
                'tra_carga'=>array('tipo'=>'entero','label'=>'Número de la carga'),
                'tra_confirmar1'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Veo que el dispositivo móvil dice 0 encuestas cargadas'),
                'tra_confirmar2'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Verifiqué que las encuestas de esta persona con este número de carga tienen todas estado_de_carga=1'),
                'tra_confirmar3'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Sé que estas encuestas no están cargadas en otro dispositivo'),
                'tra_confirmar4'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Sé que estas encuestas son las que se deben volver a cargar'),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'boton_destrabar','value'=>'destrabar'),
        ));
    }
    function responder(){
        if(!$this->argumentos->tra_confirmar1
            || !$this->argumentos->tra_confirmar2
            || !$this->argumentos->tra_confirmar3
            || !$this->argumentos->tra_confirmar4
        ){
            return new Respuesta_Negativa("No contesto afirmativamente todas las preguntas");
        }else{
            $this->db->ejecutar_sql(new Sql(<<<SQL
update respuestas 
  set res_valor = case res_var when 'per_a_cargar' then :pla_per1 when 'per' then null when 'estado_carga' then 2 end
  where res_ope='{$GLOBALS['nombre_app']}'
    and res_for='TEM'
    and res_hog=0
    and res_var in ('per_a_cargar','per','estado_carga')
    and res_enc in (
        select pla_enc 
          from plana_tem_ 
          where pla_per=:pla_per2 
            and pla_carga=:pla_carga
            and pla_estado_carga=1
    )
SQL
                ,array(
                    'pla_per1'=>$this->argumentos->tra_per,
                    'pla_per2'=>$this->argumentos->tra_per,
                    'pla_carga'=>$this->argumentos->tra_carga,
                )
            ));
        }
        $cantidad_de_variables_del_update=3;
        return new Respuesta_Positiva("Se destrabaron ".($this->db->ultima_consulta->rowCount()/$cantidad_de_variables_del_update));
    }
}
?>