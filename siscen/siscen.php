<?php
//UTF-8:SÍ 

//v 3.00

$NOMBRE_APP='siscen';
$nombre_app='siscen';

require_once "lo_imprescindible.php";
require_once "aplicaciones.php";
require_once "todos_los_php.php";
incluir_todo("../tedede");
incluir_todo("../$nombre_app");
$GLOBALS['titulo_corto_app']="Sistema Central";

if(tiene_rol('programador')){
    $db->ejecutar_sql(new Sql(<<<SQL
        select dblink_connect('trac_yeah','host=10.35.21.78 dbname=trac_db user=trac_ro password=laclave');
SQL
    ));
    $db->ejecutar_sql(new Sql(<<<SQL
        select dblink_connect('trac_xcan','host=10.35.21.78 dbname=trac_db user=trac_ro password=laclave');
SQL
    ));
}

class Aplicacion_siscen extends Aplicacion{
    function __construct(){
        global $esta_es_la_base_en_produccion,$soy_un_ipad;
        $this->ver_offline=array(
            'hoja_de_ruta'=>true, 
            'formularios_de_la_vivienda'=>true, 
            'desplegar_formulario'=>true
        );
        parent::__construct();
        if($esta_es_la_base_en_produccion){
            $this->salida->html_title="Sistema Central";
        }else{
            $this->salida->html_title="TEST - Sistema Central";
        }
        $this->salida->color_fondo=(@$GLOBALS['color_de_fondo_de_la_aplicacion'])?:'#FDE';
        if($soy_un_ipad){
            if(isset($_REQUEST['hacer'])&&isset($this->ver_offline[$_REQUEST['hacer']])){
                $this->salida->manifiesto="{$nombre_app}.manifest";
            }
        }
        $this->salida->agregar_css("{$GLOBALS['nombre_app']}.css");
        $this->salida->agregar_css("../tedede/probador.css");
        $this->salida->agregar_js("../tedede/editor.js");
        $this->salida->agregar_js("../tedede/para_grilla.js");
        $this->salida->agregar_js("../tercera/md5_paj.js");
        $this->salida->agregar_js('siscen.js');
        // $this->salida->agregar_js("estructura_{$GLOBALS['nombre_app']}.js");
    }
    function obtener_titulo(){
        return "Sistema Central";
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
                        new Esquema_siscen(),
                        new Tabla_tiempo_logico(),
                        new Tabla_http_user_agent(),
                        new Tabla_roles(),
                        new Tabla_proyectos(),
                        new Tabla_tipo_req(),
                        new Tabla_requerimientos(),
                        new Tabla_req_est(),
                        new Tabla_req_nov(),
                        new Tabla_req_est_flu(),
                        new Tabla_bitacora(),
                        new Tabla_proy_usu(),
                        new Tabla_trac(),
                        new Tabla_tipo_dispositivo(),
                        new Tabla_dispositivos(),
                    ) as $objeto_de_la_base)
                    {
                        $este->salida->enviar('instalando '.get_class($objeto_de_la_base));
                        $objeto_de_la_base->contexto=$este;
                        $objeto_de_la_base->ejecutar_instalacion();
                    }
                    foreach(array('../operaciones_siscen/insercion_tabla_roles.sql',
                                  '../operaciones_siscen/insercion_tabla_usuarios.sql',
                                  '../operaciones_siscen/insercion_tabla_rol_rol.sql',
                                  '../operaciones_siscen/insercion_tabla_proyectos.sql',
                                  '../operaciones_siscen/insercion_tabla_req_est.sql',
                                  '../operaciones_siscen/insercion_tabla_req_est_flu.sql',
                                  '../operaciones_siscen/insercion_tabla_tipo_req.sql',
                                  '../operaciones_siscen/insercion_tabla_requerimientos.sql', // para probar
                                  '../operaciones_siscen/insercion_tabla_proy_usu.sql', // para probar
                                  '../operaciones_siscen/insercion_tabla_trac.sql',
                                  '../operaciones_siscen/insercion_tabla_tipo_dispositivo.sql',
                                  '../operaciones_siscen/creacion_tabla_his_requerimientos.sql',
                                  '../operaciones_siscen/creacion_vista_req_resumen.sql',
                                   ) as $archivo)
                    {
                        foreach(explode('/*OTRA*/',file_get_contents($archivo)) as $sentencia){
                            $este->db->ejecutar_sql(new Sql(str_replace(array('/*CAMPOS_AUDITORIA*/',"'eah2012',"),array(','.PRIMER_TLG,"'siscen',"),$sentencia)));
                        }
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
    function proceso_agregar_novedades_req(){
        return new Proceso_agregar_novedades_req();
    }    
    function proceso_grabar_novedad_req(){
        return new Proceso_grabar_novedad_req();
    }
    function proceso_cambiar_prioridad_req(){
        return new Proceso_cambiar_prioridad_req();
    }
    function proceso_cambiar_plazo_req(){
        return new Proceso_cambiar_plazo_req();
    }
    function proceso_cambiar_costo_req(){
        return new Proceso_cambiar_costo_req();
    }
    function proceso_upload(){
        return new Proceso_upload();
    }
    function proceso_mispendientes(){
        return new Proceso_generico(array(
            'titulo'=>'Mis pendientes',
            //'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'requerimientos',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
            enviar_grilla($este->salida,'mispendientes','',false,array('filtro_para_lectura'=>array('req_lado'=>tiene_rol('programador')?'desarrollo':'usuario')));
            }
        ));
    }
    function proceso_administrar_novedades(){
        return new Proceso_generico(array(
            'titulo'=>'Administrar novedades',
            'submenu'=>'requerimientos',
            'para_produccion'=>false,
            'funcion'=>function(Procesos $este){
            enviar_grilla($este->salida,'novedades');
            }
        ));
    }    
    function proceso_requerimientos_abiertos(){
        return new Proceso_generico(array(
            'titulo'=>'Abiertos',
            //'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'requerimientos',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'requerimientos_abiertos','',false,array('filtro_para_lectura'=>array('req_estado'=>'#!=desafectado&!=verificado')));
            }
        ));
    }
    /*
    function proyectos_usuario_actual(){
        $ultimo_proyecto="";
        $contador=0; 
        $todos_los_proyectos="# =";
        $usuario=usuario_actual(); 
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
         SELECT proyusu_proy as proy FROM proy_usu where proyusu_usu='{$usuario}' order by proyusu_proy 
SQL
        ));
       while($fila=$cursor->fetchObject()){ 
           $contador=$contador+1;
           $ultimo_proyecto=$fila->proy;
           if ($todos_los_proyectos=="# =" ) {
              $todos_los_proyectos=$todos_los_proyectos.$ultimo_proyecto;
           }
           else{
             $todos_los_proyectos=$todos_los_proyectos.'| ='.$ultimo_proyecto;
           }
       }
       if ($contador==1) {
          $todos_los_proyectos=$ultimo_proyecto;
       }
       return $todos_los_proyectos;
    }
    */
    function proceso_requerimientos_todos(){
        return new Proceso_generico(array(
            'titulo'=>'Todos',
            //'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'requerimientos',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'requerimientos_abiertos','',false);
            }
        ));
    }  
    function proceso_cargar_requerimiento(){
        return new Proceso_cargar_requerimiento();
    }  
    function proceso_traer_combos(){
        return new Proceso_traer_combos();
    }
    function proceso_mantenimiento_sql(){
        return new Proceso_mantenimiento_sql();
    }
    function proceso_usuarios(){
        return new Proceso_generico(array(
            'titulo'=>'Usuarios',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'usuarios',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'usuarios_filtrados');                
            }
        ));
    }
    function proceso_agregar_adjuntos_requerimiento(){
        return new Proceso_agregar_adjuntos_requerimiento();
    }    
    function proceso_dispositivos(){
        return new Proceso_generico(array(
            'titulo'=>'dispositivos',
            'permisos'=>array('grupo'=>'mues_campo','grupo2'=>'programadores'),
            'submenu'=>'suministros',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'dispositivos');
            }
        ));
    }  
    function armar_menu(){
        /*
        $this->salida->enviar('¡Ahora se pueden adjuntar archivos! ideal para reportes de errores, subir formularios o cualquier tipo de documentación','',
            array(
                'style'=>'background-color:orange; text-align:center'
            )
        );
        */
        parent::armar_menu();
    }
    function proceso_chips(){
        return new Proceso_generico(array(
            'titulo'=>'chips',
            'permisos'=>array('grupo'=>'mues_campo','grupo2'=>'programadores'),
            'submenu'=>'suministros',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'chips');
            }
        ));
    }
}
if(!isset($no_ejecutar_aplicacion)){
    Aplicacion::correr(new Aplicacion_siscen());
}
?>