<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";

class Nodo_Totalizador{
    public $padre;
    function __construct($arreglo_con_nombres_de_variables){
        foreach($arreglo_con_nombres_de_variables as $nombre){
            $this->$nombre=0;
        }
    }
}

class Totalizador{
    private $arreglo_con_nombres_de_variables;
    private $nodo;
    function __construct($arreglo_con_nombres_de_variables){
        $this->nodo=new Nodo_Totalizador($arreglo_con_nombres_de_variables);
        $this->arreglo_con_nombres_de_variables=$arreglo_con_nombres_de_variables;
    }
    function abrir_grupo_interno(){
        $nuevo=new Nodo_Totalizador($this->arreglo_con_nombres_de_variables);
        $nuevo->padre=$this->nodo;
        $this->nodo=$nuevo;
    }
    function cerrar_grupo_interno(){
        if(!$this->nodo->padre){
            throw new Exception_Tedede("No se puede cerrar un grupo si no se abrio previamente");
        }
        foreach($this->arreglo_con_nombres_de_variables as $nombre){
            $this->nodo->padre->$nombre+=$this->nodo->$nombre;
        }
        $this->nodo=$this->nodo->padre;
    }
    public function __set($name, $value){
        $this->nodo->$name = $value;
    }
    public function __get($name){
        return $this->nodo->$name;
    }
}

class Prueba_totalizador extends Pruebas{
    function probar_sumar_unos(){
        $totalizador=new Totalizador(array('alfa','beta'));
        $totalizador->alfa++;
        $totalizador->beta+=2;
        $this->probador->verificar(1,$totalizador->alfa);
        $this->probador->verificar(2,$totalizador->beta);
    }
    function probar_subtotalizar(){
        $totalizador=new Totalizador(array('alfa','beta'));
        $totalizador->alfa=1;
        $totalizador->beta+=3;
        $totalizador->abrir_grupo_interno();
        $this->probador->verificar(0,$totalizador->alfa);
        $totalizador->alfa+=1;
        $this->probador->verificar(1,$totalizador->alfa);
        $totalizador->cerrar_grupo_interno();
        $this->probador->verificar(2,$totalizador->alfa);
    }
    function probar_error_al_cerrar_de_mas(){
        $totalizador=new Totalizador(array('alfa','beta'));
        try{
            $totalizador->cerrar_grupo_interno();
            $this->probador->informar_error("Debe saltar una excepción si se cierra un grupo que no se abrió");
        }catch(Exception_Tedede $e){
            // Correcto, debe saltar la excepción
        }
    }
}



?>