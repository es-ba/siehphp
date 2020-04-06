<?php
include "es_chrome.php";
Detectar_Ipad();
if($_SESSION['ipad']){
	header("Location: menu_ipad.php");
}else{
	header("Location: menu.php");
}

?>