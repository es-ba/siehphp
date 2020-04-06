<?php
include "lo_necesario.php";
IniciarSesion();
$str="";
$p_desde_bolsa=@$_REQUEST['p_desde_bolsa']?:0;
$p_hasta_bolsa=@$_REQUEST['p_hasta_bolsa']?:0;

if(@$_REQUEST["opok"]){
    $str.=<<<HTML
    <script>
    document.onload=alert('Los cambios se realizaron con exito.');
    </script>
HTML;
}
if(@$p_desde_bolsa && @$p_hasta_bolsa) {
    $str.=<<<HTML
    <br>
    <h2>Bolsas a reabrir</h2>
    <form id=pasar_a_estado24 name=pasar_a_estado24>
    <table>
HTML;
    
    $poner_read_only="readonly='readonly'";
    
    $str.=<<<HTML
            <tr><td><label for='desde_bolsa' > Desde bolsa Nº: </label><td><input type='text' name='p_desde_bolsa'  value='' id='desde_bolsa' $poner_read_only id='desde_bolsa' style='width:90px'>
            <tr><td><label for='hasta_bolsa' > Hasta bolsa Nº: </label><td><input type='text' name='p_hasta_bolsa'  value='' id='hasta_bolsa' $poner_read_only id='hasta_bolsa' style='width:90px'>            
            <br><br><br></tr>
HTML;



$respuestas=$db->preguntar_array(
        <<<SQL
            select 1 as existe, bolsa,estado
            from yeah_2011.tem11 
            where bolsa >= :p_desde_bolsa and bolsa <= :p_hasta_bolsa
SQL
        ,
        array(':p_desde_bolsa' => $p_desde_bolsa
        , ':p_hasta_bolsa' => $p_hasta_bolsa
        )
    );
    $respuesta=$respuestas['existe'];
    
    $respuesta_estado =$respuestas['estado'];
    if ($respuesta >0){
        $str.="<TABLE BORDER=1 cellspacing=0>"; 
        try {
            $respuesta=$db->preguntar(
            <<<SQL

            select yeah_2011.reabrir_bolsas(:p_desde_bolsa,:p_hasta_bolsa)
SQL
            ,
                array(':p_desde_bolsa' => $p_desde_bolsa
                , ':p_hasta_bolsa' => $p_hasta_bolsa
                )
            );
            $str.="<TR><TD>estado             </TD><TD>$respuesta_estado</TD></TR>"; 
            $str.="</TABLE><br>"; 
            header("Location: pasar_a_estado24.php?opok=ok");
            $str.="<input name=procesar type=submit value='volver' > ";
        } catch (Exception $e) {
                $str.="<p>Error durante el paso de estado - \"". $e->getMessage(). "\"</p>\n";
        }
        
    }else{
        
        $str=str_replace('Bolsas a reabrir',"<a href='pasar_a_estado24.php'>Bolsa no encontrada click aqui para Reingresar</a> ",$str);
    }
}else{
    $str.=<<<HTML
        <br>
        <h2>Bolsas a reabrir</h2>
        <form id=pasar_a_estado24 name=pasar_a_estado24>
        <table>
HTML;
    $str.=<<<HTML
            <tr><td><label for='desde_bolsa' > Desde bolsa Nº: </label><td><input type='text' name='p_desde_bolsa'  value='' id='desde_bolsa' style='width:90px'>            
            <tr><td><label for='hasta_bolsa' > Hasta bolsa Nº: </label><td><input type='text' name='p_hasta_bolsa'  value='' id='hasta_bolsa' style='width:90px'>            
HTML;
    $str.=<<<HTML
    <tr><td><td><input name='pasar' type=submit value='realizar cambio' >
    </table>
    </form>
HTML;
}

EnviarStrAlCliente($str);
?>