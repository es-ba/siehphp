<body>
<p>probando subir fotos con permiso</p>
<div id=contenido contenteditable style='border:1px solid green; min-height:100px; min-width:100px'>

</div>
<button onclick='subir_imagen()'>
subir
</button>
<img id=dibujo src=dibujo.png name='este es un título que todavía no es largo pero es donde pretendo hacer el backup si me deja' alt='texto alternativo'>
<canvas id="myCanvas" width="302" height="302" style="border:1px solid #d3d3d3;">
Your browser does not support the HTML5 canvas tag.
</canvas>
<img id=red_dot  alt="Red dot" src="punto_azul.png" style='width:100px; height:100px; border:1px solid red'>
<input type=file name=imagen_a_subir>
<pre>
<?php
$contenido=file_get_contents('lafoto.PNG');
echo base64_encode($contenido);
?>
</pre>
así era:
<pre>
iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==
</pre>

<script>
red_dot.src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA"+
"AAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO"+
"9TXL0Y4OHwAAAABJRU5ErkJggg==";

window.webkitStorageInfo.requestQuota(PERSISTENT, 1024*1024*5, function(grantedBytes) {
  window.webkitRequestFileSystem(PERSISTENT, grantedBytes, function(){
  }, errorHandler); 
}, function(e) {
  console.log('Error', e); 
});

function subir_imagen(){
   // window.webkitNotifications.requestPermission(subir_imagen_con_permiso);
   subir_imagen_con_permiso();
}

function subir_imagen_con_permiso(){
var c=document.getElementById("myCanvas");
console.log('pap 1');
var ctx=c.getContext("2d");
console.log('pap 2');
var img=document.getElementById("contenido").firstChild;
console.log('pap 3');
ctx.drawImage(img,10,10);
console.log('pap 4');
var datos=ctx.getImageData(1,1,300,300);
console.log('pap 5');
  var peticion=new XMLHttpRequest();
console.log('pap 6');
  try{
    peticion.onreadystatechange=function(){
      switch(peticion.readyState) { 
        case 4: 
          try{
            var xml = peticion.responseXML;
            alert('ok');
          }catch(err){
            alert('error '+err.description);
          }
      }
    }
    var destino='recibir.php';
console.log('pap 7');
    peticion.open('POST', destino, true); 
console.log('pap 8');
    peticion.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
console.log('pap 9');
    var parametros='imagen='+encodeURIComponent(contenido.innerHTML)+
        '&total='+encodeURIComponent(document.firstChild.innerHTML)+
        '&canvas='+encodeURIComponent(myCanvas.innerHTML)+
        '&id='+encodeURIComponent(JSON.stringify(datos));
    peticion.send(parametros);
  }catch(err){
    por_error(err.description);
  }
}

dibujo.longDesc='Descripción muy larga donde voy a hacer el backup';
</script>
</body>