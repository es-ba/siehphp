<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_averiguar_fecha_ultima_carga extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Averiguar la fecha de la última carga',
            'submenu'=>PROCESO_INTERNO,
            'permisos'=>array('grupo'=>'recepcionista'),
            'para_produccion'=>false,
            'parametros'=>array(
                'tra_per'=>array('tipo'=>'entero','label'=>'Número de la persona'),
                'tra_sufijo_rol'=>array('tipo'=>'texto','label'=>'Sufijo del rol de la persona'),
            ),
            'boton'=>array('id'=>'averiguar'),
        ));
    }
    function responder(){
        $ROL=$this->argumentos->tra_sufijo_rol;
        $tabla_plana_tem_=$this->nuevo_objeto("Tabla_plana_TEM_");
		$campos_orden=array(
            "pla_fecha_carga_{$ROL} desc"
        );
		if($ROL=='enc' || $ROL=='recu'){
			$campos_orden[]="pla_fecha_descarga_{$ROL} desc";
		}
        $tabla_plana_tem_->definir_campos_orden($campos_orden);
        $tabla_plana_tem_->leer_varios(array("pla_cod_{$this->argumentos->tra_sufijo_rol}"=>$this->argumentos->tra_per,"pla_fecha_carga_{$this->argumentos->tra_sufijo_rol}"=>Filtro_Normal::IS_NOT_NULL));
        if($tabla_plana_tem_->obtener_leido()){
			$campos=array(
                "pla_fecha_carga_{$ROL}"=>$tabla_plana_tem_->datos->{"pla_fecha_carga_{$ROL}"},
            );
			if($ROL=='enc' || $ROL=='recu'){
                $campos["pla_fecha_descarga_{$ROL}"]=$tabla_plana_tem_->datos->{"pla_fecha_descarga_{$ROL}"};
			}
            return new Respuesta_Positiva($campos);
        }else{
            return new Respuesta_Negativa("No hay carga en esa persona o no esta descargada");
        }
    }
}

?>