<?php
  include "lo_necesario.php";
  IniciarSesion();
  $str="<h1>Usuarios del sistema</h1>\n";
  $str.="<table><tr style='vertical-align:top'><td>\n";
  $str.=OpcionDeMenu("Llenar el formulario de pedido de creación de usuarios"   , "formulario_interno.php?tipo=pedido_alta_usuario");
  $str.=OpcionDeMenu("Llenar el formulario de pedido de delegación de permisos" , "consistencias.php");
  $str.="<td>";
  $str.=Incluir_tabla_editor("'roles'");
  $str.="</tr></table>\n";
  $str.=Incluir_tabla_editor("'usuarios'");
  $str.="</body></html>";
  EnviarStrAlCliente($str);
  
function OpcionDeMenu($texto, $destino){
	$str="";
	$str.="<p onclick=\"IrAUrl('$destino')\"><input type='button' onclick=\"IrAUrl('$destino');\" value='&gt;&gt;&gt' > $texto</p>\n";
	return $str;
}
  
?>