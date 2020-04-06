<html>
<head>
<title>prueba de onblur</title>
<style>
td{
    border:1px solid gray;
    min-width:60px;
}
</style>
</head>
<body>
<table>
<tr><td contenteditable>1<td contenteditable>2<td contenteditable>3
<tr><td contenteditable>4<td contenteditable>5<td contenteditable>6
</table>
<p>blur tr:<span id=blur_tr></span></p>
<p>blur td:<span id=blur_td></span></p>
<p>focus tr:<span id=focusout_tr></span></p>
<p>focus td:<span id=focusout_td></span></p>
<script>
function AgregarEvento(tipo_elemento,elemento,evento){
    elemento.addEventListener(evento,function(){
        document.getElementById(evento+'_'+tipo_elemento).textContent+=' '+this.textContent;
    });
}

function preVisualizarOnBlur(tipo_elemento){
    var elementos=document.querySelectorAll(tipo_elemento);
    for(var i=0; i<elementos.length; i++){
        var elemento=elementos[i];
        AgregarEvento(tipo_elemento,elemento,'blur');
        AgregarEvento(tipo_elemento,elemento,'focusout');
    }
}
window.addEventListener('load',function(){
    preVisualizarOnBlur('td');
    preVisualizarOnBlur('tr');
});
</script>
</body>
</html>