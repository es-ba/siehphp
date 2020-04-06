<html manifest='ab.manifest'>
<head>
    <meta charset="UTF-8">
    <title>AB</title>
    <meta name="format-detection" content="telephone=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name='viewport' content='user-scalable=no, width=776'>
</head>
<body>
<h1>b.php V 1.34</h1>
<p id=muestra>cero:</p>
<button onclick="localStorage.setItem('guardado_prueba_ipad',''); muestra.textContent='Cero';">
volver a empezar
</button>
<a href=b.php onclick="location.href='a.php'; event.preventDefault();">Volver a la A</a>
<script>
window.addEventListener('pageshow',function(){
    muestra.textContent+="\nLoad:";
    muestra.textContent+=localStorage.getItem('guardado_prueba_ipad');
},false);
window.addEventListener('unload',function(){
    localStorage.setItem('guardado_prueba_ipad',localStorage.getItem('guardado_prueba_ipad')+' w.unload');
},false);
window.addEventListener('beforeunload',function(){
    localStorage.setItem('guardado_prueba_ipad',localStorage.getItem('guardado_prueba_ipad')+' w.beforeunload');
},false);
window.addEventListener('offline',function(){
    localStorage.setItem('guardado_prueba_ipad',localStorage.getItem('guardado_prueba_ipad')+' w.offline');
},false);
window.addEventListener('resize',function(){
    localStorage.setItem('guardado_prueba_ipad',localStorage.getItem('guardado_prueba_ipad')+' w.resize');
},false);
window.addEventListener('pagehide',function(){
    localStorage.setItem('guardado_prueba_ipad',localStorage.getItem('guardado_prueba_ipad')+' w.pagehide');
},false);
window.addEventListener('hide',function(){
    localStorage.setItem('guardado_prueba_ipad',localStorage.getItem('guardado_prueba_ipad')+' w.hide');
},false);
</script>
</body>