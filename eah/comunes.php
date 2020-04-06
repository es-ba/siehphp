<?php

function arreglo($arreglo, $elemento, $si_null=NULL){
  return isset($arreglo[$elemento])?$arreglo[$elemento]:$si_null;
}

function Loguear($hasta_fecha, $mensaje, $archivo="logs/log.txt", $exceptuando=false){
global $hoy;
  if(is_string($hasta_fecha)){
    $hasta_fecha=new DateTime($hasta_fecha);
  }
  if($hasta_fecha instanceof DateTime && ($hoy<=$hasta_fecha)){
	$str="";
    $str.="-->: ".date("d/m/Y, h:i:s")." ".@$_SESSION["usuario_logueado"]."\n";
    $primero=TRUE;
    foreach(debug_backtrace() as $llamada){
	  if($exceptuando===false 
	    || $exceptuando!==true 
		   && (is_string($exceptuando) && @$llamada['file']!=$exceptuando
		      || is_array($exceptuando) && !in_array($exceptuando,@$llamada['file'])))
	  {
        $str.="  linea ".@$llamada['line']." de archivo ".@$llamada['file']."\n";
        if(!$primero){
          $str.="    {$llamada['function']}(";
          $coma='';
		  if(@$llamada['args']){
			foreach($llamada['args'] as $arg){
			  if(is_a($arg,"stdClass")){
				$str.="{$coma}".var_export($arg,true);
			  }else if(is_a($arg,"DateTime")){
				$str.="{$coma}".$arg->format('yyyy-mm-dd HH:MM:II');
			  }else{
				$str.="{$coma}{$arg}";
			  }
			  $coma=',';
			}
		  }
          $str.=");\n";
        }
        $primero=FALSE;
	  }
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

function Probar($linea,$esperado, $evaluar){
  $valor_esperado=$esperado;
  $valor_evaluado=eval(Para_Eval($evaluar));
  if($valor_esperado!=$valor_evaluado){
    $trace=debug_backtrace();
    $trace=$trace[1];
    echo "<br> se esperaba [$esperado] y se obtuvo [$valor_evaluado] de [$evaluar] \n";
    echo " <br>  en [linea ".arreglo($trace,"line",$linea)." de ".arreglo($trace,"function")." en ".arreglo($trace,"file")."]\n";
  }
}

function AplanarArray($variable, $niveles, $tab=0){
  if(is_array($variable)){
    if($niveles==0){
      return 'ARRAY'; 
	}else{
      $rta="ARRAY[\n";
      foreach($variable as $k => $v){
        $rta.=str_repeat("   ",$tab+1).$k."=".AplanarArray($v, $niveles-1, $tab+1)."\n";
      }
      $rta.=str_repeat("   ",$tab)."]";
      return $rta;
    }
  }else{
    $mostrar="";
    try{
      $mostrar=$variable." ";
    }catch(Exception $e){
      $mostrar=$e->getMessage();
    }catch(ErrorException $e){
      $mostrar=$e->getMessage();
    }
    return $mostrar;
  }
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


function noCacheHeadersXML(){
	header("Content-Type:text/xml");
	header("Cache-Control: no-store, no-cache, must-revalidate");
	header("Cache-Control: post-check=0, pre-check=0", false);	
	header("Pragma: no-cache");
}

function Incluir_tabla_editor($tabla_entrecomillada_o_funcion_js_que_la_averigua, $averiguar_parametros_tabla='false', $receptaculo=false){
// 	<div id="lugar_para_la_tabla"><img src='imagenes/cargando.gif'></div>
// 	
$str='';
if(!$receptaculo){
	$str.="\n<script language='JavaScript'>\n";
	$poner_el_contenedor="editor.poner_el_contenedor();";
}else{
	$poner_el_contenedor="elemento_existente(".json_encode($receptaculo).").innerHTML=editor.obtener_el_contenedor();";
}
$str.=<<<HTML
	{
		var nombre_tabla=$tabla_entrecomillada_o_funcion_js_que_la_averigua;
		var parametros_tabla=$averiguar_parametros_tabla;
		var editor=editores[nombre_tabla]=new Editor(nombre_tabla,nombre_tabla,parametros_tabla);
		$poner_el_contenedor
		editor.cargar_grilla(null,true);
	}
	
HTML;
if(!$receptaculo){
	$str.="</script>\n";
}
return $str;
}
?>