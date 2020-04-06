<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";

class Proceso_agregar_novedades_req extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $tabla_proyectos=$this->nuevo_objeto("Tabla_proyectos");    
        $tabla_requerimientos=$this->nuevo_objeto("Tabla_requerimientos");            
        $this->definir_parametros(array(   
            'titulo'=>'Agregar novedades a un requerimiento',
            'submenu'=>PROCESO_INTERNO,
            'html_title'=>"{tra_req}:{tra_proy}*{tra_req} ver requerimiento",
            'parametros'=>array(
                'tra_proy'=>array('label'=>'nombre del proyecto', 'opciones'=>$tabla_proyectos->lista_opciones(array()), 'pide_opciones'=>array('tra_req')),
                'tra_req'=>array('label'=>'código de requerimiento','opciones'=>$tabla_requerimientos->lista_opciones(array())),                
            ),
            'boton'=>array('id'=>'buscar'/*,'value'=>'buscar >>'*/)
            ,
        ));
    }
    function responder(){
        global $esta_es_la_base_en_produccion;
        if(!$this->argumentos->tra_proy ){
            return new Respuesta_Negativa('Debe especificar proyecto');
        }
        if(!$this->argumentos->tra_req){
            return new Respuesta_Negativa('Debe especificar un código de requerimiento');        
        }                
        $tabla_requerimientos = new tabla_requerimientos();
        $tabla_requerimientos->contexto=$this;        
        $tabla_requerimientos->leer_uno_si_hay(array(
            'req_proy'=>$this->argumentos->tra_proy,        
            'req_req'=>$this->argumentos->tra_req,
        ));
        if(!$tabla_requerimientos->obtener_leido()){
            return new Respuesta_Negativa('No existe un requerimiento con ese código para el proyecto declarado');
        }
        //aca va un armador de salida con toda su complejidad
        $this->salida=new Armador_de_salida(true);
        //pone un campo input vacio mas una descripcion
        $this->salida->abrir_grupo_interno('editor_tabla',array('tipo'=>'table','border'=>'single', 'style'=>'width:100%'));
            $plazo = (is_null($tabla_requerimientos->datos->req_plazo) ? null : date_format(date_create($tabla_requerimientos->datos->req_plazo),'d-m-Y'));
            $this->req_ficha_fila($tabla_requerimientos->datos->req_titulo,'Título','req_input');
            $this->req_ficha_fila($tabla_requerimientos->datos->req_tiporeq,'Tipo','req_input');
            $this->req_ficha_fila($tabla_requerimientos->datos->req_prioridad,'Prioridad','req_input');
            $this->req_ficha_fila($tabla_requerimientos->datos->req_costo,'Costo','req_costo');
            $this->req_ficha_fila($tabla_requerimientos->datos->req_grupo,'Grupo','req_input');
            $this->req_ficha_fila($tabla_requerimientos->datos->req_componente,'Componente','req_input');
            $this->req_ficha_fila($tabla_requerimientos->datos->req_detalles,'Detalles','req_multi_linea','pre');                
            $this->req_ficha_fila($plazo,'Plazo','req_input');
        $this->salida->cerrar_grupo_interno();    

        $tabla_reqnov = new tabla_req_nov();
        $tabla_reqnov->contexto=$this;        
        $tabla_reqnov->leer_varios(array(
            'reqnov_proy'=>$this->argumentos->tra_proy,        
            'reqnov_req'=>$this->argumentos->tra_req,
        )); 
        $estado='sin_estado';
        $maximo_tlg=0;
        $tabla_tlg = new tabla_tiempo_logico();
        $tabla_tlg->contexto=$this;    
        $tabla_sesiones = new tabla_sesiones();
        $tabla_sesiones->contexto=$this;           
        $this->salida->abrir_grupo_interno('editor_tabla',array('tipo'=>'table','border'=>'single', 'style'=>'width:100%'));
            $this->salida->abrir_grupo_interno('tabla_titulos',array('tipo'=>'tr'));
                $this->salida->enviar('Fecha','celda_comun req_ficha_fecha',array('tipo'=>'td'));
                $this->salida->enviar('Estado','celda_comun req_ficha_estado',array('tipo'=>'td'));
                $this->salida->enviar('Comentario','celda_comun',array('tipo'=>'td'));
                $this->salida->enviar('Usuario','celda_comun',array('tipo'=>'td'));
            $this->salida->cerrar_grupo_interno();    
            $this->salida->abrir_grupo_interno('',array('tipo'=>'tr'));
                while($tabla_reqnov->obtener_leido()){
                    $tabla_tlg->leer_unico(array(
                        'tlg_tlg'=>$tabla_reqnov->datos->reqnov_tlg,
                    ));
                    $tabla_sesiones->leer_unico(array(
                        'ses_ses'=>$tabla_tlg->datos->tlg_ses,
                    ));
                        $this->salida->abrir_grupo_interno('td_req_nov',array('tipo'=>'tr'));
                            $fecha = new DateTime($tabla_tlg->datos->tlg_momento);
                            $this->salida->enviar($fecha->format('d-m-Y'),'celda_comun req_ficha_fecha',array('tipo'=>'td'));
                            $this->salida->enviar($tabla_reqnov->datos->reqnov_reqest,'celda_comun req_ficha_estado',array('tipo'=>'td'));
                            $vcomentario=$tabla_reqnov->datos->reqnov_comentario;
                            $this->salida->abrir_grupo_interno('celda_comun',array('tipo'=>'td'));
                                if($tabla_reqnov->datos->reqnov_campo=='adjunto' and !!$vcomentario){
                                            $this->salida->enviar('[Bajar]','celda_comun',array('tipo'=>'span'));
                                            $vnombre_orig=$tabla_reqnov->datos->reqnov_actual;
                                            $vnombre_orig=!$vnombre_orig?$vcomentario:$vnombre_orig;
                                            $this->salida->enviar_link($vnombre_orig,'','docs/'.$vcomentario);
                                            $parametros_js=json_encode(array('tra_proy'=>$this->argumentos->tra_proy, 'tra_req'=>$this->argumentos->tra_req,'tra_nov'=>$tabla_reqnov->datos->reqnov_reqnov,'tra_nombrearchivo'=>'docs/'.$vcomentario,'tra_nombrearchivo_orig'=>$vnombre_orig));
                                            //$this->salida->enviar_link($vcomentario,'','bajar.php?'+encodeURIComponent('{$parametros_js}'));
                                            //$this->salida->enviar_link($vcomentario,'','bajar.php?tra_proy=IPCBA&tra_req=61&tra_nov=7');
                                }else{
                                    $this->salida->enviar($vcomentario,'req_comentario',array('tipo'=>'pre'));
                                }    
                            $this->salida->cerrar_grupo_interno();
                            $this->salida->enviar($tabla_sesiones->datos->ses_usu,'celda_comun',array('tipo'=>'td'));
                        $this->salida->cerrar_grupo_interno();    
                        if($tabla_reqnov->datos->reqnov_tlg>$maximo_tlg){
                            $estado=$tabla_reqnov->datos->reqnov_reqest;
                        }
                }
            $this->salida->cerrar_grupo_interno();    
        $this->salida->cerrar_grupo_interno();              
            if ($estado=='sin_estado'){
                return new Respuesta_Negativa('no hay estado');
            }
        $this->salida->abrir_grupo_interno('editor_tabla',array('tipo'=>'table', 'style'=>'width:100%'));    
            $this->salida->abrir_grupo_interno('celda_comun',array('tipo'=>'td'));                    
                    $this->salida->enviar('ESTADO ACTUAL: '.$estado, '');
            $this->salida->cerrar_grupo_interno();
            $tabla_reqestflu = new tabla_req_est_flu();
            $tabla_reqestflu->contexto=$this;        
            $tabla_reqestflu->leer_varios(array(
                'reqestflu_origen'=>$estado
            ));
            $tabla_reqest = new tabla_req_est();
            $tabla_reqest->contexto=$this;
            $tabla_reqest->leer_unico(array(
                'reqest_reqest'=>$estado
            ));
            //solo el input vacio
            $tabla_proy_usu=$this->nuevo_objeto("Tabla_proy_usu");    
            $tabla_proy_usu->contexto=$this;
            $tabla_proy_usu->leer_unico(array(
                'proyusu_usu'=>usuario_actual(),
                'proyusu_proy'=>$this->argumentos->tra_proy
            ));
        $this->salida->cerrar_grupo_interno();      
        $this->salida->abrir_grupo_interno('editor_tabla',array('tipo'=>'table', 'style'=>'width:100%')); 
        $this->salida->abrir_grupo_interno('',array('tipo'=>'tr'));    
            $this->salida->abrir_grupo_interno('celda_comun_salida',array('tipo'=>'td'));                    
                $this->salida->enviar('','', array('id'=>'tra_comentario', 'name'=>'comentario','tipo'=>'textarea', 'style'=>'width:100%', 'rows'=>5, 'placeholder'=>'escribir comentario...','onfocus'=>'habilitar_botones_req(this.id);'/*,'onkeypress'=>"retorno_de_carro('tra_comentario','tra_req');" */, 'onblur'=>'extender_elemento_al_contenido(this,true);habilitar_botones_req()'));
            $this->salida->cerrar_grupo_interno();
            $this->salida->abrir_grupo_interno('celda_comun_salida',array('tipo'=>'td'));
                $this->salida->abrir_grupo_interno('editor_tabla',array('tipo'=>'table', 'style'=>'width:100%'));
                while($tabla_reqestflu->obtener_leido()){
                    if($tabla_reqestflu->datos->reqestflu_origen==$tabla_reqestflu->datos->reqestflu_destino){
                        $this->req_armador_input_boton($tabla_reqestflu->datos->reqestflu_origen,$tabla_reqestflu->datos->reqestflu_accion,'req_input_boton');
                    } else {
                        if($tabla_reqest->datos->reqest_lado != 'nadie'){
                            if((tiene_rol('programador') && $tabla_reqest->datos->reqest_lado == 'desarrollo') || (!tiene_rol('programador') && $tabla_reqest->datos->reqest_lado != 'desarrollo')){ //fijarse de que lado está    
                                if ($tabla_reqestflu->datos->reqestflu_accion != 'confirmar' || $tabla_proy_usu->datos->proyusu_puede_confirmar){
                                    $this->req_armador_input_boton($tabla_reqestflu->datos->reqestflu_origen,$tabla_reqestflu->datos->reqestflu_accion,'boton_flujo');
                                }
                            }
                        } 
                    }
                }
                $this->salida->cerrar_grupo_interno();
            $this->salida->cerrar_grupo_interno();
            $this->salida->abrir_grupo_interno('editor_tabla',array('tipo'=>'table', 'style'=>'width:100%'));
                $this->salida->abrir_grupo_interno('',array('tipo'=>'tr'));                
                    $this->salida->abrir_grupo_interno('celda_comun_salida_boton',array('tipo'=>'td', 'style'=>'width:235px;text-align:right'));                
                        $this->salida->enviar_boton('cambiar prioridad a:','req_input_boton',array('id'=>'cambiar_prioridad', 'name'=>'cambiar_prioridad','onclick'=>"boton_cambiar_atributo_req('prioridad');"));
                    $this->salida->cerrar_grupo_interno();
                    $this->salida->abrir_grupo_interno('celda_comun',array('tipo'=>'td', 'style'=>'text-align:left;vertical-align:bottom'));
                        $this->salida->enviar('','', array('id'=>'tra_nuevo_prioridad', 'name'=>'nuevo_prioridad', 'tipo'=>'input', 'style'=>'width:30px', 'onblur'=>'habilitar_botones_req();','onfocus'=>'habilitar_botones_req(this.id);'));
                    $this->salida->cerrar_grupo_interno();                   
                    $this->salida->enviar('','celda_comun',array('tipo'=>'td'));
                    $this->salida->abrir_grupo_interno('celda_comun_salida_boton',array('tipo'=>'td', 'style'=>'width:235px;text-align:right'));                
                        $this->salida->enviar_boton('cambiar plazo a:','req_input_boton',array('id'=>'cambiar_plazo', 'name'=>'cambiar_plazo','onclick'=>"boton_cambiar_atributo_req('plazo');"));
                    $this->salida->cerrar_grupo_interno();
                    $this->salida->abrir_grupo_interno('celda_comun',array('tipo'=>'td', 'style'=>'text-align:left;vertical-align:bottom'));
                        $this->salida->enviar('','', array('id'=>'tra_nuevo_plazo', 'name'=>'nuevo_plazo', 'tipo'=>'input', 'style'=>'width:150px', 'onblur'=>'habilitar_botones_req();','onfocus'=>'habilitar_botones_req(this.id);'));
                    $this->salida->cerrar_grupo_interno();                   
                    $this->salida->enviar('','celda_comun',array('tipo'=>'td'));
                    $this->salida->abrir_grupo_interno('celda_comun_salida_boton',array('tipo'=>'td', 'style'=>'width:200px;text-align:right'));                
                        $this->salida->enviar_boton('cambiar costo a:','req_input_boton',array('id'=>'cambiar_costo', 'name'=>'cambiar_costo','onclick'=>"boton_cambiar_atributo_req('costo');"));
                    $this->salida->cerrar_grupo_interno();
                    $this->salida->abrir_grupo_interno('celda_comun',array('tipo'=>'td', 'style'=>'text-align:left;vertical-align:bottom'));
                        $this->salida->enviar('','', array('id'=>'tra_nuevo_costo', 'name'=>'nuevo_costo', 'tipo'=>'input', 'style'=>'width:30px', 'onblur'=>'habilitar_botones_req();','onfocus'=>'habilitar_botones_req(this.id);'));
                    $this->salida->cerrar_grupo_interno();
                    $this->salida->abrir_grupo_interno('celda_comun_salida_boton',array('tipo'=>'td', 'style'=>'width:200px;text-align:right'));                
                        $this->salida->enviar_boton('Adjuntar archivo','req_input_boton',array('id'=>'adjuntar_arhivo', 'name'=>'adjuntar_archivo','onclick'=>"ir_a_url('siscen.php?hacer=upload&todo='+encodeURIComponent('{\"tra_proy\":\"".$this->argumentos->tra_proy."\",\"tra_req\":\"".$this->argumentos->tra_req."\"}'))"));
                    $this->salida->cerrar_grupo_interno();                   
                $this->salida->cerrar_grupo_interno();
            $this->salida->cerrar_grupo_interno();
        $this->salida->cerrar_grupo_interno();  
        $this->salida->cerrar_grupo_interno();           
        return $this->salida->obtener_una_respuesta_HTML();
    }
    function req_ficha_fila($valor, $nombre_campo, $clase='', $tipo='span'){
         $this->salida->abrir_grupo_interno('',array('tipo'=>'tr'));    
            $this->salida->enviar($nombre_campo,'celda_comun',array('tipo'=>'td','style'=>'width:175px;font-weight:bold'));
            $this->salida->abrir_grupo_interno('',array('tipo'=>'td'));    
                $this->salida->enviar($valor.'',$clase, array('tipo'=>$tipo, 'id'=>$nombre_campo));
            $this->salida->cerrar_grupo_interno(); 
            // $this->salida->enviar($valor.'',$clase, array('tipo'=>'td', 'id'=>$nombre_campo));
        $this->salida->cerrar_grupo_interno(); 
        return true;
    }
    function req_armador_input_boton($origen,$accion,$clase=''){
        $this->salida->abrir_grupo_interno('',array('tipo'=>'tr'));    
            $this->salida->abrir_grupo_interno('celda_comun_salida_boton',array('tipo'=>'td'));
                $this->salida->enviar_boton($accion,$clase,array('id'=>$accion, 'name'=>'boton_flujo','onclick'=>"boton_grabar_nov('".$origen."','".$accion."');", 'style'=>'width:100%'));
            $this->salida->cerrar_grupo_interno();
        $this->salida->cerrar_grupo_interno(); 
        return true;
    }
}
?>