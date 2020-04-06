<?php

namespace principal;

date_default_timezone_set("America/Buenos_Aires");

// set_include_path('.'.PATH_SEPARATOR.'../basica');
 set_include_path('../basica');

include "basicas.php";

use basicas;

if(!@$_REQUEST['basica']){
  include "derivadas.php";
}

use derivadas\Alfa as Alfa;

$alfa=new Alfa();

echo "Principal de canasta<BR>";
echo "Alfa en principal ".$alfa->soy()."<BR>";

basicas\Que_Derivadas_Hay();
?>