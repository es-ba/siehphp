<?php
  include "lo_necesario.php";
  IniciarSesion();
  //kzk
  $str="";
  if(Puede('programador')){
  
	$linea = file_get_contents('../operaciones/Adaptar_Version_Base.pgs');
	//$patron="/[^-]SELECT *AdaptarEstructura\( *([0-9]+.[0-9]+) *,/m";
	//$patron="/[^-]SELECT *ControlVersionDelBackup\( *([0-9]+) */m";
	$patron="/[^-]SELECT *ControlVersionDelBackup\( *([0-9]+) */m";
	$ultimo_en_Adaptar_Version_Base;
	$version_de_comit_en_base;
	if(preg_match_all($patron, $linea, $coincidencias)){
		$coincidencias = end($coincidencias); 
		$ultimo_en_Adaptar_Version_Base = end($coincidencias); 
		$cursor=$db->ejecutar(<<<SQL
								SELECT versioncommitinstaladoenproduccion
								FROM yeah.parametros;
SQL
		);
		$fila_tem=$cursor->fetchObject();
		$version_de_comit_en_base=$fila_tem->versioncommitinstaladoenproduccion;
		if (trim($ultimo_en_Adaptar_Version_Base) != trim($version_de_comit_en_base)) {
			$str.= '<span style="background-color:red">'; 
			$str.= 'FALTA ADAPTAR LA ESTRUCTURA DE LA BASE DE DATOS'; 
			$str.= ' version del backup en  ..pgs '.$ultimo_en_Adaptar_Version_Base.' - ';
			$str.= ' version en tabla parametros '.$version_de_comit_en_base.' - ' ;
			$str.= '</span>'; 
		} else {
		}
	} else {
		$str.= "Error no se encontro ControlVersionDelBackup en archivo .pgs VERIFICAR!!!";
	}
  }
  //kzk
  $str.="<h1>Menú principal</h1>\n";
  $str.="<table><tr style='vertical-align:top'><td>\n";
  if(Puede('ingresar encuestas') || !$esta_es_la_base_en_produccion){
	$str.=OpcionDeMenu("&#8658;","Ingreso de encuestas"                      , "elegir_vivienda.php");
  }
  if(Puede('seguimiento')){
    $str.=OpcionDeMenu("&#8680;","Seguimiento de encuestas"                  , "editor.php", "principal");
  }
  $str.=OpcionDeMenu("&#8783;","Administrar listado de consistencias"      , "editor.php", "consistencias");
  $str.=OpcionDeMenu("&#8782;","Graficar Estados encuestas"      , "estados_encuestas.php", "graficos");
  $str.=OpcionDeMenu("&#8470;","Ver lista de variables"                    , "editor.php", "variables");
  if(Puede('programador')){
    $str.=OpcionDeMenu("&#8497;","Ver la estructura de los Formularios"    , "editor.php", "formularios", array('for_enc'=>"EAH20{$annio2d}"));
  }
  /*
  $str.=OpcionDeMenu("&#8253;","Correr casos de prueba"                    , "generar_despliegue_formulario.php?probar=I1&matriz=");
  */
  $str.=OpcionDeMenu("&#174;" ,"Novedades de la última versión"            , "novedades_programa.php");
  $str.=OpcionDeMenu("&#8775;","Ver inconsistencias de la base de datos"   , "editor.php", "inconsistencias_listado");
  $str.=OpcionDeMenu("&#9787;","Usuarios del sistema"                      , "usuarios.php");
  $str.="<td>\n";
  $str.=OpcionDeMenu("&#8998;","Salir (cerrar cuenta de $usuario_logueado)", "entrar.php?salir=ahora");
  $str.=OpcionDeMenu("&#8258;","Cambiar clave y datos personales"          , "cambio_datos_usuario.php");
  $str.=OpcionDeMenu("&#8846;","Bajar los formularios del 2011"            , "para_bajar");
  if($usuario_rol=='programador' or $usuario_rol=='procesamiento'){
	$str.=OpcionDeMenu("&#2951;","Compilar todas las consistencias"        , "consistencias.php");
  }
  if(Puede('hacer todo')){
	$str.=OpcionDeMenu("&#2705;","Regenerar los formularios"               , "generar_despliegue_formulario.php");
  }
  //kzk
  if(Puede('programador')){
	$str.=OpcionDeMenu("&#8752;","Version comit en base de datos" , "editor.php", "version_commit_instalado_en_produccion");
  }
  //kzk
  if (Puede('reabrir','bolsas')){
		$str.=OpcionDeMenu("&#9827","Reabrir bolsas" , "pasar_a_estado24.php");
  }
  $str.="<td>\n";
  if(Puede('hacer todo')){
	$str.=OpcionDeMenu("&#2723;","Tabla de tablas"                         , "editor.php", "tablas");
  }
  $str.=OpcionDeMenu("&#9786;","Personal"                         , "editor.php", "personal");
  $str.=OpcionDeMenu("&#2743;","Comunas"                          , "editor.php", "las_comunas");
  $str.=OpcionDeMenu("&#2753;","Agregar/Borrar tem11"             , "editor.php", "agregados_tem");
  $str.=OpcionDeMenu("&#8708;","Ver ingreso faltante"             , "editor.php", "ingreso_faltante");
  if(Puede('ver','tabulados')){
    $str.=OpcionDeMenu("&#9638;","mini Tabulados"                 , "editor.php", "tabulados");
  }
  if (Puede('reabrir','encuestas')){
		$str.=OpcionDeMenu("&#1071;","Reabrir encuesta"           , "reabrir_encuesta.php");
  }
  if(Puede('editar', 'excepciones')){
	$str.=OpcionDeMenu("&#8469;","Registro de novedades excepcionales de las encuestas", "editor.php", "excepciones");
  }
  if(Puede('ver', 'his_inconsistencias_25')){
	$str.=OpcionDeMenu("&#8471;","Ver inconsistencias historicas estado 25", "editor.php", "his_inconsistencias_25");
  }
  $str.="<td>\n";
  if(Puede('ver', 'respuestas_nsnc')){
	$str.=OpcionDeMenu("&#8473;","Ver registros con respuestas de tipo ns/nc", "editor.php", "respuestas_nsnc");
  }
  $str.=OpcionDeMenu("&#8718;","Ver errores de salto"             , "editor.php", "errores_salto");
  if(Puede('ver', 'no_realizadas')){
	$str.=OpcionDeMenu("&#8484;","Ver encuestas no realizadas y sus observaciones", "editor.php", "no_realizadas");
  }
  
  $str.="</tr></table>\n";
  $str.="</body></html>";
  EnviarStrAlCliente($str);
// EnviarStrAlCliente($str);
  
function OpcionDeMenu($icono, $texto, $destino, $parametro=false, $parametros=false){
	$str="";
	$accion="";
	if($parametro){
		$accion.="guardar_en_localStorage(\"parametro_$destino\",\"$parametro\"); guardar_en_localStorage(\"editor_arbol_profundidad\",0);";
	}
	if($parametros){
		$accion.="guardar_en_localStorage(\"parametros_$destino\",".json_encode(json_encode($parametros))."); ";
	}else{
		$accion.="localStorage.removeItem(\"parametros_$destino\"); ";
	}
	$accion.="IrAUrl(\"$destino\");";
	// $str.="<p onclick=\"$accion\"><input type='button' onclick=\"$accion\" value='&#8658;' > $texto</p>\n";
	$str.="<p onclick=\"$accion\"><input type='button' onclick='$accion' value='$icono' style='width:35px; font-family:Serif' > $texto</p>\n";
	return $str;
}

?>