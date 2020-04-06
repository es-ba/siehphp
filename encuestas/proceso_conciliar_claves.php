<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_conciliar_claves extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Conciliar claves',
            'submenu'=>'procesamiento',
            'permisos'=>array('grupo'=>'procesamiento','grupo2'=>'coor_campo'),
            'bitacora'=>true,
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_enc'=>array('tipo'=>'entero','label'=>'Número de encuesta'),
                'tra_enc2'=>array('tipo'=>'entero','label'=>'Segundo número de encuesta'),
            ),
            // 'boton'=>array('id'=>'boton_abrir_para_conciliar','value'=>'abrir','onclick'=>'boton_abrir_para_conciliar()'),
            'bitacora'=>true,
            'boton'=>array('id'=>'abrir para conciliar claves','script_ok'=>'abrir_para_conciliar_claves'),
        ));
    }
    function responder(){
        // $this->argumentos->tra_ope=$GLOBALS['NOMBRE_APP'];//OJO: Generalizar
        $filtro=clone $this->argumentos;
        unset($filtro->tra_enc2);
        $filtro->tra_numero_control=-951;
        if(!$filtro->tra_ope){
            throw new Exception_Tedede("No está especificado el operativo");
        }
        $rta=Proceso_leer_encuesta_a_localStorage::parte_proceso_leer_a_ls_encuesta($this,$filtro,FALSE,TRUE);
        if(!$rta[0]){
            return new Respuesta_Negativa($rta[1]);
        }
        if($this->argumentos->tra_enc2){
            $filtro->tra_enc=$this->argumentos->tra_enc2;
            $rta2=Proceso_leer_encuesta_a_localStorage::parte_proceso_leer_a_ls_encuesta($this,$filtro,FALSE,TRUE);
            if(!$rta2[0]){
                return new Respuesta_Negativa($rta2[1]);
            }
            $rta=array_merge($rta,$rta2);
        }
        return new Respuesta_Positiva($rta);
    }
}

class Grilla_claves_a_conciliar extends Grilla{
    function obtener_datos(){
        global $claves;
        $columnas=array();
        foreach($claves as $clave){
            $columnas['nue_'.$clave]=null;
        }
        foreach($claves as $clave){
            $columnas['vie_'.$clave]=null;
        }
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

function borrar_1_formulario_matriz($este, $pk_ud){
    global $tipos_claves;
    foreach(array(
        array('tabla'=>'respuestas',
              'prefijo'=>'res_',
              'clave_completa'=>true),
        array('tabla'=>'claves',
              'prefijo'=>'cla_',
              'clave_completa'=>true),
        array('tabla'=>'plana',
              'prefijo'=>'pla_',
              'clave_completa'=>false)
        ) as $que_hacer)
    {
        $parametros_borrado=array();
        $sql='delete from '.$que_hacer['tabla'];
        if(!$que_hacer['clave_completa']){
            $sql.="_{$pk_ud['tra_for']}_{$pk_ud['tra_mat']}";
        }
        $sql.=" WHERE TRUE ";
        foreach($tipos_claves as $campo_clave=>$tipo){
            if($que_hacer['clave_completa'] || $tipo=='N'){
                $sql.=" AND {$que_hacer['prefijo']}$campo_clave=:{$que_hacer['prefijo']}$campo_clave";
                $parametros_borrado[":{$que_hacer['prefijo']}$campo_clave"]=$pk_ud["tra_".$campo_clave];
            }
        }
        $este->db->ejecutar_sql(new Sql($sql,$parametros_borrado));
    }
}

class Proceso_conciliar_claves_ejecutar extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Conciliar claves. Ejecutar',
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
        global $tipos_claves;
        // acá arriba se pueden controlar más cosas. 
        $registros=(array)($this->argumentos->tra_registros);
        $prefijo='tra_';
        $cambios=array();
        foreach($registros as $pk=>$registro){
            $nueva=array();
            $vieja=array();
            foreach($tipos_claves as $campo_clave=>$tipo){
                if($tipo=='N'){
                    $normalizar=function($algo){ return $algo+0; };
                }else{
                    $normalizar=function($algo){ return $algo.''; };
                }
                $nueva[$prefijo.$campo_clave]=$normalizar($registro->{'nue_'.$campo_clave});
                $vieja[$prefijo.$campo_clave]=$normalizar($registro->{'vie_'.$campo_clave});
            }
            if(json_encode($nueva)!=json_encode($vieja)){
                $cambios[]=array(
                    'vieja'=>$vieja,
                    'nueva'=>$nueva,
                    'ud'=>Proceso_leer_formulario_a_localStorage::parte_proceso_leer_a_ls_1_ud($this,(object)$vieja,false)
                );
            }
        }
        $this->db->beginTransaction();
        try{
            foreach($cambios as $cambio){
                borrar_1_formulario_matriz($this,$cambio['vieja']);
            }
            // then filtrate TEM now plis !
            foreach($cambios as $cambio){
                $argumentos=json_decode(json_encode($cambio['ud']));
                $rta_ud=(array)($argumentos->rta_ud);
                foreach($rta_ud as $clave=>$valor){ // si argumentos trae copia_ que son los datos de la TEM pura en rta_ud sacarlos
                    if(strpos($clave , 'copia_')===0){
                        unset($rta_ud[$clave]);
                    }
                }
                $argumentos->rta_ud=$rta_ud;
                $argumentos->pk_ud=(object)$cambio['nueva'];
                $argumentos->tra_fecha_hora= date_format(new DateTime(), "Y-m-d H:i:s");
                Proceso_grabar_ud::parte_proceso_grabar_ud($this,$argumentos);
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