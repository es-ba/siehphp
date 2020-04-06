<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";
//require_once "respuestas.php";

class Proceso_upload extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $tabla_proyectos=$this->nuevo_objeto("Tabla_proyectos");    
        $tabla_requerimientos=$this->nuevo_objeto("Tabla_requerimientos");                   
        $this->definir_parametros(array(   
            'titulo'=>'Subir archivo',
            'submenu'=>PROCESO_INTERNO,
            'html_title'=>"{tra_req}:{tra_proy}*{tra_req} Subir Adjunto al requerimiento",            
            'parametros'=>array(
                'tra_proy'=>array('label'=>'nombre del proyecto', 'opciones'=>$tabla_proyectos->lista_opciones(array()), 'pide_opciones'=>array('tra_req')),
                'tra_req'=>array('label'=>'código de requerimiento','opciones'=>$tabla_requerimientos->lista_opciones(array())),                
            ),
            'bitacora'=>true,
        ));
    }
    function correr(){
        $tra_proy=$this->argumentos->tra_proy;
        $tra_req =$this->argumentos->tra_req;
        $this->salida->abrir_grupo_interno('',array('tipo'=>'form', 'action'=>"{$GLOBALS['nombre_app']}.php",'method'=>'post','enctype'=>"multipart/form-data"));
            $this->salida->enviar("$tra_req:$tra_proy*$tra_req Subir Adjunto al requerimiento",'div_proceso_formulario_titulo',array('id'=>'div_proceso_formulario_titulo','name'=>'tit_adjunto'));      
            $this->salida->enviar('','',array('id'=>'post','type'=>'hidden','name'=>'post','tipo'=>'input','value'=>'upload'));
            $this->salida->enviar('','',array('id'=>'tra_proy','type'=>'hidden','name'=>'tra_proy','tipo'=>'input','value'=>$tra_proy));
            $this->salida->enviar('','',array('id'=>'tra_req','type'=>'hidden','name'=>'tra_req','tipo'=>'input','value'=>$tra_req));
            $this->salida->enviar('','',array('id'=>'tra_arch_local','type'=>'file','name'=>'tra_arch_local','tipo'=>'input' ,'onchange'=>"dispone_boton_upload();"));
            $this->salida->enviar('','div_proceso_formulario_boton',array('id'=>'boton_upload','name'=>'boton_upload','value'=>'Subir >>','type'=>'submit','tipo'=>'input', 'disabled'=> true, 'onclick'=>'validar_boton_upload();'/*,'style'=>'display:none' */));
            $this->salida->enviar_script(<<<JS
    function dispone_boton_upload(){
        "use strict";
        var archivo=elemento_existente('tra_arch_local');
        elemento_existente('boton_upload').disabled=!archivo.value;
    }
    
    function validar_boton_upload(){
        "use strict";
        var archivo=elemento_existente('tra_arch_local');
        if(!archivo.value){
            alert('Falta seleccionar archivo');
        }
    }
JS
        );    
        $this->salida->cerrar_grupo_interno();
    }
    function limpiarNombreArchivo($cadena){
        $tofind = "ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëÇçÌÍÎÏìíîïÙÚÛÜùúûüÿýÝÑñ· "; 
        $replac = "AAAAAAaaaaaaOOOOOOooooooEEEEeeeeCcIIIIiiiiUUUUuuuuyyYNn-_";
        //eliminar caracteres raros: ºª!|"@#$%&/()=?¿¡`^[+]*¨´{}<>,;.:~
        $cadena = utf8_decode($cadena);      
        $cadena = strtr($cadena, utf8_decode($tofind), $replac); 
        $cadena = str_replace(array("\\", "¨", "º", "ª", "~",
                                 "#", "@", "|", "!", "\"",
                                 "=", "$", "%", "&", "/",
                                 "(", ")", "?", "'", "¡",
                                 "¿", "[", "^", "`", "]",
                                 "+", "}", "{", "*", "´",
                                 ">", "<", ";", ",", ":",
                             ), '', $cadena);
        //$cadena = strtolower($cadena);  
        return utf8_encode($cadena); 
    }
    function agregar_nov_adjunto($proyecto, $req, $nomarchsubido,$nomarchorig){
        $tabla_reqnov=$this->nuevo_objeto("Tabla_req_nov");        
        $tabla_reqnov->contexto=$this;        
        $maxnov=0;
        $ultest='';
        $filtro_reqnov=array(
            'reqnov_proy' =>$proyecto,
            'reqnov_req'  =>$req,            
        );
        $tabla_reqnov->leer_varios($filtro_reqnov);
        while ($tabla_reqnov->obtener_leido()){
            if($tabla_reqnov->datos->reqnov_reqnov>$maxnov){    
                $maxnov=$tabla_reqnov->datos->reqnov_reqnov;
                $ultest=$tabla_reqnov->datos->reqnov_reqest;
            }
        }
        $maxnov++;
        $tabla_reqnov->valores_para_insert=(array(
            'reqnov_proy'      =>$proyecto,
            'reqnov_req'       =>$req,
            'reqnov_reqnov'    =>$maxnov,
            'reqnov_campo'     =>'adjunto',
            'reqnov_reqest'    =>$ultest,
            'reqnov_comentario'=>$nomarchsubido,            
            'reqnov_actual'    =>$nomarchorig,            
            'reqnov_tlg'       =>obtener_tiempo_logico($this),
        ));
        $tabla_reqnov->ejecutar_insercion();
        //return new Respuesta_Positiva('La novedad Adjunto fue ingresada con éxito');
        $this->salida->enviar('La novedad Adjunto fue ingresada con éxito');
    }
    function a_mensaje_error($codigoError){ 
        $mensaje='';
        switch ($codigoError) { 
            case UPLOAD_ERR_INI_SIZE: 
                $mensaje = "El archivo que intenta subir excede 'upload_max_filesize' en php.ini";
                break; 
            case UPLOAD_ERR_FORM_SIZE: 
                $mensaje = "El archivo que intenta subir excede 'MAX_FILE_SIZE' que fue especificada en el formulario HTML"; 
                break; 
            case UPLOAD_ERR_PARTIAL: 
                $mensaje = "El archivo subido fue sólo parcialmente cargado"; 
                break; 
            case UPLOAD_ERR_NO_FILE: 
                $mensaje = "Ningún archivo fue subido"; 
                break; 
            case UPLOAD_ERR_NO_TMP_DIR: 
                $mensaje = "Falta la carpeta temporal"; 
                break; 
            case UPLOAD_ERR_CANT_WRITE: 
                $mensaje = "No se pudo escribir el archivo en el disco"; 
                break; 
            case UPLOAD_ERR_EXTENSION: 
                $mensaje = "Una extensión de PHP detuvo la carga de archivos"; 
                break; 
            default: 
                $mensaje = "Error de Subida desconocido"; 
                break; 
        } 
        return $mensaje; 
    } 
    function tomar_post(){
        $tra_proy=$_POST['tra_proy'];
        $tra_req =$_POST['tra_req'];
        $this->salida->enviar("$tra_req:$tra_proy*$tra_req Subir Adjunto al requerimiento",'div_proceso_formulario_titulo',array('id'=>'div_proceso_formulario_titulo','name'=>'tit_adjunto'));      
        $this->salida->enviar('procesando el archivo subido...');
        //VALIDAR CONTRA LA BASE
        $tabla_requerimientos = new tabla_requerimientos();
        $tabla_requerimientos->contexto=$this;        
        $tabla_requerimientos->leer_uno_si_hay(array(
            'req_proy'=>$tra_proy,        
            'req_req'=>$tra_req,
        ));
        if(!$tabla_requerimientos->obtener_leido()){
            $this->salida->enviar('Error: No existe un requerimiento con ese código para el proyecto declarado');
        }else{
            //Loguear('2014-04-04','tra: ------------- proy'.var_export($tra_proy,true).' REQ'.var_export($tra_req,true));
            if(isset($_POST['boton_upload'])){
                global $esta_es_la_base_en_produccion;
                    // Archivos que no sean .exe, ni .dll 
                if (($_FILES['tra_arch_local']['type'] != "application/x-msdownload") 
                        // && ($_FILES['tra_arch_local']['size'] < 1000000) 
                   ){
                    //Si es que hubo un error en la subida, mostrarlo, de la variable $_FILES podemos extraer el valor de [error], que almacena un valor booleano (1 o 0).
                    if($_FILES['tra_arch_local']["error"] > 0) {
                         $mens=$this->a_mensaje_error($_FILES['tra_arch_local']["error"]);
                         $this->salida->enviar('Error:'. $mens);
                    }else{
                        // Si no hubo ningun error, hacemos otra condicion para asegurarnos que el archivo no sea repetido
                        $nombre_archivo_subida=$this->limpiarNombreArchivo($tra_proy .'_'. $tra_req . '_' .$_FILES['tra_arch_local']["name"]);
                        if (file_exists("docs/" . $nombre_archivo_subida)) {
                            $this->salida->enviar($nombre_archivo_subida . " ya existe. ");
                        }else{
                            // Si no es un archivo repetido y no hubo ningun error, procedemos a subir a la carpeta "docs"
                            move_uploaded_file($_FILES['tra_arch_local']["tmp_name"],
                                               "docs/" . $nombre_archivo_subida);
                            $this->salida->enviar($_FILES['tra_arch_local']["name"].' Archivo Subido como '.$nombre_archivo_subida);
                            $this->agregar_nov_adjunto($tra_proy, $tra_req, $nombre_archivo_subida,$_FILES['tra_arch_local']["name"]);
                            $this->salida->enviar('redireccionando en 3 segs...');
                            $parametros_js=json_encode(array('tra_proy'=>$tra_proy, 'tra_req'=>$tra_req));
                            $this->salida->enviar_script(<<<JS
                                setTimeout(function(){ 
                                     ir_a_url('siscen.php?hacer=agregar_novedades_req&todo='+encodeURIComponent('{$parametros_js}')+'&y_luego=buscar')
                                },3000);
JS
                            );        
                        }
                    }
                }else{
                        // Si el usuario intenta subir algo que no cumple nuestra condicion
                        $this->salida->enviar("Archivo a subir tiene tipo de archivo no permitido para subir");
                }
            }
        }
    }
}
?>