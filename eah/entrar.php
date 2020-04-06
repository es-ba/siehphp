<?php
  include "lo_necesario.php";
  IniciarSesion(array('para login'=>true));
  if(@$_REQUEST['salir']){
	$_SESSION['usuario_logueado']=false;
	$_SESSION['usuario_invalido']=false;
	$nuevo_location="Location: index.php";
	if(@$_SESSION['sesion_pg']){
		$db->ejecutar("update sesiones set ses_activa=false, ses_finalizada=current_timestamp where ses_ses={$_SESSION['sesion_pg']}");
	}
  }else{
	  if(@$_REQUEST['clave_anterior']){ // estoy cambiando datos
		$usuario=$usuario_logueado;
	  }else{ // estoy logueando
		$usuario=strtolower(@$_REQUEST['usuario']);
	  }
	  extract($db->preguntar_array(
				"select usu_clave, usu_rol, usu_nombre, usu_apellido from usuarios where usu_usu=:usu_usu and usu_activo"
				,array(':usu_usu'=>$usuario)));
	  $nuevo_location="Location: login.php";
	  $_SESSION['usuario_invalido']=$usuario;
	  if($usu_clave){
		if($usu_clave==md5(@$_REQUEST['clave'].$usuario) || $usu_clave==@$_REQUEST['clave'] && strlen(@$_REQUEST['clave'])!=32){
		  $_SESSION['usuario_invalido']="";
		  $_SESSION['usuario_logueado']=$usuario;
		  $_SESSION['usuario_rol']=$usuario_rol=$usu_rol;
		  if($usu_clave==$_REQUEST['clave']){
			$nuevo_location="Location: cambio_datos_usuario.php";
			$_SESSION['rta_cambio_clave']="ud. entr&oacute; con una clave provisoria, por favor elija una nueva clave";
		  }else{
			$nuevo_location="Location: index.php";
			$_SESSION['rta_cambio_clave']="";
		  }
		  $_SESSION['sesion_pg']=$db->preguntar(<<<SQL
			insert into sesiones (ses_usu, ses_phpsessid, ses_http_user_agent, ses_remote_addr) 
			  values (:ses_usu, :ses_phpsessid, :ses_http_user_agent, :ses_remote_addr) RETURNING ses_ses
SQL
		    , array(':ses_usu'=>$usuario, ':ses_phpsessid'=>session_id(), ':ses_http_user_agent'=>$_SERVER["HTTP_USER_AGENT"], ':ses_remote_addr'=>$_SERVER["REMOTE_ADDR"])
		  );
		}else if(isset($_REQUEST['clave_anterior'])){
			$clave_anterior=$_REQUEST['clave_anterior'];
			$resultado_adverso_clave="";
			$resultado_adverso_datos="";
			$nueva_clave1=$_REQUEST['clave_nueva1'];
			if(!$clave_anterior){
				$resultado_adverso_clave="No especific&oacute; la clave anterior";
			}else if($usu_clave<>md5($clave_anterior.$usuario) && $usu_clave<>$clave_anterior){
				$resultado_adverso_clave="La clave anterior no es incorrecta";
			}else if($nueva_clave1){
				if($nueva_clave1<>$_REQUEST['clave_nueva2']){
					$resultado_adverso_clave='las claves nuevas no coinciden entre s&iacute;';
				}else if(strtolower($nueva_clave1)==strtolower($usu_nombre) 
					|| strtolower($nueva_clave1)==strtolower($usu_apellido) 
					|| strtolower($nueva_clave1)==strtolower($clave_anterior)
					|| strlen($nueva_clave1)<4
				){
					$resultado_adverso_clave='la clave es muy f&aacute;cil, no debe ser igual a la anterior, ni al nombre, ni al apellido y debe tener 4 o m&aacute;s caracteres';
				}else{
					$db->ejecutar("update usuarios set usu_clave=:usu_clave where usu_usu=:usu_usu",array(":usu_usu"=>$usuario,":usu_clave"=>md5($nueva_clave1.$usuario)));
				}
			}
			if(!$resultado_adverso_clave && $_REQUEST['cambiar']=='cambiar datos personales'){ 
				$sql="update usuarios set ";
				$parametros=array(':usu_usu'=>$usuario_logueado);
				$coma=''; 
				foreach($campos_datos_personales as $campo){
					$sql.="$coma usu_$campo=:$campo";
					$parametros[":$campo"]=$_REQUEST[$campo]; 
					$coma=",";
				}
				$db->ejecutar($sql." where usu_usu=:usu_usu",$parametros);
			}
			if($resultado_adverso_clave || $resultado_adverso_datos){
				$_SESSION['rta_cambio_clave']=$resultado_adverso_clave;
				$_SESSION['rta_cambio_datos_personales']=$resultado_adverso_datos;
				$nuevo_location="Location: cambio_datos_usuario.php";
			}else{
				$nuevo_location="Location: index.php";
			}
		}
	  }
  }
  header($nuevo_location);
?>