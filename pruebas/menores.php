<?php
$array1 = array("color" => "red", 2, 4);
$array2 = array("a", "b", "color" => "green", "shape" => "trapezoid", 4);
$result = array_merge($array1, $array2);
echo "<pre>";
print_r($array1);
print_r($result);
$array1 = array('a'=>'prima',"uno","dos","tres");
$array2 = array('a'=>'seca',"cuatro","cinco","seis");
$result = array_merge($array1, $array2);
print_r($result);
?>