<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";

global $claves, $tipos_claves,$leyendas_claves,$implode_nombres_campos_claves;

$claves=array('ope','for','mat','enc','hog','mie','exm'
        // AGREGAR A MANO UNA CAMPO NUEVO EN LA pk DE RESPUESTAS
);
$tipos_claves=array('ope'=>'T','for'=>'T','mat'=>'T','enc'=>'N','hog'=>'N','mie'=>'N','exm'=>'N'
        // AGREGAR A MANO UNA CAMPO NUEVO EN LA pk DE RESPUESTAS
);

$leyendas_claves=array('ope'=>'Operativo','for'=>'Formulario','mat'=>'Matriz','enc'=>'Encuesta','hog'=>'Hogar','mie'=>'Miembro','exm'=>'M.'
        // AGREGAR A MANO UNA CAMPO NUEVO EN LA pk DE RESPUESTAS
);

function claves_respuesta_vacia($prefijo="tra_"){
global $claves, $tipos_claves;
    $rta=array();
    foreach($tipos_claves as $clave=>$tipo){
        $rta[$prefijo.$clave]=$tipo=='T'?'':0;
    }
    return $rta;
}

function nombres_campos_claves($plantilla="tra_",$filro_tipo="todos",$sufijo="",$numerar_desde=1){
global $claves, $tipos_claves;
    $excluir=array();
    if($filro_tipo=='N~enc'){
        $filro_tipo="N";
        $excluir['enc']=true;
    }
    $rta=array();
    if(strpos($plantilla,'@')===false && strpos($plantilla,'#')===false){
        $plantilla.='@'.$sufijo;
    }else{
        $plantilla.=$sufijo;
    }
    $posicion=$numerar_desde;
    foreach($tipos_claves as $clave=>$tipo){
        if(($filro_tipo=='todos' || $filro_tipo==$tipo) && !isset($excluir[$clave])){
            $rta[]=str_replace(array('@','#'),array($clave, $posicion),$plantilla);
            $posicion++;
        }
    }
    return $rta;
}

global $cache;

$cache=array();

function implode_nombres_campos_claves($plantilla="tra_",$filro_tipo="todos",$sufijo="",$numerar_desde=1){
    global $cache;
    if(!($valor=@$cache['nombres_campos_claves'][$plantilla][$filro_tipo][$sufijo][$numerar_desde])){
        $valor=implode('',nombres_campos_claves($plantilla,$filro_tipo,$sufijo,$numerar_desde));
        $cache['nombres_campos_claves'][$plantilla][$filro_tipo][$sufijo][$numerar_desde]=$valor;
    }
    return $valor;
}

$implode_nombres_campos_claves="implode_nombres_campos_claves";

/*
class Armador_de_Pks_encuestas
{
    // function __get($value)
    // {
    //     global $baseDatos;
    //     return $baseDatos->Escapar_String($value);
    // }
    // function __method
}
$pkenc = new Armador_de_Pks_encuestas;

<<<EJEMPLO

{$pkenc->algo()}

EJEMPLO
*/
?>