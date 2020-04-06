<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";

class Proceso_fin_de_ingreso extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Fin de ingreso',
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'permisos'=>array('grupo'=>'ingresador'),
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_enc'=>array('tipo'=>'entero'),
                'tra_rol'=>array(),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'marcar'),
        ));
    }
    function responder(){
        $this->tabla_plana_tem=$this->nuevo_objeto("Tabla_plana_TEM_");
        if(!$this->argumentos->tra_rol){
            $this->tabla_plana_tem->leer_unico(array('pla_enc'=>$this->argumentos->tra_enc));
            $tra_rol=$this->tabla_plana_tem->datos->pla_rol;
        }else{
            $tra_rol=$this->argumentos->tra_rol;
        }
        switch($tra_rol){
        case 'encuestador':
            $sufijo='enc';
        break;
        case 'recuperador':
            $sufijo='recu';
        break;
        default:
            return new Respuesta_Negativa("No se puede averiguar el rol de campo de la encuesta {$this->argumentos->tra_enc}");
        }
        $this->tabla_plana_tem->update_TEM($this->argumentos->tra_enc,array("fin_ingreso_{$sufijo}"=>1));
        return new Respuesta_Positiva("Registrado fin de ingreso");
    }
}
?>