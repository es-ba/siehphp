<?php
include "lo_necesario.php";

//$lugar_a_reemplazar_mas_codigo="<!--FIN_DE_LA_GENERACION-->";
$lugar_a_reemplazar_mas_codigo="";

$annio=2011;
if(isset($_REQUEST['probar'])){
	$formulario=$_REQUEST['probar'];
	$para_casos_de_prueba='casos_prueba_yeah.js';
	$annio=2010;
	die();
}else if(isset($_REQUEST['usar'])){
	$formulario=$_REQUEST['usar'];
	$para_casos_de_prueba='';
}else{
	$formulario=false;
	$para_casos_de_prueba='';
}
if(isset($_REQUEST['matriz'])){
	$matriz=$_REQUEST['matriz'];
	if(!$matriz){
		$matriz='';
	}
}else{
	$matriz='';
}

$expresion_ID_variable=" ('".PREFIJO_ID_VARIABLE
	    ."' || lower(case when val_variable is null then (case val_val when 'unico' then val_cel else val_cel || '_' || val_val end) else replace(val_variable,'#',val_cel) end)) as id_variable";
$expresion_nsnc=<<<SQL
	coalesce(val_nsnc_atipico, tipovar_nsnc) as val_nsnc
SQL;
$filtro_val_es_variable=" val_tipovar is not null and val_tipovar <> 'multiple'";
$filtro_val_es_variable_o_multiple=" val_tipovar is not null";
foreach(array(0,1) as $para_ipad){
	$estructura=array();
	Despliegue_formulario();
}

Generar_Triggers_Relevamiento();

if($formulario){
	$html=file_get_contents("gen/formulario_{$formulario}_{$matriz}_i{$para_ipad}.php");
	echo $html;
}

function Despliegue_formulario(){
global $db,$expresion_ID_variable, $filtro_val_es_variable,$filtro_val_es_opcion,$estructura,$estructura_id_variable_anterior,$annio,$orden_variables,$para_ipad;
$orden_variables=1;
$estructura['formulario']=array();

$db->ejecutar("delete from variables where var_enc='EAH$annio';");

$boton_volver_grabando="<input type='button' onclick='VolverDelFormulario();' value='Volver'>\n";
				

$cursor_for_mat=$db->ejecutar(<<<SQL
	select for_enc, for_for, mat_mat, for_orden
		from celdas inner join formularios on for_enc=cel_enc and for_for=cel_for
			left join matrices on for_enc=mat_enc and for_for=mat_for and cel_mat=mat_mat
			where for_enc='EAH$annio' and cel_activa
			group by for_enc, for_for, mat_mat, for_orden
			ORDER BY for_orden, mat_mat asc nulls first
SQL
	);

$str_form_actual=""; // el contenido del despliegue del formulario actual!

while($fila_for_mat=$cursor_for_mat->fetchObject()){
	$estructura_id_variable_anterior=false;
	$str="";
	$str.=DatosDeIdentificacion($boton_volver_grabando);
	$str.=str_replace('$','','<small>'.substr_replace('$Rev: 3285 $</small>','.',7,0));
	$estructura['formulario'][$fila_for_mat->for_for][$fila_for_mat->mat_mat]=array();
	$str.=Despliegue_Celdas($fila_for_mat->for_enc, $fila_for_mat->for_for, $fila_for_mat->mat_mat,'vertical');
	$str.=$boton_volver_grabando;
	$json_formulario_matriz=json_encode(array('formulario'=>$fila_for_mat->for_for, 'matriz'=>$fila_for_mat->mat_mat));
	$str.=<<<HTML
	<script type="text/javascript">
	DesplegarVariableFormulario($json_formulario_matriz);
	window.onunload=function(){ GuardarElFormulario(); /* alert('guardado 1'); */ }
	window.onbeforeunload=function(){ 
		if(GuardarElFormulario()){
			return "El formulario tiene modificaciones. Se perderan al cerrar. ¿Desea cerrar?";
		}
	}
	</script>
	{$GLOBALS['lugar_a_reemplazar_mas_codigo']}
HTML;
	file_put_contents("gen/formulario_{$fila_for_mat->for_for}_{$fila_for_mat->mat_mat}_i{$para_ipad}.php"
	, EnviarStrAlCliente($str,array('return en vez de echo'=>true
	                               ,'casos de prueba'=>$GLOBALS['para_casos_de_prueba']
								   ,'prefijo_carpeta'=>'../'
								   ,'para ipad'=>$para_ipad))
	);
}

$estructura['copias']=array(
	'S1'=>array(
		''=>array(
			array('destino'=>'copia_participacion', 'origen'=>'var_participacion', 'cambiador_id'=>array('formulario'=>'S1', 'matriz'=>'', 'nhogar'=>1))
		)
		, 'P'=>array(
			array('destino'=>'copia_participacion', 'origen'=>'var_participacion', 'cambiador_id'=>array('formulario'=>'S1', 'matriz'=>'', 'miembro'=>'borrar'))
		)
	)
	, 'I1'=>array(
		''=>array(
			array('destino'=>'copia_edad', 'origen'=>'var_edad', 'cambiador_id'=>array('formulario'=>'S1', 'matriz'=>'P'))
			, array('destino'=>'copia_p5'  , 'origen'=>'var_p5'  , 'cambiador_id'=>array('formulario'=>'S1', 'matriz'=>'P'))
			, array('destino'=>'copia_sexo', 'origen'=>'var_sexo', 'cambiador_id'=>array('formulario'=>'S1', 'matriz'=>'P'))
		)
		, 'U'=>array(
			array('destino'=>'copia_p5'  , 'origen'=>'var_p5'  , 'cambiador_id'=>array('formulario'=>'S1', 'matriz'=>'P', 'relacion'=>'borrar'))
			, array('destino'=>'copia_u1'  , 'origen'=>'var_u1'  , 'cambiador_id'=>array('formulario'=>'I1', 'matriz'=>'', 'relacion'=>'borrar'))
		)
	)
	, 'MD'=>array(
		''=>array(
			array('destino'=>'copia_edad', 'origen'=>'var_edad', 'cambiador_id'=>array('formulario'=>'S1', 'matriz'=>'P'))
			, array('destino'=>'copia_p5'  , 'origen'=>'var_p5'  , 'cambiador_id'=>array('formulario'=>'S1', 'matriz'=>'P'))
			, array('destino'=>'copia_sexo', 'origen'=>'var_sexo', 'cambiador_id'=>array('formulario'=>'S1', 'matriz'=>'P'))
			, array('destino'=>'copia_e6'  , 'origen'=>'var_e6'  , 'cambiador_id'=>array('formulario'=>'I1', 'matriz'=>''))
			, array('destino'=>'copia_e2'  , 'origen'=>'var_e2'  , 'cambiador_id'=>array('formulario'=>'I1', 'matriz'=>''))
			, array('destino'=>'copia_t35' , 'origen'=>'var_t35' , 'cambiador_id'=>array('formulario'=>'I1', 'matriz'=>''))
			, array('destino'=>'copia_t38' , 'origen'=>'var_t38' , 'cambiador_id'=>array('formulario'=>'I1', 'matriz'=>''))
			, array('destino'=>'copia_t13' , 'origen'=>'var_t13' , 'cambiador_id'=>array('formulario'=>'I1', 'matriz'=>''))
		)
	)
);

// generalizar.
$estructura['formulario']['S1']['']['var_total_m']['saltar_a_boton']='boton_S1_P_1';
$estructura['formulario']['S1']['']['var_total_m']['expresion_saltar_a_boton']='entrea=1';

$estructura['formulario']['I1']['']['var_u1']['saltar_a_boton']='boton_I1_U_1';
$estructura['formulario']['I1']['']['var_u1']['expresion_saltar_a_boton']='u1>0';

$estructura['formulario']['A1']['']['var_x5']['saltar_a_boton']='boton_A1_X_1';
$estructura['formulario']['A1']['']['var_x5']['expresion_saltar_a_boton']='x5=1';


if($annio==2010){ // para pruebas
	unset($estructura['copias']['S1']);
	unset($estructura['copias']['I1']['U']);
	unset($estructura['copias']);
	$estructura['copias']=array();
	unset($estructura['formulario']['I1']['']['var_u1']); 
}

$f=fopen('gen/estructura_yeah.js','w');
fwrite($f,"var estructura=\n");
fwrite($f,json_sangrar(json_encode($estructura)));
fwrite($f,"\n;//fin\n");
fclose($f);

}

function Despliegue_Celdas($enc, $for, $mat, $orientacion){
global $db;
	$para_ipad="";
	$str="";
	if($orientacion=='horizontal'){
		$prefijo_clase="hori_";
		$str.=<<<HTML
		<table class="matriz_horizontal">
HTML;
	}else{
		$prefijo_clase="";
		$no_select=$para_ipad?" no_select":"";
		$str.=<<<HTML
		<table class="de_preguntas$no_select">
			<colgroup>
			<col width="40">
			<col width="60">
HTML;
	}
	if($mat){
		$filtro_matriz=" and cel_mat='{$mat}'";
	}else{
		$filtro_matriz=" and cel_mat is null";
	}
	$cursor_celdas=$db->ejecutar(<<<SQL
		select *
		  from celdas
		  where cel_for='{$for}' and cel_enc='{$enc}' {$filtro_matriz} and cel_activa
		  order by cel_orden, cel_cel
SQL
	);
	if($orientacion=='horizontal'){
		$str.="<tr id='titulos_matriz_{$mat}' class='unica_fila_preguntas_matriz'>\n"; // titulos
		$str_abajo="<tr id='fila_matriz_{$mat}' class='fila_matriz'>"; // las variables
	}else{
		$str_abajo="";
	}
	while($fila=$cursor_celdas->fetchObject()){
		if($fila->cel_texto=='#BotoneraHogares'){
			$cel_texto="Hogar: <span id=BotoneraHogares></span>";
		}else{
			$cel_texto=htmlspecialchars($fila->cel_texto);
		}
	  // Zona preguntas
		if($orientacion=='vertical'){
			$str.="<tr class='fila_pregunta'>\n";
		}
		
				
		if($fila->cel_tipo=="especial"){
			if($fila->cel_texto=='#inconsistencias'){ 
				$str.="<td colspan=2>";
				$str.="<input type=button id=boton_ver_consistencias value='Ver consistencias' title='para todas las hogares de esta vivienda' onclick='CorrerConsistencias(this,pk_ud.encuesta,false);'>\n";
				$str.="<input type=button id=boton_correr_consistencias value='Correr consistencias' title='para todas las hogares de esta vivienda' onclick='CorrerConsistencias(this,pk_ud.encuesta,true);'>\n";
				$str.="<input type=button id=fin_encuesta_4 value='Mandar a campo' style='display:none' onclick='Cerrar_Encuesta(4)'>";
				$str.="<input type=button id=fin_encuesta_5 value='Mandar a procesamiento' style='display:none' onclick='Cerrar_Encuesta(5)'>";
				$str.="<input type=button id=fin_encuesta_6 value='Pasar a Fase 2' style='display:none' onclick='Cerrar_Encuesta(6)'>";
				$str.="<input type=button id=boton_cerrar_encuesta value='Cerrar encuesta' style='display:none' onclick='Cerrar_Encuesta()'>";
			}
		}else if($fila->cel_tipo=="aclaracion"){
			$str.="<td colspan=2 class='cel_aclara'>\n";
			$str.="{$cel_texto}";
		}else if($fila->cel_tipo=="matriz"){
			$str.="<td colspan=2>\n";
			$str.="{$cel_texto}";
			$str.=Despliegue_Celdas($fila->cel_enc, $fila->cel_for, $fila->cel_incluir_mat, 'horizontal');
		}else{
			$str.="<td>\n";
			if($fila->cel_cel_visible===true || $fila->cel_cel_visible===null && preg_match("/[0-9]/",$fila->cel_cel)>0){
				$str.="<span class='{$prefijo_clase}pre_pre'>{$fila->cel_cel}</span>\n";
			}
			$elijo_nombre=$fila->cel_nombre_corto ?: $cel_texto;
			$str.="<span class='{$prefijo_clase}pre_texto' id='".PREFIJO_ID_PREGUNTA.$fila->cel_cel."'>{$elijo_nombre}";
			if($fila->cel_aclaracion && $orientacion=='vertical'){
				$str.=" <span class='{$prefijo_clase}pre_aclaracion'>{$fila->cel_aclaracion}</span>";
			}
			$str.="</span>\n";
			// Zona respuesta
			if($orientacion=='vertical'){
				$str.="<td>";
				$str.="<table id='interna_opciones'>";
				$str.="<colgroup><col><col><col><col><col><col><col><col></colgroup>";
				$str.=Despliegue_Variables($fila, null, 1, 1, 3, 1, 3);
				$str.="</table>\n";
			}else{
				$str_abajo.=Despliegue_Variables($fila, null, 1, 1, 3, 1, 3, 'horizontal');
			}
		}
	}
	
	$str.=$str_abajo;
	$str.=<<<HTML
	</table>
HTML;
	return $str;
}

function Despliegue_Variables($fila, $padre,$profundidad,$span_margen,$span_texto_izq,$span_variable,$span_texto_der,$orientacion='vertical'){
global $db,$expresion_ID_variable, $expresion_nsnc, $filtro_val_es_variable_o_multiple,$filtro_val_es_opcion,$estructura,$estructura_id_variable_anterior,$orden_variables,$annio2d,$para_ipad;
//aca
	$str="";
	if($padre){
		$and_padre=" and val_padre='$padre'";
	}else{
		$and_padre=" and val_padre is null";
	}
	$cursor_var=$db->ejecutar($Sql_var=<<<SQL
		select *, tipovar_es_numerico as val_es_numerico, tipovar_es_multiple_con_opciones as val_multipleconopciones
				, tipovar_para_marcar, val_optativa, tipovar_es_visible
			, $expresion_ID_variable
			, $expresion_nsnc
		  from valores inner join tipo_var on tipovar_tipovar=val_tipovar
		  where val_enc='{$fila->cel_enc}' and val_for='{$fila->cel_for}' and val_cel='{$fila->cel_cel}' 
		    and $filtro_val_es_variable_o_multiple $and_padre
		  order by val_orden
SQL
	);
	//echo $Sql_var;
	$la_anterior_es_multiple=false;
	while($fila_var=$cursor_var->fetchObject()){
		if($fila_var->val_tipovar<>'multiple'){
			$id_variable=$fila_var->id_variable;
			$id_variable_sin_prefijo=substr($id_variable,strlen(PREFIJO_ID_VARIABLE));
			if($orientacion=='horizontal'){
				$str.="<td id='$id_variable'>";
			}else{
				$parte_sql_opciones=<<<SQL
					  from valores 
					  /*inner join celdas on cel_cel=val_cel
					  inner join tipo_cel on tipocel_tipocel=cel_tipo*/
					  where val_enc='{$fila->cel_enc}' and val_for='{$fila->cel_for}' 
							and val_cel in ('{$fila->cel_cel}','{$fila_var->val_mejor_de_celda}')
						 and (val_tipovar is null and val_cel='{$fila->cel_cel}' and val_padre='{$fila_var->val_val}' /* opciones comunes */
							  or val_tipovar='marcar' and val_cel='{$fila->cel_cel}' and val_val='{$fila_var->val_val}' /* opciones de las marcar (o sea de las multiples) */
							  or val_tipovar='marcar' and val_cel='{$fila_var->val_mejor_de_celda}' and val_padre='unico' /*opciones de la celda para las elija el mejor*/) 						  
SQL;
				if($estructura_id_variable_anterior){
					$estructura['formulario'][$fila->cel_for][$fila->cel_mat][$estructura_id_variable_anterior]['siguiente']=$id_variable;
				}
				$estructura_id_variable_anterior=$id_variable;
				$estructura['formulario'][$fila->cel_for][$fila->cel_mat][$id_variable]=array();
				foreach(array('es_numerico','maximo','minimo','advertencia_sup','advertencia_inf') as $campo){
					if($fila_var->{'val_'.$campo}){
						$estructura['formulario'][$fila->cel_for][$fila->cel_mat][$id_variable][$campo]=$fila_var->{'val_'.$campo};
					}
				}
				if($fila_var->val_expresion && $fila_var->val_tipovar=='filtro'){
					$estructura['formulario'][$fila->cel_for][$fila->cel_mat][$id_variable]['expresion_filtro']=strtolower($fila_var->val_expresion);
					$estructura['formulario'][$fila->cel_for][$fila->cel_mat][$id_variable]['no_es_variable']=true;
				}
				if($fila_var->val_expresion_habilitar){
					$estructura['formulario'][$fila->cel_for][$fila->cel_mat][$id_variable]['expresion_habilitar']=strtolower($fila_var->val_expresion_habilitar);
				}
				if($fila_var->val_salta){
					$estructura['formulario'][$fila->cel_for][$fila->cel_mat][$id_variable]['salta']=variable_o_primer_variable_de_la_pregunta($fila_var->val_salta,$fila);
				}
				if($la_anterior_es_multiple){
					$estructura['formulario'][$fila->cel_for][$fila->cel_mat][$id_variable]['la_anterior_es_multiple']=true;   
				}
				if($fila_var->val_tipovar=='marcar'){
					$estructura['formulario'][$fila->cel_for][$fila->cel_mat][$id_variable]['marcar']=$fila_var->val_opcion; 
					$estructura['formulario'][$fila->cel_for][$fila->cel_mat][$id_variable]['almacenar']=$fila_var->val_opcion>90?$fila_var->val_opcion:1; 
				}
				 //(tipovar_para_marcar or pre_subpreguntas_optativas)
				if($fila_var->tipovar_para_marcar){
					$la_anterior_es_multiple=true; 
				}
				if($fila_var->val_optativa){
					$estructura['formulario'][$fila->cel_for][$fila->cel_mat][$id_variable]['optativa']=true; 
				}
				if($fila_var->val_nsnc){
					$estructura['formulario'][$fila->cel_for][$fila->cel_mat][$id_variable]['nsnc']=$fila_var->val_nsnc;
				}
				$cursor_con=$db->ejecutar("SELECT * FROM consistencias WHERE con_ultima_variable='{$id_variable_sin_prefijo}' and con_valida and con_tipo='Conceptual' and con_momento='Relevamiento 1'"); // falta and con_enc='EAH20{$annio2d}'
				while($fila_con=$cursor_con->fetchObject()){
					$estructura['formulario'][$fila->cel_for][$fila->cel_mat][$id_variable]['consistir'][$fila_con->con_con]=
						array('expr'=>strtolower($fila_con->con_expresion_sql)
							, 'expl'=>$fila_con->con_explicacion
							, 'gravedad'=>$fila_con->con_gravedad);
				}
				$se_relocaliza=strpos($str,"[RELOCALIZAR:{$fila_var->val_val}]"); // algunos datos no irán si la variable se relocaliza
				$str_var=""; // guardo la variable en un lugar intermedio para después colocar donde corresponda
				$str_var.="<tr";
				if($fila_var->val_multipleconopciones){
					$str_var.=" class='fila_subpregunta_multiple'";
				}
				$str_var.=">";
				if($profundidad>1){
					$str_var.="<td colspan=$span_margen class=sangria>";
				}
				$str_var.="<td colspan=$span_texto_izq>";
				if($fila_var->val_tipovar!='marcar'){
					$str_var.=htmlspecialchars($fila_var->val_texto);
					if($fila_var->val_aclaracion){
						$str_var.=" <span class='opc_aclaracion'>{$fila_var->val_aclaracion}</span>";
					}
				}
				$str_var.="<td colspan=$span_variable>";
				$str_var.="<span class='respuesta'  title='{$fila_var->val_tipovar}'>";
				$str_var.="<input id='$id_variable' name='$id_variable' ";
				$str_var.="type='".(($fila_var->val_es_numerico || $fila_var->tipovar_tipovar=='opciones') && $para_ipad?'number':'text')."' ";
				if(!$fila_var->tipovar_es_visible){
					$str_var.="readonly=readonly";
				}
				$str_var.=" class='input_{$fila_var->val_tipovar}' onblur='";
				$str_var.="ValidarOpcion(\"{$id_variable}\");'";
				$str_var.=" onKeyPress='PresionTeclaEnVariable(\"{$id_variable}\",event);'";
				$str_var.=" onKeyDown='PresionOtraTeclaEnVariable(\"{$id_variable}\",event);'";
				$str_var.=" >";
				$str_var.="</span>\n";
				$str_var.=Sennial_Saltar($fila_var->val_salta,$id_variable); 
				$str_var.="</td>";
				$str.=$str_var;
				$str.="<td colspan=$span_texto_der>";
				$cursor_op=$db->ejecutar("select * $parte_sql_opciones order by val_orden");
				while($fila_op=$cursor_op->fetchObject()){
					$str.="<li id='".$id_variable.SEPARADOR_VARIABLE_OPCION.$fila_op->val_opcion."'";
					$str_varop=htmlspecialchars($fila_op->val_texto);
					if(strlen($str_varop)<10){
						$str.=" style='white-space:nowrap;'";
					}
					$str.="><span ";
					$str.="onclick=\"PonerOpcion('$id_variable','{$fila_op->val_opcion}'";
					if($fila_op->val_salta){
						$str.=",'".PREFIJO_ID_PREGUNTA.$fila_op->val_salta."'";
					}
					$str.=")\"";
					$str.=">";
					$str.="{$fila_op->val_opcion}: {$str_varop}";
					$str.="</span>";
					if($fila_op->val_aclaracion){
						$str.=" <span class='opc_aclaracion'>{$fila_op->val_aclaracion}</span>";
					}
					if($fila_op->val_salta){
						$str.=Sennial_Saltar($fila_op->val_salta,"{$id_variable}.{$fila_op->val_opcion}"); 
					}
					$str.="</li>\n";
					$estructura['formulario'][$fila->cel_for][$fila->cel_mat][$id_variable]['opciones'][$fila_op->val_opcion]=array();
					$estructura['formulario'][$fila->cel_for][$fila->cel_mat][$id_variable]['opciones'][$fila_op->val_opcion]['texto']=$str_varop;
					if($fila_op->val_salta){
						$estructura['formulario'][$fila->cel_for][$fila->cel_mat][$id_variable]['opciones'][$fila_op->val_opcion]['salta']=variable_o_primer_variable_de_la_pregunta($fila_op->val_salta,$fila);
					}
					if($fila_op->val_tipovar<>'marcar'){
						$str_interno=Despliegue_Variables($fila, $fila_op->val_val,$profundidad+1, 4, 1, 2, 1);
						if($str_interno){
							$str.="<table>$str_interno</table>\n";
						}
					}
				}
				$str.="</td></tr>\n";
				if($fila_var->val_tipovar!='filtro'){
					$db->ejecutar(<<<SQL
						INSERT INTO yeah.variables(
							var_enc, var_for, var_cel, var_val, var_var, var_texto, var_salta, 
							var_aclaracion, var_orden, var_tipovar, var_maximo, var_minimo, 
							var_advertencia_sup, var_advertencia_inf, var_padre, var_variable, 
							var_expresion, var_expresion_habilitar, var_mejor_de_celda, var_optativa, 
							var_es_numerico, var_para_marcar, var_multipleconopciones, var_mat, var_nsnc)
						VALUES(
							:var_enc, :var_for, :var_cel, :var_val, :var_var, :var_texto, :var_salta, 
							:var_aclaracion, :var_orden, :var_tipovar, :var_maximo, :var_minimo, 
							:var_advertencia_sup, :var_advertencia_inf, :var_padre, :var_variable, 
							:var_expresion, :var_expresion_habilitar, :var_mejor_de_celda, :var_optativa, 
							:var_es_numerico, :var_para_marcar, :var_multipleconopciones, :var_mat, :var_nsnc);
SQL
						,array(
							 ':var_enc'                => $fila_var->val_enc
							,':var_for'                => $fila_var->val_for
							,':var_cel'                => $fila_var->val_cel
							,':var_val'                => $fila_var->val_val
							,':var_var'                => $id_variable_sin_prefijo
							,':var_texto'              => ($fila->cel_nombre_corto?:$fila->cel_texto).' '.$fila_var->val_texto
							,':var_salta'              => $fila_var->val_salta
							,':var_aclaracion'         => $fila_var->val_aclaracion
							,':var_orden'              => $orden_variables++
							,':var_tipovar'            => $fila_var->val_tipovar
							,':var_maximo'             => $fila_var->tipovar_maximo
							,':var_minimo'             => $fila_var->tipovar_minimo
							,':var_advertencia_sup'    => $fila_var->tipovar_advertencia_sup
							,':var_advertencia_inf'    => $fila_var->tipovar_advertencia_inf
							,':var_padre'              => $fila_var->val_padre
							,':var_variable'           => $fila_var->val_variable
							,':var_expresion'          => strtolower($fila_var->val_expresion)
							,':var_expresion_habilitar'=> strtolower($fila_var->val_expresion_habilitar)
							,':var_mejor_de_celda'     => $fila_var->val_mejor_de_celda
							,':var_optativa'           => $fila_var->val_optativa
							,':var_es_numerico'        => $fila_var->val_es_numerico
							,':var_para_marcar'        => $fila_var->tipovar_para_marcar
							,':var_multipleconopciones'=> $fila_var->val_multipleconopciones
							,':var_mat'                => $fila->cel_mat
							,':var_nsnc'               => $fila_var->val_nsnc
						)
					);
				}
			}
		}
		if($fila_var->val_tipovar=='multiple'){
			$str.=Despliegue_Variables($fila, $fila_var->val_val,$profundidad+1, 1, 3, 1, 3, $orientacion);
		}else if($fila_var->val_tipovar=='marcar'){
			$str.=Despliegue_Variables($fila, $fila_var->val_val,$profundidad+1, 5, 1, 2, 0, $orientacion);
		}else{
			$str.=Despliegue_Variables($fila, $fila_var->val_val,$profundidad+1, 1, 1, 2, 4, $orientacion);
		}
	}
	return $str;
}

function elemento_input_variable($id_variable,$clase_variable){  
    return $str;
}    

function DatosDeIdentificacion($boton_volver_grabando){
	$str="<table>\n";
	$str.="<tr><td>$boton_volver_grabando";
	foreach(array('ud') as $esta){
		$str.="<td>$esta:<span id='id_$esta'></span></td>";
	}
	$str.="</table>\n";
	return $str;
}

function variable_o_primer_variable_de_la_pregunta($id_pregunta_o_variable,$fila_pre){
	global $db,$expresion_ID_variable, $filtro_val_es_variable;
	$variable=$db->preguntar($la_consulta=<<<SQL
		select $expresion_ID_variable 
			from valores 
			where val_enc='{$fila_pre->cel_enc}' 
				and val_for='{$fila_pre->cel_for}' 
				and lower(val_val)=lower('{$id_pregunta_o_variable}')
				and $filtro_val_es_variable
			order by val_orden
			limit 1
SQL
	);
	if(!$variable){
		$variable=$db->preguntar($la_consulta=<<<SQL
			select $expresion_ID_variable 
				from valores
				where val_enc='{$fila_pre->cel_enc}' 
					and val_for='{$fila_pre->cel_for}' 
					and lower(val_cel)=lower('{$id_pregunta_o_variable}')
					and $filtro_val_es_variable
				order by val_orden
				limit 1
SQL
		);
	}
	if(!$variable){
		$variable=$db->preguntar($la_consulta=<<<SQL
			select $expresion_ID_variable 
				from valores
				where val_enc='{$fila_pre->cel_enc}' 
					and val_for='{$fila_pre->cel_for}' 
					and lower(val_cel)=lower('{$id_pregunta_o_variable}')
					and val_tipovar='filtro'
				order by val_orden
				limit 1
SQL
		);
	}
	return $variable;
}

function Sennial_Saltar($destino_pre,$id_salto){
	if($destino_pre){
		$caracter_saltar='&#8631;';
		return " <span class='texto_salto' id='{$id_salto}.salto'> $caracter_saltar {$destino_pre}</span>\n";
	}
}

function Generar_Triggers_Relevamiento(){
global $annio2d,$db,$tabla_de;
	$resultados=array(); // indexado por tabla\
	$where_pk_de_la_tabla['viv_s1a1']="res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0";
	$where_pk_de_la_tabla['ex']="res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=new.ex_miembro and res_relacion=0";
	$where_pk_de_la_tabla['fam']="res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.p0 and res_ex_miembro=0 and res_relacion=0";
	$where_pk_de_la_tabla['i1']="res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0";
	$where_pk_de_la_tabla['md']="res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0";
	$where_pk_de_la_tabla['un']="res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=new.relacion";
	$valores_pk_de_la_tabla['viv_s1a1']='new.nenc,new.nhogar,0,0,0';
	$valores_pk_de_la_tabla['ex']='new.nenc,new.nhogar,0,new.ex_miembro,0';
	$valores_pk_de_la_tabla['fam']='new.nenc,new.nhogar,new.p0,0,0';
	$valores_pk_de_la_tabla['i1']='new.nenc,new.nhogar,new.miembro,0,0';
	$valores_pk_de_la_tabla['md']='new.nenc,new.nhogar,new.miembro,0,0';
	$valores_pk_de_la_tabla['un']='new.nenc,new.nhogar,new.miembro,0,new.relacion';
	$cursor=$db->ejecutar(<<<SQL
		SELECT var_var as res_var, var_for as res_for, var_mat as res_mat
		  FROM variables
		  WHERE var_enc='EAH20{$annio2d}'
		  ORDER BY var_orden
SQL
		);
	foreach($where_pk_de_la_tabla as $tabla=>$algo){
		$resultados[$tabla]['ins']="";
		$resultados[$tabla]['upd']="";
		$resultados[$tabla]['del']="";
	}
	while($fila=$cursor->fetchObject()){
		$tabla=$tabla_de[$fila->res_for][$fila->res_mat];
		$valores_pk=$valores_pk_de_la_tabla[$tabla];
		$where_pk=$where_pk_de_la_tabla[$tabla];
		$resultados[$tabla]['ins'].=<<<SQL
		INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES ({$valores_pk},'{$fila->res_var}', '{$fila->res_for}', '{$fila->res_mat}', '{$tabla}',new.{$fila->res_var},new.usuario);
		
SQL;
		$resultados[$tabla]['upd'].=<<<SQL
		if new.{$fila->res_var} is distinct from old.{$fila->res_var} then
			update yeah_2011.respuestas set res_respuesta=new.{$fila->res_var}, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE {$where_pk} and res_var='{$fila->res_var}';
	    end if;
		
SQL;
		$where_pk=str_replace('new','old',$where_pk);
		$resultados[$tabla]['del'].=<<<SQL
		delete from yeah_2011.respuestas WHERE {$where_pk} and res_tab='$tabla';
		
SQL;
	}
	$todo_junto="";
	$BODY='$BODY';
	foreach($resultados as $tabla=>$contenido){
		$todo_junto.=<<<SQL
CREATE OR REPLACE FUNCTION yeah_20{$annio2d}.res_eah{$annio2d}_{$tabla}_del()
  RETURNS trigger AS
$BODY$
BEGIN
  {$contenido['del']}
  RETURN old;
END
$BODY$
  LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION yeah_20{$annio2d}.res_eah{$annio2d}_{$tabla}_upd()
  RETURNS trigger AS
$BODY$
BEGIN
  {$contenido['upd']}
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION yeah_20{$annio2d}.res_eah{$annio2d}_{$tabla}_ins()
  RETURNS trigger AS
$BODY$
BEGIN
  {$contenido['ins']}
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql VOLATILE;

SQL;
	}
	$todo_junto.="\n/* borrar triggers\n";
	foreach($resultados as $tabla=>$contenido){
		$todo_junto.=<<<SQL
DROP TRIGGER res_eah{$annio2d}_{$tabla}_del ON yeah_20{$annio2d}.eah{$annio2d}_{$tabla};
DROP TRIGGER res_eah{$annio2d}_{$tabla}_upd ON yeah_20{$annio2d}.eah{$annio2d}_{$tabla};
DROP TRIGGER res_eah{$annio2d}_{$tabla}_ins ON yeah_20{$annio2d}.eah{$annio2d}_{$tabla};

SQL;
	}
	$todo_junto.="\n*/";
	$todo_junto.="\n/* crear triggers\n";
	foreach($resultados as $tabla=>$contenido){
		$todo_junto.=<<<SQL
CREATE TRIGGER res_eah{$annio2d}_{$tabla}_del
  BEFORE DELETE
  ON yeah_20{$annio2d}.eah11_{$tabla}
  FOR EACH ROW
  EXECUTE PROCEDURE yeah_20{$annio2d}.res_eah{$annio2d}_{$tabla}_del();
  
CREATE TRIGGER res_eah{$annio2d}_{$tabla}_upd
  BEFORE UPDATE
  ON yeah_20{$annio2d}.eah11_{$tabla}
  FOR EACH ROW
  EXECUTE PROCEDURE yeah_20{$annio2d}.res_eah{$annio2d}_{$tabla}_upd();

CREATE TRIGGER res_eah{$annio2d}_{$tabla}_ins
  BEFORE INSERT
  ON yeah_20{$annio2d}.eah11_{$tabla}
  FOR EACH ROW
  EXECUTE PROCEDURE yeah_20{$annio2d}.res_eah{$annio2d}_{$tabla}_ins();

SQL;
	}
	$todo_junto.="\n*/";
	file_put_contents('gen/triggers_relevamiento.sql',$todo_junto);
}
?>