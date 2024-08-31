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
    //-------------------------------------------------------------------------------------------------------------
    function proceso_Agregar_registro_en_NovObs(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_Agregar_registro_en_NovObs($this->periodos_abiertos_calculo_para_filtro('periodo'));
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Altas y bajas manuales del cálculo',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_Agregar_registro_en_NovObs($this->periodos_abiertos_calculo_para_filtro('periodo'));
            }
        ));
      }
    }    
    function proceso_grilla_novobs () {
       $periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('periodo');
       if($GLOBALS['aplicacion_completa']) {
         $permisos = array('grupo'=>'analista');
         $submenu = 'Administración';
       } else {
         $permisos = array();
         $submenu = PROCESO_INTERNO;
       }
       return new Proceso_generico(array(
            'titulo'=>'Altas y bajas manuales del cálculo para campo',
            'permisos'=>$permisos,
            'submenu'=>$submenu,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'novobs_campo',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro)));
            }
        ));
    }
    function proceso_Agregar_registro_en_NovPre(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_Agregar_registro_en_NovPre($this->periodos_abiertos_calculo_para_filtro('periodo'));
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Anulación de precios',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_Agregar_registro_en_NovPre($this->periodos_abiertos_calculo_para_filtro('periodo'));
            }
        ));
      }
    }
    function proceso_Agregar_registro_en_NovDelObs(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_Agregar_registro_en_NovDelObs($this->periodos_abiertos_calculo_para_filtro('periodo'));
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Borrar observaciones',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_Agregar_registro_en_NovDelObs($this->periodos_abiertos_calculo_para_filtro('periodo'));
            }
        ));
      }
    }
    function proceso_Agregar_registro_en_NovDelVis(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_Agregar_registro_en_NovDelVis($this->periodos_abiertos_calculo_para_filtro('periodo'));
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Borrar visitas',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_Agregar_registro_en_NovDelVis($this->periodos_abiertos_calculo_para_filtro('periodo'));
            }
        ));
      }
    }
    function proceso_cierre_periodos(){
        if($GLOBALS['aplicacion_completa']) {
          $permisos = array('grupo'=>'analista');
          $submenu = 'Administración';
        } else {
          $permisos = array();
          $submenu = PROCESO_INTERNO;
        }
        return new Proceso_generico(array(
            'titulo'=>'Cierre de períodos',
            'permisos'=>$permisos,
            'submenu'=>$submenu,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'periodos',null,null,array('otras_opciones'=>array('agregando_filas_completas'=>false),'filtro_manual'=>array('ingresando'=>'S')));
            }
        ));
    }
    function proceso_control_diccionario(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_control_diccionario();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Control del diccionario Valores de Atributos',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_control_diccionario();
            }
        ));
      }
    }
    function proceso_copiar_calculo(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_copiar_calculo();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Copia del cálculo',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_copiar_calculo();
            }
        ));
      }
    }
    function proceso_exportacion_tu_inflacion(){
      if ($GLOBALS['operativo']=='ipcba11/12'){
       return new Proceso_generico(array(
            'titulo'=>'Exportación a tu inflación',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                $este->salida->enviar('Opción de menú no aplicable');
            }
        ));
      }
      else {
        return new Proceso_exportacion_tu_inflacion();
      }
    }
    function proceso_ingresar_periodos(){
        if($GLOBALS['aplicacion_completa']) {
          $permisos = array('grupo'=>'analista');
          $submenu = 'Administración';
        } else {
          $permisos = array();
          $submenu = PROCESO_INTERNO;
        }
        return new Proceso_generico(array(
            'titulo'=>'Ingresar períodos',
            'permisos'=>$permisos,
            'submenu'=>$submenu,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'periodos',null,null,array('otras_opciones'=>array('agregando_filas_completas'=>true),'filtro_manual'=>array('ingresando'=>'S')));
                }
        ));
    }
    function proceso_tablero_control(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_tablero_control();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Tablero de Control',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_tablero_control();
            }
        ));
      }
    }
    function proceso_cuadros(){
        return new Proceso_generico(array(
            'titulo'=>'Textos de los cuadros',
            'permisos'=>array('grupo'=>'coordinador'),
            'submenu'=>'Administración',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'cuadros',array('activo'=>'S'));
            }
        ));
    } 
    function proceso_grilla_usuarios(){
        if($GLOBALS['aplicacion_completa']) {
          $permisos = array('grupo'=>'coordinador');
          $submenu = 'Administración';
        } else {
          $permisos = array();
          $submenu = PROCESO_INTERNO;
        }
        return new Proceso_generico(array(
            'titulo'=>'Usuarios',
            'permisos'=>$permisos,
            'submenu'=>$submenu,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'usuarios');
            }
        ));
    }
    //Canasta IPCBA    
    //-------------------------------------------------------------------------------------------------------------
    function proceso_grupos(){
        if($GLOBALS['aplicacion_completa']) {
          $permisos = array('grupo'=>'coordinador');
          $submenu = 'Canasta del IPCBA';
        } else {
          $permisos = array();
          $submenu = PROCESO_INTERNO;
        }
        return new Proceso_generico(array(
            'titulo'=>'Grupos',
            'permisos'=>$permisos,
            'submenu'=>$submenu,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'grupos', null,null,array('filtro_manual'=>array('esproducto'=>'N')));
            }
        ));
    }
    function proceso_productos(){
        if($GLOBALS['aplicacion_completa']) {
          $permisos = array('grupo'=>'coordinador','grupo1'=>'analista_cuadros', 'grupo2'=>'analista');
          $submenu = 'Canasta del IPCBA';
        } else {
          $permisos = array();
          $submenu = PROCESO_INTERNO;
        }
        return new Proceso_generico(array(
            'titulo'=>'Productos',
            'permisos'=>$permisos,
            'submenu'=>$submenu,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'productos');
            }
        ));
    }
    //Control para cierre
    function proceso_control_grupos_para_cierre(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_control_grupos_para_cierre();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Control de grupos',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_control_grupos_para_cierre();
            }
        ));
      }
    }
    function proceso_control_productos_para_cierre(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_control_productos_para_cierre();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Control de productos',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_control_productos_para_cierre();
            }
        ));
      }
    }
    //Gabinete
    //-------------------------------------------------------------------------------------------------------------
    function proceso_grilla_novprod(){
        $periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('periodoc2');
        if($GLOBALS['aplicacion_completa']) {
          $permisos = array('grupo'=>'analista');
          $submenu = 'Gabinete';
        } else {
          $permisos = array();
          $submenu = PROCESO_INTERNO;
        }
        return new Proceso_generico(array(
            'titulo'=>'Administración de Externos',
            'permisos'=>$permisos,
            'para_produccion'=>true,
            'submenu'=>$submenu,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'novprod',       array(),false,array('otras_opciones'=>array('agregando_filas_completas'=>true),'filtro_manual'=>array('periodo'=>$periodos_para_filtro, 'calculo'=>'0')));
                //enviar_grilla($este->salida,'vista_calgru_vw',null  ,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro, 'calculo'=>'0', 'agrupacion'=>'Z')));
            }
        ));
    }
    function proceso_grilla_calculos () {
       //$periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('calculo');
       $periodos_para_filtro = '# > a2013m07';
       if($GLOBALS['aplicacion_completa']) {
         $permisos = array('grupo'=>'analista');
         $submenu = 'Gabinete';
       } else {
         $permisos = array();
         $submenu = PROCESO_INTERNO;
       }
       return new Proceso_generico(array(
            'titulo'=>'Cálculos',
            'permisos'=>$permisos,
            'submenu'=>$submenu,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'calculos',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro,'calculo'=>'# >0')));
            }
        ));
    }    
    function proceso_canasta_producto(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_canasta_producto();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Canasta por Producto',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_canasta_producto();
            }
        ));
      }
    }
    function proceso_controlvigencias(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_controlvigencias();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Control de atributo vigencia',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_controlvigencias();
            }
        ));
      }
    }
    function proceso_control_inconsistencias_atributos(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_control_inconsistencias_atributos();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Control de Inconsistencias de Atributos',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_control_inconsistencias_atributos();
            }
        ));
      }
    }
    function proceso_observaciones_inconsistencias_precios_ana(){  
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_observaciones_inconsistencias_precios_ana();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Control de Inconsistencias de Precios Análisis',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_observaciones_inconsistencias_precios_ana();
            }
        ));
      }
    }
    function proceso_observaciones_inconsistencias_precios_rec(){  
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_observaciones_inconsistencias_precios_rec();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Control de Inconsistencias de Precios Recepción',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_observaciones_inconsistencias_precios_rec();
            }
        ));
      }
    }
    function proceso_control_normalizables_sindato(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_control_normalizables_sindato();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Control de Normalizables sin dato',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_control_normalizables_sindato();
            }
        ));
      }
    }
    function proceso_control_anulados_recep(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_control_anulados_recep();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Control de precios Anulados en Recepción',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_control_anulados_recep();
            }
        ));
      }
    }
    function proceso_control_ingresados_calculo(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_control_ingresados_calculo();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Control de Precios ingresados que no entran al calculo',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_control_ingresados_calculo();
            }
        ));
      }
    }
    function proceso_control_sinvariacion () {
       $periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('periodo');
       if($GLOBALS['aplicacion_completa']) {
         $permisos = array('grupo'=>'analista');
         $submenu = 'Gabinete';
       } else {
         $permisos = array();
         $submenu = PROCESO_INTERNO;
       }
       return new Proceso_generico(array(
            'titulo'=>'Control de Precios Sin variacion',
            'permisos'=>$permisos,
            'submenu'=>$submenu,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'vista_control_sinvariacion',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro)));
            }
        ));
    }
    function proceso_control_tipoprecio(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_control_tipoprecio();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Control de Tipos de Precio',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_control_tipoprecio();
            }
        ));
      }
    }
    function proceso_control_sinprecio () {
       $periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('periodo');
       if($GLOBALS['aplicacion_completa']) {
         $permisos = array('grupo'=>'analista');
         $submenu = 'Gabinete';
       } else {
         $permisos = array();
         $submenu = PROCESO_INTERNO;
       }
       return new Proceso_generico(array(
            'titulo'=>'Control de Tipo de Precio Sin existencia',
            'permisos'=>$permisos,
            'submenu'=>$submenu,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'vista_control_sinprecio',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro)));
            }
        ));
    }
    function proceso_control_relpre_1_sn(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_control_relpre_1_sn();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Control de Tipo de Precio Sin existencia/No vende',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_control_relpre_1_sn();
            }
        ));
      }
    }
    function proceso_grilla_moneda_extranjera () {
       $periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('calculo');
       if($GLOBALS['aplicacion_completa']) {
         $permisos = array('grupo'=>'analista');
         $submenu = 'Gabinete';
       } else {
         $permisos = array();
         $submenu = PROCESO_INTERNO;
       }
       return new Proceso_generico(array(
            'titulo'=>'Cotización Moneda Extranjera',
            'permisos'=>$permisos,
            'submenu'=>$submenu,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'relmon_periodos',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro, 'moneda'=>'# !=ARS')));
            }
        ));
    }
    function proceso_desvios(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_desvios();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Desvios de los productos publicados',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_desvios();
            }
        ));
      }
    }
    function proceso_matriz_precios(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_matriz_precios();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Matriz de precios',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_matriz_precios();
            }
        ));
      }
    }
    function proceso_precios_porcentaje_positivos_y_anulados(){
      if ($GLOBALS['aplicacion_completa']){
        return new proceso_precios_porcentaje_positivos_y_anulados();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Porcentajes de potenciales y positivos por formulario',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new proceso_precios_porcentaje_positivos_y_anulados();
            }
        ));
      }
    }
    function proceso_preciosmaximos(){
      if ($GLOBALS['aplicacion_completa']){
        return new proceso_preciosmaximos();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Precios máximos',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new proceso_preciosmaximos();
            }
        ));
      }
    }
    function proceso_preciosminimos(){
      if ($GLOBALS['aplicacion_completa']){
        return new proceso_preciosminimos();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Precios mínimos',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new proceso_preciosminimos();
            }
        ));
      }
    }
    function proceso_proddivestimac(){
        if($GLOBALS['aplicacion_completa']) {
          $permisos = array('grupo'=>'analista');
          $submenu = 'Gabinete';
        } else {
          $permisos = array();
          $submenu = PROCESO_INTERNO;
        }
        return new Proceso_generico(array(
            'titulo'=>'Umbrales para Estimaciones',
            'permisos'=>$permisos,
            'submenu'=>$submenu,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'proddivestimac');
            }
        ));
    }    
    function proceso_variacionesmaximas(){
      if ($GLOBALS['aplicacion_completa']){
        return new proceso_variacionesmaximas();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Variaciones máximas',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new proceso_variacionesmaximas();
            }
        ));
      }
    }
    function proceso_variacionesminimas(){
      if ($GLOBALS['aplicacion_completa']){
        return new proceso_variacionesminimas();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Variaciones mínimas',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new proceso_variacionesminimas();
            }
        ));
      }
    }
    function proceso_vista_caldiv () {
       $periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('periodoc2');
        if($GLOBALS['aplicacion_completa']) {
          $permisos = array('grupo'=>'analista');
          $submenu = 'Gabinete';
        } else {
          $permisos = array();
          $submenu = PROCESO_INTERNO;
        }
       return new Proceso_generico(array(
            'titulo'=>'Vista de Caldiv',
            'permisos'=>$permisos,
            'submenu'=>$submenu,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'vista_caldiv_vw',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro, 'calculo'=>'0')));
            }
        ));
    }
    function proceso_vista_calgru () {
       $periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('periodoc2');
        if($GLOBALS['aplicacion_completa']) {
          $permisos = array('grupo'=>'analista');
          $submenu = 'Gabinete';
        } else {
          $permisos = array();
          $submenu = PROCESO_INTERNO;
        }
       return new Proceso_generico(array(
            'titulo'=>'Vista de Calgru',
            'permisos'=>$permisos,
            'submenu'=>$submenu,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'vista_calgru_vw',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro, 'calculo'=>'0', 'agrupacion'=>'Z')));
            }
        ));
    }
    function proceso_vista_control_comentariosrelvis () {
       $periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('periodo');
        if($GLOBALS['aplicacion_completa']) {
          $permisos = array('grupo'=>'analista','grupo1'=>'jefe_campo');
          $submenu = 'Gabinete';
        } else {
          $permisos = array();
          $submenu = PROCESO_INTERNO;
        }
       return new Proceso_generico(array(
            'titulo'=>'Vista de control de comentarios por formulario',
            'permisos'=>$permisos,
            'submenu'=>$submenu,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'vista_control_comentariosrelvis',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro)));
            }
        ));
    }
    function proceso_vista_control_comentariosrelpre () {
       $periodos_para_filtro = $this->periodos_abiertos_calculo_para_filtro('periodo');
        if($GLOBALS['aplicacion_completa']) {
          $permisos = array('grupo'=>'analista','grupo1'=>'jefe_campo');
          $submenu = 'Gabinete';
        } else {
          $permisos = array();
          $submenu = PROCESO_INTERNO;
        }
       return new Proceso_generico(array(
            'titulo'=>'Vista de control de comentarios por producto',
            'permisos'=>$permisos,
            'submenu'=>$submenu,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'vista_control_comentariosrelpre',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro)));
            }
        ));
    }
    //Informantes
    //-------------------------------------------------------------------------------------------------------------
    function proceso_control_hojas_ruta(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_control_hojas_ruta();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Control de Hoja de ruta',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_control_hojas_ruta();
            }
        ));
      }
    }
    function proceso_exportar_hojas_ruta(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_exportar_hojas_ruta();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Exportar Hoja de ruta',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_exportar_hojas_ruta();
            }
        ));
      }
    }
    function proceso_exportar_hojas_ruta_teorica(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_exportar_hojas_ruta_teorica();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Exportar Hoja de ruta teórica',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_exportar_hojas_ruta_teorica();
            }
        ));
      }
    }
    function proceso_exportar_hdr_cierretemporal(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_exportar_hdr_cierretemporal();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Exportar Hoja de ruta Cierre Temporal',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_exportar_hdr_cierretemporal();
            }
        ));
      }
    }
    function proceso_exportar_hdr_efectivossinprecio(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_exportar_hdr_efectivossinprecio();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Exportar Hoja de ruta Efectivos Sin Precio',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_exportar_hdr_efectivossinprecio();
            }
        ));
      }
    }
    function proceso_exportar_reemplazos(){
        if($GLOBALS['aplicacion_completa']) {
          $permisos = array('grupo'=>'analista');
          $submenu = 'Informantes';
        } else {
          $permisos = array();
          $submenu = PROCESO_INTERNO;
        }
        return new Proceso_generico(array(
            'titulo'=>'Exportar Titulares-Reemplazos de Hoja de ruta',
            'permisos'=>$permisos,
            'submenu'=>$submenu,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_exportar_reemplazos');
            }
        ));
    }
    function proceso_informantesaltasbajas(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_informantesaltasbajas();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Informantes Altas y Bajas',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_informantesaltasbajas();
            }
        ));
      }
    }
    function proceso_informantesformulario(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_informantesformulario();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Informantes por Formulario',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_informantesformulario();
            }
        ));
      }
    }
    function proceso_informantesrazon(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_informantesrazon();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Informantes por Razon',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_informantesrazon();
            }
        ));
      }
    }
    function proceso_informantesrubro(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_informantesrubro();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Informantes por Rubro',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_informantesrubro();
            }
        ));
      }
    }    
    //Ingreso
    //-------------------------------------------------------------------------------------------------------------
    function proceso_control_online_campo(){
        if($GLOBALS['aplicacion_completa']) {
          $permisos = array('grupo'=>'jefe_campo');
          $submenu = 'Ingreso';
        } else {
          $permisos = array();
          $submenu = PROCESO_INTERNO;
        }
        return new Proceso_generico(array(
            'titulo'=>'Control de ingreso',
            'en_construccion'=>true,
            'permisos'=>$permisos,
            'submenu'=>$submenu,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_control_online_campo');
            }
        ));
    }
    function proceso_control_rangos(){
        if($GLOBALS['aplicacion_completa']) {
          $permisos = array('grupo'=>'jefe_campo');
          $submenu = 'Ingreso';
        } else {
          $permisos = array();
          $submenu = PROCESO_INTERNO;
        }
        return new Proceso_generico(array(
            'titulo'=>'Control de ingreso de precios',
            'en_construccion'=>true,
            'permisos'=>$permisos,
            'submenu'=>$submenu,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'tabla_control_rangos');
            }
        ));
    }
    function proceso_control_relev_telef(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_control_relev_telef();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Control de Relevamiento telefónico',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_control_relev_telef();
            }
        ));
      }
    }
    function proceso_ingreso(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_ingreso();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Ingreso',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_ingreso();
            }
        ));
      }
    }
    function proceso_ingreso_formulario(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_ingreso_formulario();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Ingreso de formularios',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_ingreso_formulario();
            }
        ));
      }
    }
    //Recepcion
    //-------------------------------------------------------------------------------------------------------------
    function proceso_verificar_recepcion(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_verificar_recepcion();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Verificar Recepción',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_verificar_recepcion();
            }
        ));
      }
    }
    function proceso_ficha_verificar_recepcion(){  
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_ficha_verificar_recepcion();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Ficha verificar recepción',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_ficha_verificar_recepcion();
            }
        ));
      }
    }
    //Resultados
    //-------------------------------------------------------------------------------------------------------------
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
    function proceso_cuadros_canastas_externas(){
      if ($GLOBALS['operativo']=='ipcba11/12'){
       return new Proceso_cuadros_canastas_externas();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Cuadros canastas externas Marzo 2022- Junio 2022',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                $este->salida->enviar('Opción de menú no aplicable');
            }
        ));
      }
    }
    function proceso_freccambio(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_freccambio();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Frecuencia de cambio',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_freccambio();
            }
        ));
      }
    }
    function proceso_freccambio_resto(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_freccambio_resto();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Frecuencia de cambio Resto IPCBA (general y restricto)',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_freccambio_resto();
            }
        ));
      }
    }
    function proceso_resultados_elegidos(){  
        return new Proceso_resultados_elegidos();
    }    
    //Salida a campo
    //-------------------------------------------------------------------------------------------------------------
    function proceso_grilla_relenc(){
         if($GLOBALS['aplicacion_completa']) {
           $permisos = array('grupo'=>'jefe_campo');
           $submenu = 'Salida a campo';
         } else {
           $permisos = array();
           $submenu = PROCESO_INTERNO;
         }
         return new Proceso_generico(array(
             'titulo'=>'Titulares de panel-tarea',
             'permisos'=>$permisos,
             'para_produccion'=>true,
             'submenu'=>$submenu,
             'funcion'=>function(Procesos $este){
                 enviar_grilla($este->salida,'relenc',array(),false,array('otras_opciones'=>array('agregando_filas_completas'=>true)));
             }
         ));
     }
    //Supervision
    //-------------------------------------------------------------------------------------------------------------
    function proceso_ejecutar_seleccionar_supervisiones(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_ejecutar_seleccionar_supervisiones();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Correr el algoritmo de selección',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_ejecutar_seleccionar_supervisiones();
            }
        ));
      }
    }
    function proceso_hojaderuta_supervisor(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_hojaderuta_supervisor();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Hoja de ruta del supervisor',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_hojaderuta_supervisor();
            }
        ));
      }
    }
    function proceso_seleccionar_supervisiones(){
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_seleccionar_supervisiones();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Seleccionar',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_seleccionar_supervisiones();
            }
        ));
      }
    }
    function proceso_tabla_pantar () {
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            insert into cvp.pantar(panel, tarea)
              select distinct r.panel, r.tarea
                from cvp.relvis r left join cvp.pantar p on r.panel=p.panel and r.tarea= p.tarea
                where r.periodo>='a2014m01' and p.panel is null         
SQL
        ));
         if($GLOBALS['aplicacion_completa']) {
           $permisos = array('grupo'=>'jefe_campo');
           $submenu = 'Supervisiones';
         } else {
           $permisos = array();
           $submenu = PROCESO_INTERNO;
         }
        return new Proceso_generico(array(
            'titulo'=>'Tamaño de supervisiones',
            'permisos'=>$permisos,
            'submenu'=>$submenu,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'pantar',null,null,array('filtro_manual'=>array('activa'=>'S','operativo'=>'C'))); //de las tareas activas y de campo
            }
        ));
    }
    function proceso_ficha_producto(){  
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_ficha_producto();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Ficha de producto',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_ficha_producto();
            }
        ));
      }
    }
    function proceso_ficha_grupo(){  
      if ($GLOBALS['aplicacion_completa']){
        return new Proceso_ficha_grupo();
      }
      else {
       return new Proceso_generico(array(
            'titulo'=>'Ficha de grupo',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                return new Proceso_ficha_grupo();
            }
        ));
      }
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
       if($GLOBALS['aplicacion_completa']) {
         $permisos = array('grupo'=>'analista');
         $submenu = 'Gabinete';
       } else {
         $permisos = array();
         $submenu = PROCESO_INTERNO;
       }
       return new Proceso_generico(array(
            'titulo'=>'Ver anulación de precios',
            'permisos'=>$permisos,
            'submenu'=>$submenu,
            'para_produccion'=>false,
            'funcion'=>function(Procesos $este) use ($periodos_para_filtro){
                enviar_grilla($este->salida,'novpre',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro)));
            }
        ));
    }
    function scripts_a_probar(){
        return array_merge(parent::scripts_a_probar(),array('../tedede/tedede_cm_pr.js','../ipcba/para_cuadros_pr.js'));
    }
    //function proceso_generar_periodo(){
    //    return new Proceso_generar_periodo();
    //}
    //function proceso_generar_panel(){
    //    return new Proceso_generar_panel();
    //}
    //function proceso_guardar_relpre(){
    //    return new Proceso_guardar_relpre();
    //}
    //function proceso_guardar_relatr(){
    //    return new Proceso_guardar_relatr();
    //}
    //function proceso_guardar_relvis(){
    //    return new Proceso_guardar_relvis();
    //}
    //function proceso_relpan(){
    //    return new Proceso_relpan();
    //}

    // Redefino procesos heredados como PROCESO_INTERNO, no aparecerán las opciones de menú para usuarios no programadores
    function proceso_mandar_nueva_clave(){
        return new Proceso_generico(array(
            'titulo'=>'Mandar mail con nueva clave',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                $este->salida->enviar('Opción de menú discontinua');
            }
        ));
    }
    function proceso_ingresar_usuario(){
        return new Proceso_generico(array(
            'titulo'=>'Pedir una cuenta para un usuario nuevo',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                $este->salida->enviar('Opción de menú discontinua');
            }
        ));
    }
    function proceso_cambio_de_clave(){
        return new Proceso_generico(array(
            'titulo'=>'Cambiar mi clave de acceso',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                $este->salida->enviar('Opción de menú discontinua');
            }
        ));
    }
    function proceso_mis_datos_personales(){
        return new Proceso_generico(array(
            'titulo'=>'Mis datos personales',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                $este->salida->enviar('Opción de menú discontinua');
            }
        ));
    }
    function proceso_ambiente_prueba(){
        return new Proceso_generico(array(
            'titulo'=>'Control del ambiente de prueba',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                $este->salida->enviar('Opción de menú discontinua');
            }
        ));
    }    
    function proceso_adaptacion_estructura(){
        return new Proceso_generico(array(
            'titulo'=>'Adaptación de estructura de la base de datos',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                $este->salida->enviar('Opción de menú discontinua');
            }
        ));
    }
    function proceso_probar_todo(){
        return new Proceso_generico(array(
            'titulo'=>'Correr casos de prueba sin instalar',
            'permisos'=>array(),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                $este->salida->enviar('Opción de menú discontinua');
            }
        ));
    }
    // fin Redefino procesos heredados como PROCESO_INTERNO
}

if(!isset($no_ejecutar_aplicacion)){
    Aplicacion::correr(new Aplicacion_ipcba());
}
?>