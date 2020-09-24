<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";
require_once "tabla_saltos.php";

class Tabla_opciones extends Tabla{
    var $mostrar_texto_de_la_opcion_en_cada_renglon=true;
    function definicion_estructura(){
        $this->definir_prefijo('opc');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('opc_ope',array('hereda'=>'operativos','modo'=>'pk','validart'=>'codigo'));
        $this->definir_campo('opc_conopc',array('hereda'=>'con_opc','modo'=>'pk','validart'=>'codigo'));
        $this->definir_campo('opc_opc',array('es_pk'=>true, 'tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('opc_texto',array('tipo'=>'texto','largo'=>500,'not_null'=>true,'validart'=>'castellano'));
        $this->definir_campo('opc_aclaracion',array('tipo'=>'texto','largo'=>500,'validart'=>'castellano'));
        $this->definir_campo('opc_orden',array('tipo'=>'entero'));
        $this->definir_campo('opc_proxima_vacia',array('tipo'=>'logico'));
        $this->definir_campo('opc_proxima_opc',array('tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('opc_proxima_texto',array('tipo'=>'texto','largo'=>500));
        $this->definir_tablas_hijas(array(
            'saltos'=>true));
        $this->definir_campos_orden(array('opc_conopc','opc_orden'));
    }
    function desplegar(){
                // OJO: PROVISORIO PARA FORMATEO:
        $this->datos->opc_texto=str_replace('/','/'.AUTF8_SPZW,$this->datos->opc_texto);
        $this->datos->opc_texto=str_replace('/'.AUTF8_SPZW.'NC','/NC',$this->datos->opc_texto);       
        $opciones_del_area_sensible=array(
            'id'=>$this->despliegue->tabla_variables->id_dom.'__'.$this->datos->opc_opc,
            'tipo'=>'SPAN'
        );
        if($this->despliegue->tabla_variables->datos->var_editable_por!=='nadie'){
            $opciones_del_area_sensible['onclick']="PonerOpcion('".$this->despliegue->tabla_variables->id_dom."','".$this->datos->opc_opc."')";
        }
        $nombre_de_la_clase_opcion='opcion_codigo';
        $pongo_en_blanco=false;
        if ($this->datos->opc_proxima_vacia=='SI'){
          $pongo_en_blanco=true;
          $nombre_de_la_clase_en_blanco='opcion_codigo_deshabilitar';
        }
        if($this->despliegue->tabla_preguntas->datos->pre_desp_opc == 'vertical'){
            if (!($this->despliegue->tabla_con_opc->datos->conopc_despliegue=='horizontal')){
                $this->contexto->salida->abrir_grupo_interno('renglon_opciones',array('tipo'=>'TR'));
            }
            $rowspan_input=$this->cursor->rowCount();
            if(!$this->despliegue->tabla_variables->datos->ya_puse_el_input){
                $this->contexto->salida->abrir_grupo_interno("celda_input",array('tipo'=>'TD','rowspan'=>$rowspan_input));
                    $this->despliegue->tabla_variables->desplegar_el_input("opciones");
                $this->contexto->salida->cerrar_grupo_interno();
                $this->despliegue->tabla_variables->datos->ya_puse_el_input=true;
            }                
            $this->contexto->salida->abrir_grupo_interno('opcion_codigo',array('tipo'=>'TD'));
                $this->contexto->salida->enviar($this->datos->opc_opc,'opcion_codigo_id',array('tipo'=>'span'));
            $this->contexto->salida->cerrar_grupo_interno();
            $this->contexto->salida->abrir_grupo_interno('opcion_texto',array('tipo'=>'TD'));
                $this->contexto->salida->enviar($this->datos->opc_texto,'opcion_texto',$opciones_del_area_sensible);
                $this->contexto->salida->enviar($this->datos->opc_aclaracion,'opcion_aclaracion', array('tipo'=>'SPAN'));
                if($this->despliegue->tabla_con_opc->datos->conopc_despliegue!='horizontal'){
                    $this->despliegue->tabla_variables->desplegar_cual_especificar($this->datos->opc_opc);   
                }
            $this->contexto->salida->cerrar_grupo_interno();                                
            $this->despliegue->tabla_variables->desplegar_salto($this->datos);                
            if (!($this->despliegue->tabla_con_opc->datos->conopc_despliegue=='horizontal')){
                $this->contexto->salida->cerrar_grupo_interno();
            }            
        }else if(!$this->despliegue->tabla_preguntas->datos->todavia_sin_mostrar){
            $rowspan_input=1;
            if(!$this->despliegue->tabla_variables->datos->ya_puse_el_input){
                $this->contexto->salida->abrir_grupo_interno("celda_input",array('tipo'=>'TD'));
                    $this->despliegue->tabla_variables->desplegar_el_input("opciones");
                $this->contexto->salida->cerrar_grupo_interno();
                $this->despliegue->tabla_variables->datos->ya_puse_el_input=true;
            }
            $this->contexto->salida->abrir_grupo_interno($nombre_de_la_clase_opcion,array('tipo'=>'TD','colspan'=>2));
                $this->contexto->salida->abrir_grupo_interno($nombre_de_la_clase_opcion,$opciones_del_area_sensible);
                    $this->contexto->salida->enviar($this->datos->opc_opc,'id_opcion',array('tipo'=>'span'));
                    if($this->mostrar_texto_de_la_opcion_en_cada_renglon){
                        $this->contexto->salida->enviar(AUTF8_NBSP.$this->datos->opc_texto,'',array('tipo'=>'span'));
                    }else{
                        $this->contexto->salida->enviar(AUTF8_NBSP.OPCION_TOCAR,'',array('tipo'=>'span'));
                    }
                $this->contexto->salida->cerrar_grupo_interno();
                if($this->despliegue->tabla_con_opc->datos->conopc_despliegue!='horizontal'){
                    $this->despliegue->tabla_variables->desplegar_cual_especificar($this->datos->opc_opc);
                }
            $this->contexto->salida->cerrar_grupo_interno();
            if ($pongo_en_blanco){
              $this->contexto->salida->abrir_grupo_interno($nombre_de_la_clase_en_blanco,array('tipo'=>'TD','colspan'=>2));
              $this->contexto->salida->enviar(''.AUTF8_NBSP,$nombre_de_la_clase_en_blanco,array('tipo'=>'SPAN'));
              $this->contexto->salida->cerrar_grupo_interno();            
            }
        }
        if($this->despliegue->tabla_preguntas->datos->pre_desp_opc == 'horizontal' && !$this->mostrar_texto_de_la_opcion_en_cada_renglon){
            // ESTOS SON LOS ENCABEZADOS DE LAS OPCIONES HORIZONTALES
            if($this->despliegue->tabla_preguntas->datos->todavia_sin_mostrar || $this->despliegue->tabla_variables->cursor->rowCount() == 1){
                if($this->despliegue->tabla_preguntas->datos->todavia_sin_mostrar){
                    $this->contexto->salida->abrir_grupo_interno('opcion_codigo',array('tipo'=>'TD'));
                        $this->contexto->salida->enviar($this->datos->opc_opc,'opcion_codigo_id',array('tipo'=>'span'));
                    $this->contexto->salida->cerrar_grupo_interno();
                }
                // OJO: PROVISORIO PARA FORMATEO:
                if($this->despliegue->tabla_variables->datos->var_conopc_texto == 'abreviatura'){
                    $this->contexto->salida->enviar(substr($this->datos->opc_texto,0,2),'opcion_texto',array('tipo'=>'TD'));
                }else{
                    $this->contexto->salida->enviar($this->datos->opc_texto,'opcion_texto',array('tipo'=>'TD'));
                }
                if ($pongo_en_blanco){
                    $this->contexto->salida->abrir_grupo_interno('opcion_codigo',array('tipo'=>'TD'));
                        $this->contexto->salida->enviar($this->datos->opc_proxima_opc,'opcion_codigo_id',array('tipo'=>'span'));
                    $this->contexto->salida->cerrar_grupo_interno();
                    $this->contexto->salida->enviar(substr($this->datos->opc_proxima_texto,0,2),'opcion_texto',array('tipo'=>'TD'));
                }
            }
        }        
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE opciones
  ADD CONSTRAINT "texto invalido en opc_aclaracion de tabla opciones" CHECK (comun.cadena_valida(opc_aclaracion::text, 'cualquiera'::text));
/*OTRA*/
ALTER TABLE opciones
  ADD CONSTRAINT "texto invalido en opc_conopc de tabla opciones" CHECK (comun.cadena_valida(opc_conopc::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE opciones
  ADD CONSTRAINT "texto invalido en opc_opc de tabla opciones" CHECK (comun.cadena_valida(opc_opc::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE opciones
  ADD CONSTRAINT "texto invalido en opc_ope de tabla opciones" CHECK (comun.cadena_valida(opc_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE opciones
  ADD CONSTRAINT "texto invalido en opc_proxima_opc de tabla opciones" CHECK (comun.cadena_valida(opc_proxima_opc::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE opciones
  ADD CONSTRAINT "texto invalido en opc_proxima_texto de tabla opciones" CHECK (comun.cadena_valida(opc_proxima_texto::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE opciones
  ADD CONSTRAINT "texto invalido en opc_texto de tabla opciones" CHECK (comun.cadena_valida(opc_texto::text, 'cualquiera'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}

?>