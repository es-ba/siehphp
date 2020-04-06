<?php
class RecDir{
  protected $currentPath;
  protected $slash;
  protected $rootPath;
  protected $recursiveTree;   

  function __construct($rootPath,$win=false){
    switch($win){
        case true:
          $this->slash = '\\';
          break;
        default:
          $this->slash = '/';
    }
      $this->rootPath = $rootPath;
      $this->currentPath = $rootPath;
      $this->recursiveTree = array(dir($this->rootPath));
      $this->rewind();
  }

  function __destruct(){
      $this->close();
  }

  public function close(){
    while(true === ($d = array_pop($this->recursiveTree))){
         $d->close();
    }
  }

  public function closeChildren(){
    while(count($this->recursiveTree)>1 && false !== ($d = array_pop($this->recursiveTree))){
         $d->close();
         return true;
    }
    return false;
  }

  public function getRootPath(){
    if(isset($this->rootPath)){
         return $this->rootPath;
    }
    return false;
  }

  public function getCurrentPath(){
      if(isset($this->currentPath)){
         return $this->currentPath;
      }
      return false;
  }
   
  public function read(){
    while(count($this->recursiveTree)>0){
      $d = end($this->recursiveTree);
      if((false !== ($entry = $d->read()))){
        if($entry!='.' && $entry!='..'){
          $path = $d->path.$entry;
          if(is_file($path) && substr($path, -3, 3)=='fun'){
                  //return substr($path, -3, 3);
            return $path;
          }
          elseif(is_dir($path.$this->slash)){
            $this->currentPath = $path.$this->slash;
            if($child = @dir($path.$this->slash)){
              $this->recursiveTree[] = $child;
            }
          }
        }
      }
      else{
        array_pop($this->recursiveTree)->close();
      }
    }
    return false;
  }

   public function rewind(){
     $this->closeChildren();
     $this->rewindCurrent();
   }

   public function rewindCurrent(){
      return end($this->recursiveTree)->rewind();
   }
}

function obtener_todos_fun($buscar_en){
  $listado_todos_fun = array();
  $d = new RecDir($buscar_en,false);
  //echo "Path: " . $d->getRootPath() . "\n";
  while (false !== ($archivo = $d->read())) {
     //echo $archivo."\n";
     $rutainfo = pathinfo($archivo);
     $una_fun = array ('nombre_archivo' => $rutainfo['basename'],
                       'carpeta'        => $rutainfo['dirname'],
                       'modificacion'   => date("Y m d H:i:s", fileatime($archivo)),
                       'contenido'      => "");
     array_push($listado_todos_fun,$una_fun);
  }
  $d->close();
  return $listado_todos_fun;
}

function obtener_ultima_fecha($arreglo) {
  $minfecha = date("Y m d H:i:s");
  foreach ($arreglo as $elemento){
    if ($elemento['modificacion'] < $minfecha)
      $minfecha = $elemento['modificacion'];
  }
  return $minfecha;
}

function leer_contenido_fun($arreglo, $fecha_desde) {
  foreach ($arreglo as $clave=>$elemento){
     if ($elemento['modificacion'] >= $fecha_desde) {
        $archivo = $elemento['carpeta'].'/'.$elemento['nombre_archivo'];
        $elemento['contenido'] = file_get_contents($archivo);
        $arreglo[$clave] = $elemento;
     }
  }
  return $arreglo;
}

date_default_timezone_set('America/Argentina/Buenos_Aires');
$funciones = array();
$funciones = obtener_todos_fun("C:/");
$ultimafecha = obtener_ultima_fecha($funciones);
$funcionescontenido = leer_contenido_fun($funciones, $ultimafecha);
var_dump($funcionescontenido);

?>