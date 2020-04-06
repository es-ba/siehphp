<?php
//UTF-8:SÍ
/*
Soporte para las tablas de la base de datos.

*/
require_once "lo_imprescindible.php";
require_once "comunes.php";
require_once "probador.php";
require_once "para_parametros_con_nombre.php";
require_once "pdo_con_excepciones.php";
require_once "esquemas.php";
require_once "campos.php";
require_once "tablas_o_vistas.php";

class Exception_Tabla_nombre_invalido extends Exception{
}

abstract class Tabla extends Tablas_o_Vistas{
    static $Sin_Padre;
    protected $nombre_tabla;
    protected $sufijo_clase;
    public $fks=array();
    protected $prefijo='';
    public $contexto;
    public $datos;
    protected $unicos=array();
    protected $tablas_hijas=array();
    protected $padre;
    protected $heredar_en_cascada=false;
    public $valores_para_insert;
    public $valores_para_update;
    public $con_campos_auditoria=true;
    public $campos_lookup=array();
    public $tablas_lookup=array();
    function definir_campos_genericos_al_final(){
        if($this->con_campos_auditoria){
            $this->definir_campo(($this->obtener_prefijo()?$this->obtener_prefijo().'_tlg':'tlg'),array('hereda'=>'tiempo_logico','modo'=>'fk_obligatoria')); 
        }
    }
    function __construct($nombre_tabla=false,$sufijo_clase=""){
        if($nombre_tabla){
            $this->nombre_tabla=$nombre_tabla;
            if(!is_string($nombre_tabla)){
                throw new Exception_Tedede("el nombre de tabla tiene que ser un string y es ".(@get_class($nombre_tabla)).' o '.gettype($nombre_tabla));
            }
            if(!preg_match('/^\W+$/',$nombre_tabla)){
                throw new Exception_Tabla_nombre_invalido("nombre invalido de tabla ".$this->nombre_tabla);
            }
            $this->sufijo_clase=$sufijo_clase;
        }else{
            $this->nombre_tabla=get_class($this);
            $this->nombre_tabla=quitar_prefijo($this->nombre_tabla,'Tabla_');
            $lugar_doble_raya=strpos($this->nombre_tabla,'__');
            if($lugar_doble_raya){
                $this->sufijo_clase=substr($this->nombre_tabla,$lugar_doble_raya);
                $this->nombre_tabla=substr($this->nombre_tabla,0,$lugar_doble_raya);
            }
        }
        $this->nombre_tabla_o_vista=$this->nombre_tabla;
        parent::__construct();
    }
    function campos_select(){
        return implode(', ',array_merge(array_keys($this->campos),array_keys($this->campos_lookup)));
    }
    private function definir_pk($array_nombres_campos){
        // $this->pk=array_append($this->pk,$array_nombres_campos);
        $this->pk=$array_nombres_campos;
    }
    protected/* Ojo private*/ function definir_fk($array_nombres_campos,$tabla_destino){
        $this->fks[$tabla_destino->nombre_tabla]=
            array('campos_origen'=>$array_nombres_campos,
                'tabla_destino'=>$tabla_destino,
                'campos_destino'=>$tabla_destino->obtener_nombres_campos_pk(),
                'nombre_constraint'=>$this->nombre_tabla.'_'.$tabla_destino->nombre_tabla.'_fk'
            );
    }
    protected function definir_tablas_hijas($tablas_hijas){
        $this->tablas_hijas=array_merge($this->tablas_hijas,$tablas_hijas);
    }
    function definicion_tabla($tabla){
        if(isset($this->definicion_tablas[$tabla])){
            $devolver=$this->definicion_tablas[$tabla];
        }else{
            $clase="Tabla_".$tabla.$this->sufijo_clase;
            if(!class_exists($clase)){
                $clase="Tabla_".$tabla;
            }
            if(!class_exists($clase)){
                throw new Exception_Tedede("No existe la clase interna $clase en los php");
            }
            $this->definicion_tablas[$tabla]=new $clase();
            $devolver=$this->definicion_tablas[$tabla];
        }
        $this->definicion_tablas[$tabla]->sufijo_clase=$this->sufijo_clase;
        if(isset($this->contexto)){
            $devolver->contexto=$this->contexto;
        }
        if(isset($this->despliegue)){
            $devolver->despliegue=$this->despliegue;
        }
        return $devolver;
    }
    function instalar_automaticamente(){
        return get_class($this)!=='Tabla'; // poner en FALSE las tablas de los casos de prueba o cualquier otra cosa que no deba instalarse con instalador.php
    }
    function sql_creacion_tabla(){
        return new Sql("create table ".$this->nombre_esquema.".".$this->nombre_tabla.'()');
    }
    private function parte_alter_table(){
        return 'alter table '.$this->nombre_esquema.'.'.$this->nombre_tabla;
    }
    function sql_creacion_campo($nombre_campo){
        $def_campo=$this->campos[$nombre_campo];
        return new Sql($this->parte_alter_table()
                        .' add column '.$nombre_campo
                        .' '.$def_campo->sql_tipo_creacion()
                    );
    }
    function sqls_creacion_campos(){
        $sqls=new Sqls();
        foreach($this->campos as $nombre_campo=>$def_campo){
            $sqls->agregar($this->sql_creacion_campo($nombre_campo));
        }
        return $sqls;
    }
    function sql_modificacion_campos(){
        $arr=array();
        foreach($this->campos as $nombre_campo=>$def_campo){
            $prefijo_alter_table_del_campo=$this->parte_alter_table().' alter column '.$nombre_campo;
            $arr[]=$prefijo_alter_table_del_campo.' '.$def_campo->sql_modificacion_tipo();
            $arr[]=$prefijo_alter_table_del_campo.' '.$def_campo->sql_modificacion_nulleable();
            $arr[]=$prefijo_alter_table_del_campo.$def_campo->sql_modificacion_default();
        }
        return $arr;
    }
    function sql_creacion_pk(){
        $strpk=$this->parte_alter_table().' add primary key(';
        $separador='';
        foreach ($this->pk as $campk){
            $strpk.= $separador.$campk ;
            $separador=',';
        }
        $strpk.=')';
        return new Sql($strpk);
    }
    function sql_eliminacion_fk($nombre_tabla_destino){
        $fk=$this->fks[$nombre_tabla_destino];
        $sql=$this->parte_alter_table().' drop constraint '.$fk['nombre_constraint'];
        return new Sql($sql);
    }
    function sql_creacion_fk($nombre_tabla_destino){
        $fk=$this->fks[$nombre_tabla_destino];
        $sql=$this->parte_alter_table();
        $sql.=' add constraint '.$fk['nombre_constraint'];
        $sql.=' foreign key (';
        $sql.=implode(',',$fk['campos_origen']);
        $sql.=') references ';    
        $sql.=$fk['tabla_destino']->obtener_nombre_de_esquema().'.'.$fk['tabla_destino']->obtener_nombre_de_tabla();
        $sql.='('.implode(',',$fk['campos_destino']).')';
        // $tabla=$this->definicion_tabla)
        Loguear('2012-03-28','TABLA DESTINO : '.json_encode($fk['tabla_destino']));
        if($fk['tabla_destino']->heredar_en_cascada){
            Loguear('2012-03-28','TABLA DESTINO : &&&&&&&&&&&&&&&&&&&');
            $sql.=' on update cascade';
        }
        return new Sql($sql);
    }
    function sqls_creacion_fks(){
        $sqls=new Sqls();
        foreach($this->fks as $nombre_tabla_destino=>$fk){
            $sqls->agregar($this->sql_creacion_fk($nombre_tabla_destino));
        }
        return $sqls;
    }
    protected function ejecutar_creacion_restricciones_enumerados(){
        foreach($this->campos as $nombre_campo=>$def_campo){
            if($def_campo->tipo=='enumerado'){
                // OJO FALTA QUOTEAR el nombre de campo
                $sentencia='check ('.$this->contexto->db->quote($nombre_campo,'campo').' in (';
                $coma='';
                foreach($def_campo->elementos as $valor_elemento){
                    $sentencia.=$coma.$this->contexto->db->quote($valor_elemento);
                    $coma=',';
                }
                $sentencia.='))';
                $this->contexto->db->ejecutar_sql(
                    new Sql_Restriccion(
                        $this->nombre_esquema,
                        $this->nombre_tabla,
                        "valor invalido en $nombre_campo",
                        $sentencia
                    )
                );
            }
        }
    }
    protected function ejecutar_creacion_restricciones_unicos(){
        foreach($this->unicos as $nombre=>$campos){
            $this->contexto->db->ejecutar_sql(new Sql($this->parte_alter_table().' add constraint "'.$nombre.' debe ser unico" unique ('.implode(', ',$campos).')'));
        }
    }
    function ejecutar_creacion_restricciones(){
        $this->necesita_contexto_para('para crear restricciones en la base');
        $this->ejecutar_creacion_restricciones_enumerados();
        $this->ejecutar_creacion_restricciones_unicos();
        // $sqls->agregar($this->sqls_creacion_restricciones_texto());
    }
    function obtener_padres(){
        $padres=array();
        foreach($this->fks as $fk){
            $padres[]=$fk['tabla_destino'];
        }
        return $padres;
    }
    function ejecutar_instalacion_agregar_datos(){
        // USAR ESTO PARA AGREGAR DATOS INICIALES
    }
    function ejecutar_instalacion($con_dependientes=TRUE){
        $this->necesita_contexto_para('instalar','instalada');
        $this->ejecutar_creacion_tabla();
        $this->ejecutar_creacion_campos();
        $this->ejecutar_creacion_pk();
        $this->ejecutar_creacion_fks();
        $this->ejecutar_creacion_restricciones();
        $this->ejecutar_instalacion_agregar_datos();
        $this->contexto->instalada[$this->nombre_tabla]=true;
        if($con_dependientes){
            foreach($this->obtener_dependientes() as $dependiente){
                if(!@$this->contexto->instalada[$dependiente->nombre_tabla]){
                    $falta_instalar_un_padre=false;
                    foreach($dependiente->obtener_padres() as $padre){
                        if(!@$this->contexto->instalada[$padre->nombre_tabla]){
                            $falta_instalar_un_padre=true;
                        }
                    }
                    if(!$falta_instalar_un_padre){
                        $dependiente->contexto=$this->contexto;
                        $dependiente->ejecutar_instalacion();
                    }
                }
            }
        }
        foreach($this->restricciones_especificas() as $sql){
            $this->contexto->db->ejecutar_sql($sql);
        }
    }
    function restricciones_especificas(){
        return array();
    }
    function obtener_nombre_de_tabla(){
        return $this->nombre_tabla;
    }
    function sql_update_unico_o_varios($filtro, $unico){
        $params=array();
        $valores_para_update=array();
        $f=$this->contexto->nuevo_objeto("Filtro_Normal",$filtro,$this);
        // $campos_a_recuperar=array();
        foreach(array_merge($this->valores_de_auditoria(),$this->valores_para_update) as $campo=>$valor){
            if(array_key_exists($campo, $this->campos)){
                if(is_array($valor) && isset($valor['expresion'])){
                    $valores_para_update[]="$campo={$valor['expresion']}";
                }else{
                    if($valor===null && isset($this->definiciones_campo_originales[$campo]['forzar_null_a_vacio']) && $this->definiciones_campo_originales[$campo]['forzar_null_a_vacio']===true){
                        $f->parametros[":set_$campo"]='';
                        $valores_para_update[]="$campo=:set_$campo";
                    }else{
                        $f->parametros[":set_$campo"]=$valor;
                        $valores_para_update[]="$campo=:set_$campo";
                    }
                }
                // $campos_a_recuperar[]=$campo;
            }
        }
        $sentencia='update '.$this->obtener_nombre_de_esquema()
                            .'.'.$this->obtener_nombre_de_tabla()
                            .' set '.implode(", ", $valores_para_update)
                            .' where '.$f->where;
        if($unico){
            /*
            foreach($this->pk as $campo_pk){
                if(!array_key_exists($campo_pk,$this->valores_para_update)){
                    $campos_a_recuperar[]=$campo_pk;
                }
            }
            $sentencia.=" returning ".implode(', '.$campos_a_recuperar);
            */
            $sentencia.=" returning *";
        }
        return new Sql($sentencia,$f->parametros);            
    }
    function ejecutar_update_unico($filtro,$lanzar_excepcion_si_no_es_uno=true){
        $this->necesita_contexto_para('modificar la base con update');
        // si el campo a actualizar tiene un valor por default en la tabla correspondiente y el valor para actualizar viene nulo, 
        // debe tomar el valor por default
        $sql=$this->sql_update_unico_o_varios($filtro,true);
        $this->contexto->db->ejecutar_sql($sql);
        $this->resultado=$this->contexto->db->ultima_consulta;
        if($this->contexto->db->ultima_consulta->rowCount()==1){
            $this->datos=$this->contexto->db->ultima_consulta->fetchObject();
        }else{
            if($lanzar_excepcion_si_no_es_uno){
                throw new Exception_Tedede("Se esperaba que el UPDATE de ".$this->nombre_tabla." modificara un registro y modifico ".$this->contexto->db->ultima_consulta->rowCount().' '.json_encode($filtro));
            }
        }
    }
    function sql_update_varios($filtro){
        return $this->sql_update_unico_o_varios($filtro, false);
    }
    function ejecutar_update_varios($filtro){
        $sql=$this->sql_update_unico_o_varios($filtro, false);
        $this->contexto->db->ejecutar_sql($sql);
        $this->resultado=$this->contexto->db->ultima_consulta;
    }
    function sql_delete_unico_o_varios($filtro, $unico){
        $params=array();
        $f=$this->contexto->nuevo_objeto("Filtro_Normal",$filtro,$this);
        $sentencia='delete from '.$this->obtener_nombre_de_esquema()
                            .'.'.$this->obtener_nombre_de_tabla()
                            .' where '.$f->where;
        if($unico){
            $sentencia.=" returning *";
        }
        return new Sql($sentencia,$f->parametros);  
    }
    function ejecutar_delete_varios($filtro){
        //$this->necesita_contexto_para('borrar');
        $sql=$this->sql_delete_unico_o_varios($filtro, false);
        $this->contexto->db->ejecutar_sql($sql);
        $this->resultado=$this->contexto->db->ultima_consulta;        
    }
    function ejecutar_delete_uno($filtro){
        //$this->necesita_contexto_para('borrar');
        $sql=$this->sql_delete_unico_o_varios($filtro, true);
        $this->contexto->db->ejecutar_sql($sql);
        $this->resultado=$this->contexto->db->ultima_consulta;        
    }
    function valores_de_auditoria(){
        if(!$this->con_campos_auditoria){
            return array();
        }
        return array(
            $this->obtener_prefijo().'_tlg'=>obtener_tiempo_logico($this->contexto)
        );
    }
    function sqls_insercion(){
        $params=array();
        $campos=array();
        $valores=array();
        foreach(array_merge($this->valores_de_auditoria(),$this->valores_para_insert) as $campo=>$valor){
            if(array_key_exists($campo,$this->campos)){
                $params[":$campo"]=$valor;
                $valores[]=":$campo";
                $campos[]=$campo;
            }else{
                throw new Exception("No existe el campo $campo en ".get_class($this));
            }
        }
        return new Sql('insert into '.$this->obtener_nombre_de_esquema()
                            .'.'.$this->obtener_nombre_de_tabla()
                            .'('.implode(', ',$campos)
                            .') values ('.implode(', ',$valores)
                            .')'.(isset($this->expresiones_returning)?' returning '.implode(', ',$this->expresiones_returning):''),
                       $params);
    }
    function obtener_fks(){
        return $this->fks;
    }
    function depende_de($nombre_de_tabla){
        foreach($this->fks as $fk){
            if ($fk['tabla_destino']->obtener_nombre_de_tabla()==$nombre_de_tabla){
                return true;
            }
        }
        return false; 
    }
    function obtener_dependientes(){
        $dependientes=array();
        foreach($this->tablas_hijas as $tabla=>$hereda_pk){
            $dependientes[]=$this->definicion_tabla($tabla);
        }
        return $dependientes;
    }
    function ejecutar_borrar_todo_el_contenido(){
        $this->necesita_contexto_para('borrar');
        $this->contexto->db->ejecutar_sql(new Sql("delete from ".$this->nombre_esquema.".".$this->nombre_tabla));
    }
    function obtener_nombre_tabla_singular(){
        return $this->nombre_tabla;
    }
    function desplegar_encabezado(){
        $prefijo=$this->prefijo;
        $this->contexto->salida->abrir_grupo_interno("desp_{$prefijo} desp_encabezado");
            $this->contexto->salida->enviar($this->obtener_nombre_tabla_singular(),"desp_{$prefijo} desp_celda");
            foreach($this->campos as $campo=>$definicion){
                $this->contexto->salida->enviar(
                    (string)($this->datos->$campo),
                    "desp_{$prefijo} desp_celda",array('title'=>$campo)
                );
            }
        $this->contexto->salida->cerrar_grupo_interno();
    }
    function desplegar(){
        $this->necesita_datos_para('desplegar');
        $prefijo=$this->prefijo;
        $this->contexto->salida->abrir_grupo_interno("desp_{$prefijo} desp_todo");
            $this->desplegar_encabezado();
            $this->contexto->salida->abrir_grupo_interno("desp_{$prefijo} desp_contenido");
            $this->desplegar_subtablas();
            $this->contexto->salida->cerrar_grupo_interno();
        $this->contexto->salida->cerrar_grupo_interno();
    }
    function desplegar_subtablas(){
    }
    function desplegar_subtabla($nombre_tabla){
        $tabla=$this->definicion_tabla($nombre_tabla);
        if(!isset($tabla->fks[$this->nombre_tabla])){
            // echo "<BR>".var_export($tabla,true);
            /* 
            echo "<pre>";
            print_r($tabla);
            echo "</pre>";
            // */
            throw new Exception_Tedede("Error falta la definición de la fk al desplegar_subtabla $nombre_tabla de {$this->nombre_tabla}");
        }
        $definicion_fk=$tabla->fks[$this->nombre_tabla];
        $filtro=array();
        foreach(array_combine($definicion_fk['campos_origen'],$definicion_fk['campos_destino']) as $campo_hija=>$campo_padre){
            $filtro[$campo_hija]=$this->datos->{$campo_padre};
        }
        $tabla->leer_varios(array('blo_ope'=>$this->datos->for_ope,'blo_for'=>$this->datos->for_for));
        while($tabla->obtener_leido()){
            $tabla->desplegar();
        }
    }
    function ejecutar_insercion(){
        $sqls=$this->sqls_insercion();
        $this->contexto->db->ejecutar_sqls($sqls);
        if(isset($this->expresiones_returning)){
            $this->retorno=$this->contexto->db->ultima_consulta->fetchObject();
        }
    }
    function ejecutar_insercion_si_no_existe(){
        $filtro=array();
        foreach($this->pk as $campo_pk){
            if(!isset($this->valores_para_insert[$campo_pk])){
                throw new Exception_Tedede("para poder ejecutar ejecutar_insercion_si_no_existe en ".get_class($this)." se necesita la pk completa y falta ".$campo_pk);
            }
            $filtro[$campo_pk]=$this->valores_para_insert[$campo_pk];
        }
        $this->leer_varios($filtro);
        if(!$this->obtener_leido()){
            $this->ejecutar_insercion();
        }
    }
    function traer_tabla_con_datos($nombre_tabla){
        $tabla_relacionada=$this->definicion_tabla($nombre_tabla);
        if(isset($this->fks[$nombre_tabla])){
            $definicion_fk=$this->fks[$nombre_tabla];
            $filtro=array();
            foreach($definicion_fk['campos_origen'] as $num=>$campo_origen){
                $campo_destino=$definicion_fk['campos_destino'][$num];
                if(!$this->datos){
                    throw new Exception_Tedede("No se puede traer_tabla_con_datos de la tabla $nombre_tabla en ".$this->nombre_tabla." porque no tiene datos leidos");
                }
                $filtro[$campo_destino]=$this->datos->{$campo_origen};
            }
            $tabla_relacionada->leer_unico($filtro);
            return $tabla_relacionada;
        }else{
            throw new Exception_Tedede("No se puede traer_datos de la tabla $nombre_tabla en ".$this->nombre_tabla." porque no es fk");
        }
    }
    function clausula_from(){
        $rta="{$this->nombre_esquema}.{$this->nombre_tabla_o_vista}";
        foreach($this->tablas_lookup as $tabla=>$join){
            $rta.=" left join $tabla on $join";
        }
        return $rta;
    }
    function ultimo_campo_pk(){
        return $this->pk[count($this->pk)-1];
    }
    function campos_a_mostrar_en_lista_opciones(){
        $rta=array($this->ultimo_campo_pk());
        foreach($this->campos as $nombre=>$campo){
            if(@$campo->es_nombre || @$campo->mostrar_al_elegir){
                $rta[]=$nombre;
            }
        }
        return $rta;
    }
    function lista_opciones($filtro_para_lectura, $campo_para_opciones=FALSE){
        $rta=array();
        $this->leer_varios($filtro_para_lectura);
        $campos=$this->campos_a_mostrar_en_lista_opciones();
        while($this->obtener_leido()){
            $id_opcion=$this->datos->{$campo_para_opciones?:$this->ultimo_campo_pk()};
            $rta[$id_opcion]=array();
            foreach($campos as $campo){
                $rta[$id_opcion][]=$this->datos->{$campo};
            }
        }
        return $rta;
    }
    function agregar_columna_si_no_existe($nombre_campo){
        if(!$this->contexto->db->existe_columna($this->nombre_esquema,$this->nombre_tabla,$nombre_campo)){
            $this->ejecutar_creacion_campo($nombre_campo);
        }
    }
    function filtro_registros_editables(){
        return null;
    }
}

class Tabla_de_ejemplo_con_nombre_invalido extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('');
        $this->con_campos_auditoria=false;
    }
    function __construct(){
        parent::__construct('nombre con espacios');
    }
}

class Tabla_de_ejemplo2 extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('pre2');
        $this->heredar_en_cascada=true;
        $this->con_campos_auditoria=false;
        $this->definir_esquema('de_ejemplo');
        $this->definir_campo('pre2_codigo',array('es_pk'=>true,'tipo'=>'texto','largo'=>10));
        $this->definir_campo('pre2_num',array('es_pk'=>true,'tipo'=>'entero','not_null'=>true));
    }
    function instalar_automaticamente(){
        return false;
    }
}

class Tabla_de_ejemplo3 extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('pre3');
        $this->con_campos_auditoria=false;
        $this->definir_esquema('de_ejemplo');
        $this->definir_campo('pre3_codigo',array('es_pk'=>true,'tipo'=>'texto','largo'=>10));
        $this->definir_campo('pre3_enum',array('tipo'=>'enumerado','elementos'=>array('uno','dos','uno y medio')));
        $this->definir_campo('pre3_unico',array('tipo'=>'enumerado','elementos'=>array('unico')));
    }
    function instalar_automaticamente(){
        return false;
    }
}

class Tabla_de_ejemplo__para_probar extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('');
        $this->con_campos_auditoria=false;
        $this->definir_esquema('de_ejemplo');
        $otra2=new Tabla_de_ejemplo2();
        $otra3=new Tabla_de_ejemplo3();
        $this->definir_campo('codigo',array('es_pk'=>true,'tipo'=>'texto','largo'=>10));
        $this->definir_campo('numero',array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('logico',array('tipo'=>'logico', 'def'=>false));
        $this->definir_fk(array('codigo','numero'),$otra2);
        $this->definir_fk(array('codigo'),$otra3);
    }
    function instalar_automaticamente(){
        return false;
    }
}

class Tabla_de_ejemplo_hija extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('hija');
        $this->con_campos_auditoria=false;
        $this->definir_esquema('de_ejemplo');
        $this->definir_campo('hija_abuelo',array('hereda'=>'de_ejemplo_abuelo','modo'=>'pk'));
        $this->definir_campo('hija_padre',array('hereda'=>'de_ejemplo_padre','modo'=>'pk'));
        $this->definir_campo('hija_hija',array('es_pk'=>true,'tipo'=>'texto','largo'=>11));
        $this->definir_campo('hija_dato',array('tipo'=>'texto','def'=>'este texto'));
    }
}

class Tabla_de_ejemplo_abuelo extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('abuelo');
        $this->con_campos_auditoria=false;
        $this->definir_esquema('de_ejemplo');
        $this->definir_campo('abuelo_abuelo',array('es_pk'=>true,'tipo'=>'texto','largo'=>10));
        $this->definir_tablas_hijas(array('de_ejemplo_padre'=>true,'de_ejemplo_hija'=>true));
    }
}

class Tabla_de_ejemplo_padre extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('padre');
        $this->con_campos_auditoria=false;
        $this->definir_esquema('de_ejemplo');
        $this->definir_campo('padre_abuelo',array('hereda'=>'de_ejemplo_abuelo','modo'=>'pk'));
        $this->definir_campo('padre_padre',array('es_pk'=>true,'tipo'=>'texto','largo'=>10));
        $this->definir_campo('padre_dato',array('tipo'=>'texto'));
        $this->definir_tablas_hijas(array('de_ejemplo_hija'=>true));
    }
}

class Prueba_de_tablas_sin_acceso extends Pruebas{
    function __construct(){
        $this->contexto=new Contexto();
        $this->contexto->db=new Base_de_Datos_Falsa_para_Probar();
    }
    function probar_crear_tabla(){
        $tabla=new Tabla_de_ejemplo__para_probar();
        $tabla->contexto=$this->contexto;
        $tabla->ejecutar_creacion_tabla();
        $sql=$this->contexto->db->extraer_unico_sql();
        $this->probador->verificar_texto("create table de_ejemplo.de_ejemplo()", $sql->sql);
    }
    function probar_creacion_campos(){
        $tabla=new Tabla_de_ejemplo__para_probar();
        $this->probador->verificar_sqls(
            array('alter table de_ejemplo.de_ejemplo add column codigo varchar(10) not null'
                , 'alter table de_ejemplo.de_ejemplo add column numero integer not null'
                , 'alter table de_ejemplo.de_ejemplo add column logico boolean default false'
            )
            , $tabla->sqls_creacion_campos()
        );
    }
    function probar_modificacion_campos(){
        $tabla=new Tabla_de_ejemplo__para_probar();
        $this->probador->verificar_arreglo(
            array('alter table de_ejemplo.de_ejemplo alter column codigo type varchar(10)'
                , 'alter table de_ejemplo.de_ejemplo alter column codigo set not null'
                , 'alter table de_ejemplo.de_ejemplo alter column codigo drop default'
                , 'alter table de_ejemplo.de_ejemplo alter column numero type integer'
                , 'alter table de_ejemplo.de_ejemplo alter column numero set not null'
                , 'alter table de_ejemplo.de_ejemplo alter column numero drop default'
                , 'alter table de_ejemplo.de_ejemplo alter column logico type boolean'
                , 'alter table de_ejemplo.de_ejemplo alter column logico drop not null'
                , 'alter table de_ejemplo.de_ejemplo alter column logico set default false'
            )
            , $tabla->sql_modificacion_campos()
        );
    }
    function probar_obtener_la_definicion_del_campo_para_poder_definir_otro(){
        $tabla=new Tabla_de_ejemplo__para_probar();
        $this->probador->verificar_arreglo_asociativo(
            array('tipo'=>'logico', 'def'=>false),
            $tabla->definicion_campo('logico')
        );
    }
    function probar_creacion_pk(){
        $tabla=new Tabla_de_ejemplo__para_probar();
        $this->probador->verificar_sqls(
            'alter table de_ejemplo.de_ejemplo add primary key(codigo,numero)'
            , $tabla->sql_creacion_pk()
        );
    }
    function probar_creacion_de_fks(){
        // $this->probador->pendiente_ticket(358);
        $tabla=new Tabla_de_ejemplo__para_probar();
        $this->probador->verificar_sqls(array(
            'alter table de_ejemplo.de_ejemplo add constraint de_ejemplo_de_ejemplo2_fk foreign key (codigo,numero) references de_ejemplo.de_ejemplo2(pre2_codigo,pre2_num) on update cascade',
            'alter table de_ejemplo.de_ejemplo add constraint de_ejemplo_de_ejemplo3_fk foreign key (codigo) references de_ejemplo.de_ejemplo3(pre3_codigo)',
            )
            , $tabla->sqls_creacion_fks()
        );
    }
    function probar_dependencias_de_fks(){
        //$this->probador->pendiente_ticket(359);
        $tabla=new Tabla_de_ejemplo__para_probar();
        $tabla2=new Tabla_de_ejemplo2();
        $this->probador->verificar(TRUE, $tabla->depende_de($tabla2->obtener_nombre_de_tabla()));
        $this->probador->verificar(FALSE, $tabla2->depende_de($tabla->obtener_nombre_de_tabla()));
    }
    function probar_sqls_creacion_restricciones(){
        // $this->probador->pendiente_ticket(360);
        $tabla3=new Tabla_de_ejemplo3();
        $tabla3->contexto=$this->contexto;
        $tabla3->ejecutar_creacion_restricciones();
        $sqls_obtenidas=$this->contexto->db->extraer_sqls();
        $this->probador->verificar_sqls(array(
                "alter table de_ejemplo.de_ejemplo3 add constraint \"valor invalido en pre3_enum\" check (`pre3_enum` in ('uno','dos','uno y medio'))",
                "alter table de_ejemplo.de_ejemplo3 add constraint \"valor invalido en pre3_unico\" check (`pre3_unico` in ('unico'))"
            ),
            $sqls_obtenidas
        );
    }
    function probar_heredar_pk(){
        // $tabla_padre=new Tabla_de_ejemplo_padre();
        $tabla_hija=new Tabla_de_ejemplo_hija();
        $this->probador->verificar_sqls(array(
            "alter table de_ejemplo.de_ejemplo_hija add column hija_abuelo varchar(10) not null",
            "alter table de_ejemplo.de_ejemplo_hija add column hija_padre varchar(10) not null",
            "alter table de_ejemplo.de_ejemplo_hija add column hija_hija varchar(11) not null",
            "alter table de_ejemplo.de_ejemplo_hija add column hija_dato text default 'este texto'"
            ),
            $tabla_hija->sqls_creacion_campos()
        );
        $this->probador->verificar_sqls(
            "alter table de_ejemplo.de_ejemplo_hija add primary key(hija_abuelo,hija_padre,hija_hija)"
            ,
            $tabla_hija->sql_creacion_pk()
        );
        $this->probador->verificar_sqls(array(
            "alter table de_ejemplo.de_ejemplo_hija add constraint de_ejemplo_hija_de_ejemplo_abuelo_fk foreign key (hija_abuelo) references de_ejemplo.de_ejemplo_abuelo(abuelo_abuelo)",
            "alter table de_ejemplo.de_ejemplo_hija add constraint de_ejemplo_hija_de_ejemplo_padre_fk foreign key (hija_abuelo,hija_padre) references de_ejemplo.de_ejemplo_padre(padre_abuelo,padre_padre)"
            ),
            $tabla_hija->sqls_creacion_fks()
        );
    }
    function probar_insercion(){
        // se prueba dentro del insertador_multiple.php
    }
    function probar_nombre_valido_de_tabla(){
        try{
            $tabla=new Tabla_de_ejemplo_con_nombre_invalido();
            $this->probador->informar_error('debió dar error porque el nombre de tabla era inválido');
        }catch(Exception_Tabla_nombre_invalido $e){
        }
    }
}


class Tabla_de_ejemplo4 extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('');
        $this->con_campos_auditoria=false;
        $this->definir_esquema('de_ejemplo');
        $this->definir_campo('codigo',array('es_pk'=>true,'tipo'=>'texto','largo'=>10));
        $this->definir_campo('numero',array('tipo'=>'entero'));
        $this->definir_campo('logico',array('tipo'=>'logico', 'def'=>false));
    }
    function instalar_automaticamente(){
        return false;
    }
}

class Prueba_de_tablas_con_acceso extends Pruebas{
    function __construct(){
        parent::__construct();
        global $db;
        $this->contexto=new Contexto();
        $this->contexto->db=$db;
        $this->contexto->db->log_parametros_separados=true;
    }
    function pre_probar_para_clase(){
        $this->esquema=new Esquema_de_ejemplo();
        $this->esquema->contexto=$this->contexto;
        try{
            $this->esquema->ejecutar_instalacion();
        }catch(Exception $err){
            if(strpos($err->getMessage(),'permiso denegado')!==false){
                global $parametros_db;
                $this->contexto->salida->enviar('FALTA DAR PERMISOS: grant create on database '.$parametros_db->base_de_datos.' to tedede_php;','mensaje_error_grave');
            }
            throw $err; 
        }
        $this->tablas=(object) array();
        $this->tablas->de_ejemplo4=new Tabla_de_ejemplo4();
        $this->tablas->de_ejemplo4->contexto=$this->contexto;
        $this->tablas->de_ejemplo4->ejecutar_instalacion();
        $this->tablas->de_ejemplo_abuelo=new Tabla_de_ejemplo_abuelo();
        $this->tablas->de_ejemplo_abuelo->contexto=$this->contexto;
        $this->tablas->de_ejemplo_abuelo->ejecutar_instalacion();
        $this->tablas->de_ejemplo_padre=new Tabla_de_ejemplo_padre();
        $this->tablas->de_ejemplo_padre->contexto=$this->contexto;
    }
    function pos_probar_para_todo(){
        $this->tablas->de_ejemplo4->ejecutar_borrar_todo_el_contenido();
    }
    function probar_insert_y_select(){
        $valores_para_insert=array(
            'codigo'=>'A1',
            'numero'=>33,
            'logico'=>true,
        );
        $this->tablas->de_ejemplo4->valores_para_insert=$valores_para_insert;
        $this->tablas->de_ejemplo4->ejecutar_insercion();
        $this->tablas->de_ejemplo4->leer_unico(array('codigo'=>'A1'));
        $this->probador->verificar_via_json(
            $valores_para_insert,
            $this->tablas->de_ejemplo4->datos
        );
    }
    function probar_update_unico(){
        $valores_para_insert=array(
            'codigo'=>'A1',
            'numero'=>33,
            'logico'=>false,
        );
        $valores_que_voy_a_updatear=array(
            'codigo'=>'A2',
            'numero'=>30,
            'logico'=>true,
        );
        $varios_valores_para_insert=array($valores_para_insert, $valores_que_voy_a_updatear);
        foreach($varios_valores_para_insert as $valores){
            $this->tablas->de_ejemplo4->valores_para_insert=$valores;
            $this->tablas->de_ejemplo4->ejecutar_insercion();
        }
        $this->tablas->de_ejemplo4->valores_para_update=array('logico'=>false, 'numero'=>34);
        $this->tablas->de_ejemplo4->ejecutar_update_unico(array('codigo'=>'A2'));
        $this->tablas->de_ejemplo4->leer_unico(array('codigo'=>'A2'));
        $this->probador->verificar_via_json(
            array(
                'codigo'=>'A2',
                'numero'=>34,
                'logico'=>false,
            ),
            $this->tablas->de_ejemplo4->datos
        );
        $this->tablas->de_ejemplo4->leer_unico(array('codigo'=>'A1'));
        $this->probador->verificar_via_json(
            $valores_para_insert,
            $this->tablas->de_ejemplo4->datos
        );
        // probamos poner null
        $this->tablas->de_ejemplo4->valores_para_update=array('logico'=>null, 'numero'=>null);
        $this->tablas->de_ejemplo4->ejecutar_update_unico(array('codigo'=>'A2'));
        $this->tablas->de_ejemplo4->leer_unico(array('codigo'=>'A2'));
        $this->probador->verificar_via_json(
            array(
                'codigo'=>'A2',
                'numero'=>null,
                'logico'=>null,
            ),
            $this->tablas->de_ejemplo4->datos
        );
    }
    function probar_leer_varios_con_formulas(){
        $this->probador->pendiente_ticket(0);
        $valores_para_insert=array(
            'codigo'=>'A1',
            'numero'=>33,
            'logico'=>false,
        );
        $valores_que_voy_a_updatear=array(
            'codigo'=>'A2',
            'numero'=>30,
            'logico'=>true,
        );
        $valores_adicionales_para_formulas=array(
            'codigo'=>'A3',
            'numero'=>27,
            'logico'=>true,
        );
        $varios_valores_para_insert=array($valores_para_insert, $valores_que_voy_a_updatear, $valores_adicionales_para_formulas);
        foreach($varios_valores_para_insert as $valores){
            $this->tablas->de_ejemplo4->valores_para_insert=$valores;
            $this->tablas->de_ejemplo4->ejecutar_insercion();
        }
        //$this->tablas->de_ejemplo4->valores_para_update=array('logico'=>false, 'codigo'=>'A4');
        //$this->tablas->de_ejemplo4->ejecutar_update_unico(array('numero'=>33));
        $this->tablas->de_ejemplo4->leer_unico(array('codigo'=>'A2'));
        $this->probador->verificar_via_json(
            array(
                'codigo'=>'A3',
                'numero'=>27,
                'logico'=>true,
            ),
            $this->tablas->de_ejemplo4->datos
        );
    }
    function probar_falla_update_unico_vacio(){
        $this->probador->pendiente_ticket(381);
        try{
            $this->tablas->de_ejemplo4->valores_para_update=array('logico'=>null, 'numero'=>null);
            $this->tablas->de_ejemplo4->ejecutar_update_unico(array('codigo'=>'A2'));
            $this->probador->informar_error('debió lanzar una excepción porque el update no modificó ninguna fila');
        }catch(Exception_Tedede $e){
        }
    }
    function probar_falla_update_unico_multiple(){
        $this->probador->pendiente_ticket(381);
        $this->tablas->de_ejemplo4->valores_para_insert=array('numero'=>7);
        foreach(array('A1','A2','A3') as $codigo){
            $this->tablas->de_ejemplo4->valores_para_insert['codigo']=$codigo;
            $this->tablas->de_ejemplo4->ejecutar_insercion();
        }
        try{
            $this->tablas->de_ejemplo4->valores_para_update=array('logico'=>true);
            $this->tablas->de_ejemplo4->ejecutar_update_unico(array('numero'=>'7'));
            $this->probador->informar_error('debió lanzar una excepción porque el update modificó varias filas');
        }catch(Exception_Tedede $e){
        }
    }
    function probar_insercion_si_no_existe(){
        $valores_para_insert=array(
            'codigo'=>'A12',
            'numero'=>3333,
            'logico'=>true,
        );
        $this->tablas->de_ejemplo4->valores_para_insert=$valores_para_insert;
        $this->tablas->de_ejemplo4->ejecutar_insercion_si_no_existe();
        $this->tablas->de_ejemplo4->leer_unico(array('codigo'=>'A12'));
        $this->probador->verificar_via_json(
            $valores_para_insert,
            $this->tablas->de_ejemplo4->datos
        );
        $this->tablas->de_ejemplo4->ejecutar_insercion_si_no_existe();
    }
    function probar_insercion_de_cadena_vacia(){
        $valores_para_insert=array(
            'codigo'=>'',
            'numero'=>null,
            'logico'=>false,
        );
        $this->tablas->de_ejemplo4->valores_para_insert=$valores_para_insert;
        $this->tablas->de_ejemplo4->ejecutar_insercion();
        $this->tablas->de_ejemplo4->leer_unico(array('codigo'=>''));
        $this->probador->verificar_via_json(
            $valores_para_insert,
            $this->tablas->de_ejemplo4->datos
        );
    }
    function probar_traer_datos(){
        $this->tablas->de_ejemplo_abuelo->valores_para_insert=array('abuelo_abuelo'=>'El abuelo');
        $this->tablas->de_ejemplo_abuelo->ejecutar_insercion();
        $this->tablas->de_ejemplo_padre->valores_para_insert=array('padre_abuelo'=>'El abuelo','padre_padre'=>'El padre');
        $this->tablas->de_ejemplo_padre->ejecutar_insercion();
        $this->tablas->de_ejemplo_padre->leer_varios(array());
        $this->tablas->de_ejemplo_padre->obtener_leido();
        $tabla_abuelo=$this->tablas->de_ejemplo_padre->traer_tabla_con_datos('de_ejemplo_abuelo');
        $this->probador->verificar_via_json(
            'El abuelo',
            $tabla_abuelo->datos->abuelo_abuelo
        );
    }
    function probar_leer_unico_desde_tabla(){
        $this->tablas->de_ejemplo_padre->leer_varios(array());
        $this->tablas->de_ejemplo_padre->obtener_leido();
        $tabla_abuelo=$this->tablas->de_ejemplo_padre->definicion_tabla('de_ejemplo_abuelo');
        $tabla_abuelo->leer_unico($this->tablas->de_ejemplo_padre);
        $this->probador->verificar_via_json(
            'El abuelo',
            $tabla_abuelo->datos->abuelo_abuelo
        );
    }
    function probar_leer_varios_desde_tabla(){
        $this->tablas->de_ejemplo_abuelo->leer_varios(array());
        $this->tablas->de_ejemplo_abuelo->obtener_leido();
        $tabla_padre=$this->tablas->de_ejemplo_abuelo->definicion_tabla('de_ejemplo_padre');
        Loguear('2012-03-14', 'tengo '.var_export($this->tablas->de_ejemplo_abuelo->datos,true));
        $tabla_padre->leer_varios($this->tablas->de_ejemplo_abuelo);
        $tabla_padre->obtener_leido();
        $this->probador->verificar_via_json(
            'El abuelo',
            $tabla_padre->datos->padre_abuelo
        );
        $this->probador->verificar_via_json(
            'El padre',
            $tabla_padre->datos->padre_padre
        );
    }
}

class Prueba_de_filtro extends Pruebas{
    /*
    function __construct(){
    }
    */
    function pre_probar_para_todo(){
        $this->filtro_empezar_de_1();
    }
    function filtro_empezar_de_1(){
        Filtro::$nombres_simples=true;
        Filtro::$parametro_numero=1;
    }
    function probar_aplanar_filtro_normal(){
        $tabla=new Tabla_de_ejemplo4();
        Filtro::$nombres_simples=null;
        $obtenido=new Filtro_Que_se_completa_y_pisa(array(array('este'=>2,'otro'=>3), array('aquel'=>1,'otro'=>4)));
        $this->probador->verificar_via_json(
            array(':este'=>2,':otro'=>4,':aquel'=>1),
            $obtenido->parametros
        );
    }
    function probar_aplanar_filtro_tablas(){
        $tabla_padre=new Tabla_de_ejemplo_padre();
        $tabla_abuelo=new Tabla_de_ejemplo_abuelo();
        $tabla_hija=new Tabla_de_ejemplo_hija();
        $tabla_abuelo->datos=(object)array();
        $tabla_abuelo->datos->abuelo_abuelo='abuelo';
        $tabla_hija->datos=(object)array();
        $tabla_hija->datos->hija_padre='padre';
        $tabla_hija->datos->hija_abuelo='este se tiene que pisar';
        Filtro::$nombres_simples=null;
        $obtenido=$entrada=new Filtro_Que_se_completa_y_pisa(array($tabla_hija,$tabla_abuelo),$tabla_padre);
        $this->probador->verificar_via_json(
            array(':padre_abuelo'=>'abuelo',':padre_padre'=>'padre'),
            $obtenido->parametros
        );
        $this->filtro_empezar_de_1();
        // $obtenido=new Filtro_Normal($tabla_hija,$tabla_padre);
        $obtenido=$entrada=new Filtro_AND(array($tabla_hija,$tabla_abuelo),$tabla_padre);
        // $obtenido=$entrada=new Filtro_Conector(array($tabla_hija,$tabla_abuelo),$tabla_padre);
        //$obtenido=$this->contexto->nuevo_objeto("Filtro_Normal",$entrada,$tabla_padre);
        //$obtenido=new Filtro_Normal($entrada,$tabla_padre);
        $this->probador->verificar_via_json(
            '(padre_abuelo=:p1 and padre_padre=:p2) AND (padre_abuelo=:p3)',
            $obtenido->where
        );
        $this->probador->verificar_via_json(
            array(':p1'=>'este se tiene que pisar',':p2'=>'padre',':p3'=>'abuelo'),
            $obtenido->parametros
        );
    }
    function probar_filtro_voy_por(){
        $tabla_padre=new Tabla_de_ejemplo_padre();
        $entrada=new Filtro_AND(array(array('padre_abuelo'=>'#>=alfa&<=beta'),new Filtro_Voy_Por(array('padre_abuelo'=>'pepe','padre_padre'=>'josé'))),$tabla_padre);
        $obtenido=$this->contexto->nuevo_objeto("Filtro_Normal",$entrada,$tabla_padre);
        // los números pueden cambiar
        $this->probador->verificar_via_json(
            '(comun.para_ordenar_numeros(padre_abuelo::text) >= comun.para_ordenar_numeros(:p3::text) and comun.para_ordenar_numeros(padre_abuelo::text) <= comun.para_ordenar_numeros(:p5::text)) AND ((padre_abuelo, padre_padre)>(:p1, :p2))',
            $obtenido->where
        );
        $this->probador->verificar_via_json(
            array(':p3'=>'alfa',':p5'=>'beta',':p1'=>'pepe',':p2'=>'josé'),
            $obtenido->parametros
        );
    }
}

class Prueba_comunes extends Pruebas{
    function probar_cambiar_prefijo_objeto(){
        $dato=(object)array(
            'che_que'=>1,
            'che_hola'=>'hola',
        );
        $obtenido=cambiar_prefijo($dato,'che_','que_');
        $this->probador->verificar_via_json(
            (object)array(
              'que_que'=>1,
              'que_hola'=>'hola',
            ),            
        $obtenido
        );
    }
    function probar_cambiar_prefijo_arreglo(){
        $dato=array(
            'che_que'=>1,
            'che_hola'=>'hola',
        );
        $obtenido=cambiar_prefijo($dato,'che_','que_');
        $this->probador->verificar_via_json(
            array(
              'que_que'=>1,
              'que_hola'=>'hola',
            ),            
        $obtenido
        );
    }
    function probar_cambiar_prefijo_cadena(){
        $dato='che_que';
        $obtenido=cambiar_prefijo($dato,'che_','que_');
        $this->probador->verificar_via_json(
              'que_que', $obtenido
        );
    }
}

function cambiar_prefijo($dato, $que, $por_cual){
        if(is_object($dato)||is_array($dato)){
            $dato_completo = array();
            foreach ($dato as $campo=>$valor){
                $dato_cambiado=$por_cual.quitar_prefijo($campo,$que);
                $dato_completo[$dato_cambiado]=$valor;
            }
            if(is_object($dato)){
                $dato_completo=(object)$dato_completo;
            }
        }
        if(is_string($dato)){
            $dato_completo=$por_cual.quitar_prefijo($dato,$que);          
        }
        return $dato_completo;
}
?>