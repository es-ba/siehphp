<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_compilar_consistencia extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Compilar consistencia',
            'submenu'=>'consistencias',
            'html_title'=>"{tra_con} compilar consistencia - {$GLOBALS['NOMBRE_APP']}",
            'parametros'=>array(
                'tra_ope'=>array('label'=>'operativo','def'=>$GLOBALS['NOMBRE_APP'],'invisible'=>true),
                'tra_con'=>array('label'=>'consistencia','def'=>'#todo'),
                'tra_mas_info'=>array('label'=>false,'aclaracion'=>'correr la consistencia y mostrar su tabulado','type'=>'checkbox'),
            ),
            'para_produccion'=>true,
            'permisos'=>array('grupo'=>'procesamiento', 'grupo1'=>'ana_sectorial'),
            'bitacora'=>true,
            'boton'=>array('id'=>'compilar'),
        ));
        // http://localhost/yeah/eah2012/eah2012.php?proceso=compilar_consistencia&todo={%22tra_con%22:%22E06%22,%22tra_ope%22:%22eah2012%22:%22tra_mas_info%22:1}
        // http://localhost/yeah/eah2012/eah2012.php?proceso=compilar_consistencia&todo={%22tra_con%22:%22E06%22,%22tra_ope%22:%22eah2012%22:%22tra_mas_info%22:1}
    }
    function responder_campos_voy_por(){
        return array('con_con');
    }
    function responder_iniciar_estado(){
        $this->estado->errores="";
        $this->estado->cantidad_consistencias=0;        
        $this->estado->cantidad_compiladas = 0;
        $this->estado->cantidad_sin_compilar = 0;   
        if($this->argumentos->tra_con==="0"){
            $this->estado->errores="Debe refrescar la grilla antes de mandar a compilar";
        }
    }
    function responder_iniciar_iteraciones(){
        global $operadores_logicos_regexp;
        $este = $this;
        $mostrar_salida=true;
        $este->tabla_consistencias=$este->nuevo_objeto('Tabla_consistencias');
        $this->esquema=$this->tabla_consistencias->obtener_nombre_de_esquema();
        $para_filtro_para_consistencias=array(
            'con_ope'=>$GLOBALS['NOMBRE_APP'],
            'con_con'=>$this->argumentos->tra_con?:'#todo',
        );
        if(!@$this->argumentos->tra_mas_info){
            $para_filtro_para_consistencias['con_activa']=true;
        }
        $this->filtro_con=$this->nuevo_objeto("Filtro_Normal",$para_filtro_para_consistencias,$this->tabla_consistencias);
        if(isset($this->voy_por)){
            $this->filtro_con=new Filtro_AND(array($this->filtro_con,new Filtro_Voy_Por($this->voy_por)),$this->tabla_consistencias);
        }
        $this->tabla_consistencias->leer_varios($this->filtro_con);
        $este->con_var = $este->nuevo_objeto('Tabla_con_var');
    }
    function responder_hay_mas(){
        if($this->estado->errores){
            return false;
        }
        if($this->tabla_consistencias->obtener_leido()){
            Loguear('2012-12-04','********************* obtener leído: '.$this->tabla_consistencias->datos->con_con);
            $this->voy_por=(object)array('con_con'=>$this->tabla_consistencias->datos->con_con);
            return true;
        }
        return false;
    }
    function responder_un_paso(){
        global $operadores_logicos_regexp;
        global $pg_identifica_var_regexp;        
        $este=$this;
        $tiempo_inicio = microtime(true);
        //actualizar con_var
        $para_filtro_para_convar_delete=array('convar_ope'=>$GLOBALS['NOMBRE_APP']);
        $para_filtro_para_convar_insert=array('con_ope'=>$GLOBALS['NOMBRE_APP']);
        $para_filtro_para_convar_delete['convar_con']=trim($este->tabla_consistencias->datos->con_con);
        $para_filtro_para_convar_insert['con_con']=trim($este->tabla_consistencias->datos->con_con);            
        $filtro_para_convar_delete=new Filtro_Normal($para_filtro_para_convar_delete);
        $filtro_para_convar_insert=new Filtro_Normal($para_filtro_para_convar_insert);
        $this->actualizar_convar($filtro_para_convar_delete, $filtro_para_convar_insert,$este->tabla_consistencias->datos->con_momento);
        //terminar actualizar con_var        
        $this->estado->cantidad_consistencias++;
        $para_filtro_cada_consistencia=array(
            'convar_ope'=>$GLOBALS['NOMBRE_APP'], 
            'convar_con'=>$este->tabla_consistencias->datos->con_con
        );
        $filtro_cada_consistencia=new Filtro_Normal($para_filtro_cada_consistencia);
        $ultima_variable=$this->db->preguntar(new Sql(<<<SQL
            SELECT convar_var 
                FROM con_var INNER JOIN variables on convar_ope=var_ope AND convar_var=var_var
                    INNER JOIN preguntas on pre_ope=var_ope AND pre_pre=var_pre
                    INNER JOIN bloques on blo_ope=pre_ope AND blo_for=pre_for AND blo_blo=pre_blo
                    INNER JOIN formularios on for_ope=blo_ope AND for_for=blo_for
                WHERE {$filtro_cada_consistencia->where} 
                ORDER BY for_orden DESC, blo_orden DESC, pre_orden DESC, var_orden DESC
                LIMIT 1
SQL
            ,$filtro_cada_consistencia->parametros
        ));
        $UNIR_CON_CAMPOS_PK="";
        
        // OJO GENERALIZAR:
        // Intento de generalización (por Mauro y Elba, consideramos que el formulario de hogar SIEMPRE es el formulario principal
        $este->tabla_formularios=$este->nuevo_objeto('Tabla_formularios');
        $este->tabla_formularios->leer_unico(array(
                    'for_ope'=>$GLOBALS['NOMBRE_APP'],
                    'for_es_principal'=>true
                ));
        $formulario_principal=$este->tabla_formularios->datos->for_for;        
        if(strpos($este->tabla_consistencias->datos->con_precondicion.' '. 
                 $este->tabla_consistencias->datos->con_postcondicion,'nhogar')>=0){
            $UNIR_CON_CAMPOS_I1_PK='';         
            if (substr($GLOBALS['NOMBRE_APP'],0,2)=='ut' && $este->tabla_formularios->datos->for_es_especial){         
                $UNIR_CON_CAMPOS_I1_PK=<<<SQL
                union select 'I1','','["enc","hog","mie"]'
SQL;
            }
            $UNIR_CON_CAMPOS_PK.=<<<SQL
            union select '$formulario_principal','','["enc","hog"]' 
SQL;
        }
        // FIN GENERALIZAR        
        $para_filtro_para_variables=array('convar_ope'=>$GLOBALS['NOMBRE_APP']);
        $filtro_para_variables=new Filtro_Normal($para_filtro_para_variables);
        $select_lista_parcial=" var_for, var_mat";
        $from_parcial="";
        $where_parcial="";
        if($este->tabla_consistencias->datos->con_momento=='Procesamiento 2'){
            $select_lista_parcial=" COALESCE(var_for,varcaldes_for) as var_for, coalesce(var_mat,varcaldes_mat) var_mat ";
            $from_parcial="left join varcal ON varcal_ope= convar_ope AND varcal_varcal=convar_var \r\n". 
                "     left join varcal_destinos ON varcal_destino=varcaldes_destino and varcal_ope=varcaldes_ope \r\n".
                "     left join (select distinct regexp_matches(lower('{$este->tabla_consistencias->datos->con_variables_contexto}'), '$pg_identifica_var_regexp', 'g') as vars) z on z.vars[1] = varcal_varcal \r\n";
            $where_parcial=" or varcal_varcal = z.vars[1] ";
        }
        $select_datos_from=<<<SQL
        select var_for,var_mat, ua_pk from(
          select {$select_lista_parcial}, ua_pk 
            from con_var
              inner join matrices on convar_ope=mat_ope and convar_for=mat_for and convar_mat=mat_mat
              left join variables on var_ope=convar_ope and var_for=convar_for and var_mat=convar_mat and var_var=convar_var
              inner join ua on ua_ope=convar_ope and ua_ua=mat_ultimo_campo_pk 
              left join (select distinct regexp_matches(lower('{$este->tabla_consistencias->datos->con_variables_contexto}'), '$pg_identifica_var_regexp', 'g') as vars) y on y.vars[1] = var_var
              {$from_parcial}
            where {$filtro_cada_consistencia->where} or {$filtro_para_variables->where} and var_var = y.vars[1] 
                {$where_parcial}
          {$UNIR_CON_CAMPOS_PK}) x
        group by var_for, var_mat, ua_pk
        order by length(ua_pk);
SQL;
        $from="{$this->esquema}.plana_tem_ tem";
        $tabla_para_unir="{$this->esquema}.plana_tem_";
      $this->campos_para_unir=array();
        $para_filtro_ua=array('ua_ope'=>$GLOBALS['NOMBRE_APP']);
        $filtro_ua=new Filtro_Normal($para_filtro_ua);
        $this->tabla_ua=$this->nuevo_objeto('Tabla_ua');
        $this->tabla_ua->leer_varios($filtro_ua);
        while($this->tabla_ua->obtener_leido()){
            $this->campos_para_unir[$this->tabla_ua->datos->ua_ua]=null;
        }            
        $this->campos_para_unir['enc']="tem.pla_enc";
        $pref = 'pla_';
        $cursor=$this->db->ejecutar_sql(new Sql($select_datos_from, (object)array_merge($filtro_cada_consistencia->parametros, $filtro_para_variables->parametros)));
        //$cursor=$this->db->ejecutar_sql(new Sql($select_datos_from, $filtro_cada_consistencia->parametros));
        Loguear('2016-08-24','POR INICIAR EL CALCULO DE JUNTA '.$select_datos_from);
        Loguear('2013-08-30','PARAMETROS: '.json_encode((object)array_merge($filtro_cada_consistencia->parametros, $filtro_para_variables->parametros)));
        while($fila=$cursor->fetchObject()){
            Loguear('2013-08-30','ESTOY CONSTRUYENDO LA JUNTA '.$fila->var_for.'/'.$fila->var_mat);
            if($fila->var_for != 'TEM'){
                $alias_nuevo = "{$fila->var_for}_{$fila->var_mat}";
                $tabla_nueva = "{$this->esquema}.plana_{$fila->var_for}_{$fila->var_mat} {$alias_nuevo}";
                $tabla_nueva=$fila->var_for=='UT'? str_replace('plana_UT_','diario_actividades_vw',$tabla_nueva): $tabla_nueva;
                $from.=" INNER JOIN {$tabla_nueva} ON ";
                $variables = json_decode($fila->ua_pk);
                $and="";
                foreach($variables as $variable){
                    if (isset($this->campos_para_unir[$variable])){
                        $from.= $and.$this->campos_para_unir[$variable]." = {$alias_nuevo}.{$pref}{$variable}";
                        $and=" and ";
                    }
                    $this->campos_para_unir[$variable]=$alias_nuevo.".pla_".$variable;
                }
            }
        }
        /*
        if(substr($GLOBALS['NOMBRE_APP'],0,2)=='ut' && $this->tabla_consistencias->datos->con_modulo=='DIARIO'){
            $from.=" LEFT JOIN encu.diario_actividades_vw da ON da.pla_enc=i1_.pla_enc and da.pla_hog=i1_.pla_hog and da.pla_mie=i1_.pla_mie";
        }
        */
        $lista_var_contexto='';
        foreach(explode(' ',$this->tabla_consistencias->datos->con_variables_contexto) as $variable){
            if($variable){
                $lista_var_contexto.="pla_{$variable},";
            }
        } 
        $condicion_var_contexto='';
        if ($lista_var_contexto!=''){        
            $lista_var_contexto= '('. substr($lista_var_contexto,0,strlen($lista_var_contexto)-1) .')'; 
            $condicion_var_contexto= ' and '.$lista_var_contexto. ' is not distinct from '.$lista_var_contexto;
        }
        Loguear('2014-06-20','********************* cond var contexto: '.$condicion_var_contexto);
        // falta ver si falta alguna tabla en el from?
        $poner_expresion_sql = strtolower(<<<SQL
            select count(*) as cantidad 
                from {$from} 
                where {$this->casteo_temporal($this->clausula_where
                ($este->tabla_consistencias->datos->con_precondicion, 
                 $este->tabla_consistencias->datos->con_postcondicion, 
                 $este->tabla_consistencias->datos->con_rel). $condicion_var_contexto)} 
SQL
        );
        Loguear('2016-08-12','********************* expre: '.$poner_expresion_sql);
        $este->db->beginTransaction();
        try{
            $this->cursor_consistencia = $este->db->ejecutar_sql(new Sql($poner_expresion_sql));
            $this->con_error_compilacion=null;
            $con_valida = true;
            $var_no_encontradas_lista=@$this->error_var_no_encontradas[$este->tabla_consistencias->datos->con_con];
            if( /*$este->tabla_consistencias->datos->con_modulo!='DIARIO' && */ $var_no_encontradas_lista &&count($var_no_encontradas_lista)>0){
                $this->con_error_compilacion = "VARIABLES NO ENCONTRADAS: ".implode(', ',$this->error_var_no_encontradas[$este->tabla_consistencias->datos->con_con]);
                $con_valida = false;
                $this->estado->cantidad_sin_compilar++;
            }else{
                $this->estado->cantidad_compiladas++;
            }
        }catch(Exception $e){
            $this->con_error_compilacion = (@$e->getMessage())?:$this->con_error_compilacion;
            if(is_array($this->con_error_compilacion)){
                $this->con_error_compilacion=(@$this->con_error_compilacion[2])?:$this->con_error_compilacion;
            }
            $con_valida = false;
            $this->estado->errores .='';
            $this->estado->cantidad_sin_compilar++;
        }
        $este->db->commit();
        $este->tabla_consistencias->valores_para_update = array(
            'con_expresion_sql'=>strtolower($this->casteo_temporal($this->clausula_where($este->tabla_consistencias->datos->con_precondicion, $este->tabla_consistencias->datos->con_postcondicion, $este->tabla_consistencias->datos->con_rel))),
            'con_clausula_from'=>strtolower($from),
            'con_valida'=>$con_valida,
            'con_junta'=>json_encode($this->campos_para_unir),
            'con_error_compilacion'=>$this->con_error_compilacion,
            'con_ultima_variable'=>$ultima_variable,
            'con_demora_compilacion'=>(int)floor((microtime(true)-$tiempo_inicio)*1000),
        );
        $este->tabla_consistencias->ejecutar_update_unico(array('con_ope'=>$GLOBALS['NOMBRE_APP'], 'con_con'=>$este->tabla_consistencias->datos->con_con));
    }
    function responder_finalizar(){
        $this->salida=new Armador_de_salida(true); 
        if($this->estado->errores){
            $this->salida->enviar($this->estado->errores,'mensaje_error');
        }
        if($this->estado->cantidad_consistencias==1 && $this->argumentos->tra_mas_info){
            $filtro=(object)array(
                'tra_ope'=>$this->argumentos->tra_ope,
                'tra_con'=>$this->argumentos->tra_con,
            );
            if($this->estado->cantidad_sin_compilar>0){
                $this->salida->enviar('ERROR EN LA COMPILACIÓN DE CONSISTENCIAS','mensaje_error');
                $this->salida->enviar($this->con_error_compilacion,'',array('tipo'=>'pre'));
            }else{
                $proceso_correr=$this->nuevo_objeto('Proceso_correr_consistencias');
                $proceso_correr->argumentos=(object)array_merge((array)$filtro,array('tra_enc'=>'#todo'));
                $proceso_correr->responder();
                if($proceso_correr->existe_variable_observacion('s1a1_obs',$this)){
                    $vinconsistencias=$proceso_correr->contar_inconsistencias_mecanismo_prueba($this->argumentos->tra_ope,
                                                                             $this->argumentos->tra_con,
                                                                             '#todo');
                    if($vinconsistencias['total_en_s1']>0){ 
                        $this->salida->enviar('Cantidad de Encuestas con inconsistencia informada en Observaciones del S1:'. $vinconsistencias['total_en_s1']);
                        if (count($vinconsistencias['solo_en_observaciones'])>0 || count($vinconsistencias['solo_en_inconsistencias'])>0 ){
                            foreach(array('solo_en_inconsistencias'=>'Encuestas con inconsistencia detectada y no informada en observaciones: ',
                                          'solo_en_observaciones'  =>'Encuestas donde no saltó inconsistencia pero fue informada en observaciones del S1: ')
                                          as $para_comparar=>$mensaje){
                                if(count($vinconsistencias[$para_comparar])>0){
                                    $this->salida->enviar($mensaje.implode(', ',$vinconsistencias[$para_comparar]),'mensaje_alerta');
                                }
                            }
                            /*
                            foreach($vinconsistencias['solo_en_observaciones'] as $vencuesta){
                                    $parametros_js=json_encode(array('tra_ope'=>$GLOBALS['NOMBRE_APP'],'tra_enc'=>$vencuesta,'tra_hn'=>'-951'));
                                    Loguear('2014-07-12','********************* parametros: '.$parametros_js. " enc:".$vencuesta. " url:".$GLOBALS['NOMBRE_APP'].".php?hacer=ingresar_encuesta&todo=encodeURIComponent({$parametros_js})"+'y_luego=boton_ingresar_encuesta');                        
                                    $this->salida->enviar_link($vencuesta,'',$GLOBALS['NOMBRE_APP'].".php?hacer=ingresar_encuesta&todo=encodeURIComponent({$parametros_js})"+'y_luego=boton_ingresar_encuesta');
                            } 
                            */
                        }
                    }
                }    
                $this->salida->abrir_grupo_interno();
                    $this->salida->enviar('','',array('id'=>'resultados'));
                $this->salida->cerrar_grupo_interno();
            }
            $este=$this;
            $grilla=function($nombre_grilla,$prefijo_filtro) use ($este,$filtro) {
                enviar_grilla(
                    $este->salida,
                    $nombre_grilla,
                    cambiar_prefijo($filtro,'tra_',$prefijo_filtro),
                    'resultados',
                    array('agregar_al_contenedor'=>true,'simple'=>true)
                );
            };
            if($this->estado->cantidad_sin_compilar==0){
                $grilla('inconsistencias','inc_'   );
            }
            $grilla('tabla_con_var'  ,'convar_');
            $grilla('tabla_ano_con'  ,'anocon_');
        }else{
            $this->salida->enviar($this->estado->cantidad_compiladas.' consistencias compiladas');
            $this->salida->enviar($this->estado->cantidad_sin_compilar.' consistencias sin compilar');        
        }
        return $this->salida->obtener_una_respuesta_HTML();
    }    
    function clausula_where($con_precondicion, $con_postcondicion,$con_rel){
        $consistencia_where = "";
        $con_precondicion = expresion_regular_agregar_prefijo($con_precondicion,'pla_');
        $con_postcondicion = expresion_regular_agregar_prefijo($con_postcondicion,'pla_');
        if($con_rel=='=>' || !$con_rel){
            if(!$con_precondicion){
                $consistencia_where="($con_postcondicion) is not true";
            }else{
                $consistencia_where="($con_precondicion) is true and ($con_postcondicion) is not true";
            }
        }else{
            $consistencia_where="($con_precondicion) is true is distinct from (($con_postcondicion) is true)";
        }
        return $consistencia_where;
    }
    function clausula_campos(){
    }
    function agregar_prefijo($clausula_where){
        return $clausula_where;
    }
    function casteo_temporal($expresion_sql){
        global $separador_diccionario_regexp;
        global $separador_diccionario_replacer;
        $expresion_sql=preg_replace($separador_diccionario_regexp,$separador_diccionario_replacer,$expresion_sql);
        //OJO: GENERALIZAR
        foreach(variables_especiales_consistencias('tradu',$this,$this) as $cuando_vea=>$pongo){
            if($pongo!==null){
                $expresion_sql=preg_replace("/\b{$cuando_vea}\b/i",$pongo,$expresion_sql);
            }
        }
        return $expresion_sql;
    }
    function sql_para_con_var($es_el_insert,$filtro_ins,$con_momento){
        global $operadores_logicos_regexp;
        global $pg_identifica_var_regexp;
        $select_lista_parcial=" COALESCE(v.var_texto,pre_texto) AS convar_texto,". 
                   " v.var_for AS convar_for, v.var_mat AS convar_mat, v.var_orden AS convar_orden";
        $join_varcal="";
        if($es_el_insert){
            $parte_insert=<<<SQL
        INSERT INTO con_var
SQL;
            $filtro_error="";
            $tipo_join="INNER";
            if($con_momento=='Procesamiento 2'){
                $select_lista_parcial=" COALESCE(COALESCE(v.var_texto,pre_texto),c.varcal_nombre) AS convar_texto,". 
                    " COALESCE(v.var_for, varcaldes_for ) AS convar_for, coalesce(v.var_mat,varcaldes_mat) AS convar_mat, coalesce(v.var_orden,c.varcal_orden) AS convar_orden";            
                $tipo_join="LEFT";    
                $join_varcal=" LEFT JOIN varcal c on x.vars[1]=c.varcal_varcal and (c.varcal_activa=true and (not c.varcal_tipo='normal' or c.varcal_valida is true))".
                    " LEFT JOIN varcal_destinos d ON c.varcal_destino=d.varcaldes_destino and c.varcal_ope=d.varcaldes_ope ";
                $filtro_error=" AND (var_var IS NOT NULL OR varcal_varcal IS NOT NULL)";
        }
        }else{
            $parte_insert="";
            $filtro_error=" AND var_var IS NULL";
            $tipo_join="LEFT";
            if($con_momento=='Procesamiento 2'){
                $select_lista_parcial=" COALESCE(COALESCE(v.var_texto,pre_texto),c.varcal_nombre) AS convar_texto,". 
                    " COALESCE(v.var_for, varcaldes_for ) AS convar_for, coalesce(v.var_mat,varcaldes_mat) AS convar_mat, coalesce(v.var_orden,c.varcal_orden) AS convar_orden";
                $filtro_error=" AND var_var IS NULL AND varcal_varcal IS NULL";
                $join_varcal=" LEFT JOIN varcal c on x.vars[1]=c.varcal_varcal and (c.varcal_activa=true and (not c.varcal_tipo='normal' or c.varcal_valida is true))".
                    " LEFT JOIN varcal_destinos d ON c.varcal_destino=d.varcaldes_destino and c.varcal_ope=d.varcaldes_ope ";
            }

        }
        $este=$this;
        $lista_palabras_excluir="'".implode("','",variables_especiales_consistencias('excluir convar',$este))."','".
            str_replace('|',"','",$operadores_logicos_regexp)."'";
        
        $a=<<<SQL
        $parte_insert SELECT distinct con_ope AS convar_ope, x.convar_con, x.vars[1] AS convar_var, 
        {$select_lista_parcial}
        , 1 as convar_tlg
        FROM ( select con_ope, convar_con, vars from (SELECT DISTINCT con_ope, consistencias.con_con AS convar_con,  
        regexp_matches(lower((COALESCE(consistencias.con_precondicion, '') || ' and ') || 
        COALESCE(consistencias.con_postcondicion, '')), '$pg_identifica_var_regexp', 'g') AS vars
        FROM consistencias  where  {$filtro_ins->where}
        order by con_con) y) x
        {$tipo_join} JOIN variables v ON x.vars[1] = v.var_var and var_ope=con_ope 
        {$tipo_join} JOIN preguntas p ON var_ope=pre_ope and var_pre=pre_pre
        {$join_varcal} 
        WHERE x.vars[1] not in ($lista_palabras_excluir) {$filtro_error};
SQL;
        Loguear('2015-08-10','********************* sql: '. $a);
        return new Sql(<<<SQL
        $parte_insert SELECT distinct con_ope AS convar_ope, x.convar_con, x.vars[1] AS convar_var, 
        {$select_lista_parcial}
        , 1 as convar_tlg
        FROM ( select con_ope, convar_con, vars from (SELECT DISTINCT con_ope, consistencias.con_con AS convar_con,  
        regexp_matches(lower((COALESCE(consistencias.con_precondicion, '') || ' and ') || 
        COALESCE(consistencias.con_postcondicion, '')), '$pg_identifica_var_regexp', 'g') AS vars
        FROM consistencias  where  {$filtro_ins->where}
        order by con_con) y) x
        {$tipo_join} JOIN variables v ON x.vars[1] = v.var_var and var_ope=con_ope 
        {$tipo_join} JOIN preguntas p ON var_ope=pre_ope and var_pre=pre_pre
        {$join_varcal} 
        WHERE x.vars[1] not in ($lista_palabras_excluir) {$filtro_error};
SQL
        , $filtro_ins->parametros);
    }
    function actualizar_convar($filtro_del,$filtro_ins, $con_momento){        
        $sentencia_delete = <<<SQL
        DELETE FROM con_var WHERE {$filtro_del->where};
SQL;
        $cursor=$this->db->ejecutar_sql($this->sql_para_con_var(false,$filtro_ins,$con_momento));
        while($fila=$cursor->fetchObject()){
            $this->error_var_no_encontradas[$fila->convar_con][]=$fila->convar_var;
        }
        $this->db->beginTransaction();
        $this->db->ejecutar_sql(new Sql($sentencia_delete,$filtro_del->parametros)); 
        $this->db->ejecutar_sql($this->sql_para_con_var(true,$filtro_ins,$con_momento)); 
        $this->db->commit();
    }
}
?>