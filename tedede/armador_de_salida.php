<?php
//UTF-8:SÍ
/* 
    El Armador_de_salida es el objeto que contiene el documento HTML que será mostrado 
    o partes parciales del mismo mientras se arma
*/ 
require_once "lo_imprescindible.php";

$esta_fun_tiene_el_unico_armador_de_salida_principal=FALSE; // FALSE=todavía no hay ninguno
$tags_sin_relleno=array('script'=>true, 'textarea'=>true, 'pre'=>true);

class Nodo_de_salida{
    public $acumulador_paquetes=""; // lo que está listo para un echo
    public $padre=NULL; // el nodo que tiene el padre si pongo un abrir_grupo_interno
    public $usa_salida_por_echo=FALSE;
    public $especifica_al_cerrar=FALSE;
    public $cerrar_con_opciones="";
}

class Armador_de_salida{
    private $ya_envio_algo_al_cliente=FALSE; // DOBLE USO: 1. si todavía no envió nada se pueden seguir agregando headers. 2. en el primer envío de algo hay que enviar antes los headers
    private $nodo;
    private $array_de_css=array();
    private $array_de_js=array('../tedede/comunes.js'=>true,'../tedede/tedede.js'=>true,'../tedede/tabulados.js'=>true);
    private $profundidad=0;
    private $control_profundidad=true;
    private $poner_retornos_de_carro=true;
    public $html_title='prueba';
    public $icon_app='';
    public $acumulador_js="";
    public $manifiesto="";
    const ESPECIFICA_AL_CERRAR=3.141592;
    function __construct($secundaria=FALSE){
        $this->icon_app=$GLOBALS['ICON_APP'];
        global $esta_fun_tiene_el_unico_armador_de_salida_principal;
        $this->principal=!$secundaria;
        $this->nodo=new Nodo_de_salida();
        if($this->principal){
            if($esta_fun_tiene_el_unico_armador_de_salida_principal){
                throw new Exception_Tedede("Ya habia un Armador_de_salida principal creado en ".var_export($esta_fun_tiene_el_unico_armador_de_salida_principal,true));
            }else{
                $esta_fun_tiene_el_unico_armador_de_salida_principal=aplanar_trace(debug_backtrace());
            }
            // $this->nodo->usa_salida_por_echo=false;
            $this->nodo->usa_salida_por_echo=$this->principal;
        }
    }
    function abrir_grupo_interno($clase='',$parametros=array()){
        $this->DEBUG_TAG('...'); // DEBUG_TAG
        $nuevo_nodo=new Nodo_de_salida();
        if($clase===self::ESPECIFICA_AL_CERRAR){
            $nuevo_nodo->especifica_al_cerrar=true;
            $nuevo_nodo->usa_salida_por_echo=false;
        }else{
            $this->DEBUG_TAG('{'); // DEBUG_TAG
            $this->enviar_tag_apertura($clase,$parametros);
            $nuevo_nodo->usa_salida_por_echo=$this->nodo->usa_salida_por_echo;
        }
        if((@$this->nodo->padre->tag_cierre)=='TD' && $this->nodo->tag_cierre=='TD'){
            //throw new Exception_Tedede("No se puede meter un TD dentro de otro");
        }
        $nuevo_nodo->padre=$this->nodo;
        $this->nodo=$nuevo_nodo;
    }
    function cerrar_grupo_interno($clase='',$parametros=array()){
        $nodo_hijo=$this->nodo;
        $this->nodo=$nodo_hijo->padre;
        if(!$nodo_hijo->especifica_al_cerrar && (@$parametros['tipo']) && $parametros['tipo']!=$this->nodo->tag_cierre){
            //throw new Exception_Tedede("se esperaba cerrar con {$parametros['tipo']} y estamos en el nodo ".json_encode($this->nodo));
        }
        if($nodo_hijo->especifica_al_cerrar){
            $this->DEBUG_TAG('['); // DEBUG_TAG
            $this->enviar_tag_apertura($clase,$parametros);
        }
        $this->sacar($nodo_hijo->acumulador_paquetes);
        $this->enviar_tag_cierre($clase,$parametros);
        $this->DEBUG_TAG(']'); // DEBUG_TAG
    }
    private function sacar_headers(){
        Loguear('2014-10-09','*************** SACO LOS HEADERS');
        $poner_manifiesto=$this->manifiesto?"manifest='$this->manifiesto'":"";
        $estilos_body=array();
        if($poner_manifiesto){
            $estilos_body[]='width:768px';
        }
        $agregar_al_titulo=$this->manifiesto?"":"";
        if(@$this->color_fondo){
            $estilos_body[]="background-color:{$this->color_fondo};";
        }
        if(@$this->img_fondo){
            $estilos_body[]="background-image:url({$this->img_fondo});";
        }
        $poner_estilo_body="style='".implode("; ",$estilos_body)."'";
        if($GLOBALS['esta_es_la_base_en_produccion']){
            $entorno = 'prod';
        }else if($GLOBALS['esta_es_la_base_de_capacitacion']){
            $entorno = 'capa';
        }else{
            $entorno = 'test';
        }
        $nombre_webmanifest= "webmanifest_" . $GLOBALS['nombre_app'] . "_". $entorno . ".webmanifest";
        echo <<<HTML
<!DOCTYPE HTML>
<html $poner_manifiesto lang="es">
<head>
    <meta charset="UTF-8">
    <title>$agregar_al_titulo{$this->html_title}</title>
    <meta name="format-detection" content="telephone=no">
    <link rel="manifest" crossorigin="use-credentials" href="$nombre_webmanifest">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name='viewport' content='user-scalable=no, width=776'>

HTML;

//  <meta name='viewport' content='user-scalable=no, width=device-width'>
//	<script language="JavaScript" src="comunes.js"> </script>
        foreach($this->array_de_css as $nombre_archivo=>$true){
            echo <<<HTML
    <link rel="stylesheet" href="$nombre_archivo">
    
HTML;
        }
        foreach($this->array_de_js as $nombre_archivo=>$true){
            echo <<<HTML
    <script language="JavaScript" src="$nombre_archivo"> </script>
    
HTML;
        }
        $ext_icon=substr($GLOBALS['ICON_APP'],strlen($GLOBALS['ICON_APP'])-3);
        echo <<<HTML
    <link rel="apple-touch-icon" href="{$this->icon_app}">
    <link rel="icon" type="image/$ext_icon" href="{$this->icon_app}">
</head>
<body $poner_estilo_body>

HTML;
        $this->ya_envio_algo_al_cliente=true; // si envió los headers es porque está por enviar algo al cliente y ya lo marco. 
    }
    function enviar_encabezado_general(){
        $this->abrir_grupo_interno("div_principal",array('id'=>'div_principal'));
    }
    protected function enviar_finalizado_general(){
        $this->cerrar_grupo_interno();
    }
    private function sacar($paquete){
        if($this->nodo->usa_salida_por_echo){
            if(!$this->ya_envio_algo_al_cliente){
                $this->sacar_headers();
            }
            echo $this->nodo->acumulador_paquetes;
            echo $paquete;
            $this->nodo->acumulador_paquetes="";
        }else{
            $this->nodo->acumulador_paquetes.=$paquete;
        }
    }
    function sacar_html_directo($fraccion_HTML){
        $this->sacar($fraccion_HTML);
    }
    private function controlar_que_se_pueda_agregar_headers(){
        if($this->ya_envio_algo_al_cliente){
            throw new Exception_Tedede("no se pueden agregar headers porque ya se enviaron datos al cliente");
        }
    }
    function agregar_css($nombre_del_css){
        if(!@$this->array_de_css[$nombre_del_css]){
            $this->controlar_que_se_pueda_agregar_headers();
        }
        $this->array_de_css[$nombre_del_css]=TRUE;
    }    
    function eliminar_lista_css(){
        $this->controlar_que_se_pueda_agregar_headers();
        $this->array_de_css=array();
    }    
    
    function agregar_js($nombre_del_js,$poner_en_el_header=FALSE){
        if($poner_en_el_header || !$this->ya_envio_algo_al_cliente){
            if(!@$this->array_de_js[$nombre_del_js]){
                $this->controlar_que_se_pueda_agregar_headers();
            }
            $this->array_de_js[$nombre_del_js]=TRUE;
        }else{
            $clase='';
            $this->enviar_tag_apertura($clase,array('tipo'=>'script','type'=>'text/javascript','src'=>$nombre_del_js));
            $this->enviar_tag_cierre($clase);
        }
    }    
    function redireccionar_a($url_nueva){
        $this->controlar_que_se_pueda_agregar_headers();
        header("Location: $url_nueva");
        die();
    }
    static function escapar_caracteres_antes_de_enviar_texto($mensaje){
        return htmlspecialchars($mensaje,ENT_NOQUOTES)."";
    }
    public function enviar($mensaje,$clase='',$parametros=NULL){
        global $tags_sin_relleno;
        if($mensaje===NULL){
            $mensaje="";
        }
        if(!is_string($mensaje)){
            throw new Exception_Tedede("enviar solo recibe mensajes de texto");
        }
        if(!is_string($clase)){
            throw new Exception_Tedede("enviar solo recibe clases de texto");
        }
        $this->DEBUG_TAG("("); // DEBUG_TAG
        if(@$parametros['tipo']=='script'){
            throw new Exception_Tedede("No se puede usar enviar para tipo=script, usar enviar_script");
        }
        if(@$parametros['type']=='button'){
            throw new Exception_Tedede("No se puede usar enviar para type=button, usar enviar_boton");
        }
        $this->enviar_tag_apertura($clase,$parametros);
        $this->sacar($this->escapar_caracteres_antes_de_enviar_texto($mensaje)); 
        if(!@$tags_sin_relleno[$this->nodo->tag_cierre]){
            $this->sacar_retorno_de_carro();
        }
        $this->enviar_tag_cierre($clase,$parametros);
        $this->DEBUG_TAG(")"); // DEBUG_TAG
    }
    private function DEBUG_TAG($sennal){
        // $algo=htmlspecialchars(json_encode($this->nodo));
        // $this->sacar("<span style='background-color:cyan' title='$algo'>$sennal</span>");
    }
    static function tabla_opciones_para_combo($opciones,$id_elemento,$opciones_post_proceso){
        $rta="";
        $stuff_id_opciones="'opciones_de_".$id_elemento."'";
        $stuff_id_elemento='"'.$id_elemento.'"';
        $rta.="<table id=$stuff_id_opciones class='mostrar_opciones_lista' >\n";
        foreach($opciones as $opcion=>$columnas){
            if(is_numeric($opcion) && is_string($columnas)){
                $opcion=$columnas;
                $columnas=array($columnas);
            }
            $rta.="<tr onclick='mostrar_opciones_asignar($stuff_id_elemento,\"".
                htmlspecialchars($opcion)."\"); $opciones_post_proceso'>";
            foreach($columnas as $columna){
                $rta.="<td>".
                    self::escapar_caracteres_antes_de_enviar_texto($columna)."</td>";
            }
            $rta.="</tr>\n";
        }
        $rta.="</table>\n";
        return $rta;
    }
    private function enviar_tag_apertura($clase='',$parametros=NULL,$necesita_cerrar=TRUE){
        global $tags_sin_relleno;
        if($parametros){
            $opciones=extraer_y_quitar_parametro($parametros,'opciones',array('def'=>null,'validar'=>'is_array'));
            $opciones_pre_proceso=extraer_y_quitar_parametro($parametros,'opciones_pre_proceso',array('def'=>null,'validar'=>'is_string'));
            $opciones_post_proceso=extraer_y_quitar_parametro($parametros,'opciones_post_proceso',array('def'=>null,'validar'=>'is_string'));
            if($opciones){
                if(!$parametros['id']){
                    throw new Exception_Tedede("Para poner opciones en un elemento debe haber un id en el elemento");
                }
                //$parametros['style']=@($parametros['style'].';').'width:80%';
                $stuff_id_opciones="'opciones_de_".htmlspecialchars($parametros['id'])."'";
                $stuff_id_elemento='"'.htmlspecialchars($parametros["id"]).'"';
                $this->sacar("<span style='white-space:nowrap;'>");
                $this->nodo->cerrar_con_opciones="<img src=../imagenes/mopciones.png onclick=\"mostrar_opciones($stuff_id_opciones)\" class='mostrar_opciones_boton'></span>";
                $this->nodo->cerrar_con_opciones.=self::tabla_opciones_para_combo($opciones,htmlspecialchars($parametros['id']),$opciones_post_proceso);
            }
        }
        controlar_parametros($parametros,array(
            'tipo'=>'DIV',
            // desde acá orden alfabético, atributos comunes:
            'action'=>null,
            'autofocus'=>array('validar'=>'is_bool'),
            'border'=>null,
            'checked'=>array('validar'=>'is_bool'),
            'colspan'=>null,
            'disabled'=>null,
            'display'=>null,
            'draggable'=>null,
            'enctype'=>null,
            'for'=>null, // esto es para los labels
            'href'=>null,
            'id'=>null,
            'method'=>null,
            'name'=>null,
            'placeholder'=>null,
            'rows'=>null,
            'rowspan'=>null,
            'select'=>null,
            'src'=>null,
            'style'=>null,
            'title'=>null,
            'type'=>null,
            'value'=>null,
            'visibility'=>null,
            'width'=>null,
            // desde acá orden alfabético, atributos "on" de eventos:
            'onblur'=>null,
            'onchange'=>null,
            'onclick'=>null,
            'onkeydown'=>null,
            'onkeypress'=>null,
            'onfocus'=>null,
            'onmousedown'=>null,
            'onmouseout'=>null,
            'onmouseup'=>null,
            // de usuario
            'data-nivel'=>null,
            'data-tipo'=>null,
            'referencia'=>null,
            // asociados a variables especiales
            'grilla_boton'=>null,
        ));
        if($necesita_cerrar){
            $this->profundidad++;
        }
        $tipo=$parametros->tipo;
        $this->nodo->tag_cierre=$tipo;
        unset($parametros->tipo);
        if($this->control_profundidad && !@$tags_sin_relleno[$this->nodo->tag_cierre]){
            $this->sacar(str_repeat(' ',$this->profundidad));
        }
        $this->sacar("<".$tipo);
        if($clase){
            $this->sacar(' class="'.htmlspecialchars($clase).'"');
        }
        foreach($parametros as $parametro=>$valor){
            if($valor || $valor==='0' || $valor===0){
                $this->sacar(' '.$parametro.'="'.htmlspecialchars($valor).'"');
            }
        }
        $this->sacar(">");
        $this->sacar_retorno_de_carro();
    }
    private function sacar_retorno_de_carro(){
        if($this->poner_retornos_de_carro){
            $this->sacar("\n");
        }
    }
    private function enviar_tag_cierre(){
        global $tags_sin_relleno;
        if($this->control_profundidad && !@$tags_sin_relleno[$this->nodo->tag_cierre]){
            $this->sacar(str_repeat(' ',$this->profundidad));
        }
        $this->sacar("</{$this->nodo->tag_cierre}>");
        if($this->nodo->cerrar_con_opciones){
            $this->sacar($this->nodo->cerrar_con_opciones);
            $this->nodo->cerrar_con_opciones="";
        }
        $this->sacar_retorno_de_carro();
        $this->profundidad--;
    }
    function enviar_imagen($nombre_archivo_relativo_a_imagenes,$clase='',$parametros=NULL){
        $parametros['tipo']='img';
        if(empieza_con($nombre_archivo_relativo_a_imagenes,'..')){
            $parametros['src']=$nombre_archivo_relativo_a_imagenes;
        }else{
            $parametros['src']="../imagenes/".$nombre_archivo_relativo_a_imagenes;
        }
        $this->enviar_tag_apertura($clase,$parametros,FALSE);
    }
    function abrir_grupo_link($clase, $url, $parametros=array()){
        return $this->abrir_grupo_interno($clase,array_merge($parametros,array('href'=>$url,'onclick'=>"click_ir_url(".json_encode($url).",event)",'tipo'=>'a')));
    }
    function enviar_link($texto,$clase,$url){
        $this->enviar($texto,$clase,array('href'=>$url,'onclick'=>"click_ir_url(".json_encode($url).",event)",'tipo'=>'a'));
    }
    function enviar_boton($texto_del_boton,$clase='',$parametros=NULL){
        if($texto_del_boton){
            $parametros['value']=$texto_del_boton;
            $parametros['tipo']='input';
            $parametros['type']='button';
        }
        $this->enviar_tag_apertura($clase,$parametros,FALSE);
    }
    function enviar_script($texto_en_js){
        if($this->principal){
            $clase='';
            $this->enviar_tag_apertura($clase,array('tipo'=>'script'));
            // $this->sacar($this->escapar_caracteres_antes_de_enviar_texto($texto_en_js)); 
            $this->sacar($texto_en_js); 
            $this->sacar_retorno_de_carro();
            $this->enviar_tag_cierre($clase);
        }else{
            $this->acumulador_js.="$texto_en_js \n";
        }
    }
    function enviar_html_lo_uso_solo_para_los_manuales($html){
        $this->sacar($html); 
    }
    function enviar_info_expandible($sennial,$texto){
        $this->enviar($sennial,'info_expandible',array('tipo'=>'span','title'=>$texto,'onclick'=>'alert(this.title);'));
    }
    function mandar_todo_al_cliente(){
        $this->nodo->usa_salida_por_echo=true;
        $this->enviar_finalizado_general();
        $this->sacar("</body>\n</html>\n");
    }
    function obtener_una_respuesta_HTML(){
        if($this->nodo->usa_salida_por_echo){
            throw new Exception_Tedede("La funcion obtener_una_respuesta_HTML solo puede usarse en un armador secundario");
        }
        return new Respuesta_Positiva(array(
            'html'=>$this->nodo->acumulador_paquetes,
            'tipo'=>'html',
            'js_indirecto'=>$this->acumulador_js));
    }
}


?>