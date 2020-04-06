<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";

class Proceso_reporte_errores extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Reporte de errores',
            'submenu'=>PROCESO_INTERNO,
            'permisos'=>array('grupo'=>'programador'),
            'parametros'=>array(
                'tra_file'=>array('id'=>'tra_file','tipo'=>'texto','label'=>'nombre del archivo','def'=>'c:\prueba_de_error.txt'),
                'tra_line'=>array('id'=>'tra_line','tipo'=>'texto','label'=>'número de linea'),
            ),
            'boton'=>array('id'=>'responder','value'=>'crear archivo .bat'),
        ));
    }   
    function responder(){
        $nom_file=$this->argumentos->tra_file;
        $num_line=$this->argumentos->tra_line;
        $existe_archivo=file_put_contents('..\logs\log_error.bat',
            '@ECHO OFF
cd C:\Archivos de programa\Notepad++
notepad++.exe '.$nom_file.' -n'. $num_line.'
');
        if(!$existe_archivo){
            return new Respuesta_Negativa('No existe el archivo');
        }else{
            return new Respuesta_Negativa('archivo '.$nom_file.' linea '.$num_line);
        }
    }    
}
    
?>