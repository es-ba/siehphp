<?php
//UTF-8:SÍ
/*
   Para incluir todos los PHP. 
   
   USAR SOLO PARA PROGRAMAS QUE USAN REFLECTION. Si no incluirlas una por una
*/
function incluir_todo($path='.'){
    $recursivo=TRUE; 
    $s='/';
    if ($handle = opendir($path)) {
        while (false !== ($file = readdir($handle))) {
            if ($file != "." && $file != "..") {
                //si es un directorio lo recorremos en caso de activar la recursividad
                if(is_dir($path.$s.$file) and $recursivo) {
                    incluir_todo($path.$s.$file,true);
                } else {
                    $ext = substr(strtolower($file),-3);
                    if($ext == 'php' and $file!='index.php'){
                        require_once($path.$s.$file);
                    }
                }
            }
        }
        closedir($handle);
    }
}

?>