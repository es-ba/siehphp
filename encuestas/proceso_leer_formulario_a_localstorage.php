<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_leer_formulario_a_localStorage extends Proceso_Formulario{
    function __construct(){
        $parametros_tra=claves_respuesta_vacia('tra_');
        foreach($parametros_tra as $clave=>$valor){
            $parametros_tra=array('def'=>$valor);
        }
        $parametros_tra['tra_ope']=array('def'=>$GLOBALS['NOMBRE_APP']);
        parent::__construct(array(
            'titulo'=>'leer formulario a localStorage',
            'submenu'=>PROCESO_INTERNO,
            'parametros'=>$parametros_tra,
            'boton'=>array('id'=>'boton_leer_formulario','value'=>'leer a localStorage','onclick'=>'boton_leer_formulario()'),
        ));
    }
    function responder(){
        $rta=self::parte_proceso_leer_a_ls_1_ud($this,$this->argumentos);
        return new Respuesta_Positiva($rta);
    }
    static function parte_proceso_leer_a_ls_1_ud($este,$filtro,$de_operativos_anteriores=FALSE){
        $filtro->tra_mat=$filtro->tra_mat===NULL?'':$filtro->tra_mat;
        $tabla_matrices=new Tabla_matrices();
        $tabla_matrices->contexto=$este;
        $tabla_matrices->leer_unico(array(
            'mat_ope'=>$filtro->tra_ope,
            'mat_for'=>$filtro->tra_for,
            'mat_mat'=>$filtro->tra_mat
        ));
        $tabla_ua=$tabla_matrices->traer_tabla_con_datos('ua');
        $tabla_claves=$tabla_matrices->definicion_tabla('claves');
        $tabla_claves->contexto=$este;
        $tabla_res=$tabla_matrices->definicion_tabla('respuestas');
        if(!$de_operativos_anteriores){ // garantizo que exista la TEM
            $tabla_claves->leer_unico(array(
                'cla_ope'=>$filtro->tra_ope,
                'cla_enc'=>$filtro->tra_enc,
                'cla_aux_es_enc'=>true,
            ));
            //OJO: Verificar que tenga permiso (por ejemplo entrando en una función en la base)
            //$tabla_res->contexto=$este;
            $tabla_claves->valores_para_insert=array();
            $filtro_res=array();
            foreach($tabla_claves->obtener_nombres_campos_pk() as $campo_cla){
                $campo_tra=cambiar_prefijo($campo_cla,$tabla_claves->obtener_prefijo().'_','tra_');
                $campo_res=cambiar_prefijo($campo_cla,$tabla_claves->obtener_prefijo().'_','res_');
                $tabla_claves->valores_para_insert[$campo_cla]=$filtro->{$campo_tra};
                $filtro_res[$campo_res]=$filtro->{$campo_tra};
                $pk_ud[$campo_tra]=$filtro->{$campo_tra};
            }
            $tabla_claves->ejecutar_insercion_si_no_existe();
        }else{
            foreach($tabla_claves->obtener_nombres_campos_pk() as $campo_cla){
                $campo_tra=cambiar_prefijo($campo_cla,$tabla_claves->obtener_prefijo().'_','tra_');
                $campo_res=cambiar_prefijo($campo_cla,$tabla_claves->obtener_prefijo().'_','res_');
                $filtro_res[$campo_res]=$filtro->{$campo_tra};
                $pk_ud[$campo_tra]=$filtro->{$campo_tra};
            }
        }
        $rta=array(
            'pk_ud'=>$pk_ud,
            'rta_ud'=>array(),
            'estados_rta_ud'=>array(),
            'anotaciones_marginales'=>array(),
        );
        $tabla_res->leer_varios($filtro_res);
        while($tabla_res->obtener_leido()){
            $variable=$tabla_res->datos->res_var;
            $rta['rta_ud']["var_".$variable]=$tabla_res->valor_ingresado();
            $rta['estados_rta_ud']["var_".$variable]=$tabla_res->datos->res_estado;
            $rta['anotaciones_marginales']["var_".$variable]=$tabla_res->datos->res_anotaciones_marginales;
        }
        if($filtro->tra_for=='TEM' && $filtro->tra_mat===''){
            $tabla_tem=$tabla_matrices->definicion_tabla('plana_TEM_');
            $tabla_tem->leer_unico(array(
                'pla_enc'=>$filtro->tra_enc,
            ));
            foreach($tabla_tem->datos as $campo=>$valor){
                $rta['rta_ud'][cambiar_prefijo($campo,'pla_','copia_')]=$valor;
            }
        }
        return $rta;
    }
}
?>