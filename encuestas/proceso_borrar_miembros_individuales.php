<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_borrar_miembros_individuales extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Eliminar miembros individuales',
            'permisos'=>array('grupo1'=>'coor_campo','grupo2'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_enc'=>array('tipo'=>'entero','label'=>'Número de encuesta'),
                'tra_hog'=>array('tipo'=>'entero','label'=>'Número de hogar'),
                'tra_mie'=>array('tipo'=>'entero','label'=>'Número del miembro'),
                'tra_nombre'=>array('tipo'=>'texto','label'=>'Nombre del miembro','def'=>null),
                'tra_edad'=>array('tipo'=>'entero','label'=>'Edad del miembro','def'=>null),
                'tra_borrar_s1_p'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Borra también el renglón P en el S1.'),
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
            $vedad=$GLOBALS['NOMBRE_APP']=='empav31'?'pla_p9':'pla_edad'; 
            $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            select pla_nombre as nombre_com, {$vedad} as edad_com
                  from plana_s1_p
                  where pla_enc=:tra_enc and pla_hog=:tra_hog and pla_mie=:tra_mie and pla_exm=0
SQL
                ,array(
                    ':tra_enc'=>$this->argumentos->tra_enc,
                    ':tra_hog'=>$this->argumentos->tra_hog,
                    ':tra_mie'=>$this->argumentos->tra_mie,
                )
            ));
            $datos=$cursor->fetchObject();
            if(!$datos){
                return new Respuesta_Negativa("No hay datos para esos parámetros");
            }else{
                if(trim($datos->nombre_com) === ''){
                    $datos->nombre_com=null;
                }
                if($datos->nombre_com<>$this->argumentos->tra_nombre){
                    return new Respuesta_Negativa("No coincide el nombre, revise los datos");
                }
                if($datos->edad_com !== $this->argumentos->tra_edad){
                    return new Respuesta_Negativa("No coincide la edad, revise los datos");
                }
            }
            $this->db->beginTransaction();
            try{
                if($this->argumentos->tra_borrar_s1_p){
                    $filtro_mat=' is not null';
                }else{
                    $filtro_mat="<>'P'";
                }
                $parametros_borrado=array(
                    ':tra_enc'=>$this->argumentos->tra_enc,
                    ':tra_hog'=>$this->argumentos->tra_hog,
                    ':tra_mie'=>$this->argumentos->tra_mie,
                );
                foreach(array(
                    <<<SQL
                        delete from respuestas 
                           where res_ope='{$GLOBALS['NOMBRE_APP']}' 
                             and res_for not in ('TEM', 'SUP')
                             and res_mat {$filtro_mat}
                             and res_enc=:tra_enc 
                             and res_hog=:tra_hog
                             and res_mie=:tra_mie
SQL
                    , <<<SQL
                        delete from claves
                           where cla_ope='{$GLOBALS['NOMBRE_APP']}' 
                             and cla_for not in ('TEM', 'SUP')
                             and cla_mat {$filtro_mat}
                             and cla_enc=:tra_enc 
                             and cla_hog=:tra_hog
                             and cla_mie=:tra_mie                             
SQL
                    , "delete from plana_s1_  where pla_enc=:tra_enc and pla_hog=:tra_hog and pla_mie=:tra_mie"
                    , "delete from plana_i1_  where pla_enc=:tra_enc and pla_hog=:tra_hog and pla_mie=:tra_mie"
                    , ($this->argumentos->tra_borrar_s1_p
                          ?"delete from plana_s1_p where pla_enc=:tra_enc and pla_hog=:tra_hog and pla_mie=:tra_mie"
                          :""
                       )
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