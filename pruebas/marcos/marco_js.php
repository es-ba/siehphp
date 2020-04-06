<html>
<body>
<div id=barra_superior style='background-color:lightgreen; height:64px; width:100%; margin:0px; position:relative; top:0'>
algo que queremos que esté arriba de todo.!wxx tsd
</div>
<div style='background-color:lightcyan;'>
algo adentro muy pero muy ancho
<?php
muchos_numeros();
?>
</div>
</div>
<script>
document.ontouchstart=function(){
    var barra_superior=document.getElementById('barra_superior');
    barra_superior.style.visibility='hidden';
}
document.ontouchend=function(e){
    var barra_superior=document.getElementById('barra_superior');
    if(!e.touches.length){
        barra_superior.style.visibility='visible';
    }
}
window.onscroll=function(e){
    var barra_superior=document.getElementById('barra_superior');
    barra_superior.style.top=window.scrollY;
}
</script>
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