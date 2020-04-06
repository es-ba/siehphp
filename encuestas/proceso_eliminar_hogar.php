<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_eliminar_hogar extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Eliminar Hogar',
            'permisos'=>array('grupo1'=>'coor_campo','grupo2'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_enc'=>array('tipo'=>'entero','label'=>'Número de encuesta'),
                'tra_hog'=>array('tipo'=>'entero','label'=>'Número de hogar'),
                'tra_mie'=>array('tipo'=>'entero','label'=>'Número del primer miembro con dato'),
                'tra_edad1'=>array('tipo'=>'entero','label'=>'Edad del primer miembro'),
                'tra_nombre1'=>array('tipo'=>'texto','label'=>'Nombre del primer miembro'),
                'tra_cant_mie'=>array('tipo'=>'texto','label'=>'Cantidad de miembros','aclaracion'=>'contar solo los miembros con nombre'),
                'tra_confirmar1'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Borrar el S1, el A1 y todos los I1 de este hogar'),
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
        if(!$this->argumentos->tra_confirmar1
            || !$this->argumentos->tra_confirmar2
        ){
            return new Respuesta_Negativa("No contesto afirmativamente todas las preguntas");
        }else{
            if(!$this->argumentos->tra_mie && !$this->argumentos->tra_edad1 && !$this->argumentos->tra_nombre1 && !$this->argumentos->tra_cant_mie){
                $cursor = $this->db->ejecutar_sql(new Sql(<<<SQL
                    select count(s1.pla_hog) as cantidad from plana_s1_ s1 left join plana_s1_p s1_p on s1.pla_enc = s1_p.pla_enc and s1.pla_hog = s1_p.pla_hog
                    where s1.pla_enc=:tra_enc and s1.pla_hog=:tra_hog
SQL
                    ,array(
                        ':tra_enc'=>$this->argumentos->tra_enc,
                        ':tra_hog'=>$this->argumentos->tra_hog
                    )
                ));
                $datos=$cursor->fetchObject();
                if(!$datos){
                    return new Respuesta_Negativa("No hay datos en ese hogar");
                }elseif($datos->cantidad > 1){
                    return new Respuesta_Negativa("El hogar tiene miembros ingresados. Debe completar los datos faltantes para poder borrar");
                }
            }else{
                $vedad=$GLOBALS['NOMBRE_APP']=='empav31'?'pla_p9':'pla_edad'; 
                $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
                    select count(nullif(trim(pla_nombre),'')) as cantidad,
                           min(case when trim(pla_nombre)<>'' then pla_mie else null end) as primer_miembro, 
                           string_agg(case when pla_mie=:tra_mie then coalesce(trim(pla_nombre),'')||','||coalesce({$vedad},0) else '' end,'') as nombre_edad
                      from plana_s1_p
                      where pla_enc=:tra_enc and pla_hog=:tra_hog
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
                }elseif($datos){
                    if($datos->cantidad+0<>$this->argumentos->tra_cant_mie+0){
                        return new Respuesta_Negativa("No coincide la cantidad de miembros, es {$datos->cantidad} y no {$this->argumentos->tra_cant_mie}");
                    }
                    if($datos->primer_miembro+0<>$this->argumentos->tra_mie+0){
                        return new Respuesta_Negativa("No coincide el primer miembro, decía {$datos->primer_miembro} y no {$this->argumentos->tra_mie}");
                    }
                    $nombre_edad=$this->argumentos->tra_nombre1.','.$this->argumentos->tra_edad1;
                    if($datos->nombre_edad<>$nombre_edad){
                        return new Respuesta_Negativa("No coincide el nombre o la edad, dice {$datos->nombre_edad} y no {$nombre_edad}");
                    }
                }
            }
            $this->db->beginTransaction();
            try{
                $parametros_borrado=array(
                    ':tra_enc'=>$this->argumentos->tra_enc,
                    ':tra_hog'=>$this->argumentos->tra_hog,
                );
                $sqls=array(
                    <<<SQL
                        delete from respuestas 
                           where res_ope='{$GLOBALS['NOMBRE_APP']}' 
                             and res_for not in ('TEM','SUP')
                             and res_enc=:tra_enc 
                             and res_hog=:tra_hog
SQL
                    , <<<SQL
                        delete from claves
                           where cla_ope='{$GLOBALS['NOMBRE_APP']}' 
                             and cla_for not in ('TEM','SUP')
                             and cla_enc=:tra_enc 
                             and cla_hog=:tra_hog
SQL
                );
                $cursor=$this->db->ejecutar_sql(new Sql(
                    "select mat_for, mat_mat from matrices join formularios on mat_ope=for_ope and mat_for=for_for where mat_ope=:mat_ope and mat_for not in ('TEM','SUP') and not for_es_especial",
                    array(':mat_ope'=>$GLOBALS['NOMBRE_APP'])
                ));
                while(!!$datos=$cursor->fetchObject()){
                    $sqls[] = "delete from plana_".$datos->mat_for."_".$datos->mat_mat." where pla_enc=:tra_enc and  pla_hog=:tra_hog";
                }
                foreach($sqls as $sql_parcial){
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