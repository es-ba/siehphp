<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tabla_operativos.php";
require_once "nuestro_mini_yaml_parse.php";
require_once "insertador_multiple.php";

class Metadatos_pp2012 extends Objeto_de_la_base{ 
    private $metadatos_ajus;
    function __construct(){
        parent::__construct();
        $this->definir_esquema('encu');
    }
    function ejecutar_instalacion(){
        $via_json=true;
        // $via_json=false;
        if($via_json){
            $separador=";/*FIN*/\n";
            $json=json_decode(json_arreglar(file_get_contents('..\operaciones_pp2012\pp2012_dump.json')),true);
            if(!$json){
                throw new Exception_Tedede("Error al parsear el json pp2012_dump.json. Error ".json_str_error());
            }
            $sentencias="";
            foreach($json['tablas'] as $tabla=>$contenido){
                $this->contexto->salida->enviar('Levantando el json para las tablas dependientes de '.$tabla);
                $sentencias.=json_generar_insert('encu',$tabla,$contenido,$separador,$json['jerarquia']);
            }
        }else{
            $separador=";\n";
            $sentencias=file_get_contents('..\operaciones_pp2012\migraciones\metadatos.sql');
        }
        foreach(explode($separador,$sentencias) as $sentencia){
            if($sentencia){
                $this->contexto->db->ejecutar_sql(new Sql($sentencia));
            }
        }
    }
}

class Tablas_planas extends Objeto_de_la_base{ 
    function __construct(){
        parent::__construct();
        $this->definir_esquema('encu');
    }
    function ejecutar_instalacion(){
        $tabla_matrices=$this->contexto->nuevo_objeto('Tabla_matrices');
        $tabla_matrices->leer_varios(array('mat_ope'=>$GLOBALS['NOMBRE_APP']));
        while($tabla_matrices->obtener_leido()){
            $tra_for=$tabla_matrices->datos->mat_for;
            $tra_mat=$tabla_matrices->datos->mat_mat;
            Tabla_planas::crear_jsones($this->contexto,$tra_for,$tra_mat);
            $tabla_plana=$this->contexto->nuevo_objeto("Tabla_plana_{$tra_for}_{$tra_mat}");
            $tabla_plana->ejecutar_instalacion();
        }
    }
}

?>