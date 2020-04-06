<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tabla_operativos.php";
require_once "pdo_con_excepciones.php";
require_once "nuestro_mini_yaml_parse.php";

class Estructura_js extends Objeto_de_la_base{ 
    private $estructura;
    function __construct(){
        parent::__construct();
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->estructura = array();
    }
    function generar_estructura(){
        $estructura_final = $this->recorrer_metadatos($GLOBALS['NOMBRE_APP']);
        //$estructura_final['copias']=array();
        $estructura_final = json_sangrar(json_encode($estructura_final));        
        $f=fopen("estructura_{$GLOBALS['nombre_app']}.js",'w');
        fwrite($f,$this->generar_tabla('variables'));
        fwrite($f,$this->generar_tabla('semanas'));
        fwrite($f,$this->generar_tabla('preguntas'));
        if($GLOBALS['NOMBRE_APP']=='ut2016'){
            fwrite($f,$this->generar_tabla('actividades_codigos'));
        }
        fwrite($f,"var estructura=\n");
        fwrite($f,$estructura_final);
        fwrite($f,"\n;");
        fwrite($f,"//fin\n");
        fclose($f);
    }
    function generar_tabla($nombre_tabla){
        $filas=array(); // pongo una primer fila vacía para luego sacarla y que quede numerado desde 1 el array
        $tabla=$this->contexto->nuevo_objeto("Tabla_{$nombre_tabla}");
        $tabla->leer_varios(array());
        $unico_campo_pk=$tabla->obtener_nombres_campos_pk();
        if(termina_con($unico_campo_pk[0],'_ope')){
            array_shift($unico_campo_pk);
        }
        if(count($unico_campo_pk)!=1){
            throw new Exception("La tabla $nombre_tabla debe tener un solo campo pk para usar generar_tabla");
        }
        $unico_campo_pk=$unico_campo_pk[0];
        while($tabla->obtener_leido()){
            $filas[$tabla->datos->{$unico_campo_pk}]=$tabla->datos;
        }
        return "var {$nombre_tabla}=".json_sangrar(json_encode($filas)).";\n\n";
    }
    function recorrer_metadatos($operativo){
        global $db;
        $this->estructura = array();
        $this->estructura['formulario']=array();
        $tabla_formularios=new Tabla_formularios();
        $tabla_formularios->contexto=$this->contexto;
        $tabla_formularios->leer_varios(array(
            'for_ope'=>$operativo
        ));
        while($tabla_formularios->obtener_leido()){
            $estr_for=&$this->estructura['otros_datos_formulario'][$tabla_formularios->datos->for_for];
            $estr_for['es_principal']=$tabla_formularios->datos->for_es_principal;
            $estr_for['tarea']=$tabla_formularios->datos->for_tarea;
            $estr_for['es_especial']=$tabla_formularios->datos->for_es_especial;
        }
        $tabla_matrices=new Tabla_matrices();
        $tabla_matrices->contexto=$this->contexto;
        $tabla_matrices->leer_varios(array('mat_ope'=>$operativo));
        while($tabla_matrices->obtener_leido()){
            $this->estructura['formulario'][$tabla_matrices->datos->mat_for][$tabla_matrices->datos->mat_mat]=array();
            $this->estructura['copias'][$tabla_matrices->datos->mat_for][$tabla_matrices->datos->mat_mat]=array();
            $estr_mat=&$this->estructura['otros_datos_formulario'][$tabla_matrices->datos->mat_for]['matrices'];
            $estr_mat[$tabla_matrices->datos->mat_mat]=array();
            $estr_mat[$tabla_matrices->datos->mat_mat]['ultimo_campo_pk']=$tabla_matrices->datos->mat_ultimo_campo_pk;
            $this->despliegue_variables($this->estructura['formulario'][$tabla_matrices->datos->mat_for][$tabla_matrices->datos->mat_mat],$tabla_matrices);
        }
        return $this->estructura;
    }
                                                
    function agregar_consistencias_a_estructura($tabla_consistencias,$este,$separador_lista_var,$tabla_variables){
        $parte_estructura=array(
            'expr'=>($este->evalua_expresion_para_agregar_copia(
                ($tabla_consistencias->datos->con_precondicion
                    ?('('.$tabla_consistencias->datos->con_precondicion.')'.
                        ($tabla_consistencias->datos->con_rel=='=>'?' && ':' = ')
                    )
                    :''
                ).
                ('!('.$tabla_consistencias->datos->con_postcondicion.')')
            , $tabla_variables
            , "consistencia")),
            'expl'=>$tabla_consistencias->datos->con_explicacion?:$tabla_consistencias->datos->con_descripcion,
            'gravedad'=>$tabla_consistencias->datos->con_falsos_positivos?'Advertencia':'Error',
            'momento'=>$tabla_consistencias->datos->con_momento,
            'con_variables'=>explode($separador_lista_var,$tabla_consistencias->datos->con_variables),
        );
        return $parte_estructura;
    }
    function despliegue_variables(&$parte_estructura,$tabla_matrices){
        global $db;
        global $tipo_de_la_base;
        $tabla_variables=$tabla_matrices->definicion_tabla('variables');
        $tabla_variables_alterable=$tabla_matrices->definicion_tabla('variables');
        // $tabla_variables->definir_orden_por_otra('pre');
        $tabla_filtros=$tabla_matrices->definicion_tabla('filtros');
        $tabla_bloques=$tabla_matrices->definicion_tabla('bloques');
        $tabla_preguntas=$tabla_matrices->definicion_tabla('preguntas');
        // $tabla_filtros->definir_orden_por_otra('blo');
        $la_anterior_es_multiple = false;
        $var_anterior = null;
        $tabla_bloques->leer_varios($tabla_matrices);
        while($tabla_bloques->obtener_leido()){
            $tabla_filtros->leer_varios($tabla_bloques);
            $tabla_filtros->obtener_leido();
            $tabla_preguntas->leer_varios($tabla_bloques);
            while($tabla_preguntas->obtener_leido()){
                $tabla_variables->leer_varios($tabla_preguntas);
                while($tabla_variables->obtener_leido()){
                    $var_var='var_'.$tabla_variables->datos->var_var;
                    while ($tabla_filtros->datos and $tabla_preguntas->datos->pre_orden>$tabla_filtros->datos->fil_orden){
                          $parte_estructura['var_'.$tabla_filtros->datos->fil_fil]=array(
                              "expresion_filtro"=>$this->evalua_expresion_para_agregar_copia($tabla_filtros->datos->fil_expresion, $tabla_variables,"expresion filtro"),
                              "no_es_variable"=>true,
                              "salta"=>$this->buscar_la_variable_del_destino($tabla_filtros->datos->fil_ope,$tabla_filtros->datos->fil_for,$tabla_filtros->datos->fil_destino,"bvd(6){$tabla_filtros->datos->fil_fil} / filsalta"),
                              "siguiente"=>$var_var
                          );
                          $tabla_filtros->obtener_leido();
                    }
                    $parte_estructura[$var_var]=array();
                    if($tabla_variables->datos->var_subordinada_var){
                        if($tabla_variables->datos->var_subordinada_opcion){
                          $parte_estructura[$var_var]['expresion_habilitar']=$tabla_variables->datos->var_subordinada_var.'='.$tabla_variables->datos->var_subordinada_opcion;
                        } else {
                          $parte_estructura[$var_var]['expresion_habilitar']='!!'.$tabla_variables->datos->var_subordinada_var;
                        }
                    }
                    if(!isset($tipo_de_la_base[$tabla_variables->datos->var_tipovar])){
                        throw new Exception_Tedede("No se encuentra el tipo del tipo ".$tabla_variables->datos->var_tipovar);
                    }
                    $tipo=$tipo_de_la_base[$tabla_variables->datos->var_tipovar];
                    if ($tipo=='entero'){
                        $parte_estructura[$var_var]['es_numerico']=true;
                        $parte_estructura[$var_var]['minimo']=0;
                    }
                    $this->despliegue_saltos_variable_o_pregunta($parte_estructura[$var_var], $tabla_variables);
                    if($tabla_variables->datos->var_conopc){
                        $parte_estructura[$var_var]['opciones']=array();
                        $this->despliegue_opciones($parte_estructura[$var_var]['opciones'],$tabla_variables);
                    }
                    if($var_anterior){
                        $parte_estructura[$var_anterior]['siguiente']=$var_var;
                    }
                    if($la_anterior_es_multiple){
                        $parte_estructura[$var_var]['la_anterior_es_multiple']=true;
                    }
                    if($tabla_variables->datos->var_expresion_habilitar){
                        $parte_estructura[$var_var]['expresion_habilitar']=$this->evalua_expresion_para_agregar_copia($tabla_variables->datos->var_expresion_habilitar, $tabla_variables, "expresion habilitar");
                    }
                    if($tabla_variables->datos->var_optativa){
                        $parte_estructura[$var_var]['optativa']=true;
                    }                    
                    if($tabla_variables->datos->var_conopc){
                        $parte_estructura[$var_var]['es_numerico']=true;
                    }
                    if($tabla_variables->datos->var_maximo!==null){
                        $parte_estructura[$var_var]['maximo']=$tabla_variables->datos->var_maximo;
                    }
                    if($tabla_variables->datos->var_minimo!==null){
                        $parte_estructura[$var_var]['minimo']=$tabla_variables->datos->var_minimo;
                    }
                    if($tabla_variables->datos->var_advertencia_sup!==null){
                        $parte_estructura[$var_var]['advertencia_sup']=$tabla_variables->datos->var_advertencia_sup;
                    }
                    if($tabla_variables->datos->var_advertencia_inf!==null){
                        $parte_estructura[$var_var]['advertencia_inf']=$tabla_variables->datos->var_advertencia_inf;
                    }
                    if($tabla_variables->datos->var_ocu_sal!==null){
                        $parte_estructura[$var_var]['ocu_sal']=$tabla_variables->datos->var_ocu_sal;
                    }
                    if($tabla_variables->datos->var_tipovar == 'multiple_marcar'){
                        $mascara_de_la_opcion = substr(strrchr($tabla_variables->datos->var_var, '_'), 1);
                        $parte_estructura[$var_var]['marcar']=$mascara_de_la_opcion; 
                        //$parte_estructura[$var_var]['almacenar']=$mascara_de_la_opcion>90?$mascara_de_la_opcion:1; 
                        //$parte_estructura[$var_var]['almacenar']=$mascara_de_la_opcion>90?intval($mascara_de_la_opcion,10):1; 
                        $parte_estructura[$var_var]['almacenar']=1; 
                        $parte_estructura[$var_var]['opciones']=array();
                        $parte_estructura[$var_var]['opciones'][$mascara_de_la_opcion]=array();
                        $parte_estructura[$var_var]['opciones'][$mascara_de_la_opcion]['texto']='';
                        $parte_estructura[$var_var]['esta_es_multiple']=true;
                        $la_anterior_es_multiple=true;                         
                    }else{
                        if(!$tabla_variables->datos->var_subordinada_var){
                            $la_anterior_es_multiple=false; 
                        }
                    }
                    $var_anterior = $var_var;
                    $tabla_consistencias=$tabla_variables->definicion_tabla('consistencias');
                    $separador_lista_var='/*OTRA_VAR*/,';
                    $tabla_consistencias->campos_lookup=array(
                        "(select string_agg(case when convar_for<>'{$tabla_variables->datos->var_for}' or convar_mat<>'{$tabla_variables->datos->var_mat}' then 'copia_' else '' end || convar_var,'$separador_lista_var' order by convar_orden) from con_var where convar_ope=con_ope and convar_con=con_con) as con_variables"=>true,
                    );
                    /*
                    $tabla_consistencias->tablas_lookup=array(
                        'consistencias'=>'con_con=inc_con and con_ope=inc_ope',
                    );
                    */
                    $tabla_consistencias->leer_varios(array(
                        'con_ope'=>$tabla_variables->datos->var_ope,
                        'con_ultima_variable'=>$tabla_variables->datos->var_var,
                        'con_activa'=>true,
                        'con_valida'=>true,
                        //'con_tipo'=>'Conceptual',
                        'con_momento'=>'Relevamiento 1',
                    ));
                    while($tabla_consistencias->obtener_leido()){
                        $parte_estructura[$var_var]['consistir'][$tabla_consistencias->datos->con_con]=$this->agregar_consistencias_a_estructura($tabla_consistencias,$this,$separador_lista_var,$tabla_variables);
                    }
                    $tabla_consistencias->leer_varios(array(
                        'con_ope'=>$tabla_variables->datos->var_ope,
                        'con_ultima_variable'=>$tabla_variables->datos->var_var,
                        'con_activa'=>true,
                        'con_valida'=>true,
                        //'con_tipo'=>'Conceptual',
                        'con_momento'=>'Relevamiento 2',
                    ));
                    while($tabla_consistencias->obtener_leido()){
                        $parte_estructura[$var_var]['consistir'][$tabla_consistencias->datos->con_con]=$this->agregar_consistencias_a_estructura($tabla_consistencias,$this,$separador_lista_var,$tabla_variables);
                    }                    
                }
            }
        }
    }
    
    function evalua_expresion_para_agregar_copia($expresion_habilitar, $tabla_con_parametros, $lugar_donde_busco){
        $tabla_variables = new Tabla_variables;
        $tabla_variables->contexto=$this->contexto;        
        $operadores_logicos_regexp="or|and|is|end|in|not";
        preg_match_all("#([A-Za-z][A-Za-z_.0-9]*)*($|[-+)<=>,*/!|]| ($operadores_logicos_regexp))#",$expresion_habilitar, $variables_en_expresion_habilitar);
        foreach($variables_en_expresion_habilitar[1] as $variable_individual){
            if($variable_individual){
                $variable_individual = strtolower($variable_individual);
                $variable_procesada = preg_replace("#(copia_)#i","",$variable_individual);
                $tabla_variables->leer_uno_si_hay(array(
                    'var_ope'=>$tabla_con_parametros->datos->var_ope,
                    'var_var'=>strtolower($variable_procesada)
                ));
                $variable_existente = false;
                if($tabla_variables->obtener_leido()){
                    $variable_existente = true;
                    if($tabla_con_parametros->datos->var_for != $tabla_variables->datos->var_for || $tabla_con_parametros->datos->var_mat != $tabla_variables->datos->var_mat){
                        $this->agregar_copia(strtolower($variable_procesada), $tabla_con_parametros, $tabla_variables);
                        if(!preg_match("#(copia_)#i",$variable_individual)){
                            $expresion_habilitar = expresion_regular_reemplazar_variable($expresion_habilitar, $variable_individual, 'copia_'.$variable_individual);
                        }                        
                    }
                }
                //OJO: segundo condicional del if deberia ser temporal
                $variables_a_filtrar = variables_especiales_consistencias('excluir convar',$this->contexto);
                if(!$variable_existente && !in_array(strtolower($variable_procesada), $variables_a_filtrar)){
                    $this->contexto->salida->enviar("No se encuentra la variable $variable_procesada de $lugar_donde_busco de ".$tabla_con_parametros->datos->var_var.". Expresion: ".$expresion_habilitar);
                }else if(!$variable_existente and strtolower($variable_procesada)!='encues' && strtolower($variable_procesada)!='nhogar' && strtolower($variable_procesada)!='nmiembro'){
                    $pref_copia = 'copia_';
                    $estructura_copia_esta=array();
                    $nombre_copia='copia_'.strtolower($variable_procesada);
                    $estructura_copia_esta['destino']=$nombre_copia;
                    $estructura_copia_esta['origen']=$nombre_copia;
                    $estructura_copia_esta['cambiador_id']=array('tra_for'=>'TEM', 'tra_mat'=>'', 'tra_hog'=>0, 'tra_mie'=>0, 'tra_exm'=>0);
                    $estructura_copia_esta['tipovar']='entero';
                    $this->estructura['copias'][$tabla_con_parametros->datos->var_for][$tabla_con_parametros->datos->var_mat][$nombre_copia]=$estructura_copia_esta;
                    if(!preg_match("#(copia_)#i",$variable_individual)){
                        $expresion_habilitar = expresion_regular_reemplazar_variable($expresion_habilitar, $variable_individual, 'copia_'.$variable_individual);
                    }                        
                }
            }
        }
        return $expresion_habilitar;
    }
    function agregar_copia($variable_para_copia, $tabla_con_parametros, $tabla_variables){
        $pref_copia = 'copia_';
        //OJO: GENERALIZAR
        if($tabla_variables->datos->var_for == 'TEM'){
            $pref_var = 'copia_';
        }else{
            $pref_var = 'var_';
        }
        if($tabla_con_parametros->datos->var_for=='A1' && $variable_para_copia=='i1'){
            Loguear('2012-09-14','ACA ENCONTRE EL PROBLEMA DEL X');
        }
        $tabla_matrices=$this->contexto->nuevo_objeto('Tabla_matrices');
        $tabla_matrices->leer_unico($tabla_variables);
        $estructura_copia_esta=array();
        $estructura_copia_esta['destino']=$pref_copia.$tabla_variables->datos->var_var;
        $estructura_copia_esta['origen']=$pref_var.$tabla_variables->datos->var_var;
        $estructura_copia_esta['cambiador_id']=array();
        $estructura_copia_esta['cambiador_id']['tra_for']=$tabla_variables->datos->var_for;
        $estructura_copia_esta['cambiador_id']['tra_mat']=$tabla_variables->datos->var_mat;
        $estructura_copia_esta['tipovar']=$tabla_variables->datos->var_tipovar;
        foreach(explode(',',$tabla_matrices->datos->mat_blanquear_clave_al_retroceder) as $blanqueador){
            if($blanqueador){
                $campo=substr($blanqueador,0,strlen($blanqueador)-strlen(":0"));
                $estructura_copia_esta['cambiador_id'][$campo]=0; 
            }
        }
        $this->estructura['copias'][$tabla_con_parametros->datos->var_for][$tabla_con_parametros->datos->var_mat][$pref_copia."$variable_para_copia"]=$estructura_copia_esta;
    }
    function buscar_la_variable_del_destino($tra_ope,$tra_for,$destino,$contexto_para_error){
        if($destino=='fin'){
            return 'fin';
        }
        if(!$destino){
            throw new Exception_Tedede("La funcion buscar_la_variable_del_destino() debe contener destino [$contexto_para_error]");
        }
        $tabla_variables = new Tabla_variables;
        $tabla_variables->contexto=$this->contexto;
        $tabla_variables->leer_uno_si_hay(array(
            'var_ope'=>$tra_ope,
            'var_for'=>$tra_for,
            'var_var'=>$destino
        ));
        if($tabla_variables->obtener_leido()){
            return 'var_'.$tabla_variables->datos->var_var;
        }else{ // no hay una variable
            $tabla_preguntas = new Tabla_preguntas;
            $tabla_preguntas->contexto=$this->contexto;
            $tabla_preguntas->leer_uno_si_hay(array(
                'pre_ope'=>$tra_ope,
                'pre_for'=>$tra_for,
                'pre_pre'=>$destino
            ));
            if($tabla_preguntas->obtener_leido()){
                $tabla_variables->leer_varios($tabla_preguntas);
                if($tabla_variables->obtener_leido()){ // hay pregunta y variable
                    return 'var_'.$tabla_variables->datos->var_var;
                }
            }else{ // no hay variable ni pregunta
                $tabla_bloques = new Tabla_bloques;
                $tabla_bloques->contexto=$this->contexto;
                $tabla_bloques->leer_uno_si_hay(array(
                    'blo_ope'=>$tra_ope,
                    'blo_for'=>$tra_for,
                    'blo_blo'=>$destino
                ));
                if($tabla_bloques->obtener_leido()){
                    $tabla_preguntas->leer_varios($tabla_bloques);
                    if($tabla_preguntas->obtener_leido()){ // hay bloque, pregunta y variable
                        $tabla_variables->leer_varios($tabla_preguntas);
                        if($tabla_variables->obtener_leido()){ // hay bloque, pregunta y variable
                            return 'var_'.$tabla_variables->datos->var_var;
                        }
                    }
                }else{
                    $tabla_filtros = new Tabla_filtros;
                    $tabla_filtros->contexto = $this->contexto;
                    $tabla_filtros->leer_uno_si_hay(array(
                        'fil_ope'=>$tra_ope,
                        'fil_for'=>$tra_for,
                        'fil_fil'=>$destino
                    ));
                    if($tabla_filtros->obtener_leido()){
                        return 'var_'.$tabla_filtros->datos->fil_fil;
                    }
                }
            }
        }
        throw new  Exception_Tedede("problema con los metadatos, no se encuentra el destino $destino [$contexto_para_error]");
    }
    function despliegue_saltos_variable_o_pregunta(&$parte_estructura, $tabla_variables){
        global $db;
        if(!$tabla_variables->datos->var_conopc){
            if($tabla_variables->datos->var_destino == 'fin'){
                $parte_estructura['salta']='fin';
            }else{
                if($tabla_variables->datos->var_destino){
                    $parte_estructura['salta']=($this->buscar_la_variable_del_destino($tabla_variables->datos->var_ope,$tabla_variables->datos->var_for,$tabla_variables->datos->var_destino,"bvd(5){$tabla_variables->datos->var_var} / salta"));
                }
            }
        }else{
            if($tabla_variables->datos->var_destino){
                $parte_estructura['salta_nsnc']=($this->buscar_la_variable_del_destino($tabla_variables->datos->var_ope,$tabla_variables->datos->var_for,$tabla_variables->datos->var_destino,"bvd(4){$tabla_variables->datos->var_var} / destino"));
            }
        }
        if($tabla_variables->datos->var_destino_nsnc){
            $parte_estructura['salta_nsnc']=($this->buscar_la_variable_del_destino($tabla_variables->datos->var_ope,$tabla_variables->datos->var_for,$tabla_variables->datos->var_destino_nsnc,"bvd(7){$tabla_variables->datos->var_var} / nsnc"));
        }
    }
    function despliegue_saltos_opciones(&$parte_estructura,Tabla_opciones $tabla_opciones,Tabla_variables $tabla_variables){
        global $db;
        $tabla_saltos=$tabla_variables->definicion_tabla('saltos');
        $tabla_saltos->leer_uno_si_hay($mostrar=new Filtro_Que_se_completa_y_pisa(array($tabla_variables,$tabla_opciones),$tabla_saltos));
        $destino=false;
        if($tabla_saltos->obtener_leido()){
            $destino=$tabla_saltos->datos->sal_destino;
        }else if($tabla_variables->datos->var_destino){
            $destino=$tabla_variables->datos->var_destino;
        }else{
            $tabla_preguntas=$tabla_variables->traer_tabla_con_datos('preguntas');
            if($tabla_preguntas->datos->pre_destino){
                $destino=$tabla_preguntas->datos->pre_destino;
            }
        }
        if($destino){
            $tabla_busco_subordinada=$tabla_saltos->definicion_tabla('variables');
            $tabla_busco_subordinada->leer_varios(array(
                'var_ope'=>$tabla_variables->datos->var_ope,
                'var_subordinada_var'=>$tabla_variables->datos->var_var,
                'var_subordinada_opcion'=>$tabla_variables->datos->var_var,
            ));
            $tiene_subordinadas=false;
            while($tabla_busco_subordinada->obtener_leido()){
                $this->estructura['formulario']
                    [$tabla_variables->datos->var_for]
                    [$tabla_variables->datos->var_mat]
                    [$tabla_busco_subordinada->datos->var_var]['salta']=$this->buscar_la_variable_del_destino($tabla_variables->datos->var_ope,$tabla_variables->datos->var_for,$this->buscar_la_variable_del_destino($destino,"bvd(2){$tabla_variables->datos->var_var} / {$tabla_opciones->datos->opc_opc}"),"bvd(3){$tabla_variables->var_var} / {$tabla_opciones->opc_opc}");
                $tiene_subordinadas=true;
            }
            if(!$tiene_subordinadas){
                $parte_estructura['salta']=($this->buscar_la_variable_del_destino($tabla_variables->datos->var_ope,$tabla_variables->datos->var_for,$destino,"bvd(1){$tabla_variables->datos->var_var} / {$tabla_opciones->datos->opc_opc} (tabla saltos)"));
            }
        }
    }
    function despliegue_opciones(&$parte_estructura,$tabla_variables){
        global $db;
        $tabla_con_opc=$tabla_variables->traer_tabla_con_datos('con_opc');
        $tabla_opciones=$tabla_con_opc->definicion_tabla('opciones');
        $tabla_opciones->leer_varios($tabla_con_opc);
        while($tabla_opciones->obtener_leido()){
            $parte_estructura[$tabla_opciones->datos->opc_opc]=array();
            $parte_estructura[$tabla_opciones->datos->opc_opc]['texto']=$tabla_opciones->datos->opc_texto;
            if($tabla_opciones->datos->opc_proxima_vacia){
                  $parte_estructura[$tabla_opciones->datos->opc_opc]['proxima_vacia']=true;
            }            
            if($tabla_opciones->datos->opc_proxima_opc!==null){
                  $parte_estructura[$tabla_opciones->datos->opc_opc]['proxima_opc']=$tabla_opciones->datos->opc_proxima_opc;
            }
            if($tabla_opciones->datos->opc_proxima_texto!==null){
                  $parte_estructura[$tabla_opciones->datos->opc_opc]['proxima_texto']=$tabla_opciones->datos->opc_proxima_texto;
            }
            $this->despliegue_saltos_opciones($parte_estructura[$tabla_opciones->datos->opc_opc],$tabla_opciones,$tabla_variables);
        }
    }
}

?>