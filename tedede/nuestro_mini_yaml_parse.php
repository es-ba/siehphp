<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "comunes.php";
require_once "probador.php";

function mini_yaml_parse($yaml){
    $arreglo_de_lineas_yaml=explode("\n",$yaml);
    return mini_yaml_parse_lineas($arreglo_de_lineas_yaml);
}

function mini_yaml_parse_lineas_dentro_de_arreglo($arreglo_de_lineas_yaml_arreglo,$nivel_margen,$num_linea_inicial){
    $num_linea=$num_linea_inicial;
    $arr=array();
    $tercerizar=array();
    $primera_linea=true;
    foreach($arreglo_de_lineas_yaml_arreglo as $linea){
        $num_linea++;
        $tengo_guion=substr($linea,$nivel_margen,1)=='-';
        if($primera_linea){
            if(!$tengo_guion){
                throw new Exception_Tedede("Falta un guion en mini_yaml_parse_lineas_dentro_de_arreglo en la primera linea del arreglo");
            }else{
                $primera_linea=false;
            }
        }else{
            if($tengo_guion){
                $arr[]=mini_yaml_parse_lineas($tercerizar,$nivel_margen+2,$num_linea_inicial);
                $num_linea_inicial=$num_linea;
                $tercerizar=array();
            }
        }
        $tercerizar[]=$linea;
    }
    $arr[]=mini_yaml_parse_lineas($tercerizar,$nivel_margen+2,$num_linea_inicial);
    return $arr;
}

function mini_yaml_parse_lineas($arreglo_de_lineas_yaml,$nivel_margen=0,$num_linea_inicial=0){
    // Loguear('2012-01-17','----------');
    $arr=array();
    $num_linea=$num_linea_inicial;
    $tercerizando=false;
    $vi_esta_clave=array();
    foreach($arreglo_de_lineas_yaml as $linea){
        $donde_dos_puntos=strpos($linea,':');
        $num_linea++;
        $que_hay_hasta_mi_nivel_de_margen=trim(substr($linea,0,$nivel_margen+1));
        if($que_hay_hasta_mi_nivel_de_margen!='' and $que_hay_hasta_mi_nivel_de_margen!='-'){
            // estoy dentro de mi nivel
            if($tercerizando){
                $arr[$clave]=mini_yaml_parse_lineas_dentro_de_arreglo($tercerizar,$nivel_margen,$num_linea_tercerizando);
            }
            if($donde_dos_puntos>0){
                $clave=trim(substr($linea,$nivel_margen,$donde_dos_puntos-$nivel_margen));
                $resto=trim(substr($linea,$donde_dos_puntos+1));
                if(@$vi_esta_clave[$clave]){
                    throw new Exception_Tedede("Clave duplicada '$clave' en linea $num_linea:$resto");
                }else{
                    $vi_esta_clave[$clave]=true;
                }
                if($resto || $resto==='0'){
                    if($resto=="''"){
                        $resto='';
                    }
                    $arr[$clave]=$resto;
                }else{
                    $tercerizando=true;
                    $num_linea_tercerizando=$num_linea;
                    $tercerizar=array();
                    // $arr[$clave]=mini_yaml_parse_lineas_arreglo($arreglo_de_lineas_yaml);
                }
            }else{
                throw new Exception_Tedede("error al mini_yaml_parse_lineas en la linea $num_linea, no encontre los :");
            }
        }else{
            if(!$tercerizando){
                throw new Exception_Tedede("error al mini_yaml_parse_lineas en la linea $num_linea, encontre una linea con margen incorrecto: [$linea]");
            }
            $tercerizar[]=$linea;
        }
    }
    if($tercerizando){
        $arr[$clave]=mini_yaml_parse_lineas_dentro_de_arreglo($tercerizar,$nivel_margen,$num_linea_tercerizando);
    }
    return $arr;
}

class Probar_mini_yaml_parse extends Pruebas{
    function probar_simple(){
        $entrada=<<<YAML
uno: 1
dos:2
tres:3
YAML;
        $obtenido=mini_yaml_parse($entrada);
        $this->probador->verificar_via_json(array('uno'=>'1', 'dos'=>'2', 'tres'=> '3'),$obtenido);
    }    
    function probar_estructurado(){
        $entrada=<<<YAML
uno:
- uu:1.1
  dd:2.2
  otro:
  - ud:1.2
    du:2.1
  - ut:1.3
- tt:3.3
YAML;
        $obtenido=mini_yaml_parse($entrada);
        $this->probador->verificar_via_json(
            array('uno'=>array(
                array(
                    'uu'=>'1.1', 
                    'dd'=>'2.2', 
                    'otro'=>array(
                        array(
                            'ud'=>'1.2', 
                            'du'=>'2.1'
                        ),array(
                            'ut'=> '1.3'
                        )
                    )
                ),
                array(
                    'tt'=>'3.3'
                )
            )),
            $obtenido
        );
    }    
}


?>