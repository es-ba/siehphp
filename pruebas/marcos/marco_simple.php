<html>
<body>
<div style='background-color:lightgreen; height:400px; overflow:hidden'>
algo
<?php
muchos_numeros();
?>
<div style='position:absolute; left:64px; top:64px; background-color:lightcyan; height:336px; overflow:scroll'>
algo adentro muy pero muy ancho
<?php
muchos_numeros();
?>
</div>
</div>
<?php
function muchos_numeros(){
    $i=0;
    while($i<1000){
        echo "<p>$i</p>";
        $i++;
    }
}
?>
</body>
</html>