<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";

class Proceso_colorear_respuestas extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Colorear respuestas',
            'submenu'=>'mantenimiento',
            'para_produccion'=>true,
            'permisos'=>array('grupo'=>'programador'),
            'parametros'=>array(
                'tra_ope'=>array('label'=>'operativo','def'=>$GLOBALS['NOMBRE_APP']),
                'tra_for'=>array('label'=>'formulario','def'=>'TEM'),
                'tra_mat'=>array('label'=>'matriz','def'=>''),
                'tra_enc'=>array('label'=>'número de encuesta','def'=>'120012'),
                'tra_hog'=>array('label'=>'número de hogar','def'=>'0'),
                'tra_grabando'=>array('label-derecho'=>'grabando el coloreo en la base','checked'=>false,'type'=>'checkbox','label'=>false),
            ),
            'boton'=>array('id'=>'colorear'),
        ));
    }
    function colorear($pk_respuestas,$id_variable_cursor_actual){
        // $this->pk_respuestas=cambiar_prefijo($pk_respuestas,'tra_','res_'); // para acceder a todas las respuestas
        $this->pk_respuestas=$pk_respuestas;
        $this->pk_respuesta=(array)$this->pk_respuestas; // para acceder a una sola respuesta
        if($pk_respuestas->res_for==$GLOBALS['nombre_app']){
            $this->preguntas_ud=$this->estructura->formulario->{$pk_respuestas->res_for}->{$pk_respuestas->res_mat?:"_empty_"};
            //$estructura_formulario=(array)$this->preguntas_ud=$this->estructura->formulario->{$pk_respuestas->res_for};
            // echo print_r($estructura_formulario);
            //$this->preguntas_ud=$estructura_formulario["_empty_"];
            $this->Validar_rta_ud($id_variable_cursor_actual);
        }
    }
    function rta_ud($variable){
        $this->pk_respuesta['res_var']=quitar_prefijo($variable,'var_');
        $this->tabla_respuestas->leer_unico($this->pk_respuesta);
        return $this->tabla_respuestas->valor_ingresado();
    }
    function hacer_expresion_evaluable($expresion){
        $expresion=preg_replace('/\bis not\b/i'                 ,"!="                            ,$expresion);
        $expresion=preg_replace('/\bis distinct from\b/i'       ,"<>"                            ,$expresion);
        $expresion=preg_replace('/\band\b/i'                    ,"&&"                            ,$expresion);
        $expresion=preg_replace('/\bor\b/i'                     ,"||"                            ,$expresion);
        $expresion=preg_replace('/\bnot\b/i'                    ,"!"                             ,$expresion);
        $expresion=preg_replace('/[A-Za-z]\w*(?!\w|[.(])/'      ,'var_$0'                        ,$expresion);
        $expresion=preg_replace('/var_nenc/'                    ,'$this->pk_respuestas->res_enc' ,$expresion);
        $expresion=preg_replace('/var_pk_tra_(\w*)\b/'          ,'$this->pk_respuestas->res_$1'  ,$expresion);
        //$expresion=preg_replace("/rta_ud\.var_copia_/'          ,"copia_ud.copia_"             ,$expresion);
        $expresion=preg_replace('/var_\w*\b/'                   ,'$this->rta_ud("$0")'           ,$expresion);
        $expresion=preg_replace('/(\w*_ud\.var_\w*)/'           ,"($1?:0)"                       ,$expresion);
        $expresion=preg_replace('/^(.*)<=>(.*)$/'               ,"($1) = ($2)"                   ,$expresion);
        $expresion=preg_replace('/^(.*)=>(.*)$/'                ,"($1) && !($2)"                 ,$expresion);
        $expresion=preg_replace('/([^><!])=/'                   ,"$1 == "                        ,$expresion);
        $expresion=preg_replace('/<>/i'                         ,"!="                            ,$expresion);
        $expresion=preg_replace('/$this->rta_ud(false)/'        ,"false"                         ,$expresion);
        $expresion=preg_replace('/$this->rta_ud(true)/'         ,"true"                          ,$expresion);
        $expresion=preg_replace('/\[/'                          ,"array("                        ,$expresion);
        $expresion=preg_replace('/\]/'                          ,")"                             ,$expresion);
        Loguear('2012-05-20',$expresion,false,false,true);
        //  */
        return "return ".strtolower($expresion).";";
    }
    function Marcar_Posteriores_Al_Omitidos($variable_omitida){
        // transcripción a PHP de la función encuestas.js.Marcar_Posteriores_Al_Omitidos(variable_omitida)
        $ya_vi_la_omitida=false;
        foreach($this->preguntas_ud as $var_actual=>$definicion){
            if($ya_vi_la_omitida){
                $this->estados_rta_ud[$var_actual]=$this->estados_rta->hay_omitidas;
            }else{
                if($var_actual==$variable_omitida){ 
                    $ya_vi_la_omitida=true;
                    $this->estados_rta_ud[$var_actual]=$this->estados_rta->omitido;
                }
            }
        }
    }
    function Validar_rta_ud($id_variable_cursor_actual){
        // transcripción a PHP de la función encuestas.js.Validar_rta_ud(id_variable_actual)
        // devuelve el lugar a saltar si está indicada id_variable_cursor_actual
        // si no devuelve la primer variable con blanco
        // transcri
        $this->estados_rta_ud=array();
        $proxima_variable=null; // salto desde id_variable_cursor_actual
        $var_anterior_habilitada=null; // anterior a la actual del procesamiento. 
        $salteando_hasta=false;
        $la_anterior_esta_ingresada_o_es_optativa_blanca=true;
        $esta_esta_ingresada=true;
        $ya_vi_algun_null_erroneo=false;
        $primer_null_de_la_serie=false;
        $variable_omitida=false;
        $tipo_anterior_multiple=false;
        $expresion_habilitar;
        $primer_blanco=false;
        $ultima_variable_con_valor=0;
        $cantidad_de_variables_al_momento=0;
        /////////////// CICLO POR CADA VARIABLE
        foreach($this->preguntas_ud as $var_actual=>$def_var_actual){
            Loguear('2012-05-14','var_actual '.$var_actual,false,false,true);
            $var_anterior[$var_actual]=$var_anterior_habilitada; // guarda la variable anterior habilitada
            Loguear('2012-05-14','var_anterior',false,false,true);
            $cantidad_de_variables_al_momento++;
            Loguear('2012-05-14',"cantidad_de_variables_al_momento $cantidad_de_variables_al_momento",false,false,true);
            if($id_variable_cursor_actual==$var_anterior_habilitada){
                if($salteando_hasta){
                    $proxima_variable=$salteando_hasta;
                }else{
                    $proxima_variable=$var_actual;
                }
            }
            $expresion_filtro=@$def_var_actual->expresion_filtro;
            Loguear('2012-05-14',"expresion_filtro $expresion_filtro",false,false,true);
            $tipo=@$def_var_actual->multiple; 
            $variable_habilitada=true;
            $variable_mal_habilitada=false;
            Loguear('2012-05-14','===================='.$var_actual,false,false,true);
            if($expresion_filtro){
                ///////////// Para los filtros:
                if(!$salteando_hasta || $salteando_hasta == $var_actual){
                    $salteando_hasta=false;
                    $valor = eval($this->hacer_expresion_evaluable($expresion_filtro));
                    if ($valor){
                        $salteando_hasta=$def_var_actual->salta;
                    }
                }
                $variable_habilitada=false; // no es una variable habilitada, es un filtro
            } else if(!@$def_var_actual->no_es_variable) {
                /////////// Normaliza el valor de la variable unificando nulos y pasando el tipo a Number o Sting según corresponda y haciendo TRIM
                Loguear('2012-05-16',"no_es_variable ".isset($def_var_actual->no_es_variable).'&'.@$def_var_actual->no_es_variable,false,false,true);
                $valor=$this->rta_ud($var_actual); // si la variable no está especificada devuelve undefined (ej: para los casos de prueba).
                $opciones=@($def_var_actual->opciones);
                if(is_array($opciones)){
                    $viejo_opciones=$opciones;
                    $opciones=(object)(array());
                    foreach($viejo_opciones as $clave=>$contenido){
                        $opciones->{$clave.""}=$contenido;
                    }
                }
                if($valor===''){
                    $valor=null;
                }else if($valor==null){
                    // no convertir
                }else if($valor=='+' && @$def_var_actual->marcar){
                    $valor=$def_var_actual->marcar;
                }else if(@$def_var_actual->es_numerico){
                    if(is_numeric($valor)){ 
                        $valor=$valor+0;
                    }
                }else if(gettype($valor)=="integer" || gettype($valor)=="double"){
                    $valor=$valor."";
                }else if($valor!=trim($valor)){
                    $valor=trim($valor);
                    if($valor===''){
                        $valor=null;
                    }
                }
                // Loguear('2012-05-14','/////////////////'.$valor,false,false,true);
                // EN PHP NO: rta_ud[$var_actual]=valor;
                //////////////// SALTEA si corresonde
                $expresion_habilitar=@$def_var_actual->expresion_habilitar;
                $variable_habilitada = (!$salteando_hasta || $var_actual==$salteando_hasta)
                    && (!$expresion_habilitar || eval($this->hacer_expresion_evaluable($expresion_habilitar)));
                if(!$variable_habilitada){
                    Loguear('2012-05-14',"!variable_habilitada",false,false,true);
                    if($valor){
                        $this->estados_rta_ud[$var_actual]=$this->estados_rta->ingreso_sobre_salto;
                    }else{
                        $this->estados_rta_ud[$var_actual]=$this->estados_rta->salteada;
                    }
                }else{
                    Loguear('2012-05-14',"variable_habilitada",false,false,true);
                    ////// VALIDA EL VALOR
                    $salteando_hasta=false;
                    /// VOY POR ACÁ
                    if(!@$def_var_actual->la_anterior_es_multiple){
                        $la_anterior_esta_ingresada_o_es_optativa_blanca=$esta_esta_ingresada;
                    }
                    if($valor===null){
                        Loguear('2012-05-14',"/////////// VARIABLE NO INGRESADA",false,false,true);
                        /////////// VARIABLE NO INGRESADA
                        if(!$primer_null_de_la_serie){
                            $primer_null_de_la_serie=$var_actual;
                        }
                        if(!@$def_var_actual->la_anterior_es_multiple){
                            $esta_esta_ingresada=false;
                        }
                        if($la_anterior_esta_ingresada_o_es_optativa_blanca){
                            $primer_blanco=$primer_blanco||$var_actual;
                            $this->estados_rta_ud[$var_actual]=$this->estados_rta->blanco;
                            if(@$def_var_actual->optativa){
                                $esta_esta_ingresada=true;
                            }
                        }else{
                            $this->estados_rta_ud[$var_actual]=$this->estados_rta->todavia_no;
                        }
                    }else{
                        Loguear('2012-05-14',"// si estoy acá es porque el valor no es nulo",false,false,true);
                        // si estoy acá es porque el valor no es nulo
                        $esta_esta_ingresada=true;
                        $ultima_variable_con_valor=$cantidad_de_variables_al_momento;
                        if(!$la_anterior_esta_ingresada_o_es_optativa_blanca){
                            Loguear('2012-05-14',"!la_anterior_esta_ingresada_o_es_optativa_blanca",false,false,true);
                            $ya_vi_algun_null_erroneo=true;	
                            if(!$variable_omitida){
                                $variable_omitida=$primer_null_de_la_serie;
                            }
                        }
                        Loguear('2012-05-14',"primer_null_de_la_serie null ($valor)",false,false,true,true);
                        Loguear('2012-05-14','$valor==@$def_var_actual->nsnc='.($valor==@$def_var_actual->nsnc),false,false,true,true);
                        Loguear('2012-05-14','$valor==-1 || strtolower($valor)==sin especificar='.($valor==-1 || strtolower($valor)=='sin especificar'),false,false,true,true);
                        Loguear('2012-05-14','$opciones===null='.($opciones===null),false,false,true,true);
                        Loguear('2012-05-14','@$def_var_actual->almacenar?$valor!=@$def_var_actual->almacenar:@$opciones[$valor]==null='.(((@$def_var_actual->almacenar)?($valor!=@$def_var_actual->almacenar):(@$opciones->{$valor}===null))),false,false,true,true);
                        //Loguear('2012-05-14','='.(),false,false,true,true);
                        //Loguear('2012-05-14','='.(),false,false,true,true);
                        $primer_null_de_la_serie=null;
                        /////////// VARIABLES CON VALORES ESPECIALES
                        Loguear('2012-05-16',"%%%%%%%% $var_actual=$valor ".json_encode($def_var_actual)." null:".($opciones===null)." isset:".isset($opciones),false,false,true);
                        if(isset($def_var_actual->nsnc) && $valor==$def_var_actual->nsnc){
                            Loguear('2012-05-14',"def_var_actual->nsnc",false,false,true,true);
                            $this->estados_rta_ud[$var_actual]=$this->estados_rta->nsnc;
                            Loguear('2012-05-14',"def_var_actual->nsnc marcado",false,false,true,true);
                        }else if($valor==-1 || strtolower($valor)=='sin especificar'){
                            Loguear('2012-05-14',"sin especificar",false,false,true,true);
                            $this->estados_rta_ud[$var_actual]=$this->estados_rta->sinesp;
                        /////////// VARIABLES SIN OPCIONES
                        }else if($opciones===null){ // decía undefined
                            Loguear('2012-05-14',"/////////// VARIABLES SIN OPCIONES",false,false,true);
                            if(@$def_var_actual->es_numerico){
                                if(!is_numeric($valor)){
                                    $this->estados_rta_ud[$var_actual]=$this->estados_rta->error_tipo;
                                }else{
                                    $valor=$valor+0;
                                    Loguear('2012-05-16',@($valor<$def_var_actual->minimo)." || ".@($valor>$def_var_actual->maximo),false,false,true);
                                    if(isset($def_var_actual->minimo) && ($valor<$def_var_actual->minimo) || isset($def_var_actual->maximo) && ($valor>$def_var_actual->maximo)){
                                        $this->estados_rta_ud[$var_actual]=$this->estados_rta->fuera_de_rango_obligatorio;
                                    }else if(isset($def_var_actual->advertencia_inf) && ($valor<$def_var_actual->advertencia_inf) || isset($def_var_actual->advertencia_sup) && ($valor>$def_var_actual->advertencia_sup)){
                                        $this->estados_rta_ud[$var_actual]=$this->estados_rta->fuera_de_rango_advertencia;
                                    }else{
                                        $this->estados_rta_ud[$var_actual]=$this->estados_rta->ok;
                                    }
                                }
                            }else{
                                $this->estados_rta_ud[$var_actual]=$this->estados_rta->ok;
                            }
                            $salteando_hasta=@$def_var_actual->salta;
                        /////////// VARIABLES CON OPCIONES
                        }else if(@$def_var_actual->almacenar?$valor!=@$def_var_actual->almacenar:@$opciones->{$valor}===null){
                            $this->estados_rta_ud[$var_actual]=$this->estados_rta->opcion_inexistente;
                            //// Si es una múltiple marcar y el valor es incorrecto se puede intentar salvar
                            if(@$def_var_actual->almacenar && ($valor!=1)){
                                //// Si existiera la variable sería la misma que la actual pero reemplazando la última parte por el valor ingresado:
                                $otra_variable_multiple_marcar=preg_replace("/[^_]*$/",$valor,$var_actual);
                                //// Veo si existe:
                                if(isset($this->preguntas_ud->{$otra_variable_multiple_marcar})){
                                    //// si existe hago la transformación (o sea el pase del valor de una variable a la otra). 
                                    /*  EN PHP NO: 
                                    rta_ud[otra_variable_multiple_marcar]=$def_var_actual->almacenar;
                                    rta_ud[$var_actual]=null;
                                    */
                                    //// cambio el id_variable_cursor_actual para mover el cursor en función de la transformación que acabo de hacer
                                    $id_variable_cursor_actual=$otra_variable_multiple_marcar;
                                    $primer_blanco=$primer_blanco||$var_actual;
                                    $this->estados_rta_ud[$var_actual]=$this->estados_rta->blanco;
                                    $this->estados_rta_ud[otra_variable_multiple_marcar]=$this->estados_rta->ok;
                                }
                            }
                        }else{
                            // Loguear('2012-05-20',"/////////// ESTAS SON LAS OK $valor,".json_encode($opciones).';'.json_encode($def_var_actual),false,false,true);
                            $this->estados_rta_ud[$var_actual]=$this->estados_rta->ok;
                            $parte_del_salteando=@$opciones->{$valor}?:@$opciones->{$def_var_actual->marcar}?:(object)array();
                            $salteando_hasta=@$parte_del_salteando->salta ?: @$def_var_actual->salta;
                        }
                        if($valor==='//' && $def_var_actual->salta_nsnc){
                            $salteando_hasta=$def_var_actual->salta_nsnc;
                        }
                    }
                }
            }
            if($variable_habilitada /* || valor OJO:Poner esto cuando se quiera que el ENTER PARE en las "sosa" */){
                $var_anterior_habilitada=$var_actual;
            }
        }
        $cantidad_de_variables_al_momento=0;
        foreach($this->preguntas_ud as $var_actual=>$def_var_actual){
            $cantidad_de_variables_al_momento++;
            if(@$def_var_actual->consistir){
                foreach($def_var_actual->consistir as $id_cons=>$consistencia){
                    $inconsistente=false;
                    //try{
                        if($ultima_variable_con_valor >= $cantidad_de_variables_al_momento || $var_actual == $id_variable_cursor_actual){
                            $inconsistente=eval($this->hacer_expresion_evaluable($consistencia->expr));
                        }
                    //}catch(err){
                        // aca hay que registrar las consistencias que no corren en JS.
                    //}
                }
            }
        }
        if($ya_vi_algun_null_erroneo){
            $this->Marcar_Posteriores_Al_Omitidos($variable_omitida);
        }
        // $estados_intermedios->{$variable_omitida}=$variable_omitida;
        return $salteando_hasta=='fin'?'boton_fin':($id_variable_cursor_actual?$proxima_variable:$primer_blanco);
    }
    function inicializar_para_responder(){
        $this->tabla_respuestas=$this->nuevo_objeto('Tabla_respuestas');
        $lineas=file_get_contents("estructura_{$GLOBALS['nombre_app']}.js");
        $lineas=str_replace(array("var estructura=",";//fin"),array('',''),$lineas);
        $this->estructura=json_decode($lineas);
        $this->estados_rta=json_decode(<<<JSON
{ "ok":"opc_ok"
, "opcion_inexistente":"opc_inex" 
, "ingreso_sobre_salto":"opc_sosa"
, "salteada":"opc_salt" 
, "blanco":"opc_blanco" 
, "todavia_no":"opc_tono" 
, "omitido":"opc_omit" 
, "hay_omitidas":"opc_homi" 
, "fuera_de_rango_obligatorio":"opc_rano"
, "fuera_de_rango_advertencia":"opc_rana"
, "error_tipo":"opc_tipo" 
, "nsnc":"opc_nsnc" 
, "sinesp":"opc_sinesp" 
, "inconsistente":"opc_inconsistente" 
}
JSON
        );
    }
    function responder_campos_voy_por(){
        return nombres_campos_claves('res_');
    }
    function responder_iniciar_estado(){
        $this->estado->errores="";
        $this->estado->oks=0;
        $this->estado->encuestas_ok=0;
        $this->estado->diferencias_grabadas=0;
        $this->estado->nulos_grabados=0;
    }
    function responder_iniciar_iteraciones(){
        $this->inicializar_para_responder();
        $and_solo_para_controlar=($this->argumentos->tra_grabando?"":"AND res_estado is null");
        $filtro=cambiar_prefijo($this->argumentos,'tra_','res_');
        unset($filtro->res_grabando);
        foreach($filtro as $campo=>$valor){
            if(!$valor){
                unset($filtro->{$campo});
            }
        }
        $f=$this->nuevo_objeto("Filtro_Normal",$filtro,$this->tabla_respuestas);
        if(isset($this->voy_por)){
            $f=new Filtro_AND(array($f,new Filtro_Voy_Por($this->voy_por)),$this->tabla_respuestas);
        }
        $this->cursor=$this->db->ejecutar_sql(new Sql(
            "SELECT DISTINCT ".implode(', ',nombres_campos_claves('res_'))." FROM respuestas ".
            " WHERE ".$f->where." $and_solo_para_controlar ".
            " ORDER BY ".implode(', ',$this->responder_campos_voy_por()),
            $f->parametros
        ));
    }
    function responder_hay_mas(){
        if($this->estado->errores){
            return false;
        }
        $this->voy_por=$this->cursor->fetchObject();
        return !!$this->voy_por;
    }
    function responder_un_paso(){
        $encuesta=$this->voy_por;
        Loguear('2012-05-20',json_encode($encuesta),false,false,true);
        $this->colorear($encuesta,null);
        if(isset($this->estados_rta_ud)){
            foreach($this->estados_rta_ud as $variable=>$estado){
                $this->pk_respuesta['res_var']=quitar_prefijo($variable,'var_');
                if(!@$this->preguntas_ud->{$variable}->no_es_variable){
                    $this->tabla_respuestas->leer_unico($this->pk_respuesta);
                    if($this->tabla_respuestas->datos->res_estado!==$estado){
                        if($this->argumentos->tra_grabando){
                            if($this->tabla_respuestas->datos->res_estado){
                                $this->estado->diferencias_grabadas++;
                            }else{
                                $this->estado->nulos_grabados++;
                            }
                            $this->tabla_respuestas->valores_para_update=array('res_estado'=>$estado);
                            $this->tabla_respuestas->ejecutar_update_unico($this->tabla_respuestas->datos);
                        }else{
                            $this->estado->errores.="$variable=$estado<>{$this->tabla_respuestas->datos->res_estado} ({$this->tabla_respuestas->datos->res_valor}), ";
                        }
                    }else{
                        $this->estado->oks++;
                    }
                }
            }
        }
        if(!$this->estado->errores){
            $this->estado->encuestas_ok++;
        }
    }
    function responder_finalizar(){
        if($this->estado->errores){
            $this->estado->errores.=json_encode($this->argumentos);
            $this->estado->errores.=json_encode($this->pk_respuesta);
            return new Respuesta_Negativa("Problemas al colorear: {$this->estado->errores}");
        }else{
            // return new Respuesta_Positiva("esta");
            return new Respuesta_Positiva("{$this->estado->oks} respuestas y {$this->estado->encuestas_ok} encuestas coloreados ok (estados actualizados: {$this->estado->diferencias_grabadas} diferentes, {$this->estado->nulos_grabados} nulos)");
        }
    }    
}

function funcion_o($result, $item) {
    return $result || $item==1;
}

function al_menos_uno_lleno_con_dato_uno($arreglo_de_valores){
    return array_reduce($arreglo_de_valores,"funcion_o");
}
?>