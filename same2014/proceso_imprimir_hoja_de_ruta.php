<?php
//UTF-8:SÍ

//recorre tem
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_imprimir_hoja_de_ruta__same2014 extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Imprimir hoja de ruta',
            'submenu'=>'campo',
            'permisos'=>array('grupo'=>'subcoor_campo','grupo1'=>'recepcionista'),
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_sufijo_rol' =>array('invisible'=>true,'tipo'=>'entero','label'=>'Rol de la persona','def'=>'enc'),//YA NO SE USA
                'tra_cod_per' =>array('tipo'=>'entero','label'=>'Número de persona'),
            ),
            'boton'=>array('id'=>'imprimir'),
        ));
    }
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
                    $this->salida->enviar_imagen('../imagenes/logo_eah.png','',array('style'=>'width:130px'));
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

        $columnas=array(
            'Disp'          =>array("pla_dispositivo_{$sufijo_rol}"),
            'Com'           =>array('pla_comuna'),
            'Lote'          =>array('pla_lote'),
            'UP'            =>array('pla_up'),
            'Encuesta'      =>array('pla_enc'),
            'Part'          =>array('pla_participacion'),            
            'Calle'         =>array('pla_cnombre'),
            'Número'        =>array('pla_hn'), 
            'Piso'          =>array('pla_hp'), 
            'Depto'         =>array('pla_hd'), 
            'Hab'           =>array('pla_hab'),
            'Barrio'        =>array('pla_barrio'),
            'Ident Edificio'=>array('pla_ident_edif'),
            'REA'           =>array('pla_rea'), 
            'NoREA'         =>array('pla_norea'), 
            'Cod.Enc Cod.Rec'=>array('enc_rec'), 
            'Observaciones' =>array('pla_obs'), 
            'Observaciones año anterior' =>array('obs_ant'), 
        );
        $alineacion=array('Número'=>'derecha','Piso'=>'derecha','Lote'=>'derecha','UP'=>'derecha');
        $this->salida->abrir_grupo_interno('tabla_remito',array('tipo'=>'table'));
            $this->salida->abrir_grupo_interno('',array('tipo'=>'tr'));
                foreach($columnas as $titulo=>$definicion){
                    if ($titulo !='Observaciones año anterior'){
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
                            if($definicion[$i]=='obs_ant'){
                                $es_obs_ant=true;
                                $dato_obs_ant=array();
                                foreach(array($tabla_operativos->datos->ope_ope_anterior, $GLOBALS['NOMBRE_APP']) as $operativo){
                                    $tabla_respuestas->leer_uno_si_hay(array(
                                        'res_ope'=>$operativo,
                                        'res_enc'=>$tabla_tem->datos->pla_enc,
                                        'res_var'=>'s1a1_obs',                                    
                                    ));
                                    if($tabla_respuestas->obtener_leido() && $tabla_respuestas->datos->res_valor){                                    
                                        $dato_obs_ant[]=$operativo.": ".$tabla_respuestas->datos->res_valor;
                                    }
                                }
                                $para_telefonos='';
                                $tabla_respuestas->leer_varios(array(
                                    'res_ope'=>$tabla_operativos->datos->ope_ope_anterior,
                                    'res_enc'=>$tabla_tem->datos->pla_enc, 
                                    'res_for'=>'S1',
                                    'res_var'=>'telefono',
                                ));
                                while($tabla_respuestas->obtener_leido()){
                                    if($tabla_respuestas->datos->res_valor){
                                        $para_telefonos.=$tabla_respuestas->datos->res_hog<>1?(' Hog. '.$tabla_respuestas->datos->res_hog.': '):'';
                                        $para_telefonos.=' '.$tabla_respuestas->datos->res_valor;
                                    }
                                }
                                if($para_telefonos!=''){
                                    $dato_obs_ant[]='Telefono/s:'.$para_telefonos;
                                }
                                $para_respondentes='';
                                $tabla_respuestas->leer_varios(array(
                                    'res_ope'=>$tabla_operativos->datos->ope_ope_anterior,
                                    'res_enc'=>$tabla_tem->datos->pla_enc, 
                                    'res_for'=>'S1',
                                    'res_var'=>'nombrer',
                                ));
                                $respondente_por_hogar= Array();
                                while($tabla_respuestas->obtener_leido()){
                                    if($tabla_respuestas->datos->res_valor){
                                        $respondente_por_hogar[$tabla_respuestas->datos->res_hog]=$tabla_respuestas->datos->res_valor; 
                                    }else{
                                        $respondente_por_hogar[$tabla_respuestas->datos->res_hog]=' ';
                                    }
                                }
                                foreach($respondente_por_hogar as $hogar=>$respondente){
                                    if($respondente==' '){ // lo busco en S1P por respond del S1
                                        $tabla_respuestas->leer_uno_si_hay(array(
                                            'res_ope'=>$tabla_operativos->datos->ope_ope_anterior,
                                            'res_enc'=>$tabla_tem->datos->pla_enc,
                                            'res_hog'=>$hogar,
                                            'res_for'=>'S1',
                                            'res_var'=>'respond',
                                        ));
                                        if($tabla_respuestas->obtener_leido() && $tabla_respuestas->datos->res_valor){
                                            $tabla_respuestas->leer_uno_si_hay(array(
                                                'res_ope'=>$tabla_operativos->datos->ope_ope_anterior,
                                                'res_enc'=>$tabla_tem->datos->pla_enc, 
                                                'res_for'=>'S1',
                                                'res_mat'=>'P',
                                                'res_hog'=>$hogar,
                                                'res_mie'=>$tabla_respuestas->datos->res_valor,
                                                'res_var'=>'nombre',
                                            )); 
                                            if($tabla_respuestas->obtener_leido()){
                                                $respondente_por_hogar[$tabla_respuestas->datos->res_hog]=$tabla_respuestas->datos->res_valor;
                                            }else{ // busco nombre del miembro 1 del hogar
                                                $tabla_respuestas->leer_uno_si_hay(array(
                                                    'res_ope'=>$tabla_operativos->datos->ope_ope_anterior,
                                                    'res_enc'=>$tabla_tem->datos->pla_enc, 
                                                    'res_for'=>'S1',
                                                    'res_mat'=>'P',
                                                    'res_hog'=>$hogar,
                                                    'res_mie'=>1,
                                                    'res_var'=>'nombre',
                                                ));
                                                if($tabla_respuestas->obtener_leido()){ 
                                                    $respondente_por_hogar[$tabla_respuestas->datos->res_hog]=$tabla_respuestas->datos->res_valor;
                                                }
                                            }
                                        }else{ // busco nombre  del miembro 1 del hogar
                                            $tabla_respuestas->leer_uno_si_hay(array(
                                                'res_ope'=>$tabla_operativos->datos->ope_ope_anterior,
                                                'res_enc'=>$tabla_tem->datos->pla_enc, 
                                                'res_for'=>'S1',
                                                'res_mat'=>'P',
                                                'res_hog'=>$hogar,
                                                'res_mie'=>1,
                                                'res_var'=>'nombre',
                                            ));
                                            if($tabla_respuestas->obtener_leido()){ 
                                                $respondente_por_hogar[$tabla_respuestas->datos->res_hog]=$tabla_respuestas->datos->res_valor;
                                            }
                                        }
                                    }
                                }
                                foreach($respondente_por_hogar as $hogar=>$respondente){
                                    if($respondente!=' '){
                                        $para_respondentes.=$hogar<>1?' - Hog. '.$hogar.': ':'';
                                        $para_respondentes.=' '.$respondente;
                                    }
                                }
                                if($para_respondentes!=''){
                                    $dato_obs_ant[]='Respondente/s:'.$para_respondentes;
                                }
                                $tabla_anoenc->leer_varios(array(
                                    'anoenc_ope'=>$tabla_operativos->datos->ope_ope_anterior,
                                    'anoenc_enc'=>$tabla_tem->datos->pla_enc,
                                ));
                                $para_visitas='';
                                while($tabla_anoenc->obtener_leido()){
                                    $para_visitas.=' '.$tabla_anoenc->datos->anoenc_anotacion.' ('.$tabla_anoenc->datos->anoenc_fecha.' '.$tabla_anoenc->datos->anoenc_hora.')';
                                }
                                if($para_visitas!=''){
                                    $dato_obs_ant[]='Visita/s:'.$para_visitas;
                                }
                                if(count($dato_obs_ant)>0){
                                    $this->salida->abrir_grupo_interno('tabla_remito_obs_ant',array('tipo'=>'tr'));
                                    $this->salida->enviar('observaciones '.implode(' / ',$dato_obs_ant),'',array('tipo'=>'td','colspan'=>'99'));
                                    $this->salida->cerrar_grupo_interno();
                                }
                            }else if($definicion[$i]=='enc_rec'){
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
                            if($definicion[$i]=='pla_barrio'){
                                $es_pla_barrio=true; 
                                $mostrar_barrio=$tabla_tem->datos->pla_barrio;
                            }else{
                                $es_pla_barrio=false;
                            }
                            if($definicion[$i]=='pla_ident_edif'){
                                $es_pla_ident_edif=true;
                                $mostrar_ident_edif    =$tabla_tem->datos->pla_ident_edif;
                            }else{
                                $es_pla_ident_edif=false;
                            }
                            if($definicion[$i]=='pla_obs'){
                                $es_pla_obs=true; 
                                $mostrar_obs=$tabla_tem->datos->pla_obs;
                            }else{
                                $es_pla_obs=false;
                            }
                            if ($definicion[$i]=='pla_dispositivo_enc'){
                                $dato=$tabla_tem->datos->pla_dispositivo_enc==1?'DM':'P';                                
                            }
                            $i++;
                        }while($i<count($definicion) && !$dato);
                        if(isset($valores_anteriores[$titulo]) && $valores_anteriores[$titulo]==$dato){
                            $clase='tabla_remito_celda_vacia';
                            $dato_a_mostrar='';
                        }elseif($es_pla_cnombre){
                            $clase='tabla_remito_cnombre15';    
                            $dato_a_mostrar=$mostrar_cnombre;
                        }elseif($es_pla_barrio){
                            $clase='tabla_remito_barrio15';    
                            $dato_a_mostrar=$mostrar_barrio;
                        }elseif($es_pla_ident_edif){
                            $clase='tabla_remito_ident_edif15';
                            $dato_a_mostrar=$mostrar_ident_edif;
                        }elseif($es_pla_obs){
                            $clase='tabla_remito_obs15';
                            $dato_a_mostrar=$mostrar_obs;
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