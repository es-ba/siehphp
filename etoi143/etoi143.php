<?php
//UTF-8:SÍ
//v 3.00

$NOMBRE_APP='etoi143';
$nombre_app='etoi143';
$PLA_F_NAC_O='fechadma(pla_f_nac_d,pla_f_nac_m, pla_f_nac_a)';
$GLOBALS['anio_operativo']=2014;
$GLOBALS['trimestre_operativo']=3;
$GLOBALS['esquema_principal']='encu';

require_once "lo_imprescindible.php";
require_once "aplicaciones.php";
require_once "tabla_operativos.php";
require_once "metadatos_etoi143.php";
require_once "todos_los_php.php";
incluir_todo("../tedede");
incluir_todo("../encuestas");
incluir_todo("../etoi143");

class Aplicacion_etoi143 extends Aplicacion_encuesta{
    function __construct(){
        global $esta_es_la_base_en_produccion,$esta_es_la_base_de_capacitacion,$soy_un_ipad;
        $this->ver_offline=array(
            'hoja_de_ruta'=>true, 
            'formularios_de_la_vivienda'=>true, 
            'desplegar_formulario'=>true
        );
        parent::__construct();
        if($esta_es_la_base_en_produccion){
            $this->salida->html_title="ETOI143";
        }else if($esta_es_la_base_de_capacitacion){
            $this->salida->html_title="CAPA - ETOI143";
        }else{
            $this->salida->html_title="TEST - ETOI143";
        }
        if($soy_un_ipad){
            if(isset($_REQUEST['hacer'])&&isset($this->ver_offline[$_REQUEST['hacer']])){
                $this->salida->manifiesto="etoi143.manifest";
            }
        }
        $this->salida->agregar_css("../tedede/probador.css");
        $this->salida->agregar_js("../encuestas/encuestas.js");
        $this->salida->agregar_js("../tedede/editor.js");
        $this->salida->agregar_js("../tedede/para_grilla.js");
        $this->salida->agregar_js("../tercera/md5_paj.js");
        $this->salida->agregar_js("../encuestas/encu_especiales.js");
        $this->salida->agregar_js("estructura_{$GLOBALS['nombre_app']}.js");
        $this->salida->agregar_js('dbo_etoi143.js');
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
        $this->salida->abrir_grupo_interno();
            $this->salida->abrir_grupo_link('',$destino_principal);
                $this->salida->enviar_imagen("../{$GLOBALS['nombre_app']}/logo_app.png",'logo_principal no_imprimir',array('id'=>'logo_principal'));
            $this->salida->cerrar_grupo_interno();
        $this->salida->cerrar_grupo_interno();
    }
    function obtener_titulo(){
        return "Prueba Piloto ETOI143";
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
                        new Esquema_operaciones(),
                        new Esquema_dbx(),
                        new Esquema_his(),
                        new Tabla_tiempo_logico(),
                        new Tabla_estados_ingreso(),
                        new Tabla_roles(),
                        new Tabla_importancia(),
                        new Tabla_tipo_nov(),
                        new Tabla_planillas(), 
                        new Tabla_con_momentos(),                        
                        //new Tabla_usuarios(),
                        new Tabla_operativos(),
                        new Tabla_http_user_agent(),
                        new Metadatos_etoi143(), /// aca inserta los metadatos corriendo '..\operaciones_etoi143\etoi143_dump.json'
                        new Tablas_planas(),
                        new Tabla_tabulados(),
                        new Tabla_diccionario(),
                        new Tabla_dispositivo(),
                        new Tabla_dominio(),                        
                        new Tabla_replica(),                        
                        new Tabla_result_sup(),
                        new Tabla_verificado(),                        
                        new Tabla_a_ingreso(),
                        new Tabla_volver_a_cargar(),
                        new Tabla_tem(),
                        new Tabla_funciones_automaticas(),
                        new Triggers_tem(),
                    ) as $objeto_de_la_base)
                    {
                        $este->salida->enviar('instalando '.get_class($objeto_de_la_base));
                        $objeto_de_la_base->contexto=$este;
                        $objeto_de_la_base->ejecutar_instalacion();
                    }
                    foreach(array('..\operaciones_etoi143\otras_sentencias_instalacion.sql',//ok 
                                  '..\operaciones_etoi143\insercion_tabla_tem.sql',
                                  '..\operaciones\insercion_tabla_http_user_agent.sql',
                                  '..\operaciones_etoi143\insercion_tabla_roles.sql',//ok normalizado
                                  '..\operaciones_etoi143\insercion_tabla_rol_rol.sql',//ok normalizado
                                  '..\operaciones_etoi143\insercion_tabla_con_momentos.sql',//ok normalizado
                                  '..\operaciones_etoi143\insercion_tabla_usuarios.sql',//ok normalizado
                                  '..\operaciones_etoi143\insercion_tabla_personal.sql',//ok normalizado
                                  '..\operaciones_etoi143\insercion_tabla_estados_ingreso.sql',//ok normalizado
                                  '..\operaciones_etoi143\insercion_tabla_importancia.sql',//ok normalizado                       
                                  '..\operaciones_etoi143\insercion_tabla_tipo_nov.sql',//ok normalizado        
                                  '..\operaciones_etoi143\insercion_tabla_relaciones.sql',//ok normalizado         
                                  '..\operaciones_etoi143\insercion_tabla_planillas.sql',//ok normalizado     
                                  '..\operaciones_etoi143\insercion_tabla_pla_var.sql',  //ok normalizado     
                                  '..\operaciones_etoi143\insercion_tabla_diccionario.sql',  // ok n
                                  '..\operaciones_etoi143\insercion_tabla_dictra.sql',  // ok n
                                  '..\operaciones_etoi143\insercion_tabla_dicvar.sql',  // ok n
                                  '..\operaciones_etoi143\insercion_tabla_dispositivo.sql',  // ok n
                                  '..\operaciones_etoi143\insercion_tabla_dominio.sql',  // ok n
                                  '..\operaciones_etoi143\insercion_tabla_replica.sql',  // ok n
                                  '..\operaciones_etoi143\insercion_tabla_result_sup.sql',  // ok n
                                  '..\operaciones_etoi143\insercion_tabla_tabulados.sql',  // ok n
                                  '..\operaciones_etoi143\insercion_tabla_verificado.sql',  // ok n
                                  '..\operaciones_etoi143\insercion_tabla_volver_a_cargar.sql', // ok n
                                  '..\operaciones_etoi143\insercion_tabla_estados.sql', // ok n
                                  '..\operaciones_etoi143\insercion_tabla_est_rol.sql', // ok n                             
                                  '..\operaciones_etoi143\insercion_tabla_pla_est.sql', // ok n
                                  '..\operaciones_etoi143\insercion_tabla_est_var.sql', // ok n
                                  '..\operaciones_etoi143\insercion_tabla_varcal.sql', //ok n
                                  '..\operaciones_etoi143\insercion_tabla_varcalopc.sql',// ok n                                  
                                  '..\operaciones_etoi143\vista_var_orden.sql',// ok
                                   ) as $archivo)
                    {
                        $sentencias_generales=explode("/*OTRA*/",file_get_contents($archivo));
                        $sql_sentencias=str_replace(array('/*CAMPOS_AUDITORIA*/',"'eah2013',"),array(PRIMER_TLG,"'dbo.ope_actual()',"),$sentencias_generales);
                        if(!$esta_es_la_base_en_produccion){
                            $este->db->beginTransaction();
                            $este->db->ejecutar_sql(new Sql("SET CONSTRAINTS ALL DEFERRED"));
                        }   
                        $este->salida->enviar('instalando '.$archivo);                        
                        foreach($sql_sentencias as $cada_sentencia) {                            
                            $este->db->ejecutar_sql(new Sql($cada_sentencia));                            
                        }
                        if(!$esta_es_la_base_en_produccion){
                            $este->db->ejecutar_sql(new Sql("SET CONSTRAINTS ALL IMMEDIATE"));
                            $este->db->commit();
                        }                        
                    }
                    $este->salida->enviar('corriendo scripts_esquema_his.sql');                        
                    $sentencias_his=explode("/*OTRA*/",file_get_contents("scripts_esquema_his.sql"));
                    foreach($sentencias_his as $cada_sentencia) {
                        $este->db->ejecutar_sql(new Sql($cada_sentencia));                        
                    }                    
                    $este->salida->enviar('instalando las funciones_dbo.sql');                        
                    $funciones_dbo=explode("/*OTRA*/",file_get_contents("funciones_dbo.sql"));
                    foreach($funciones_dbo as $cada_funcion) {
                        $este->db->ejecutar_sql(new Sql($cada_funcion));                        
                    }
                    $este->salida->enviar('instalando las funciones_encu.sql');                        
                    $funciones_encu=explode("/*OTRA*/",file_get_contents("funciones_encu.sql"));
                    foreach($funciones_encu as $cada_funcion) {
                        $este->db->ejecutar_sql(new Sql($cada_funcion));                        
                    }
                    $este->salida->enviar('instalando las funciones_operaciones.sql');                        
                    $funciones_operaciones=explode("/*OTRA*/",file_get_contents("funciones_operaciones.sql"));
                    foreach($funciones_operaciones as $cada_funcion) {
                        $este->db->ejecutar_sql(new Sql($cada_funcion));                        
                    }                    
                    $este->salida->enviar('instalando los triggers');                        
                    $triggers=explode("/*OTRA*/",file_get_contents("triggers.sql"));
                    foreach($triggers as $cada_trigger) {
                        $este->db->ejecutar_sql(new Sql($cada_trigger));                        
                    }                    
                    $este->salida->enviar('insertando las claves');                        
                    //$este->db->ejecutar_sql(new Sql("INSERT INTO claves (cla_ope, cla_for, cla_mat, cla_enc, cla_tlg) SELECT '{$GLOBALS['NOMBRE_APP']}','TEM','',tem_enc,tem_tlg FROM tem"));
                    
                    $estructura_encuesta = new Estructura_etoi143();
                    $estructura_encuesta->contexto=$este;
                    $este->salida->enviar('generando estructura');  
                    $estructura_encuesta->generar_estructura();
                    $este->salida->enviar('insertando consistencias');  
                    $archivo='..\operaciones_etoi143\insercion_tabla_consistencias.sql';
                    $este->db->ejecutar_sql(new Sql(str_replace(array('/*CAMPOS_AUDITORIA*/',"'etoi143',"),array(PRIMER_TLG,"'etoi143',"),file_get_contents($archivo))));
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
        $esto=$this;
        return new Proceso_Generico(array(
            'para_produccion'=>true,
            'titulo'=>'Actualizar Instalación (jsones varios, post cambio metadatos)',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'mantenimiento',
            'funcion'=>function($este) use ($esto){
                $esto->para_proceso_actualizar_instalacion($este,false);
            }
        ));
    }        
    function proceso_actualizar_instalacion_mas_planas(){
        $esto=$this;
        return new Proceso_Generico(array(
            'para_produccion'=>true,
            'titulo'=>'Actualizar Instalación (jsones varios, post cambio metadatos) mas las tablas planas',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'mantenimiento',
            'funcion'=>function($este) use ($esto) {
                $esto->para_proceso_actualizar_instalacion($este,true);
            }
        ));
    }
    function para_proceso_actualizar_instalacion_mas_planas($mas_planas){
        if($mas_planas){
            $this->proceso_actualizar_instalacion_mas_planas();
        }else{
            $this->proceso_actualizar_instalacion();        
        }
    }    
    function para_proceso_actualizar_instalacion($este,$mas_planas){
        global $esta_es_la_base_en_produccion;
        try{
            Aplicacion_etoi143::salida_enviar_aviso_instalacion($este);
            if($mas_planas){
                foreach(array(
                    new Tablas_planas(),
                ) as $objeto_de_la_base)
                {
                    $este->salida->enviar('instalando '.get_class($objeto_de_la_base));
                    $objeto_de_la_base->contexto=$este;
                    $objeto_de_la_base->ejecutar_instalacion();
                }
            }
            $este->salida->enviar('creando jsones');
            $tablas_planas=$este->nuevo_objeto("Tablas_planas");
            $tablas_planas->crear_jsones();
            $triggers_tem=$este->nuevo_objeto("Triggers_tem");
            $este->salida->enviar('instalando '.get_class($triggers_tem));
            $triggers_tem->ejecutar_instalacion();
            $tabla_respuestas=$este->nuevo_objeto('Tabla_respuestas');
            $este->db->ejecutar_sqls($tabla_respuestas->restricciones_especificas());                    
            //$este->db->ejecutar_sqls(new Sqls(explode('/*OTRA*/',file_get_contents('..\operaciones_etoi143\actualizar_a_etoi143.sql'))));                    
            // esta sentencia se incluye a partir de etoi143 en '..\operaciones_etoi143\otras_sentencias_instalacion.sql'                    
            $estructura_encuesta = new Estructura_etoi143();
            $estructura_encuesta->contexto=$este;
            $estructura_encuesta->generar_estructura();
            // Se comentan porque se corren por separado
            //$este->salida->enviar('generando consistencias de flujo');
            //$este->db->ejecutar_sql(new Sql("select generar_consistencias_flujo(:ope)", array(':ope'=>$GLOBALS['NOMBRE_APP'])));
            //$este->db->ejecutar_sql(new Sql("select generar_consistencias_audi_nsnc(:ope)", array(':ope'=>$GLOBALS['NOMBRE_APP'])));
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
                    $metadatos=$este->nuevo_objeto("Metadatos_etoi143");
                    $metadatos->instalar_tem_de_prueba();
                    $este->salida->enviar('Listo');
                }catch(Exception $e){
                    throw $e;
                }
            }
        ));
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
    function proceso_desplegar_sup(){
        return $this->proceso_desplegar_formulario('SUP');
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
    function proceso_planilla_carga_encuestador(){    
        return new planilla_carga_encuestador();
    }
    function proceso_planilla_carga_recuperador(){    
        return new planilla_carga_recuperador();
    }    
    function proceso_planilla_carga_supervisor_campo(){    
        return new planilla_carga_supervisor_campo();
    }
    function proceso_planilla_carga_supervisor_telefonico(){    
        return new planilla_carga_supervisor_telefonico();
    }    
    function proceso_planilla_recepcion_encuestador(){
        return new Planilla_recepcion_encuestador();
    }
    function proceso_planilla_recepcion_recuperador(){
        return new Planilla_recepcion_recuperador();
    }
    function proceso_planilla_recepcion_supervisor_campo(){
        return new Planilla_recepcion_supervisor_campo();
    }
    function proceso_planilla_recepcion_supervisor_telefonico(){
        return new Planilla_recepcion_supervisor_telefonico();
    }
    function proceso_planilla_analista_consistencias(){
        return new Planilla_analista_consistencias();
    }
    function proceso_planilla_monitoreo_TEM(){
        return new Planilla_monitoreo_TEM();
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
                $este->salida->enviar('Pantalla de entrada al sistema en producción de la ETOI 2014 trimestre 3','',array('tipo'=>'h2'));
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
        return new Proceso_formularios_de_la_vivienda();
    }
    function proceso_hoja_de_ruta(){
        return new Proceso_generico(array(
            'titulo'=>'Hoja de ruta',
            'permisos'=>null,
            'submenu'=>PROCESO_INTERNO,
            'html_title'=>"E.T.O.I. 2014 trimestre 3",
            'funcion'=>function(Procesos $este){
                $este->salida->abrir_grupo_interno('cabezal_matriz',array('id'=>'encabezado_pagina'));
                    $este->salida->enviar('Carga ','',array('tipo'=>'span'));
                    $este->salida->enviar('','',array('tipo'=>'span','id'=>'mostrar_carga'));
                    $este->salida->enviar(AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP,'',array('tipo'=>'span'));
                    $este->salida->enviar('Persona','',array('tipo'=>'span','id'=>'nombre_rol_hdr'));
                    $este->salida->enviar(' ','',array('tipo'=>'span'));
                    $este->salida->enviar('','',array('tipo'=>'span','id'=>'mostrar_encuestador'));
                    $este->salida->enviar(AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP.'HOJA DE RUTA v 3.00  '.AUTF8_NBSP.AUTF8_NBSP.AUTF8_NBSP,'',array('tipo'=>'span'));
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
                        setTimeout(function(){
                            mostrar_advertencia_descargado();
                            desplegar_hoja_de_ruta();
                        },0);
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
    function proceso_asignar_resto_lote_a_recu(){
        return new Proceso_asignar_resto_lote_a_recu();
    }
    function proceso_asignar_resto_lote_a_sup_telefonico(){
        return new Proceso_asignar_resto_lote_a_sup_telefonico();
    }
    function proceso_asignar_resto_lote_a_sup_campo(){
        return new Proceso_asignar_resto_lote_a_sup_campo();
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
    function proceso_grilla_monitoreo_procesamiento(){
        return new Proceso_generico(array(
            'titulo'=>'Monitoreo de Procesamiento',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_monitoreo_procesamiento');
            }
        ));
    }
    function proceso_grilla_monitoreo_procesamiento_2(){
        return new Proceso_generico(array(
            'titulo'=>'Monitoreo de Procesamiento 2',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_monitoreo_procesamiento_2');
            }
        ));
    }
    function proceso_grilla_monitoreo_procesamiento_3(){
        return new Proceso_generico(array(
            'titulo'=>'Monitoreo de Procesamiento 3',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_monitoreo_procesamiento_3');
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
    function proceso_fin_descargar_dispositivo_enc(){
        return new Proceso_fin_descargar_dispositivo_enc();
    }
    function proceso_fin_descargar_dispositivo_recu(){
        return new Proceso_fin_descargar_dispositivo_recu();
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
            'permisos'=>array('grupo'=>'procesamiento','grupo2'=>'subcoor_campo'),
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
    function proceso_grilla_A1(){
        return new Proceso_generico(array(
            'titulo'=>'Grilla de Preguntas abiertas del A1',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) {           
               //enviar_grilla($este->salida,'A1',null,null,array('filtro_visible'=>array('pla_v2'=>'#=8|pla_v5=4|pla_h2=7|pla_h20_14=1')));
               enviar_grilla($este->salida,'A1',array('pla_v2'=>'# =8|pla_h2=7'),null,array());                
            }
        ));
    }
    function proceso_grilla_I1_trabajo_ingresos(){
        return new Proceso_generico(array(
            'titulo'=>'Grilla de Preguntas abiertas del I1 (trabajo e ingresos)',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'I1_trabajo_ingresos',
                    array('pla_t8'=>'# =3|pla_t8_otro!=NULL|pla_t11=4|pla_t11_otro!=NULL|pla_t37!=NULL|pla_t39=2|pla_t39=3|pla_t39=4|pla_t39_barrio!=NULL|pla_t39_partido!=NULL|pla_t39_otro!=NULL|pla_t41!=NULL|pla_t42!=NULL|pla_t48b=6|pla_t48b_esp!=NULL|pla_i6_10_esp!=NULL|pla_i3_10_otro!=NULL'),null,array());
            }
        ));
    }
    function proceso_grilla_I1_migracion(){
        return new Proceso_generico(array(
            'titulo'=>'Grilla de Preguntas abiertas del I1 migración',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'I1_migracion',array('pla_m1'=>'#=2|pla_m1=3|pla_m1=4|pla_m4=1|pla_m4=2|pla_m4=3'),null,array());
            }
        ));
    }
    function proceso_grilla_A1_X_abiertas(){
        return new Proceso_generico(array(
            'titulo'=>'Grilla de Preguntas abiertas del A1 ex miembros',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'A1_X_abiertas',array(),null,array());
            }
        ));
    }
    function proceso_grilla_I1_variables_externas(){
        return new Proceso_generico(array(
            'titulo'=>'Grilla de Variables calculadas externas del I1',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'I1_variables_externas');
            }
        ));       
    }    
    function proceso_grilla_S1_variables_externas(){
        return new Proceso_generico(array(
            'titulo'=>'Grilla de Variables calculadas externas del S1',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'S1_variables_externas');
            }
        ));       
    }    
    function proceso_grilla_dictra(){
        return new Proceso_generico(array(
            'titulo'=>'Diccionario para variables construidas y consistencias',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'dictra',null,null,array('otras_opciones'=>array('agregando_filas_completas'=>true),'filtro_manual'=>array('dictra_dic'=>'barrio')));
            }
        ));
    } 
    function proceso_grilla_diccionario_coincidencias(){
        return new Proceso_generico(array(
            'titulo'=>'Coincidencias de variables con diccionario',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_diccionario_coincidencias',null,null,array('filtro_manual'=>array('vis_dic'=>'barrio')));
            }
        ));
    }     
    function proceso_grilla_temas(){
        return new Proceso_generico(array(
            'titulo'=>'Variables calculadas (temas)',
            'permisos'=>array('grupo'=>'procesamiento'),
            'para_produccion'=>true,
            'submenu'=>'procesamiento',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'temas',array(),false,array('otras_opciones'=>array('agregando_filas_completas'=>true)));
            }
        ));
    }    
    function proceso_grilla_varcal(){
        return new Proceso_generico(array(
            'titulo'=>'Variables calculadas (definición)',
            'permisos'=>array('grupo'=>'procesamiento'),
            'para_produccion'=>true,
            'submenu'=>'procesamiento',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'varcal',array(),false,array('otras_opciones'=>array('agregando_filas_completas'=>true)));
            }
        ));
    }    
    function proceso_grilla_varcalopc(){
        return new Proceso_generico(array(
            'titulo'=>'Variables calculadas (opciones)',
            'permisos'=>array('grupo'=>'procesamiento'),
            'para_produccion'=>true,
            'submenu'=>'procesamiento',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'varcalopc',array(),false,array('otras_opciones'=>array('agregando_filas_completas'=>true)));
            }
        ));
    }    
    function proceso_compilar_variables_calculadas(){
        return new Proceso_compilar_variables_calculadas();
    }
    function proceso_frecuencia_variables(){
        return new Proceso_frecuencia_variables();
    }
    function proceso_grilla_I1_salud(){
        return new Proceso_generico(array(
            'titulo'=>'Grilla de Preguntas abiertas del I1 salud',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'I1_salud',array('pla_sn1_1'=>'#=1|pla_sn1_7=1|pla_sn1_2=1|pla_sn1_3=1|pla_sn1_4=1'),null,array());
            }            
        ));
    }
    function proceso_grilla_tabulados(){
        return new Proceso_generico(array(
            'titulo'=>'Grilla de tabulados',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'tabulados',null,null,array('otras_opciones'=>array('agregando_filas_completas'=>true)));                
            }
        ));
    }    
    function proceso_tabulados(){
        return new Proceso_tabulados();
    }
    function proceso_grilla_rama(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla rama',
            'permisos'=>array('grupo'=>'programador', 'grupo1'=>'procesamiento'),
            'para_produccion'=>true,
            'submenu'=>'documentación',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'rama' );
            }
        ));
    }
    function proceso_grilla_ocupacion(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla ocupacion',
            'permisos'=>array('grupo'=>'programador', 'grupo1'=>'procesamiento'),
            'para_produccion'=>true,
            'submenu'=>'documentación',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'ocupacion' );
            }
        ));
    }  
    function proceso_copiar_encuesta(){
        return new Proceso_copiar_encuesta();
    }
    function proceso_planilla_encuestas_pendientes_verificar(){
        return new Planilla_encuestas_pendientes_verificar();
    }
    function proceso_planilla_monitoreo_campo(){
        return new Planilla_monitoreo_campo(); // si se incluye en todos los operativos encuesta: pasar a aplicacion_encuesta
    }
    function proceso_grilla_baspro_var(){
        return new Proceso_generico(array(
            'titulo'=>'Bases producidas variables',
            'permisos'=>array('grupo'=>'programador', 'grupo1'=>'procesamiento'),
            'para_produccion'=>true,
            'submenu'=>'procesamiento',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'baspro_var',array(),false,array('otras_opciones'=>array('agregando_filas_completas'=>true)));
            }
        ));
    }
    function proceso_copiar_variables(){
        return new Proceso_copiar_variables();
    }
    function proceso_exportar_base(){
        return new Proceso_exportar_base();
    }
}
if(!isset($no_ejecutar_aplicacion)){
    Aplicacion::correr(new Aplicacion_etoi143());
}
?>