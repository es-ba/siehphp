<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_eliminar_formulario_pmd extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Eliminar Formulario PMD',
            'permisos'=>array('grupo1'=>'procesamiento','grupo2'=>'coor_campo'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_enc'=>array('tipo'=>'entero','label'=>'Número de encuesta'),
                'tra_hog'=>array('tipo'=>'entero','label'=>'Número de hogar'),
                'tra_respon'=>array('tipo'=>'entero','label'=>'Respondente del PMD'),
                'tra_confirmar1'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Sé que antes de entrar a esta encuesta tengo que salir del sistema y volver a entrar'),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'boton_eliminar','value'=>'eliminar'),
        ));
    }
    function responder(){
        if($this->argumentos->tra_ope!=$GLOBALS['NOMBRE_APP']){
            return new Respuesta_Negativa("Solo se pueden eliminar registros del operativo ".$GLOBALS['NOMBRE_APP']);
        }
        if(!$this->argumentos->tra_enc || !$this->argumentos->tra_hog){
            return new Respuesta_Negativa("Falta indicar encuesta y/o hogar");
        }        
        if(!$this->argumentos->tra_confirmar1 ){
            return new Respuesta_Negativa("No contesto afirmativamente la pregunta");
        }else{
            $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
                  select pla_respon as v_respon
                  from plana_pmd_
                  where pla_enc=:tra_enc and pla_hog=:tra_hog and pla_mie=0 and pla_exm=0
SQL
                ,array(
                    ':tra_enc'=>$this->argumentos->tra_enc,
                    ':tra_hog'=>$this->argumentos->tra_hog,
                )
            ));
            $datos=$cursor->fetchObject();
            if(!$datos){
                return new Respuesta_Negativa("No hay datos para esos parámetros");
            }else{
                if($datos->v_respon!==$this->argumentos->tra_respon){
                    return new Respuesta_Negativa("No coincide el respondente");
                }                
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
                             and res_for='PMD'
                             and res_enc=:tra_enc 
                             and res_hog=:tra_hog
SQL
                    , <<<SQL
                        delete from claves
                           where cla_ope='{$GLOBALS['NOMBRE_APP']}' 
                             and cla_for='PMD'
                             and cla_enc=:tra_enc 
                             and cla_hog=:tra_hog
SQL
                    , "delete from plana_pmd_  where pla_enc=:tra_enc and pla_hog=:tra_hog"
                    ) as $sql_parcial)
                {
                    $this->db->ejecutar_sql(new Sql($sql_parcial,$parametros_borrado));
                }
                $vsentencia="";
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