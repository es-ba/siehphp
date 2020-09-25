<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_variables extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('var');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('var_ope',array('hereda'=>'operativos','modo'=>'pk','validart'=>'codigo'));
        $this->definir_campo('var_for',array('hereda'=>'formularios','modo'=>'fk_obligatoria','validart'=>'codigo'));
        $this->definir_campo('var_mat',array('hereda'=>'matrices','modo'=>'fk_obligatoria','forzar_null_a_vacio'=>true,'validart'=>'codigo'));
        $this->definir_campo('var_pre',array('hereda'=>'preguntas','modo'=>'fk_obligatoria','validart'=>'codigo'));
        $this->definir_campo('var_var',array('es_pk'=>true,'tipo'=>'texto','largo'=>50,'not_null'=>true,'validart'=>'codigo'));
        $this->definir_campo('var_texto',array('tipo'=>'texto','largo'=>3000,'validart'=>'castellano'));
        $this->definir_campo('var_aclaracion',array('tipo'=>'texto','largo'=>500));
        $this->definir_campo('var_conopc',array('hereda'=>'con_opc','modo'=>'fk_optativa','validart'=>'codigo'));
        $this->definir_campo('var_conopc_texto',array('tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('var_tipovar',array('tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('var_destino',array('tipo'=>'texto','largo'=>50,'validart'=>'codigo'));        
        $this->definir_campo('var_subordinada_var',array('tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('var_subordinada_opcion',array('tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('var_desp_nombre',array('tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('var_expresion_habilitar',array('tipo'=>'texto','largo'=>500,'validart'=>'formula'));
        $this->definir_campo('var_optativa',array('tipo'=>'logico'));
        $this->definir_campo('var_editable_por',array('tipo'=>'texto','validart'=>'codigo'));
        $this->definir_campo('var_orden',array('tipo'=>'entero'));
        $this->definir_campo('var_nsnc_atipico',array('tipo'=>'entero'));
        $this->definir_campo('var_mejor_de_pregunta',array('tipo'=>'texto','largo'=>50,'validart'=>'codigo')); // OJO falta heredar de preguntas, herencia múltiple.
        $this->definir_campo('var_maximo',array('tipo'=>'entero')); 
        $this->definir_campo('var_minimo',array('tipo'=>'entero')); 
        $this->definir_campo('var_advertencia_sup',array('tipo'=>'entero')); 
        $this->definir_campo('var_advertencia_inf',array('tipo'=>'entero')); 
        $this->definir_campo('var_destino_nsnc',array('tipo'=>'texto','validart'=>'codigo')); 
        $this->definir_campo('var_calculada',array('tipo'=>'texto', 'largo'=>500));
        $this->definir_campo('var_nombre_dr',array('tipo'=>'texto'));
        $this->definir_campo('var_ocu_sal',array('tipo'=>'logico'));
        if (substr($GLOBALS['NOMBRE_APP'],0,4)=='eder'&& $GLOBALS['anio_operativo']=2017 ){
            $this->definir_campo('var_grilla',array('tipo'=>'texto', 'largo'=>50));
            $this->definir_campo('var_fija'  ,array('tipo'=>'logico'));
        }
        $this->definir_tablas_hijas(array(
            'saltos'=>true,
            'respuestas'=>false,
            'con_var'=>true,
            'pla_var'=>true,         
            'est_var'=>true,         
        ));
        $this->definir_campos_orden('(select varord_orden_total from var_orden where varord_ope=var_ope and varord_var=var_var)');
    }
    function desplegar_subtablas(){
        if($this->datos->var_conopc){
            $this->despliegue->tabla_con_opc=$tabla_con_opc=$this->definicion_tabla('con_opc');
            $tabla_con_opc->leer_pk(array(
                $this->datos->var_ope,
                $this->datos->var_conopc
            ));
            $this->despliegue->tabla_opciones=$tabla_opciones=$this->definicion_tabla('opciones');
            $tabla_opciones->leer_varios(array(
                'opc_ope'=>$tabla_con_opc->datos->conopc_ope,
                'opc_conopc'=>$tabla_con_opc->datos->conopc_conopc
            ));
            while($tabla_opciones->obtener_leido()){
                $tabla_opciones->desplegar();
            }
            if($this->despliegue->tabla_con_opc->datos->conopc_despliegue=='horizontal'){
                $tabla_opciones->leer_varios(array(
                    'opc_ope'=>$tabla_con_opc->datos->conopc_ope,
                    'opc_conopc'=>$tabla_con_opc->datos->conopc_conopc
                ));
                while($tabla_opciones->obtener_leido()){
                    $this->despliegue->tabla_variables->desplegar_cual_especificar($tabla_opciones->datos->opc_opc);   
                }
            }
        }else{
            // poner los otros input que no son de opcion. 
            $subclase="";
            $clase="";
            // OJO: PROVISORIO. Solo poner esto en las matrices muy anchas.
            if($this->datos->var_subordinada_var && $this->despliegue->tabla_preguntas->datos->pre_desp_opc == 'horizontal'){
                $subclase="elemento_angosto";
            }
            if ($this->datos->var_tipovar!=null){
                $clase=strtolower(trim($this->datos->var_tipovar));
            }
            else{
                $clase="variable";
            }
            if(!"antes de habilitar el texto para todas las subordinadas hay que revisar los datos"
                || @$this->cantidad_variables_subordinadas_que_estoy_mostrando_en_esta_vuelta>0
                || @$this->datos->var_tipovar=="monetaria" //RO-ML Cambio realizado para que en las variables monetarias aparezca el texto que es $ en el caso de la pregunta I3
            ){
                if($this->datos->var_subordinada_var){
                    if($this->despliegue->tabla_con_opc->datos->conopc_despliegue=='horizontal'){
                        $this->contexto->salida->enviar($this->datos->var_texto,"opcion_aclaracion meta_reem",array('tipo'=>'TD'));
                    } else {
                        $this->contexto->salida->enviar($this->datos->var_texto,"opcion_aclaracion meta_reem",array('tipo'=>'span'));
                    }                    
                }
            }
            Loguear('2017-08-22','#####despliega input variable '.$clase);
            $this->desplegar_el_input($clase,$subclase);
            //$this->desplegar_cual_especificar('1');
            $this->desplegar_cual_especificar_var();
        }
        if($this->datos->var_destino){
            if($this->datos->var_subordinada_var){
                $id_salto_min=strtolower($this->datos->var_destino);
                $id_salto='var_'.$id_salto_min;
                $this->contexto->salida->enviar(CARACTER_SALTO.' '.ucfirst($this->datos->var_destino),'opcion_salto',
                    array(
                        'tipo'=>'TD',
                    )
                );
            }else{
                $id_salto_min=strtolower($this->datos->var_destino);
                $id_salto='var_'.$id_salto_min;
                if($this->datos->var_conopc){
                    $this->contexto->salida->enviar(CARACTER_SALTO.' '.ucfirst($this->datos->var_destino),'opcion_salto_grande',
                        array(
                            'tipo'=>'TD',
                            'colspan'=>2
                        )
                    );
                }else{
                    $this->contexto->salida->enviar(CARACTER_SALTO." ".ucfirst($this->datos->var_destino),'opcion_salto',
                        array(
                            'tipo'=>'td',
                        )
                    );
                }
            }
        }
    } 
    function desplegar(){
        $this->id_dom='var_'.$this->despliegue->tabla_variables->datos->var_var;
        $operativo=$this->despliegue->tabla_variables->datos->var_ope;
        $numero_opcion_para_multiples = ($this->datos->var_tipovar=='multiple_marcar' || $this->datos->var_tipovar=='multiple_nsnc')?substr(strrchr($this->datos->var_var, '_'), 1):NULL;
        $opciones_del_area_sensible=array(
            'id'=>$this->id_dom.'__'.$numero_opcion_para_multiples,
            'onclick'=>"PonerOpcion('".$this->id_dom."','".$numero_opcion_para_multiples."')"
        );        
        $this->datos->ya_puse_el_input=false;
        $this->despliegue->tabla_preguntas->datos->todavia_sin_mostrar = $this->despliegue->tabla_preguntas->datos->tipo_conopc_anterior != $this->datos->var_conopc?true:false;
        if($this->despliegue->tabla_preguntas->datos->todavia_sin_mostrar && $this->despliegue->tabla_preguntas->datos->pre_desp_opc == 'horizontal' && $this->cursor->rowCount()>1){
            $this->contexto->salida->abrir_grupo_interno("renglon_variable",array('tipo'=>'TR', 'id'=>'tr3_var_'.$this->datos->var_var,'referencia'=>'pregunta-'.$this->datos->var_pre));
                $this->contexto->salida->enviar('',"",array('tipo'=>'TD','colspan'=>2));
                $this->desplegar_subtablas();
            $this->contexto->salida->cerrar_grupo_interno();
        }
        $this->despliegue->tabla_preguntas->datos->tipo_conopc_anterior = $this->datos->var_conopc;
        $this->despliegue->tabla_preguntas->datos->todavia_sin_mostrar = false;
        $this->contexto->salida->abrir_grupo_interno("renglon_variable",array('tipo'=>'TR','referencia'=>'pregunta-'.$this->datos->var_pre));
            if($this->datos->var_tipovar=='multiple_marcar' || $this->datos->var_tipovar=='multiple_nsnc'){
                $clase_td_texto="td_texto_variable_multiple";
                $this->contexto->salida->abrir_grupo_interno("td_input_multiple",array('tipo'=>'TD'));
                    $this->desplegar_el_input("marcar");
                $this->contexto->salida->cerrar_grupo_interno();
                $ya_desplegue_subtablas=true;
            }else{
                $clase_td_texto="encabezado_variable";
                $ya_desplegue_subtablas=false;
            }
            $this->contexto->salida->abrir_grupo_interno($clase_td_texto,array('tipo'=>'TD'));
                if($this->despliegue->tabla_preguntas->tiene_una_sola_variable_sin_texto){
                    $this->contexto->salida->enviar(
                        $this->despliegue->tabla_preguntas->datos->pre_desp_nombre===NULL
                            ?$this->despliegue->tabla_preguntas->datos->pre_pre
                            :$this->despliegue->tabla_preguntas->datos->pre_desp_nombre
                        ,"pre_pre"
                    );
                }else{
                    $this->contexto->salida->enviar($this->datos->var_tipovar=='multiple_marcar' || $this->datos->var_tipovar=='multiple_nsnc'?$numero_opcion_para_multiples:($this->datos->var_desp_nombre===NULL?$this->datos->var_var:$this->datos->var_desp_nombre),"var_var");
                }
                if($this->despliegue->tabla_preguntas->datos->pre_texto && !$this->datos->var_texto){
                    $this->contexto->salida->enviar($this->despliegue->tabla_preguntas->datos->pre_texto,"pre_texto meta_reem");
                    $this->contexto->salida->enviar($this->despliegue->tabla_preguntas->datos->pre_aclaracion,"pre_aclaracion meta_reem",array('tipo'=>'SPAN'));
                    if($this->datos->var_var=='entrea'){
                        $this->contexto->salida->enviar('',"datos_seguimiento",array('id'=>'mas_datos_entrea'));
                    }
                    /*if($this->datos->var_destino){
                        $this->contexto->salida->enviar(CARACTER_SALTO.' '.ucfirst($this->datos->var_destino),"var_destino",array('tipo'=>'SPAN'));
                    }*/ 
                }else if($this->datos->var_tipovar == 'multiple_marcar' || $this->datos->var_tipovar == 'multiple_nsnc'){
                    $this->contexto->salida->enviar($this->datos->var_texto,"var_texto meta_reem", $opciones_del_area_sensible);
                    $this->contexto->salida->enviar($this->datos->var_aclaracion,"var_aclaracion meta_reem",array('tipo'=>'SPAN'));
                    $this->desplegar_cual_especificar_var();
                }else if($this->datos->var_tipovar == 'si_no'){ //&& @$this->despliegue->tabla_con_opc->datos->conopc_despliegue=='horizontal'){
                    $this->despliegue->tabla_con_opc=$tabla_con_opc=$this->definicion_tabla('con_opc');
                    $tabla_con_opc->leer_pk(array(
                        $this->datos->var_ope,
                        $this->datos->var_conopc
                    ));                    
                    if(@$this->despliegue->tabla_con_opc->datos->conopc_despliegue=='horizontal'){
                        $texto_opcion=substr($this->datos->var_var,strlen($this->despliegue->tabla_preguntas->datos->pre_pre));
                        if(substr($texto_opcion,0,1)=='_'){
                            $texto_opcion=substr($texto_opcion,1);
                        }
                        $this->contexto->salida->enviar($texto_opcion,"opc_var",array('tipo'=>'SPAN'));                    
                        $this->contexto->salida->enviar($this->datos->var_texto,"var_texto meta_reem",array('tipo'=>'SPAN'));
                        $this->contexto->salida->enviar($this->datos->var_aclaracion,"var_aclaracion meta_reem",array('tipo'=>'SPAN'));
                    }
                }else{
                    if(@$this->datos->var_desp_nombre){
                        $this->contexto->salida->enviar($this->datos->var_desp_nombre,"var_desp_nombre",array('tipo'=>'SPAN'));
                    }
                    $this->contexto->salida->enviar($this->datos->var_texto,"var_texto meta_reem",array('tipo'=>'SPAN'));
                    $this->contexto->salida->enviar($this->datos->var_aclaracion,"var_aclaracion meta_reem",array('tipo'=>'SPAN'));
                }
                if(!$ya_desplegue_subtablas){
                    if($this->despliegue->tabla_preguntas->datos->pre_desp_opc == 'vertical'){
                        $this->contexto->salida->abrir_grupo_interno("celda_opciones_verticales",array('tipo'=>'TD'));
                            $this->contexto->salida->abrir_grupo_interno("",array('tipo'=>'table'));
                                $this->desplegar_subtablas();
                            $this->contexto->salida->cerrar_grupo_interno();                                
                        $this->contexto->salida->cerrar_grupo_interno();
                    }else{
                        $this->desplegar_subtablas();
                    }
                }
            $this->contexto->salida->cerrar_grupo_interno();
        $this->contexto->salida->cerrar_grupo_interno();
    }
    function desplegar_salto($opciones_datos = null){
        $this->despliegue->tabla_saltos=$tabla_saltos=$this->definicion_tabla('saltos');
        if($opciones_datos){
            $tabla_saltos->leer_varios(array(
            'sal_ope'=>$opciones_datos->opc_ope,
            'sal_opc'=>$opciones_datos->opc_opc,
            'sal_conopc'=>$opciones_datos->opc_conopc,
            'sal_var'=>$this->datos->var_var
            ));
        }
        $id_salto='';
        if($tabla_saltos->obtener_leido()){
            $id_salto_min=strtolower($tabla_saltos->datos->sal_destino);
            $id_salto='var_'.$id_salto_min;
            $this->contexto->salida->enviar(CARACTER_SALTO.' '.ucfirst($tabla_saltos->datos->sal_destino),'opcion_salto',
                array(
                    'tipo'=>'TD',
                    /* 'onclick'=>"Saltar_de_a('".$this->id_dom."','".$id_salto."')" */
                )
            );
        }
    }
    function desplegar_cual_especificar($opc_opc){
        $this->despliegue->tabla_variables_especificar=$tabla_variables_especificar=$this->definicion_tabla('variables');
        $tabla_variables_especificar->leer_varios(array(
            'var_ope'=>$this->datos->var_ope,
            'var_for'=>$this->datos->var_for,
            'var_pre'=>$this->datos->var_pre,
            'var_subordinada_var'=>$this->datos->var_var, 
            'var_subordinada_opcion'=>$opc_opc
        ));
        $tabla_variables_especificar->cantidad_variables_subordinadas_que_estoy_mostrando_en_esta_vuelta=0;
        while($tabla_variables_especificar->obtener_leido()){
            $tabla_variables_especificar->cantidad_variables_subordinadas_que_estoy_mostrando_en_esta_vuelta++;
            $tabla_variables_especificar->id_dom='var_'.$tabla_variables_especificar->datos->var_var;
            $tabla_variables_especificar->desplegar_subtablas();
        }
    }
    function desplegar_cual_especificar_var(){
        $this->despliegue->tabla_variables_especificar=$tabla_variables_especificar=$this->definicion_tabla('variables');
        $tabla_variables_especificar->leer_varios(array(
            'var_ope'=>$this->datos->var_ope,
            'var_for'=>$this->datos->var_for,
            'var_pre'=>$this->datos->var_pre,
            'var_subordinada_var'=>$this->datos->var_var, 
        ));
        while($tabla_variables_especificar->obtener_leido()){
            $tabla_variables_especificar->id_dom='var_'.$tabla_variables_especificar->datos->var_var;
            $tabla_variables_especificar->desplegar_subtablas();
        }
    }
    function desplegar_el_input($tipo_de_input,$subclase=""){
        $clase_de_input='input_'.$tipo_de_input.' '.$subclase;
        global $que_teclado_mostrar;
        if(@$this->despliegue->tabla_con_opc->datos->conopc_despliegue=='horizontal'){
            if(in_array($tipo_de_input, array('texto_especificar', 'texto_libre', 'texto', 'observaciones'))){ //seria mejor hacerlo para la segunda subordinada en adelante
                $this->contexto->salida->abrir_grupo_interno("",array('tipo'=>'TR'));
                $this->contexto->salida->abrir_grupo_interno("",array('tipo'=>'TD','colspan'=>7));
            }else{
                $this->contexto->salida->abrir_grupo_interno("",array('tipo'=>'TD'));
            }
        }
        $atributos_input=array(
            'tipo'=>in_array($tipo_de_input, array('texto_especificar', 'texto_libre', 'texto', 'observaciones'))?'textarea':'input',
            'type'=>in_array($que_teclado_mostrar[$tipo_de_input], array('entero', 'fecha', 'fecha_corta', 'edad'))?'tel':'text',
            'id'=>$this->id_dom,
            'onblur'=>'extender_elemento_al_contenido(this); ValidarOpcion("'.$this->id_dom.'");',
            'onkeypress'=>'PresionTeclaEnVariable("'.$this->id_dom.'",event);',
            'onkeydown'=>'PresionOtraTeclaEnVariable("'.$this->id_dom.'",event);',
            'disabled'=>$this->datos->var_editable_por==='nadie' || $this->datos->var_editable_por==='especial',
            /*
            'visibility'=>$this->datos->var_grilla!='g3', 
            'display'=>$this->datos->var_grilla!='g3' ,
            */
        );
        $this->contexto->salida->enviar('',$clase_de_input,$atributos_input);
        if($this->datos->var_editable_por==='especial' && ( $texto_boton=$this->datos->var_ope==='ut2016' || $texto_boton=$this->datos->var_ope==='eder2017' )) {
                $texto_boton=$this->datos->var_ope==='eder2017'? 'ir a grilla':($this->datos->var_ope==='ut2016'? 'ir al diario de actvidades': 'ir a horarios');
               // $texto_boton=$this->datos->var_ope=='ut2016'? 'ir al diario de actividades':'ir a horarios'; //original
               // Loguear('2017-08-10','tabla_variablesboton '.$this->datos->var_ope.' texto_boton '. $texto_boton);
               if($this->datos->var_ope==='eder2017'){
                    $boton_atributo=$this->datos->var_grilla;
                    $id_boton='boton_formulario_especial_'.$boton_atributo;
               }else{
                    $id_boton='boton_formulario_especial';   
                    $boton_atributo='ut';
               }
               $this->contexto->salida->enviar_boton( $texto_boton,'',array('id'=>$id_boton,  'grilla_boton'=>json_encode(array('grilla'=>$boton_atributo, 'var_especial'=>$this->datos->var_var)) ,'onclick'=>'alert("Error interno, no se puede cambiar de formulario")'));
        }
        if(@$this->despliegue->tabla_con_opc->datos->conopc_despliegue=='horizontal'){  
           if(in_array($tipo_de_input, array('texto_especificar', 'texto_libre', 'texto', 'observaciones'))){ //seria mejor hacerlo para la segunda subordinada en adelante
                $this->contexto->salida->cerrar_grupo_interno();
            }            
            $this->contexto->salida->cerrar_grupo_interno();
        }
    }
    function definir_orden_por_otra($otra){
        $campos_orden=array();
        if($otra=='blo'){
            $campos_orden[]='(select blo_orden from bloques, preguntas where blo_ope=pre_ope and blo_for=pre_for and blo_blo=pre_blo and pre_ope=var_ope and pre_pre=var_pre)';
        }
        if($otra=='pre' || count($campos_orden)){
            $campos_orden[]='(select pre_orden from preguntas where pre_ope=var_ope and pre_pre=var_pre)';
        }
        if($otra='sub'){
            $campos_orden[]='case when var_subordinada_var is null then var_orden else (select padre_orden from (select var_ope as padre_ope, var_var as padre_var, var_orden as padre_orden from variables) padre where padre_var=var_subordinada_var and padre_ope=var_ope) end';
            $campos_orden[]='case when var_subordinada_var is null then 0 else var_orden end';
        }
        $campos_orden[]='var_orden';
        $this->definir_campos_orden($campos_orden);
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE variables
  ADD CONSTRAINT "texto invalido en var_aclaracion de tabla variables" CHECK (comun.cadena_valida(var_aclaracion::text, 'cualquiera'::text));
/*OTRA*/    
ALTER TABLE variables
  ADD CONSTRAINT "texto invalido en var_conopc de tabla variables" CHECK (comun.cadena_valida(var_conopc::text, 'codigo'::text));
/*OTRA*/    
ALTER TABLE variables
  ADD CONSTRAINT "texto invalido en var_conopc_texto de tabla variables" CHECK (comun.cadena_valida(var_conopc_texto::text, 'codigo'::text));
/*OTRA*/    
ALTER TABLE variables
  ADD CONSTRAINT "texto invalido en var_desp_nombre de tabla variables" CHECK (comun.cadena_valida(var_desp_nombre::text, 'codigo'::text));
/*OTRA*/    
ALTER TABLE variables
  ADD CONSTRAINT "texto invalido en var_destino de tabla variables" CHECK (comun.cadena_valida(var_destino::text, 'codigo'::text));
/*OTRA*/    
ALTER TABLE variables
  ADD CONSTRAINT "texto invalido en var_destino_nsnc de tabla variables" CHECK (comun.cadena_valida(var_destino_nsnc, 'codigo'::text));
/*OTRA*/    
ALTER TABLE variables
  ADD CONSTRAINT "texto invalido en var_editable_por de tabla variables" CHECK (comun.cadena_valida(var_editable_por, 'codigo'::text));
/*OTRA*/    
ALTER TABLE variables
  ADD CONSTRAINT "texto invalido en var_expresion_habilitar de tabla variables" CHECK (comun.cadena_valida(var_expresion_habilitar::text, 'cualquiera'::text));
/*OTRA*/    
ALTER TABLE variables
  ADD CONSTRAINT "texto invalido en var_for de tabla variables" CHECK (comun.cadena_valida(var_for::text, 'codigo'::text));
/*OTRA*/    
ALTER TABLE variables
  ADD CONSTRAINT "texto invalido en var_mat de tabla variables" CHECK (comun.cadena_valida(var_mat::text, 'codigo'::text));
/*OTRA*/    
ALTER TABLE variables
  ADD CONSTRAINT "texto invalido en var_mejor_de_pregunta de tabla variables" CHECK (comun.cadena_valida(var_mejor_de_pregunta::text, 'codigo'::text));
/*OTRA*/    
ALTER TABLE variables
  ADD CONSTRAINT "texto invalido en var_ope de tabla variables" CHECK (comun.cadena_valida(var_ope::text, 'codigo'::text));
/*OTRA*/    
ALTER TABLE variables
  ADD CONSTRAINT "texto invalido en var_pre de tabla variables" CHECK (comun.cadena_valida(var_pre::text, 'codigo'::text));
/*OTRA*/    
ALTER TABLE variables
  ADD CONSTRAINT "texto invalido en var_subordinada_opcion de tabla variables" CHECK (comun.cadena_valida(var_subordinada_opcion::text, 'codigo'::text));
/*OTRA*/    
ALTER TABLE variables
  ADD CONSTRAINT "texto invalido en var_subordinada_var de tabla variables" CHECK (comun.cadena_valida(var_subordinada_var::text, 'codigo'::text));
/*OTRA*/    
ALTER TABLE variables
  ADD CONSTRAINT "texto invalido en var_texto de tabla variables" CHECK (comun.cadena_valida(var_texto::text, 'cualquiera'::text));
/*OTRA*/    
ALTER TABLE variables
  ADD CONSTRAINT "texto invalido en var_tipovar de tabla variables" CHECK (comun.cadena_valida(var_tipovar::text, 'codigo'::text));
/*OTRA*/    
ALTER TABLE variables
  ADD CONSTRAINT "texto invalido en var_var de tabla variables" CHECK (comun.cadena_valida(var_var::text, 'codigo'::text));
/*OTRA*/  
ALTER TABLE variables
  ADD CONSTRAINT "el nombre de la variable debe estar en minúscula" CHECK (var_var=lower(var_var));  
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }    
}

?>