<?php


function IniciarSesion($opciones=array()){
/* opciones: 
	para_login: se especifica cuando es una pantalla de login para evitar el loop infinito. 
					Si no está especificado para login controla que estés logueado y si no te manda al login.php
	puede:	se especifica para indicar que necesita permisos especiales para entrar en esa pantalla. 
*/
	$usuario_logueado=$GLOBALS['usuario_logueado']='';
	$cambiar_sesion=TRUE;
	$interactivo=TRUE;
	noCacheHeaders();
	session_start();
	if(!@$opciones['para login'] && !@$_SESSION['usuario_logueado']){
		header("Location: login.php");
	}
	Detectar_ipad();
	if(isset($_SESSION['usuario_logueado']) && isset($_SESSION['usuario_rol']) ){
		$usuario_logueado=$_SESSION['usuario_logueado'];
		$usuario_rol=$_SESSION['usuario_rol'];
	}else{
		$_SESSION['usuario_logueado']=FALSE;
		$usuario_rol=$_SESSION['usuario_rol']=FALSE;
	}
	$GLOBALS['usuario_logueado']=$usuario_logueado;
	$GLOBALS['usuario_rol']=$usuario_rol;
	/*
	if(!Puede(@$opciones['puede'])){
		header("Location: index.php");
	}
	*/
}

function noCacheHeaders() {
	header("Content-Type:text/html");
	header("Cache-Control: no-store, no-cache, must-revalidate");
	header("Cache-Control: post-check=0, pre-check=0", false);
	header("Pragma: no-cache");
} 

?>