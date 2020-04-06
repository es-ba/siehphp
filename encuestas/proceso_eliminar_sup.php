<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_eliminar_formulario_sup extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Eliminar Formulario SUPERVISIÓN',
            'permisos'=>array('grupo1'=>'procesamiento','grupo2'=>'coor_campo'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_enc'=>array('tipo'=>'entero','label'=>'Número de encuesta'),
                'tra_hog'=>array('tipo'=>'entero','label'=>'Número de hogar'),
                'tra_confirmar1'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Borrar el formulario SUP implica borrar los miembros de este formulario', 'disabled'=> !($GLOBALS['NOMBRE_APP']=='ut2016')),
                'tra_confirmar2'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Sé que antes de entrar a esta encuesta tengo que salir del sistema y volver a entrar'),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'boton_eliminar','value'=>'eliminar'),
        ));
    }
    function responder(){
        $vborrar_miembros_sup="";
        if($this->argumentos->tra_ope!=$GLOBALS['NOMBRE_APP']){
            return new Respuesta_Negativa("Solo se pueden eliminar registros del operativo ".$GLOBALS['NOMBRE_APP']);
        }
        if((($GLOBALS['NOMBRE_APP']=='ut2016')&&!$this->argumentos->tra_confirmar1 )|| !$this->argumentos->tra_confirmar2){
            return new Respuesta_Negativa("No contesto afirmativamente la pregunta");
        }else{
            $cursor = $this->db->ejecutar_sql(new Sql(<<<SQL
                select count(s.pla_hog) as cantidad from plana_sup_ s
                where s.pla_enc=:tra_enc and s.pla_hog=:tra_hog
SQL
                ,array(
                    ':tra_enc'=>$this->argumentos->tra_enc,
                    ':tra_hog'=>$this->argumentos->tra_hog
                )
            ));
            $datos=$cursor->fetchObject();
            if($datos->cantidad < 1){
                return new Respuesta_Negativa('No hay formulario SUP para este hogar');
            }
            $this->db->beginTransaction();
            try{
                $parametros_borrado=array(
                    ':tra_enc'=>$this->argumentos->tra_enc,
                    ':tra_hog'=>$this->argumentos->tra_hog,
                );
                foreach(array(
                    <<<SQL
                        delete from respuestas 
                           where res_ope='{$GLOBALS['NOMBRE_APP']}' 
                             and res_for='SUP'
                             and res_enc=:tra_enc 
                             and res_hog=:tra_hog
SQL
                    , <<<SQL
                        delete from claves
                           where cla_ope='{$GLOBALS['NOMBRE_APP']}' 
                             and cla_for='SUP'
                             and cla_enc=:tra_enc 
                             and cla_hog=:tra_hog
SQL
                    , "delete from plana_sup_  where pla_enc=:tra_enc and pla_hog=:tra_hog"
                    ) as $sql_parcial)
                {
                    $this->db->ejecutar_sql(new Sql($sql_parcial,$parametros_borrado));
                }
                if($this->argumentos->tra_confirmar1 &&  $GLOBALS['NOMBRE_APP']=='ut2016'){ //existen operativos q no tiene formulario SUP, P
                  //  Loguear('2016-12-19','se cumple condición');
                    $vborrar_miembros_sup="delete from plana_sup_p where pla_enc=:tra_enc and pla_hog=:tra_hog";
                    {
                        $this->db->ejecutar_sql(new Sql($vborrar_miembros_sup,$parametros_borrado));
                    }
                };
            }catch(Exception $e){
                $this->db->rollBack();
                return new Respuesta_Negativa($e->getMessage());
            }
            $this->db->commit();
        }
        return new Respuesta_Positiva("Eliminado");
    }
}
?>