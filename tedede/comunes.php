<?php
//UTF-8:SÍ
//$timestamp_del_log_anterior=time();
//global $timestamp_del_log_anterior;
$timestamp_del_log_anterior=array();

function contenido_interno_a_string($cualquier_variable,$modo=true,$profundidad=0){
    $max_profundidad=5;
    if(is_a($cualquier_variable,"DateTime")){
        return $cualquier_variable->format('y-m-d H:i:s');
    }else if($cualquier_variable instanceof Tabla){
        $tabla=$cualquier_variable;
        unset($cualquier_variable);
        $cualquier_variable['es una tabla']=get_class($tabla);
        foreach(array('datos','valores_para_insert','valores_para_update') as $que_ver){
            if(isset($tabla->{$que_ver})){
                $cualquier_variable[$que_ver]=$tabla->{$que_ver};
            }
        }
        return "[".get_class($tabla)."]=".contenido_interno_a_string($cualquier_variable,$modo,$profundidad);
    }else if(is_string($cualquier_variable)){
        return json_encode($cualquier_variable);
    }else if(is_array($cualquier_variable) || is_object($cualquier_variable)){
        if(is_array($cualquier_variable)){
            $rta="ARRAY ";
        }else{
            $rta="[".get_class($cualquier_variable)."] ";
        }
        if($profundidad<$max_profundidad){
            foreach((array)$cualquier_variable as $campo=>$valor){
                $rta.="\n".str_repeat('  ',$profundidad).$campo.':'.contenido_interno_a_string($valor,$modo,$profundidad+1);
            }
            // $rta.="\n";
        }
    }else{
        return substr(json_encode($cualquier_variable),0,100);
    }
    return $rta;
}

function is_array_o_stdclass(&$valor){
    if($valor instanceof stdClass){
        $valor=(array)$valor;
        return true;
    }else{
        return is_array($valor);
    }
}

function aplanar_trace($que_trace,$exceptuando=false,$limite=false){
    // Devuelve un string con líneas con lo que entendemos nos sirve para debuguear. 
    $str="";
    $primero=TRUE;
    $renglon=0;
    foreach($que_trace as $llamada){
      if(($exceptuando===false 
          || $exceptuando!==true 
             && (is_string($exceptuando) && @$llamada['file']!=$exceptuando
                || is_array($exceptuando) && !in_array($exceptuando,@$llamada['file'])
                || is_numeric($exceptuando) && $renglon<$exceptuando
                )
          )
      )
      {
        $renglon++;
        $str.="  linea ".@$llamada['line']." de archivo ".@$llamada['file']."\n";
        if(!$primero){
          $str.="    {$llamada['function']}(";
          $coma='';
          if(@$llamada['args']){
            foreach($llamada['args'] as $arg){
              $str.="{$coma}".contenido_interno_a_string($arg,FALSE);
              $coma=',';
            }
          }
          $str.=");\n";
        }
        $primero=FALSE;
      }
    }
    global $loguear_ultimos_debug_trace;
    if($loguear_ultimos_debug_trace){
        $separador="\n\n\n";
        $arch_log="../logs/ultimo_debug_grace.txt";
        $lineas_anteriores='';
        if($loguear_ultimos_debug_trace>1){
            if(file_exists($arch_log)){
                $lineas=file_get_contents($arch_log);
                $lineas_anteriores=implode($separador,array_slice(explode($separador,$lineas),-$loguear_ultimos_debug_trace)).$separador;
            }
        }
        file_put_contents($arch_log,$lineas_anteriores.$str);
    }
    return $str;
}

function Loguear($hasta_fecha, $mensaje, $archivo="../logs/log.txt", $exceptuando=false, $sin_debug_trace=false){
global $hoy,$timestamp_del_log_anterior;
  if(!$archivo){
    $archivo="../logs/log.txt";
  }
  if(is_string($hasta_fecha)){
    $hasta_fecha=new DateTime($hasta_fecha);
  }
  if($hasta_fecha instanceof DateTime && ($hoy<=$hasta_fecha)){
    $str="";
    $str.="-->: ".date("d/m/Y, h:i:s")." ".@$_SESSION["usuario_logueado"];
    if(@$timestamp_del_log_anterior[$archivo]){
        $str.=" DEMORO:".round((microtime(TRUE)-$timestamp_del_log_anterior[$archivo]),3)."s  ";
        // ./*'obtenido de './*(time().' - '.$timestamp_del_log_anterior).*/ ;
    }
    $timestamp_del_log_anterior[$archivo]=microtime(TRUE);
    if($sin_debug_trace!==true){
        $str.="\n";
        $str.=aplanar_trace(debug_backtrace(),$exceptuando,$sin_debug_trace);
    }
    $str.=$mensaje."\n";
    file_put_contents($archivo,$str,FILE_APPEND);
  }
}

function Para_Eval($expresion){
  if(strpos($expresion,'return')===false){
    return "return ".$expresion.';';
  }
  return $expresion;
}


function Hace($cuantos,$medida){
    if($cuantos==0){
      return false;
    }else if($cuantos==1){ 
      return "hace 1 ".$medida;
    }else{ 
      return "hace ".$cuantos." ".$medida."s";
    }
}   

function DiaDeLaSemana($cual){
  if($cual==1){ return "lunes"; } else
  if($cual==2){ return "martes"; } else
  if($cual==3){ return "miércoles"; } else
  if($cual==4){ return "jueves"; } else
  if($cual==5){ return "viernes"; } else
  if($cual==6){ return "sábado"; } else
  if($cual==7){ return "domingo"; }
}

function GetDeltaTime($dtTime1, $dtTime2, $divisor)
{
  $nUXDate1 = strtotime($dtTime1->format("Y-m-d H:i:s"));
  $nUXDate2 = strtotime($dtTime2->format("Y-m-d H:i:s"));

  $nUXDelta = $nUXDate1 - $nUXDate2;
  return floor($nUXDelta/$divisor);
}

function FechaElegante($fecha,$con_adornos=TRUE){
  if(!trim($fecha)){
    return "";
  }
  $dt=new DateTime($fecha);
  // $dt->setTimezone(new DateTimeZone("America/Buenos_Aires"));
  $ahora=new DateTime();
  // $ahora->setTimezone(new DateTimeZone("America/Buenos_Aires"));
  $rta="";
  if(!$con_adornos){
    $rta=$dt->format('d/m/Y');
  }else if($dt->format('Y-m-d')==$ahora->format('Y-m-d')){
    $rta="<small>hoy</small> ".$dt->format('d/m');
  }else if($dt->format('Y-m')==$ahora->format('Y-m')){
    $rta="<small>".substr(DiaDeLaSemana($dt->format('N')),0,3)."</small> ".$dt->format('d/m');
  }else if($dt->format('Y')==$ahora->format('Y')){
    $rta=$dt->format('d/m');
  }else{
    $rta=$dt->format('d/m')."<small>/".$dt->format('Y')."</small>";
  }
  // $alt=$dt->format('d/m/Y H:i:s');
  // return "<a href='$href' alt='$alt' title='$alt'>$rta</a>";
  return $rta;
}

function ParsearCualquierFecha($frase){
  $ahora=new DateTime();
  if(preg_match('@(\D)*(?P<dia>\d+)[-./ ]+(?P<mes>\d+)([-./ ]+(?P<anno>\d+))?@', $frase, $matches)){
      $anno=Arreglo($matches,'anno',$ahora->format('Y'));
      if($anno<50){
        $anno+=2000;
      }else if($anno<100){
        $anno+=1900;
      }
      $ahora->setDate($anno,$matches['mes'],$matches['dia']);
  }else{
    $frase=trim(strtolower($frase));
    if($frase=='hoy'){
    }else{
        return "";
    }
  }
  return $ahora->format('Y-m-d'); ;
}

function Probar_ParsearCualquierFecha(){
    $ahora=new DateTime();
    $anno=$ahora->format('Y');
    Probar(__LINE__, "","FechaElegante('',FALSE)");
    Probar(__LINE__, "01/02/2003","FechaElegante(ParsearCualquierFecha('1/2/2003'),FALSE)");
    Probar(__LINE__, "01/02/$anno","FechaElegante(ParsearCualquierFecha('1/2'),FALSE)");
    Probar(__LINE__, "31/12/2009","FechaElegante(ParsearCualquierFecha('31-12-2009'),FALSE)");
    Probar(__LINE__, "01/04/2009","FechaElegante(ParsearCualquierFecha('lunes 1-4/9'),FALSE)");
    Probar(__LINE__, FechaElegante($ahora->format('Y-m-d'),FALSE),"FechaElegante(ParsearCualquierFecha('Hoy'),FALSE)");
    Probar(__LINE__, "","FechaElegante(ParsearCualquierFecha('otra cosa'),FALSE)");
    
}

function MomentoRelativoHTML($momento,$href){
  $dt=new DateTime($momento);
  $dt->setTimezone(new DateTimeZone("America/Buenos_Aires"));
  $ahora=new DateTime();
  $ahora->setTimezone(new DateTimeZone("America/Buenos_Aires"));
  if($dt->format('Y-m-d')==$ahora->format('Y-m-d')){
    $rta=coalesce(Hace(GetDeltaTime($ahora,$dt,60*60),"hora")
         ,Hace(GetDeltaTime($ahora,$dt,60),"minuto")
         ,"reci&eacute;n");
  }else{
    $dias=GetDeltaTime(new DateTime('today'),$dt,60*60*24)+1;
    if($dias==1){
      $rta="ayer";
    }else if($dias<7){
      $rta="el ".DiaDeLaSemana($dt->format('N'));
    }else{
      $rta="el ".$dt->format('d/m');
    }
  }
  $alt=$dt->format('d/m/Y H:i:s');
  return "<a href='$href' alt='$alt' title='$alt'>$rta</a>";
}

function array_append(&$arreglo_destino, $arreglo_a_agregar){
    foreach($arreglo_a_agregar as $valor){
        $arreglo_destino[]=$valor;
    }
}

function empieza_con($frase,$prefijo){
    return substr($frase,0,strlen($prefijo))===$prefijo;
}

function termina_con($frase,$sufijo){
    return substr($frase,-strlen($sufijo))===$sufijo;
}

function quitar_prefijo($frase,$prefijo){
    if(!empieza_con($frase,$prefijo)){
        throw new Exception_Tedede("No se pudo quitar el prefijo $prefijo de $frase");
    }
    return substr($frase,strlen($prefijo));
}

function cambiar_prefijo_raya($nombre_campo,$prefijo_quitar,$prefijo_poner){

    return ($prefijo_poner?$prefijo_poner.'_':'').quitar_prefijo($nombre_campo,($prefijo_quitar?$prefijo_quitar.'_':''));
}

function traer_sufijo($texto){
  //trae lo que hay despues del ultimo "_". traer_sufijo('tab_cam') regresa "cam".
  $pos=strrpos($texto,'_')+1;
  return substr($texto,$pos,strlen($texto)-$pos);
}

function obtener_tiempo_logico($este){
    if(!isset($GLOBALS["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_tlg"])){
        $tabla_tiempo_logico=$este->nuevo_objeto('Tabla_tiempo_logico');
        $tabla_tiempo_logico->valores_para_insert=array(
            'tlg_ses'=>sesion_actual()
        );
        $tabla_tiempo_logico->expresiones_returning=array('tlg_tlg');
        $tabla_tiempo_logico->ejecutar_insercion();
        $GLOBALS["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_tlg"]=$tabla_tiempo_logico->retorno->tlg_tlg;
    }
    return $GLOBALS["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_tlg"];
}

function json_str_error(){
    switch (json_last_error()) {
        case JSON_ERROR_NONE:
            return ' - No errors';
        break;
        case JSON_ERROR_DEPTH:
            return ' - Maximum stack depth exceeded';
        break;
        case JSON_ERROR_STATE_MISMATCH:
            return ' - Underflow or the modes mismatch';
        break;
        case JSON_ERROR_CTRL_CHAR:
            return ' - Unexpected control character found';
        break;
        case JSON_ERROR_SYNTAX:
            return ' - Syntax error, malformed JSON';
        break;
        case JSON_ERROR_UTF8:
            return ' - Malformed UTF-8 characters, possibly incorrectly encoded';
        break;
        default:
            return ' - Unknown error';
        break;
    }
}

// OJO estas funciones las copiamos de proceso_control_encuesta.php
// luego cambiar proceso_control_encuesta.php para que las tome de comunes

function diferencia_ips($primer_ip,$segundo_ip){
  return diferencia_ips_total($primer_ip,$segundo_ip,2);
}
function diferencia_ips_total($primer_ip,$segundo_ip,$desde){
    $octetos_primer_ip =explode ('.',$primer_ip);
    $octetos_segundo_ip=explode ('.',$segundo_ip);
    $i=$desde;
    while ($i<count($octetos_primer_ip) && $octetos_primer_ip[$i]==$octetos_segundo_ip[$i]){
        $i++;
    }
    $diferencia='';
    while ($i<count($octetos_primer_ip)){
        $diferencia.=$octetos_segundo_ip[$i].'.';
        $i++;
    }
    return substr($diferencia,0,strlen($diferencia)-1);
}

function sanitizar_sql($dato_que_viene_de_afuera){
    return str_replace(array('"',"'"),array('',''),$dato_que_viene_de_afuera);
}
?>