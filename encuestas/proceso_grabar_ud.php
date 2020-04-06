<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
/*
function LoguearYVer2($que){
    Loguear('2018-11-02',$que);
}
*/
function reconocer_valores_especiales($valor_ingresado,$tipovar){
    $reconocidos=(object)array();
    if($valor_ingresado===NSNC || $valor_ingresado===RELEVAMIENTO_OMITIDO){
        $reconocidos->valesp=$valor_ingresado;
        $reconocidos->valor=NULL;
        $reconocidos->valor_con_error=NULL;
    }else{
        $reconocidos->valesp=NULL;
        $reconocidos->valor=$valor_ingresado;
        $reconocidos->valor_con_error=NULL;
    }
    return $reconocidos;
}

class Proceso_grabar_ud extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Grabar ud desde formulario',
            'submenu'=>PROCESO_INTERNO,
            'parametros'=>array(
                'pk_ud'=>array(),
                'rta_ud'=>array(),
                'estados_rta_ud'=>array(),
                'tra_fecha_hora'=>array('invisible'=>true,'tipo'=>'fecha','def'=>date_format(new DateTime(), "Y-m-d H:i:s")),                
            ),
            'boton'=>array('id'=>'guardar'),
        ));
    }
    static function parte_proceso_grabar_ud($este,$argumentos){
        $tabla_claves=$este->nuevo_objeto('Tabla_claves');
        $tabla_res=new Tabla_respuestas();
        $tabla_res->contexto=$este;
        $filtro_pk=array();
        $con_dato=false;
        foreach($argumentos->rta_ud as $variable=>$valor){
            // graba tra_ud solo cuando alguna variable trae valor 
            if($valor && trim($valor)!=''){
                $con_dato=true;
                break;
            }
            // o cuando estaba la respuesta grabada de antes
            foreach($tabla_res->obtener_nombres_campos_pk() as $campo_res){
                if($campo_res!='res_var'){            
                    $campo_tra='tra_'.quitar_prefijo($campo_res,$tabla_res->obtener_prefijo().'_');
                    $filtro_pk[$campo_res]=$argumentos->pk_ud->{$campo_tra};
                }else{
                    $filtro_pk[$campo_res]=quitar_prefijo($variable,'var_');
                }
            }
            $tabla_res->leer_uno_si_hay($filtro_pk);
            if($tabla_res->obtener_leido() ){
                $con_dato=true;
                break;
            }
        } 
        if($con_dato){
            foreach($tabla_res->obtener_nombres_campos_pk() as $campo_res){
                if($campo_res!='res_var'){
                    $campo_tra='tra_'.quitar_prefijo($campo_res,$tabla_res->obtener_prefijo().'_');
                    $campo_claves=cambiar_prefijo($campo_res,$tabla_res->obtener_prefijo().'_',$tabla_claves->obtener_prefijo().'_');
                    $filtro_pk[$campo_res]=$argumentos->pk_ud->{$campo_tra};
                    $filtro_claves[$campo_claves]=$argumentos->pk_ud->{$campo_tra};
                }
            }
            $tabla_claves->leer_uno_si_hay($filtro_claves);
            if(!$tabla_claves->obtener_leido() ){
                $tabla_claves->valores_para_insert=$filtro_claves;
                $tabla_claves->ejecutar_insercion();
                $tabla_claves->leer_unico($filtro_claves);
            }   
            $cuantas_son=0;
            foreach($argumentos->rta_ud as $variable=>$valor){
                $cuantas_son++;
            }
            $cuantas_faltan=$cuantas_son;
            //apagar el trigger variables calculadas sincronizando con las variables sync
            $este->db->ejecutar_sql(new Sql("update encu.plana_i1_ set pla_sync_i1=1 where pla_enc={$argumentos->pk_ud->tra_enc} and pla_hog={$argumentos->pk_ud->tra_hog} and pla_mie={$argumentos->pk_ud->tra_mie};"));
            $este->db->ejecutar_sql(new Sql("update encu.plana_s1_ set pla_sync_s1=1 where pla_enc={$argumentos->pk_ud->tra_enc} and pla_hog={$argumentos->pk_ud->tra_hog};"));
            /*
            $json_rta_ud=json_encode($argumentos->rta_ud);
            LoguearyVer2('********* rta_ud '.$json_rta_ud);
            $cursor= $este->db->ejecutar_sql(new Sql("SELECT grabar_respuestas_json({$json_rta_ud}::jsonb) ;"));
            $cant_resp=$cursor->fetchObject();
            LoguearyVer2('********* cant rta '.$cant_resp);
            */
            foreach($argumentos->rta_ud as $variable=>$valor){
                $cuantas_faltan--;
                if($cuantas_faltan==1){
                    Loguear('2018-11-01',' UN DIA MAS '.$variable);
                    //disparar el trigger variables calculadas sincronizando con las variables sync
                    $este->db->ejecutar_sql(new Sql("update encu.plana_i1_ set pla_sync_i1=0 where pla_enc={$argumentos->pk_ud->tra_enc} and pla_hog={$argumentos->pk_ud->tra_hog} and pla_mie={$argumentos->pk_ud->tra_mie};"));
                    $este->db->ejecutar_sql(new Sql("update encu.plana_s1_ set pla_sync_s1=0 where pla_enc={$argumentos->pk_ud->tra_enc} and pla_hog={$argumentos->pk_ud->tra_hog};"));
                }
                $reconocidos=reconocer_valores_especiales($valor,null);
                $filtro_pk["res_var"]=quitar_prefijo($variable,'var_');
                $tabla_res->valores_para_update["res_valor"]=$reconocidos->valor;
                $tabla_res->valores_para_update["res_valesp"]=$reconocidos->valesp;
                $tabla_res->valores_para_update["res_valor_con_error"]=$reconocidos->valor_con_error;
                if($argumentos->estados_rta_ud!==null){
                    $tabla_res->valores_para_update["res_estado"]=$argumentos->estados_rta_ud->{$variable};
                }
                if($filtro_pk["res_var"]=='cr_ningun_miembro' && $GLOBALS['nombre_app']=='same2014' && $GLOBALS['nombre_app']=='vcm2018'){
                    $tabla_res->ejecutar_update_varios($filtro_pk); // cambiando
                }else{
                    $tabla_res->ejecutar_update_unico($filtro_pk);
                }
            };
            $tabla_claves->valores_para_update=array(
                'cla_ultimo_coloreo_tlg'=>obtener_tiempo_logico($este)
            );
            $tabla_claves->ejecutar_update_unico($filtro_claves);
        }
    }
    function responder(){
        global $hoy;
        Loguear('2012-03-05','antes de grabar');
        $this->db->beginTransaction();
        // sacar factor común:
        //marcar_tabla($this, $this->argumentos->pk_ud->tra_ope, $this->argumentos->pk_ud->tra_enc, 'Tabla_respuestas', 'TEM','res_var','comenzo_ingreso','res_valor',1);
        marcar_tabla($this, $this->argumentos->pk_ud->tra_ope, $this->argumentos->pk_ud->tra_enc, 'Tabla_respuestas', 'TEM','res_var','comenzo_ingreso','res_valor',date_format(new DateTime(), "Y-m-d H:i:s"));
        // hasta acá 
        $this->parte_proceso_grabar_ud($this,$this->argumentos);
        $this->db->commit();
        $rta='Anduvo bien y guardé';
        Loguear('2013-01-09','después de grabar');
        return new Respuesta_Positiva($rta);
    }
}

function marcar_tabla($este, $operativo, $encuesta, $objeto, $formulario, $variable_a_filtrar, $valor_variable_a_filtrar, $variable_a_updatear, $valor_a_updatear){
    $tabla=$este->nuevo_objeto($objeto);
    $prefijo=$tabla->obtener_prefijo();
    $filtro=claves_respuesta_vacia($prefijo."_");
    $filtro[$prefijo.'_ope']=$operativo;
    $filtro[$prefijo.'_for']=$formulario;
    $filtro[$prefijo.'_enc']=$encuesta;
    $filtro[$variable_a_filtrar]=$valor_variable_a_filtrar;
    $tabla->leer_unico($filtro);
    if(!$tabla->datos->{$variable_a_updatear}){
        $tabla->valores_para_update[$variable_a_updatear]=$valor_a_updatear;
        $tabla->ejecutar_update_unico($filtro);
    }
}

?>