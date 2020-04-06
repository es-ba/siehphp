<?php
//UTF-8:SÍ
/*
Soporte para las tablas_o_vistas de la base de datos.

*/
require_once "lo_imprescindible.php";
require_once "comunes.php";
require_once "para_parametros_con_nombre.php";
require_once "pdo_con_excepciones.php";
require_once "esquemas.php";
require_once "campos.php";

abstract class Tablas_o_Vistas extends Objeto_de_la_base{
    public $campos=array();
    public $fin_de_definicion_estructura=false;
    protected $campos_orden;
    protected $pk=array();
    public $definiciones_para_grilla=array();
    abstract function definicion_estructura();
    abstract function definir_campos_genericos_al_final();
    public $clausula_where_agregada_manual="";
    function leer_estructura_del_json(){
        $estructura=json_decode(file_get_contents(get_class($this).'.estructura.json'),true);
        foreach($estructura['definir_campo'] as $campo=>$definicion){
            $this->definir_campo($campo,$definicion);
        }
    }
    function __construct(){
        if(count($this->campos)>0){
            throw new Exception_Tedede("No se pueden definir campos antes de definicion_estructura(). En ".get_class($this));
        }
        $this->definicion_estructura();
        $this->definir_campos_genericos_al_final();
        $this->fin_de_definicion_estructura=true;
    }
    protected function agregar_campo_a_la_pk($campo_a_agregar){
        $this->pk[]=$campo_a_agregar;
    }
    public function definir_campo($nombre_campo,$definicion_campo){
        if($this->fin_de_definicion_estructura){
            throw new Exception_Tedede("No se pueden definir campos fuera de definicion_estructura(). En ".get_class($this));
        }
        if(!isset($this->prefijo)){
            throw new Exception_Tedede("antes de llamar a definir_campo hay que definir el prefijo. En ".get_class($this));
        }
        $this->definiciones_campo_originales[$nombre_campo]=$definicion_campo;
        $hereda=extraer_y_quitar_parametro($definicion_campo,'hereda',false);
        if($hereda){
            $controlar_definir_hijas_en_el_padre=extraer_y_quitar_parametro($definicion_campo,'controlar_definir_hijas_en_el_padre',true);
            $tabla_padre=$this->definicion_tabla($hereda);
            if($controlar_definir_hijas_en_el_padre && !isset($tabla_padre->muchas_hijas) && !isset($tabla_padre->tablas_hijas[$this->nombre_tabla_o_vista])){
                //throw new Exception_Tedede("en definir campo $nombre_campo la tabla de donde debe heredar {$tabla_padre->nombre_tabla_o_vista} no tiene a {$this->nombre_tabla_o_vista} entre sus hijas");
            }
            $modo_herencia=extraer_y_quitar_parametro($definicion_campo,'modo',array('obligatoria'=>true,'opciones'=>array('pk','fk_obligatoria','fk_optativa')));
            $nombre_campo_en_padre=extraer_y_quitar_parametro($definicion_campo,'campo_relacionado',null)?:
                cambiar_prefijo_raya($nombre_campo,$this->prefijo,$tabla_padre->prefijo);
            $definicion_campo=$tabla_padre->definiciones_campo_originales[$nombre_campo_en_padre];
            if(!in_array($nombre_campo_en_padre,$tabla_padre->pk)){
                throw new Exception_Tedede("Error en {$this->nombre_tabla_o_vista} tratando de heredar el campo $nombre_campo_en_padre que no es pk en {$tabla_padre->nombre_tabla_o_vista}");
            }
            if($definicion_campo['tipo']=='serial'){
                $definicion_campo['tipo']='entero';
            }
            if($modo_herencia=='pk'){
                $definicion_campo['es_pk']=true;
            }else{
                $definicion_campo['es_pk']=false;
                if($modo_herencia=='fk_obligatoria'){
                    $definicion_campo['not_null']=true;
                }else{
                    $definicion_campo['not_null']=false;
                }
            }
            $campos_origen=array();
            foreach($tabla_padre->pk as $campo_pk_en_el_padre){
                $campos_origen[]=cambiar_prefijo_raya($campo_pk_en_el_padre,$tabla_padre->prefijo,$this->prefijo);
            }
            $campos_origen[count($campos_origen)-1 /*el último*/]=$nombre_campo;
            $this->definir_fk($campos_origen,$tabla_padre);
        }
        $agregar_a_este=array();
        $def_para_todos=array(
            'invisible'=>null,
            'title'=>null,
            'solo_lectura'=>null,
            'es_nombre'=>null,
            'mostrar_al_elegir'=>null,
        );
        foreach($def_para_todos as $param=>$def_un_parametro){
            $agregar_a_este[$param]=extraer_y_quitar_parametro($definicion_campo,$param,$def_un_parametro);
        }
        $this->extraer_parametros_especificos($nombre_campo,$definicion_campo);
        $es_pk=extraer_y_quitar_parametro($definicion_campo,'es_pk',array('def'=>false));
        if($es_pk){
            $definicion_campo['not_null']=true;
        }
        $unico=extraer_y_quitar_parametro($definicion_campo,'unico',array('def'=>false));
        if($unico){
            if($unico===true){
                $unico=$nombre_campo;
            }
            $this->unicos[$unico][]=$nombre_campo;
        }
        if(!@$definicion_campo['tipo']){
            throw new Exception_Tedede("Falta especificar el tipo del campo $nombre_campo");
        }
        $campo_clase='Campo_'.$definicion_campo['tipo'];
        $campo_actual=new $campo_clase($definicion_campo);
        $this->campos[$nombre_campo]=$campo_actual;
        $campo_actual->nombre_sin_prefijo=substr($nombre_campo,strlen($this->prefijo)+1);
        if($es_pk){
            $this->agregar_campo_a_la_pk($nombre_campo);
        }
        foreach($def_para_todos as $param=>$def_un_parametro){
            if($agregar_a_este[$param]!==null){
                $campo_actual->{$param}=$agregar_a_este[$param];
            }
        }
    }
    function definir_campos_orden($campos_orden){
        $this->campos_orden=is_string($campos_orden)?array($campos_orden):$campos_orden;
    }
    protected function definir_prefijo($prefijo){
        $this->prefijo=$prefijo;
    }
    function existe_campo($nombre_campo){
        return isset($this->definiciones_campo_originales[$nombre_campo]);
    }
    function definicion_campo($nombre_campo){
        if(!$this->existe_campo($nombre_campo)){
            throw new Exception_Tedede("no existe el campo $nombre_campo en ".get_class($this));
        }
        return $this->definiciones_campo_originales[$nombre_campo];
    }
    protected function extraer_parametros_especificos($nombre_campo,&$definicion_campo){
    }
    function clausula_where_agregada(){
        return "";
    }
    function en_que_where_va_el_campo_y_cual_campo(&$campo){
        // $campo queda intacto pero en la vista puede cambiar al interior si era un alias
        if(@$this->campos_lookup_nombres && @$this->campos_lookup_nombres[$campo]){
            return 'where_posterior';
        }
        return 'where';
    }
    protected function obtener_sentencia_select_y_parametros($filtro,$con_order_by){
        $f=$this->contexto->nuevo_objeto("Filtro_Normal",$filtro,$this);
        $f->sentencia_select="select ".$this->campos_select()." /*este*/ from ".$this->clausula_from().
            " where ".$f->where.$this->clausula_where_agregada().$this->clausula_where_agregada_manual.
            $this->clausula_group_by();
        if($con_order_by){
            $f->sentencia_select.=" order by ".($this->campos_orden?implode(", ",$this->campos_orden):implode(", ",$this->pk));
        }
        if($f->where_posterior && $f->where_posterior!='true'){
            $f->sentencia_select="select * from (".$f->sentencia_select.") x where ".$f->where_posterior;
        }
        return $f;
    }
    protected function obtener_sentencia_count_y_parametros($filtro){
        $f=$this->contexto->nuevo_objeto("Filtro_Normal",$filtro,$this);
        $f->sentencia_select="select count (*) from ".$this->clausula_from().
            " where ".$f->where;
        return $f;
    }
    protected function obtener_sentencia_max_y_parametros($filtro, $campo){
        $f=$this->contexto->nuevo_objeto("Filtro_Normal",$filtro,$this);
        $f->sentencia_select="select max(".$campo.") from ".$this->clausula_from().
            " where ".$f->where;
        return $f;
    }
    public function obtener_maximo($filtro, $campo){
        $this->necesita_db_para('leer');
        $f=$this->obtener_sentencia_max_y_parametros($filtro,$campo);
        return $this->contexto->db->preguntar($f->sentencia_select, $f->parametros);
    }
    public function contar_cuantos($filtro){
        $this->necesita_db_para('leer');
        $f=$this->obtener_sentencia_count_y_parametros($filtro);
        return $this->contexto->db->preguntar($f->sentencia_select, $f->parametros);
    }        
    protected function leer_unico_o_varios($filtro,$unico){
        $this->necesita_db_para('leer');        
        $f=$this->obtener_sentencia_select_y_parametros($filtro,!$unico);
        if($unico){
            $this->datos=$this->contexto->db->preguntar_objeto($f->sentencia_select, $f->parametros);
            if(!$this->datos){
                throw new Exception_Tedede("No hay ningun registro activo para leer de ".$this->nombre_tabla_o_vista." para ".json_encode($filtro));
            }
        }else{
            $this->cursor=$this->contexto->db->ejecutar($f->sentencia_select, $f->parametros);
        }
    }
    abstract function clausula_from();
    abstract function campos_select();
    function clausula_group_by(){
        return "";
    }
    function obtener_leido(){
        if(!isset($this->cursor)){
            throw new Exception_Tedede("Error uso de obtener_leido sin cursor en ".get_class($this));
        }
        $this->datos=$this->cursor->fetchObject();
        return $this->datos;
    }
    function leer_varios($filtro){
        return $this->leer_unico_o_varios($filtro,false);
    }
    function leer_unico($filtro){
        // OJO falta el caso de prueba que verifique que sí o sí haya uno y solo un registro.
        return $this->leer_unico_o_varios($filtro,true);
    }
    function leer_uno_si_hay($filtro){
        // OJO falta el caso de prueba que verifique que sí o sí haya uno.
        return $this->leer_unico_o_varios($filtro,false);
    }
    function leer_pk($pk){
        $filtro=array();
        $posicion=0;
        foreach($this->pk as $nombre_campo){
            $filtro[$nombre_campo]=$pk[$posicion];
            if(!isset($pk[$posicion])){
                throw new Exception_Tedede("leyendo ".get_class($this)." faltan valores en la pk pasada ".json_encode($pk));
            }
            $posicion++;
        }
        if($posicion<count($pk)){
            throw new Exception_Tedede("leyendo ".get_class($this)." sobran valores en la pk pasada ".json_encode($pk));
        }
        $this->leer_unico($filtro);
    }
    function id_registro(){
        $this->necesita_datos_para('obtener id_registro');
        $rta=array();
        foreach($this->pk as $nombre_campo){
            $rta[]=$this->datos->{$nombre_campo};
        }
        /*
        if(count($rta)==1){
            return $rta[0];
        }
        */
        return json_encode($rta);
    }
    protected function necesita_contexto_para($nombre_accion,$propiedad_de_control=null){
        if(!isset($this->contexto)){
            throw new Exception_Tedede("La tabla {$this->nombre_tabla_o_vista} necesita un contexto para poder $nombre_accion");
        }
        if($propiedad_de_control && !isset($this->contexto->$propiedad_de_control)){
            $this->contexto->$propiedad_de_control=array();
        }
    }
    protected function necesita_db_para($nombre_accion){
        $this->necesita_contexto_para($nombre_accion);
        if(!isset($this->contexto->db)){
            throw new Exception_Tedede("El contexto de la tabla {$this->nombre_tabla_o_vista} necesita una db para poder $nombre_accion");
        }
    }
    protected function necesita_datos_para($nombre_accion){
        if(!isset($this->datos)){
            throw new Exception_Tedede("La tabla {$this->nombre_tabla_o_vista} necesita datos para poder $nombre_accion");
        }
    }
    function obtener_campos(){
        return $this->campos;
    }
    function obtener_nombres_campos(){
        return array_keys($this->campos);
    }
    function obtener_nombres_campos_pk(){
        return $this->pk;
    }
    function obtener_prefijo(){
        return $this->prefijo;
    }
    function puede_detallar(){
        return false;
    }
    function permite_grilla_sin_filtro(){
        return true;
    }
}

/*
function aplanar_filtro($filtro,$esta_tov=null){
    // transforma un filtro basado en tablas en un filtro solo basado en parámetros
    // $esta_tov "esta tabla o vista" es la tabla en la que basar los fitros que son tablas, si no está especificada
    if($filtro instanceof Tabla){
        if($esta_tov==null){
            throw new Exception_Tedede("no se pueden usar tablas como filtros sobre filtros que no son de tabla.");
        }
        $otra_tabla=$filtro; 
        $nombre_otra_tabla=$otra_tabla->nombre_tabla_o_vista; 
        if(isset($esta_tov->fks[$nombre_otra_tabla])){
            $definicion_fk=$esta_tov->fks[$nombre_otra_tabla];
            $lado_a_filtrar='campos_origen';
            $lado_a_usar='campos_destino';
        }else if(isset($otra_tabla->fks[$esta_tov->nombre_tabla_o_vista])){
            $definicion_fk=$otra_tabla->fks[$esta_tov->nombre_tabla_o_vista];
            $lado_a_filtrar='campos_destino';
            $lado_a_usar='campos_origen';
        }else{
            throw new Exception_Tedede("no se puede usar {$nombre_otra_tabla} como filtro de la tabla ".$esta_tov->nombre_tabla_o_vista);
        }
        $filtro=array();
        foreach($definicion_fk[$lado_a_usar] as $num=>$campo_origen){
            $campo_destino=$definicion_fk[$lado_a_filtrar][$num];
            $filtro[$campo_destino]=$otra_tabla->datos->{$campo_origen};
        }
    }else if($filtro instanceof Filtro_Que_se_completa_y_pisa){
        $Filtro_Que_se_completa_y_pisa=$filtro;
        $filtro=array();
        foreach($Filtro_Que_se_completa_y_pisa->array_de_filtros as $filtro_interno){ 
            $filtro=array_merge($filtro,aplanar_filtro($filtro_interno,$esta_tov));
        }
        // Loguear('2012-03-15','APLANAR =-============ '.var_export($filtro,true));
    }
    return $filtro;
}
*/
?>