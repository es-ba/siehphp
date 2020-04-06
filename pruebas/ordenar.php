<?php

?>
<p>probando javascript</p>
<script>
var datos={
    strings:['hola','che'],
    objetos:[['dos','tres'],['dos','cuatro']],
    objetos2:[['dos','cuatro'],['dos','tres']],
    objetos3:[['dos','cuatro'],['dos','tres xxxxxxxxxxxxxx']]
};

for(var i in datos){
    var elementos=datos[i];
    document.write('<p>'+JSON.stringify(elementos[0])+', '+JSON.stringify(elementos[1])+' da '+(elementos[0]<elementos[1])+'<p>');
}

</script>