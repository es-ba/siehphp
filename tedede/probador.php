<?php
//UTF-8:SÍ
/* 
    Las pruebas estarán almacenadas en clases que extiendan las pruebas
*/ 

require_once "armador_de_salida.php";

interface Probador{
    function informar_error($mensaje);
}

class Pruebas{
    var $probador;
    function __construct(){
    }
}

class Base_de_Datos_Falsa_para_Probar{
    // Base de datos que no guarda nada, solo se acuerda de lo ejecutado para poder hacer casos de prueba. 
    private $sqls;
    function __construct(){
        $this->sqls=new Sqls();
    }
    function ejecutar_sql(Sql $sql){
        $this->sqls->agregar($sql);
    }
    function ejecutar_sqls(Sqlsable $sqls){
        foreach($sqls->obtener_sqls() as $sql){
            $this->ejecutar_sql($sql);
        }
    }
    function extraer_sqls(){
        // saca todos los sqls ejecutados y los devuelve vaciando el acumulado
        $rta=$this->sqls;
        $this->sqls=new Sqls();
        return $rta;
    }
    function extraer_unico_sql(){
        // saca el único sql ejecutados y los devuelve vaciando el acumulado
        // si no era uno solo lanza una excepción
        $extraidos=$this->extraer_sqls();
        $arreglo=$extraidos->obtener_sqls();
        if(count($arreglo)!=1){
            throw new Exception_Tedede("Se esperaba un unico sql");
        }
        return $arreglo[0];
    }
    function quote($nombre_objeto_o_valor,$tipo='dato'){
        if($tipo=='dato'){
            return "'{$nombre_objeto_o_valor}'";
        }else{
            return "`{$nombre_objeto_o_valor}`";
        }
    }
}

class Exception_Tedede_Saltear_pruebas extends Exception_Tedede{
}

class Probador_minimo_HTML implements Probador{
    var $salida;
    var $estoy_en;
    private $cant;
    function __construct($contexto){
        $this->salida=$contexto->salida;
        $this->contexto=$contexto;
        $this->salida->agregar_css('../tedede/probador.css');
        $this->cant=new Totalizador(array('funciones','clases','errores','ignorados'));
    }
    function probar($prueba,$funciones_a_probar){
        $prueba->probador=$this;
        if(!isset($prueba->contexto)){
            $prueba->contexto=$this->contexto;
        }
        $this->cant->clases++;
        // $this->cant->clases=$this->cant->clases+1;
        foreach($funciones_a_probar as $funcion){
            $this->cant->funciones++;
            $this->cant->abrir_grupo_interno();
            if(method_exists($prueba,'pre_probar_para_todo')){
                $prueba->pre_probar_para_todo();
            }
            try{
                $prueba->$funcion();
            }catch(Exception_Tedede_Saltear_pruebas $e){
                $this->cant->ignorados++;
                $this->salida->enviar("$funcion #".$e->getMessage(),'probador_trabajando');
            }
            if($this->cant->errores>0){
                $this->salida->enviar("función $funcion",'probador_funcion_con_error');
            }
            if(method_exists($prueba,'pos_probar_para_todo')){
                $prueba->pos_probar_para_todo();
            }
            $this->cant->cerrar_grupo_interno();
        }
    }
    function probar_todo($otros_js){
        foreach(get_declared_classes() as $nombre_clase){
            $clase=new ReflectionClass($nombre_clase);
            if($clase->isSubclassOf('Pruebas')){
                $clase_de_cada_proyecto=$nombre_clase.'__'.$GLOBALS['nombre_app'];
                if(class_exists($clase_de_cada_proyecto)){                    
                    $clase=new ReflectionClass($clase_de_cada_proyecto);
                    $nombre_clase=$clase_de_cada_proyecto;
                }
                $this->cant->abrir_grupo_interno();
                $this->salida->abrir_grupo_interno();
                $prueba=$clase->newInstance();
                if(!isset($prueba->contexto)){
                    $prueba->contexto=$this->contexto;
                }
                if(!isset($prueba->contexto->salida)){
                    $prueba->contexto->salida=$this->contexto->salida;
                }
                if(method_exists($prueba,'pre_probar_para_clase')){
                    $prueba->pre_probar_para_clase();
                }
                $metodos=$clase->getMethods();
                $nombres_de_funciones_de_prueba=array();
                foreach($metodos as $metodo){
                    if(strpos($metodo->name,'probar')===0){
                        $nombres_de_funciones_de_prueba[]=$metodo->name;
                    }
                }
                $this->probar($prueba,$nombres_de_funciones_de_prueba);
                if($this->cant->errores>0){
                    $this->salida->enviar_imagen('probador_error.png','probador_icono');
                }else{
                    $this->salida->enviar_imagen('probador_ok.png','probador_icono');
                }
                $this->salida->enviar("clase $nombre_clase {$this->cant->errores} errores en {$this->cant->funciones} funciones",'',array('tipo'=>'span'));
                $this->cant->cerrar_grupo_interno();
                $this->salida->cerrar_grupo_interno();
            }
        }
        $this->salida->agregar_js('../tedede/casos_prueba.js');
        foreach($otros_js as $un_js){
            $this->salida->agregar_js($un_js);
        }
        $this->salida->enviar_script(<<<JS
            probar_todo();
JS
        );
    }
    function informar_error($mensaje){
        $this->cant->errores++;
        $this->informar_texto($mensaje);
    }
    function informar_texto($mensaje,$tipo=array()){
        $this->salida->enviar($mensaje,'probador_texto_con_error',$tipo);
    }
    function pendiente_ticket($num_ticket){
        throw new Exception_Tedede_Saltear_pruebas($num_ticket);
    }
    function pendiente_de_especificar($mensaje){
        $this->cant->ignorados++;
        $this->salida->enviar($mensaje,'probador_texto_pendiente_de_especificar');
    }
    function verificar_arreglo($esperado, $obtenido){
        $num_linea=0;
        if($obtenido==null){
            $this->informar_error("no se obtuvo nada, se esperaba:");
            $this->informar_texto(implode("\n",$esperado),array('tipo'=>"pre"));
        }
        if(!is_array($obtenido)){
            throw new Exception_Tedede("para usar verificar_arreglo debe ser un arreglo");
        }
        while($num_linea<count($esperado) && $num_linea<count($obtenido) 
            && preg_replace(array('/^\s*/','/\s*$/'),array('',''),@$esperado[$num_linea])
             ==preg_replace(array('/^\s*/','/\s*$/'),array('',''),@$obtenido[$num_linea])
        ){
            $num_linea++;
        }
        if($num_linea<count($esperado) || $num_linea<count($obtenido)){
            $this->informar_error("iguales hasta:");
            $this->informar_texto(implode("\n",array_slice($esperado,0,$num_linea)),array('tipo'=>"pre"));
            $this->informar_texto("líneas distintas del esperado:");
            $this->informar_texto(implode("\n",array_slice($esperado,$num_linea)),array('tipo'=>"pre"));
            $this->informar_texto(json_encode($esperado),array('tipo'=>"pre"));
            $this->informar_texto("líneas distintas del obtenido:");
            $this->informar_texto(implode("\n",array_slice($obtenido,$num_linea)),array('tipo'=>"pre"));
            $this->informar_texto(json_encode($obtenido),array('tipo'=>"pre"));
        }
    }
    function verificar($esperado, $obtenido, $aclaracion_al_fallar=null){
        if($esperado!==$obtenido){
            $this->informar_error("esperaba ".var_export($esperado,true)." y obtuve ".var_export($obtenido,true).($aclaracion_al_fallar?" ($aclaracion_al_fallar)":""));
        }
    }
    function verificar_texto($esperado, $obtenido){
        $lineas_esperado=explode("\n",$esperado);
        $lineas_obtenido=explode("\n",$obtenido);
        return $this->verificar_arreglo($lineas_esperado, $lineas_obtenido);
    }
    function verificar_arreglo_asociativo($esperado, $obtenido, $simetrico=true, $aclaracion_al_fallar=""){
        $tiene_error=false;
        if($obtenido instanceof stdClass){
            throw new Exception_Tedede("se esperaba un arreglo para comparar en el caso de prueba contra ".var_export($esperado));
        }
        foreach($esperado as $clave=>$valor){
            if(!array_key_exists($clave,$obtenido)){
                $this->informar_error('la clave '.$clave.' no está en el obtenido');
                $tiene_error=true;
            }else if($valor !== $obtenido[$clave]){
                $this->informar_error('la clave '.$clave.' tiene distinto valor en esperado "'.$valor.'" y obtenido "'.$obtenido[$clave].'"');
                $tiene_error=true;
            }
        }
        if($simetrico){
            foreach($obtenido as $clave=>$valor){
                if(!array_key_exists($clave,$esperado)){
                    $this->informar_error('la clave '.$clave.' no está en el esperado');
                    $tiene_error=true;
                }
            }
        }
        if($tiene_error){
            $this->informar_error($aclaracion_al_fallar);
        }
    }
    function verificar_sqls($esperado,$obtenido){
        if($esperado instanceof Sqls){
            // ok, está en el formato esperado.
        }else if($esperado instanceof Sql){
            $sqls=new Sqls();
            $sqls->agregar($esperado);
            $esperado=$sqls;
        }else if(is_array($esperado)){
            $sqls=new Sqls();
            foreach($esperado as $sql){
                if(!$sql instanceof Sql){
                    $sql=new Sql($sql);
                }
                $sqls->agregar($sql);
            }
            $esperado=$sqls;
        }else if(is_string($esperado)){
            $sqls=new Sqls();
            $sqls->agregar(new Sql($esperado));
            $esperado=$sqls;
        }
        if($obtenido instanceof Sql){
            $sqls=new Sqls();
            $sqls->agregar($obtenido);
            $obtenido=$sqls;
        }if(is_array($obtenido)){
            $sqls=new Sqls();
            foreach($obtenido as $sql){
                $sqls->agregar(new Sql($sql));
            }
            $obtenido=$sqls;
        }else if(!$obtenido instanceof Sqls){
            throw new Exception_Tedede("el segundo parametro de verificar_sqls debe ser un objeto de clase Sql o Sqls");
        }
        $this->verificar_via_json($esperado->obtener_sqls(), $obtenido->obtener_sqls());
    }
    function mostrar_resumen(){
    
        $html=$this->salida;
        $html->abrir_grupo_interno(Armador_de_salida::ESPECIFICA_AL_CERRAR);
        $html->enviar_imagen(($this->cant->errores>0?'probador_error.png':(
                              $this->cant->ignorados>0?'probador_ignorados.gif':'probador_ok.png')));
        $html->enviar("Se probaron {$this->cant->funciones} funciones en {$this->cant->clases} clases.","pruebas_resumen");
        if($this->cant->errores){
            $html->enviar("Se encontraron {$this->cant->errores} errores","pruebas_resumen");
        }
        if($this->cant->ignorados){
            $html->enviar("Se ignoraron {$this->cant->ignorados} pruebas","pruebas_resumen");
        }
        $html->cerrar_grupo_interno('probador_resumen'.($this->cant->errores>0?' probador_con_errores':''));
    }
    function verificar_via_json($esperado, $obtenido){
        $this->verificar_texto(str_replace('}',"}\n",json_encode($esperado)),str_replace('}',"}\n",json_encode($obtenido)));
    }
}

class Prueba_de_pruebas extends Pruebas{
    function probar_ver_un_error(){
        // $this->probador->informar_error("Este error está bien que aparezca porque es para probar el mecanismo de errores");
    }
}
?>