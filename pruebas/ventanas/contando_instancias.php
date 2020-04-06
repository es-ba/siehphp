<!DOCTYPE HTML>
<title>Probando comunicación entre ventanas</title>
<h1>Viendo ventanas</h1>
<p>ver status<button onclick='ver_status()'>ahora</button></p>
<p>dos inputs<input id=uno><input id=dos></p>
<pre id="log">Log:</pre>
<script>
  var worker = new SharedWorker('cuantas_instancias.js');
  var log = document.getElementById('log');
  worker.port.addEventListener('message',function(e){ 
    log.textContent += '\n' + JSON.stringify(e.data);
    if(e.data.asignar_id){
        worker.port.asignar_id=e.data.asignar_id;
        log.textContent += '\nMi id:' + worker.port.asignar_id;
    }
  });
  worker.port.start();
  window.addEventListener('unload',function(){ 
    worker.port.postMessage({accion:'desconectar',id_desconectando:worker.port.asignar_id});
  });
  function ver_status(){
    worker.port.postMessage({accion:'status'});
  }
  /* Pruebo que me avise sin tener que preguntarle
  window.addEventListener('focus',function(){ 
    log.textContent += '\nFoco en la ventana';
    ver_status();
  });
  */
  uno.addEventListener('focus',function(){ 
    log.textContent += '\nFoco en uno';
  });
  dos.addEventListener('focus',function(){ 
    log.textContent += '\nFoco en dos';
  });
</script>