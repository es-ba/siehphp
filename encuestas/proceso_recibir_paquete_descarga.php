<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

global $campos_visitas;
$campos_visitas=array('fecha','hora','anotacion','per','rol','usu','anoenc');

function LoguearYVer($que){
    Loguear('2018-10-25',$que);
}

class Proceso_recibir_paquete_descarga extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Recibir paquete de encuestas en la descarga',
            'submenu'=>PROCESO_INTERNO,
            'parametros'=>array(
                'fecha_hora'=>array(),
                'paquetes'=>array(),
            ),
            'boton'=>array('id'=>'guardar'),
        ));
    }
    function fin_descarga_dispo($inforol,$paquete){
        global $campos_visitas,$ahora;
        $ROL=$inforol->sufijo_rol();
        $tabla_respuestas=$this->nuevo_objeto('Tabla_respuestas');
        $con_dato=0;
        //$encuesta=$envio->paquete->tra_enc;
        $encuesta=$paquete->tra_enc;
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
        foreach($paquete->tra_visitas as $visita=>$contenido_visita){
            //Loguear('2018-10-26','Visitas campo '+$contenido_visita->fecha );
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
    }
    function responder(){
        global $hoy;
        global $campos_visitas;
        Loguear('2012-03-05','antes de grabar');
        // avisar comienzo de descarga:
        $this->db->beginTransaction();
        LoguearYVer($this->argumentos->tra_paquetes);
        foreach($this->argumentos->tra_paquetes as $envio){
            if($envio->proceso=='grabar_fecha_comenzo_descarga'){
                $ahora=date_format(new DateTime(), "Y-m-d H:i:s");
                $tabla_plana_tem_=$this->nuevo_objeto('Tabla_plana_TEM_');
                $tabla_plana_tem_->update_TEM($envio->paquete->tra_enc,array(
                    'momento_comenzo_descarga'=>$ahora,
                ));
            }
        }
        $this->db->commit();
        // guardado de los datos
        $this->db->beginTransaction();
        LoguearYVer($this->argumentos->tra_paquetes);
        foreach($this->argumentos->tra_paquetes as $envio){
            if($envio->proceso=='grabar_fecha_comenzo_descarga'){
                $ahora=date_format(new DateTime(), "Y-m-d H:i:s");
                $tabla_plana_tem_=$this->nuevo_objeto('Tabla_plana_TEM_');
                $tabla_plana_tem_->update_TEM($envio->paquete->tra_enc,array(
                    'fecha_comenzo_descarga'=>$ahora,
                ));
            }else if($envio->proceso=='fin_descargar_dispositivo_enc'){
                $this->fin_descarga_dispo(new Info_Rol_Enc(), $envio->paquete);
            }else if($envio->proceso=='fin_descargar_dispositivo_sup'){
                $this->fin_descarga_dispo(new Info_Rol_Sup_Campo(),$envio->paquete);
            }else if($envio->proceso=='fin_descargar_dispositivo_recu'){
                $this->fin_descarga_dispo(new Info_Rol_Recu(),$envio->paquete);
            }else if($envio->proceso=='grabar_ud'){
                Proceso_grabar_ud::parte_proceso_grabar_ud($this,$envio->paquete);
            }
        }
        $this->db->commit();
        // avisar comienzo de descarga:
        $this->db->beginTransaction();
        LoguearYVer($this->argumentos->tra_paquetes);
        foreach($this->argumentos->tra_paquetes as $envio){
            if($envio->proceso=='grabar_fecha_comenzo_descarga'){
                $ahora=date_format(new DateTime(), "Y-m-d H:i:s");
                $tabla_plana_tem_=$this->nuevo_objeto('Tabla_plana_TEM_');
                $tabla_plana_tem_->update_TEM($envio->paquete->tra_enc,array(
                    'momento_termino_descarga'=>$ahora,
                ));
            }
        }
        $this->db->commit();
        $rta='Anduvo bien y guardé';
        Loguear('2013-01-09','después de grabar');
        return new Respuesta_Positiva($rta);
    }
}


?>