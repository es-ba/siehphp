<?php
//UTF-8:SÍ

global $revisando_metadatos;

//$revisando_metadatos=true;

abstract class Aplicacion_encuesta extends Aplicacion{
    function __construct(){
        parent::__construct();
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
    function proceso_conciliar_claves_ejecutar(){
        return new Proceso_conciliar_claves_ejecutar();
    }
    function proceso_conciliar_claves(){
        return new Proceso_conciliar_claves();
    }
    function proceso_conciliar_visitas_ejecutar(){
        return new Proceso_conciliar_visitas_ejecutar();
    }
    function proceso_conciliar_visitas(){
        return new Proceso_conciliar_visitas();
    }
    function proceso_conciliar_grilla_claves(){
        return new Proceso_generico(array(
            'titulo'=>'Grilla de conciliación de claves',
            'permisos'=>array('grupo'=>'procesamiento', 'grupo2'=>'coor_campo'),
            'para_produccion'=>true,
            'submenu'=>PROCESO_INTERNO,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'claves_a_conciliar',array(),false,array('simple'=>'true','otras_opciones'=>array('offline'=>'claves_a_conciliar')));
                $este->salida->enviar_boton('ejecutar','ejecutar_claves_a_conciliar',array('id'=>'boton_ejecutar_claves_a_conciliar','onclick'=>"ejecutar_claves_a_conciliar();"));
                $este->salida->enviar('','',array('id'=>'mensajes_conciliar'));
            }
        ));
    }
    function proceso_conciliar_grilla_visitas(){
        return new Proceso_generico(array(
            'titulo'=>'Grilla de conciliación de visitas',
            'permisos'=>array('grupo'=>'procesamiento', 'grupo2'=>'coor_campo'),
            'para_produccion'=>true,
            'submenu'=>PROCESO_INTERNO,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'visitas_a_conciliar',array(),false,array('simple'=>'true','otras_opciones'=>array('offline'=>'visitas_a_conciliar')));
                $este->salida->enviar_boton('ejecutar','ejecutar_visitas_a_conciliar',array('id'=>'boton_ejecutar_visitas_a_conciliar','onclick'=>"ejecutar_visitas_a_conciliar();"));
                $este->salida->enviar('','',array('id'=>'mensajes_conciliar_visitas'));
            }
        ));
    }    
    function proceso_correr_consistencias(){
        return new Proceso_correr_consistencias();
    }
    /*
    function proceso_imprimir_hoja_de_ruta(){        
        $nombre_proceso='Proceso_imprimir_hoja_de_ruta';
        $proceso=$nombre_proceso.'__'.$GLOBALS['nombre_app'];
        if(!class_exists($proceso)){
            $proceso=$nombre_proceso;
        }
        if(!class_exists($proceso)){
            throw new Exception_Tedede("Intento de invocar un proceso inexistente: $proceso");
        }
        return new $proceso;
    }
    function proceso_imprimir_hoja_de_ruta_sup(){        
        $nombre_proceso='Proceso_imprimir_hoja_de_ruta_sup';
        $proceso=$nombre_proceso.'__'.$GLOBALS['nombre_app'];
        if(!class_exists($proceso)){
            $proceso=$nombre_proceso;
        }
        if(!class_exists($proceso)){
            throw new Exception_Tedede("Intento de invocar un proceso inexistente: $proceso");
        }
        return new $proceso;
    }
    */    
    function proceso_imprimir_hoja_de_ruta_sup_campo(){        
        $nombre_proceso='Proceso_imprimir_hoja_de_ruta_sup_campo';
        $proceso=$nombre_proceso.'__'.$GLOBALS['nombre_app'];
        if(!class_exists($proceso)){
            $proceso=$nombre_proceso;
        }
        if(!class_exists($proceso)){
            throw new Exception_Tedede("Intento de invocar un proceso inexistente: $proceso");
        }
        return new $proceso;
    }
    function proceso_imprimir_hoja_de_ruta_sup_telefonico(){        
        $nombre_proceso='Proceso_imprimir_hoja_de_ruta_sup_telefonico';
        $proceso=$nombre_proceso.'__'.$GLOBALS['nombre_app'];
        if(!class_exists($proceso)){
            $proceso=$nombre_proceso;
        }
        if(!class_exists($proceso)){
            throw new Exception_Tedede("Intento de invocar un proceso inexistente: $proceso");
        }
        return new $proceso;
    }
    function proceso_imprimir_hoja_de_ruta_recu(){        
        $nombre_proceso='Proceso_imprimir_hoja_de_ruta_recu';
        $proceso=$nombre_proceso.'__'.$GLOBALS['nombre_app'];
        if(!class_exists($proceso)){
            $proceso=$nombre_proceso;
        }
        if(!class_exists($proceso)){
            throw new Exception_Tedede("Intento de invocar un proceso inexistente: $proceso");
        }
        return new $proceso;
    }
    function proceso_imprimir_hoja_de_ruta_enc(){        
        $nombre_proceso='Proceso_imprimir_hoja_de_ruta_enc';
        $proceso=$nombre_proceso.'__'.$GLOBALS['nombre_app'];
        if(!class_exists($proceso)){
            $proceso=$nombre_proceso;
        }
        if(!class_exists($proceso)){
            throw new Exception_Tedede("Intento de invocar un proceso inexistente: $proceso");
        }
        return new $proceso;
    }
    function proceso_imprimir_planilla_supervision(){
        return new Proceso_imprimir_planilla_supervision();
    }
    function proceso_confirmar_entrega_en_papel_enc(){
        return new Proceso_confirmar_entrega_en_papel_enc();
    }    
    function proceso_confirmar_entrega_en_papel_recu(){
        return new Proceso_confirmar_entrega_en_papel_recu();
    }    
    function proceso_confirmar_entrega_en_papel_sup_telefonico(){
        return new Proceso_confirmar_entrega_en_papel_sup_telefonico();
    }    
    function proceso_confirmar_entrega_en_papel_sup_campo(){
        return new Proceso_confirmar_entrega_en_papel_sup_campo();
    }    
    function scripts_a_probar(){
        return array_merge(parent::scripts_a_probar(),array('../encuestas/casos_prueba_encuesta.js'));
    }
    function proceso_liberacion_a_campo(){
        return new Proceso_liberacion_a_campo();
    }
    function proceso_impresion_etiquetas(){
        return new Proceso_impresion_etiquetas();
    }
    function proceso_fin_de_ingreso(){
        return new Proceso_fin_de_ingreso();
    }
    function preparar_scripts_iniciales(){
        global $esta_es_la_base_en_produccion;
        parent::preparar_scripts_iniciales();
        $this->salida->enviar_script("operativo_actual='{$GLOBALS['nombre_app']}';\n");
		$tabla_operativos=$this->nuevo_objeto("Tabla_operativos");
		$tabla_operativos->leer_unico(array(
			'ope_ope'=>$GLOBALS['NOMBRE_APP'],
		));
		if($tabla_operativos->datos->ope_en_campo){				
			$this->salida->enviar_script("var operativo_anterior='{$tabla_operativos->datos->ope_ope_anterior}';\n"); 
		} else{
			$this->salida->enviar_script("var operativo_anterior='';\n"); 
		}	
        $this->salida->enviar_script('$esta_es_la_base_en_produccion='.($esta_es_la_base_en_produccion?'true':'false').";\n");        
        $this->salida->enviar_script("var tiene_rol_subcoor_campo=".(tiene_rol('subcoor_campo')?'true':'false').";\n");
        $this->salida->enviar_script("var tiene_rol_recepcionista=".(tiene_rol('recepcionista')?'true':'false').";\n");
        $this->salida->enviar_script("var tiene_rol_procesamiento=".(tiene_rol('procesamiento')?'true':'false').";\n");
        $this->salida->enviar_script("anio_operativo='{$GLOBALS['anio_operativo']}';\n");
    }
    function proceso_grilla_bloques(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla bloques',
            'permisos'=>array('grupo'=>'dis_con','grupo2'=>'procesamiento'),
            'para_produccion'=>true,
            'submenu'=>'metadatos',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'bloques', array('blo_ope'=>$GLOBALS['NOMBRE_APP']),false,array('otras_opciones'=>array('agregando_filas_completas'=>true)));
            }
        ));
    }    
    function proceso_grilla_preguntas(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla preguntas',
            'permisos'=>array('grupo'=>'dis_con','grupo2'=>'procesamiento'),
            'para_produccion'=>true,
            'submenu'=>'metadatos',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'preguntas', array('pre_ope'=>$GLOBALS['NOMBRE_APP']),false,array('otras_opciones'=>array('agregando_filas_completas'=>true)));
            }
        ));
    }
    function proceso_grilla_variables(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla variables',
            'permisos'=>array('grupo'=>'dis_con','grupo2'=>'procesamiento'),
            'para_produccion'=>true,
            'submenu'=>'metadatos',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'variables', array('var_ope'=>$GLOBALS['NOMBRE_APP']),false,array('otras_opciones'=>array('agregando_filas_completas'=>true)));
            }
        ));
    }
    function proceso_grilla_con_opc(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla conjunto de opciones',
            'permisos'=>array('grupo'=>'dis_con','grupo2'=>'procesamiento'),
            'para_produccion'=>true,
            'submenu'=>'metadatos',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'con_opc', array('conopc_ope'=>$GLOBALS['NOMBRE_APP']),false,array('otras_opciones'=>array('agregando_filas_completas'=>true)));
            }
        ));
    }
    function proceso_grilla_opciones(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla opciones',
            'permisos'=>array('grupo'=>'dis_con','grupo2'=>'procesamiento'),
            'para_produccion'=>true,
            'submenu'=>'metadatos',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'opciones', array('opc_ope'=>$GLOBALS['NOMBRE_APP']),false,array('otras_opciones'=>array('agregando_filas_completas'=>true)));
            }
        ));
    }
    function proceso_grilla_filtros(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla filtros',
            'permisos'=>array('grupo'=>'dis_con','grupo2'=>'procesamiento'),
            'para_produccion'=>true,
            'submenu'=>'metadatos',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'filtros', array('fil_ope'=>$GLOBALS['NOMBRE_APP']),false,array('otras_opciones'=>array('agregando_filas_completas'=>true)));
            }
        ));
    }
    function proceso_grilla_saltos(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla saltos',
            'permisos'=>array('grupo'=>'dis_con','grupo2'=>'procesamiento'),
            'para_produccion'=>true,
            'submenu'=>'metadatos',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'saltos', array('sal_ope'=>$GLOBALS['NOMBRE_APP']),false,array('otras_opciones'=>array('agregando_filas_completas'=>true)));
            }
        ));
    }
    function proceso_desplegar_formulario($formulario='',$matriz=''){
        return new Proceso_Generico(array(
            'titulo'=>'Desplegar formulario '.$formulario.' '.$matriz,
            'permisos'=>array('grupo'=>'dis_con','grupo2'=>'procesamiento'),
            //'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'submenu'=>'metadatos',            
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
            http://localhost/yeah/ebcp2014/ebcp2014.php?hacer=desplegar_formulario&todo={"tra_ope":"ebcp2014","tra_for":"AJH1","tra_mat":""}
        */
    }
    function proceso_planilla_monitoreo_TEM(){
        return new Planilla_monitoreo_TEM();
    }
    function proceso_planilla_inquilinato_campo(){
        return new Planilla_inquilinato_campo();
    }
    function proceso_planilla_dom5_campo(){
        return new Planilla_dom5_campo();
    }   
    function proceso_grilla_estados(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla estados',
            'permisos'=>array(),
            'para_produccion'=>true,
            'submenu'=>'documentación',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'estados', array('est_ope'=>$GLOBALS['NOMBRE_APP']));
            }
        ));
    }
    function proceso_grilla_verificado(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla verificado',
            'permisos'=>array(),
            'para_produccion'=>true,
            'submenu'=>'documentación',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'verificado' );
            }
        ));
    } 
    function proceso_grilla_semanas(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla semanas',
            'permisos'=>array('grupo'=>'programador','grupo2'=>'mues_campo', 'grupo3'=>'subcoor_campo', 'grupo4'=>'procesamiento'),
            'para_produccion'=>true,
            'submenu'=>'metadatos',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'semanas' );
            }
        ));
    } 

    function proceso_grilla_a_ingreso(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla a_ingreso',
            'permisos'=>array(),
            'para_produccion'=>true,
            'submenu'=>'documentación',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'a_ingreso' );
            }
        ));
    }
    function proceso_grilla_volver_a_cargar(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla volver_a_cargar',
            'permisos'=>array(),
            'para_produccion'=>true,
            'submenu'=>'documentación',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'volver_a_cargar' );
            }
        ));
    }
    function proceso_grilla_dispositivo(){
        return new Proceso_generico(array(
            'titulo'=>'Tabla dispositivo',
            'permisos'=>array(),
            'para_produccion'=>true,
            'submenu'=>'documentación',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'dispositivo' );
            }
        ));
    }
    function proceso_grilla_monitoreo_procesamiento_4(){
        return new Proceso_generico(array(
            'titulo'=>'Monitoreo de Todos los estados',
            'permisos'=>array('grupo'=>'procesamiento','grupo2'=>'mues_campo','grupo3'=>'ingresador','grupo4'=>'dis_con','grupo6'=>'ana_campo','grupo5'=>'coor_campo'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_monitoreo_procesamiento_4');
            }
        ));
    }
    function proceso_grilla_monitoreo_rea(){
        return new Proceso_generico(array(
            'titulo'=>'Monitoreo de REA/NOREA',
            'permisos'=>array('grupo'=>'procesamiento','grupo2'=>'mues_campo','grupo3'=>'ingresador','grupo4'=>'dis_con','grupo6'=>'ana_campo','grupo5'=>'coor_campo','grupo6'=>'muestrista'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_monitoreo_procesamiento_rea');
            }
        ));
    }
    function proceso_manual_odbc(){
        return new Proceso_manual_odbc();
    }
    function proceso_grilla_tabla_inconsistencias(){
        return new Proceso_generico(array(
            'titulo'=>'Todas las inconsistencias',
            'permisos'=>array('grupo'=>'procesamiento','grupo1'=>'ana_sectorial','grupo2'=>'subcoor_campo'),
            'submenu'=>'consistencias',
            'para_produccion'=>true,            
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'inconsistencias_todas',array('inc_ope'=>$GLOBALS['NOMBRE_APP']));
            }
        ));
    }
    function proceso_grilla_tabla_inconsistencias_incontroladas(){
        return new Proceso_generico(array(
            'titulo'=>'Inconsistencias fuera de prueba',
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'consistencias',
            'para_produccion'=>true,            
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'inconsistencias',array('inc_ope'=>$GLOBALS['NOMBRE_APP'],'inc_controlada'=>false),null,array('filtro_manual'=>array('inc_con'=>'#!como audi_nsnc%')));
            }
        ));
    }
    function proceso_planilla_monitoreo_campo(){
        return new Planilla_monitoreo_campo(); // si se incluye en todos los operativos encuesta: pasar a aplicacion_encuesta
    }
    function proceso_grilla_totales_por_estado(){
        return new Proceso_generico(array(
            'titulo'=>'Grilla de totales de encuestas por estado',
            'permisos'=>array('grupo'=>'procesamiento','grupo1'=>'mues_campo','grupo2'=>'ingresador'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_totales_por_estado',array(),false/*,array('filtro_manual'=>$filtro)*/);
            }
        ));
    }
    function proceso_grilla_dictra(){
        return new Proceso_generico(array(
            'titulo'=>'Diccionario para variables construidas y consistencias',
            'permisos'=>array('grupo'=>'procesamiento', 'grupo2'=>'ana_con'),
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
    function proceso_destrabar_descarga_dispositivo(){
        return new Proceso_destrabar_descarga_dispositivo();
    }    
    function proceso_controlar_opciones_variables_calculadas(){
        return new Proceso_controlar_opciones_variables_calculadas();
    }    
    function proceso_frecuencia_variables(){
        return new Proceso_frecuencia_variables();
    }
    function proceso_grilla_monitoreo_resumen_norea(){
        return new Proceso_generico(array(
            'titulo'=>'Monitoreo Resumen de NoRea',
            'permisos'=>array('grupo'=>'dis_con','grupo1'=>'subcoor_campo', 'grupo2'=>'programador', 'grupo3'=>'muestrista', 'grupo4'=>'procesamiento'),
            'submenu'=>'coordinación de campo',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_monitoreo_resumen_norea');
                enviar_grilla($este->salida,'vista_monitoreo_resumen_norea_semanal');
                enviar_grilla($este->salida,'vista_monitoreo_resumen_norea_dominio');
                enviar_grilla($este->salida,'vista_monitoreo_resumen_norea_estrato');
                enviar_grilla($este->salida,'vista_monitoreo_resumen_norea_zonal');
                enviar_grilla($este->salida,'vista_monitoreo_resumen_norea_comunal');
                enviar_grilla($este->salida,'vista_monitoreo_resumen_norea_area');
                enviar_grilla($este->salida,'vista_monitoreo_resumen_norea_encuestador');
                if(tiene_rol('mues_campo')||tiene_rol('procesamiento')){
                    enviar_grilla($este->salida,'vista_monitoreo_resumen_norea_recuperador');
                    enviar_grilla($este->salida,'vista_monitoreo_resumen_norea_dominio_semana');
                    enviar_grilla($este->salida,'vista_monitoreo_resumen_norea_semana_area');
                    enviar_grilla($este->salida,'vista_monitoreo_resumen_norea_dominio_comuna_semana');                    
                    enviar_grilla($este->salida,'vista_monitoreo_resumen_norea_dominio_estrato');
                }
            }
        ));
    }
    function proceso_grilla_monitoreo_resumen_norea_encuestador(){ 
        return new Proceso_generico(array(
            'titulo'=>'Monitoreo Resumen de NoRea por Encuestador',
            'permisos'=>array('grupo'=>'dis_con','grupo1'=>'subcoor_campo', 'grupo2'=>'programador', 'grupo3'=>'muestrista', 'grupo4'=>'procesamiento'),
            'submenu'=>'coordinación de campo',
            'para_produccion'=>true,
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'vista_monitoreo_resumen_norea_total_enc');
                enviar_grilla($este->salida,'vista_monitoreo_resumen_norea_semanal_enc');
                enviar_grilla($este->salida,'vista_monitoreo_resumen_norea_estrato_enc');
                enviar_grilla($este->salida,'vista_monitoreo_resumen_norea_zonal_enc');
                enviar_grilla($este->salida,'vista_monitoreo_resumen_norea_comunal_enc');
                enviar_grilla($este->salida,'vista_monitoreo_resumen_norea_encuestador_enc');
            }
        ));
    }
    function proceso_grilla_variables_controlar_consistencias(){
        return new Proceso_generico(array(
            'titulo'=>'Controlar variables no ingresadas',
            'permisos'=>array('grupo'=>'dis_con','grupo2'=>'procesamiento'),
            'para_produccion'=>true,
            'submenu'=>'consistencias',
            'funcion'=>function(Procesos $este){
                enviar_grilla($este->salida,'variables_controlar_consistencias', array('var_ope'=>$GLOBALS['NOMBRE_APP']),false);
            }
        ));
    }
    function proceso_planilla_mis_supervisiones_telefonicas(){
        return new Planilla_mis_supervisiones_telefonicas();
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
?>