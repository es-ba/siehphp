<?php
include "lo_necesario.php";
IniciarSesion();
$str="";
$p_encuesta=@$_REQUEST['p_encuesta']?:0;
$p_id=@$_REQUEST['p_id']?:0;

if(@$_REQUEST["opok"]){
    $str.=<<<HTML
    <script>
    document.onload=alert('Los cambios se realizaron con exito. Nuevo estado={$_REQUEST["opok"]}');
    </script>
HTML;
}

if(@$_REQUEST["procesar"]){
    $p_deshacer_fin_ing   = 'false';  
    $p_deshacer_anal_ing   = 'false';  
    $p_deshacer_anal_campo = 'false';
    $p_deshacer_anal_proc  = 'false';
    if (isset($_REQUEST['p_deshacer_fin_ing'])) {
        $p_deshacer_fin_ing   = 'true';  
    } else {
        $p_deshacer_fin_ing   = 'false';  
    }
    if (isset($_REQUEST['p_deshacer_anal_ing'])) {
        $p_deshacer_anal_ing   = 'true';  
    } else {
        $p_deshacer_anal_ing   = 'false';  
    }
    if (isset($_REQUEST['p_deshacer_anal_campo'])) {
        $p_deshacer_anal_campo = 'true';
    } else {
        $p_deshacer_anal_campo = 'false';
    }
    if (isset($_REQUEST['p_deshacer_anal_proc'])) {
        $p_deshacer_anal_proc  = 'true';
    } else {
        $p_deshacer_anal_proc  = 'false';
    }
    try {
            if (isset($_REQUEST['p_deshacer_fin_ing'])=="on" || isset($_REQUEST['p_deshacer_anal_ing'])=="on" || isset($_REQUEST['p_deshacer_anal_campo'])=="on" || isset($_REQUEST['p_deshacer_anal_proc'])=="on"){
                    $respuesta=$db->preguntar(
                    <<<SQL
                        select yeah_2011.reabrir_encuesta(:p_encues,:p_id,$p_deshacer_fin_ing,$p_deshacer_anal_ing,$p_deshacer_anal_campo,$p_deshacer_anal_proc)
SQL
                    ,
                    array(':p_encues' => $p_encuesta
                        , ':p_id' => $p_id
                    )
                );
                $nuevo_estado=$db->preguntar(
                    <<<SQL
                        select estado
                          from yeah_2011.tem11 
                          where encues = :p_encues and id_proc = :p_id 
SQL
                    ,
                    array(':p_encues' => $p_encuesta
                        , ':p_id' => $p_id
                    )
                );
                header("Location: reabrir_encuesta.php?opok=".$nuevo_estado);
            }else{
                            
                $str.=<<<HTML
                <script>
                    document.onload=alert('No se realizo ningun cambio');
                </script>
HTML;
            }
    } catch (Exception $e) {
                $str.="<p>Error durante la reapertura de la encuesta - \"". $e->getMessage(). "\"</p>\n";
    }
}
if(@$p_encuesta){
    $str.=<<<HTML
    <br>
    <h2>Reabrir encuesta para deshacer analisis</h2>
    <form id=reabrir_encuesta name=reabrir_encuesta>
    <table>
HTML;
    if($p_id>0){
        $poner_read_only="readonly='readonly'";
    }else{
        $poner_read_only="";
    }
    $str.=<<<HTML
            <tr><td><label for='encuesta'>Nº de encuesta:     </label><td><input type='text' name='p_encuesta' id='p_encuesta' value='$_REQUEST[p_encuesta]'  readonly='readonly' id='encuesta' style='width:90px'>
            <tr><td><label for='id_proc'>ID de procesamiento: </label><td><input type='text' name='p_id'       id='p_id'       value='$_REQUEST[p_id]'        $poner_read_only id='id_proc' style='width:70px'>            
            <br><br><br></tr>
HTML;
    $respuestas=$db->preguntar_array(
        <<<SQL
            select 1 as existe, fin_ingreso, fin_anal_ing, fin_anal_campo, fin_anal_proc, estado, id_proc
              from yeah_2011.tem11 
              where encues = :p_encues and (id_proc = :p_id or -1=:p_id2)
SQL
        ,
        array(':p_encues' => $p_encuesta
            , ':p_id' => $p_id
            , ':p_id2' => $p_id
        )
    );
    $respuesta=$respuestas['existe'];
    $respuesta_fing =$respuestas['fin_ingreso'];
    $respuesta_ing  =$respuestas['fin_anal_ing'];
    $respuesta_campo=$respuestas['fin_anal_campo'];
    $respuesta_proc =$respuestas['fin_anal_proc'];
    $respuesta_estado =$respuestas['estado'];
    if ($respuesta >0){
        $str.="<TABLE BORDER=1 cellspacing=0>"; 
        $str.="<TR><TH>  Fin de </TH><TH>   Codigo       </TH><TH>                      deshacer                                 </TH></TR>"; 
        $str.="<TR><TD>ingreso            </TD><TD>$respuesta_fing  </TD><TD><input type=checkbox name=p_deshacer_fin_ing   id=chk_ing   > </TD></TR>"; 
        $str.="<TR><TD>análisis de ingreso            </TD><TD>$respuesta_ing  </TD><TD><input type=checkbox name=p_deshacer_anal_ing   id=chk_ing   > </TD></TR>"; 
        $str.="<TR><TD>análisis de campo              </TD><TD>$respuesta_campo</TD><TD><input type=checkbox name=p_deshacer_anal_campo id=chk_campo > </TD></TR>"; 
        $str.="<TR><TD>análisis de procesamiento      </TD><TD>$respuesta_proc </TD><TD><input type=checkbox name=p_deshacer_anal_proc  id=chk_proc  > </TD></TR>"; 
        $str.="<TR><TD>estado             </TD><TD>$respuesta_estado</TD><TD></TD></TR>"; 
        if($p_id<=0){
            $str.="<TR><TD colspan=3>ATENCI<span title='{$respuestas['id_proc']}'>Ó</span>N FALTA ESPECIFICAR EL ID</TD></TR>"; 
        }
        $str.="</TABLE><br>"; 
        $str.="<input name=procesar type=submit value='Deshacer los fines tildados' > ";
    }else{
        $str=str_replace('Reabrir encuesta para deshacer analisis',"<a href='reabrir_encuesta.php'>Encuesta no encontrada click aqui para Reingresar</a> ",$str);
    }
}else{
    $str.=<<<HTML
        <br>
        <h2>Reabrir encuesta para deshacer analisis</h2>
        <form id=reabrir_encuesta name=reabrir_encuesta>
        <table>
HTML;
    $str.=<<<HTML
            <tr><td><label for='encuesta'>Nº de encuesta:     </label><td><input type='text' name='p_encuesta'  value='' id='encuesta' style='width:90px'>            
            <tr><td><label for='id_proc'>ID de procesamiento: </label><td><input type='text' name='p_id'        value='' id='id_proc'  style='width:70px'>            
HTML;
    $str.=<<<HTML
    <tr><td><td><input name='consultar' type=submit value='Ver analisis' >
    </table>
    </form>
HTML;
}

EnviarStrAlCliente($str);
?>