<?php
//UTF-8:SÍ
//V 1.06c
$detenido=true;
//$detenido=$_SERVER['REMOTE_ADDR']!='10.30.1.153' && $_SERVER['REMOTE_ADDR']!='10.30.1.207' && $_SERVER['REMOTE_ADDR']!='10.30.1.7' && $_SERVER['REMOTE_ADDR']!='localhost' && $_SERVER['REMOTE_ADDR'];
if($detenido){
    echo "SISTEMA MUDADO A <a href='http://10.30.1.7/eah2012/eah2012/eah2012.php'>http://10.30.1.7/eah2012/eah2012/eah2012.php</a>";
    return ;
}
$NOMBRE_APP='pp2012';
$nombre_app='pp2012';

require_once "lo_imprescindible.php";
require_once "aplicaciones.php";
require_once "tabla_operativos.php";
require_once "metadatos_pp2012.php";
require_once "todos_los_php.php";
incluir_todo("../tedede");
incluir_todo("../encuestas");
incluir_todo("../pp2012");
require_once "probar_todo.php";

$soy_un_ipad=strpos($_SERVER["HTTP_USER_AGENT"],'iPad')>0 || strpos($_SERVER["HTTP_USER_AGENT"],'Safari')>0 && strpos($_SERVER["HTTP_USER_AGENT"],'Chrome')===false;

class Aplicacion_pp2012 extends Aplicacion{
    function __construct(){
        global $esta_es_la_base_en_produccion,$soy_un_ipad;
        parent::__construct();
        if($esta_es_la_base_en_produccion){
            $this->salida->html_title="pp2012 - Prueba piloto de la EAH2012";
            $this->salida->color_fondo='#FEA';
        }else{
            $this->salida->html_title="TEST - pp2012";
            $this->salida->color_fondo='#BDF';
        }
        if($soy_un_ipad){
            $ver_offline=array();
            // /*
            $ver_offline=array(
                'hoja_de_ruta'=>true, 
                'formularios_de_la_vivienda'=>true, 
                'desplegar_formulario'=>true
            );
            // */
            if(isset($_REQUEST['hacer'])&&isset($ver_offline[$_REQUEST['hacer']])){
                // $this->salida->manifiesto="pp2012.manifest.php";
                $this->salida->manifiesto="pp2012.manifest";
            }
        }
        $this->salida->agregar_css("{$GLOBALS['nombre_app']}.css");
        $this->salida->agregar_css("../tedede/probador.css");
        $this->salida->agregar_js("../encuestas/encuestas.js");
        $this->salida->agregar_js("../tedede/editor.js");
        $this->salida->agregar_js("../tedede/para_grilla.js");
        $this->salida->agregar_js("../tercera/md5_paj.js");
        $this->salida->agregar_js("estructura_{$GLOBALS['nombre_app']}.js");
    }
    function mostrar_titulo($proceso=false){
        global $soy_un_ipad;
        $destino_principal=$GLOBALS['nombre_app'].'.php';
        if($soy_un_ipad){
            $destino_principal.="?hacer=hoja_de_ruta";
        }
        $this->salida->abrir_grupo_interno('',array('tipo'=>'a','href'=>$destino_principal,'id'=>'logo_principal'));
            $this->salida->enviar_imagen('logo_prototipo.png','logo_principal no_imprimir');
        $this->salida->cerrar_grupo_interno();
    }
    function obtener_titulo(){
        return "Prueba Piloto EAH2012";
    }
    function probar_aplicacion(){
    }
    function proceso_instalar(){
        return new Proceso_Generico(array(
            'titulo'=>'Instalar aplicación',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'mantenimiento',
            'funcion'=>function(Procesos $este){
                try{
                    global $esta_es_la_base_en_produccion;
                    $_SESSION["{$GLOBALS['NOMBRE_APP']}_ses"]=1;
                    if($esta_es_la_base_en_produccion){
                        $este->db->beginTransaction();
                    }
                    $este->salida->abrir_grupo_interno('',array('id'=>'resultado_instalando'));
                        $este->salida->enviar('instalando ','instalando');
                        $este->salida->enviar_imagen('mini_loading.gif');
                    $este->salida->cerrar_grupo_interno();
                    $este->salida->abrir_grupo_interno('',array('id'=>'resultado_ok','style'=>'display:none'));
                        $este->salida->enviar('instalado ','instalando');
                        $este->salida->enviar_imagen('mini_confirmado.png');
                    $este->salida->cerrar_grupo_interno();
                    $este->salida->abrir_grupo_interno('',array('id'=>'resultado_error','style'=>'display:none'));
                        $este->salida->enviar('falló la instalación ','instalando');
                        $este->salida->enviar_imagen('mini_Error.png');
                    $este->salida->cerrar_grupo_interno();
                    $este->salida->enviar_script(<<<JS
                        var resultado_instalacion=false;
                        window.addEventListener('load', function(e) {
                            var elemento_resultado=elemento_existente(resultado_instalacion?'resultado_ok':'resultado_error');
                            elemento_resultado.style.display='block';
                            elemento_existente('resultado_instalando').style.display='none';
                        });

JS
                    );
                    probar_todo($este,array('../encuesta/casos_prueba_encuesta.js'));
                    foreach(array(
                        new Esquema_encu(),
                        new Esquema_dbo(),
                        new Tabla_tiempo_logico(),
                        new Tabla_operativos(),
                        new Tabla_http_user_agent(),
                        new Metadatos_pp2012(),
                        new Tablas_planas(),
                        new Triggers_tem(),
                    ) as $objeto_de_la_base)
                    {
                        $este->salida->enviar('instalando '.get_class($objeto_de_la_base));
                        $objeto_de_la_base->contexto=$este;
                        $objeto_de_la_base->ejecutar_instalacion();
                    }
                    foreach(array('insercion_tabla_tem.sql',
                                  'insercion_tabla_roles.sql',
                                  'insercion_tabla_usuarios.sql',
                                  'insercion_tabla_rol_rol.sql',
                                  '..\operaciones_pp2012\insercion_tabla_personal.sql',
                                  //'..\operaciones_pp2012\insertar_estados_ingreso_consistencias.sql',
                                  'insercion_tabla_consistencias.sql',  
                                  'vista_var_orden.sql',
                                   ) as $archivo)
                    {
                        $este->db->ejecutar_sql(new Sql(str_replace(array('/*CAMPOS_AUDITORIA*/',"'AJUS',"),array(','.PRIMER_TLG,"'pp2012',"),file_get_contents($archivo))));
                    }
                    $consistencias=explode("INSERT INTO consistencias",file_get_contents("../operaciones_pp2012/consistencias_pp2012.sql"));
                    array_shift($consistencias); // descarto las primeas instrucciones del dump;
                    foreach($consistencias as $cada_consistencia) {
                        $este->db->ejecutar_sql(new Sql("insert into encu.consistencias".preg_replace("/, [0-9]+\);/",",1);",$cada_consistencia)));
                    }
                    $funciones_dbo=explode("/*otra*/",file_get_contents("funciones_dbo.sql"));
                    foreach($funciones_dbo as $cada_funcion) {
                        $este->db->ejecutar_sql(new Sql($cada_funcion));
                    }
                    $este->db->ejecutar_sql(new Sql("INSERT INTO encu.claves (cla_ope, cla_for, cla_mat, cla_enc, cla_tlg) SELECT '{$GLOBALS['NOMBRE_APP']}','TEM','',tem_enc,tem_tlg FROM encu.tem"));
                    
                    $estructura_encuesta = new Estructura_pp2012();
                    $estructura_encuesta->contexto=$este;
                    $estructura_encuesta->generar_estructura();
                    if($esta_es_la_base_en_produccion){
                        $este->db->commit();
                    }
                }catch(Exception $e){
                    $este->salida->enviar_boton('algo anduvo mal','mensaje_error',array('autofocus'=>true,'id'=>'aviso_mal','onclick'=>'centrar_en_vertical(this)'));
                    $este->salida->enviar_script("window.onload = function(e){centrar_en_vertical(elemento_existente('aviso_mal'));};");
                    throw $e;
                }
                $este->salida->enviar_boton('sin excepciones durante la intalación. Mirar arriba los casos de prueba','',array('onclick'=>'centrar_en_vertical(this)'));
                $este->salida->enviar_script(<<<JS
                    resultado_instalacion=true;
JS
                );
            }
        ));
    }
    function proceso_probar_todo(){
        return new Proceso_Generico(array(
            'titulo'=>'Correr casos de prueba sin instalar',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'mantenimiento',
            'funcion'=>function(Procesos $este){
                probar_todo($este,array('../encuesta/casos_prueba_encuesta.js'));
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
            http://localhost/yeah/pp2012/pp2012.php?hacer=desplegar_formulario&todo={"tra_ope":"pp2012","tra_for":"AJH1","tra_mat":""}
        */
    }
    function proceso_desplegar_tem(){
        return $this->proceso_desplegar_formulario('TEM');
    }
    function proceso_desplegar_s1(){
        return $this->proceso_desplegar_formulario('S1');
    }
    function proceso_desplegar_a1(){
        return $this->proceso_desplegar_formulario('A1');
    }
    function proceso_desplegar_s1_p(){
        return $this->proceso_desplegar_formulario('S1','P');
    }
    function proceso_desplegar_i1(){
        return $this->proceso_desplegar_formulario('I1');
    }
    function proceso_leer_formulario_a_localStorage(){
        return new Proceso_leer_formulario_a_localStorage();
    }
    function proceso_leer_encuesta_a_localStorage(){
        return new Proceso_leer_encuesta_a_localStorage();
    }
    function proceso_ingresar_encuesta(){
        return new Proceso_ingresar_encuesta();
    }
    function proceso_cargar_dispositivo(){
        return new Proceso_cargar_dispositivo();
    }
    function proceso_fin_descargar_dispositivo(){
        return new Proceso_fin_descargar_dispositivo();
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
            'titulo'=>'Tabla formularios',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'mantenimiento',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'tabla_formularios');
            }
        ));
    }
    function proceso_grilla_bloques(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla bloques',
            'permisos'=>array('grupo'=>'subcoor_campo'),
            'para_produccion'=>true,
            'submenu'=>'metadatos',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'bloques', array('blo_ope'=>$GLOBALS['NOMBRE_APP']));
            }
        ));
    }    
    function proceso_grilla_preguntas(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla preguntas',
            'permisos'=>array('grupo'=>'subcoor_campo'),
            'para_produccion'=>true,
            'submenu'=>'metadatos',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'preguntas', array('pre_ope'=>$GLOBALS['NOMBRE_APP']));
            }
        ));
    }
    function proceso_grilla_variables(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla variables',
            'permisos'=>array('grupo'=>'subcoor_campo','grupo'=>'procesamiento'),
            'para_produccion'=>true,
            'submenu'=>'metadatos',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'variables', array('var_ope'=>$GLOBALS['NOMBRE_APP']));
            }
        ));
    }
    function proceso_grilla_opciones(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla opciones',
            'permisos'=>array('grupo'=>'subcoor_campo'),
            'para_produccion'=>true,
            'submenu'=>'metadatos',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'opciones', array('opc_ope'=>$GLOBALS['NOMBRE_APP']));
            }
        ));
    }
    function proceso_grilla_tabla_con_var(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla con_var',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'mantenimiento',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'tabla_con_var');
            }
        ));
    }
    function proceso_grilla_tabla_usuarios(){
        return new Proceso_generico(array(
            'titulo'=>'usuarios',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'administración',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'tabla_usuarios');
            }
        ));
    }
    function proceso_grilla_tabla_saltos(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla saltos',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'mantenimiento',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'tabla_saltos');
            }
        ));
    }
    function proceso_grilla_TEM(){
        return new Proceso_generico(array(
            'titulo'=>'Planilla de Recepción (sistema anterior)',
            'permisos'=>array(),
            'submenu'=>'campo',
            'para_produccion'=>false,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'TEM');
            }
        ));
    }
    function proceso_visor_encuestas(){
        return new Proceso_generico(array(
            'titulo'=>'Visor de encuesta',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                mostrar_visor($este);
            }
        ));
    }
    function proceso_planilla_carga(){
        return new Proceso_generico(array(
            'titulo'=>'Planilla de carga',
            'permisos'=>array('grupo'=>'recepcionista'),
            'submenu'=>'recepcionista',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                mostrar_planilla_carga($este);
            }
        ));
    }
    function proceso_planilla_recepcion(){
        return new Proceso_generico(array(
            'titulo'=>'Planilla de recepción',
            'permisos'=>array('grupo'=>'recepcionista'),
            'submenu'=>'recepcionista',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                mostrar_planilla_recepcion($este);
            }
        ));
    }
    function proceso_confirmar_salida_campo_papel(){
        return new Proceso_confirmar_salida_campo_papel();
    }
    function proceso_grilla_control_ingreso(){
        return new Proceso_generico(array(
            'titulo'=>'Control de ingreso',
            'permisos'=>array('grupo'=>'sup_ing'),
            'submenu'=>'ingreso',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_control_ingreso');
            }
        ));
    }
    function proceso_grilla_control_muestra(){
        return new Proceso_generico(array(
            'titulo'=>'Control de muestra',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'muestrista',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_control_muestra');
            }
        ));
    }
    function proceso_grilla_variables_consistencias(){
        return new Proceso_generico(array(
            'titulo'=>'Variables',
            'permisos'=>array(),
            'submenu'=>'consistencias',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_variables_consistencias');
            }
        ));
    }    
    function proceso_grilla_consistencias(){
        return new Proceso_generico(array(
            'titulo'=>'Consistencias',
            'permisos'=>array(),
            'submenu'=>'consistencias',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'consistencias',array('con_ope'=>$GLOBALS['NOMBRE_APP']),false,array('filtro_manual'=>array('con_tipo'=>'#=Conceptual| =Revisar')));
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
    function proceso_bienvenida(){
        return new Proceso_generico(array(
            'titulo'=>'bienvenida',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                $este->salida->enviar('Pantalla de entrada al sistema en producción de la EAH','',array('tipo'=>'h2'));
                $este->salida->abrir_grupo_interno();
                    $este->salida->enviar('Ir al menú principal','',array('tipo'=>'a','href'=>$GLOBALS['nombre_app'].'.php?hacer=menu'));
                $este->salida->cerrar_grupo_interno();
                $este->salida->abrir_grupo_interno();
                    if(isset($_SESSION['ir_despues_de_loguearse'])){
                        $este->salida->enviar('Ir al sitio donde estaba antes','',array('tipo'=>'a','href'=>$_SESSION['ir_despues_de_loguearse']));
                    }
                $este->salida->cerrar_grupo_interno();
            }
        ));
    }
    function proceso_aviso_offline(){
        return new Proceso_generico(array(
            'titulo'=>'aviso offline',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                $este->salida->enviar('El sistema está fuera de línea, no se puede realizar esa operación');
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
                    $este->salida->enviar(AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.'resumen de sus formularios ','',array('tipo'=>'div'));
                    $este->salida->enviar('','',array('tipo'=>'div','id'=>'direccion'));
                    $este->salida->enviar('','',array('tipo'=>'span','id'=>'lote'));
                $este->salida->cerrar_grupo_interno();
                $este->salida->enviar('','',array('tipo'=>'div','id'=>'grilla_visitas'));
                $este->salida->enviar_script(<<<JS
                    window.onload=function(){
                        mostrar_advertencia_descargado();
                        desplegar_visitas_de_la_vivienda();
                        desplegar_formularios_de_la_vivienda();
                        window.document.title='prueba';
                    }
                    
JS
                );
            }
        ));
    }
    function proceso_hoja_de_ruta(){
        return new Proceso_generico(array(
            'titulo'=>'Hoja de ruta',
            'permisos'=>null,
            'submenu'=>PROCESO_INTERNO,
            'funcion'=>function(Procesos $este){
                $este->salida->abrir_grupo_interno('cabezal_matriz');
                    $este->salida->enviar('Carga ','',array('tipo'=>'span'));
                    $este->salida->enviar('','',array('tipo'=>'span','id'=>'mostrar_carga'));
                    $este->salida->enviar(AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.'Encuestador ','',array('tipo'=>'span'));
                    $este->salida->enviar('','',array('tipo'=>'span','id'=>'mostrar_encuestador'));
                    $este->salida->enviar(AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.'HOJA DE RUTA V 1.06c '.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP,'',array('tipo'=>'span'));
                    $este->salida->enviar('','',array(
                        'tipo'=>'input',
                        'id'=>'clave_recepcionista',
                        'style'=>'width:50px',
                        'onblur'=>"if(this.value==1234){ ir_a_url(location.pathname+'?hacer=cargar_dispositivo'); this.value=null};if(this.value==753){ controlar_offline(); this.value=null};",
                    ));
                $este->salida->cerrar_grupo_interno();
                $este->salida->enviar_script(<<<JS
                    window.onload=function(){
                        mostrar_advertencia_descargado();
                        desplegar_hoja_de_ruta();
                    }

JS
                );
            }
        ));
    }
    function proceso_compilar_consistencia(){
        return new Proceso_compilar_consistencia();
    }
    function proceso_controlar_estado_carga(){
        return new Proceso_controlar_estado_carga();
    }
    function proceso_control_encuesta(){
        return new Proceso_control_encuesta();
    }
    function proceso_asignar_resto_lote_a_persona(){
        return new Proceso_asignar_resto_lote_a_persona();
    }
    function proceso_mandar_nueva_clave(){
        return new Proceso_mandar_nueva_clave();
    }
    function proceso_inconsistencias(){
        return new Proceso_generico(array(
            'titulo'=>'Listado de inconsistencias por encuesta',
            'permisos'=>array(),
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
            'titulo'=>'Tabla inconsistencias',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,            
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
            'titulo'=>'Viviendas no realizadas',
            'permisos'=>array(),
            'submenu'=>'muestrista',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_muestrista_no_realizadas');
            }
        ));
    }
    function proceso_grilla_muestrista_miembros(){
        return new Proceso_generico(array(
            'titulo'=>'Miembros de viviendas realizadas',
            'permisos'=>array(),
            'submenu'=>'muestrista',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_muestrista_miembros');
            }
        ));
    }
    function proceso_mis_datos_personales(){
        return new Proceso_generico(array(
            'titulo'=>'Mis datos personales',
            'permisos'=>array(),
            'submenu'=>'usuarios',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'tabla_usuarios',array('usu_usu'=>$_SESSION["{$GLOBALS['NOMBRE_APP']}_usu_usu"]),false,array('simple'=>'true'));
                $este->salida->enviar('Verifique que su dirección de correo electrónico sea correcta. Se usará este correo para enviarle una nueva clave en caso de que se la olvide.','celda_comun',array('style'=>'max-width:inherit'));
            }
        ));
    }
    function proceso_grilla_excepciones(){
        return new Proceso_generico(array(
            'titulo'=>'Registro de excepciones',
            'para_produccion'=>true,
            'submenu'=>'campo',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'excepciones', array('exc_ope'=>$GLOBALS['NOMBRE_APP']));
            }
        ));
    }
}

if(!isset($no_ejecutar_aplicacion)){
    Aplicacion::correr(new Aplicacion_pp2012());
}
?>