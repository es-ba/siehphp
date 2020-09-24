<?php
//UTF-8:SÍ
//v 3.00

$NOMBRE_APP='same2013';
$nombre_app='same2013';
$GLOBALS['esquema_principal']='encu';

require_once "lo_imprescindible.php";
require_once "aplicaciones.php";
require_once "tabla_operativos.php";
require_once "metadatos_same2013.php";
require_once "todos_los_php.php";
incluir_todo("../tedede");
incluir_todo("../encuestas");
incluir_todo("../same2013");

class Aplicacion_same2013 extends Aplicacion_encuesta{
    function __construct(){
        global $esta_es_la_base_en_produccion,$soy_un_ipad;
        $this->ver_offline=array(
            'hoja_de_ruta'=>true, 
            'formularios_de_la_vivienda'=>true, 
            'desplegar_formulario'=>true
        );
        parent::__construct();
        if($esta_es_la_base_en_produccion){
            $this->salida->html_title="same2013";
        }else{
            $this->salida->html_title="TEST - same2013";
        }
        $this->salida->color_fondo=(@$GLOBALS['color_de_fondo_de_la_aplicacion'])?:'#AEE';
        if($soy_un_ipad){
            if(isset($_REQUEST['hacer'])&&isset($this->ver_offline[$_REQUEST['hacer']])){
                $this->salida->manifiesto="same2013.manifest";
            }
        }
        $this->salida->agregar_css("{$GLOBALS['nombre_app']}.css");
        $this->salida->agregar_css("../tedede/probador.css");
        $this->salida->agregar_js("../encuestas/encuestas.js");
        $this->salida->agregar_js("../tedede/editor.js");
        $this->salida->agregar_js("../tedede/para_grilla.js");
        $this->salida->agregar_js("../tercera/md5_paj.js");
        $this->salida->agregar_js("../encuestas/encu_especiales.js");
        $this->salida->agregar_js("estructura_{$GLOBALS['nombre_app']}.js");
        $this->salida->agregar_js('dbo_same.js');
    }
    function mostrar_titulo($proceso=false){        
        global $soy_un_ipad;
        $destino_principal=$GLOBALS['nombre_app'].'.php';
        if($soy_un_ipad){
            $destino_principal.="?hacer=hoja_de_ruta";
        }else{
            $mensaje_encabezado='';
            if(usuario_actual() && !$soy_un_ipad){
                $mensaje_encabezado.='Usuario: '.$_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_usu_usu"].' ';                
            }
            $ip_cliente=$_SERVER['REMOTE_ADDR'];
            $ip_servidor=$_SERVER['SERVER_ADDR'];
            //$ip_servidor='173.10.3.2'; PARA PROBAR SI ES DISTINTO
            $diferencia_ips=diferencia_ips($ip_servidor,$ip_cliente);
            if($diferencia_ips!=''){
                $mensaje_encabezado.='IP: '.$diferencia_ips;
            }
            $this->salida->enviar($mensaje_encabezado,'div_proceso_formulario_usuario_ip');
        }
        $this->salida->abrir_grupo_link('',$destino_principal/*,array('id'=>'logo_principal')*/);
            $this->salida->enviar_imagen("../{$GLOBALS['nombre_app']}/logo_app.png",'logo_principal no_imprimir');
        $this->salida->cerrar_grupo_interno();
    }
    function obtener_titulo(){
        return "Prueba Piloto same2013";
    }
    function probar_aplicacion(){
    }
    static function salida_enviar_aviso_instalacion(Procesos $este){
        global $esta_es_la_base_en_produccion;
        forzar_sesion_actual(1);
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
        //probar_todo($este,array('../encuestas/casos_prueba_encuesta.js')); // OJO comentareado para poder crear jsones
    }
    function proceso_instalar(){
        return new Proceso_Generico(array(
            'titulo'=>'Instalar aplicación',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'mantenimiento',
            'funcion'=>function(Procesos $este){
                global $esta_es_la_base_en_produccion;
                try{
                    Aplicacion::salida_enviar_aviso_instalacion($este);
                    foreach(array(
                        new Esquema_encu(),
                        new Esquema_dbo(),
                        new Tabla_tiempo_logico(),
                        new Tabla_estados_ingreso(),
                        new Tabla_roles(),
                        new Tabla_importancia(),
                        new Tabla_tipo_nov(),
                        new Tabla_planillas(),                        
                        // new Tabla_usuarios(),
                        new Tabla_operativos(),
                        new Tabla_http_user_agent(),
                        new Metadatos_same2013(),
                        new Tablas_planas(),
                        new Triggers_tem(),
                    ) as $objeto_de_la_base)
                    {
                        $este->salida->enviar('instalando '.get_class($objeto_de_la_base));
                        $objeto_de_la_base->contexto=$este;
                        $objeto_de_la_base->ejecutar_instalacion();
                    }
                    foreach(array('..\operaciones_same2013\otras_sentencias_instalacion.sql',
                                  '..\operaciones_same2013\insercion_tabla_tem.sql',
                                  '..\operaciones_same2013\insercion_tabla_roles.sql',
                                  '..\operaciones_same2013\insercion_tabla_rol_rol.sql',
                                  '..\operaciones_same2013\insercion_tabla_usuarios.sql',
                                  //'..\operaciones_same2013\insercion_tabla_usuarios_nuevos.sql',
                                  '..\operaciones_same2013\insercion_tabla_personal.sql',
                                  '..\operaciones_same2013\insercion_tabla_estados_ingreso.sql',
                                  '..\operaciones_same2013\insercion_tabla_importancia.sql',                                                                    
                                  '..\operaciones_same2013\insercion_tabla_tipo_nov.sql',
                                  '..\operaciones_same2013\insercion_tabla_relaciones.sql',  
                                  '..\operaciones_same2013\insercion_tabla_planillas.sql',  
                                  //'..\operaciones_same2013\insercion_tabla_pla_var.sql',  
                                  'vista_var_orden.sql',
                                   ) as $archivo)
                    {
                        $este->db->ejecutar_sql(new Sql(str_replace(array('/*CAMPOS_AUDITORIA*/',"'AJUS',"),array(','.PRIMER_TLG,"'same2013',"),file_get_contents($archivo))));
                    }
                    /*
                    $consistencias=explode("INSERT INTO consistencias",file_get_contents("../operaciones_same2013/consistencias_same2013.sql"));
                    array_shift($consistencias); // descarto las primeas instrucciones del dump;
                    foreach($consistencias as $cada_consistencia) {
                        $este->db->ejecutar_sql(new Sql("insert into consistencias".preg_replace("/, [0-9]+\);/",",1);",$cada_consistencia)));
                    }
                    */
                    $funciones_dbo=explode("/*otra*/",file_get_contents("funciones_dbo.sql"));
                    foreach($funciones_dbo as $cada_funcion) {
                        $este->db->ejecutar_sql(new Sql($cada_funcion));                        
                    }
                    $este->db->ejecutar_sql(new Sql("INSERT INTO claves (cla_ope, cla_for, cla_mat, cla_enc, cla_tlg) SELECT '{$GLOBALS['NOMBRE_APP']}','TEM','',tem_enc,tem_tlg FROM tem"));
                    
                    $estructura_encuesta = new Estructura_same2013();
                    $estructura_encuesta->contexto=$este;
                    $estructura_encuesta->generar_estructura();
                    $archivo='..\operaciones_same2013\insercion_tabla_consistencias.sql';
                    $este->db->ejecutar_sql(new Sql(str_replace(array('/*CAMPOS_AUDITORIA*/',"'AJUS',"),array(','.PRIMER_TLG,"'same2013',"),file_get_contents($archivo))));
                    if($esta_es_la_base_en_produccion){
                        $este->db->commit();
                    }
                }catch(Exception $e){
                    $este->salida->enviar_boton('algo anduvo mal','mensaje_error',array('autofocus'=>true,'id'=>'aviso_mal','onclick'=>'centrar_en_vertical(this)'));
                    $este->salida->enviar_script("window.addEventListener('load',function(){centrar_en_vertical(elemento_existente('aviso_mal'));});");
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
    function proceso_actualizar_instalacion(){
        return new Proceso_Generico(array(
            'titulo'=>'Actualizar Instalación (jsones varios, post cambio metadatos)',
            'para_produccion'=>true,
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'mantenimiento',
            'funcion'=>function(Procesos $este){
                global $esta_es_la_base_en_produccion;
                try{
                    Aplicacion_same2013::salida_enviar_aviso_instalacion($este);
                    $este->salida->enviar('creando jsones');
                    $tablas_planas=$este->nuevo_objeto("Tablas_planas");
                    $tablas_planas->crear_jsones();
                    $triggers_tem=$este->nuevo_objeto("Triggers_tem");
                    $este->salida->enviar('instalando '.get_class($triggers_tem));
                    $triggers_tem->ejecutar_instalacion();
                    $tabla_respuestas=$este->nuevo_objeto('Tabla_respuestas');
                    $este->db->ejecutar_sqls($tabla_respuestas->restricciones_especificas());
                    $este->db->ejecutar_sqls(new Sqls(explode('/*OTRA*/',file_get_contents('..\operaciones_same2013\actualizar_a_same2013.sql'))));
                    $estructura_encuesta = new Estructura_same2013();
                    $estructura_encuesta->contexto=$este;
                    $estructura_encuesta->generar_estructura();
                    if($esta_es_la_base_en_produccion){
                        $este->db->commit();
                    }
                }catch(Exception $e){
                    $este->salida->enviar_boton('algo anduvo mal','mensaje_error',array('autofocus'=>true,'id'=>'aviso_mal','onclick'=>'centrar_en_vertical(this)'));
                    $este->salida->enviar_script("window.addEventListener('load',function(){centrar_en_vertical(elemento_existente('aviso_mal'));});");
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
    function proceso_actualizar_instalacion_mas_planas(){
        return new Proceso_Generico(array(
            'para_produccion'=>true,
            'titulo'=>'Actualizar Instalación (jsones varios, post cambio metadatos) mas las tablas planas',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'mantenimiento',
            'funcion'=>function(Procesos $este){
                global $esta_es_la_base_en_produccion;
                try{
                    Aplicacion_same2013::salida_enviar_aviso_instalacion($este);
                    foreach(array(
                        new Tablas_planas(),
                    ) as $objeto_de_la_base)
                    {
                        $este->salida->enviar('instalando '.get_class($objeto_de_la_base));
                        $objeto_de_la_base->contexto=$este;
                        $objeto_de_la_base->ejecutar_instalacion();
                    }

                    $este->salida->enviar('creando jsones');
                    $tablas_planas=$este->nuevo_objeto("Tablas_planas");
                    $tablas_planas->crear_jsones();
                    $triggers_tem=$este->nuevo_objeto("Triggers_tem");
                    $este->salida->enviar('instalando '.get_class($triggers_tem));
                    $triggers_tem->ejecutar_instalacion();
                    $tabla_respuestas=$este->nuevo_objeto('Tabla_respuestas');
                    $este->db->ejecutar_sqls($tabla_respuestas->restricciones_especificas());
                    $este->db->ejecutar_sqls(new Sqls(explode('/*OTRA*/',file_get_contents('..\operaciones_same2013\actualizar_a_same2013.sql'))));
                    $estructura_encuesta = new Estructura_same2013();
                    $estructura_encuesta->contexto=$este;
                    $estructura_encuesta->generar_estructura();
                    if($esta_es_la_base_en_produccion){
                        $este->db->commit();
                    }
                }catch(Exception $e){
                    $este->salida->enviar_boton('algo anduvo mal','mensaje_error',array('autofocus'=>true,'id'=>'aviso_mal','onclick'=>'centrar_en_vertical(this)'));
                    $este->salida->enviar_script("window.addEventListener('load',function(){centrar_en_vertical(elemento_existente('aviso_mal'));});");
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
    function proceso_cargar_tem_de_prueba(){
        return new Proceso_Generico(array(
            'titulo'=>'Cargar TEM de prueba',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'mantenimiento',
            'funcion'=>function(Procesos $este){
                global $esta_es_la_base_en_produccion;
                if($esta_es_la_base_en_produccion){
                    throw new Exception_Tedede("ESTO NO SE PUEDE HACER EN PRODUCCION");
                }
                try{
                    $este->salida->enviar('instalando TEM de prueba');
                    $metadatos=$este->nuevo_objeto("Metadatos_same2013");
                    $metadatos->instalar_tem_de_prueba();
                    $este->salida->enviar('Listo');
                }catch(Exception $e){
                    throw $e;
                }
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
            http://localhost/ysame/same2013/same2013.php?hacer=desplegar_formulario&todo={"tra_ope":"same2013","tra_for":"AJH1","tra_mat":""}
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
    function proceso_ingresar_tem(){
        return new Proceso_ingresar_tem();
    }
    function proceso_grabar_ud(){
        return new Proceso_grabar_ud();
    }
    function proceso_grabar_fecha_comenzo_descarga(){
        return new Proceso_grabar_fecha_comenzo_descarga();
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
            'permisos'=>array('grupo'=>'subcoor_campo','grupo2'=>'procesamiento'),
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
            'permisos'=>array('grupo'=>'subcoor_campo','grupo2'=>'procesamiento'),
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
            'permisos'=>array('grupo'=>'subcoor_campo','grupo2'=>'procesamiento'),
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
            'permisos'=>array('grupo'=>'subcoor_campo','grupo2'=>'procesamiento'),
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
    function proceso_grilla_usuarios(){
        return new Proceso_generico(array(
            'titulo'=>'usuarios',
            'permisos'=>array('grupo'=>'programador','grupo2'=>'coor_campo','grupo3'=>'procesamiento','grupo4'=>'mues_campo'),
            'submenu'=>'administración',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'usuarios');
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
    function proceso_reporte_errores(){
        return new Proceso_reporte_errores();
        }
    function para_proceso_planilla_recepcion($rol,$que_planilla='recepcion',$tipo='normal'){
        return new Proceso_generico(array(
            'titulo'=>($tipo=='correccion'?'Correcciones especiales de la TEM':($tipo=='mis.sup.tel'?'Mis supervisiones telefónicas':($rol?"Planilla de $que_planilla del encuestador":"Planilla monitoreo de la TEM"))),
            'permisos'=>($tipo=='correccion'?array('grupo'=>'coor_campo'):($rol?array('grupo'=>($tipo=='mis.sup.tel' || $rol && $rol<=2?'recepcionista':'subcoor_campo')):array('grupo'=>'subcoor_campo','grupo2'=>'procesamiento'))),
            'submenu'=>($tipo=='mis.sup.tel' || $rol && $rol<=2?'recepcionista':'coordinación de campo'),
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($rol,$que_planilla,$tipo){
                mostrar_planilla_recepcion($este,1,'encuestador');
            }
        ));
    } 
 
    /*function proceso_planilla_carga_encuestador(){
        return new Proceso_planilla_carga_encuestador();
    }*/
    function proceso_planilla_carga_encuestador(){
        return new Proceso_planilla_carga_encuestador();
    }
    /*function proceso_planilla_carga_recuperador(){
        return $this->para_proceso_planilla_carga_o_recepcion(2,'carga');
    }
    function proceso_planilla_carga_supervisor_campo(){
        return $this->para_proceso_planilla_carga_o_recepcion(3,'carga');
    }
    function proceso_planilla_carga_supervisor_telefonico(){
        return $this->para_proceso_planilla_carga_o_recepcion(4,'carga');
    }*/
    function proceso_planilla_recepcion_encuestador(){
        return $this->para_proceso_planilla_recepcion(1,'recepción');
    }
    function proceso_planilla_recepcion_recuperador(){
        return $this->para_proceso_planilla_recepcion(2,'recepción');
    }
    function proceso_planilla_recepcion_supervisor_campo(){
        return $this->para_proceso_planilla_recepcion(3,'recepción');
    }
    function proceso_planilla_recepcion_supervisor_telefonico(){
        return $this->para_proceso_planilla_recepcion(4,'recepción');
    }
    function proceso_planilla_mis_superviones_telefonicas(){
        return $this->para_proceso_planilla_recepcion(4,'recepción','mis.sup.tel');
    }
    function proceso_correccion_TEM(){
        return $this->para_proceso_planilla_recepcion(null,'recepción','correccion');
    }
    function proceso_confirmar_salida_campo_papel(){
        return new Proceso_confirmar_salida_campo_papel();
    }
    function proceso_averiguar_fecha_ultima_carga(){
        return new Proceso_averiguar_fecha_ultima_carga();
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
            'permisos'=>array('grupo'=>'procesamiento'),
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
            'permisos'=>array('grupo'=>'procesamiento','grupo1'=>'mues_campo'),
            'submenu'=>'consistencias',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'consistencias',array('con_ope'=>$GLOBALS['NOMBRE_APP']),false,array('filtro_manual'=>array('con_tipo'=>'#=Conceptual| =Revisar| =Completitud')));
            }
        ));
    }
    function proceso_grilla_viviendas_para_el_muestrista(){
        return new Proceso_generico(array(
            'titulo'=>'Viviendas para el muestrista',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'viviendas_para_el_muestrista',array(),false,array('filtro_manual'=>array('pla_estado'=>'#<>98')));
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
                global $soy_un_ipad;
                $este->salida->enviar('Pantalla de entrada al sistema en producción de la same','',array('tipo'=>'h2'));
                if($_SESSION["{$GLOBALS['NOMBRE_APP']}_usu_blanquear_clave"]){
                    $este->salida->abrir_grupo_interno();
                        $este->salida->enviar('debe ','',array('tipo'=>'span'));
                        $este->salida->enviar_link('cambiar la clave de acceso','',$GLOBALS['nombre_app'].'.php?hacer=cambio_de_clave');
                        $este->salida->enviar(' (porque posee una provisoria)','',array('tipo'=>'span'));
                    $este->salida->cerrar_grupo_interno();
                }else{
                    if($soy_un_ipad){
                        $este->salida->abrir_grupo_interno();
                            $este->salida->enviar_link('Ir a la hoja de ruta','',$GLOBALS['nombre_app'].'.php?hacer=hoja_de_ruta');
                        $este->salida->cerrar_grupo_interno();
                        $este->salida->enviar('','',array('tipo'=>'hr'));
                    }else{
                        $este->salida->abrir_grupo_interno();
                            $este->salida->enviar_link('Ir al menú principal','',$GLOBALS['nombre_app'].'.php?hacer=menu');
                        $este->salida->cerrar_grupo_interno();
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
            // 'titulo_html'=>'{
            'submenu'=>PROCESO_INTERNO,
            'funcion'=>function(Procesos $este){
                $este->salida->abrir_grupo_interno('cabezal_matriz');
                    $este->salida->enviar('Encuesta ','',array('tipo'=>'span'));
                    $este->salida->enviar('','',array('tipo'=>'span','id'=>'mostrar_enc'));
                    $este->salida->enviar(AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.'resumen de sus formularios ','',array('tipo'=>'div'));
                    $este->salida->enviar('','',array('tipo'=>'div','id'=>'direccion'));
                    $este->salida->enviar('','',array('tipo'=>'span','id'=>'lote'));
                    $este->salida->enviar('','',array('tipo'=>'span','id'=>'participacion'));
                $este->salida->cerrar_grupo_interno();
                $este->salida->enviar('','',array('tipo'=>'div','id'=>'grilla_visitas'));
                $este->salida->enviar('','',array('tipo'=>'div','id'=>'anoenc'));
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
    function proceso_hoja_de_ruta(){
        return new Proceso_generico(array(
            'titulo'=>'Hoja de ruta',
            'permisos'=>null,
            'submenu'=>PROCESO_INTERNO,
            'html_title'=>"SA.ME. 2013",
            'funcion'=>function(Procesos $este){
                $este->salida->abrir_grupo_interno('cabezal_matriz');
                    $este->salida->enviar('Carga ','',array('tipo'=>'span'));
                    $este->salida->enviar('','',array('tipo'=>'span','id'=>'mostrar_carga'));
                    $este->salida->enviar(AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP,'',array('tipo'=>'span'));
                    $este->salida->enviar('Persona','',array('tipo'=>'span','id'=>'nombre_rol_hdr'));
                    $este->salida->enviar(' ','',array('tipo'=>'span')); 
                    $este->salida->enviar('','',array('tipo'=>'span','id'=>'mostrar_encuestador'));
                    $este->salida->enviar(AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.'HOJA DE RUTA v 3.00 '.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP,'',array('tipo'=>'span'));
                    $este->salida->enviar('','',array(
                        'tipo'=>'input',
                        'id'=>'clave_recepcionista',
                        'type'=>'tel', 
                        'style'=>'width:50px',
                        'onblur'=>"if(this.value==1234){ ir_a_url(location.pathname+'?hacer=cargar_dispositivo'); this.value=null};if(this.value==753){ controlar_offline(); this.value=null};",
                    ));
                $este->salida->cerrar_grupo_interno();
                $este->salida->enviar_script(<<<JS
                    window.addEventListener('load',function(){
                        mostrar_advertencia_descargado();
                        desplegar_hoja_de_ruta();
                    });

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
    function proceso_asignar_resto_lote_a_enc(){
        return new Proceso_asignar_resto_lote_a_enc();
    }
    function proceso_inconsistencias(){
        return new Proceso_generico(array(
            'titulo'=>'Listado de inconsistencias por encuesta',
            'permisos'=>array('grupo'=>'ingresador'),
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
    function proceso_imprimir_remito(){
        return new Proceso_imprimir_remito();
    }
    function proceso_colorear_respuestas(){
        return new Proceso_colorear_respuestas();
    }
    function proceso_grilla_muestrista_no_realizadas(){    
        return new Proceso_generico(array(
            'titulo'=>'Viviendas no realizadas',
            'permisos'=>array('grupo'=>'procesamiento', 'grupo2'=>'subcoor_campo'),
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
            'permisos'=>array('grupo'=>'procesamiento', 'grupo2'=>'subcoor_campo'),
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
                enviar_grilla($este->salida,'tabla_usuarios',array('usu_usu'=>usuario_actual()),false,array('simple'=>'true'));
                $este->salida->enviar('Verifique que su dirección de correo electrónico sea correcta. Se usará este correo para enviarle una nueva clave en caso de que se la olvide.','celda_comun',array('style'=>'max-width:inherit'));
            }
        ));
    }
    function proceso_grilla_excepciones(){
        return new Proceso_generico(array(
            'titulo'=>'Registro de excepciones',
            'para_produccion'=>true,
            'submenu'=>'campo',
            'permisos'=>array('grupo1'=>'subcoor_campo','grupo2'=>'procesamiento'),
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'excepciones', array('exc_ope'=>$GLOBALS['NOMBRE_APP']));
            }
        ));
    }
    function proceso_grilla_personal(){
        return new Proceso_generico(array(
            'titulo'=>'Personal de campo',
            'para_produccion'=>true,
            'submenu'=>'campo',
            'permisos'=>array('grupo'=>'subcoor_campo'),
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'tabla_personal', array('per_ope'=>$GLOBALS['NOMBRE_APP']));
            }
        ));
    }
    function proceso_grilla_bolsas_scc(){
        return new Proceso_generico(array(
            'titulo'=>'Planilla Bolsas para sub coor campo',
            'permisos'=>array('grupo'=>'subcoor_campo'),
            'para_produccion'=>true,
            'submenu'=>'campo',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'bolsas', array('bol_ope'=>$GLOBALS['NOMBRE_APP'],'bol_dispositivo'=>2));
            }
        ));
    }
    function proceso_grilla_bolsas_pro(){
        return new Proceso_generico(array(
            'titulo'=>'Planilla Bolsas para procesamiento',
            'permisos'=>array('grupo'=>'procesamiento'),
            'para_produccion'=>true,
            'submenu'=>'campo',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'bolsas', array('bol_ope'=>$GLOBALS['NOMBRE_APP']));
            }
        ));
    }
    function proceso_destrabar_carga_dispositivo(){
        return new Proceso_destrabar_carga_dispositivo();
    }    
    function proceso_ingresar_personal(){
        return new Proceso_ingresar_personal();
    }    
    function proceso_fin_de_campo(){
        return new Proceso_fin_de_campo();
    }    
    function proceso_fin_descargar_dispositivo(){
        return new Proceso_fin_descargar_dispositivo();
    }
    function proceso_eliminar_hogar(){
        return new Proceso_eliminar_hogar();
    } 
    function proceso_numerar_bolsas_virtuales(){
        return new Proceso_numerar_bolsas_virtuales();
    }    
    function proceso_grilla_inconsistencias_historicas(){
        return new Proceso_generico(array(
            'titulo'=>'Grilla inconsistencias Históricas',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'his_inconsistencias',array('hisinc_ope'=>$GLOBALS['NOMBRE_APP']));
            }
            /*'funcion'=>function(Procesos $este){
                mostrar_visor($este);
            }*/
        ));
    }
    function proceso_borrar_miembros_individuales(){
        return new Proceso_borrar_miembros_individuales();
    }    
    function proceso_borrar_ex_miembros(){
        return new Proceso_borrar_ex_miembros();
    }
    function proceso_migrar_visitas_a_anoenc(){
        return new Proceso_migrar_visitas_a_anoenc();
    }    
    function proceso_eliminar_formulario_a1(){
        return new Proceso_eliminar_formulario_a1();
    } 
    function proceso_agregar_novedades(){
        return new Proceso_agregar_novedades();
    } 
    function preparar_scripts_iniciales(){
        parent::preparar_scripts_iniciales();
        $this->salida->agregar_js("seleccion_miembro.js");
    }
    function proceso_impresion_etiquetas_respondentes(){
        return new Proceso_impresion_etiquetas_respondentes();
    } 
    
}

if(!isset($no_ejecutar_aplicacion)){
    Aplicacion::correr(new Aplicacion_same2013());
}
?>