<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_formularios_de_la_vivienda extends Proceso_generico{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $tabla_personal=$this->nuevo_objeto("Tabla_personal");
        $tabla_personal->leer_uno_si_hay(array('per_usu'=>usuario_actual()));
        if($tabla_personal->obtener_leido()){
            if($tabla_personal->datos->per_rol=='recepcionista'){
                $this->salida->enviar_script(<<<JS
                
                    window.addEventListener('load',function(){
                        es_un_recepcionista=true;                        
                    });
JS
                );
            }            
        }
        if (tiene_rol('ing_sup')){
                $this->salida->enviar_script(<<<JS
                
                    window.addEventListener('load',function(){
                        es_ing_sup=true;                        
                    });
JS
                );
        }
        if(tiene_rol('subcoor_campo')||tiene_rol('procesamiento')||$GLOBALS['nombre_app']=='etoi143'){
            $this->salida->enviar_script(<<<JS
            
                window.addEventListener('load',function(){
                    puede_ver_todos_los_formularios=true;
                });
JS
            );
        }
        $tabla_roles=$this->nuevo_objeto("Tabla_roles");
        $this->definir_parametros(array(
            'titulo'=>'Formularios de la vivienda',
            'permisos'=>null,
            'submenu'=>PROCESO_INTERNO,
            'funcion'=>function(Procesos $este){
                $este->salida->abrir_grupo_interno('cabezal_matriz',array('id'=>'encabezado_pagina'));
                    $este->salida->enviar('Encuesta ','',array('tipo'=>'span'));
                    $este->salida->enviar('','',array('tipo'=>'span','id'=>'mostrar_enc'));
                    $este->salida->enviar(AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.'resumen de sus formularios ','',array('tipo'=>'div'));
                    $este->salida->enviar('','',array('tipo'=>'div','id'=>'direccion'));
                    $este->salida->enviar('','',array('tipo'=>'span','id'=>'lote'));
                    $este->salida->enviar('','',array('tipo'=>'span','id'=>'participacion'));
                    $este->salida->enviar('','',array('tipo'=>'span','id'=>'periodicidad'));
                    $este->salida->enviar('','',array('tipo'=>'span','id'=>'ident_edif'));
                $este->salida->cerrar_grupo_interno();
                $este->salida->enviar('','',array('tipo'=>'div','id'=>'grilla_visitas'));
                $este->salida->enviar('','',array('tipo'=>'div','id'=>'anoenc'));
                if($GLOBALS['nombre_app']=='etoi143'){
                    $este->salida->enviar_script(<<<JS
                    
                        window.addEventListener('load',function(){
                            puede_ver_todos_los_formularios=true;
                        });

JS
                    );
                }
                $este->salida->enviar_script(<<<JS
                    window.addEventListener('load',function(){
                        mostrar_advertencia_descargado();  
                        desplegar_visitas_de_la_vivienda();
                        desplegar_formularios_de_la_vivienda(); 
                    });
                    
JS
                );
            }
        ));
    }
}

?>