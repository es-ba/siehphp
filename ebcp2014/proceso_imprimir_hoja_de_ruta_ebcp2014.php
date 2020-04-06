<?php
//UTF-8:SÍ

//recorre tem
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_imprimir_hoja_de_ruta__ebcp2014 extends Proceso_imprimir_hoja_de_ruta{
    function imprimir(){
        global $hoy;
        $numero_carga=null;
        $rol_texto = '';
        $this->inforol=Info_Rol::a_partir_de_sufijo($this->argumentos->tra_sufijo_rol);
        $rol_texto=$this->inforol->rol_persona();
        $rol_texto.=' '.$this->argumentos->tra_cod_per;
        $this->argumentos->tra_ope=$GLOBALS['NOMBRE_APP'];
        $anio=substr($this->argumentos->tra_ope, strlen($this->argumentos->tra_ope)-4, 4);
        $this->salida->abrir_grupo_interno('tabla_remito_enc',array('tipo'=>'table','border'=>'none'));
            $this->salida->abrir_grupo_interno('',array('tipo'=>'tr'));
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td','rowspan'=>2,'style'=>'width:90px'));
                    $this->salida->enviar_imagen('../ebcp2014/ebcp2014_icon.gif','',array('style'=>'width:130px'));
                $this->salida->cerrar_grupo_interno();
                $this->salida->enviar('','',array('tipo'=>'td'));
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                    $this->salida->enviar('HOJA DE RUTA');
                $this->salida->cerrar_grupo_interno();
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                $this->salida->enviar($rol_texto);
                $tabla_personal=$this->nuevo_objeto('Tabla_personal');
                $tabla_personal->leer_unico(array(
                    'per_ope'=>$GLOBALS['NOMBRE_APP'],
                    'per_per'=>$this->argumentos->tra_cod_per,
                    'per_activo'=>'true',                    
                ));
                $nombre_y_apellido_persona=$tabla_personal->datos->per_nombre.' '.$tabla_personal->datos->per_apellido;
                $this->salida->enviar($nombre_y_apellido_persona);
                $this->salida->cerrar_grupo_interno();
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                $this->salida->cerrar_grupo_interno();
            $this->salida->cerrar_grupo_interno();
            $this->salida->abrir_grupo_interno('',array('tipo'=>'tr'));
                $this->salida->enviar('','',array('tipo'=>'td'));
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                    $this->salida->enviar('año '.$anio,'',array('style'=>'font-size:80%')); // generalizar
                $this->salida->cerrar_grupo_interno();
                $this->salida->enviar('','',array('tipo'=>'td'));
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                    $this->salida->enviar($hoy->format('d/m/Y'));
                $this->salida->cerrar_grupo_interno();
            $this->salida->cerrar_grupo_interno();
        $this->salida->cerrar_grupo_interno();
        $tabla_operativos=$this->nuevo_objeto('Tabla_operativos');
        $tabla_operativos->leer_unico(array(
            'ope_ope'=>$GLOBALS['NOMBRE_APP']
        ));
        $tabla_respuestas=$this->nuevo_objeto('Tabla_respuestas');        
        $tabla_tem=$this->nuevo_objeto('Tabla_plana_TEM_');
        $tabla_anoenc=$this->nuevo_objeto('Tabla_anoenc');
        $sufijo_rol=$this->inforol->sufijo_rol();
        $tabla_tem->definir_campos_orden(array("pla_dispositivo_{$sufijo_rol}",'pla_lote','pla_cnombre','pla_hn','pla_hp','pla_hd','pla_hab'));
        $filtro_para_tem=new Filtro_OR(array(
                array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>22,
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>23,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>24,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>32,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>33,
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>34,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>42,
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>43,
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>44,
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>45,
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>52,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>53,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>54,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>55,                
                )
        )); 
        if(@$this->argumentos->tra_carga){
            $filtro_para_tem = array_merge($filtro_para_tem, array('pla_carga'=>$this->argumentos->tra_carga));
        }
        $tabla_tem->leer_varios($filtro_para_tem);
/*
Com - Lote - Encuesta - Calle - Número - Piso - Depto - Hab - Mza - Casa - Ident Edificio - Tel - Apellido - Nombre - Cod Enc -Nueva Dirección CABA
*/
        $columnas=array(
            'Com'            =>array('pla_comuna'),
            'Lote'           =>array('pla_lote'),
            'Encuesta'       =>array('pla_enc'),
            'Calle'          =>array('pla_cnombre'),
            'Número'         =>array('pla_hn'), 
            'Piso'           =>array('pla_hp'), 
            'Depto'          =>array('pla_hd'), 
            'Hab'            =>array('pla_hab'),
            'Manzana'        =>array('pla_manzana'),
            'Casa'           =>array('pla_casa'),
            'Ident Edificio' =>array('pla_ident_edif'),
            'Teléfono'       =>array('pla_teltit'),
            'Apellido'       =>array('pla_titu_apellido'),
            'Nombre'         =>array('pla_titu_nombre'),            
            'Cod.Enc'        =>array('enc_rec'),  
            'Nueva Dirección CABA'        =>array('pla_nueva_direccion_caba'),
//            'Observaciones'  =>array('pla_descripcion_de_campo'),             
//            'Información adicional'  =>array('pla_informacion_adicional'),             
        );
        $alineacion=array('Número'=>'derecha','Piso'=>'derecha','Lote'=>'derecha','UP'=>'derecha');
        $this->salida->abrir_grupo_interno('tabla_remito',array('tipo'=>'table'));
            $this->salida->abrir_grupo_interno('',array('tipo'=>'tr'));
                foreach($columnas as $titulo=>$definicion){
                    if ($titulo !='Observaciones' and $titulo !='Información adicional'){
                        $this->salida->enviar($titulo,'',array('tipo'=>'th'));
                    }
                }
            $this->salida->cerrar_grupo_interno();
            $cuenta_encuestas=0;
            while($tabla_tem->obtener_leido()){
                $cuenta_encuestas++;
                $this->salida->abrir_grupo_interno('tabla_remito_fila',array('tipo'=>'tr'));
                    foreach($columnas as $titulo=>$definicion){
                        $i=0;
                        
                        do{

                            if($definicion[$i]=='enc_rec'){
                                if($tabla_tem->datos->pla_cod_recu){
                                    $dato='R '.$tabla_tem->datos->pla_cod_recu;
                                }else{
                                    $dato='E '.$tabla_tem->datos->pla_cod_enc;
                                }
                            }else{
                                $es_obs_ant=false;
                                $dato=$tabla_tem->datos->{$definicion[$i]};
                            }
                            if($definicion[$i]=='pla_cnombre'){
                                $es_pla_cnombre=true; 
                                $mostrar_cnombre=$tabla_tem->datos->pla_cnombre;
                            }else{
                                $es_pla_cnombre=false;
                            }
                            if($definicion[$i]=='pla_ident_edif'){
                                $es_pla_ident_edif=true;
                                $mostrar_ident_edif    =$tabla_tem->datos->pla_ident_edif;
                            }else{
                                $es_pla_ident_edif=false;
                            }
                            $i++;
                        }while($i<count($definicion) && !$dato);
                        if(isset($valores_anteriores[$titulo]) && $valores_anteriores[$titulo]==$dato){
                            $clase='tabla_remito_celda_vacia';
                            $dato_a_mostrar='';
                        }elseif($es_pla_cnombre){
                            $clase='tabla_remito_cnombre15';    
                            $dato_a_mostrar=$mostrar_cnombre;
                        }elseif($es_pla_ident_edif){
                            $clase='tabla_remito_ident_edif15';
                            $dato_a_mostrar=$mostrar_ident_edif;
                        }else{
                            $clase='tabla_remito_td';
                            $dato_a_mostrar=''.$dato;
                            if(isset($valores_anteriores[$titulo])){
                                $valores_anteriores[$titulo]=$dato;
                            }
                        }
                        $clase.=@(' '.$alineacion[$titulo]);
                        if(!$es_obs_ant){
                            $this->salida->enviar($dato_a_mostrar,$clase,array('tipo'=>'td'));
                        }
                    }
                $this->salida->cerrar_grupo_interno();
                if($tabla_tem->datos->pla_obs){
                    $this->salida->abrir_grupo_interno('tabla_remito_fila',array('tipo'=>'tr'));
                        $this->salida->enviar('Obs: '.$tabla_tem->datos->pla_obs,$clase,array('tipo'=>'td','colspan'=>'99'));
                    $this->salida->cerrar_grupo_interno();
                }                
                if($tabla_tem->datos->pla_descripcion_de_campo){
                    $this->salida->abrir_grupo_interno('tabla_remito_fila',array('tipo'=>'tr'));
                        $this->salida->enviar('Observaciones: '.$tabla_tem->datos->pla_descripcion_de_campo,$tabla_tem->datos->pla_obs?'tabla_remito_linea_sin_sep':$clase,array('tipo'=>'td','colspan'=>'99'));
                    $this->salida->cerrar_grupo_interno();
                }
                if($tabla_tem->datos->pla_informacion_adicional){
                    $this->salida->abrir_grupo_interno('tabla_remito_fila',array('tipo'=>'tr'));
                        $this->salida->enviar('Información adicional: '.$tabla_tem->datos->pla_informacion_adicional,($tabla_tem->datos->pla_descripcion_de_campo or $tabla_tem->datos->pla_obs)?'tabla_remito_linea_sin_sep':$clase,array('tipo'=>'td','colspan'=>'99'));
                    $this->salida->cerrar_grupo_interno(); 
                }
            }
        $this->salida->abrir_grupo_interno('tabla_remito_enc',array('tipo'=>'table'));
            $this->salida->abrir_grupo_interno('tabla_remito_totales',array('tipo'=>'tr'));
                $this->salida->enviar('Cantidad total de encuestas: '.$cuenta_encuestas,'',array('tipo'=>'th'));
            $this->salida->cerrar_grupo_interno();
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
cssPagedMedia.size('landscape');
window.print();
            
JS;
        $this->salida->enviar_script($str); 
    }    
}
?>