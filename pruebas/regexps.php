<?php
function encabezar_error(&$ya_mostro_error,$expresion){
    if(!$ya_mostro_error){
        $ya_mostro_error=true;
        echo "<li><b>errores en</b> $expresion<ul>";
    }
}

function probar($expresion, $esperado, $unico=true){
    $expresion=substr($expresion,1);
    $regexp_divididor='/([|&()])/';
    $regexp_expresiones_filtro='/^\s*((?P<conector>[|&()])|(?P<nombre>\d*)\s*(?P<negar>!?)((?P<null>(null|vacio|todo))|(?P<posicional>@?)(?P<operador>[=<>~*]+|like) *((?P<variable>#\d+)|(?P<operando>[^&]*)))\s*)$/';
    if($unico){
        $varios_esperados=array($esperado);
    }else{
        $varios_esperados=$esperado;
    }
    $porciones=preg_split($regexp_divididor,$expresion,-1,PREG_SPLIT_DELIM_CAPTURE);
    // echo "<li> ******* $expresion -=-=-=> ".json_encode($porciones);
    foreach($porciones as $cual=>$porcion){
        $matchea=preg_match($regexp_expresiones_filtro, $porcion, $matches);
        // echo "<li> ******************** $porcion ---> ".json_encode($matches);
        if(!$matchea){
            if($esperado!='no debe machear'){
                echo "<li><B>No machea</b> $expresion";
            }
        }else{
            $esperado=$varios_esperados[$cual];
            if($esperado=='no debe machear'){
                echo "<li><B>NO DEBIA MACHEAR</b> $expresion";
            }else{
                $ya_mostro_error=false;
                foreach($matches as $que=>$tiene){
                    if(!is_numeric($que)){
                        if(!isset($esperado[$que])){
                            if($tiene){
                                encabezar_error($ya_mostro_error,$expresion);
                                echo "<li> falta en esperado $que: $tiene";
                            }
                        }else if($esperado[$que]!=$tiene){
                            encabezar_error($ya_mostro_error,$expresion);
                            echo "<li> distinto en $que:'{$esperado[$que]}'!='$tiene'";
                        }
                    }
                }
                foreach($esperado as $que=>$tiene){
                    if(!isset($matches[$que])){
                        encabezar_error($ya_mostro_error,$expresion);
                        echo "<li> falta en matches $que: $tiene";
                    }
                }
                if($ya_mostro_error){
                    echo "  [matchea: $matchea] <small>".json_encode($matches)."</small>";
                    echo "</ul>";
                }
            }
        }
    }
}

probar("lo que no machea y se muestra asi",array());
probar("#>Esto",array('operador'=>'>','operando'=>'Esto'));
probar("#>Esto",array('operador'=>'>','operando'=>'Esto','negar'=>false));
probar("#!=7",array('operador'=>'=','operando'=>'7','negar'=>true));
probar("#null",array('null'=>true));
probar("#vacio",array('null'=>'vacio'));
probar("#7!<>algo",array('nombre'=>'7','negar'=>true,'operador'=>'<>','operando'=>'algo'));
probar("#>#5",array('operador'=>'>','variable'=>'#5'));
probar("#null>=5",'no debe machear');
probar("·7 null",array('nombre'=>'7','null'=>'null'));
probar("#like abd%",array('operador'=>'like','operando'=>'abd%'));
probar("#@>#5",array('operador'=>'>','variable'=>'#5','posicional'=>true));
// probar("#@entre 5 y bajo",array('entre'=>'entre','operando1'=>'5','posicional'=>true,'operando2'=>'bajo'));
probar("#@> #5 & <=23",array(array('operador'=>'>','variable'=>'#5','posicional'=>true),array('conector'=>'&'),array('operador'=>'<=','operando'=>'23')),false);
probar("#@>15&<=23",array(array('operador'=>'>','operando'=>'15','posicional'=>true),array('conector'=>'&'),array('operador'=>'<=','operando'=>'23')),false);

?>