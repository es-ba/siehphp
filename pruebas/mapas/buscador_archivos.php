<?php
//UTF-8:SÍ

date_default_timezone_set('America/Buenos_Aires');
function buscar_archivos(){        
    $dir = "./imagenes/"; 
    $dir2 = "\\imagenes\\"; 
    $extensiones= array ('bmp','jpg', 'png', 'jpeg', 'gif');
    if (is_dir($dir)) {
        if ($dh = opendir($dir)) {
            while (($file = readdir($dh)) !== false ) {
                $file_low=strtolower($file);
                if (filetype($dir.$file)=='file' 
                    and substr($file_low, 0,2)!='m_'                    
                    ){
                    $ext=calcular_extension($file_low);
                    if (in_array($ext,$extensiones)){
                        $nombre=$file;
                        $ruta=dirname(__FILE__).$dir2;                        
                        achicar($ruta, $nombre);                        
                    }
                }
            }
            closedir($dh);
        }
    }
}
buscar_archivos();
function calcular_extension($filename){
    $ext = end(explode('.', $filename));
    $ext = substr(strrchr($filename, '.'), 1);
    $ext = substr($filename, strrpos($filename, '.') + 1);
    $ext = preg_replace('/^.*\.([^.]+)$/D', '$1', $filename);
    return $ext;
    /*
    $exts = split("[/\\.]", $filename);
    $n = count($exts)-1;
    $ext = $exts[$n];
    */
}
function achicar ($ruta, $nombre, $anchura=100, $hmax=80){
    $dir_destino=dirname(__FILE__)."\\imagenes2\\";    
    if (!is_dir($dir_destino)){
        mkdir($dir_destino,0007) ; 
    }    
    $ruta_con_nombre= $ruta.$nombre;
    $datos = getimagesize($ruta_con_nombre);
    

    if($datos[2]==1){
        $img = @imagecreatefromgif($ruta_con_nombre);            
    }
    if($datos[2]==2){$img = @imagecreatefromjpeg($ruta_con_nombre);}
    if($datos[2]==3){$img = @imagecreatefrompng($ruta_con_nombre);}
    if($datos[2]==6){$img = @imagecreatefromwbmp($ruta_con_nombre);}
    $ratio = ($datos[0] / $anchura);
    $altura = ($datos[1] / $ratio);
    if($altura>$hmax){$anchura2=$hmax*$anchura/$altura;$altura=$hmax;$anchura=$anchura2;}
    $thumb = imagecreatetruecolor($anchura,$altura); 
    imagecopyresampled($thumb, $img, 0, 0, 0, 0, $anchura, $altura, $datos[0], $datos[1]);    
    $destino=dir_destino;//.nombre;
    
    if($datos[2]==1){
        header("Content-type: image/gif");
        imagegif($thumb, $destino);
    } 
    if($datos[2]==2){
        header("Content-type: image/jpeg");
        imagejpeg($thumb, $destino);
    } 
    if($datos[2]==3){
        header("Content-type: image/png");
        imagepng($thumb, $destino);         
    } 
    if($datos[2]==6){
        header("Content-type: image/bmp");
        imagwbmp($thumb, $destino);         
    } 
    imagedestroy($thumb);    
}
?>