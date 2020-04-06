<?php

function es_chrome(){
	return strpos($_SERVER["HTTP_USER_AGENT"],"Chrome")>0;
}

function Detectar_ipad(){
	if(@$_SERVER["HTTP_USER_AGENT"]){
		$_SESSION["ipad"]=$ipad=(strpos($_SERVER["HTTP_USER_AGENT"],'iPad')>0 || $_SERVER["REMOTE_ADDR"]=="10.30.1.167x");
		if($ipad){
		  $so_png="ipad.png";
		}else if(strpos($_SERVER["HTTP_USER_AGENT"],'iPod')){
		  $so_png="ipod.png";
		  $_SESSION["ipad"]=$ipad=1;
		}else if(strpos($_SERVER["HTTP_USER_AGENT"],'Windows NT 6.1')){
		  $so_png="windows7.png";
		}else if(strpos($_SERVER["HTTP_USER_AGENT"],'Windows NT 6.0')){
		  $so_png="windowsVista.png";
		}else if(strpos($_SERVER["HTTP_USER_AGENT"],'Windows NT 5.0')){
		  $so_png="windows2000.png";
		}else if(strpos($_SERVER["HTTP_USER_AGENT"],'Windows NT 5.1')){
		  $so_png="windowsxp.png";
		}else if(strpos($_SERVER["HTTP_USER_AGENT"],'Windows NT 5.2')){
		  $so_png="windows2003.png";
		}else if(strpos($_SERVER["HTTP_USER_AGENT"],'Windows NT')){
		  $so_png="windows.png";
		}else{
		  $so_png="pc.png";
		}
	}else{
		$ipad=false;
		$so_png="pc.png";
	}
}

?>