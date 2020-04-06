<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
// require_once "proceso_setear_modo_encuesta.php";
//global $modo_encuesta;

class Proceso_bienvenida extends Proceso_Generico{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'bienvenida',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                global $soy_un_ipad,$esta_es_la_base_en_produccion;
                $este->salida->enviar(
                    'Pantalla de entrada al sistema '.
                        ($esta_es_la_base_en_produccion?'en producción':'').
                        ' de '.$GLOBALS['titulo_corto_app'],
                    '',
                    array('tipo'=>'h2')
                );
                if($_SESSION["{$GLOBALS['NOMBRE_APP']}_usu_blanquear_clave"]){
                    $este->salida->abrir_grupo_interno();
                        $este->salida->enviar('debe ','',array('tipo'=>'span'));
                        $este->salida->enviar_link('cambiar la clave de acceso','',$GLOBALS['nombre_app'].'.php?hacer=cambio_de_clave');
                        $este->salida->enviar(' (porque posee una provisoria)','',array('tipo'=>'span'));
                    $este->salida->cerrar_grupo_interno();
                }else{
                    if($soy_un_ipad){
                        $este->salida->abrir_grupo_interno();
                        if(strpos($GLOBALS['HTTP_USER_AGENT'],'Safari')>0 || @$_REQUEST['Safari']){
                            $este->salida->enviar_link('Presentar a la hoja de ruta del encuestador/recuperador','',$GLOBALS['nombre_app'].'.php?hacer=hoja_de_ruta');
                            $este->salida->enviar('','',array('tipo'=>'br'));
                            $este->salida->enviar_link('Presentar a la hoja de ruta del supervisor','',$GLOBALS['nombre_app'].'.php?hacer=hoja_de_ruta_super');
                        }else{
                            $este->salida->enviar_link('Ir a la hoja de ruta','',$GLOBALS['nombre_app'].'.php?hacer=hoja_de_ruta');
                        }
                        $este->salida->cerrar_grupo_interno();
                        $este->salida->enviar('','',array('tipo'=>'hr'));
                    }else{
                        if((tiene_rol('programador')|| tiene_rol('procesamiento')) && substr($GLOBALS['nombre_app'],0,3)=='eah' && $GLOBALS['anio_operativo']>=2015){
                            // $este->salida->enviar('completo','',array('tipo'=>'div','id'=>'modo'));
                            // $este->salida->enviar(array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'elegido','id'=>'chequeo'));
                            $este->salida->enviar_boton('Modo_completo','modo_completo',array('id'=>'boton_modo_completo','onclick'=>'enviar_modo_encuesta(true)'));//o llamar a función q setee el modo
                            $este->salida->enviar_boton('Modo_ETOI','modo_etoi',array('id'=>'boton_modo_etoi','onclick'=>'enviar_modo_encuesta(false)'));
                            $este->salida->enviar_script(<<<JS
function enviar_modo_encuesta(es_completo){
"use strict";
    var ok_esta=true;
    var vmodo;
    vmodo= es_completo?'Completo':'ETOI';  
    enviar_paquete({
        proceso:'setear_modo_encuesta',
        paquete:{pmodoenc:vmodo},
        cuando_ok:function(datos){
            ok_esta=true;
            ir_a_url(location.pathname+"?hacer=menu");
        },
        cuando_error:function(mensaje){
            ok_esta=false;
            console.log('error al setear modo encuesta' );
        },
        asincronico:false
    });

}                            

JS
                            );
                        }else{
                            $este->salida->abrir_grupo_interno();
                            $este->salida->enviar_link('Ir al menú principal','',$GLOBALS['nombre_app'].'.php?hacer=menu');
                            $este->salida->cerrar_grupo_interno();
                        }
                    }
                    $este->salida->abrir_grupo_interno();
                        if(isset($_SESSION['ir_despues_de_loguearse '.$GLOBALS['nombre_app']])){
                            $este->salida->enviar_link((termina_con($_SESSION['ir_despues_de_loguearse '.$GLOBALS['nombre_app']],'cargar_dispositivo')?'Ir a CARGAR DISPOSITIVO':'Ir al sitio donde estaba antes'),'',$_SESSION['ir_despues_de_loguearse '.$GLOBALS['nombre_app']]);
                        }
                    $este->salida->cerrar_grupo_interno();
                }
            }
        ));
    }
}

?>
