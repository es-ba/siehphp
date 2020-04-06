<html>
<head>
</head>
<body>
<script> 
function desplegar_extender_texto(este){
    if(!document.getElementById('contenedor_extender_texto')){
        var textoarea = document.createElement('textarea');
        textoarea.value = este.value;
        textoarea.onkeyup = function(){ return extender_elemento_al_contenido(this); }
        textoarea.onblur = function(){
            este.value = textoarea.value;
            padre = textoarea.parentNode;
            padre.removeChild(textoarea);
        }
        textoarea.id = 'contenedor_extender_texto';
        document.body.appendChild(textoarea);
        extender_elemento_al_contenido(textoarea);
        textoarea.style.position = 'fixed';
        textoarea.style.left = (este.offsetLeft + 10) + 'px';
        textoarea.style.top = (este.offsetTop + 10) + 'px';
        textoarea.focus();
    }
}
function extender_elemento_al_contenido(esto){
    while (
        esto.rows > 1 &&
        esto.scrollHeight < esto.offsetHeight
    ){
        esto.rows--;
    }
    var h=0;
    while (esto.scrollHeight > esto.offsetHeight && h!==esto.offsetHeight)
    {
        h=esto.offsetHeight;
        esto.rows++;
    }
    esto.rows++    
}
</script>
<form>
    <input type='text' id='el_input' value='texto default' onclick='desplegar_extender_texto(this);'/><br />
    <input type='text' id='el_input' value='texto adicinal' onclick='desplegar_extender_texto(this);'/>
    <br />
    <input type='text' id='el_input' value='texto adicinal' onclick='desplegar_extender_texto(this);'/>
    <br />
    <input type='text' id='el_input' value='texto adicinal' onclick='desplegar_extender_texto(this);'/>
    <br />
    <input type='text' id='el_input' value='texto adicinal' onclick='desplegar_extender_texto(this);'/>
    <br />
    <input type='text' id='el_input' value='texto adicinal' onclick='desplegar_extender_texto(this);'/>
    <br />
    <input type='text' id='el_input' value='texto adicinal' onclick='desplegar_extender_texto(this);'/>
    
</form>
</body>
</html>