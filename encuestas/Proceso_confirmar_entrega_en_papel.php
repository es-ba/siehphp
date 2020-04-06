<?php
//UTF-8:SÍ

//recorre tem
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_confirmar_entrega_en_papel_enc extends Proceso_confirmar_entrega_en_papel{
    function __construct(){
        $this->inforol=new Info_Rol_Enc();
        parent::__construct();
    }
}
class Proceso_confirmar_entrega_en_papel_recu extends Proceso_confirmar_entrega_en_papel{
    function __construct(){
        $this->inforol=new Info_Rol_Recu();
        parent::__construct();
    }
}
class Proceso_confirmar_entrega_en_papel_sup_telefonico extends Proceso_confirmar_entrega_en_papel{
    function __construct(){
        $this->inforol=new Info_Rol_Sup_Telefonico();
        parent::__construct();
    }
}
class Proceso_confirmar_entrega_en_papel_sup_campo extends Proceso_confirmar_entrega_en_papel{
    function __construct(){
        $this->inforol=new Info_Rol_Sup_Campo();
        parent::__construct();
    }
}

class Proceso_confirmar_entrega_en_papel extends Proceso_Formulario{
    function __construct(){
        $ROL=$this->inforol->sufijo_rol();
        $rol_persona=$this->inforol->rol_persona();        
        parent::__construct(array(
            'titulo'=>"Confirmar entrega en papel del {$rol_persona}",
            'submenu'=>'campo',
            'permisos'=>array('grupo'=>'subcoor_campo'),
            'para_produccion'=>false,
            'parametros'=>array(
                'tra_cod_per' =>array('tipo'=>'entero','label'=>'Número de persona'),                
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'confirmar_entrega_en_papel'),
        ));
    }
    function responder(){
        global $hoy;
        $ROL=$this->inforol->sufijo_rol();
        $estado_ttt='#='.implode('|=',$this->inforol->estados_asignado()); 
        $cantidad_encuestas=0;    
        $this->db->beginTransaction();
        try{   
            $es_supervisor= ($ROL == 'sup');
            $tabla_plana_tem=$this->nuevo_objeto('Tabla_plana_TEM_');
            $filtro_para_tem = array(
                "pla_cod_{$ROL}"=>$this->argumentos->tra_cod_per,
                'pla_estado'=>$estado_ttt,
            );
            if(!$es_supervisor){
                $filtro_para_tem["pla_dispositivo_{$ROL}"]=2;
            }
            Loguear('2013-10-22','8888888888888----'.contenido_interno_a_string($filtro_para_tem));
            $tabla_plana_tem->leer_varios($filtro_para_tem);
            $ahora=date_format(new DateTime(), "Y-m-d");
            while($tabla_plana_tem->obtener_leido()){  
                $tabla_plana_tem->update_TEM($tabla_plana_tem->datos->pla_enc,
                    array(
                        "fecha_carga_{$ROL}"=>$ahora,                                        
                    )
                );
                if ($tabla_plana_tem->datos->{"pla_fecha_primcarga_{$ROL}"}===null){
                    $tabla_plana_tem->update_TEM($tabla_plana_tem->datos->pla_enc,array(
                        "fecha_primcarga_{$ROL}"=>$ahora,                        
                    ));
                }
                $cantidad_encuestas++;
            }
            $this->db->commit();
            return new Respuesta_Positiva("Confirmados $cantidad_encuestas encuestas de {$ROL} y fecha {$ahora}"); 
        }catch(Exception $e){
            $this->db->rollBack();
            return new Respuesta_Negativa($e->getMessage());
        }
    }
}
?>