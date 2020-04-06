<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_deshacer_carga_dispositivo extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Deshacer carga dispositivo',
            'submenu'=>PROCESO_INTERNO,
            'permisos'=>array('grupo'=>'recepcionista'),
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_lista_enc'=>array('tipo'=>'texto'),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'controlar'),
        ));
        $this->sin_interrumpir=true;
    }
    function responder(){
        Loguear('2012-07-09',gettype($this->argumentos->tra_lista_enc).'----------'.$this->argumentos->tra_lista_enc);
        $this->argumentos->tra_ope=$GLOBALS['NOMBRE_APP'];//OJO: Generalizar
        $tra_lista_enc=json_decode($this->argumentos->tra_lista_enc);
        $parametros_nominales="";
        $parametros_reales=array();
        $cant=0;
        $coma='';
        $this->contexto->db->beginTransaction();
        try{
            $this->tabla_plana_tem_=$this->nuevo_objeto('Tabla_plana_TEM_');
            foreach($tra_lista_enc as $tra_enc){
                $this->tabla_plana_tem_->leer_unico(array('pla_enc'=>$tra_enc, 'pla_for'=>'TEM', 'pla_mat'=>''));
                $this->tabla_plana_tem_->update_TEM($tra_enc,array(
                    'per_a_cargar'=>$this->tabla_plana_tem_->datos->per,
                    'estado_carga'=>2,
                ));
            }
            $this->contexto->db->commit();
        }catch(Exception $e){
            $this->contexto->db->rollBack();
            throw $e;
        }
        return new Respuesta_Positiva($rta);
    }
}

?>