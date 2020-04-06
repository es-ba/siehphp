<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_Formulario extends Procesos{
    var $max_segundos=3;
    var $max_pasos=10000;
    var $sin_interrumpir=false;
    function __construct($parametros){
        $this->parametros_aceptados(array(
            'aclaracion'=>null, //array('validar'=>'is_string'),
            'sobre_aclaracion'=>null,
            'label-derecho'=>null,
            'parametros'=>array('validar'=>'is_array'),
            'select'=>array('validar'=>'is_array'),
            'boton'=>array('validar'=>'is_array'),
            'botones'=>array('validar'=>'is_array'),
            'responder'=>null,
            'invisible'=>array('validar'=>'is_bool','def'=>false),
            'readonly'=>array('validar'=>'is_bool','def'=>false),
            'script_arranque'=>null,
            'cuando_un_paso'=>null,
            'html_title'=>null,
            'script_ok'=>null,
            'td_colspan'=>null, // para expandir un td y que las aclaraciones de otros parámetros no se corran mucho cuando ese td es muy ancho
            'td_width'=>null, // para delimitar ancho de td (lo creamos para usarlo en combinacion con 'td_colspan')
            'horizontal'=>array('validar'=>'is_bool','def'=>false),
        ));
        parent::__construct($parametros);
    }
    function mostrarAntesDelFormulario(){
    }
    function correr(){
        $this->salida->abrir_grupo_interno('div_proceso_formulario');
            $this->salida->enviar($this->parametros->titulo,'div_proceso_formulario_titulo');
            $this->mostrarAntesDelFormulario();
            if($this->parametros->aclaracion){
                $this->salida->enviar($this->parametros->aclaracion,'div_proceso_formulario_aclaracion');
            }
            $this->salida->abrir_grupo_interno('div_proceso_formulario_tabla',array('tipo'=>'TABLE'));
                $parametros_para_js;
                $num_renglon_visible=0;
                if($this->parametros->horizontal){
                    $this->salida->abrir_grupo_interno('',array('tipo'=>'TR'));
                }
                foreach($this->parametros->parametros as $parametro=>$def){
                    $invisible=extraer_y_quitar_parametro($def,'invisible',false);
                    $pide_opciones=extraer_y_quitar_parametro($def,'pide_opciones',false);
                    if($pide_opciones){
                        $def['opciones_post_proceso']=" traer_combos(\"{$parametro}\",".json_encode($pide_opciones).");";
                    }
                    $num_renglon_visible+=$invisible?0:1;
                    $script=extraer_y_quitar_parametro($def,'script',null);
                    $label=extraer_y_quitar_parametro($def,'label',$parametro);
                    $valor_por_defecto=extraer_y_quitar_parametro($def,'def','');
                    if(isset($this->argumentos->{$parametro})){
                        $def['value']=$this->argumentos->{$parametro};
                    }else if($valor_por_defecto || $valor_por_defecto==='0' || $valor_por_defecto===0){
                        $def['value']=$valor_por_defecto;
                    }
                    if(@$def['type']=='checkbox' && isset($def['value'])){
                        $def['checked']=$def['value'];
                    }
                    $aclaracion=extraer_y_quitar_parametro($def,'aclaracion','');
                    $label_derecho=extraer_y_quitar_parametro($def,'label-derecho','');
                    $td_colspan=extraer_y_quitar_parametro($def,'td_colspan',null);
                    $td_width=extraer_y_quitar_parametro($def,'td_width',null);                    
                    $sobre_aclaracion=extraer_y_quitar_parametro($def,'sobre_aclaracion','');
                    controlar_parametros($def,array(
                        'name'=>$parametro,
                        'id'=>$parametro,
                    ),true);
                    if(@$def->tipo=='entero'){
                        $def->type='number';
                    }
                    if(isset($def->type) && $def->type=='textarea'){
                        $def->tipo='textarea';
                    }else{
                        $def->tipo='input';
                    }
                    if(isset($this->parametros->enfocar)?$this->parametros->enfocar==$enfocar:$num_renglon_visible==1){
                        $def->autofocus=true;
                    }
                    if(!$this->parametros->horizontal){
                        $this->salida->abrir_grupo_interno('',array('tipo'=>'TR','style'=>($invisible?'display:none':'')));
                    }
                        if($sobre_aclaracion){
                            $this->salida->cerrar_grupo_interno();
                            $this->salida->abrir_grupo_interno('',array('tipo'=>'TR','style'=>($invisible?'display:none':'')));
                            $this->salida->enviar('','',array('tipo'=>'TD','style'=>($invisible?'display:none':'')));
                            $this->salida->enviar($sobre_aclaracion,'div_proceso_formulario_aclaracion',array('tipo'=>'TD','style'=>($invisible?'display:none':''),'colspan'=>2));
                            $this->salida->cerrar_grupo_interno();
                            $this->salida->abrir_grupo_interno('',array('tipo'=>'TR','style'=>($invisible?'display:none':'')));
                        }
                        if($label===false){
                            $this->salida->abrir_grupo_interno('',array('tipo'=>'TD','colspan'=>99));
                        }else{
                            $this->salida->abrir_grupo_interno('',array('tipo'=>'TD'));
                                $this->salida->enviar($label,'div_proceso_formulario_label', array('tipo'=>'label','for'=>$def->name));
                            $this->salida->cerrar_grupo_interno();
                            $this->salida->abrir_grupo_interno('',array('tipo'=>'TD', isset($def->td_colspan)?:'colspan'=>$td_colspan, isset($def->td_width)?:'width'=>$td_width.'px'));
                        }
                            $this->salida->enviar('','div_proceso_formulario_input', (array)$def);
                            $parametros_para_js[]=$def->id;
                        if($label!==false){
                            $this->salida->cerrar_grupo_interno();
                            $this->salida->abrir_grupo_interno('',array('tipo'=>'TD'));
                        }
                            if($label_derecho){
                                $this->salida->enviar($label_derecho,'div_proceso_formulario_label', array('tipo'=>'label','for'=>$def->name));
                            }
                            $this->salida->enviar($aclaracion,'div_proceso_formulario_aclaracion', array('id'=>'aclaracion_'.$def->name,'tipo'=>'span'));
                        $this->salida->cerrar_grupo_interno();
                    if(!$this->parametros->horizontal){
                        $this->salida->cerrar_grupo_interno();
                    }
                }
                if ($this->parametros->select){
                    //$def->tipo='select';
                    $this->salida->abrir_grupo_interno('',array('tipo'=>'TD'));
                        $this->salida->enviar('','div_proceso_formulario_select',array('tipo'=>'select'));
                    $this->salida->cerrar_grupo_interno();
                }
                if ($this->parametros->boton){
                    if (($this->parametros->botones)){
                        throw new Exception_Tedede("Se a declarado un boton y un array de botones");
                    };
                    $botones=array($this->parametros->boton);                    
                }else if($this->parametros->botones){
                    $botones=$this->parametros->botones;
                }else{
                    $botones=array();
                }
                if($this->parametros->opcion_node){
                    $botones[]=array('id'=>'probar node', 'onclick'=>"probar_node('{$this->nombre}','nombre_boton',".json_encode($parametros_para_js).");");
                }
                $y_luego="";
                foreach($botones as $este_boton){
                    if(!$this->parametros->horizontal){
                        $this->salida->abrir_grupo_interno('',array('tipo'=>'TR'));
                    }
                        $this->salida->abrir_grupo_interno('',array('tipo'=>'TD'));
                        $this->salida->cerrar_grupo_interno();
                        $nombre_boton=@$este_boton['id'];
                        $opciones_caja=array('tipo'=>'TD','id'=>"caja_$nombre_boton");
                        if(isset($este_boton['invisible']) && $este_boton['invisible']){
                            $opciones_caja['style']='display:none';
                            unset($este_boton['invisible']);
                        }
                        $this->salida->abrir_grupo_interno('',$opciones_caja);
                            if(strpos($nombre_boton,"'")>0){
                                throw new Exception_Tedede("el nombre de boton no puede tener un apostrofe $nombre_boton");
                            }
                            $script_ok=extraer_y_quitar_parametro($este_boton,'script_ok',array('def'=>'null'));
                            $otro_control=extraer_y_quitar_parametro($este_boton,'otro_control',array('def'=>null));
                            $onclick_boton="proceso_formulario_boton_ejecutar('{$this->nombre}','$nombre_boton',".json_encode($parametros_para_js).",{$script_ok},null".
                                ($este_boton['id']=='imprimir'?',true':',false').
                                ($this->parametros->cuando_un_paso?','.$this->parametros->cuando_un_paso:'').
                                ")";
                            controlar_parametros($este_boton,
                                array('id'=>array('obligatorio'=>true,'validar'=>'is_string'),
                                    'onclick'=>@$este_boton['onclick']?:$onclick_boton,
                                    'value'=>$nombre_boton,
                                    'name'=>$nombre_boton,
                                    'disabled'=>null,
                                    'style'=>null,
                                )
                            );
                            $este_boton->tipo='input';
                            $este_boton->type='button';
                            $this->salida->enviar_boton('','div_proceso_formulario_boton', (array)$este_boton);
                            //<div id="divMayus" style="visibility:hidden">Caps Lock is on.</div> 
                            if($otro_control){
                                $texto=extraer_y_quitar_parametro($otro_control,'innerText',array('def'=>'null'));
                                $this->salida->enviar($texto,'', (array)$otro_control);
                            }
                        $this->salida->cerrar_grupo_interno();
                    if(!$this->parametros->horizontal){
                        $this->salida->cerrar_grupo_interno();
                    }
                    if(@$_REQUEST['y_luego']==$este_boton->id){
                        $y_luego.="{$este_boton->onclick} \n";
                    }
                }
                $this->salida->abrir_grupo_interno('',array('tipo'=>'TR'));
                    $this->salida->enviar('','div_proceso_formulario_respuesta',array('tipo'=>'TD','id'=>'proceso_formulario_respuesta','colspan'=>999));
                $this->salida->cerrar_grupo_interno();
                $this->salida->abrir_grupo_interno('',array('tipo'=>'TR'));
                    $this->salida->enviar('','div_proceso_encuesta_respuesta',array('tipo'=>'TD','id'=>'proceso_encuesta_respuesta','colspan'=>999));
                $this->salida->cerrar_grupo_interno();
            $this->salida->cerrar_grupo_interno();
        $this->salida->cerrar_grupo_interno();
        $this->salida->enviar('','',array('tipo'=>'br'));
        if($this->parametros->script_arranque){
            $this->salida->enviar_script($this->parametros->script_arranque);
        }
        if($y_luego){
            $this->salida->enviar_script($y_luego);
        }
    }
    function validar_argumentos(){
        Loguear('2012-03-22','entre a validar_argumentos()');
        foreach($this->parametros->parametros as $nombre=>$definicion){
            controlar_parametros($definicion,array(
                /* alfabético */
                'aclaracion'=>null,
                'checked'=>null,
                'def'=>null,
                'disabled'=>null,
                'id'=>null,
                'invisible'=>null,
                'label'=>null,
                'label-derecho'=>null,
                'name'=>null,
                'opciones'=>null,
                'opciones_post_proceso'=>null,
                'opciones_pre_proceso'=>null,
                'pide_opciones'=>null,
                'placeholder'=>null,
                'sobre_aclaracion'=>null,
                'style'=>null,
                'td_colspan'=>null,
                'td_width'=>null,
                'tipo'=>null,
                'type'=>null,
                /* eventos */
                'onclick'=>null,
                'onkeydown'=>null,
                'onkeypress'=>null,
            ));
            if($definicion->tipo=='entero'){
                if($this->argumentos->{$nombre}===''){
                    $this->argumentos->{$nombre}=null;
                }else if(is_numeric($this->argumentos->{$nombre}) && substr(trim($this->argumentos->{$nombre}),0,1)!='+'){
                    $this->argumentos->{$nombre}=(integer)$this->argumentos->{$nombre};
                }else if($this->argumentos->{$nombre}!==null){
                    throw new Exception_Tedede("Parametro $nombre se esperaba entero y vino ".$this->argumentos->{$nombre});
                }
            }
        }
    }
    function responder_voy_por(){
        foreach($this->responder_campos_voy_por() as $campo){
            $rta['parcial'][$campo]=$this->voy_por->{$campo};
        }
        $rta['estado']=$this->estado;
        return new Respuesta_Positiva($rta);
    }
    function responder(){
        if($this->responder_campos_voy_por()){
            if(!isset($this->estado)){
                $this->estado=(object)array();
                $this->responder_iniciar_estado();
            }
            $this->responder_iniciar_iteraciones();
            $parar_en=time()+$this->max_segundos;
            $pasos=$this->max_pasos;
            while(($this->sin_interrumpir or time()<$parar_en and $pasos) and ($hubo_avance=$this->responder_hay_mas())){
                $this->responder_un_paso();
                $pasos--;
            }
            if($hubo_avance){
                return $this->responder_voy_por();
            }else{
                return $this->responder_finalizar();
            }
        }else{
            $funcion=$this->parametros->responder;
            return $funcion($this);
        }
    }
    function responder_campos_voy_por(){
        // Definir en esta los nombres de los campos que definen el iterador del ciclo (esto implica que se procesa en partes)
        // dejar así en false si el proceso es de única corrida (o sea solo se programa responder())
        return false;
    }
}
?>