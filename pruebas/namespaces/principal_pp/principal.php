<?php

namespace principal;

date_default_timezone_set("America/Buenos_Aires");

set_include_path('../basica');

include "basicas.php";

use basicas;

if(!@$_REQUEST['basica']){
  include "derivadas.php";
}

use derivadas\Alfa as Alfa;

$alfa=new Alfa();

echo "Principal de PP<BR>";
echo "Alfa en principal ".$alfa->soy();
?>