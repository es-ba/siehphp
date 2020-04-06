<?php

// Si esta fuera la parte manual y hubiera otra generada, la generada tendría que incluirse dentro de la clase

class Mi_Clase{
include "generado.php";
    function __construct(){
        echo "<br>se construye";
        $this->constructor_generado();
        include "incluido_basico.php";
    }
    function hola(){
        echo "<br>saludar";
        $this->saludo();
    }
    function __call($esta,$args){
        echo "<br> no encontre '$esta'";
    }
}

$mi_clase=new Mi_Clase();
$mi_clase->hola();
?>