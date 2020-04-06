<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_borrar_mascotas extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Eliminar mascotas',
            'permisos'=>array('grupo1'=>'coor_campo','grupo2'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_enc'=>array('tipo'=>'entero','label'=>'Número de encuesta'),
                'tra_hog'=>array('tipo'=>'entero','label'=>'Número de hogar'),
                'tra_exm'=>array('tipo'=>'entero','label'=>'Número de mascota en el hogar'),
                'tra_nombre'=>array('tipo'=>'texto','label'=>'Nombre de la mascota a borrar','def'=>null),
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
        if(!$this->argumentos->tra_confirmar1
        ){
            return new Respuesta_Negativa("No contesto afirmativamente todas las preguntas");
        }else{
            $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
                  select pla_pyg1 as nombre_masc
                    from plana_pg1_m
                    where pla_enc=:tra_enc and pla_hog=:tra_hog and pla_mie=0 and pla_exm=:tra_exm
SQL
                ,array(
                    ':tra_enc'=>$this->argumentos->tra_enc,
                    ':tra_hog'=>$this->argumentos->tra_hog,
                    ':tra_exm'=>$this->argumentos->tra_exm,
                )
            ));
            $datos=$cursor->fetchObject();
            if(!$datos){
                return new Respuesta_Negativa("No hay datos para esos parámetros");
            }else{
                if(trim($datos->nombre_masc)!==trim($this->argumentos->tra_nombre)){
                    return new Respuesta_Negativa("No coincide el nombre de la mascota");
                }                
            }
            $this->db->beginTransaction();
            try{
                $parametros_borrado=array(
                    ':tra_enc'=>$this->argumentos->tra_enc,
                    ':tra_hog'=>$this->argumentos->tra_hog,
                    ':tra_exm'=>$this->argumentos->tra_exm,
                );
                foreach(array(
                    <<<SQL
                        delete from respuestas 
                           where res_ope='{$GLOBALS['NOMBRE_APP']}' 
                             and res_for='PG1'
                             and res_mat='M'
                             and res_enc=:tra_enc 
                             and res_hog=:tra_hog
                             and res_mie=0
                             and res_exm=:tra_exm
SQL
                    , <<<SQL
                        delete from claves
                           where cla_ope='{$GLOBALS['NOMBRE_APP']}' 
                             and cla_for='PG1'
                             and cla_mat='M'
                             and cla_enc=:tra_enc 
                             and cla_hog=:tra_hog
                             and cla_mie=0
                             and cla_exm=:tra_exm
SQL
                    , "delete from plana_pg1_m where pla_enc=:tra_enc and pla_hog=:tra_hog and pla_mie=0 and pla_exm=:tra_exm"
                    ) as $sql_parcial)
                {
                    if($sql_parcial){
                        $this->db->ejecutar_sql(new Sql($sql_parcial,$parametros_borrado));
                    }
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