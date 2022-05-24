<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_hoja_de_ruta extends Proceso_Generico{
    function __construct($parametros=array()){
        $para_supervisor=!!@$parametros['para_supervisor'];
        $parametros_proceso=array(
            'titulo'=>'Hoja de ruta',
            'permisos'=>null,
            'submenu'=>PROCESO_INTERNO,
            'html_title'=>$para_supervisor?'SUPERVISOR':$GLOBALS['titulo_corto_app'],
            // 'cookies'=>array('para_supervisor'=>'0'),
            'funcion'=>function(Procesos $este) use ($para_supervisor){
                $este->salida->abrir_grupo_interno('cabezal_matriz',array('id'=>'encabezado_pagina'));
                    $este->salida->enviar('Carga ','',array('tipo'=>'span'));
                    $este->salida->enviar('','',array('tipo'=>'span','id'=>'mostrar_carga'));
                    $este->salida->enviar(AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP,'',array('tipo'=>'span'));
                    $este->salida->enviar('Persona','',array('tipo'=>'span','id'=>'nombre_rol_hdr'));
                    $este->salida->enviar(' ','',array('tipo'=>'span'));
                    $este->salida->enviar('','',array('tipo'=>'span','id'=>'mostrar_encuestador'));
                    $este->salida->enviar(AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.($para_supervisor?' hoja de ruta Supervisor':'HOJA DE RUTA').' v 3.04b  '.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP,'',array('tipo'=>'span', 'id'=>'hdr_version'));
                    $este->salida->enviar('','',array(
                        'tipo'=>'input',
                        'id'=>'clave_recepcionista',
                        'type'=>'tel', 
                        'style'=>'width:50px',
                        'onblur'=>"if(this.value==1234){ ir_a_url(location.pathname+'?hacer=cargar_dispositivo'); this.value=null};if(this.value==753){ controlar_offline(); this.value=null};",
                    ));
                $este->salida->cerrar_grupo_interno();
                $renglon_para_supervisor='localStorage["para_supervisor"]=para_supervisor='.($para_supervisor?'1':'0');
                $este->salida->enviar_script(<<<JS
                    window.addEventListener('load',function(){
                        $renglon_para_supervisor;
                        setTimeout(function(){
                            mostrar_advertencia_descargado();
                            desplegar_hoja_de_ruta();
                        },0);
                    });

JS
                );
            }
        );
        if($para_supervisor){
            $parametros_proceso['icon_app']="../{$GLOBALS['nombre_app']}/{$GLOBALS['nombre_app']}_icon_super.png";
            // $parametros_proceso['cookies']=$parametros['cookies'];
        }
        parent::__construct($parametros_proceso);
    }
}

class Proceso_hoja_de_ruta_super extends Proceso_hoja_de_ruta{
    function __construct(){
        parent::__construct(array(
            // 'cookies'=>array('para_supervisor'=>'1'),
            'para_supervisor'=>true,
        ));
    }
}
?>