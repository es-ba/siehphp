<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";

class Objeto_de_la_base{
    protected $nombre_esquema;
    function __construct(){
    }
    function definir_esquema($nombre_esquema){
        if(!class_exists("Esquema_$nombre_esquema")){
            throw new Exception_Tedede("no existe el esquema $nombre_esquema probablemente falte esquema_{$nombre_esquema}.php");
        }
        $this->nombre_esquema=$nombre_esquema;
    }
    function obtener_nombre_de_esquema(){
        return $this->nombre_esquema;
    }
    function instalar_automaticamente(){
        return true;
    }
    function sqls_instalacion_para_linea_de_comando(){
        throw new Exception_Tedede("Todavia no definido el sqls_instalacion_para_linea_de_comando para ".get_class($this));
    }
    function depende_de($nombre_de_otro_objeto_del_esquema){
        return false;
    }
    public function __call($name, array $arguments){
        if(empieza_con($name,'ejecutar_')){
            if(count($arguments)>1){
                throw new Exception_Tedede("No se puede llamar a $name con varios parametros si no se define realmente en ".get_class($this));
            }
            $funcion_a_ejecutar='sqls_'.quitar_prefijo($name,'ejecutar_');
            if(method_exists($this,$funcion_a_ejecutar)){
                $sqls=$this->$funcion_a_ejecutar();
                $this->contexto->db->ejecutar_sqls($sqls);
            }else{
                $funcion_a_ejecutar='sql_'.quitar_prefijo($name,'ejecutar_');
                if(method_exists($this,$funcion_a_ejecutar)){
                    if(count($arguments)==1){
                        $sql=$this->$funcion_a_ejecutar($arguments[0]);
                    }else{
                        $sql=$this->$funcion_a_ejecutar();
                    }
                    $this->contexto->db->ejecutar_sql($sql);
                }else{
                    throw new Exception_Tedede("No existe ninguna funcion para obtener el sql para $name en ".get_class($this));
                }
            }
        }else{
            throw new Exception_Tedede("No existe la funcion para $name en ".get_class($this));
        }
    }
}

class Esquema extends Objeto_de_la_base{
    private $nombre;
    private $objetos_incluidos = array();
    protected $esquema_productivo=false;
    function __construct($nombre_esquema=FALSE){
        if($nombre_esquema){
            $this->nombre = $nombre_esquema;
        }else{
            $this->nombre=get_class($this);
            $this->nombre=substr($this->nombre,strlen('Esquema_'));
        }
    }
    function obtener_nombre_de_esquema(){
        return $this->nombre;
    }
    function instalar_automaticamente(){
        return get_class($this)!=='Esquema'; // poner en FALSE los esquemas de los casos de prueba o cualquier otra cosa que no deba instalarse con instalador.php
    }
    function sqls_instalacion(){
        global $esta_es_la_base_en_produccion;
        $sqls=new Sqls();
        if(!$this->esquema_productivo || !$esta_es_la_base_en_produccion){
            $sqls->agregar(new Sql("drop schema if exists {$this->nombre} cascade"));
        }
        $sqls->agregar(new Sql("create schema {$this->nombre}"));
        return $sqls;
    }
    function sqls_instalacion_completa_de_esquema(){
        /*
        $comando_completo=array();
        $comando_completo=$this->sqls_instalacion_creacion_del_esquema_vacio();
        //$comando_completo[]="drop schema if exists {$this->nombre} cascade";
        //$comando_completo[]="create schema {$this->nombre}";
        foreach(get_declared_classes() as $nombre_clase){
            $clase=new ReflectionClass($nombre_clase);
            if($clase->isSubclassOf('Objeto_de_la_base')){
                $objeto=$clase->newInstance();
                $objetos_de_la_base[$objeto->obtener_nombre_de_esquema()][]=$objeto;
            }
        }
        $lista_ordenada_por_dependencia=array();
        foreach($objetos_de_la_base[$nombre_esquema] as $objeto){    
            $lista_abajo=array();
            $lista_arriba=array();
            foreach($objetos_por_dependencia as $objeto_dep){
                //verifico dependencia del nuevo objeto con los objetos ya ordenados
                if($objeto_dep->depende_de($objeto)){
                    $lista_abajo[]=$objeto_dep;
                }
                else {
                    $lista_arriba[]=$objeto_dep;
                }
            }
            $lista_ordenada_por_dependencia=array();
            array_append($lista_ordenada_por_dependencia,$lista_arriba);
            $auxi=array();
            $auxi[]=$objeto;
            //lista_ordenada_por_dependencia[]=$objeto;
            array_append($lista_ordenada_por_dependencia,$auxi);
            array_append($lista_ordenada_por_dependencia,$lista_abajo);
        }
        foreach($lista_ordenada_por_dependencia as $objeto_ordenado){
            $comando[]=$objeto_ordenado->sqls_instalacion_para_linea_de_comando();
        }
        return $comando_completo;
        */
        return array();
    }
}

class Esquema_test extends Esquema{
}

class Esquema_de_ejemplo extends Esquema{
    function instalar_automaticamente(){
        return false; // porque es para probar
    }
}

class Objeto_de_prueba_con_esquema_invalido extends Objeto_de_la_base{
    var $nombre;
    function definir_esquema_invalido(){
        $this->definir_esquema('de_ejemplo_inexistente');
    }
}

class Objeto_de_prueba extends Objeto_de_la_base{
    var $nombre;
    function __construct(){
        $this->definir_esquema('de_ejemplo');
    }
    function sqls_instalacion_para_linea_de_comando(){
        return array("/* creando el objeto de ejemplo {$this->nombre} */");
    }
}

class Esquema_de_prueba_363 Extends Esquema{
    function instalar_automaticamente(){
        return false;
    }
}
// el 1 depende del 3 y el 3 del 2
class Objeto_de_prueba_de_prueba_363_1 extends Objeto_de_la_base{
    var $nombre;
    function __construct(){
        $this->definir_esquema('de_prueba_363');
    }
    function sqls_instalacion_para_linea_de_comando(){
        return array("/* creando el objeto de ejemplo {$this->nombre} */");
    }
    function depende_de($nombre){
        return $nombre='de_prueba_de_prueba_363_3';
    }
}

class Objeto_de_prueba_de_prueba_363_2 extends Objeto_de_la_base{
    var $nombre;
    function __construct(){
        $this->definir_esquema('de_prueba_363');
    }
    function sqls_instalacion_para_linea_de_comando(){
        return array("/* creando el objeto de ejemplo {$this->nombre} */");
    }
    function depende_de($nombre){
        return false;
    }
}
class Objeto_de_prueba_de_prueba_363_3 extends Objeto_de_la_base{
    var $nombre;
    function __construct(){
        $this->definir_esquema('de_prueba_363');
    }
    function sqls_instalacion_para_linea_de_comando(){
        return array("/* creando el objeto de ejemplo {$this->nombre} */");
    }
    function depende_de($nombre){
        return $nombre='de_prueba_de_prueba_363_2';
    }
}

class Prueba_de_esquema extends Pruebas{
    function probar_new_sin_parametros(){
        $esquema = new Esquema_de_ejemplo(); 
        $this->probador->verificar('de_ejemplo',$esquema->obtener_nombre_de_esquema());
    }
    function probar_objeto_con_esquema_invalido(){
        try{
            $objeto = new Objeto_de_prueba_con_esquema_invalido(); 
            $objeto->definir_esquema_invalido();
            $this->probador->informar_error("esto debió dar error proque no existe el esqumea de_ejemplo_inexistente definido dentro de Objeto_de_prueba_con_esquema_invalido");
        }catch(Exception_Tedede $e){
        }
    }
    function probar_generar_sql(){
        $esquema=new Esquema_de_ejemplo();
        $this->probador->verificar_sqls(
            array(
                "drop schema if exists de_ejemplo cascade",
                "create schema de_ejemplo"
            ),
            $esquema->sqls_instalacion());
    }
    function probar_generacion_total_con_dependencias(){
        $this->probador->pendiente_ticket(363);
        $esquema=new Esquema_de_prueba_363();
        $this->probador->verificar_arreglo(
            array(
                "drop schema if exists de_prueba_363 cascade",
                "create schema de_prueba_363",
                "/* creando el objeto de ejemplo de_prueba_363_2 */",
                "/* creando el objeto de ejemplo de_prueba_363_3 */",
                "/* creando el objeto de ejemplo de_prueba_363_1 */"
            ),
            $esquema->sqls_instalacion_completa_de_esquema()
        );
    }
}

?>