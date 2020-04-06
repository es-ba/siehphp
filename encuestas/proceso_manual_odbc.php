<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_manual_odbc extends Proceso_generico{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Cómo conectarse a ODBC',
            'submenu'=>'documentación',
            'permisos'=>array('grupo'=>'procesamiento'),
            'para_produccion'=>true,
        ));
    }
    function correr(){
        global $parametros_db;
        $this->salida->enviar_html_lo_uso_solo_para_los_manuales(<<<HTML
            <div class=instructivo style="font-size:75%">
                <H2>Cómo acceder a controlar las bases vía ODBC</H2>
                <H3>Paso 1:</H3>
                <p>Utilizar los siguientes datos del servidor 
                  (las imágenes de ejemplo usan ebcp como ejemplo pero las que hay que usar son las que acá figuran)
                </p>
                <TABLE>
                    <TR><TD>IP del servidor:<TD>{$parametros_db->host}
                    <TR><TD>nombre de la base:<TD>{$parametros_db->base_de_datos}
                </TABLE>
                <h3>Paso 2</h3>
                <P>Las pantallas pueden no ser iguales porque dependen de la versión del sistema operativo</p>
                <img src=../imagenes/odbc_fig1.png>
                <h3>Paso 3</h3><img src=../imagenes/odbc_fig2.png>
                <h3>Paso 4</h3><img src=../imagenes/odbc_fig3.png>
                <h3>Paso 5</h3><img src=../imagenes/odbc_fig4.png>
                <h3>Cuando haya un problema</h3>
                <p>Cuando haya un problema primero hay que consultar si fueron pedidos los permisos correspondientes 
                   (los permisos son por base de datos), luego verificar que se hayan dado todos los pasos, 
                   y de continuar el problema debe levantarse un requerimiento de nombre "problema para acceder al ODBC usuario TAL" 
                   (colocar en el texto del requerimiento el paso que no pudo concretarse y el texto del cartel que muestre el error).
            </div>
HTML
        );
    }
}

?>