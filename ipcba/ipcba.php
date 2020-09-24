<?php
//UTF-8:SÍ
//v 3.00
$NOMBRE_APP='ipcba';
$nombre_app='ipcba';
$login_dual=true;
$parametros_db=(object) array();
//$parametros_db->search_path=';ConnSettings=set search_path to ipcba,cvp,comun,public;';
$parametros_db->search_path='ipcba,cvp,comun,public';
$GLOBALS['titulo_corto_app']="I.P.C.B.A.";
require_once "lo_imprescindible.php";
require_once "aplicaciones.php";
require_once "todos_los_php.php";
incluir_todo("../tedede");
incluir_todo("../$nombre_app");

class Aplicacion_ipcba extends Aplicacion{
    function __construct(){
        global $esta_es_la_base_en_produccion,$soy_un_ipad;
        $this->ver_offline=array(
            'hoja_de_ruta'=>true, 
            'formularios_de_la_vivienda'=>true, 
            'desplegar_formulario'=>true
        );
        parent::__construct();
        if($esta_es_la_base_en_produccion){
            $this->salida->html_title="I.P.C.B.A.";
        }else{
            $this->salida->html_title="TEST - I.P.C.B.A.";
        }
        $this->salida->color_fondo=(@$GLOBALS['color_de_fondo_de_la_aplicacion'])?:'#FDE';
        if($soy_un_ipad){
            if(isset($_REQUEST['hacer'])&&isset($this->ver_offline[$_REQUEST['hacer']])){
                $this->salida->manifiesto="{$nombre_app}.manifest";
            }
        }
        $this->salida->agregar_css("{$GLOBALS['nombre_app']}.css");
        $this->salida->agregar_css("../tedede/probador.css");
        $this->salida->agregar_css("cuadros.css");
        $this->salida->agregar_js("../tedede/editor.js");
        $this->salida->agregar_js("../tedede/para_grilla.js");
        $this->salida->agregar_js("../tedede/tedede_cm.js");
        $this->salida->agregar_js("para_cuadros.js");
        $this->salida->agregar_js("matriz_precios.js");
        $this->salida->agregar_css("matriz_precios.css");
        $this->salida->agregar_js("../tercera/md5_paj.js");
        $this->salida->agregar_js("../tercera/decimal.js");
        $this->salida->agregar_js("../tipox/controlador.js");
        $this->salida->agregar_js("../tipox/enviador.js");
        $this->salida->agregar_js("../tipox/acumuladores.js");
        $this->salida->agregar_css("../tipox/grilla2.css");
        $this->salida->agregar_js("../tipox/grilla2.js");
        $this->salida->agregar_js("ipcba.js");
    }
    function obtener_titulo(){
        return "I.P.C.B.A.";
    }
    function mostrar_titulo($proceso=false){
        $destino_principal=$GLOBALS['nombre_app'].'.php';
        $this->salida->abrir_grupo_interno('zona_logo_principal');
            $this->salida->abrir_grupo_link('',$destino_principal);
                $this->salida->enviar_imagen("../{$GLOBALS['nombre_app']}/logo_app.png",'logo_principal no_imprimir');
            $this->salida->cerrar_grupo_interno();
            $this->salida->enviar_imagen("../ipcba/logo_ipcba.png",'logo_flotante no_imprimir');
        $this->salida->cerrar_grupo_interno();
        $this->salida->enviar_script(<<<JS
            window.addEventListener('load',function(){
                var elementos=document.querySelectorAll('.logo_flotante');
                for (var i=0; i<elementos.length; i++){
                    elementos[i].style.top='0px';
                }
            });
JS
        );
        $mensaje_encabezado='';
        if(usuario_actual()){
            $mensaje_encabezado.='Usuario: '.$_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_usu_usu"].' ';                
            //$mensaje_encabezado.='Usuario: '.$GLOBALS['NOMBRE_DB'].' ';                
        }
        $ip_cliente=$_SERVER['REMOTE_ADDR'];
        $ip_servidor=$_SERVER['SERVER_ADDR'];
        $diferencia_ips=diferencia_ips($ip_servidor,$ip_cliente);
        if($diferencia_ips!=''){
            $mensaje_encabezado.='IP: '.$diferencia_ips;
        }
        $this->salida->enviar($mensaje_encabezado,'div_proceso_formulario_usuario_ip');
    }
    function probar_aplicacion(){
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
                        new Esquema_ipcba(),
                        new Tabla_tiempo_logico(),
                        new Tabla_http_user_agent(),
                        new Tabla_roles(),
                        new Tabla_bitacora(),
                    ) as $objeto_de_la_base)
                    {
                        $este->salida->enviar('instalando '.get_class($objeto_de_la_base));
                        $objeto_de_la_base->contexto=$este;
                        $objeto_de_la_base->ejecutar_instalacion();
                    }
                    foreach(array('../operaciones_ipcba/insercion_tabla_roles.sql',
                                  '../operaciones_ipcba/insercion_tabla_usuarios.sql',
                                  '../operaciones_ipcba/insercion_tabla_rol_rol.sql',
                                   ) as $archivo)
                    {
                        $este->db->ejecutar_sql(new Sql(str_replace(array('/*CAMPOS_AUDITORIA*/',"'eah2012',"),array(','.PRIMER_TLG,"'ipcba',"),file_get_contents($archivo))));
                    }
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
    function proceso_login(){
        return new Proceso_login_dual();
    }
    //Administración
    function proceso_Agregar_registro_en_NovObs(){
        return new Proceso_Agregar_registro_en_NovObs($this->periodos_abiertos_calculo_para_filtro('periodo'));
    }    
    function proceso_grilla_novobs () {
       $periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('periodo');
       return new Proceso_generico(array(
            'titulo'=>'Altas y bajas manuales del cálculo para campo',
            'permisos'=>array('grupo'=>'analista'),
            'submenu'=>'Administración',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'novobs_campo',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro)));
            }
        ));
    }
    function proceso_Agregar_registro_en_NovPre(){
        return new Proceso_Agregar_registro_en_NovPre($this->periodos_abiertos_calculo_para_filtro('periodo'));
    }
    function proceso_Agregar_registro_en_NovDelObs(){
        return new Proceso_Agregar_registro_en_NovDelObs($this->periodos_abiertos_calculo_para_filtro('periodo'));
    }
    function proceso_Agregar_registro_en_NovDelVis(){
        return new Proceso_Agregar_registro_en_NovDelVis($this->periodos_abiertos_calculo_para_filtro('periodo'));
    }
    function proceso_cierre_periodos(){
        return new Proceso_generico(array(
            'titulo'=>'Cierre de períodos',
            'permisos'=>array('grupo'=>'analista'),
            'submenu'=>'Administración',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'periodos',null,null,array('otras_opciones'=>array('agregando_filas_completas'=>false),'filtro_manual'=>array('ingresando'=>'S')));
            }
        ));
    }
    function proceso_control_diccionario(){  
        return new Proceso_control_diccionario();
    }
    function proceso_copiar_calculo(){
        return new Proceso_copiar_calculo();
    }
    function proceso_exportacion_tu_inflacion(){
        return new Proceso_exportacion_tu_inflacion();
    }        
    function proceso_ingresar_periodos(){
        return new Proceso_generico(array(
            'titulo'=>'Ingresar períodos',
            'permisos'=>array('grupo'=>'analista'),
            'submenu'=>'Administración',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'periodos',null,null,array('otras_opciones'=>array('agregando_filas_completas'=>true),'filtro_manual'=>array('ingresando'=>'S')));
                }
        ));
    }
    function proceso_tablero_control(){
        return new Proceso_tablero_control();
    }
    function proceso_cuadros(){
        return new Proceso_generico(array(
            'titulo'=>'Textos de los cuadros',
            'permisos'=>array('grupo'=>'coordinador'),
            'submenu'=>'Administración',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'cuadros');
            }
        ));
    } 
    function proceso_grilla_usuarios(){
        return new Proceso_generico(array(
            'titulo'=>'Usuarios',
            'permisos'=>array('grupo'=>'coordinador'),
            'submenu'=>'Administración',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'usuarios');
            }
        ));
    }
    //Canasta IPCBA    
    function proceso_grupos(){
        return new Proceso_generico(array(
            'titulo'=>'Grupos',
            'permisos'=>array('grupo'=>'coordinador'),
            'submenu'=>'Canasta del IPCBA',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'grupos', null,null,array('filtro_manual'=>array('esproducto'=>'N')));
            }
        ));
    }
    function proceso_productos(){
        return new Proceso_generico(array(
            'titulo'=>'Productos',
            'permisos'=>array('grupo'=>'coordinador','grupo1'=>'analista_cuadros', 'grupo2'=>'analista'),
            'submenu'=>'Canasta del IPCBA',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'productos');
            }
        ));
    }
    //Control para cierre
    function proceso_control_grupos_para_cierre(){
        return new Proceso_control_grupos_para_cierre();
    }
    function proceso_control_productos_para_cierre(){
        return new Proceso_control_productos_para_cierre();
    }
    //Gabinete
    function proceso_grilla_novprod(){
        $periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('periodoc2');
        return new Proceso_generico(array(
            'titulo'=>'Administración de Externos',
            'permisos'=>array('grupo'=>'analista'),
            'para_produccion'=>true,
            'submenu'=>'Gabinete',
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'novprod',       array(),false,array('otras_opciones'=>array('agregando_filas_completas'=>true),'filtro_manual'=>array('periodo'=>$periodos_para_filtro, 'calculo'=>'0')));
                //enviar_grilla($este->salida,'vista_calgru_vw',null  ,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro, 'calculo'=>'0', 'agrupacion'=>'Z')));
            }
        ));
    }
    function proceso_grilla_calculos () {
       //$periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('calculo');
       $periodos_para_filtro = '# > a2013m07';
       return new Proceso_generico(array(
            'titulo'=>'Cálculos',
            'permisos'=>array('grupo'=>'analista'),
            'submenu'=>'Gabinete',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'calculos',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro,'calculo'=>'# >0')));
            }
        ));
    }    
    function proceso_canasta_producto(){
        return new Proceso_canasta_producto();
    }
    function proceso_controlvigencias(){
        return new Proceso_controlvigencias();
    }
    function proceso_control_inconsistencias_atributos(){
        return new Proceso_control_inconsistencias_atributos();
    }
    function proceso_observaciones_inconsistencias_precios_ana(){  
        return new Proceso_observaciones_inconsistencias_precios_ana();
    }
    function proceso_observaciones_inconsistencias_precios_rec(){  
        return new Proceso_observaciones_inconsistencias_precios_rec();
    }
    function proceso_control_normalizables_sindato(){
        return new Proceso_control_normalizables_sindato();
    }
    function proceso_control_anulados_recep(){
        return new Proceso_control_anulados_recep();
    }
    function proceso_control_ingresados_calculo(){
        return new Proceso_control_ingresados_calculo();
    }
    function proceso_control_sinvariacion () {
       $periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('periodo');
       return new Proceso_generico(array(
            'titulo'=>'Control de Precios Sin variacion',
            'permisos'=>array('grupo'=>'analista'),
            'submenu'=>'Gabinete',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'vista_control_sinvariacion',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro)));
            }
        ));
    }
    function proceso_control_tipoprecio(){
        return new Proceso_control_tipoprecio();
    }
    function proceso_control_sinprecio () {
       $periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('periodo');
       return new Proceso_generico(array(
            'titulo'=>'Control de Tipo de Precio Sin existencia',
            'permisos'=>array('grupo'=>'analista'),
            'submenu'=>'Gabinete',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'vista_control_sinprecio',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro)));
            }
        ));
    }
    function proceso_control_relpre_1_sn(){
        return new Proceso_control_relpre_1_sn();
    }
    function proceso_grilla_moneda_extranjera () {
       $periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('calculo');
       return new Proceso_generico(array(
            'titulo'=>'Cotización Moneda Extranjera',
            'permisos'=>array('grupo'=>'analista'),
            'submenu'=>'Gabinete',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'relmon_periodos',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro, 'moneda'=>'# !=ARS')));
            }
        ));
    }
    function proceso_desvios(){
        return new Proceso_desvios();
    }
    function proceso_matriz_precios(){
        return new Proceso_matriz_precios();
    }
    function proceso_precios_porcentaje_positivos_y_anulados(){
        return new proceso_precios_porcentaje_positivos_y_anulados();
    }
    function proceso_preciosmaximos(){
        return new proceso_preciosmaximos();
    }
    function proceso_preciosminimos(){
        return new proceso_preciosminimos();
    }
    function proceso_proddivestimac(){
        return new Proceso_generico(array(
            'titulo'=>'Umbrales para Estimaciones',
            'permisos'=>array('grupo'=>'analista'),
            'submenu'=>'Gabinete',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'proddivestimac');
            }
        ));
    }    
    function proceso_variacionesmaximas(){
        return new proceso_variacionesmaximas();
    }
    function proceso_variacionesminimas(){
        return new proceso_variacionesminimas();
    }
    function proceso_vista_caldiv () {
       $periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('periodoc2');
       return new Proceso_generico(array(
            'titulo'=>'Vista de Caldiv',
            'permisos'=>array('grupo'=>'analista'),
            'submenu'=>'Gabinete',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'vista_caldiv_vw',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro, 'calculo'=>'0')));
            }
        ));
    }
    function proceso_vista_calgru () {
       $periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('periodoc2');
       return new Proceso_generico(array(
            'titulo'=>'Vista de Calgru',
            'permisos'=>array('grupo'=>'analista'),
            'submenu'=>'Gabinete',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'vista_calgru_vw',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro, 'calculo'=>'0', 'agrupacion'=>'Z')));
            }
        ));
    }
    function proceso_vista_control_comentariosrelvis () {
       $periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('periodo');
       return new Proceso_generico(array(
            'titulo'=>'Vista de control de comentarios por formulario',
            'permisos'=>array('grupo'=>'analista','grupo1'=>'jefe_campo'),
            'submenu'=>'Gabinete',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'vista_control_comentariosrelvis',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro)));
            }
        ));
    }
    function proceso_vista_control_comentariosrelpre () {
       $periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('periodo');
       return new Proceso_generico(array(
            'titulo'=>'Vista de control de comentarios por producto',
            'permisos'=>array('grupo'=>'analista','grupo1'=>'jefe_campo'),
            'submenu'=>'Gabinete',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'vista_control_comentariosrelpre',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro)));
            }
        ));
    }
    //Informantes
    function proceso_control_hojas_ruta(){
        return new Proceso_control_hojas_ruta();
    }
    function proceso_exportar_hojas_ruta(){
        return new Proceso_exportar_hojas_ruta();
    }
    function proceso_exportar_hojas_ruta_teorica(){
        return new Proceso_exportar_hojas_ruta_teorica();
    }
    function proceso_exportar_hdr_cierretemporal(){
        return new Proceso_exportar_hdr_cierretemporal();
    }
    function proceso_exportar_hdr_efectivossinprecio(){
        return new Proceso_exportar_hdr_efectivossinprecio();
    }
    function proceso_exportar_reemplazos(){
        return new Proceso_generico(array(
            'titulo'=>'Exportar Titulares-Reemplazos de Hoja de ruta',
            'permisos'=>array('grupo'=>'analista'),
            'submenu'=>'Informantes',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_exportar_reemplazos');
            }
        ));
    }
    function proceso_informantesaltasbajas(){
        return new Proceso_informantesaltasbajas();
    }
    function proceso_informantesformulario(){
        return new Proceso_informantesformulario();
    }
    function proceso_informantesrazon(){
        return new Proceso_informantesrazon();
    }
    function proceso_informantesrubro(){
        return new Proceso_informantesrubro();
    }    
    //Ingreso
    function proceso_control_online_campo(){
        return new Proceso_generico(array(
            'titulo'=>'Control de ingreso',
            'en_construccion'=>true,
            'permisos'=>array('grupo'=>'jefe_campo'),
            'submenu'=>'Ingreso',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_control_online_campo');
            }
        ));
    }
    function proceso_control_rangos(){
        return new Proceso_generico(array(
            'titulo'=>'Control de ingreso de precios',
            'en_construccion'=>true,
            'permisos'=>array('grupo'=>'jefe_campo'),
            'submenu'=>'Ingreso',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'tabla_control_rangos');
            }
        ));
    }
    function proceso_control_relev_telef(){
        return new Proceso_control_relev_telef();
    }
    function proceso_ingreso(){
        return new Proceso_ingreso();
    }
    function proceso_ingreso_formulario(){
        return new Proceso_ingreso_formulario();
    }
    //Recepcion
    function proceso_verificar_recepcion(){
        return new Proceso_verificar_recepcion();
    }
    function proceso_ficha_verificar_recepcion(){  
        return new Proceso_ficha_verificar_recepcion();
    }
    //Resultados
    function proceso_grilla_cuagru(){
        return new Proceso_generico(array(
            'titulo'=>'Grupos por cuadro',
            'permisos'=>array('grupo'=>'coordinador'),
            'para_produccion'=>true,
            'submenu'=>'Resultados',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'cuagru',array(),false,array('otras_opciones'=>array('agregando_filas_completas'=>true)));
            }
        ));
    }
    function proceso_cuadros_resultados(){
        return new Proceso_cuadros_resultados();
    }
    function proceso_freccambio(){
        return new Proceso_freccambio();
    }
    function proceso_freccambio_resto(){
        return new Proceso_freccambio_resto();
    }
    function proceso_resultados_elegidos(){  
        return new Proceso_resultados_elegidos();
    }    
    //Salida a campo
    function proceso_grilla_relenc(){
        return new Proceso_generico(array(
            'titulo'=>'Titulares de panel-tarea',
            'permisos'=>array('grupo'=>'jefe_campo'),
            'para_produccion'=>true,
            'submenu'=>'Salida a campo',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'relenc',array(),false,array('otras_opciones'=>array('agregando_filas_completas'=>true)));
            }
        ));
    }
    //Supervision
    function proceso_ejecutar_seleccionar_supervisiones(){
        return new Proceso_ejecutar_seleccionar_supervisiones();
    }
    function proceso_hojaderuta_supervisor(){
        return new Proceso_hojaderuta_supervisor();
    }
    function proceso_seleccionar_supervisiones(){
        return new Proceso_seleccionar_supervisiones();
    }
    function proceso_tabla_pantar () {
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            insert into cvp.pantar(panel, tarea)
              select distinct r.panel, r.tarea
                from cvp.relvis r left join cvp.pantar p on r.panel=p.panel and r.tarea= p.tarea
                where r.periodo>='a2014m01' and p.panel is null         
SQL
        ));
        return new Proceso_generico(array(
            'titulo'=>'Tamaño de supervisiones',
            'permisos'=>array('grupo'=>'jefe_campo'),
            'submenu'=>'Supervisiones',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'pantar',null,null,array('filtro_manual'=>array('activa'=>'S','operativo'=>'C'))); //de las tareas activas y de campo
            }
        ));
    }
    
    
    function proceso_ficha_producto(){  
        return new Proceso_ficha_producto();
    }
    function proceso_ficha_grupo(){  
        return new Proceso_ficha_grupo();
    }
    function periodos_abiertos_calculo_para_filtro($contexto) {
       $ultimo_periodo_abierto="";
       $contador=0; 
       $todos_periodos_abiertos="# =";
       if ($contexto == 'calculo') {
               
         $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
         SELECT periodo as ultimo FROM calculos where calculo=0 and abierto='S' order by periodo 
SQL
        ));
       }
       if ($contexto == 'periodo') {
               
         $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
         SELECT periodo as ultimo FROM periodos where ingresando='S' order by periodo 
SQL
        ));
       }
       if ($contexto == 'periodoc2') {
       
          $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
           SELECT case when min(periodo) is not null then min(periodo) else (select max(periodo) from calculos where calculo=0) end  as ultimo
             FROM calculos  WHERE abierto='S' and calculo=0
SQL
        ));
       }        
       while($fila=$cursor->fetchObject()){ 
           $contador=$contador+1;
           $ultimo_periodo_abierto=$fila->ultimo;
           if ($todos_periodos_abiertos=="# =" ) {
              $todos_periodos_abiertos=$todos_periodos_abiertos.$ultimo_periodo_abierto;
           }
           else{
             $todos_periodos_abiertos=$todos_periodos_abiertos.'| ='.$ultimo_periodo_abierto;
           }
       }
       if ($contador==1) {
          $todos_periodos_abiertos=$ultimo_periodo_abierto;
       }
    return $todos_periodos_abiertos;       
    }
    function proceso_grilla_novpre () {
       $periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('periodo');
       return new Proceso_generico(array(
            'titulo'=>'Ver anulación de precios',
            'permisos'=>array('grupo'=>'analista'),
            'submenu'=>'Gabinete',
            'para_produccion'=>false,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'novpre',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro)));
            }
        ));
    }
    function scripts_a_probar(){
        return array_merge(parent::scripts_a_probar(),array('../tedede/tedede_cm_pr.js','../ipcba/para_cuadros_pr.js'));
    }
    function proceso_generar_periodo(){
        return new Proceso_generar_periodo();
    }
    function proceso_generar_panel(){
        return new Proceso_generar_panel();
    }
    function proceso_guardar_relpre(){
        return new Proceso_guardar_relpre();
    }
    function proceso_guardar_relatr(){
        return new Proceso_guardar_relatr();
    }
    function proceso_guardar_relvis(){
        return new Proceso_guardar_relvis();
    }
    function proceso_relpan(){
        return new Proceso_relpan();
    }
}

if(!isset($no_ejecutar_aplicacion)){
    Aplicacion::correr(new Aplicacion_ipcba());
}
?>