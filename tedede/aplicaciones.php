<?php
// UTF-8:Sí
/* Una aplicación es un .php que puede llamarse desde el navegador
   una aplicación tiene una salida y más adelante tendrá su propia conexión a la base de datos
*/
session_start();
require_once "lo_imprescindible.php";
require_once "comunes.php";
require_once "contextos.php";
require_once "para_parametros_con_nombre.php";
require_once "procesos.php";
require_once "armador_de_salida.php";
require_once "pdo_con_excepciones.php";

class Parametros_App{
}

class Parametro_Armando_Menu extends Parametros_App{
}

abstract class Aplicacion extends Contexto{
    public $salida; // armador de salida
    private $opcion_de_menu;
    protected $proceso_def='menu';
    function __construct(){
        //$this->contexto = new Contexto();
        global $db,$esta_es_la_base_en_produccion;
        if(!$this->salida){
            $this->salida=new Armador_de_salida();
        }
        $this->db=$db; // OJO GLOBAL (por ahora)
        // Para cambiar el color de fondo ponerlo en configuracion_local.php
        $this->salida->color_fondo=(@$GLOBALS['color_de_fondo_de_la_aplicacion'])?:'#FDE'; // NO CAMBIAR ACÁ EL COLOR ESTE ES EL ROSA DE PRUEBA
        $this->salida->img_fondo=(
            @$GLOBALS['img_de_fondo_de_la_aplicacion']
        )?:( $esta_es_la_base_en_produccion?
             '':
             ( strpos(__DIR__,'alserver_')===false?
               '../tedede/desa_fondo_t.png':
               ( strpos(__DIR__,'_capa')===false?
                 '../tedede/test_fondo_t.png':
                 '../tedede/capacitacion.png); background-size:235px 235px; other:('
                )
             )
        ); 
    }
    function mostrar_titulo($proceso=false){
        $destino_principal=$GLOBALS['nombre_app'].'.php';
        $this->salida->abrir_grupo_interno('');
            $this->salida->abrir_grupo_link('',$destino_principal);
                $this->salida->enviar_imagen("../{$GLOBALS['nombre_app']}/logo_app.png",'logo_principal no_imprimir',array('id'=>'logo_principal'));
            $this->salida->cerrar_grupo_interno();
        $this->salida->cerrar_grupo_interno();
    }
    final protected function definir_parte($parametros){
        controlar_parametros($parametros,array(
            'titulo'=>array('obligatorio'=>true, 'validar'=>'is_string'),
            'permisos'=>null,
            'submenu'=>null,
            'parametros_app'=>null
        ));
        if($parametros->parametros_app instanceof Parametro_Armando_Menu){
            $this->salida->enviar_link($parametros->titulo,'app_menu',$this->nombre_del_php."?hacer={$this->opcion_de_menu}");
            throw new Exception_Applicacion_Interrupcion_Controlada();
        }else{
        }
    }
    final private function obtener_proceso($nombre_de_proceso,$incluye_prefijo){
        global $db;
        if($incluye_prefijo){
            $nombre_metodo=$nombre_de_proceso;
            $nombre_de_proceso=substr($nombre_de_proceso,strlen(self::PREFIJO_PROCESO));
        }else{
            $nombre_metodo=self::PREFIJO_PROCESO.$nombre_de_proceso;
        }
        $proceso=$this->$nombre_metodo();
        $proceso->nombre=$nombre_de_proceso;
        $proceso->salida=$this->salida;
        $proceso->db=$db; // OJO GLOBAL (por ahora)
        $proceso->app=$this;
        $proceso->post_constructor();
        return $proceso;
    }
    const PREFIJO_PROCESO='proceso_';
    final private function obtener_procesos(){
        $arr=array();
        foreach(get_class_methods(get_class($this)) as $nombre_metodo){
            if(empieza_con($nombre_metodo,'proceso_')){
                $arr[]=$this->obtener_proceso($nombre_metodo,true);
            }
        }
        return $arr;
    }
    abstract function obtener_titulo();
    private function permisos_habilitados($permisos_a_validar){
        $tabla_rol_rol = $this->nuevo_objeto('Tabla_rol_rol');
        if($permisos_a_validar){
            foreach($permisos_a_validar as $permiso_singular){
                if(tiene_rol('programador') || tiene_rol($permiso_singular)){ 
                    return true;
                }
            }
            return false;
        }
        return true;
    }
    function armar_menu(){
        global $esta_es_la_base_en_produccion,$esta_es_la_base_de_capacitacion;
        unset($_SESSION['ir_despues_de_loguearse '.$GLOBALS['nombre_app']]);
        $tit_modo_encuesta= substr($GLOBALS['nombre_app'],0,3)=='eah'&& $GLOBALS['anio_operativo']>=2015 &&(tiene_rol('programador')|| tiene_rol('procesamiento'))?$_SESSION['modo_encuesta']:'';/* $_SESSION['modo_encuesta'];*/
        $tit_tele_etoi=isset($GLOBALS['es_tele_etoi'])&& $GLOBALS['es_tele_etoi']==true? ' **TELE_ETOI**':'';
        $parametro_indicando_Parametro_Armando_Menu=new Parametro_Armando_Menu();
        $this->mostrar_titulo();
        $desplegar_menu=array();
        // Asignando acá los array vacíos se determina un primer orden
        $desplegar_menu['produccion']=array();
        $desplegar_menu['produccion']['principal']=array();
        if(!$esta_es_la_base_en_produccion){
            $desplegar_menu['prueba']=array();
        }
        foreach($this->obtener_procesos() as $proceso){
            controlar_parametros($proceso->parametros,array(
                'para_produccion'=>false,
                'submenu'=>false
            ),true);
            if( (!$esta_es_la_base_en_produccion && !$esta_es_la_base_de_capacitacion && tiene_rol('programador') 
                   || $proceso->parametros->para_produccion && $proceso->parametros->submenu!=PROCESO_INTERNO
                ) 
                && $proceso->parametros->submenu && $this->permisos_habilitados($proceso->parametros->permisos)
            ){
                $desplegar_menu[$proceso->parametros->para_produccion?'produccion':'prueba'][$proceso->parametros->submenu][]=$proceso;
            }
        }
        $contador_menu=1;
        foreach($desplegar_menu as $grupo_1=>$procesos_grupo_1){
            $this->salida->abrir_grupo_interno('div_app_menu_1');
            
                $this->salida->enviar($grupo_1=='produccion'?'Menú'.$tit_tele_etoi:'opciones de prueba','app_menu_1 app_menu');
                $this->salida->enviar($tit_modo_encuesta);
                $this->salida->abrir_grupo_interno('div_app_menu_1_in');
                    foreach($procesos_grupo_1 as $grupo_2=>$procesos_grupo_2){
                        $this->salida->abrir_grupo_interno('div_app_menu_2');
                            /*
                            $this->salida->abrir_grupo_interno('app_menu_2 app_menu');
                                $this->salida->enviar('','',array('tipo'=>'input','type'=>'checkbox'));
                                $this->salida->enviar($grupo_2,'',array('tipo'=>'span'));
                            $this->salida->cerrar_grupo_interno();
                            */
                            $contador_menu++;
                            $este_id='id_menu_'.$contador_menu;
                            $this->salida->enviar('','chk_menu',array('tipo'=>'input','type'=>'checkbox','checked'=>true,'id'=>$este_id));
                            $this->salida->enviar($grupo_2,'app_menu_2 app_menu',array('tipo'=>'label','for'=>$este_id));
                            $this->salida->abrir_grupo_interno('div_app_menu_2_in');
                                foreach($procesos_grupo_2 as $proceso){
                                    $this->salida->abrir_grupo_interno('div_app_menu');
                                        $this->salida->enviar_link($proceso->parametros->titulo,'app_menu app_menu_3',$this->nombre_del_php."?hacer={$proceso->nombre}");
                                        if($proceso->parametros->en_construccion){
                                            $this->salida->enviar_imagen("../imagenes/falta_programar.png");
                                        }
                                        if(tiene_rol('programador') && !$esta_es_la_base_en_produccion){
                                            $this->salida->enviar_info_expandible('ℙ','permisos: '.json_encode($proceso->parametros->permisos));
                                            $this->salida->enviar_info_expandible('R','roles: '.json_encode($_SESSION["{$GLOBALS['NOMBRE_APP']}_usu_todos_los_roles"]));
                                        }
                                    $this->salida->cerrar_grupo_interno();
                                }
                            $this->salida->cerrar_grupo_interno();
                        $this->salida->cerrar_grupo_interno();
                    }
                $this->salida->cerrar_grupo_interno();
            $this->salida->cerrar_grupo_interno();
        }
    }
    private function obtener_proceso_si_existe($hacer){
        $metodo="proceso_$hacer";
        if(method_exists($this,$metodo)){
            $proceso=$this->obtener_proceso($metodo,true);
            if(!$proceso instanceof Procesos){
                throw new Exception_Tedede("Error en la definicion de $metodo, debe crear un objeto de clase Proceso");
            }
            return $proceso;
        }else{
            return null;
        }
    }
    static function correr(Aplicacion $app){
        global $soy_un_ipad;
        $app->nombre_del_php=basename($_SERVER["SCRIPT_NAME"]);
        $modo_hacer=isset($_REQUEST['proceso'])?'proceso':(
                     isset($_REQUEST['hacer'])?'hacer':(
                      isset($_REQUEST['imprimir'])?'imprimir':(
                      isset($_REQUEST['post'])?'post':'error')));
        if(!isset($_REQUEST[$modo_hacer])){
            $nombre_proceso='error';
        }else{
            $nombre_proceso=$_REQUEST[$modo_hacer];
        }
        if($modo_hacer=='proceso'){
            if(!usuario_actual() && $nombre_proceso!='login' && $nombre_proceso!='mandar_nueva_clave'){
                $respuesta=new Respuesta_Negativa('DESCONECTADO');
            }else{
                try{
                    $proceso=$app->obtener_proceso_si_existe($nombre_proceso);
                    if(!$proceso){
                        $respuesta=new Respuesta_Negativa("No existe el proceso $nombre_proceso");
                    }else{
                        $proceso->argumentos=json_decode($_REQUEST['todo']);
                        if(isset($_REQUEST['voy_por']) && $_REQUEST['voy_por']){
                            $proceso->voy_por=json_decode($_REQUEST['voy_por']);
                        }
                        if(isset($_REQUEST['estado']) && $_REQUEST['estado']){
                            $proceso->estado=json_decode($_REQUEST['estado']);
                        }
                        if(@$proceso->argumentos->argumentos_posicionales){
                            $i=0;
                            foreach($proceso->parametros->parametros as $nombre=>$definicion){
                                $proceso->argumentos->{$nombre}=$proceso->argumentos->argumentos_posicionales[$i];
                                $i++;
                            }
                            unset($proceso->argumentos->argumentos_posicionales);
                        }
                        $bit_bit=null;
                        $tabla_bitacora=$app->nuevo_objeto("Tabla_bitacora");                        
                        if($proceso->parametros->bitacora){
                            $tabla_bitacora->valores_para_insert=array(
                                'bit_ope'=>$GLOBALS['NOMBRE_APP'],
                                'bit_proceso'=>$nombre_proceso,
                                'bit_parametros'=>$_REQUEST['todo'],
                            );                            
                            $tabla_bitacora->expresiones_returning=array('bit_bit');
                            $tabla_bitacora->ejecutar_insercion();
                            $bit_bit=$tabla_bitacora->retorno->bit_bit;
                        }
                        $proceso->validar_argumentos();
                        Loguear('2012-11-19','Nombre del proceso '.$nombre_proceso.'/'.$bit_bit);
                        $respuesta=$proceso->responder();
                    }
                }catch(Exception $err){
                    global $esta_es_la_base_en_produccion;
                    $respuesta=new Respuesta_Negativa('ERROR: '.$err->getMessage().($esta_es_la_base_en_produccion?'':' '.aplanar_trace($err->getTrace())));
                    if($app->db->inTransaction()){
                        $app->db->rollBack();
                    }
                }
                if($proceso && $proceso->parametros->bitacora && $bit_bit!==null){
                    $tabla_bitacora->valores_para_update=array( 
                        'bit_resultado'=>json_encode($respuesta->obtener_mensaje()),
                        'bit_fin'=>array('expresion'=>'now()'),
                        'bit_valor_respuesta'=>$respuesta->obtener_valor(),
                    ); 
                    $filtro_para_update=array( 
                        'bit_ope'=>$GLOBALS['NOMBRE_APP'],
                        'bit_bit'=>$bit_bit, 
                    ); 
                    $tabla_bitacora->ejecutar_update_unico($filtro_para_update);  
                }
            }
            $respuesta->mandar_todo_al_cliente();
        }else if($modo_hacer=='hacer' || $modo_hacer=='imprimir'){
            $comenzo=new DateTime();
            try{
                $hacer=$nombre_proceso;
                $app->salida->agregar_css('../tedede/tedede.css');
                $app->salida->agregar_css('../encuestas/encuestas.css');
                $app->salida->agregar_css("{$GLOBALS['nombre_app']}.css");
                $app->salida->agregar_css('../tedede/menu.css');
                if(!usuario_actual() 
                    && !($hacer=='instalar' && isset($_REQUEST['sin_login'])) 
                    && (!$soy_un_ipad || !@$app->ver_offline[$hacer] && $hacer!='aviso_offline')
                ){
                    if($hacer!='menu' && $hacer!='login' && $hacer!='logout'){
                        $_SESSION['ir_despues_de_loguearse '.$GLOBALS['nombre_app']]=$_SERVER['REQUEST_URI'];
                    }
                    if($hacer!='login'){
                        $app->salida->redireccionar_a($GLOBALS['nombre_app'].'.php?hacer=login');
                    }
                    $app->salida->manifiesto=""; // la pantalla de login no se muestra off-line
                    $app->salida->enviar_encabezado_general();
                    $proceso_login=$app->obtener_proceso_si_existe("login");
                    if($proceso_login){
                        $app->mostrar_titulo($proceso_login);
                        $proceso_login->correr();
                    }else{
                        $app->salida->enviar('ERROR. La instalación de la aplicación está incompleta. Falta el proceso de LOGIN');
                    }
                }elseif($hacer==='menu'){ 
                    if(isset($_REQUEST['soy_un_ipad']) && $_REQUEST['soy_un_ipad']){
                        setcookie('soy_un_ipad',$_REQUEST['soy_un_ipad'], time() + (720 * 24 * 60 * 60));
                    }else{
                        setcookie('soy_un_ipad', "", time() - 3600);
                    }
                    $app->salida->enviar_encabezado_general();
                    $app->preparar_scripts_iniciales();
                    $app->armar_menu();
                }else{
                    $proceso=$app->obtener_proceso_si_existe($hacer);
                    if($proceso){
                        if(isset($_REQUEST['todo'])){
                            $proceso->argumentos=json_decode($_REQUEST['todo']);
                        }
                        if(isset($proceso->parametros->html_title)){
                            if(isset($proceso->argumentos)){
                                $app->salida->html_title=preg_replace_callback('|{(\w*)}|',
                                    function($coincidencias) use ($proceso){
                                        return $proceso->argumentos->{$coincidencias[1]};
                                    },
                                    $proceso->parametros->html_title
                                );
                            }else{
                                $app->salida->html_title=$proceso->parametros->html_title;
                            }
                        }
                        if($proceso->ignorar_csss_de_la_aplicacion_en_modo($modo_hacer)){
                            $app->salida->eliminar_lista_css();
                        }
                        foreach($proceso->los_csss() as $cada_css){
                            $app->salida->agregar_css($cada_css);
                        }
                        Loguear('2014-10-09','***************SETEO EL ICONO');
                        if(isset($proceso->parametros->cookies)){
                            foreach($proceso->parametros->cookies as $k=>$v){
                                setcookie($k,$v,time() + (720 * 24 * 60 * 60));
                            }
                        }
                        if(isset($proceso->parametros->icon_app)){
                            $app->salida->icon_app=$proceso->parametros->icon_app;
                        }else{
                            $app->salida->icon_app=$GLOBALS['ICON_APP'];
                        }
                        $app->salida->enviar_encabezado_general();
                        $app->mostrar_titulo($proceso);
                        if(!$proceso->parametros->de_instalacion){
                            $app->preparar_scripts_iniciales();
                        }
                        if($modo_hacer=='imprimir'){
                            $proceso->imprimir();
                        }else{
                            $proceso->correr();
                        }
                    }else{
                        $app->salida->enviar_encabezado_general();
                        $app->salida->enviar('','',array('tipo'=>'br'));
                        $app->salida->enviar('','',array('tipo'=>'br'));
                        $app->salida->enviar(<<<TXT
ERROR. URL MAL FORMADA. Este error debe aparecer cuando se introduzca a mano una URL (dirección de internet) inválida. 
Si usted recibe este error usando el programa en forma normal por favor avise
TXT
                        );
                        Loguear('2099-01-01','Error de URL en '.get_class($app).'.'.$hacer.' '.var_export($_REQUEST,TRUE));
                    }
                }
                $termino=new DateTime();
                $demoro=$termino->diff($comenzo);
                if($demoro->format("%H:%I:%S")>'00:09:59'){
                    $app->salida->enviar('demoró '.$demoro->format("%H:%I:%S"),'demora_proceso');
                }
                $app->salida->mandar_todo_al_cliente();
            }catch(Exception $err){
                global $loguear_excepciones_hasta;
                Loguear($loguear_excepciones_hasta,"********** EXCEPCION EN EL LOOP PRINCIPAL\n".aplanar_trace($err->getTrace()),false,false,true);
                if(@$GLOBALS['debug_via_notepadPP']){
                    $app->salida->enviar($err->getMessage());
                    enviar_trace_a_salida($app,$app->salida,$err->getTrace());
                }else{
                    if(!@$GLOBALS['esta_es_la_base_en_produccion']){
                        echo '<BR><B><PRE>Poner en configuracion_local $debug_via_notepadPP=true; para ver esto mejor y poder editarlo del notepad++</pre></b><br>';
                    }
                    echo '<pre>';
                    throw $err; 
                }
            }
        }else if(isset($_REQUEST['post'])){
            $comenzo=new DateTime();
            try{
                $nombre_proceso=$_REQUEST['post'];
                if(!usuario_actual()){
                    $app->salida->enviar_encabezado_general();
                    $app->salida->enviar('ERROR. DESCONECTADO');
                }else{
                    $proceso=$app->obtener_proceso_si_existe($nombre_proceso);
                    $app->salida->enviar_encabezado_general();
                    if($proceso){
                        //$app->mostrar_titulo($proceso);
                        $proceso->tomar_post();
                    }else{
                        $app->salida->enviar('','',array('tipo'=>'br'));
                        $app->salida->enviar('','',array('tipo'=>'br'));
                        $app->salida->enviar('ERROR. URL NO VALIDADA');
                        Loguear('2099-01-01','Error de URL en '.get_class($app).'.'.$hacer.' '.var_export($_REQUEST,TRUE));
                    }
                }
                $termino=new DateTime();
                $demoro=$termino->diff($comenzo);
                $app->salida->mandar_todo_al_cliente();
            }catch(Exception $err){
                global $loguear_excepciones_hasta;
                Loguear($loguear_excepciones_hasta,"********** EXCEPCION EN EL LOOP PRINCIPAL\n".aplanar_trace($err->getTrace()),false,false,true);
                if(@$GLOBALS['debug_via_notepadPP']){
                    $app->salida->enviar($err->getMessage());
                    enviar_trace_a_salida($app,$app->salida,$err->getTrace());
                }else{
                    if(!@$GLOBALS['esta_es_la_base_en_produccion']){
                        echo '<BR><B><PRE>Poner en configuracion_local $debug_via_notepadPP=true; para ver esto mejor y poder editarlo del notepad++</pre></b><br>';
                    }
                    echo '<pre>';
                    throw $err; 
                }
            }
        }else{
            $app->salida->redireccionar_a($app->nombre_del_php."?hacer=".$app->proceso_def);
            $app->salida->mandar_todo_al_cliente();
        }
    }
    function preparar_scripts_iniciales(){
    }
    function proceso_grilla_soporte(){
        return new Proceso_grilla_soporte();
    }
    function proceso_login(){
        return new Proceso_login();
    }
    function proceso_ingresar_usuario(){
        return new Proceso_ingresar_usuario();
    }
    function proceso_cambio_de_clave(){
        return new Proceso_cambio_de_clave();
    }
    function proceso_logout(){
        return new Proceso_Generico(array(
            'titulo'=>'Salir de la aplicación',
            'permisos'=>null,
            'submenu'=>'principal',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                unset($_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_usu_usu"]);
                $tabla_sesiones=$este->nuevo_objeto('Tabla_sesiones');
                $tabla_sesiones->registrar_logout('logout');
                $este->salida->enviar('¡DESCONECTADO!');
                $este->salida->enviar_link('volver a ingresar','',$GLOBALS['nombre_app'].'.php?hacer=menu');
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
    function proceso_bienvenida(){
        return new Proceso_bienvenida();
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
    function proceso_mandar_nueva_clave(){
        return new Proceso_mandar_nueva_clave();
    }
    function scripts_a_probar(){
        return array('../tedede/tabulados_pr.js');
    }
    function proceso_probar_todo(){
        return new Proceso_Generico(array(
            'titulo'=>'Correr casos de prueba sin instalar',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'mantenimiento',
            'funcion'=>function(Procesos $este){
                $probador=new Probador_minimo_HTML($este);
                $probador->probar_todo($este->app->scripts_a_probar());
                $probador->mostrar_resumen();
            }
        ));
    }
    function proceso_ambiente_prueba(){
        return new Proceso_ambiente_prueba();
    }
    function proceso_adaptacion_estructura(){
        return new Proceso_adaptacion_estructura();
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
}

function enviar_trace_a_salida($este,$salida, $trace){
    $este->salida->enviar('LISTA DE ERRORES ENCONTRADOS');
    $este->salida->abrir_grupo_interno('tabla_remito_enc',array('tipo'=>'table','border'=>'single'));
        $este->salida->abrir_grupo_interno('',array('tipo'=>'tr'));
            $este->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                $este->salida->enviar('linea');
            $este->salida->cerrar_grupo_interno();
            $este->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                $este->salida->enviar('archivo');
            $este->salida->cerrar_grupo_interno();    
            $este->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                $este->salida->enviar('funcion');
            $este->salida->cerrar_grupo_interno();
            $este->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                $este->salida->enviar('link');
            $este->salida->cerrar_grupo_interno();    
        $este->salida->cerrar_grupo_interno();    
        foreach($trace as $linea_trace){
            $linea_trace['file']=str_replace('\\','/',@$linea_trace['file']);
            $este->salida->abrir_grupo_interno('',array('tipo'=>'tr'));
                $este->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                    $salida->enviar(''.@$linea_trace['line'].'');
                $este->salida->cerrar_grupo_interno();    
                $este->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                    $salida->enviar(''.@$linea_trace['file'].'');
                $este->salida->cerrar_grupo_interno();    
                $este->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                    $salida->enviar(''.$linea_trace['function'].'');
                $este->salida->cerrar_grupo_interno();    
                $este->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                    $salida->enviar_boton('Editar error','',array('id'=>'editar_error','onclick'=>"editar_error('".@$linea_trace['file']."','".@$linea_trace['line']."',this)"));
                $este->salida->cerrar_grupo_interno();
            $este->salida->cerrar_grupo_interno();    
        }
    $este->salida->cerrar_grupo_interno();    
}

?>