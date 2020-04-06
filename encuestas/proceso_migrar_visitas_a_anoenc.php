<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_migrar_visitas_a_anoenc extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Migrar visitas',
            'submenu'=>PROCESO_INTERNO,
            'permisos'=>array('grupo'=>'programador'),
            'para_produccion'=>false,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
            ),
            'boton'=>array('id'=>'boton_migrar_visitas','value'=>'migrar visitas >>'),
        ));
    }

    function responder_campos_voy_por(){
    	return array('pla_enc');
	}
    function responder_iniciar_estado(){
    }
    function responder_iniciar_iteraciones(){
        $this->max_segundos=1;
        $filtro=array(
            //'pla_enc'=>$this->argumentos->tra_enc
        );
        $this->tabla_plana_tem_=$this->nuevo_objeto('Tabla_plana_TEM_');
        //$this->tabla_anoenc=$this->nuevo_objeto("tabla_anoenc");
        $f=$this->nuevo_objeto("Filtro_Normal",$filtro,$this->tabla_plana_tem_);
        
        if(isset($this->voy_por)){
            $f=new Filtro_AND(array($f,new Filtro_Voy_Por($this->voy_por)),$this->tabla_plana_tem_);
        }
        $this->cursor=$this->db->ejecutar_sql(new Sql($mostrar=<<<SQL
            SELECT pla_enc,
                   pla_per,
                   pla_obs_campo,
                   pla_rol,
                   pla_tlg
                FROM plana_tem_ 
                WHERE {$f->where} 
                ORDER BY 
SQL
                .implode(', ',$this->responder_campos_voy_por()),
            $f->parametros
        ));
    }
    function responder_hay_mas(){
        $this->voy_por=$this->cursor->fetchObject();
        return !!$this->voy_por;
    }
    function responder_un_paso(){
        if($this->voy_por->pla_obs_campo){
            $visitas = json_decode($this->voy_por->pla_obs_campo);
            $tabla_anoenc=$this->nuevo_objeto("tabla_anoenc");
            //$tabla_tlg = $this->nuevo_objeto("tabla");
            $cont = 0;
            if(is_array($visitas)){
                foreach($visitas as $visita=>$contenido){
                    if($contenido->fecha || $contenido->hora || $contenido->observaciones){
                        $cont++;
                        $tabla_anoenc->valores_para_insert = array(
                            'anoenc_ope'        =>$this->argumentos->tra_ope,
                            'anoenc_enc'        =>$this->voy_por->pla_enc,
                            'anoenc_anoenc'     =>$cont,
                            'anoenc_rol'        =>$this->voy_por->pla_rol?rol_numero_a_texto($this->voy_por->pla_rol):'encuestador',
                            'anoenc_per'        =>$this->voy_por->pla_per,
                            'anoenc_usu'        =>'instalador',
                            'anoenc_fecha'      =>$contenido->fecha,
                            'anoenc_hora'       =>$contenido->hora,
                            'anoenc_anotacion'  =>$contenido->observaciones,
                        );
                        $tabla_anoenc->ejecutar_insercion_si_no_existe();
                    }
                }
            }
        }
    }
    function responder_finalizar(){
        return new Respuesta_Positiva();
    }
}
?>