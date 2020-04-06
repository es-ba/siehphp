<?php

if(@$_REQUEST['bajar']){
    file_put_contents('bajar.txt',$_REQUEST['bajar']);
    echo "bajado";
}else{
    echo "<form method=post><input name=bajar type=textarea><input type=submit bajar></form>";
}

?>