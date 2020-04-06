<?php

include "lo_necesario.php";
IniciarSesion();
$tipo=@$_REQUEST['tipo'];
$str='';
switch($tipo){
	case 'soporte':
		$todo=json_decode($_REQUEST['todo'],true);
		switch($todo['tipo']){
			case 'pedido_alta_usuario':
				$todo['parametros']['activo']=true;
				// $todo['parametros']['rol']=$usuario_rol;
				$tabla='usuarios';
				$prefijo_campo='usu_';
				$coma='';
				$sql1="insert into $tabla (";
				$sql2=") values (";
				$parametros=array();
				foreach($todo['parametros'] as $campo=>$valor){
					$sql1.="$coma {$prefijo_campo}{$campo}";
					$sql2.="$coma :$campo";
					if($valor==''){
						$valor=null;
					}
					$parametros[":$campo"]=$valor;
					$coma=',';
				}
				try{
					$db->ejecutar($sql1.$sql2.")", $parametros);
					RespuestaEnviar(true,"cargado");
				}catch(Exception $e){
					RespuestaEnviar(false,$e->getMessage());
				}
				break;
			default:
				RespuestaEnviar(false,"no existe el tipo {$todo['tipo']}");
		}
		die();
	break;
	case 'pedido_alta_usuario':
		if(Puede('crear','usuarios')){
			$roles=$este_rol_contiene?:array($usuario_rol=>true);
			$mostrar_roles=array();
			foreach($roles as $rol=>$va){
				if($va || $usuario_rol=='programador'){
					$mostrar_roles[]=$rol;
				}
			}
			$datos=array(
				'titulo'=>'Formulario de pedido de alta de usuarios'
				, 'campos'=>array(
					'usu'=>array('nombre'=>'usuario', 'aclaracion'=>'@buenosaires.gob.ar', 'onblur'=>"elemento_existente('mail').value=elemento_existente('usu').value+'@buenosaires.gob.ar';")
					, 'nombre'=>array()
					, 'apellido'=>array()
					, 'clave'=>array('nombre'=>'clave provisoria', 'aclaracion'=>'el usuario deberá cambiarla la primera vez que ingrese')
					, 'interno'=>array('nombre'=>'interno o teléfono')
					, 'mail'=>array('aclaracion'=>'confirmar que use el mail del dominio')
					, 'rol'=>array('lista'=>$mostrar_roles)
					, 'verifico'=>array('no_pasar'=>true, 'tipo'=>'checkbox', 'aclaracion'=>'sé que el usuario al que le estoy pidiendo una cuenta debe tener el rol que determinan los permisos para acceder a este sistema')
				)
			);
		}
		break;
	default:
	EnviarStrAlCliente('Formulario interno no definido');
	die();
}

$str.=<<<HTML
	<h1>{$datos['titulo']}</h1>
	<form id=formulario_interno><table>
HTML;
foreach($datos['campos'] as $campo=>$def){
	$str.="<tr><td><label for='$campo'>";
	$str.=(@$def['nombre']?:$campo);
	$str.="<td>";
	if(@$def['lista']){
		$str.="<select";
	}else{
		$str.="<input type=";
		$str.=(@$def['tipo']?:'text');
	}
	$str.=" id='$campo'";
	if(@$def['onblur']){
		$str.=' onblur="'.$def['onblur'].'"';
	}
	if(@$def['no_pasar']){
		$str.='no_pasar=no_pasar';
	}
	$str.="> &nbsp;";
	if(@$def['lista']){
		foreach($def['lista'] as $elemento){
			$str.="<option value='$elemento'>$elemento</option>\n";
		}
		$str.="</select>";
	}
	if(@$def['aclaracion']){
		$str.=$def['aclaracion'];
	}
	$str.="</tr>\n";
}
$str.="<tr><td><td><input type=button value=Aceptar onclick=\"enviar_formulario_interno('$tipo')\" no_pasar=no_pasar>";
$str.="</table>\n";

EnviarStrAlCliente($str);

?>