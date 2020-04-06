<?php
  include "lo_necesario.php";
  IniciarSesion();
  $datos_personales=$db->preguntar_array(
	"select usu_".implode(', usu_',$campos_datos_personales)." from usuarios where usu_usu=:usu_usu"
	,array(":usu_usu"=>$usuario_logueado)
  );
  $ancho_campos=array('mail'=>'500px','interno'=>'150px');
  $str=<<<HTML
	<h2>Cambio de clave y datos personales</h2> 
    <hr>
    <form method="post" action="entrar.php" id="flogin">
      <table>
        <tr><td><label>Usuario:             </td><td><input type="text"     id="usuario"        name="usuario" value="{$usuario_logueado}" readonly=readonly></td></tr>
        <tr><td><label>Clave anterior:      </td><td><input type="password" id="clave_anterior" name="clave_anterior"></td></tr>  
        <tr><td><label>Clave nueva:         </td><td><input type="password" id="clave_nueva1"   name="clave_nueva1"  ></td></tr>  
        <tr><td><label>repetir clave nueva: </td><td><input type="password" id="clave_nueva2"   name="clave_nueva2"  ></td></tr>  
HTML;
  if($mostrar=@$_SESSION['rta_cambio_clave']){
    $str.="<tr><td colspan='2' style='color:red'><b>$mostrar</b></td></tr>\n";
  }
  $str.=<<<HTML
        <tr><td                             </td><td><input type="submit" id="cambiar" name="cambiar" class="boton" value="cambiar clave"></td></tr>  
HTML;
  foreach($campos_datos_personales as $campo){
	$valor=$datos_personales["usu_$campo"];
    $ancho=@$ancho_campos[$campo]?:'200px';
	$str.=<<<HTML
        <tr><td><label>$campo:              </td><td><input type="text"     id="$campo"         name="$campo" value="$valor" style='width:$ancho'></td></tr>  
HTML;
  }
  $str.=<<<HTML
        <tr><td                             </td><td><input type="submit" id="cambiar" name="cambiar" class="boton" value="cambiar datos personales"></td></tr>  
HTML;
  if($mostrar=@$_SESSION['rta_cambio_datos_personales']){
    $str.="<tr><td colspan='2' style='color:red'><b>$mostrar</b></td></tr>\n";
  }
  $str.=<<<HTML
      </form></div>
HTML;
  EnviarStrAlCliente($str);  
?>