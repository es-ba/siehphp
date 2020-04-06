<body>
<p>probando grabar backup v2</p>
<div id=contenido contenteditable style='border:1px solid green; min-height:100px; min-width:100px'>

</div>
<button onclick='guardar_info()'>
guardar
</button>
<button onclick='recuperar_info()'>
recuperar
</button>
<script>

function mostrar(esto){
    document.write('<br>'+esto+': '+eval(esto));
}
mostrar('window.webKitStoreWebDataForBackup');
mostrar('navigator.webKitStoreWebDataForBackup');
mostrar('document.webKitStoreWebDataForBackup');

function guardar_info(){
    console.log('pap 1');
    window.webkitStorageInfo.requestQuota(PERSISTENT, 1024*1024*5, function(grantedBytes) {
    console.log('pap 2');
      window.webkitRequestFileSystem(PERSISTENT, grantedBytes, function(fs){
    console.log('pap 3');
          fs.root.getFile('log.txt', {create: true}, function(fileEntry) {
            // Create a FileWriter object for our FileEntry (log.txt).
            fileEntry.createWriter(function(fileWriter) {
              fileWriter.onwriteend = function(e) {
                console.log('Write completed.');
              };
              fileWriter.onerror = function(e) {
                console.log('Write failed: ' + e.toString());
              };
              // Create a new Blob and write it to log.txt.
              var blob = new Blob([contenido.textContent], {type: 'text/plain'});
              fileWriter.write(blob);
            }, errorHandler);
          }, errorHandler);
      }, errorHandler); 
    }, function(e) {
      console.log('Error', e); 
    });
}
    
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

// dibujo.longDesc='Descripción muy larga donde voy a hacer el backup';
</script>
</body>