<?php
include "lo_necesario.php";
IniciarSesion();
$bolsa=@$_REQUEST['bolsa'];
if(!$bolsa){
	$bolsa=json_decode($_REQUEST['cual']);
	$bolsa=$bolsa[0];
}
if(!$bolsa){
	$str="ERROR FALTA EL NÚMERO DE BOLSA";
}else{
        $str="<table class='tabla_remito_enc' style='width:900px; border:1px solid black;'>";
	$str.="<tr><td style='width:90px' rowspan=2><img src=imagenes/logo_eah.png>";
	$str.="<td><td>REMITO DE BOLSA N°<br> <big>$bolsa</big>";
	$str.="<td><td>imprimió<br>{$usuario_logueado}\n";
	$str.="<tr><td><td><small>año 2011</small><TD><TD>".$hoy->format("d/m/Y")."\n";
	$str.="</table>";
	$str.="<table class='tabla_remito' style='width:900px; border:1px solid black;'>";
	$cursor=$db->ejecutar(<<<SQL
		SELECT * 
		    , coalesce(hog::text,'')||coalesce(' ('||(hog+nullif(s1_extra,0))||') ','') as "hog (S1)"
			, 	case when (rea in (0,1)) then norea_enc::text 
					else norea_recu::text	
				end 
				as norea 
				
			, coalesce(rea_recu_modu::text, rea_modulo::text) as modulos
			, coalesce(norea_recu_modu::text, norea_modulo::text) as "norea m"
			, lpad('',6*6,'&nbsp;') as "."
			, lpad('',60*6,'&nbsp;') as ".."
		  FROM tem11 
		  WHERE bolsa = :bolsa
		  ORDER BY encues
SQL
		, array(':bolsa'=>$bolsa)
	);
	$columnas=array(
		'comuna','replica','up','lote','encues','id_proc','hog (S1)','pobl','norea','modulos','norea m','.','..'
	);
	$str.="<tr>";
	foreach($columnas as $columna){
		$str.="<th>$columna";
	}
	$fila_anterior=null;
	$sumas=array();
	$cant_filas=0;
	while($fila=$cursor->fetchObject()){
		$str.="<tr>";
		$num_columna=0;
		foreach($columnas as $columna){
			$num_columna++;
			if($num_columna>4 or !$fila_anterior or $fila_anterior->{$columna}!=$fila->{$columna}){
				$str.="<td class='tabla_remito_td remito_$columna'>".$fila->{$columna};
				$sumas[$columna]=@$sumas[$columna]+$fila->{$columna};
			}else{
				$str.="<td class='tabla_remito_celda_vacia'>";
			}
		}
		$sumas['S1']=@$sumas['S1']+$fila->s1_extra+$fila->hog;
		$sumas['hog']=@$sumas['hog']+$fila->hog;
		$fila_anterior=$fila;
		$cant_filas++;
	}
	$str.="\n<tr style='border-bottom:1px solid black; border-top:2px solid black'>";
	$str.="<td class=tabla_remito_td colspan=4><td class=tabla_remito_td>$cant_filas<td class=tabla_remito_td><td class=tabla_remito_td>";
	$str.=$sumas['hog'];
	if($sumas['hog']!=$sumas['S1']){
		$str.=" (".$sumas['S1'].")";
	}
	$str.="<td class=tabla_remito_td>{$sumas['pobl']}<td class=tabla_remito_td><td class=tabla_remito_td>{$sumas['modulos']}<td class=tabla_remito_td colspan=3>";
	$str.="</table>\n";
        $str.="<table id='PieDePagina' position= 'absolute' width='900px' border='1' cellpadding='0' cellspacing='0' bordercolor='#000000'>  <tr height='75px'>    <td>&nbsp;</td>    <td>&nbsp;</td>    <td>&nbsp;</td>    <td>&nbsp;</td>  </tr></table>";
        $str.=<<<JS
<script>


page = document.getElementsByTagName('html')[0]
if (page != null) {
   page.style.zoom = "100%";
}
SetPieRemito(event);
window.print();
</script>
JS;
}
EnviarStrAlCliente($str,array('sin doctype'=>true));
?>