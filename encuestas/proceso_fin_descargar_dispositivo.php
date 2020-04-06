<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

global $campos_visitas;
$campos_visitas=array('fecha','hora','anotacion','per','rol','usu','anoenc');

class Proceso_fin_descargar_dispositivo_enc extends Proceso_fin_descargar_dispositivo{
    function __construct(){
        $this->inforol=new Info_Rol_Enc();
        parent::__construct();
    }
}

class Proceso_fin_descargar_dispositivo_recu extends Proceso_fin_descargar_dispositivo{
    function __construct(){
        $this->inforol=new Info_Rol_Recu();
        parent::__construct();
    }
}

class Proceso_fin_descargar_dispositivo_sup extends Proceso_fin_descargar_dispositivo{
    function __construct(){
        $this->inforol=new Info_Rol_Sup_Campo();
        parent::__construct();
    }
}

class Proceso_fin_descargar_dispositivo extends Proceso_Formulario{
    function __construct(){
        $rol_persona=$this->inforol->rol_persona();
        $ROL=$this->inforol->sufijo_rol();
        parent::__construct(array(
            'titulo'=>"Registrar fin de descarga dispositivo de {$rol_persona}",
            'submenu'=>'ingreso',
            'permisos'=>array('grupo1'=>'sup_ing','grupo2'=>'subcoor_campo'),
            'parametros'=>array(
                'tra_cod_per'=>array('tipo'=>'entero','label'=>"Número del {$rol_persona}"),
                'tra_enc'=>array('tipo'=>'entero','label'=>'Número de encuesta'),
                'tra_visitas'=>array('label'=>'Visitas'),
                'tra_fecha_hora'=>array('invisible'=>true,'tipo'=>'fecha','def'=>date_format(new DateTime(), "Y-m-d H:i:s")),                
            ),
            'bitacora'=>true,
            'botones'=>array(
                array('id'=>'boton_descargar_dispositivo','value'=>'registrar'),
            ),
        ));
        $this->sin_interrumpir=true;
    }
    function responder(){
        global $campos_visitas,$ahora;
        $ROL=$this->inforol->sufijo_rol();
        $tabla_respuestas=$this->nuevo_objeto('Tabla_respuestas');
        $con_dato=0;
        $encuesta=$this->argumentos->tra_enc;
        $filtro_respuestas= new Filtro_Normal(array(
            'res_ope'        =>$GLOBALS['NOMBRE_APP'],
            'res_enc'        =>$encuesta,
            'res_for'        =>'#!=TEM',
            'res_valor'      =>'#!vacio'
        ), $tabla_respuestas);
        $respuestas_con_dato=0;
        $respuestas_con_dato=$tabla_respuestas->contar_cuantos($filtro_respuestas);
        if($respuestas_con_dato>0){
            $con_dato=1;
        }
        $tabla_anoenc=$this->nuevo_objeto("tabla_anoenc");
        $filtro_buscar_visitas = new Filtro_Normal(array(
            'anoenc_ope'        =>$GLOBALS['NOMBRE_APP'],
            'anoenc_enc'        =>$encuesta,
        ), $tabla_anoenc);
        $tabla_anoenc->ejecutar_delete_varios($filtro_buscar_visitas);
        foreach($this->argumentos->tra_visitas as $visita=>$contenido_visita){
            if($contenido_visita->fecha || $contenido_visita->hora || $contenido_visita->anotacion){
                $tabla_anoenc->valores_para_insert=array();
                foreach($campos_visitas as $campo){
                    $tabla_anoenc->valores_para_insert['anoenc_'.$campo]=$contenido_visita->{$campo}?:null;                    
                }
                $tabla_anoenc->valores_para_insert['anoenc_ope']=$GLOBALS['NOMBRE_APP'];
                $tabla_anoenc->valores_para_insert['anoenc_enc']=$encuesta;
                $tabla_anoenc->ejecutar_insercion();
            }
        }
        $tabla_plana_tem_=$this->nuevo_objeto('Tabla_plana_TEM_');
        $tabla_plana_tem_->update_TEM($encuesta,array( 
            "fecha_descarga_{$ROL}"=>$ahora->format('Y-m-d H:i:s'),
            "con_dato_{$ROL}"=>$con_dato,
            'fecha_comenzo_descarga'=>null,
        ));
        return new Respuesta_Positiva("Descargado");
    }
}

?>