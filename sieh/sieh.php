<?php
//UTF-8:SÍ 

//V 1.93

$NOMBRE_APP='sieh';
$nombre_app='sieh';
$GLOBALS['esquema_principal']='rrhh';
$parametros_db=(object) array();
$parametros_db->search_path='rrhh,comun,public';

require_once "lo_imprescindible.php";
require_once "aplicaciones.php";
require_once "todos_los_php.php";
incluir_todo("../tedede");
incluir_todo("../$nombre_app");
$GLOBALS['titulo_corto_app']="Sistema Integrado de Encuestas a Hogares";

class Aplicacion_sieh extends Aplicacion{
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
    }
    function obtener_titulo(){
        return "Sistema Central";
    }
    function probar_aplicacion(){
    }
    /*function proceso_instalar(){
        return new Proceso_Generico(array(
            'titulo'=>'Instalar aplicación',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'mantenimiento',
            'funcion'=>function(Procesos $este){
                global $esta_es_la_base_en_produccion;
                try{
                    Aplicacion::salida_enviar_aviso_instalacion($este);
                    foreach(array(
                        new Esquema_rrhh(),
                        new Tabla_tiempo_logico(),
                        new Tabla_http_user_agent(),
                        new Tabla_roles(),
                        new Tabla_bitacora(),
                        new Tabla_cod_area_estud(),
                        new Tabla_cod_entr_entrvdor(),
                        new Tabla_cod_entr_perfil(),
                        new Tabla_cod_estad_selecc(),
                        new Tabla_cod_exp(),
                        new Tabla_cod_exp1(),
                        new Tabla_cod_niv_est(),
                        new Tabla_cod_op_ev_anual(),
                        new Tabla_cod_op_ev_puest_rec(),
                        new Tabla_cod_op_nov(),
                        new Tabla_cod_op_resp_llam(),
                        new Tabla_cod_op_tip_enc(),
                        new Tabla_cod_or_sec(),
                        new Tabla_cod_puestos(),
                        new Tabla_cod_resul_entrev(),
                        new Tabla_cod_resul_llam(),
                        new Tabla_cod_tipo_contr(),
                        new Tabla_cod_tipo_operativo(),
                        new Tabla_cod_ubic_dgeyc(),
                        new Tabla_cod_ult_situacion()

                    ) as $objeto_de_la_base)
                    {
                        $este->salida->enviar('instalando '.get_class($objeto_de_la_base));
                        $objeto_de_la_base->contexto=$este;
                        $objeto_de_la_base->ejecutar_instalacion();
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
    }*/    
    function proceso_mantenimiento_sql(){
        return new Proceso_mantenimiento_sql();
    }
    function proceso_personal(){
        return new Proceso_generico(array(
            'titulo'=>'personas',
            'permisos'=>array('grupo'=>'rrhh','grupo1'=>'suprrhh'),
            'submenu'=>'RRHH',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'personas',null,false,array('filtro_manual'=>array('fecha_ult_cv'=>'#>=2015-01-1'),'otras_opciones'=>array('agregando_filas_completas'=>true)));
            }
        ));
    }
    function proceso_operativos(){
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            select tt.value as operativo
                from ( select (json_each_text(mdf_pk::json)).key,  (json_each_text(mdf_pk::json)).value 
                    FROM his.modificaciones
                    where mdf_tlg=(          
                        SELECT max(mdf_tlg) as max_tlg
                        FROM his.modificaciones
                        WHERE mdf_tabla='operativos' 
                    )
                ) as tt       
                where tt.key='operativo'   
SQL
        ));
        $fila=$cursor->fetchObject();
        $operativo=$fila?$fila->operativo:null;
        return new Proceso_generico(array(
            'titulo'=>'operativos',
            'permisos'=>array('grupo'=>'rrhh','grupo1'=>'suprrhh'),
            'submenu'=>'RRHH',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use($operativo){
                enviar_grilla($este->salida,'operativos',null,false,array('filtro_manual'=>array('operativo'=>$operativo),'otras_opciones'=>array('agregando_filas_completas'=>true)));
            }
        ));
    }
    function proceso_auditoria(){
        $fecha = date( "Y-m-d" );
        $ayer = date( "Y-m-d", strtotime( "-30 days", strtotime( $fecha ) ) );  
        Loguear('25-03-2015','ayer = '.$ayer);
        return new Proceso_generico(array(
            'titulo'=>'auditoria',
            'permisos'=>array('grupo'=>'suprrhh'),
            'submenu'=>'RRHH',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($ayer){
                 enviar_grilla($este->salida,'modificaciones',null,null);
            }
        ));
    }
    function proceso_usuarios(){
        return new Proceso_generico(array(
            'titulo'=>'Usuarios',
            'permisos'=>array('grupo'=>'programador'),
            'submenu'=>'usuarios',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'usuarios');                
            }
        ));
    }
    function para_proceso_codigo_descripcion($tabla){
        return new Proceso_generico(array(
            'titulo'=>$tabla,
            'permisos'=>array('grupo'=>'mues_campo'),
            'submenu'=>'tablas',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este) use ($tabla){
                enviar_grilla($este->salida,'tabla_'.$tabla);
            }
        ));
    } 
    function proceso_cod_area_estud(){ return $this->para_proceso_codigo_descripcion('cod_area_estud'); }
    function proceso_cod_entr_entrvdor(){ return $this->para_proceso_codigo_descripcion('cod_entr_entrvdor'); }
    function proceso_cod_entr_perfil(){ return $this->para_proceso_codigo_descripcion('cod_entr_perfil'); }
    function proceso_cod_estad_selecc(){ return $this->para_proceso_codigo_descripcion('cod_estad_selecc'); }
    function proceso_cod_exp(){ return $this->para_proceso_codigo_descripcion('cod_exp'); }
    function proceso_cod_exp1(){ return $this->para_proceso_codigo_descripcion('cod_exp1'); }
    function proceso_cod_niv_est(){ return $this->para_proceso_codigo_descripcion('cod_niv_est'); }
    function proceso_cod_op_ev_anual(){ return $this->para_proceso_codigo_descripcion('cod_op_ev_anual'); }
    function proceso_cod_op_ev_puest_rec(){ return $this->para_proceso_codigo_descripcion('cod_op_ev_puest_rec'); }
    function proceso_cod_op_nov(){ return $this->para_proceso_codigo_descripcion('cod_op_nov'); }
    function proceso_cod_op_resp_llam(){ return $this->para_proceso_codigo_descripcion('cod_op_resp_llam'); }
    function proceso_cod_op_tip_enc(){ return $this->para_proceso_codigo_descripcion('cod_op_tip_enc'); }
    function proceso_cod_or_sec(){ return $this->para_proceso_codigo_descripcion('cod_or_sec'); }
    function proceso_cod_puestos(){ return $this->para_proceso_codigo_descripcion('cod_puestos'); }
    function proceso_cod_resul_entrev(){ return $this->para_proceso_codigo_descripcion('cod_resul_entrev'); }
    function proceso_cod_resul_llam(){ return $this->para_proceso_codigo_descripcion('cod_resul_llam'); }
    function proceso_cod_tipo_contr(){ return $this->para_proceso_codigo_descripcion('cod_tipo_contr'); }
    function proceso_cod_tipo_operativo(){ return $this->para_proceso_codigo_descripcion('cod_tipo_operativo'); }
    function proceso_cod_ubic_dgeyc(){ return $this->para_proceso_codigo_descripcion('cod_ubic_dgeyc'); }
    function proceso_cod_ult_situacion(){ return $this->para_proceso_codigo_descripcion('cod_ult_situacion'); }
    
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
}
if(!isset($no_ejecutar_aplicacion)){
    Aplicacion::correr(new Aplicacion_sieh());
}
?>