<?php
//UTF-8:SÍ

class Planilla_carga extends Proceso_formulario{
    function titulo(){ 
        return 'Planilla de carga del '.$this->inforol->titulo();
    }
    function submenu(){
        return 'recepción';
    }
    function permisos(){
        return array('grupo'=>'recepcionista', 'grupo2'=>'procesamiento');
    }
    function filtro_personal(){
        return array();
    }
    function nombre_planilla(){
        return strtolower(get_class($this));
    }
    function __construct(){
        $titulo=$this->titulo();
        parent::__construct(array(
            'titulo'=>$this->titulo(),
            'permisos'=>$this->permisos(),
            'submenu'=>$this->submenu(),
            'para_produccion'=>true,
        ));
    }
    function post_constructor(){
        parent::post_constructor();
        $este=$this;
        $tabla_personal_usuario_actual=$este->nuevo_objeto("Tabla_personal");
        $tabla_personal_usuario_actual->leer_uno_si_hay(array('per_usu'=>usuario_actual()));
        $this->campos_orden=array();
        if($tabla_personal_usuario_actual->obtener_leido()){
            if($tabla_personal_usuario_actual->datos->per_dominio){
                $this->campos_orden[]="(per_dominio={$tabla_personal_usuario_actual->datos->per_dominio}) desc";
            }
            if($tabla_personal_usuario_actual->datos->per_comuna){
                $this->campos_orden[]="(per_comuna={$tabla_personal_usuario_actual->datos->per_comuna}) desc";
            }
            $this->per_usuario_actual=$tabla_personal_usuario_actual->datos->per_per;            
        }else{
            $this->per_usuario_actual=null;
        }
    }    
    function correr(){
        $este=$this;
        $rol_persona=$este->inforol->rol_persona();
        $titulo=$este->inforol->titulo();
        $ROL=$este->inforol->sufijo_rol();
        $SUFIJO_TITULO=$este->inforol->sufijo_titulo();
        $estados_asignado=$este->inforol->estados_asignado();
        $tabla_personal=$este->nuevo_objeto("Tabla_personal");
        $tabla_personal_usuario_actual=$este->nuevo_objeto("Tabla_personal");
        $tabla_personal_usuario_actual->leer_uno_si_hay(array('per_usu'=>usuario_actual()));
        if($tabla_personal_usuario_actual->obtener_leido()){
            $campos_orden=array();
            if($tabla_personal_usuario_actual->datos->per_dominio){
                $campos_orden[]="(per_dominio={$tabla_personal_usuario_actual->datos->per_dominio}) desc";
            }
            if($tabla_personal_usuario_actual->datos->per_comuna){
                $campos_orden[]="(per_comuna={$tabla_personal_usuario_actual->datos->per_comuna}) desc";
            }
            $campos_orden[]='per_apellido';
            $campos_orden[]='per_nombre';
            $tabla_personal->definir_campos_orden($campos_orden);
            $comuna_sugerida=$tabla_personal_usuario_actual->datos->per_comuna;
            $dominio=$tabla_personal_usuario_actual->datos->per_dominio;
            $dominio_sugerido=$tabla_personal_usuario_actual->datos->per_dominio;
        }else{
            $tabla_personal->definir_campos_orden(array('per_apellido','per_nombre'));
            $comuna_sugerida=0;
            $dominio_sugerido=0;
            $dominio=null;
        }
        if(!$comuna_sugerida){
            $comuna_sugerida="0";
        } 
        if(!$dominio_sugerido){
            $dominio_sugerido="0";
        }         
        $este->salida->enviar("Planilla de carga del $titulo",'',array('tipo'=>'label','for'=>'tra_cod_{$ROL}','title'=>"código del $rol_persona"));
        $este->salida->enviar('','',array('tipo'=>'input','id'=>'tra_cod_per','style'=>'width:2.2em','onblur'=>'refrescar_planilla_carga()'
            ,'opciones'=>$tabla_personal->lista_opciones(
                array(
                    'per_ope'=>$GLOBALS['NOMBRE_APP'],
                    'per_rol'=>$rol_persona,
                    'per_activo'=>true,
                )
            )
            ,'opciones_post_proceso'=>'refrescar_planilla_carga()'
            ,'onblur'=>'refrescar_planilla_carga()'
        ));
        $este->salida->enviar("Dispositivo",'',array('tipo'=>'label','for'=>"tra_dispositivo_{$ROL}"));
        $tabla_operativos=$este->nuevo_objeto("Tabla_operativos");
        $tabla_operativos->leer_unico(array(
                'ope_ope'=>$GLOBALS['NOMBRE_APP'],
        ));
        $dispositivo_unico=$tabla_operativos->datos->ope_dispositivo_unico;
        if($dispositivo_unico){
               $este->salida->enviar('','',array('tipo'=>'input','id'=>'tra_dispositivo','style'=>'width:1.4em','value'=>$dispositivo_unico,'disabled'=>true));        
        } elseif ($este->inforol->puede_usar_DM()){        
            $tabla_dispositivo=$este->nuevo_objeto("Tabla_dispositivo");        
            $este->salida->enviar('','',array('tipo'=>'input','id'=>'tra_dispositivo','style'=>'width:1.4em',
                'opciones'=>$tabla_dispositivo->lista_opciones(array()),
                'opciones_post_proceso'=>'refrescar_planilla_carga()',
                'onblur'=>'refrescar_planilla_carga()',
            ));
        } else {
            $este->salida->enviar('','',array('tipo'=>'input','id'=>'tra_dispositivo','style'=>'width:1.4em','value'=>2,'disabled'=>true));
        }
        $este->salida->enviar_boton('Refrescar','',array('onclick'=>'refrescar_planilla_carga()'));
        $este->salida->enviar_boton('cambiar filtros','',array('onclick'=>'visor_encuesta_ocultar_mostrar_filtros(null)','id'=>'cambiar_filtros'));
        $este->salida->enviar('','',array('tipo'=>'br'));
        $este->salida->abrir_grupo_interno('',array('id'=>'grupo_forzar_asignacion','style'=>'display:none'));
            $este->salida->enviar('Permitir incrementar asignación','',array('tipo'=>'span','for'=>'forzar_asignacion'));
            $este->salida->enviar('','',array('tipo'=>'input', 'type'=>'checkbox', 'checked'=>false, 'id'=>'forzar_asignacion'));
            $este->salida->enviar('(solo para dominio 4 y 5 o para supervisor de campo)','',array('tipo'=>'small'));
        $este->salida->cerrar_grupo_interno();        
        $filtro_replica='#todo';
        $filtro=array(
            'vis_encuestas_sin_asignar'=>'#!=0',            
            'vis_replica'=>$filtro_replica,
        );
        if($comuna_sugerida){
            $filtro ['vis_comuna']=$comuna_sugerida;
        }
        if($dominio_sugerido){
            $filtro ['vis_dominio']=$dominio_sugerido;
        }
        enviar_grilla($este->salida,'vista_lotes_a_cargar_'.$SUFIJO_TITULO,array(),false,array(
            'filtro_manual'=>$filtro
        )); 
        enviar_grilla($este->salida,'tem_asignada_'.$SUFIJO_TITULO  ,array(),false, array('simple'=>'true'));
        $filtro_estados='#='.implode("|=",$estados_asignado);
        $este->salida->enviar_script(<<<JS
function parametrizar_planilla_carga(){
    editores['vista_lotes_a_cargar_$SUFIJO_TITULO'].pk_adicional=[tra_cod_per.value,tra_dispositivo.value,forzar_asignacion.checked];
}

function refrescar_planilla_carga(mantener_filtro){
"use strict";
    if(tra_dispositivo.value==2){
        grupo_forzar_asignacion.style.display='';
    }else{
        grupo_forzar_asignacion.style.display='none';
    }
    var editor=editores['tem_asignada_$SUFIJO_TITULO'];
    var tra_cod_per=elemento_existente('tra_cod_per').value;
    document.title='$ROL '+tra_cod_per+' d'+tra_dispositivo.value+' carga'; 
    var tra_estados='{$filtro_estados}';
    if(!mantener_filtro){
        editor.filtro_manual.pla_cod_$ROL=tra_cod_per || null;
    }
    editor.filtro_manual.pla_estado=tra_estados || null; 
    editor.cargar_grilla(document.body,false);
    // editor.filtrar_tabla();
    editores['vista_lotes_a_cargar_$SUFIJO_TITULO'].pk_adicional=[tra_cod_per,forzar_asignacion.checked];
    if(!mantener_filtro){
        editores['vista_lotes_a_cargar_$SUFIJO_TITULO'].filtro_manual.vis_comuna={$comuna_sugerida} || null;
        editores['vista_lotes_a_cargar_$SUFIJO_TITULO'].filtro_manual.vis_dominio={$dominio_sugerido} || null;
        if(!{$comuna_sugerida}){
            delete editores['vista_lotes_a_cargar_$SUFIJO_TITULO'].filtro_manual.vis_comuna;
        }
        if(!{$dominio_sugerido}){
            delete editores['vista_lotes_a_cargar_$SUFIJO_TITULO'].filtro_manual.vis_dominio;
        }
    }
    // editores['vista_lotes_a_cargar_$SUFIJO_TITULO'].filtrar_tabla();
    editores['vista_lotes_a_cargar_$SUFIJO_TITULO'].cargar_grilla(document.body,false);
        // editor.refrescar();
    if(elemento_existente('tra_dispositivo').value=='1'){
        elemento_existente('asignado_dm').style.display='inline';    
        elemento_existente('asignado_dm').style.backgroundColor='LightGreen';    
        elemento_existente('confirmar_entrega_en_papel').style.display='none';
        elemento_existente('imprimir_hoja_de_ruta').style.display='inline';
    }else if (elemento_existente('tra_dispositivo').value=='2'){
        elemento_existente('asignado_dm').style.display='none';
        elemento_existente('confirmar_entrega_en_papel').style.display='inline';
        elemento_existente('imprimir_hoja_de_ruta').style.display='inline';
    }else{
        elemento_existente('asignado_dm').style.display='none';
        elemento_existente('confirmar_entrega_en_papel').style.display='none';
        elemento_existente('imprimir_hoja_de_ruta').style.display='none';
    }
}

function visor_encuesta_ocultar_mostrar_filtros(mostrar){
"use strict";
    if(mostrar==null){
        mostrar=editores.tem_asignada_$ROL.fila_filtro.style.display=='none';
    }
    elemento_existente('cambiar_filtros').value=(mostrar?'ocultar':'mostrar')+' filtros';
    for(var i in editores) if(iterable(i,editores)){
        var editor=editores[i];
        if(editor.fila_filtro){
            editor.fila_filtro.style.display=(mostrar?'table-row':'none');
            editor.fila_botones_orden.style.display=(mostrar?'table-row':'none');
        }
    }
}
function imprimir_hoja_de_ruta(){
    var parametros_para_el_paquete={
        tra_sufijo_rol:"{$este->inforol->sufijo_rol()}",
        tra_cod_per:elemento_existente('tra_cod_per').value,
    };
    var sufijo_titulo="{$este->inforol->sufijo_titulo()}";
    ir_a_otra_url(location.pathname+'?imprimir=imprimir_hoja_de_ruta_'+sufijo_titulo+'&todo='+encodeURIComponent(JSON.stringify(parametros_para_el_paquete)));
    
    //if("{$este->inforol->rol_persona()}"=="encuestador"){              
    //    ir_a_otra_url(location.pathname+'?imprimir=imprimir_hoja_de_ruta&todo='+encodeURIComponent(JSON.stringify(parametros_para_el_paquete)));
    //} else {
    //    ir_a_otra_url(location.pathname+'?imprimir=imprimir_hoja_de_ruta_sup&todo='+encodeURIComponent(JSON.stringify(parametros_para_el_paquete)));
    //};   
    
}
function confirmar_entrega_en_papel(){
    enviar_paquete({
        proceso:"confirmar_entrega_en_papel_{$este->inforol->sufijo_titulo()}",
        paquete:{
            tra_cod_per:elemento_existente('tra_cod_per').value,            
        },    
        cuando_ok:function(mensaje){
            rta=mensaje;
            ok=mensaje.ok;
        },
        usar_fondo_de:elemento_existente('confirmar_entrega_en_papel'),
        mostrar_tilde_confirmacion:true
    });
}
JS
        );
        
        $este->salida->enviar_boton('Imprimir hoja de ruta','',array('id'=>'imprimir_hoja_de_ruta','onclick'=>'imprimir_hoja_de_ruta()','style'=>'display:none'));
        $este->salida->enviar_boton('Confirmar entrega en papel','',array('id'=>'confirmar_entrega_en_papel',
                  'onclick'=>'confirmar_entrega_en_papel()','style'=>'display:none' ));        
        $este->salida->enviar('','',array('tipo'=>'span','style'=>'display:none;', 'id'=>'asignado_dm'));
    }
}

class Vista_lotes_a_cargar_enc extends Vista_lotes_a_cargar{
    function __construct(){
        $this->inforol=new Info_Rol_Enc();
        parent::__construct();
    }    
}

class Vista_lotes_a_cargar_recu extends Vista_lotes_a_cargar{
    function __construct(){
        $this->inforol=new Info_Rol_Recu();
        parent::__construct();
    }
}

class Vista_lotes_a_cargar_sup_telefonico extends Vista_lotes_a_cargar{
    function __construct(){
        $this->inforol=new Info_Rol_Sup_Telefonico();
        parent::__construct();
    }
}
class Vista_lotes_a_cargar_sup_campo extends Vista_lotes_a_cargar{
    function __construct(){
        $this->inforol=new Info_Rol_Sup_Campo();
        parent::__construct();
    }
}
class Vista_lotes_a_cargar extends Vistas{
    function __construct(){
        parent::__construct();
    }
    function post_constructor(){
        parent::post_constructor();
    }
    function definicion_estructura(){
        global $ahora;
        $hoystr=$ahora->format('Y-m-d'); //este es el correcto
        //$hoystr='2014-07-14'; // para probar
        $este=$this;
        $ROL=$este->inforol->sufijo_rol();
        $SUFIJO_TITULO=$este->inforol->sufijo_titulo();
        $estados_asignable=$este->inforol->estados_asignable();
        $this->definir_campo('vis_dominio'                ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_dominio'  ));
        $this->definir_campo('vis_replica'                ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_replica'  ));
        $this->definir_campo('vis_comuna'                 ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_comuna'   ));
        if($GLOBALS['nombre_app']=='same2014'){
            $this->definir_campo('vis_up'                 ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_up'));
        }
        $this->definir_campo('vis_lote'                   ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_lote'));
        $this->definir_campo('vis_tamanno_lote'           ,array('operacion'=>'cuenta','origen'=>'*','title'=>'Cantidad de viviendas en el 
        lote'));
        $ROL_SEM=$ROL == 'enc'?$ROL:'recu';
        $filtro_sql=' (pla_estado='.implode(' or pla_estado= ',$estados_asignable)." ) and pla_cod_$ROL is null and '$hoystr'  BETWEEN sem_carga_{$ROL_SEM}_desde AND sem_carga_{$ROL_SEM}_hasta";
        $this->definir_campo('vis_encuestas_sin_asignar'  ,array('operacion'=>'cuenta_true','origen'=>$filtro_sql,'boton'=>'asignar','proceso'=>"asignar_resto_lote_a_{$SUFIJO_TITULO}",'post_proceso'=>'refrescar_planilla_carga(true)','pre_proceso'=>'parametrizar_planilla_carga(true)'));
        if($ROL == 'enc'){
            $this->definir_campo('vis_cargas_anteriores'      ,array('operacion'=>'concato_unico','origen'=>"pla_fecha_primcarga_$ROL"));
        }
    }
    function clausula_from(){
        return "plana_tem_ inner join semanas on pla_semana = sem_sem ";
    }
}
class Planilla_carga_encuestador extends Planilla_carga{
    function __construct(){
        $this->inforol=new Info_Rol_Enc();
        parent::__construct();
    }
}
class Planilla_carga_recuperador extends Planilla_carga{
    function __construct(){
        $this->inforol=new Info_Rol_Recu();
        parent::__construct();
    }
}

class Planilla_carga_supervisor_campo extends Planilla_carga{
    function __construct(){
        $this->inforol=new Info_Rol_Sup_Campo();
        parent::__construct();
    }
}

class Planilla_carga_supervisor_telefonico extends Planilla_carga{
    function __construct(){
        $this->inforol=new Info_Rol_Sup_Telefonico();
        parent::__construct();
    }
}

class Grilla_tem_asignada_enc extends Grilla_tem_asignada{
    function __construct(){
        $this->inforol=new Info_Rol_Enc();
        parent::__construct();
    }
}

class Grilla_tem_asignada_recu extends Grilla_tem_asignada{
    function __construct(){
        $this->inforol=new Info_Rol_Recu();
        parent::__construct();
    }
}

class Grilla_tem_asignada_sup_campo extends Grilla_tem_asignada{
    function __construct(){
        $this->inforol=new Info_Rol_Sup_Campo();
        parent::__construct();
    }
} 

class Grilla_tem_asignada_sup_telefonico extends Grilla_tem_asignada{
    function __construct(){
        $this->inforol=new Info_Rol_Sup_Telefonico();
        parent::__construct();
    }
} 

class Grilla_tem_asignada_anacon extends Grilla_tem_asignada{
    function __construct(){
        $this->inforol=new Info_Rol_AnaCon();
        parent::__construct();
    }
}

class Grilla_tem_asignada extends Grilla_TEM{
    function campos_a_listar($filtro_para_lectura){
        $ROL=$this->inforol->sufijo_rol();
        $campos_a_listar= array(
            'pla_semana',
            'pla_enc',
            'pla_periodicidad',
            'pla_participacion',
            'pla_comuna',
            'pla_replica',
            'pla_up',
            'pla_lote',
            'pla_cnombre',
            'pla_hn',
            'pla_hp',
            'pla_hd',
            'pla_hab',
            'pla_h4',
            'pla_usp',
            'pla_barrio',
            'pla_ident_edif',
            'pla_obs',
            'pla_marco',
            'pla_zona',
            'pla_cod_'.$ROL, 
            'pla_estado'
        );
        if($ROL=='recu'){
            $campos_a_listar=array_merge($campos_a_listar,array('pla_norea_enc', ));
        }        
        if($ROL=='enc' || $ROL=='recu'){
            $campos_a_listar=array_merge($campos_a_listar,array('pla_dispositivo_'.$ROL,'pla_norea_'.$ROL, ));
        }
        if($ROL=='sup'){
            $campos_a_listar=array_merge($campos_a_listar,array('pla_sup_aleat','pla_sup_dirigida'));
        }
        return $campos_a_listar;
    }
    function campos_editables($filtro_para_lectura){
        $ROL=$this->inforol->sufijo_rol();
        return array('pla_cod_'.$ROL);
    } 
    function cantidadColumnasFijas(){
        return 2;
    }    
}
?>