<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_imprimir_remito extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Imprimir remito de bolsa',
            'submenu'=>'campo',
            'permisos'=>array('grupo'=>'subcoor_campo'),
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_bolsa' =>array('tipo'=>'entero','label'=>'Número de bolsa'),
            ),
            'boton'=>array('id'=>'imprimir'),
        ));
    }
    function imprimir(){
        global $hoy;
        $this->argumentos->tra_ope=$GLOBALS['NOMBRE_APP'];//OJO: Generalizar
        $this->salida->abrir_grupo_interno('tabla_remito_enc',array('tipo'=>'table'));
            $this->salida->abrir_grupo_interno('',array('tipo'=>'tr'));
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td','rowspan'=>2,'style'=>'width:90px'));
                    $this->salida->enviar_imagen('../imagenes/logo_eah.png','',array('style'=>'width:130px'));
                $this->salida->cerrar_grupo_interno();
                $this->salida->enviar('','',array('tipo'=>'td'));
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                    $this->salida->enviar('REMITO DE BOLSA N°');
                    $this->salida->enviar($this->argumentos->tra_bolsa,'',array('style'=>'font-size:130%'));
                $this->salida->cerrar_grupo_interno();
                $this->salida->enviar('','',array('tipo'=>'td'));
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                    $this->salida->enviar('imprimió');
                    $this->salida->enviar(usuario_actual());
                $this->salida->cerrar_grupo_interno();
            $this->salida->cerrar_grupo_interno();
            $this->salida->abrir_grupo_interno('',array('tipo'=>'tr'));
                $this->salida->enviar('','',array('tipo'=>'td'));
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                    $this->salida->enviar('año 2012','',array('style'=>'font-size:80%'));
                $this->salida->cerrar_grupo_interno();
                $this->salida->enviar('','',array('tipo'=>'td'));
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                    $this->salida->enviar($hoy->format('d/m/Y'));
                $this->salida->cerrar_grupo_interno();
            $this->salida->cerrar_grupo_interno();
        $this->salida->cerrar_grupo_interno();
        $tabla_tem=$this->nuevo_objeto('Tabla_plana_TEM_');
        $tabla_tem->leer_varios(array(
            'pla_bolsa'=>$this->argumentos->tra_bolsa,
        ));
        $columnas=array(
            'comuna'     =>array('pla_comuna'   ),
            'réplica'    =>array('pla_replica'  ),
            'up'         =>array('pla_up'       ),
            'lote'       =>array('pla_lote'     ),
            'encues'     =>array('pla_enc'      ),
            'hn'         =>array('pla_hn'       ),
            'hog (S1)'   =>array('pla_hog_tot','pla_hog_pre' ),
            'pobl'       =>array('pla_pob_tot','pla_pob_pre'),
            'norea'      =>array('pla_norea','pla_norea_r','pla_norea_e'),
        );
        $valores_anteriores=array(
            'comuna'     =>'pla_comuna'  ,
            'réplica'    =>'pla_replica' ,
            'up'         =>'pla_up_comuna',
            'lote'       =>'pla_lote',
        );
        $this->salida->abrir_grupo_interno('tabla_remito',array('tipo'=>'table'));
            $this->salida->abrir_grupo_interno('',array('tipo'=>'tr'));
                foreach($columnas as $titulo=>$definicion){
                    $this->salida->enviar($titulo,'',array('tipo'=>'th'));
                }
                $this->salida->enviar('','',array('tipo'=>'th'));
                $this->salida->enviar('','',array('tipo'=>'th','style'=>'width:190px'));
            $this->salida->cerrar_grupo_interno();
            $cuenta_encuestas=0;
            $suma_hogares=0;
            $suma_miembros=0;
            while($tabla_tem->obtener_leido()){
                $cuenta_encuestas++;
                $this->salida->abrir_grupo_interno('',array('tipo'=>'tr'));
                    foreach($columnas as $titulo=>$definicion){
                        $i=0;
                        do{
                            $dato=$tabla_tem->datos->{$definicion[$i]};
                            $i++;
                        }while($i<count($definicion) && !$dato);
                        if($titulo=='hog (S1)'){
                            $suma_hogares+=$dato;
                        }elseif($titulo=='pobl'){
                            $suma_miembros+=$dato;
                        }
                        if(isset($valores_anteriores[$titulo]) && $valores_anteriores[$titulo]==$dato){
                            $clase='tabla_remito_celda_vacia';
                            $dato_a_mostrar='';
                        }else{
                            $clase='tabla_remito_td';
                            $dato_a_mostrar="".$dato;
                            if(isset($valores_anteriores[$titulo])){
                                $valores_anteriores[$titulo]=$dato;
                            }
                        }
                        $this->salida->enviar($dato_a_mostrar,$clase,array('tipo'=>'td'));
                    }
                    $this->salida->enviar('','tabla_remito_td',array('tipo'=>'td'));
                    $this->salida->enviar('','tabla_remito_td',array('tipo'=>'td'));
                $this->salida->cerrar_grupo_interno();
            }
            // /*
            $this->salida->abrir_grupo_interno('tabla_remito_totales',array('tipo'=>'tr'));
                $this->salida->enviar('','',array('tipo'=>'th','colspan'=>4));
                $this->salida->enviar(''.$cuenta_encuestas,'',array('tipo'=>'th'));
                $this->salida->enviar('','',array('tipo'=>'th'));
                $this->salida->enviar(''.$suma_hogares,'',array('tipo'=>'th'));
                $this->salida->enviar(''.$suma_miembros,'',array('tipo'=>'th'));
                $this->salida->enviar('','',array('tipo'=>'th','colspan'=>4));
            $this->salida->cerrar_grupo_interno();
            // */
        $this->salida->cerrar_grupo_interno();
        $str=<<<JS
            var cssPagedMedia = (function () {
                var style = document.createElement('style');
                document.head.appendChild(style);
                return function (rule) {
                    style.innerHTML = rule;
                };
            }());
cssPagedMedia.size = function (size) {
    cssPagedMedia('@page {size: ' + size + '}');
};
cssPagedMedia.size('portrait');
window.print();
JS;
        $this->salida->enviar_script($str); 
        
        
    }
}

?>