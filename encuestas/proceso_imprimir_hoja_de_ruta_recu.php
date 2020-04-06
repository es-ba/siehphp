<?php
//UTF-8:SÍ

//recorre tem
require_once "lo_imprescindible.php";
require_once "Proceso_imprimir_hoja_de_ruta.php";
require_once "procesos.php";

class Proceso_imprimir_hoja_de_ruta_recu extends Proceso_imprimir_hoja_de_ruta{
    function __construct(){
        Proceso_Formulario::__construct(array(
            'titulo'=>'Imprimir hoja de ruta del recuperador',
            'submenu'=>'campo',
            'permisos'=>array('grupo'=>'subcoor_campo','grupo1'=>'recepcionista'),
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_sufijo_rol' =>array('tipo'=>'texto','label'=>'Rol de la persona', 'def'=>'recu', 'opciones'=>array('recu'=>array('recu','recuperador'), 'sup'=>array('sup','supervisor'))),
                'tra_cod_per' =>array('tipo'=>'entero','label'=>'Número del recuperador / supervisor'),
            ),
            'boton'=>array('id'=>'imprimir'),
        ));
    }    
    public function obtenerColumnas(){
        $sufijo_rol=$this->inforol->sufijo_rol();
        $columnas=array(
            'Com'                        =>array('campos'=>array('pla_comuna')),
            'Área'                       =>array('campos'=>array('pla_area')),
            'Encuesta'                   =>array('campos'=>array('pla_enc')),
            'Sem'                        =>array('campos'=>array('pla_semana')),            
            'Part'                       =>array('campos'=>array('pla_participacion')),
            'Per'                        =>array('campos'=>array('enc_period')),
            'Calle'                      =>array('campos'=>array('pla_cnombre')),
            'Número'                     =>array('campos'=>array('pla_hn')), 
            'Piso'                       =>array('campos'=>array('pla_hp')), 
            'Depto'                      =>array('campos'=>array('pla_hd')), 
            'Hab'                        =>array('campos'=>array('pla_hab')),
            'Barrio'                     =>array('campos'=>array('pla_barrio')),
            //'Ident Edificio'             =>array('campos'=>array('pla_ident_edif')),
            'Edif'                       =>array('campos'=>array('pla_edificio')),
            'Obs'                        =>array('campos'=>array('pla_obs')), 
            'Cod.Enc'                    =>array('campos'=>array('pla_cod_enc')),  
            'Tel'                        =>array('campos'=>array('telefono')),
            'NoRea_Enc'                  =>array('campos'=>array('pla_norea_enc')),
            'Observaciones año anterior' =>array('campos'=>array('obs_ant'),'otro_renglon'=>true),            
        );
        return $columnas;     
    }
}
?>