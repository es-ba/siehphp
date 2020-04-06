<?php

namespace basicas;

class Alfa{
  function soy(){
    return "Alfa";
  }
}

$alfa = new Alfa();

echo "dentro de basicas Alfa: ".$alfa->soy()."<BR>";

use derivadas;

function Que_Derivadas_Hay(){
  $alfa=new derivadas\Alfa();
  echo "----------- ".$alfa->soy();
}

?>