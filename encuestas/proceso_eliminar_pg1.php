<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_eliminar_formulario_pg1 extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Eliminar Formulario de mascotas PG1',
            'permisos'=>array('grupo1'=>'coor_campo','grupo2'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_enc'=>array('tipo'=>'entero','label'=>'Número de encuesta'),
                'tra_hog'=>array('tipo'=>'entero','label'=>'Número de hogar'),
                'tra_confirmar1'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Verifique que el formulario está vacío'),
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
            return new Respuesta_Negativa("No contesto afirmativamente alguna de las preguntas");
        }else{
            $cursor = $this->db->ejecutar_sql(new Sql(<<<SQL
                select count(pla_exm) as cantidad from plana_pg1_m 
                  where pla_enc=:tra_enc and pla_hog=:tra_hog and pla_mie=0        
SQL
                ,array(
                    ':tra_enc'=>$this->argumentos->tra_enc,
                    ':tra_hog'=>$this->argumentos->tra_hog,
                )
            ));
            $datos=$cursor->fetchObject();
            if($datos->cantidad > 0){
                return new Respuesta_Negativa('No se puede eliminar el formulario PG1 porque hay mascotas cargadas, elimine primero las mascotas');
            }else{
                $cursor = $this->db->ejecutar_sql(new Sql(<<<SQL
                    select pla_pygf1a as tiene_perros, pla_pygf1b as tiene_gatos  from plana_a1_   
                      where pla_enc=:tra_enc and pla_hog=:tra_hog        
SQL
                    ,array(
                        ':tra_enc'=>$this->argumentos->tra_enc,
                        ':tra_hog'=>$this->argumentos->tra_hog,
                    )
                ));
                $datos=$cursor->fetchObject();
                if($datos){      
                    if($datos->tiene_perros ==1){
                        return new Respuesta_Negativa("No se puede eliminar el formulario PG1 porque indicó en el formulario A1 que tiene perros");
                    }
                    if($datos->tiene_gatos ==1){
                        return new Respuesta_Negativa("No se puede eliminar el formulario PG1 porque indicó en el formulario A1 que tiene gatos");
                    }
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
                            and res_for='PG1'
                            and res_mat=''
                            and res_enc=:tra_enc 
                            and res_hog=:tra_hog
                            and res_mie=0
                            and res_exm=0
SQL
                    ,<<<SQL
                        delete from claves
                          where cla_ope='{$GLOBALS['NOMBRE_APP']}' 
                            and cla_for='PG1'
                            and cla_mat=''
                            and cla_enc=:tra_enc 
                            and cla_hog=:tra_hog
                            and cla_mie=0
                            and cla_exm=0
SQL
                    , "delete from plana_pg1_ where pla_enc=:tra_enc and pla_hog=:tra_hog and pla_mie=0 and pla_exm=0" 
                    ) as $sql_parcial)
                {
                    $this->db->ejecutar_sql(new Sql($sql_parcial,$parametros_borrado));
                }
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