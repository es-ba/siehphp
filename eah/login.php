<?php
  include "lo_necesario.php";
  IniciarSesion(array('para login'=>true));
	$_SESSION['usuario_logueado']=false;
	if(@$_SESSION['sesion_pg']){
		$db->ejecutar("update sesiones set ses_activa=false, ses_finalizada=current_timestamp where ses_ses={$_SESSION['sesion_pg']}");
		$_SESSION['sesion_pg']=false;
	}
  $usuario_invalido=@$_SESSION['usuario_invalido'];
  if($usuario_invalido){
    $usuario=$usuario_invalido;
    $decir_invalido="<tr><td colspan=2><spam style='color:red;'><B>usuario o contrase&ntilde;a inv&aacute;lidos</B></spam>";
  }else{
    $usuario=@$_SESSION['usuario'];
    $decir_invalido="";
  }
  if(strpos($_SERVER["HTTP_USER_AGENT"],"Chrome")>0 || $_SESSION['ipad'] || strpos($_SERVER["HTTP_USER_AGENT"],"Safari")>0){
    $boton_login='<input type="submit" id="ingresar"  class="boton" value="ingresar >>"';
	if(!$_SESSION['ipad']){
		$boton_login.='onclick="if(elemento_existente(\'borrarLS\').checked){ Borrar_LocalStorage(true);}"';
	}
	$boton_login.='>';
  }else{
    $boton_login='<input type="button" title="usar el Chrome o el Safari" id="ingresar"  class="boton" value="Navegador no soportado">';
  }
  if($_SESSION['ipad']){
	$renglon_tilde_borrar=<<<HTML
  			<tr>
				<td colspan=2>(conectándose desde un ipad)</label>
HTML;
  }else{
	$renglon_tilde_borrar=<<<HTML
  			<tr>
				<td colspan=2><input type=checkbox id="borrarLS" checked=checked> 
					<label for=borrarLS id=label_borrarLS> No tengo otras ventanas abiertas en esta máquina</label>
HTML;
  }
  EnviarStrAlCliente(<<<HTML
	<h2>Entrada al sistema</h2> 
	<hr>
	<form method="post" action="entrar.php" id="flogin">
		<table>
			<tr>
				<td><label for="usuario">Usuario:</label><td><input type="text" id="usuario" name="usuario" value="$usuario">
			<tr>
				<td><label for="clave">Clave:    </label><td><input type="password" id="clave" name="clave">
			$renglon_tilde_borrar
			<tr>
				<td><td>$boton_login
			$decir_invalido
		</table>
	</form></div>
HTML
	);
?>