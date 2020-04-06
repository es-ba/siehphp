<?php
echo <<<HTML
<html>
<head>
<title>prueba de cuadros</title>
 <LINK href="cuadros.css" rel="stylesheet" type="text/css">

</head>
<body>
<script src='comunes.js'></script>
<script src='casos_prueba.js'></script>
<script src='tedede_cm.js'></script>
<script src='tedede_cm_pr.js'></script>
<script src='para_cuadros.js'></script>
HTML;
// conexion a la base de datos
include "conexion.php";

$db->query("set search_path=cvp,public");

$sql = <<<SQL
 SELECT * from cvp.res_cuadro_iivv('Nivel general, bienes y servicios', 'a2012m11'::text, 1, 'S'::text, false); 
SQL;

$resultado=array();

foreach ($db->query($sql,PDO::FETCH_OBJ) as $row) {
    $resultado[]=$row;
    // para debug:
   // print '<p>'.json_encode($row).'</p>';
}

// $resultado tiene todo el resultado
// $resultado_jsoneado=str_replace('\\','\\\\',json_encode($resultado));
$resultado_jsoneado=json_encode($resultado);

echo <<<HTML
<hr>

<script>
mostrar_ejemplos();
var cuadro=$resultado_jsoneado;
mostrar_cuadro(cuadro);
</script>
<hr>
<!--
<h2>casos de prueba</h2>
-->
<script>
probar_todo();
</script>
</body>
</html>
HTML;
?>