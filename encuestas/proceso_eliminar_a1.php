<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_eliminar_formulario_a1 extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Eliminar Formulario A1',
            'permisos'=>array('grupo1'=>'procesamiento','grupo2'=>'coor_campo'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_enc'=>array('tipo'=>'entero','label'=>'Número de encuesta'),
                'tra_hog'=>array('tipo'=>'entero','label'=>'Número de hogar'),
                'tra_confirmar1'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Borrar el A1 implica borrar los ex-miembros de este formulario'),
                'tra_confirmar2'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Sé que antes de entrar a esta encuesta tengo que salir del sistema y volver a entrar'),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'boton_eliminar','value'=>'eliminar'),
        ));
    }
    function responder(){
        if($this->argumentos->tra_ope!=$GLOBALS['NOMBRE_APP']){
            return new Respuesta_Negativa("Solo se pueden eliminar registros del operativo ".$GLOBALS['NOMBRE_APP']);
        }
        if(!$this->argumentos->tra_confirmar1 || !$this->argumentos->tra_confirmar2){
            return new Respuesta_Negativa("No contesto afirmativamente la pregunta");
        }else{
            $cursor = $this->db->ejecutar_sql(new Sql(<<<SQL
                select count(s1.pla_hog) as cantidad from plana_s1_ s1
                where s1.pla_enc=:tra_enc and s1.pla_hog=:tra_hog and (pla_entrea=:tra_entrea or pla_entrea is null)
SQL
                ,array(
                    ':tra_enc'=>$this->argumentos->tra_enc,
                    ':tra_hog'=>$this->argumentos->tra_hog,
                    ':tra_entrea'=>1
                )
            ));
            $datos=$cursor->fetchObject();
            if($datos->cantidad > 0){
                return new Respuesta_Negativa('Existe un hogar realizado o vacío con esta clave (S1). Para borrar un hogar use la opción "eliminar hogar" o defina este hogar como no realizado');
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
                             and res_for='A1'
                             and res_enc=:tra_enc 
                             and res_hog=:tra_hog
SQL
                    , <<<SQL
                        delete from claves
                           where cla_ope='{$GLOBALS['NOMBRE_APP']}' 
                             and cla_for='A1'
                             and cla_enc=:tra_enc 
                             and cla_hog=:tra_hog
SQL
                    , "delete from plana_a1_  where pla_enc=:tra_enc and pla_hog=:tra_hog"
                    //, "delete from plana_a1_x where pla_enc=:tra_enc and  pla_hog=:tra_hog"
                    ) as $sql_parcial)
                {
                    $this->db->ejecutar_sql(new Sql($sql_parcial,$parametros_borrado));
                }
                $vsentencia="";
                if($this->existe_formulario($GLOBALS['NOMBRE_APP'], 'A1','X', $this)){ //existen operativos q no tiene formulario A1_x.
                    $vsentencia="delete from plana_a1_x where pla_enc=:tra_enc and  pla_hog=:tra_hog";
                    {
                        $this->db->ejecutar_sql(new Sql($vsentencia,$parametros_borrado));
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
    function existe_formulario($pope,$pfor, $pmat,$este){ 
        $tabla_matrices=$este->nuevo_objeto("Tabla_matrices");
        $tabla_matrices->leer_uno_si_hay(array('mat_ope'=>"'".$pope."'" ,'mat_for'=>$pfor,'mat_mat'=>$pmat));
        return $tabla_matrices->obtener_leido();  
    }
}
?>