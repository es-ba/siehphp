<?php
//UTF-8:SÍ
/* -------------------------------------

Los parámetros con nombre (referidos a las funciones) permiten 
llamar a la función pasando los parámetros en cualquier orden. 
Además simplifica el pasaje de parámetros cuando los parámetros
son opcionales (porque si el pasaje de parámetros es posicional
solo se pueden omitir los últimos y no uno del medio). 

Otros lenguajes (OCaml, VisualBasic, la última versión de C#, 
Ruby y otros) tienen esto. En los foros de PHP dan como idea
pasar los parámetros a través de un arreglo asociativo. 

Por ejemplo: 

function f($parametro1, $parametros2, $array_de_param_optativos){
...
}

que se invocaría así:

f(1,2,array('param_opt1'=>3, 'param_opt4'=>4));

el inconveniente de esta solución es que no queda claro leyendo
la descripción de la función de cuáles so los parámetros optativos
válidos, y, lo que es peor, que si se pasa un parámetro inválido
el programa no se da cuenta (o sea si se comete un error de tipeo
en el nombre eso puede ocasionar problemas difíciles de detectar). 

Para eso vamos a validar los parámetros optativos en el primer
renglón de la función llamando a una función específica llamada
controlar_parametros. 

La función controlar_parametros verificará que el parámetro pasado
sea un parámetro válido, en el caso de que el parámetro no esté 
especificado puede especificar un valor por defecto y hacer 
algún control de tipos. 

Ejemplo:

function f($parametro1, $parametros2, $array_de_param_optativos){
  controlar_parametros($array_de_param_optativos,
    array('param_opt1'=>array('def'=>0, 'validar'=>'is_numeric'),
          'param_opt2'=>true, 
         );
...
}

controlar_parametros recie el array a controlar y el array
con los nombres de los parámetros optativos válidos y 
su valor por defecto o un arreglo con la definción del parámetro
esa definición es
    def => valor por defecto
    validar => nombre de una función usada para validar
    
la función coloca en el arreglo de parámetros los valores por defecto
y si hay un parámetro inválido lanza una excepción

Exception_Parametro_con_nombre_inexistente o 
Exception_Parametro_con_nombre_invalido

*/
require_once "probador.php";

class Exception_Parametro_con_nombre_inexistente extends Exception{};
class Exception_Parametro_con_nombre_invalido extends Exception{};

function validar_un_parametro(&$parametros_recibidos_en_la_funcion, $param, $valor){
    if(is_array($valor) && isset($valor['validar']) && isset($parametros_recibidos_en_la_funcion[$param])){
        $opciones_de_validacion=$valor['validar'];
        if(is_array($opciones_de_validacion)){
            $funcion_validadora=@$opciones_de_validacion['funcion'];
            if($opciones_de_validacion['instanceof'] && !is_a($parametros_recibidos_en_la_funcion[$param],$opciones_de_validacion['instanceof'])){
                throw new Exception_Parametro_con_nombre_invalido(
                    /* (@$parametros_recibidos_en_la_funcion[$param]?:"").*/" es ".
                    (@get_class($parametros_recibidos_en_la_funcion[$param])?:gettype($parametros_recibidos_en_la_funcion[$param])).
                    ", no es  ".$opciones_de_validacion['instanceof']);
            }
        }else{
            $funcion_validadora=$opciones_de_validacion;
        }
        if($funcion_validadora && !$funcion_validadora($parametros_recibidos_en_la_funcion[$param])){
            throw new Exception_Parametro_con_nombre_invalido($param." no cumple ".$funcion_validadora);
        }
    }
    if(is_array($valor) && isset($valor['opciones']) && isset($parametros_recibidos_en_la_funcion[$param])){
        $opciones_posibles=$valor['opciones'];
        if(is_array($opciones_posibles)){
            if(!in_array($parametros_recibidos_en_la_funcion[$param],$opciones_posibles)){
                throw new Exception_Parametro_con_nombre_invalido(
                    "$param es ".$parametros_recibidos_en_la_funcion[$param].
                    ", no es ninguno de: (".implode(', ',$opciones_posibles).")");
            }
        }else{
            throw new Exception_Parametro_con_nombre_invalido("las opciones de ".$param." deben ser un arreglo");
        }
    }
    if(!is_array($parametros_recibidos_en_la_funcion)){
        throw new Exception_Tedede("en validar_un_parametro se esparaba una definicion en forma de arreglo, no ".json_encode($parametros_recibidos_en_la_funcion));
    }
    if(!array_key_exists($param,$parametros_recibidos_en_la_funcion)){
        $valor_por_defecto=is_array($valor)?@$valor['def']:$valor;
        $parametros_recibidos_en_la_funcion[$param]=$valor_por_defecto;
    }
}

function controlar_parametros(&$parametros_recibidos_en_la_funcion, $definicion_de_parametros_validos,$puede_haber_otros=false){
    if(!isset($parametros_recibidos_en_la_funcion)){
        $parametros_recibidos_en_la_funcion=array();
    }elseif($parametros_recibidos_en_la_funcion instanceof StdClass){
        $parametros_recibidos_en_la_funcion=(array)$parametros_recibidos_en_la_funcion;
    }
    if(is_string($parametros_recibidos_en_la_funcion)){
        $unico_parametro=$parametros_recibidos_en_la_funcion;
        $parametros_recibidos_en_la_funcion=array();
        $paso_un_string_en_vez_de_un_array=true;
    }else{
        $paso_un_string_en_vez_de_un_array=false;
    }
    foreach($definicion_de_parametros_validos as $param=>$valor){
        if($paso_un_string_en_vez_de_un_array && @$valor['def_unico']){
            $parametros_recibidos_en_la_funcion[$param]=$unico_parametro;
        }
        validar_un_parametro($parametros_recibidos_en_la_funcion, $param, $valor);
    }
    if(!$puede_haber_otros){
        foreach($parametros_recibidos_en_la_funcion as $param=>$valor){
            if(!array_key_exists($param,$definicion_de_parametros_validos)){
                throw new Exception_Parametro_con_nombre_inexistente("parametro con nombre inexistente: ".$param);
            }
        }
    }
    $parametros_recibidos_en_la_funcion=(object)$parametros_recibidos_en_la_funcion;
}

function extraer_y_quitar_parametro(&$parametros_recibidos_en_la_funcion, $nombre_parametro, $definicion_parametro_a_extraer){
    validar_un_parametro($parametros_recibidos_en_la_funcion, $nombre_parametro, $definicion_parametro_a_extraer);
    $retornar=$parametros_recibidos_en_la_funcion[$nombre_parametro];
    unset($parametros_recibidos_en_la_funcion[$nombre_parametro]);
    return $retornar;
}

function funcion_ejemplo_es_par($numero){
    if($numero==5){
        return false;
    }
    return true;
}

class Pruebas_parametros_con_nombre extends Pruebas{
    function probar_que_sean_validos(){
        $la_funcion_recibe_como_parametros=array('p1'=>1, 'p2'=>2, 'p3'=>3);
        $esperado=$la_funcion_recibe_como_parametros; // los valores antes de controlar
        controlar_parametros($la_funcion_recibe_como_parametros,
            array('p1'=>true, // estos tres son los parámetros válidos
                  'p2'=>false, // p2 tiene como valor por defecto false
                  'p3'=>null   // p3 tiene como valor por defecto null
                  )
        );
        // comparo que después de controlar los parámetros no hayan cambiado.
        $this->probador->verificar_arreglo_asociativo($esperado,(array)$la_funcion_recibe_como_parametros);
    }
    function probar_que_ponga_valores_por_defecto(){
        $la_funcion_recibe_como_parametros=array('p1'=>1, 'p2'=>2, 'p3'=>3);
        controlar_parametros($la_funcion_recibe_como_parametros,
            array('p1'=>true, 
                  'p1b'=>true,
                  'p2'=>false,
                  'p2c'=>false, 
                  'p3'=>null,   
                  'p3c'=>null,
                  'p4'=>7,
                  'p5'=>'hola',
                  'p6'=>array('def'=>8)
                  )
        );
        $esperado=array(
                  'p1'=>1, 
                  'p1b'=>true,
                  'p2'=>2,
                  'p2c'=>false, 
                  'p3'=>3,   
                  'p3c'=>null,
                  'p4'=>7,
                  'p5'=>'hola',
                  'p6'=>8
        );
        $this->probador->verificar_arreglo_asociativo($esperado,(array)$la_funcion_recibe_como_parametros);
        // No da excepción porque todos los parámetros son válidos
    }
    function probar_que_falle_con_parametro_inexistente(){
        try{
            $la_funcion_recibe_como_parametros=array('p1'=>1, 'p2'=>2);
            controlar_parametros($la_funcion_recibe_como_parametros,
                array('p1'=>true, 'p3'=>true)
            );
            $this->probador->informar_error('controlar_parametros debió lanzar la excepción Exception_Parametro_con_nombre_inexistente porque p2 es inexistente');
        }catch(Exception_Parametro_con_nombre_inexistente $e){
            // ok controlar_parametros lanzó la excepción que yo esperaba porque p2 era inexistente
        }
    }
    function probar_que_falle_con_parametro_invalido(){
        try{
            $la_funcion_recibe_como_parametros=array('p1'=>1, 'p2'=>5);
            controlar_parametros($la_funcion_recibe_como_parametros,
                array('p1'=>true
                    , 'p2'=>array('def'=>0, 'validar'=>'funcion_ejemplo_es_par')
                      )
            );
            $this->probador->informar_error('controlar_parametros debió lanzar la excepción Exception_Parametro_con_nombre_invalido porque p2 es inválido');
        }catch(Exception_Parametro_con_nombre_invalido $e){
            // ok controlar_parametros lanzó la excepción que yo esperaba porque p2 era inválido
        }
    }
    function probar_extraccion_de_valor_con_def_0(){
        $definicion=array('tipo'=>'tres','def'=>'0','def2'=>0,'otra_cosa'=>true);
        $cero=extraer_y_quitar_parametro($definicion,'def','x');
        $this->probador->verificar('0',$cero);
        $this->probador->verificar_via_json(array('tipo'=>'tres','def2'=>0,'otra_cosa'=>true),$definicion);
        $cero=extraer_y_quitar_parametro($definicion,'def2','x');
        $this->probador->verificar(0,$cero);
        $this->probador->verificar_via_json(array('tipo'=>'tres','otra_cosa'=>true),$definicion);
    }
}

?>