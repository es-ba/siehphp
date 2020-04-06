<html manifest='ab.manifest'>
<head>
    <meta charset="UTF-8">
    <title>AB</title>
    <meta name="format-detection" content="telephone=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name='viewport' content='user-scalable=no, width=776'>
</head>
<body>
<h1>a.php V 1.34</h1>
<p id=muestra>cero:</p>
<button onclick="localStorage.setItem('guardado_prueba_ipad',''); muestra.textContent='Cero';">
volver a empezar
</button>
<button onclick='location.href="b.php"';>Vamos a la B</button>
<script>
window.addEventListener('pageshow',function(){
    muestra.textContent+="\nLoad:";
    muestra.textContent+=localStorage.getItem('guardado_prueba_ipad');
});
</script>
</body>
</html>