<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "comunes.php";

//constantes y funciones de expresiones regulares
global $operadores_logicos_regexp;
global $parseador_variables_regexp;
global $postgres_identifica_var_regexp;
global $parseador_llamadas_regexp;
global $separador_diccionario_regexp;
global $separador_diccionario_replacer;
global $pg_identifica_var_regexp;
$operadores_logicos_regexp="or|and|is|end|in|not|true|false|null|case|when|else";
$operadores_logicos_regexp="or|and|is|end|in|not|true|false|null|case|when|else";
// ORIGINAL $postgres_identifica_var_regexp="([A-Za-z][A-Za-z_.0-9]*)(\s*)($|[-+)<=>,*/!|]|\s({$operadores_logicos_regexp}))";
$postgres_identifica_var_regexp="([A-Za-z][A-Za-z_.0-9]*)(\s*)($|[-+)<=>,*/!|]|\s(\b(is null|is true|is false|{$operadores_logicos_regexp})\b))";
$pg_identifica_var_regexp="([A-Za-z][A-Za-z_.0-9]*)(\s*)($|[-+)<=>,*/!|]|\s(\m(is null|is true|is false|{$operadores_logicos_regexp})\M))";
$parseador_variables_regexp="#{$postgres_identifica_var_regexp}#";
$parseador_llamadas_regexp='#(\b(?!and)(?!or)(?!not)([A-Za-z][A-Za-z_.0-9]*)(\s*)(\\(((?>[^()]+)|(?-2))*\\)))#';
//$parseador_llamadas_regexp='#(\b(?!and)([A-Za-z][A-Za-z_.0-9]*)(\s*)[(][^)]*[)])#'; sin recursion
//$postgres_identifica_var_regexp='([A-Za-z][A-Za-z0-9_]*)(?![A-Za-z0-9_]|[.(])';
$separador_diccionario_regexp='#\\@([A-Za-z][A-Za-z_.0-9]*)\\(([^)\']+)\\)#';
$separador_diccionario_replacer='(select varcondic_destino from varcondic where varcondic_dic=$$$1$$ and varcondic_origen=$$$2$$)';

function variables_especiales_consistencias($tipo,$este,$unidor=false){
    $maestro_especiales=
      array('p3_b'         =>array('excluir convar'=>true ,'tradu'=>'pla_edad'),
            'participacion'=>array('excluir convar'=>true ,'tradu'=>null),
            'replica'      =>array('excluir convar'=>true ,'tradu'=>null),
            'dominio'      =>array('excluir convar'=>true ,'tradu'=>null),
            'encues'       =>array('excluir convar'=>true ,'tradu'=>'pla_enc'),
            'nhogar'       =>array('excluir convar'=>true ,'tradu'=>'pla_hog'),
            'miembro'      =>array('excluir convar'=>true ,'tradu'=>'pla_mie'), // queda:mie porque es una traducción de la consistencias
            'enc'          =>array('excluir convar'=>true ,'tradu'=>$unidor?$unidor->campos_para_unir['enc']:null),
            'hog'          =>array('excluir convar'=>true ,'tradu'=>$unidor?$unidor->campos_para_unir['hog']:null),
            'mie'          =>array('excluir convar'=>true ,'tradu'=>$unidor?$unidor->campos_para_unir['mie']:null), // queda:mie porque es una traducción de la consistencias
            'nmiembro'     =>array('excluir convar'=>true ,'tradu'=>$unidor?$unidor->campos_para_unir['mie']:null), // queda:mie porque es una traducción de la consistencias
            'hab'          =>array('excluir convar'=>true ,'tradu'=>null)
        );
    /* OJO FALTA GENERALIZAR EL A1. Puede ser así:
         poner en la tabla variables un booleano que diga (variable_de_vivienda o solo_hogar_1) y esas
         son las que deben traducirse
    */
    $st_sql=<<<SQL
      select blo_for,string_agg( var_var, ',' order by blo_orden, pre_orden, var_orden) as lista_var_viv
        from encu.bloques JOIN encu.preguntas ON bloques.blo_ope = preguntas.pre_ope AND bloques.blo_for = preguntas.pre_for AND bloques.blo_blo = preguntas.pre_blo
                JOIN encu.variables ON preguntas.pre_ope = variables.var_ope AND preguntas.pre_pre = variables.var_pre
        where bloques.blo_ope=:p_ope AND bloques.blo_blo='Viv'
        group by blo_for
SQL;
    $cursor=$este->db->ejecutar_sql(new Sql($st_sql,
                                        array(':p_ope'=>$GLOBALS['nombre_app'])));
    if($que_encuentra=$cursor->fetchObject()){
        $formulario_vivienda= $que_encuentra->blo_for;
        $variables_vivienda = explode(',',$que_encuentra->lista_var_viv);
        //loguear('2014-07-25','form:'.$formulario_vivienda.' lista_viv:'.$que_encuentra->lista_var_viv); 
    }    
    if(isset($variables_vivienda)){
        foreach($variables_vivienda as $variable){
            $maestro_especiales[$variable]=array(
                'excluir convar'=>false,
                'tradu'=>"(select pla_{$variable} from plana_{$formulario_vivienda}_ where pla_hog = 1 and pla_enc = tem.pla_enc)");
        }
    }
    switch($tipo){
    case "tradu":
        return array_map(
            function($valor){ return $valor['tradu']; },
            cambiar_prefijo($maestro_especiales,'','pla_')
        );
    case 'excluir convar':
        return array_keys(array_filter(
            $maestro_especiales,
            function($valor){ return $valor['excluir convar']; }
        ));
    }
}

function expresion_regular_extraer($expresion, $patrones){
    preg_match_all($patrones,$expresion, $contenedor);
    return $contenedor[1];
}
function expresion_regular_extraer_variables($expresion){
    global $parseador_variables_regexp;
    return array_values(array_filter(expresion_regular_extraer($expresion, $parseador_variables_regexp),function($que){
        global $operadores_logicos_regexp;
        return strpos("|{$operadores_logicos_regexp}|","|{$que}|")===false;
    }));
}
function expresion_regular_extraer_llamada_funciones($expresion){
    global $parseador_llamadas_regexp;
    return expresion_regular_extraer($expresion,$parseador_llamadas_regexp);
}

function expresion_regular_reemplazar($patrones, $reemplazar_por, $expresion){
    return preg_replace($patrones, $reemplazar_por, $expresion);
}
function expresion_regular_reemplazar_sin_restricciones($expresion, $cadena, $reemplazar_por){
    return expresion_regular_reemplazar("#({$cadena})#i", $reemplazar_por, $expresion);
    //return preg_replace("#({$cadena})#i",$reemplazar_por,$expresion);
}
function expresion_regular_reemplazar_variable($expresion, $cadena, $reemplazar_por){
    global $operadores_logicos_regexp;
    return expresion_regular_reemplazar("#(^|[-+()<=>,*/!|\s]|($operadores_logicos_regexp))({$cadena})($|[-+()<=>,*/!|\s]|($operadores_logicos_regexp))#i", "\\1{$reemplazar_por}\\4", $expresion);
    //return preg_replace("#(^|[-+()<=>,*/!|\s]|($operadores_logicos_regexp))({$cadena})($|[-+()<=>,*/!|\s]|($operadores_logicos_regexp))#i", "\\1{$reemplazar_por}\\4",$expresion);
}
function expresion_regular_buscar($expresion, $cadena){
    return preg_match("#({$cadena})#i",$expresion);
}
function expresion_regular_agregar_prefijo($expresion, $para_agregar){
    global $operadores_logicos_regexp;
    global $parseador_variables_regexp;
    $expresion = expresion_regular_reemplazar($parseador_variables_regexp, "{$para_agregar}\\1\\2\\3", $expresion);
    $expresion = expresion_regular_reemplazar("#{$para_agregar}(({$operadores_logicos_regexp}|null|not|true)\b)#i", "\\1", $expresion);
    return $expresion;
}

function controlar_Resp_dato($ope, $este, $enc, $mostrar_en_pantalla){
    $este->tabla_hogares=$este->nuevo_objeto('Tabla_plana_AJH1_');
    $este->tabla_hogares->leer_varios(array(
        'pla_enc'=>$enc,
    ));
    while($este->tabla_hogares->obtener_leido()){
        if(($este->tabla_hogares->datos->pla_rea <> 2) && (! $este->tabla_hogares->datos->pla_respondente_num > 0)){
            $este->tabla_inconsistencias->valores_para_insert=array_merge(
                claves_respuesta_vacia('inc_'),
                array(
                    'inc_ope'=>$ope,
                    'inc_enc'=>$enc,
                    'inc_hog'=>$este->tabla_hogares->datos->pla_hog,                
                    'inc_con'=>'Resp_dato'
                )
            );
            $este->tabla_inconsistencias->ejecutar_insercion();
            $este->problemas++;
            if ($mostrar_en_pantalla){
                $este->salida->enviar('* Problema '.$este->problemas.' Resp_dato');
            }
        }
    }
}

function controlar_omisiones_de_ingreso($filtro_para_consistir,$este){
    /* SE controlan con las consistencias automáticas
    $claves_res_numericas=implode(', ',nombres_campos_claves('res_','N'));
    $array_salida=array();
    $filtro_delete=$este->nuevo_objeto("Filtro_Normal",cambiar_prefijo($filtro_para_consistir,'tra_','inc_'));
    $sentencia_delete="DELETE FROM inconsistencias WHERE inc_con like 'opc_%' ".$filtro_delete->and_where;
    $cursor=$este->db->ejecutar_sql(new Sql($sentencia_delete, $filtro_delete->parametros));   
    $sentencia_insert="INSERT INTO inconsistencias (inc_ope, ".implode(', ',nombres_campos_claves('inc_','N')).", inc_con, inc_variables_y_valores, inc_tlg)
      select '{$GLOBALS['NOMBRE_APP']}', $claves_res_numericas,res_estado as inc_con, comun.concato(res_var||', ') as variables_y_valores, ".obtener_tiempo_logico($este)."  from respuestas ";
    $parametros_ejecutar=array();
    $sentencia_where=" where res_hog<>0 and res_estado not in ('opc_blanco','opc_ok','opc_salt')";
    $returning=" returning inc_con||'       :'||inc_variables_y_valores as problema";
    $sentencia_group=" group by $claves_res_numericas, res_estado ";
    $filtro_select=$este->nuevo_objeto("Filtro_Normal",cambiar_prefijo($filtro_para_consistir,'tra_','res_'));
    $Sql=$sentencia_insert.$sentencia_where.$filtro_select->and_where.$sentencia_group.$returning;
    $este->db->beginTransaction();
    $cursor=$este->db->ejecutar_sql(new Sql($Sql, $filtro_select->parametros));   
    if($returning){
        while($fila=$cursor->fetchObject()){
            $array_salida[]=$fila->problema;
        }
    }
    $este->db->commit();  
    return $array_salida;    
    */
}

class probar_expresiones_regulares extends Pruebas{
    function _construct(){
        $this->contexto = new Contexto();
    }
    function probar_expresion_regular_reemplazar_variable(){
        $this->probador->verificar_texto("(((informado(E9_edad) or (informado(E9_anio))) and E12 = 4 and E13 = 1) && !(E9_edad>=14 or E9_anio>=2012-copia_edad+14))", expresion_regular_reemplazar_variable("(((informado(E9_edad) or (informado(E9_anio))) and E12 = 4 and E13 = 1) && !(E9_edad>=14 or E9_anio>=2012-edad+14))", "edad", "copia_edad"));
        $this->probador->verificar_texto("copia_p4=1 and (P5=1 or P5=2) and p5b>0 and p5b<95", expresion_regular_reemplazar_variable("P4=1 and (P5=1 or P5=2) and p5b>0 and p5b<95", "p4", "copia_p4"));
        $this->probador->verificar_texto("E9_edad>=20 or E9_anio>=2012-copia_edad+20", expresion_regular_reemplazar_variable("E9_edad>=20 or E9_anio>=2012-edad+20", "edad", "copia_edad"));
        $this->probador->verificar_texto("Sexo=2 and copia_edad>=10", expresion_regular_reemplazar_variable("Sexo=2 and edad>=10", "edad", "copia_edad"));
    }
    function probar_expresion_regular_reemplazar_sin_restricciones(){
        $this->probador->verificar_texto("(((informado(E9_edad) or (informado(E9_anio))) and E12 = 4 and copia_e13 = 1) && !(E9_edad>=14 or E9_anio>=2012-edad+14))", expresion_regular_reemplazar_sin_restricciones("(((informado(E9_edad) or (informado(E9_anio))) and E12 = 4 and E13 = 1) && !(E9_edad>=14 or E9_anio>=2012-edad+14))", "e13", "copia_e13"));
        $this->probador->verificar_texto("p4=1 and (copia_p5=1 or copia_p5=2) and copia_p5b>0 and copia_p5b<95", expresion_regular_reemplazar_sin_restricciones("p4=1 and (P5=1 or P5=2) and p5b>0 and p5b<95", "p5", "copia_p5"));
        $this->probador->verificar_texto("E9_copia_edad>=20 or E9_anio>=2012-copia_edad+20", expresion_regular_reemplazar_sin_restricciones("E9_edad>=20 or E9_anio>=2012-edad+20", "edad", "copia_edad"));
        $this->probador->verificar_texto("copia_sexo=2 and edad>=10", expresion_regular_reemplazar_sin_restricciones("Sexo=2 and edad>=10", "sexo", "copia_sexo"));
    }
    function probar_expresion_regular_buscar(){
        $this->probador->verificar(1, expresion_regular_buscar("(((informado(E9_edad) or (informado(E9_anio))) and E12 = 4 and E13 = 1) && !(E9_edad>=14 or E9_anio>=2012-edad+14))", "E9_anio"));
        $this->probador->verificar(1, expresion_regular_buscar("p4=1 and (P5=1 or P5=2) and p5b>0 and p5b<95", "p5"));
        $this->probador->verificar(0, expresion_regular_buscar("E9_edad>=20 or E9_anio>=2012-copia_edad+20", "sn1"));
        $this->probador->verificar(0, expresion_regular_buscar("Sexo=2 and edad>=10", "edades"));
    }
    function probar_expresion_regular_agregar_prefijo(){
        $this->probador->verificar_texto("(((informado(prefijo_E9_edad) or (informado(prefijo_E9_anio))) and prefijo_E12 = 4 and prefijo_E13 = 1) && !(prefijo_E9_edad>=14 or prefijo_E9_anio>=2012-prefijo_edad+14))", expresion_regular_agregar_prefijo("(((informado(E9_edad) or (informado(E9_anio))) and E12 = 4 and E13 = 1) && !(E9_edad>=14 or E9_anio>=2012-edad+14))", "prefijo_"));
        $this->probador->verificar_texto("prefijo_p4=1 and (prefijo_P5=1 or prefijo_P5=2) and prefijo_p5b>0 and prefijo_p5b<95", expresion_regular_agregar_prefijo("p4=1 and (P5=1 or P5=2) and p5b>0 and p5b<95", "prefijo_"));        
        $this->probador->verificar_texto("pla_edad>=10 and pla_ingtot>0", expresion_regular_agregar_prefijo("edad>=10 and ingtot>0", "pla_"));
        $this->probador->verificar_texto("prefijo_E9_edad>=20 or prefijo_E9_anio>=2012-prefijo_edad+20", expresion_regular_agregar_prefijo("E9_edad>=20 or E9_anio>=2012-edad+20", "prefijo_"));
        $this->probador->verificar_texto("prefijo_Sexo=2 and prefijo_edad>=10", expresion_regular_agregar_prefijo("Sexo=2 and edad>=10", "prefijo_"));
    }
    function probar_expresion_regular_extraer_variables(){
        $this->probador->verificar_arreglo(
            array(
                'p4',
                'P5',
                'P5',
                'p5b',
                'p5b',
                'x22'
            ),
            expresion_regular_extraer_variables("p4=1 and (P5=1 or P5=2) and p5b>0 and p5b<95 and dbo.funcion (x22)")
        );
        $this->probador->verificar_arreglo(
            array(
                't4',
                't5',
                't6'
            ),
            expresion_regular_extraer_variables("t4=1 and t5 is null and t6 is true")
        );
        $this->probador->verificar_arreglo(array(
            'E9_edad',
            'E9_anio',
            'edad'
        ),
        expresion_regular_extraer_variables("E9_edad>=20 or E9_anio>=2012-edad+20"));
        $this->probador->verificar_arreglo(array(
            'edad',
            'ingtot',
        ),
        expresion_regular_extraer_variables("edad>=10 and ingtot>0"));
        $this->probador->verificar_arreglo(array(
            'a11'
        ),
        expresion_regular_extraer_variables("true or a11 or true or false"));
    }
    function probar_expresion_and_funcion(){
        $this->probador->verificar(
            expresion_regular_agregar_prefijo('p4=4 and textoinformado(p7)','pla_'),
            'pla_p4=4 and textoinformado(pla_p7)'
        );
        $this->probador->verificar(
            expresion_regular_agregar_prefijo('Edad<25 and informado(p5b) and P5b<>95 and not nsnc(p5b)','pla_'),
            'pla_Edad<25 and informado(pla_p5b) and pla_P5b<>95 and not nsnc(pla_p5b)'
        );
    }
    function probar_expresion_regular_extraer_llamada_funciones(){
        $this->probador->verificar_arreglo(
            array(
                'informado(pla_f_nac_o)',
                'nsnc(pla_f_nac_o)',
                'dbo.es_fecha(pla_f_nac_o)'
            ),
            expresion_regular_extraer_llamada_funciones(
                '(informado(pla_f_nac_o) and (not nsnc(pla_f_nac_o))) is true and (dbo.es_fecha(pla_f_nac_o) = 1) is not true'
            )
        );
        $this->probador->verificar_arreglo(
            array(
                'informado(pla_f_nac_o)',
                'nsnc(pla_f_nac_o)',
                'dbo.es_fecha(pla_f_nac_o)'
            ),
            expresion_regular_extraer_llamada_funciones(
                '(informado(pla_f_nac_o) or (not nsnc(pla_f_nac_o))) is true and (dbo.es_fecha(pla_f_nac_o) = 1) is not true'
            )
        );
        $this->probador->verificar_arreglo(
            array(
                'informado(T53c_anios)',
                'nsnc(T53c_anios)',
                'informado(T54b)',
                'nsnc(T54b)'
            ),
            expresion_regular_extraer_llamada_funciones(
                '(informado(T53c_anios) or (not(nsnc(T53c_anios)))) is true and (informado(T54b) and (not(nsnc(T54b)))) is not true'
            )
        );        
        $this->probador->verificar_arreglo(
            array(
                'f ( j )',
                'g( 4, g, f)',
                'hhh2 ( 45, (4+jkl)*((3+j)*2))'
            ),
            expresion_regular_extraer_llamada_funciones(
                ' f ( j ) + 5 + g( 4, g, f) + hhh2 ( 45, (4+jkl)*((3+j)*2))<0'
            )
        );
    }
    function seria_ideal_probar_expresion_regular_extraer_llamada_funciones(){
        $this->probador->verificar_arreglo(
            array(
                'f ( g (pepe, 5) + 4)',
                'g (pepe, 5)'
            ),
            expresion_regular_extraer_llamada_funciones(
                ' f ( g (pepe, 5) + 4) '
            )
        );
    }
    function probar_separador(){
        global $separador_diccionario_regexp;
        global $separador_diccionario_replacer;
        $this->probador->verificar(
            ' and (select varcondic_destino from varcondic where varcondic_dic=$$extranj$$ and varcondic_origen=$$v7$$)=1',
            preg_replace($separador_diccionario_regexp,$separador_diccionario_replacer,
            " and @extranj(v7)=1"));
        $this->probador->verificar(
            " and arreglo[extranj,v7]=1 or arreglo[otro,g4 + g5]=2", 
            preg_replace($separador_diccionario_regexp,'arreglo[$1,$2]',
            " and @extranj(v7)=1 or @otro(g4 + g5)=2"));
    }
    function probar_regexp(){
        $this->probador->verificar(
            'pla_enc=(s1.pla_hog)',
            preg_replace('#\bpla_hog\b#','s1.pla_hog',
            "pla_enc=(pla_hog)"));
        $this->probador->verificar(
            's1.pla_enc=(s1.pla_hog)',
            preg_replace('#\bpla_(hog|enc)\b#','s1.pla_$1',
            "pla_enc=(pla_hog)"));
    }
}

?>