<?php
//UTF-8:SÍ
$detenido=false;
if($detenido){
    echo "SISTEMA DETENIDO POR MANTENIMIENTO";
    return ;
}

$NOMBRE_APP='AJUS';
$nombre_app='ajus';

require_once "lo_imprescindible.php";
require_once "aplicaciones.php";
require_once "tabla_operativos.php";
require_once "metadatos_ajus.php";
require_once "probar_todo.php";
incluir_todo("../tedede");
incluir_todo("../encuestas");
incluir_todo("../ajus");

class Aplicacion_ajus extends Aplicacion{
    function __construct(){
        global $esta_es_la_base_en_produccion;
        parent::__construct();
        if($esta_es_la_base_en_produccion){
            $this->salida->html_title='EAJ'; //generalizar: 'AJUS'
        }
        $this->salida->agregar_css("ajus.css");
        $this->salida->agregar_css("../tedede/probador.css");
        $this->salida->agregar_js("../encuestas/encuestas.js");
        $this->salida->agregar_js("../tedede/editor.js");
        $this->salida->agregar_js("../tedede/para_grilla.js");
        $this->salida->agregar_js("../tercera/md5_paj.js");
        $this->salida->agregar_js("estructura_ajus.js");
    }
    function obtener_titulo(){
        return "Encuesta de Acceso a la Justicia";
    }
    function proceso_instalar(){
        return new Proceso_Generico(array(
            'titulo'=>'Instalar aplicación',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'mantenimiento',
            'funcion'=>function(Procesos $este){
                global $esta_es_la_base_en_produccion;
                $_SESSION["{$GLOBALS['NOMBRE_APP']}_ses"]=1;
                if($esta_es_la_base_en_produccion){
                    $este->db->beginTransaction();
                }
                probar_todo($este);
                foreach(array(
                    new Esquema_encu(),
                    new Esquema_dbo(),
                    new Tabla_tiempo_logico(),
                    new Tabla_operativos(),
                    new Tabla_http_user_agent(),
                    new Metadatos_ajus(),
                    new Tablas_planas(),
                    new Triggers_tem(),
                    new Metadatos_ajus2(),
                ) as $objeto_de_la_base)
                {
                    $este->salida->enviar('instalando '.get_class($objeto_de_la_base));
                    $objeto_de_la_base->contexto=$este;
                    $objeto_de_la_base->ejecutar_instalacion();
                }
                foreach(array('insercion_tabla_tem.sql',
                              'insercion_tabla_tem_20120420.sql',
                              'insercion_tabla_tem_ticket_501.sql',
                              'insercion_tabla_tem_ticket_508.sql',
                              'insercion_tabla_tem_ticket_511.sql',
                              //'insercion_tabla_tem_ticket_531.sql',
                              'insercion_tabla_roles.sql',
                              'insercion_tabla_usuarios.sql',
                              'insercion_tabla_rol_rol.sql',
                              'insercion_tabla_personal.sql',
                              'insercion_tabla_consistencias.sql',
                              'insercion_funcion_dbo_edad_jefe.sql',
                              'insercion_funcion_dbo_total_hogares.sql',
                              'insercion_funcion_dbo_estado_jefe.sql',
                              'insercion_funcion_dbo_existe_hogar.sql',
                              'insercion_funcion_dbo_existe_jefe.sql',
                              'insercion_funcion_dbo_existe_miembro.sql',
                              'insercion_funcion_dbo_nroconyuges.sql',
                              'insercion_funcion_dbo_nrojefes.sql',
                              'insercion_funcion_dbo_sexojefe.sql',
                              'insercion_funcion_dbo_es_fecha.sql',
                              'insercion_funcion_dbo_anio.sql',
                              'insercion_funcion_dbo_cantidad_de_miembros_tem.sql',
                              'insercion_funcion_dbo_cantidad_de_miembros_ingresados.sql',
                              'insercion_funcion_dbo_detectar_salto_en_hogares.sql',
                              'insercion_funcion_dbo_buscar_rea.sql',
                              ) as $archivo)
                {
                    $este->db->ejecutar_sql(new Sql(str_replace('/*CAMPOS_AUDITORIA*/',','.PRIMER_TLG,file_get_contents($archivo))));
                }
                $este->db->ejecutar_sql(new Sql("INSERT INTO encu.claves (cla_ope, cla_for, cla_mat, cla_enc, cla_tlg) SELECT '{$GLOBALS['NOMBRE_APP']}','TEM','',tem_enc,tem_tlg FROM encu.tem"));
                $estructura_encuesta = new Estructura_ajus();
                $estructura_encuesta->contexto=$este;
                $estructura_encuesta->generar_estructura();
                if($esta_es_la_base_en_produccion){
                    $este->db->commit();
                }
            }
        ));
    }
    function proceso_probar_todo(){
        return new Proceso_Generico(array(
            'titulo'=>'Correr casos de prueba sin instalar',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'mantenimiento',
            'funcion'=>function(Procesos $este){
                probar_todo($este);
            }
        ));
    }
    function proceso_desplegar_formulario($formulario='',$matriz=''){
        return new Proceso_Generico(array(
            'titulo'=>'Desplegar formulario '.$formulario.' '.$matriz,
            'permisos'=>null,
            'submenu'=>PROCESO_INTERNO,
            'funcion'=>function(Procesos $este) use ($formulario,$matriz){
                $tabla_matrices=new Tabla_matrices();
                $tabla_matrices->contexto=$este;
                if($formulario){
                    $filtro_pk=array($GLOBALS['NOMBRE_APP'],$formulario,$matriz);
                }else{
                    $filtro_pk=array(
                        $GLOBALS['NOMBRE_APP'],
                        $este->argumentos->tra_for,
                        $este->argumentos->tra_mat
                    );
                }
                $tabla_matrices->leer_pk($filtro_pk);
                $tabla_matrices->desplegar();
            }
        ));
        /* 
            http://localhost/yeah/ajus/ajus.php?hacer=desplegar_formulario&todo={"tra_ope":"AJUS","tra_for":"AJH1","tra_mat":""}
        */
    }
    function proceso_desplegar_tem(){
        return $this->proceso_desplegar_formulario('TEM');
    }
    function proceso_desplegar_ajh1(){
        return $this->proceso_desplegar_formulario('AJH1');
    }
    function proceso_desplegar_ajh1_m(){
        return $this->proceso_desplegar_formulario('AJH1','M');
    }
    function proceso_desplegar_aji1(){
        return $this->proceso_desplegar_formulario('AJI1');
    }
    function proceso_crear_nuevo_operativo(){
        return new Proceso_Formulario(array(
            'titulo'=>'crear operativo (prueba)',
            'submenu'=>'cosas para probar',
            'parametros'=>array(
                'ope_ope'=>array('label'=>'código del operativo abreviado','title'=>'tratar de que sea corto'),
                'ope_nombre'=>array('label'=>'nombre del operativo'),
            ),
            'boton'=>array('id'=>'crear'),
            'responder'=>function(Procesos $este){
                $tabla_operativos=new Tabla_operativos();
                $tabla_operativos->contexto=$este;
                $tabla_operativos->valores_para_insert=$este->argumentos;
                $tabla_operativos->valores_para_insert->ope_ope=strtoupper($este->argumentos->ope_ope);
                $este->db->ejecutar_sqls($tabla_operativos->sqls_insercion());
                // $rta='Anduvo bien y lo que se creo es '.var_export($este->argumentos,true);
                $rta='Anduvo bien y lo que se creo es '.$este->argumentos->ope_ope;
                return new Respuesta_Positiva($rta);
            }
        ));
    }
    
    function proceso_leer_formulario_a_localStorage(){
        return new Proceso_leer_formulario_a_localStorage();
    }
    function proceso_leer_encuesta_a_localStorage(){
        return new Proceso_leer_encuesta_a_localStorage();
    }
    function proceso_abrir_formulario(){
        return new Proceso_abrir_formulario();
    }
    function proceso_ingresar_encuesta(){
        return new Proceso_ingresar_encuesta();
    }
    function proceso_ingresar_tem(){
        return new Proceso_ingresar_tem();
    }
    function proceso_grabar_ud(){
        return new Proceso_grabar_ud();
    }
    function proceso_marcar_para_supervisar_general(){
        return new Proceso_marcar_para_supervisar_general();
    }
    function proceso_marcar_para_supervisar(){
        return new Proceso_marcar_para_supervisar();
    }
    function proceso_grilla_tabla_formulario(){
        return new Proceso_generico(array(
            'titulo'=>'Ver grilla tabla formularios',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'mantenimiento',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'tabla_formularios');
            }
        ));
    }
    function proceso_grilla_tabla_con_var(){
        return new Proceso_generico(array(
            'titulo'=>'Ver grilla tabla con_var',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'mantenimiento',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'tabla_con_var');
            }
        ));
    }
    function proceso_grilla_tabla_usuarios(){
        return new Proceso_generico(array(
            'titulo'=>'Ver grilla tabla usuarios',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'mantenimiento',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'tabla_usuarios');
            }
        ));
    }
    function proceso_grilla_tabla_saltos(){
        return new Proceso_generico(array(
            'titulo'=>'Ver grilla tabla saltos',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'mantenimiento',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'tabla_saltos');
            }
        ));
    }
    function proceso_grilla_TEM(){
        return new Proceso_generico(array(
            'titulo'=>'Ver grilla TEM',
            'permisos'=>array('grupo'=>'subcoor_campo'),
            'submenu'=>'mantenimiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'TEM');
            }
        ));
    }
    function proceso_grilla_control_ingreso(){
        return new Proceso_generico(array(
            'titulo'=>'Ver grilla control de ingreso',
            'permisos'=>array('grupo'=>'ingresador'),
            'submenu'=>'consistencias',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_control_ingreso');
            }
        ));
    }
    function proceso_grilla_control_muestra(){
        return new Proceso_generico(array(
            'titulo'=>'Ver grilla control de muestra (para enviar al muestrista)',
            'permisos'=>array('grupo'=>'ingresador'),
            'submenu'=>'consistencias',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_control_muestra');
            }
        ));
    }
    function proceso_grilla_variables_consistencias(){
        return new Proceso_generico(array(
            'titulo'=>'Ver grilla de variables y las consistencias donde aparecen',
            'permisos'=>array('grupo'=>'programadores'),
            'submenu'=>'consistencias',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_variables_consistencias');
            }
        ));
    }    
    function proceso_grilla_consistencias(){
        return new Proceso_generico(array(
            'titulo'=>'Ver grilla consistencias',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'consistencias',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'consistencias');
            }
        ));
    }
    function proceso_grilla_AJH1_M(){
        return new Proceso_generico(array(
            'titulo'=>'Ver grilla AJH1',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'mantenimiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'respuestas_AJH1_M');
            }
        ));
    }
    function proceso_grilla_up_para_supervision(){
        return new Proceso_generico(array(
            'titulo'=>'Resumen por UP (y algoritmo de supervisión)',
            'permisos'=>array('grupo'=>'mues_campo'),
            'submenu'=>'campo',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_up_para_supervision');
            }
        ));
    }
    function proceso_grilla_grupos_marcas_supervision(){
        return new Proceso_generico(array(
            'titulo'=>'Resumen de las corridas del algoritmos de supervisión',
            'permisos'=>array('grupo'=>'mues_campo'),
            'submenu'=>'campo',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_grupos_marcas_supervision');
            }
        ));
    }
    function proceso_formularios_de_la_vivienda(){
        return new Proceso_generico(array(
            'titulo'=>'Formularios de la vivienda',
            'permisos'=>null,
            'submenu'=>PROCESO_INTERNO,
            'funcion'=>function(Procesos $este){
                $este->salida->abrir_grupo_interno('cabezal_matriz');
                    $este->salida->enviar('Encuesta ','',array('tipo'=>'span'));
                    $este->salida->enviar('','',array('tipo'=>'span','id'=>'mostrar_enc'));
                    $este->salida->enviar(AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.'Formularios de la vivienda. ','',array('tipo'=>'span'));
                $este->salida->cerrar_grupo_interno();
                $este->salida->enviar_script("desplegar_formularios_de_la_vivienda();");
            }
        ));
    }
    function proceso_compilar_consistencia(){
        return new Proceso_compilar_consistencia();
    }
    function proceso_control_encuesta(){
        return new Proceso_control_encuesta();
    }
    function proceso_inconsistencias(){
        return new Proceso_generico(array(
            'titulo'=>'Listado de inconsistencias por encuesta',
            'permisos'=>array('grupo'=>'sup_ing'),
            'submenu'=>'ingreso',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_inconsistencias');
            }
        ));
    }
    function proceso_inconsistencias_por_bolsa(){
        return new Proceso_generico(array(
            'titulo'=>'Listado de inconsistencias por bolsa',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'ingreso',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_inconsistencias_por_bolsa');
            }
        ));
    }
    function proceso_grilla_tabla_inconsistencias(){
        return new Proceso_generico(array(
            'titulo'=>'Ver grilla tabla inconsistencias',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'mantenimiento',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'inconsistencias');
            }
        ));
    }
    function proceso_imprimir_remito(){
        return new Proceso_imprimir_remito();
    }
    function proceso_colorear_respuestas(){
        return new Proceso_colorear_respuestas();
    }
    function proceso_grilla_muestrista_no_realizadas(){    
        return new Proceso_generico(array(
            'titulo'=>'Ver grilla muestrista no realizadas',
            'permisos'=>array('grupo1'=>'mues_campo','grupo2'=>'procesamiento'),
            'submenu'=>'muestrista',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_muestrista_no_realizadas');
            }
        ));
    }
    function proceso_grilla_muestrista_miembros(){
        return new Proceso_generico(array(
            'titulo'=>'Ver grilla muestrista miembros',
            'permisos'=>array('grupo1'=>'mues_campo','grupo2'=>'procesamiento'),
            'submenu'=>'muestrista',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_muestrista_miembros');
            }
        ));
    }
}

Aplicacion::correr(new Aplicacion_ajus());
?>