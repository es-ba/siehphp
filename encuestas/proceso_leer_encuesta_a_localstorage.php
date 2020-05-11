<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_leer_encuesta_a_localStorage extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'leer encuesta a localStorage',
            'submenu'=>PROCESO_INTERNO,
            'parametros'=>array(
                'tra_ope'=>array('def'=>$GLOBALS['NOMBRE_APP']),
                'tra_enc'=>array('def'=>'1001'),
                'tra_numero_control'=>array(),
            ),
            'boton'=>array('id'=>'boton_leer_encuesta','value'=>'leer a localStorage','onclick'=>'boton_leer_encuesta()'),
        ));
    }
    function responder(){
        $se_pudo_leer=self::parte_proceso_leer_a_ls_encuesta($this);
        if (!$se_pudo_leer[0]){
            return new Respuesta_Negativa($se_pudo_leer[1]);
        }else{
            return new Respuesta_Positiva($se_pudo_leer);
        }
    }
    static function parte_proceso_leer_a_ls_encuesta($este,$filtro=null,$con_operativos_anteriores=FALSE, $para_claves_a_conciliar_saca_operativo_anterior=FALSE){
        global $probando_ingreso,$esta_es_la_base_en_produccion;
        $tabla_operativos=$este->nuevo_objeto('Tabla_operativos');
        $tabla_operativos->leer_unico(array(
            'ope_ope'=>$GLOBALS['NOMBRE_APP']
        ));
        if($tabla_operativos->datos->ope_ope_anterior!=null && !$para_claves_a_conciliar_saca_operativo_anterior){
           $con_operativos_anteriores=TRUE;
           $operativo_anterior=$tabla_operativos->datos->ope_ope_anterior;   
        }else{
            $operativo_anterior="";
        }
        $todaslasrtas=array();
        if($filtro==null){
            $filtro=$este->argumentos;
        }else{
            $filtro=(object)$filtro;
        }   
        $tabla_tem=$este->nuevo_objeto('Tabla_tem');
        $tabla_tem->leer_uno_si_hay(array(
            'tem_enc'=>$filtro->tra_enc,            
        ));
        if(!$tabla_tem->obtener_leido()){
            //return new Respuesta_Negativa("No existe el número de encuesta {$filtro->tra_enc}");
            $todaslasrtas[]=false;
            $todaslasrtas[]="No existe el número de encuesta {$filtro->tra_enc}";
            return $todaslasrtas;
        }elseif($tabla_tem->datos->tem_hn!=NULL && $tabla_tem->datos->tem_hn!=$filtro->tra_numero_control && -951!=$filtro->tra_numero_control && ((!tiene_rol('programador') && !tiene_rol('procesamiento') && !tiene_rol('ing_sup')) || $filtro->tra_numero_control)){
            //return new Respuesta_Negativa("No coincide el número verificador de la encuesta {$filtro->tra_enc}, no es {$filtro->tra_numero_control}");
            $todaslasrtas[]=false;
            $todaslasrtas[]="No coincide el número verificador de la encuesta {$filtro->tra_enc}, no es {$filtro->tra_numero_control}";
            return $todaslasrtas;
        }else{
            $rol_usuario_actual=rol_actual();
            $tabla_plana_tem_=$este->nuevo_objeto('Tabla_plana_TEM_');
            $tabla_plana_tem_->leer_uno_si_hay(array(
                'pla_enc'=>$filtro->tra_enc,
                'pla_hog'=>0, 
                'pla_mie'=>0, 
                'pla_exm'=>0                
            ));
            if(!$tabla_plana_tem_->obtener_leido()){
                $todaslasrtas[]=false;
                $todaslasrtas[]="No existe el número de encuesta {$filtro->tra_enc} en la tabla plana";
                return $todaslasrtas;
            //}elseif($tabla_plana_tem_->datos->pla_estado_carga==1 && $tabla_plana_tem_->datos->pla_dispositivo==1){
            }elseif($tabla_plana_tem_->datos->pla_estado==23 || $tabla_plana_tem_->datos->pla_estado==33 || $tabla_plana_tem_->datos->pla_estado==46 || $tabla_plana_tem_->datos->pla_estado==56){
                $todaslasrtas[]=false;
                $todaslasrtas[]="La encuesta {$filtro->tra_enc} está en campo en IPAD ";
                return $todaslasrtas;
            }elseif($rol_usuario_actual=='ingresador' && $tabla_plana_tem_->datos->pla_estado != 26 && $tabla_plana_tem_->datos->pla_estado != 36 && (!$probando_ingreso || $esta_es_la_base_en_produccion)){
                $todaslasrtas[]=false;
                $todaslasrtas[]="La encuesta {$filtro->tra_enc} no se puede editar ";
                return $todaslasrtas;
            }else{        
                $tabla_claves=new Tabla_claves();
                $tabla_claves->contexto=$este;
                $nuevo_filtro=array(
                    'cla_ope'=>$filtro->tra_ope,
                    'cla_enc'=>$filtro->tra_enc,            
                );
                if($con_operativos_anteriores){
                    $tabla_operativos->leer_unico(array(
                        'ope_ope'=>$operativo_anterior
                    ));
                    if($tabla_operativos->datos->ope_ope_anterior!=null){  
                        $operativo_anterior_anterior=$tabla_operativos->datos->ope_ope_anterior;
                        $nuevo_filtro=new Filtro_OR(array(
                            $nuevo_filtro
                            ,array(
                                'cla_ope'=>$operativo_anterior, 
                                'cla_enc'=>$filtro->tra_enc,        
                                'cla_for'=>'S1',               
                            ),array(
                                'cla_ope'=>$operativo_anterior,
                                'cla_enc'=>$filtro->tra_enc,
                                'cla_for'=>'A1',
                            ),array(
                                'cla_ope'=>$operativo_anterior_anterior, 
                                'cla_enc'=>$filtro->tra_enc,        
                                'cla_for'=>'S1',               
                            )
                        ));
                    }else{
                        $nuevo_filtro=new Filtro_OR(array(
                            $nuevo_filtro
                            ,array(
                                'cla_ope'=>$operativo_anterior, 
                                'cla_enc'=>$filtro->tra_enc,        
                                'cla_for'=>'S1',               
                            ),array(
                                'cla_ope'=>$operativo_anterior,
                                'cla_enc'=>$filtro->tra_enc,
                                'cla_for'=>'A1',
                            )
                        ));
                    }
                }
                $tabla_claves->leer_varios($nuevo_filtro);
                $claves=array('claves_de'=>$filtro->tra_enc,'formularios'=>null);
                $info_de=array('info_de'=>$filtro->tra_enc,'info'=>array('operativo_actual'=>$GLOBALS['NOMBRE_APP']));
                while($tabla_claves->obtener_leido()){
                    foreach($tabla_claves->obtener_nombres_campos_pk() as $campo_cla){
                        $campo_tra=cambiar_prefijo($campo_cla,$tabla_claves->obtener_prefijo().'_','tra_');
                        $filtro_res[$campo_tra]=$tabla_claves->datos->{$campo_cla};
                    }
                    $rta=Proceso_leer_formulario_a_localStorage::parte_proceso_leer_a_ls_1_ud($este,(object)$filtro_res,($filtro->tra_ope!=$tabla_claves->datos->cla_ope));
                    $claves['formularios'][json_encode($filtro_res)]=true;
                    $todaslasrtas[]=$rta;
                    if($tabla_claves->datos->cla_ope==$operativo_anterior){
                        $info_de['info']['operativo_anterior']=$operativo_anterior;
                    }
                    if($tabla_claves->datos->cla_ope==$operativo_anterior_anterior){
                        $info_de['info']['operativo_anterior_anterior']=$operativo_anterior_anterior;
                    }
                }
                $todaslasrtas[]=$claves;
                $todaslasrtas[]=$info_de;
                /*
                $tem_datos_solicitados=array('tem_cnombre','tem_hn','tem_hp','tem_hd', 'tem_hab', 'tem_lote');            
                $datos_tem = array('datos_tem'=>$filtro->tra_enc, 'varios'=>null);
                foreach($tem_datos_solicitados as $tem_dato){
                    $filtro_tem[$tem_dato]=$tabla_tem->datos->{$tem_dato};            
                }
                $datos_tem['varios']=$filtro_tem;
                $todaslasrtas[]=$datos_tem;
                */
                return $todaslasrtas;
            }
        }
    }
}
?>