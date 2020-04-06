<?php
//UTF-8:SÍ

class Planilla_basada_en_TEM extends Proceso_generico{
    function permisos(){
        return array('grupo'=>'recepcionista', 'grupo2'=>'procesamiento','grupo3'=>'ana_sectorial');
    }
    function submenu(){
        return 'recepción';
    }
    function filtro_personal(){
        return array(
            'per_ope'=>$GLOBALS['NOMBRE_APP'],
            'per_activo'=>true,
        );
    }
    function nombre_planilla(){
        return strtolower(get_class($this));
    }
    function __construct(){
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
    function filtro_manual(){
        return array();
    }
    function correr(){
        $este=$this;
        $este->salida->enviar_boton('cambiar filtros','',array('onclick'=>'visor_encuesta_ocultar_mostrar_filtros(null)','id'=>'cambiar_filtros'));
        $opciones_filtro_manual=array();
        $filtro_manual=$this->filtro_manual();
        if($filtro_manual){
            $opciones_filtro_manual=array('filtro_manual'=>$filtro_manual);
        }
        enviar_grilla($este->salida,$this->nombre_planilla(),array(),false,$opciones_filtro_manual);
        $este->salida->enviar_script(<<<JS
    function visor_encuesta_ocultar_mostrar_filtros(mostrar){
    "use strict";
        if(mostrar==null){
            mostrar=editores.{$this->nombre_planilla()}.fila_filtro.style.display=='none';
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
JS
        );
    }
}

class Planilla_correcciones_especiales_TEM extends Planilla_basada_en_TEM{
    function titulo(){
        return 'Correciones especiales de la TEM';
    }
    function permisos(){
        return array('grupo'=>'coor_campo');
    }
    function submenu(){
        return 'coordinación de campo';
    }
}

class Planilla_monitoreo_TEM extends Planilla_basada_en_TEM{
    function titulo(){
        return 'Monitoreo general de la TEM';
    }
    function permisos(){
        return array('grupo'=>'mues_campo','grupo2'=>'procesamiento','grupo3'=>'muestrista','grupo4'=>'cartografia');
    }
    function submenu(){
        return 'muestrista';
    }    
}
class Planilla_inquilinato_campo extends Planilla_basada_en_TEM{
    function titulo(){
        return 'Monitoreo de la TEM para inquilinato';
    }
    function permisos(){
        return array('grupo'=>'subcoor_campo','grupo1'=>'coor_campo','grupo2'=>'dis_con','grupo3'=>'ana_campo');
    }
    function submenu(){
        return 'coordinación de campo';
    }
}
class Planilla_dom5_campo extends Planilla_basada_en_TEM{
    function titulo(){
        return 'Monitoreo de la TEM para dominio 5';
    }
    function permisos(){
        return array('grupo'=>'subcoor_campo','grupo1'=>'coor_campo','grupo2'=>'dis_con','grupo3'=>'ana_campo');
    }
    function submenu(){
        return 'coordinación de campo';
    }
}
class Planilla_monitoreo_campo extends Planilla_basada_en_TEM{
    function titulo(){
        return 'Monitoreo de la TEM';
    }
    function permisos(){
        return array('grupo'=>'subcoor_campo','grupo1'=>'coor_campo','grupo2'=>'dis_con','grupo3'=>'ana_campo', 'grupo4'=>'sup_ing', 'grupo5'=>'coor_listado', 'grupo6'=>'ana_sectorial', 'grupo7'=>'recepcionista');
    }
    function submenu(){
        return 'coordinación de campo';
    }
}

class Planilla_recepcion extends Planilla_basada_en_TEM{
    function correr(){
        $este=$this;
        $ROL=$this->sufijo_rol();
        $tabla_personal=$este->nuevo_objeto("Tabla_personal");
        $this->campos_orden[]='per_apellido';
        $this->campos_orden[]='per_nombre';
        $tabla_personal->definir_campos_orden($this->campos_orden);
        $este->salida->enviar('Persona','',array('tipo'=>'label','for'=>"tra_cod_{$ROL}",'title'=>'código del encuestador/recuperador/supervisor'));
        $este->salida->enviar('','',array('tipo'=>'input','id'=>"tra_cod_{$ROL}",'style'=>'width:4.2em',
            'opciones'=>$tabla_personal->lista_opciones($this->filtro_personal()),                        
        ));
        $este->salida->enviar_boton('Refrescar','',array('onclick'=>'filtrar_planilla()'));
        parent::correr();
        $este->salida->enviar_script(<<<JS
    function filtrar_planilla(){
    "use strict";
        var editor=editores['{$this->nombre_planilla()}'];
        var tra_cod_{$ROL}=elemento_existente('tra_cod_{$ROL}').value;
        document.title=tra_cod_{$ROL}+' {$ROL} recepción '+operativo_actual;
        enviar_paquete({
            proceso:'averiguar_fecha_ultima_carga',
            paquete:{tra_per:tra_cod_{$ROL}, tra_sufijo_rol:"{$ROL}"},
            cuando_ok:function(mensaje){
                editor.filtro_manual.pla_cod_{$ROL}=tra_cod_{$ROL};
                editor.filtro_manual.pla_fecha_carga_{$ROL}=mensaje.pla_fecha_carga_{$ROL};
                if(mensaje.pla_fecha_descarga_{$ROL}){
                    editor.filtro_manual.pla_fecha_descarga_{$ROL}='#fecha '+mensaje.pla_fecha_descarga_{$ROL};
                }
                editor.cargar_grilla(document.body,false);
            }
        });
    }

JS
        );
    }
}

class Planilla_recepcion_recuperador extends Planilla_recepcion{
    function titulo(){
        return 'Planilla de recepción del recuperador';
    }
    function filtro_personal(){
        return array_merge(parent::filtro_personal(),array(            
            'per_rol'=>'recuperador',          
        ));
    }
    function sufijo_rol(){
        return 'recu';
    }
}

class Planilla_recepcion_encuestador extends Planilla_recepcion{
    function titulo(){
        return 'Planilla de recepción del encuestador';
    }
    function filtro_personal(){
        return array_merge(parent::filtro_personal(),
            array('per_rol'=>'encuestador')
            );
    }
    function sufijo_rol(){
        return 'enc';
    }
}


class Planilla_recepcion_supervisor_campo extends Planilla_recepcion{
    function titulo(){
        return 'Planilla de recepción del supervisor de campo';
    }
    function permisos(){
        return array('grupo'=>'subcoor_campo', 'grupo2'=>'procesamiento');
    }
    function filtro_personal(){
        return array_merge(parent::filtro_personal(),array(
            'per_rol'=>'supervisor',            
        ));
    }
    function sufijo_rol(){
        return 'sup';
    }
}

class Planilla_recepcion_supervisor_telefonico extends Planilla_recepcion{
    function titulo(){
        return 'Planilla de recepción del supervisor telefónico';
    }
    function permisos(){
        return array('grupo'=>'subcoor_campo', 'grupo2'=>'procesamiento');
    }
    function filtro_personal(){
        return array_merge(parent::filtro_personal(),array(
            'per_rol'=>'recepcionista',          
        ));
    }
    function sufijo_rol(){
        return 'sup';
    }
}

class Planilla_analista_consistencias extends Planilla_basada_en_TEM{
    function titulo(){
        return 'Planilla analista de consistencias';
    }
    function permisos(){
        return array('grupo'=>'procesamiento', 'grupo2'=>'ana_con');
    }
    function submenu(){
        return 'procesamiento';
    }
    function filtro_personal(){
        return array_merge(parent::filtro_personal(),array(
            'per_per'=>666,
            )// OJO GENERALIZAR            
        );
    }
    function sufijo_rol(){
        return 'anacon';
    }
}

class Grilla_planilla_recepcion_encuestador extends Grilla_planilla_recepcion{
    function codigo_planilla(){
        return 'REC_ENC';
    }
    function cantidadColumnasFijas(){
        return 2;
    }    
}
class Grilla_planilla_recepcion_supervisor extends Grilla_planilla_recepcion{
    function iniciar($nombre_del_objeto_base){
        parent::iniciar($nombre_del_objeto_base);
        /*
        $this->tabla->tablas_lookup["
        (select rs.res_enc as sup_enc, count(*) vis_cuenta_diferencias, 
               string_agg(rs.res_var||'/'||ri.res_var||':'||coalesce(rs.res_valor,'')||'/'||coalesce(ri.res_valor), ', ') vis_cuales_diferencias
          from respuestas rs inner join variables vs on rs.res_var=vs.var_var and rs.res_ope=vs.var_ope and rs.res_for=vs.var_for
               inner join variables vi on vi.var_ope=vs.var_ope and vi.var_var=vs.var_nombre_dr
               inner join matrices on mat_ope=vi.var_ope and mat_for=vi.var_for and mat_mat=vi.var_mat
               inner join plana_s1_ on pla_enc=rs.res_enc and pla_hog=rs.res_hog
               left join respuestas ri on rs.res_ope=ri.res_ope and rs.res_enc=ri.res_enc and rs.res_hog=ri.res_hog and vs.var_nombre_dr=ri.res_var and case when mat_ua='mie' then pla_respond else 0 end=ri.res_mie
          where rs.res_enc=202010 and 
             rs.res_hog=1
            and rs.res_ope='eah2014'
            and rs.res_for='SUP'
            and vs.var_nombre_dr is not null
            and ri.res_valor is distinct from rs.res_valor
          group by rs.res_enc
        ) sup
        "]="pla_enc=sup_enc";
        $this->tabla->campos_lookup['vis_cuenta_diferencias']=false;
        $this->tabla->campos_lookup['vis_cuales_diferencias']=false;
        
        $expr="(select /*rs.res_enc as sup_enc, count(*) vis_cuenta_diferencias, 
               string_agg(rs.res_var||'/'||ri.res_var||':'||coalesce(rs.res_valor,'')||'/'||coalesce(ri.res_valor), ', ') vis_cuales_diferencias
          from respuestas rs inner join variables vs on rs.res_var=vs.var_var and rs.res_ope=vs.var_ope and rs.res_for=vs.var_for
               inner join variables vi on vi.var_ope=vs.var_ope and vi.var_var=vs.var_nombre_dr
               inner join matrices on mat_ope=vi.var_ope and mat_for=vi.var_for and mat_mat=vi.var_mat
               inner join respuestas rs1 on rs1.res_ope=rs.res_ope and rs1.res_for='S1' and rs1.res_mat='' and rs1.res_enc=rs.res_enc and rs1.res_hog=rs.res_hog and rs1.res_var='respond' and rs1.res_mie=0 and rs1.res_exm=0
               left join respuestas ri on rs.res_ope=ri.res_ope and rs.res_enc=ri.res_enc and rs.res_hog=ri.res_hog and vs.var_nombre_dr=ri.res_var and case when mat_ua='mie' then rs1.res_valor::integer else 0 end=ri.res_mie
          where rs.res_enc=pla_enc 
            and rs.res_ope='eah2014'
            and rs.res_for='SUP'
            and vs.var_nombre_dr is not null
            and ri.res_valor is distinct from rs.res_valor
          group by rs.res_enc
        ) 
        ";     
        //$expr="select contar_diferencias(pla_enc)";
        $this->tabla->campos_lookup["$expr as vis_cuenta_diferencias"]=false;
        $this->tabla->campos_lookup["$expr as vis_cuales_diferencias"]=false;
        */
    }
    /*
    function campos_a_listar($filtro_para_lectura){
        $heredados=parent::campos_a_listar($filtro_para_lectura);
        if($heredados!=array('*') && is_array($heredados)){
            $heredados[]='vis_cuenta_diferencias';
            $heredados[]='vis_cuales_diferencias';        
        }
        return $heredados;           
    }
    
    */    
}

class Grilla_planilla_recepcion_supervisor_campo extends Grilla_planilla_recepcion_supervisor{
    function codigo_planilla(){
        return 'REC_SUP_CAM'; 
    }    
}

class Grilla_planilla_recepcion_supervisor_telefonico extends Grilla_planilla_recepcion_supervisor{
    function codigo_planilla(){
        return 'REC_SUP_TEL'; 
    }
}

class Grilla_planilla_analista_consistencias extends Grilla_planilla_recepcion{
    function codigo_planilla(){
        return 'PLA_PRO';
    }
}
class Grilla_planilla_mis_supervisiones_telefonicas extends Grilla_planilla_recepcion{
    function codigo_planilla(){
        return 'PLA_MIS_SUP_TEL';
    }     
    function permite_grilla_sin_filtro(){
        return false; 
    }    
}    
class Grilla_planilla_recepcion extends Grilla_TEM{
    function campos_a_listar($filtro_para_lectura){
        $tabla_pla_var=$this->contexto->nuevo_objeto("Tabla_pla_var");
        $tabla_pla_var->definir_campos_orden("plavar_orden asc");
        $tabla_pla_var->leer_varios(array(
            'plavar_ope'=>$GLOBALS['NOMBRE_APP'],
            'plavar_planilla'=>$this->codigo_planilla(),
            'plavar_orden'=>Filtro_Normal::IS_NOT_NULL
        ));
        while($tabla_pla_var->obtener_leido()){
            $columnas[]='pla_'.$tabla_pla_var->datos->plavar_var;
        }
        return $columnas;
    }
    
    function campos_solo_lectura(){
        //$campos_solo_lectura=parent::campos_solo_lectura();
        $tabla_pla_var=$this->contexto->nuevo_objeto("Tabla_pla_var");
        $tabla_pla_var->definir_campos_orden("plavar_orden asc");
        $tabla_pla_var->leer_varios(array(
            'plavar_ope'=>$GLOBALS['NOMBRE_APP'],
            'plavar_planilla'=>$this->codigo_planilla(),
            'plavar_editable'=>false,
            'plavar_orden'=>Filtro_Normal::IS_NOT_NULL,            
        ));
        while($tabla_pla_var->obtener_leido()){
                $campos_solo_lectura[]='pla_'.$tabla_pla_var->datos->plavar_var;
        }
        return $campos_solo_lectura;
    }
    
    function campos_a_excluir($filtro_para_lectura){
        $campos_a_excluir=parent::campos_a_excluir($filtro_para_lectura);   
        $campos_a_excluir[]='pla_carga';
        return $campos_a_excluir;
    }
    function boton_enviar(){
        return array(
            'leyenda'=>'ir',
            'title'=>'abrir encuesta',
            'proceso'=>'ingresar_encuesta',
            'campos_parametros'=>array('tra_enc'=>null,'tra_hn'=>array('forzar_valor'=>-951)),
            'y_luego'=>'boton_ingresar_encuesta',
        );
    }
}

class Grilla_planilla_recepcion_recuperador extends Grilla_planilla_recepcion{
    function codigo_planilla(){
        return 'REC_REC';
    }
    function cantidadColumnasFijas(){
        return 2;
    }    
}

class Grilla_planilla_monitoreo_TEM extends Grilla_planilla_recepcion{
    function codigo_planilla(){
        return 'MON_TEM';
    }
    function campos_a_excluir($filtro_para_lectura){
        $excluir_claves=nombres_campos_claves("pla_","N");
        array_shift($excluir_claves);
        return $excluir_claves;
    }     
    function cantidadColumnasFijas(){
        return 2;
    }
    function campos_editables($filtro_para_lectura){
        $editables=array();
        $tabla_pla_var=$this->contexto->nuevo_objeto("Tabla_pla_var");
        $tabla_pla_var->definir_campos_orden("plavar_orden asc");
        $tabla_pla_var->leer_varios(array(
            'plavar_ope'=>$GLOBALS['NOMBRE_APP'],
            'plavar_planilla'=>$this->codigo_planilla(),
            'plavar_editable'=>true,
            'plavar_orden'=>Filtro_Normal::IS_NOT_NULL,            
        ));
        while($tabla_pla_var->obtener_leido()){
            $editables[]='pla_'.$tabla_pla_var->datos->plavar_var;
        }
        if(tiene_rol('mues_campo')){
            $editables[]='pla_semana';
            //$editables[]='pla_procedencia';
            //$editables[]='pla_yearfuente';
            //$editables[]='pla_up_comuna';
            //$editables[]='pla_operacion'; 
            //$editables[]='pla_h4_mues'; 
            //$editables[]='pla_frac_comun'; 
            //$editables[]='pla_radio_comu'; 
            //$editables[]='pla_mza_comuna'; 
            //$editables[]='pla_clado'; 
            //$editables[]='pla_id_marco';
        }
        return $editables;
    }
}

class Grilla_planilla_monitoreo_campo extends Grilla_planilla_monitoreo_TEM{
   /* 
    function iniciar($tov){
        parent::iniciar($tov);
        $this->tabla->clausula_where_agregada_manual="  and pla_estado is distinct from 18 ";        
    }
    */
    function campos_editables($filtro_para_lectura){
        $editables=array();
        $tabla_pla_var=$this->contexto->nuevo_objeto("Tabla_pla_var");
        $tabla_pla_var->definir_campos_orden("plavar_orden asc");
        $tabla_pla_var->leer_varios(array(
            'plavar_ope'=>$GLOBALS['NOMBRE_APP'],
            'plavar_planilla'=>$this->codigo_planilla(),
            'plavar_editable'=>true,
            'plavar_orden'=>Filtro_Normal::IS_NOT_NULL,            
        ));
        while($tabla_pla_var->obtener_leido()){
            $editables[]='pla_'.$tabla_pla_var->datos->plavar_var;
        }
        if(tiene_rol('subcoor_campo','coor_campo','coor_listado')){
            $editables[]='pla_semana';
            $editables[]='pla_reserva';
            if(tiene_rol('subcoor_campo','coor_campo')){
                $editables[]='pla_cod_recu';
                $editables[]='pla_cod_sup';
            }
            if(tiene_rol('coor_campo')){
                $editables[]='pla_recepcionista';
            }    
        }
        return $editables;
    }
    function codigo_planilla(){
        return 'MON_TEM_CAMPO';
    }
    function cantidadColumnasFijas(){
        return 2;
    }
}
class Grilla_planilla_inquilinato_campo extends Grilla_planilla_monitoreo_TEM{
    function iniciar($tov){
        parent::iniciar($tov);
        $this->tabla->clausula_where_agregada_manual="  and pla_dominio=4 " ;        
    }
    function codigo_planilla(){
        return 'MON_INQ_CAMPO';
    }
    function cantidadColumnasFijas(){
        return 2;
    }
}
class Grilla_planilla_dom5_campo extends Grilla_planilla_monitoreo_TEM{
    function iniciar($tov){
        parent::iniciar($tov);
        $this->tabla->clausula_where_agregada_manual="  and pla_dominio=5 " ;        
    }
    function codigo_planilla(){
        return 'MON_DOM5_CAMPO';
    }
    function cantidadColumnasFijas(){
        return 2;
    }
}
class Grilla_correccion_TEM extends Grilla_planilla_recepcion_encuestador{
    function campos_editables($filtro_para_lectura){
        return array_merge(
            parent::campos_editables($filtro_para_lectura),
            array('pla_per','pla_cod_enc','pla_norea_e','pla_cod_recu','pla_norea_r','pla_dispositivo','pla_norea','pla_fecha_carga', 'pla_fecha_descarga', 'pla_estado_carga','pla_codsup')
        );
    }
}

class Planilla_encuestas_pendientes_verificar extends Planilla_basada_en_TEM{
    function titulo(){
        return 'Planilla de encuestas pendientes de verificar';
    }
    function permisos(){
        return array('grupo'=>'recepcionista', 'grupo2'=>'procesamiento');
    }
    function submenu(){
        return 'recepción';
    }    
    function filtro_personal(){
        if(tiene_rol('subcoor_campo') || tiene_rol('mues_campo') || tiene_rol('programador')|| tiene_rol('procesamiento')){
            return array();
        }
        return array_merge(parent::filtro_personal(),array(
            'per_rol'=>'recepcionista',
        ));
    }    
}
class Grilla_planilla_encuestas_pendientes_verificar extends Grilla_planilla_monitoreo_TEM{
    function codigo_planilla(){
        return 'PLA_ENC_VER';
    }
    function iniciar($tov){
        parent::iniciar($tov); 
        $X_PLANILLA=$this->codigo_planilla();
        $this->tabla->campos_lookup=array(
            "per_codigo"=>true,
            "per_est"=>false,
        );       
        
        if (tiene_rol('subcoor_campo')){
            $recepcionista_filtro=" pla_recepcionista is not null ";
            //$texto_where_lookup=" true ";
            $texto_where_lookup=" per_rol='recepcionista' ";
        } else {
            $recepcionista_filtro=" pla_recepcionista=per_codigo ";
            $texto_where_lookup="per_usu='".usuario_actual()."'";
        }
        $this->tabla->tablas_lookup=array(            
            "(select per_per as per_codigo, y.plaest_est as per_est
                from personal,
                (select plaest_est 
                   from encu.pla_est
                   where plaest_planilla='{$X_PLANILLA}' ) as y 
                 where {$texto_where_lookup} ) per"=>" pla_recepcionista=per_codigo and pla_estado=per_est ",
        );
        $this->tabla->clausula_where_agregada_manual=" and ({$recepcionista_filtro} and pla_estado=per_est) ";                    
    }
    function permite_grilla_sin_filtro(){
        return true; //para que muestre la información de las encuestas sin verificar del recepcionista apenas entra a la grilla.
    }    
}

class Planilla_mis_supervisiones_telefonicas extends Planilla_basada_en_TEM{
    function titulo(){
        return 'Planilla de mis supervisiones telefónicas';
    }
    function permisos(){
        return array('grupo'=>'recepcionista', 'grupo2'=>'procesamiento');
    }
    function submenu(){
        return 'recepción';
    }
    function filtro_manual(){
        $this->tabla_personal=$this->nuevo_objeto("Tabla_personal");
        $this->tabla_personal->leer_uno_si_hay(array('per_usu'=>usuario_actual()));
        if($this->tabla_personal->obtener_leido()){
            $cod_sup=$this->tabla_personal->datos->per_per;
        }else{
            $cod_sup=-1;
        }
        return array('pla_cod_sup'=>$cod_sup,'pla_sup_aleat'=>'#=4|pla_sup_dirigida=4','pla_verificado_sup'=>'#vacio');
    }        
}
?>