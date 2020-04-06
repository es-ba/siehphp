<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_conciliar_visitas extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Conciliar visitas',
            'submenu'=>'procesamiento',
            'permisos'=>array('grupo'=>'procesamiento','grupo2'=>'coor_campo'),
            'bitacora'=>true,
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_enc'=>array('tipo'=>'entero','label'=>'Número de encuesta'),
                'tra_enc2'=>array('tipo'=>'entero','label'=>'Segundo número de encuesta'),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'abrir para conciliar visitas','script_ok'=>'abrir_para_conciliar_visitas'),
        ));
    }
    function responder(){
        $filtro=clone $this->argumentos;
        $filtro->tra_numero_control=-951;
        if(!$filtro->tra_ope){
            throw new Exception_Tedede("No está especificado el operativo");
        }
        $tabla_anoenc=$this->nuevo_objeto("tabla_anoenc");
        $filtro_buscar_visitas = new Filtro_Normal(array(
            'anoenc_ope'=>$filtro->tra_ope,
            'anoenc_enc'=>$filtro->tra_enc,
        ));
        $tabla_anoenc->leer_uno_si_hay($filtro_buscar_visitas);
        if(!$tabla_anoenc->obtener_leido()){
            $todaslasrtas[]=false;
            $todaslasrtas[]="La encuesta {$filtro->tra_enc} no tiene visitas registradas o no existe la encuesta"; 
            return new Respuesta_Negativa($todaslasrtas[1]);
        }else{
            do {
                $pk_ud['tra_ope']=$tabla_anoenc->datos->anoenc_ope;
                $pk_ud['tra_enc']=$tabla_anoenc->datos->anoenc_enc;
                $pk_ud['tra_anoenc']=$tabla_anoenc->datos->anoenc_anoenc;            
                $rta=array(
                    'pk_ud'=>$pk_ud,
                    'rta_ud'=>array(),
                    'estados_rta_ud'=>array(),
                    'anotaciones_marginales'=>array(),
                );
                $rta['rta_ud']["rol"]=$tabla_anoenc->datos->anoenc_rol;
                $rta['rta_ud']["per"]=$tabla_anoenc->datos->anoenc_per;
                $rta['rta_ud']["usu"]=$tabla_anoenc->datos->anoenc_usu;
                $rta['rta_ud']["fecha"]=$tabla_anoenc->datos->anoenc_fecha;
                $rta['rta_ud']["hora"]=$tabla_anoenc->datos->anoenc_hora;
                $rta['rta_ud']["anotacion"]=$tabla_anoenc->datos->anoenc_anotacion;
                $todaslasrtas[]=$rta;
            } while($tabla_anoenc->obtener_leido());
            if($filtro->tra_enc2){
                $filtro_buscar_visitas = new Filtro_Normal(array(
                    'anoenc_ope'=>$filtro->tra_ope,
                    'anoenc_enc'=>$filtro->tra_enc2,
                ));
                $tabla_anoenc->leer_uno_si_hay($filtro_buscar_visitas);
                if(!$tabla_anoenc->obtener_leido()){
                    $rta2[]=false;
                    $rta2[]="La encuesta {$filtro->tra_enc2} no tiene visitas registradas o no existe la encuesta"; 
                    return new Respuesta_Negativa($rta2[1]);
                }else{
                    do {
                        $pk_ud['tra_ope']=$tabla_anoenc->datos->anoenc_ope;
                        $pk_ud['tra_enc']=$tabla_anoenc->datos->anoenc_enc;
                        $pk_ud['tra_anoenc']=$tabla_anoenc->datos->anoenc_anoenc;            
                        $rta2=array(
                            'pk_ud'=>$pk_ud,
                            'rta_ud'=>array(),
                            'estados_rta_ud'=>array(),
                            'anotaciones_marginales'=>array(),
                        );
                        $rta2['rta_ud']["rol"]=$tabla_anoenc->datos->anoenc_rol;
                        $rta2['rta_ud']["per"]=$tabla_anoenc->datos->anoenc_per;
                        $rta2['rta_ud']["usu"]=$tabla_anoenc->datos->anoenc_usu;
                        $rta2['rta_ud']["fecha"]=$tabla_anoenc->datos->anoenc_fecha;
                        $rta2['rta_ud']["hora"]=$tabla_anoenc->datos->anoenc_hora;
                        $rta2['rta_ud']["anotacion"]=$tabla_anoenc->datos->anoenc_anotacion;                
                        $todaslasrtas[]=$rta2;
                    } while($tabla_anoenc->obtener_leido());
                }        
            }
        }
        $respuesta=array(
            'tra_enc'=>$this->argumentos->tra_enc,
            'tra_enc2'=>$this->argumentos->tra_enc2,
            'respuestas'=>$todaslasrtas
        );
        return new Respuesta_Positiva($respuesta);
    }
}        

class Grilla_visitas_a_conciliar extends Grilla{
    function obtener_datos(){
        global $claves;
        $columnas=array();
        $columnas['nue_ope']=null;
        $columnas['nue_enc']=null;
        $columnas['nue_anoenc']=null;
        $columnas['vie_ope']=null;
        $columnas['vie_enc']=null;
        $columnas['vie_anoenc']=null;
        $columnas['datos']=null;        
        return array(
            'atributos_fila'=>array('uno'=>null),
            'registros'=>array('vacia'=>$columnas)
        );
    }
    function pks(){
        return array('anterior');
    }
}

function borrar_1_visita($este, $pk_ud_vieja){
    $tabla_anoenc=$este->nuevo_objeto("tabla_anoenc");
    $filtro_delete=array(
        'anoenc_ope'=>$pk_ud_vieja['tra_ope'],
        'anoenc_enc'=>$pk_ud_vieja['tra_enc'],
        'anoenc_anoenc'=>$pk_ud_vieja['tra_anoenc'],    
    );
    $tabla_anoenc->ejecutar_delete_uno($filtro_delete);
}

function insertar_1_visita($este, $pk_ud, $datos_visita){
    $tabla_anoenc=$este->nuevo_objeto("tabla_anoenc");
    $tabla_anoenc->valores_para_insert=array(
        'anoenc_ope'=>$pk_ud['tra_ope'],
        'anoenc_enc'=>$pk_ud['tra_enc'],
        'anoenc_anoenc'=>$pk_ud['tra_anoenc'],
        'anoenc_rol'=>$datos_visita['var_rol'],
        'anoenc_per'=>$datos_visita['var_per'],
        'anoenc_usu'=>$datos_visita['var_usu'],
        'anoenc_fecha'=>$datos_visita['var_fecha'],
        'anoenc_hora'=>$datos_visita['var_hora'],
        'anoenc_anotacion'=>$datos_visita['var_anotacion'],
    );                            
    $tabla_anoenc->ejecutar_insercion();
}

class Proceso_conciliar_visitas_ejecutar extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Conciliar visitas. Ejecutar',
            'submenu'=>PROCESO_INTERNO,
            'permisos'=>array('grupo'=>'procesamiento','grupo2'=>'coor_campo'),
            'para_produccion'=>true,
            'bitacora'=>true,
            'parametros'=>array(
                'tra_registros'=>array(),
            ),
            'boton'=>array('id'=>'ejecutar'),
        ));
    }
    function responder(){
        $tipos_claves_visitas=array('ope'=>'T','enc'=>'N','anoenc'=>'N');
        // acá arriba se pueden controlar más cosas. 
        $registros=(array)($this->argumentos->tra_registros);
        $prefijo='tra_';
        $cambios=array();
        foreach($registros as $pk=>$registro){
            $nueva=array();
            $vieja=array();
            $para_mostrar='';
            foreach($tipos_claves_visitas as $campo_clave=>$tipo){
                if($tipo=='N'){
                    $normalizar=function($algo){ return $algo+0; };
                }else{
                    $normalizar=function($algo){ return $algo.''; };
                }
                $nueva[$prefijo.$campo_clave]=$normalizar($registro->{'nue_'.$campo_clave});
                $vieja[$prefijo.$campo_clave]=$normalizar($registro->{'vie_'.$campo_clave});
            }
            $datos=$registro->resumen;
            if(json_encode($nueva)!=json_encode($vieja)){
                //$datos='"var_'.str_replace(',','","',$datos).'"';
                $datos='"var_'.preg_replace('/(\d|\w),(\w)/','$1","$2',$datos).'"';
                //loguear('2017-02-14','dd:'.$datos);
                $datos=preg_replace('/,"([\w]+):/',',"var_$1":"',$datos);
                $datos=preg_replace('/:"([\d]+)",/',':$1,',$datos);
                $datos='{'.str_replace('var_rol:','var_rol":"',$datos).'}';
                $datos=str_replace('"null"','null',$datos);//ML: ojo, no debería ser necesario
                $datos=str_replace('"," ',', ',$datos);
                loguear('2017-02-14','dll:'.$datos);
                $datos=json_decode($datos);
                $cambios[]=array(
                    'vieja'=>$vieja,
                    'nueva'=>$nueva,
                    'datos'=>$datos,
                );
            }
        }
        $this->db->beginTransaction();
        try{
            foreach($cambios as $cambio){
                $esta_para_borrar=false;
                foreach($cambios as $para_comparar){
                    if(json_encode($cambio['nueva'])===json_encode($para_comparar['vieja'])){
                        $esta_para_borrar=true;
                    }
                }
                $pk_ud=(array)$cambio['nueva']; 
                $datos_visita=(array)$cambio['datos'];                
                if($esta_para_borrar){
                    borrar_1_visita($this,$pk_ud);
                    insertar_1_visita($this,$pk_ud,$datos_visita);
                }else{
                    $pk_ud_vieja=(array)$cambio['vieja'];
                    insertar_1_visita($this,$pk_ud,$datos_visita);
                    borrar_1_visita($this,$pk_ud_vieja);
                }
            }
            $this->db->commit();
        }catch(Exception $err){
            $this->db->rollBack();
            throw $err;
        }    
        $rta='Hechos '.count($cambios).' cambios';
        return new Respuesta_Positiva($rta);
    }
}

?>