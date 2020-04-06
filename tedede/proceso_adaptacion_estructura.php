<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "contextos.php";
require_once "procesos.php";
require_once "proceso_formulario.php";


class Proceso_adaptacion_estructura extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Adaptación de estructura de la base de datos',
            'submenu'=>'mantenimiento',
            // 'permisos'=>array('grupo'=>'programador'),
            'parametros'=>array(
                'tra_cuales'=>array('label'=>'cuáles','aclaracion'=>'anotar el prefijo del nombre por ejemplo consist','def'=>'pre'),
                'tra_caracteres'=>array('label'=>false,'type'=>'checkbox','label-derecho'=>'controlar y corregir los caracteres válidos de los campos'),
            ),
            'boton'=>array('id'=>'adaptar'),
            'para_produccion'=>true
        ));
    }
    function obtener_tablas(){
        $nombres_clases_tablas=array();
        $nombres_clases_declaradas=get_declared_classes();
        $prefijo=$this->argumentos->tra_cuales;
        foreach($nombres_clases_declaradas as $nombre_clase){
            if(empieza_con($nombre_clase , 'Tabla_'.$prefijo)){
                $nombres_clases_tablas[]=$nombre_clase;
            }
        
        }
        return $nombres_clases_tablas;
    }
    function revisar_tabla($nombre_clase){
        /*
        $tabla_operativos=$this->nuevo_objeto("Tabla_operativos");
        $tabla_operativos->leer_unico(array('ope_ope'=>$parametro_operativo));
        if(!$tabla_operativos->datos->ope_en_campo){
            throw new Excpetion("error no esta en campo");
        }
        */

        $refl=new ReflectionClass($nombre_clase);
        if(!termina_con($refl->getFileName(),'tablas.php') && !$refl->isAbstract()){
            $tabla=$this->nuevo_objeto($nombre_clase);
            if($tabla->obtener_nombre_de_esquema()=='encu'){
                $nombre_tabla=$tabla->obtener_nombre_de_tabla();
                foreach($tabla->obtener_campos() as $nombre_campo=>$def_campo){
                    if(!$this->db->existe_columna($tabla->obtener_nombre_de_esquema(),$nombre_tabla,$nombre_campo)){
                        $this->tablas_revisadas[$nombre_tabla][$nombre_campo]=array(
                            'problema'=>'falta columna'
                        );
                    }else{
                        $atr_col=$this->db->dame_atributos_columna($tabla->obtener_nombre_de_esquema(),$nombre_tabla,$nombre_campo,'TOLERANT');
                        if(isset($def_campo->validart) && $def_campo->validart!=$atr_col->validart){
                            $this->tablas_revisadas[$nombre_tabla][$nombre_campo]=array(
                                'problema'=>'validart',
                                'en_la_base'=>$atr_col->validart,
                                'en_el_php'=>$def_campo->validart
                            );
                        }
                        
                        if($def_campo->tipo=='texto' && $atr_col->tipo_texto && $def_campo->largo != $atr_col->largo_texto){
                            // $texto=$atr_col->tipo_texto;
                             
                            $this->tablas_revisadas[$nombre_tabla][$nombre_campo]=array(
                                'problema'=>'largo texto',
                                'en_la_base'=>$atr_col->largo_texto,
                                'en_el_php'=>$def_campo->largo
                            );
                        }
                        
                        // if( $def_campo->tipo='entero' && !$atr_col->tipo_entero ){
                             // echo ($def_campo->tipo);
                             // $this->tablas_revisadas[$nombre_tabla][$nombre_campo]=array(
                                // 'problema'=>'es entero',
                                // 'en_la_base'=>$atr_col->tipo_entero,
                                // 'en_el_php'=>$def_campo->tipo
                            // );
                        // }
                        if( $atr_col->valor_por_defecto != $def_campo->def){
                            $this->tablas_revisadas[$nombre_tabla][$nombre_campo]=array(
                                'problema'=>'valor por defecto',
                                'en_la_base'=>$atr_col->valor_por_defecto,
                                'en_el_php'=>$def_campo->def
                            );
                        }
                        
                        
                        // if( $atr_col->es_pk != $atr_col->es_pk){
                            // $this->tablas_revisadas[$nombre_tabla][$nombre_campo]=array(
                                // 'problema'=>'pk',
                                // 'en_la_base'=>$atr_col->es_pk,
                                // 'en_el_php'=>$es_pk
                            // );
                        //}
                         
                    }
                }
            }
        }
    }
    function responder(){
        if(!$this->argumentos->tra_caracteres){
            return new Respuesta_Negativa('Tiene que tildar algo para hacer');
        }
        $nombres_clases_tablas=$this->obtener_tablas();
        $reporte="Revisada: ";
        $this->tablas_revisadas=array();
        foreach($nombres_clases_tablas as $nombre_clase){
            //echo "QUIEN ES".$nombre_clase."ES ESTO";
            $this->revisar_tabla($nombre_clase);
        }
        return new Respuesta_Positiva(json_encode($this->tablas_revisadas));
    }

}
?>