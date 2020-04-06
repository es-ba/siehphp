<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_controlar_estado_carga extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'controlar_estado_carga',
            'submenu'=>PROCESO_INTERNO,
            'permisos'=>array('grupo'=>'recepcionista'),
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_lista_enc'=>array('tipo'=>'texto'),
                'tra_para_que'=>array('tipo'=>'texto'),
                'tra_rol'=>array('tipo'=>'texto','def'=>'recu'),
                'tra_fecha_hora'=>array('invisible'=>true,'tipo'=>'fecha','def'=>date_format(new DateTime(), "Y-m-d H:i:s")),                
            ),
            'boton'=>array('id'=>'controlar'),
        ));
        $this->sin_interrumpir=true;
    } 
    function responder(){
        $this->inforol=Info_Rol::a_partir_de_sufijo($this->argumentos->tra_rol);
        $estados_asignado=$this->inforol->estados_asignado();
        $estados_cargado_ipad=$this->inforol->estados_cargado_ipad();
        $estados_cargado_papel=$this->inforol->estados_cargado_papel();
        $estados_cargado=array_merge($estados_cargado_ipad,$estados_cargado_papel);
        sort($estados_cargado);
        $mayor_estado_cargado=array_pop($estados_cargado);
        rsort($estados_asignado);
        $estados_asignado_imp=implode(" ,",$estados_asignado);
        $estados_cargado_ipad_imp=implode(",",$estados_cargado_ipad);
        $estados_cargado_papel_imp=implode(",",$estados_cargado_papel);
        $menor_estado_asignado=array_pop($estados_asignado);
        Loguear('2012-07-09',gettype($this->argumentos->tra_lista_enc).'----------'.$this->argumentos->tra_lista_enc);
        $this->argumentos->tra_ope=$GLOBALS['NOMBRE_APP'];
        $tra_lista_enc=json_decode($this->argumentos->tra_lista_enc);
        $parametros_nominales="";
        $parametros_reales=array();
        $cant=0;
        $coma='';
        foreach($tra_lista_enc as $tra_enc){
            $cant++;
            $param_nombre=':p'.$cant;
            $parametros_nominales.=$coma.$param_nombre;
            $parametros_reales[$param_nombre]=$tra_enc;
            $coma=',';
        }
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            select sum(case when pla_estado in ($estados_asignado_imp) then 1 else 0 end) as asignadas,
                   sum(case when pla_estado in ($estados_cargado_ipad_imp) then 1 else 0 end) as cargadas,
                   sum(case when pla_estado in ($estados_cargado_papel_imp) then 1 else 0 end) as en_papel,
                   sum(case when pla_estado > $mayor_estado_cargado then 1 else 0 end) as descargadas,
                   sum(case when pla_estado < $menor_estado_asignado then 1 else 0 end) as nunca_cargadas,
                   count(*) as totales
                from plana_tem_
                where pla_enc in ($parametros_nominales)
SQL
            , $parametros_reales
        ));
        $resultado=$cursor->fetchObject();
        $rta['atencion']='hay ';
        foreach(array('asignadas','cargadas','en_papel','descargadas','nunca_cargadas') as $que){
            if($resultado->{$que}){
                $rta['atencion'].=$resultado->{$que}.' encuestas '.$que.', ';
            }
        }
        $ok=false;
        if($this->argumentos->tra_para_que=='cargar'){
            $ok=$resultado->asignadas==$resultado->totales;
        }else if($this->argumentos->tra_para_que=='descargar'){
            $ok=$resultado->cargadas==$resultado->totales;
        }else if($this->argumentos->tra_para_que=='deshacer carga'){
            
        }else{
            throw new Exception_Tedede("No existe la operacion {$this->argumentos->tra_para_que} en control de estado de carga");
        }
        $rta['resultado']=$resultado;
        $rta['ok']=$ok;
        return new Respuesta_Positiva($rta);
    }
}

?>