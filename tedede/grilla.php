<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

function Puede(){
    return true;
}

abstract class Grilla{
    var $nombre_grilla=null;
    var $esquema='';
    function __construct(){
        $this->nombre_grilla=substr(get_class($this),strlen('Grilla_'));
        Loguear('2012-03-25',$this->nombre_grilla);
    }
    function armar_detalles(){
        throw new Exception("Falta definir como armar detalles en la grilla ".get_class($this));
    }
    function boton_enviar(){
        return false;
    }
    function debe_listar_campo($campo,$filtro_para_lectura){
        $campos_a_listar=$this->campos_a_listar($filtro_para_lectura);
        return !is_array($campos_a_listar) || @$campos_a_listar[0]=='*' || in_array($campo,$campos_a_listar);
    }
	function campos_a_listar($filtro_para_lectura){
		return array('*');
	}
    function campos_de_auditoria_para_update(){
		return '';
	}
    function campos_editables($filtro_para_lectura){
        return array();
    }
	function campos_solo_lectura(){
		return array();
	}
    function iniciar($nombre_del_objeto_base){
        // para la inicialización posterior al constructor porque el constructor no tiene contexto. 
    }
	function joins(){
		return array();
	}
	function nombre_grilla(){
		if($this->nombre_grilla){
			return $this->nombre_grilla;
		}else{
			throw new Exception("Falta definir el nombre de la tabla en la grilla ".get_class($this));
		}
	}
    // abstract function obtener_datos($filtro_para_lectura);
	function obtener_tabla_o_subselect(){
		global $db;
		return ($this->esquema?$this->esquema.'.':'').$db->quote($this->nombre_grilla,'tabla'); 
	}
	function order_by(){
		if(count($this->pks())==0){
			return 'row_number() over ()';
		}else{
			$str='';
			$coma='';
			foreach($this->pks() as $campo_pk){
				$str.="$coma para_ordenar_numeros($campo_pk::text)";
				$coma=',';
			}
			return $str;
		}
	}
    function permite_grilla_con_este_filtro($o_con_este_filtro){
        return true;
    }
    function permite_grilla_sin_filtro(){
        return true;
    }
    function permite_grilla_sin_filtro_manual(){
        return true;
    }
	function pks(){
		throw new Exception("Falta definir las pks de la grilla ".get_class($this));
	}
	function prefijo_nombre_campos(){
		$pks=$this->pks();
		$primer_pk=$pks[0];
		return substr($primer_pk,0,strpos($primer_pk,'_'));
	}
	function puede_eliminar(){
		return false;
	}
	function puede_detallar(){
		return false;
	}
	function puede_insertar(){
		return $this->puede_eliminar();
	}
	function remover_en_nombre_de_campo(){
		return "^[^_]*_";
	}
	function sql_para_valores_insert_de_la_pk(){
		$valores=array();
		foreach($this->pks() as $campo_pk){
			$valores[]="'0_provisorio_'||nextval('numeros_provisorios_seq')";
		}
		return $valores;
	}
    /////////////////////// RESPUESTAS /////////////////////////
    function responder_leer_grilla(){
        Loguear('2012-03-25',var_export($this->argumentos,true));
        $filtro_para_lectura=$this->argumentos->filtro_para_lectura;
        $filtro_manual=$this->argumentos->filtro_manual;
        Loguear('2012-04-08','$filtro_para_lectura inicio');
        $rta=$this->obtener_datos($filtro_para_lectura,$filtro_manual);
        // $rta['registros']=$datos_tabla;
        $rta['cantidad_registros']=count($rta['registros']);
        $rta['definicion_campos']=$this->definiciones_para_grilla();
        $rta['campos_editables']=$this->campos_editables($filtro_para_lectura);
        foreach(array(
            'solo_lectura'=>'campos_solo_lectura',
            'puede_eliminar',
            'puede_detallar',
            'puede_insertar',
            'boton_enviar',
            'remover_en_nombre_de_campo',
            'pks',
            'cantidadColumnasFijas',
            'joins',
        ) as $campo_rta=>$funcion_grilla){
            if(is_numeric($campo_rta)){
                $campo_rta=$funcion_grilla;
            }
            $rta[$campo_rta]=$this->$funcion_grilla();
        }
        Loguear('2012-04-08','$filtro_para_lectura fin');
        return new Respuesta_Positiva($rta);
    }
    function definiciones_para_grilla(){
        return array();
    }
    function cantidadColumnasFijas(){
        return 1;
    }
}

class Grilla_tablas_o_vistas extends Grilla{
    var $tabla_o_vista;
    function campos_a_excluir($filtro_para_lectura){
        $excluir=array();
        foreach($this->tabla_o_vista->campos as $nombre=>$campo){
            if(isset($campo->invisible) && $campo->invisible){
                $excluir[]=$nombre;
            }
        }
        return $excluir;
    }
    function ordenar_campos_a_listar($primeros_campos){
        $nuevos_campos_a_listar=$primeros_campos;
        foreach($this->tabla_o_vista->obtener_nombres_campos() as $campo){
            if (!in_array($campo, $primeros_campos)){
                $nuevos_campos_a_listar[]=$campo;
            }
        }
        return $nuevos_campos_a_listar;
    }
    function obtener_otros_atributos_y_completar_fila(&$fila,&$atributos_fila){
    }
    function obtener_datos($filtro_para_lectura_sin_filtro_manual,$filtro_manual=false){
        if($filtro_manual){
            $filtro_para_lectura=array_merge($filtro_para_lectura_sin_filtro_manual,$filtro_manual);
        }else{
            $filtro_para_lectura=$filtro_para_lectura_sin_filtro_manual;
        }
        $rta=array();
        $att=array();
        $filtro_para_lectura_original=$filtro_para_lectura;
        if(count($filtro_para_lectura)==0 and !$this->permite_grilla_sin_filtro() 
            or count($filtro_para_lectura)!=0 and !$this->permite_grilla_con_este_filtro($filtro_para_lectura)
            or count($filtro_manual)==0 and !$this->permite_grilla_sin_filtro_manual() 
        ){
            $filtro_para_lectura=array();
            $renglon_vacio=true;
        }else{
            $renglon_vacio=false;
        }
        Loguear('2015-03-25','$filtro_para_lectura='.json_encode($filtro_para_lectura).' $renglon_vacio='.$renglon_vacio);
        $campos_a_listar=$this->campos_a_listar($filtro_para_lectura);
        $campos_a_excluir=array_merge($this->campos_a_excluir($filtro_para_lectura),array_filter($this->tabla_o_vista->obtener_nombres_campos(),function($elemento){ return termina_con($elemento,'tlg');}));
        $this->tabla_o_vista->leer_varios($filtro_para_lectura);
        if(!$renglon_vacio){
            while($this->tabla_o_vista->obtener_leido()){
                if(is_array($campos_a_listar) && $campos_a_listar[0]!='*'){
                    $fila=array();
                    foreach($campos_a_listar as $campo){
                        $fila[$campo]=$this->tabla_o_vista->datos->{$campo}; 
                    }
                }else{
                    $fila=(array)$this->tabla_o_vista->datos;
                }
                foreach($campos_a_excluir as $campo){
                    unset($fila[$campo]);
                }
                $atributos_fila=array();
                $this->obtener_otros_atributos_y_completar_fila($fila,$atributos_fila);
                $rta[$this->tabla_o_vista->id_registro()]=$fila;
                $att[$this->tabla_o_vista->id_registro()]=$atributos_fila;
            }
        }
        if(count($rta)==0){
            if(!$renglon_vacio){
                if(count($filtro_para_lectura_original)==0){
                    $title_ultimo_renglon='grilla sin dato';
                }else{
                    $title_ultimo_renglon='grilla sin dato para el filtro seleccionado';
                }
                $ultima_consulta=$this->contexto->db->ultima_consulta;
                for($indice_columna=0; $indice_columna<$ultima_consulta->columnCount(); $indice_columna++){
                    $meta_columna=$ultima_consulta->getColumnMeta($indice_columna);
                    $campo=$meta_columna['name'];
                    $poner_titulo=
                        is_array($campos_a_listar) && $campos_a_listar[0]=='*'
                        || is_array($campos_a_listar) && in_array($campo,$campos_a_listar)
                        || !is_array($campos_a_listar);
                    if($poner_titulo){
                        $rta[''][$campo]=$indice_columna?'':'s/d';
                        $att[''][$campo]['title']=$title_ultimo_renglon;
                        $att[''][$campo]['clase']='sin_dato';
                    }
                }
                $primero='s/d';
            }else{
                $primero='d/f';
                $title_ultimo_renglon='debe filtrar para ver algún dato';
            }
            if($this->tabla_o_vista->obtener_leido()){
                if(is_array($campos_a_listar) && $campos_a_listar[0]!='*'){
                    $fila=array();
                    foreach($campos_a_listar as $campo){
                        $fila[$campo]=$this->tabla_o_vista->datos->{$campo};
                    }
                }else{
                    $fila=(array)$this->tabla_o_vista->datos;
                }
                foreach($campos_a_excluir as $campo){
                    unset($fila[$campo]);
                }
                foreach($fila as $campo=>$valor){
                    // $fila[$campo]=chr(224).chr(176).chr(rand(146,168));
                    $fila[$campo]=$primero;
                    $fila_attr[$campo]['title']=$title_ultimo_renglon;
                    $primero='';
                    $fila_attr[$campo]['clase']='sin_dato';
                }
                $rta[""]=$fila;
                $att[""]=$fila_attr;
            }
        }
        return array('registros'=>$rta,'atributos_fila'=>$att);
    }
    function pks(){
        return $this->tabla_o_vista->obtener_nombres_campos_pk();
    }
    function definiciones_para_grilla(){
        $definiciones=$this->tabla_o_vista->definiciones_para_grilla;
        foreach($this->tabla_o_vista->obtener_nombres_campos() as $nombre_campo){
            $definiciones[$nombre_campo]['tipo']=$this->tabla_o_vista->campos[$nombre_campo]->tipo;
        }
        return $definiciones;
    }
    function puede_detallar(){
        return $this->tabla_o_vista->puede_detallar();
    }
    function permite_grilla_sin_filtro(){
        return $this->tabla_o_vista->permite_grilla_sin_filtro();
    }
    function cantidadColumnasFijas(){
        return count($this->tabla_o_vista->obtener_nombres_campos_pk())?:1;
    }
}

class Grilla_tabla extends Grilla_tablas_o_vistas{
    var $tabla;
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="tabla_".$nombre_del_objeto_base;
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_".$nombre_del_objeto_base);
    }
    function campos_a_listar($filtro_para_lectura){
        return true;
    }
    function campos_editables($filtro_para_lectura){
        if(Puede('editar_cualquier_campo')){
            return true;
        }else{
            $editables=array();
            foreach($this->campos_a_listar($filtro_para_lectura) as $campo){
                if(Puede('editar',$this->nombre_grilla,$campo)){
                    $editables[]=$campo;
                }
            }
            return $editables;
        }
    }
    function responder_grabar_campo(){
        return $this->responder_grabar_campo_directo();
    }
    function responder_grabar_campo_directo(){
        Loguear('2012-09-11','por grabar campo '.var_export($this->argumentos,true));
        if(!Puede('grabar en',$this->nombre_grilla)){
            return new Respuesta_Negativa("No tiene permisos para modificar la tabla $nombre_grilla");
        }else{
            $campo=$this->argumentos->campo;
            $this->tabla->valores_para_update=array();
            $this->tabla->valores_para_update[$campo]=$this->argumentos->nuevo_valor;
            $filtro_update=array();
            $i=0;
            if(is_array($this->argumentos->pk)){
                foreach($this->tabla->obtener_nombres_campos_pk() as $nombre_campo_pk){
                    $filtro_update[$nombre_campo_pk]=$this->argumentos->pk[$i];
                    $i++;
                }
            }else{
                $nombre_campo_pk=$this->tabla->obtener_nombres_campos_pk();
                $filtro_update[$nombre_campo_pk[0]]=$this->argumentos->pk;
            }
            $this->filtro_solo_pk=$filtro_update;
            $filtro_update[$campo]=$this->argumentos->viejo_valor;
            $this->contexto->db->beginTransaction();
            if($filtro_registros_editables=$this->tabla->filtro_registros_editables()){
                $filtro_update=new Filtro_AND(array($filtro_update,$filtro_registros_editables));
            }
            $this->tabla->ejecutar_update_unico($filtro_update,false);
            if(!isset($GLOBALS['con_auditoria_php']) || $GLOBALS['con_auditoria_php'] ){
                $tabla_modificaciones=$this->tabla->definicion_tabla('modificaciones');
                $tabla_modificaciones->valores_para_insert=array(
                    'mdf_tabla'=>$this->tabla->obtener_nombre_de_tabla(),
                    'mdf_operacion'=>'U',
                    'mdf_pk'=>(count($this->argumentos->pk)==1?$this->argumentos->pk[0]:json_encode($this->argumentos->pk)),
                    'mdf_campo'=>$campo,
                    'mdf_actual'=>$this->argumentos->nuevo_valor,
                    'mdf_anterior'=>$this->argumentos->viejo_valor,
                    'mdf_tlg'=>obtener_tiempo_logico($this->contexto),
                );
                $tabla_modificaciones->ejecutar_insercion();
            }
            if($this->tabla->resultado->rowCount()==1){
                $valor_grabado=$this->tabla->datos->{$campo};
                $nueva_pk=$this->tabla->id_registro();
                if(isset($this->filtro_solo_pk[$campo])){
                    $this->filtro_solo_pk[$campo]=$valor_grabado;
                }
                $rta=$this->obtener_datos($this->filtro_solo_pk); // pisa id_registro y $rta;
                $rta['pk']=$nueva_pk;
                $rta['valor_grabado']=$valor_grabado;
                Loguear('2012-03-28',"el pk de id_registro = ".json_encode($rta['pk']));
                $this->contexto->db->commit();
                return new Respuesta_Positiva($rta);
            }else if($this->tabla->resultado->rowCount()==0){
                $this->contexto->db->rollBack();
                $this->tabla->leer_varios($this->filtro_solo_pk);
                if($this->tabla->obtener_leido()){
                    if($filtro_registros_editables){
                        $this->tabla->leer_varios(new Filtro_AND(array($this->filtro_solo_pk,$filtro_registros_editables)));
                        if(!$this->tabla->obtener_leido()){
                            return new Respuesta_Negativa("No tiene permiso para modificar el registro");
                        }
                    }
                    return new Respuesta_Negativa("No se pudo modificar el registro, quizás un usuario lo modificó antes. Valor actual=".$this->tabla->datos->{$campo}.". Refresque la pantalla");
                }else{
                    return new Respuesta_Negativa("el registro ya no está en la base de datos quizás otro usuario lo modificó");
                }
            }else if($this->tabla->resultado->rowCount()>1){
                $this->contexto->db->rollBack();
                return new Respuesta_Negativa("Error, se han intentado modificar múltiples registros (".$this->tabla->resultado->rowCount().") cuando debió ser uno. grabando {$this->argumentos->nuevo_valor} en {$this->nombre_grilla}");
            }
        }
    }
    function responder_grabar_registro(){
        Loguear('2012-09-11','por grabar registro '.var_export($this->argumentos,true));
        if(!Puede('grabar en',$this->nombre_grilla)){
            return new Respuesta_Negativa("No tiene permisos para modificar la tabla $nombre_grilla");
        }else{
            $campo=$this->argumentos->campo;
            $this->tabla->valores_para_update=array();
            $filtro_update=array();
            $i=0;
            if(is_array($this->argumentos->pk)){
                foreach($this->tabla->obtener_nombres_campos_pk() as $nombre_campo_pk){
                    $filtro_update[$nombre_campo_pk]=$this->argumentos->pk[$i];
                    $i++;
                }
            }else{
                $nombre_campo_pk=$this->tabla->obtener_nombres_campos_pk();
                $filtro_update[$nombre_campo_pk[0]]=$this->argumentos->pk;
            }
            $this->filtro_solo_pk=$filtro_update;
            $registro_nuevo=$campo=='*'?$this->argumentos->nuevo_valor:array($campo=>$this->argumentos->nuevo_valor);
            $registro_viejo=$campo=='*'?$this->argumentos->viejo_valor:array($campo=>$this->argumentos->viejo_valor);
            $this->contexto->db->beginTransaction();
            foreach($registro_nuevo as $campo=>$nuevo_valor){
                if($registro_viejo){ // OJO quitar para control de versiones
                    $viejo_valor=$registro_viejo[$campo];
                    $filtro_update[$campo]=$viejo_valor;
                }else{
                    $viejo_valor=NULL;
                }
                if(trim($nuevo_valor)===''){
                    $nuevo_valor=null;
                }
                $this->tabla->valores_para_update[$campo]=$nuevo_valor;
                if(!isset($GLOBALS['con_auditoria_php']) || $GLOBALS['con_auditoria_php']){
                    $tabla_modificaciones=$this->tabla->definicion_tabla('modificaciones');
                    Loguear('2014-03-25','Recibido argumento '.json_encode($this->argumentos));
                    // $this->argumentos->pk=(array)$this->argumentos->pk;
                    $tabla_modificaciones->valores_para_insert=array(
                        'mdf_tabla'=>$this->tabla->obtener_nombre_de_tabla(),
                        'mdf_operacion'=>'U',
                        'mdf_pk'=>(count($this->argumentos->pk)==1?$this->argumentos->pk[0]:json_encode($this->argumentos->pk)),
                        'mdf_campo'=>$campo,
                        'mdf_actual'=>$nuevo_valor,
                        'mdf_anterior'=>$viejo_valor,
                        'mdf_tlg'=>obtener_tiempo_logico($this->contexto),
                    );
                    $tabla_modificaciones->ejecutar_insercion();
                }
            }
            if($filtro_registros_editables=$this->tabla->filtro_registros_editables()){
                $filtro_update=new Filtro_AND(array($filtro_update,$filtro_registros_editables));
            }
            $this->tabla->ejecutar_update_unico($filtro_update,false);
            if($this->tabla->resultado->rowCount()==1){
                $valores_grabados=array();
                foreach($registro_nuevo as $campo=>$nuevo_valor){
                    if($this->tabla->existe_campo($campo)){
                        $valor_grabado=$this->tabla->datos->{$campo};
                        if(isset($this->filtro_solo_pk[$campo])){
                            $this->filtro_solo_pk[$campo]=$valor_grabado;
                        }
                        $valores_grabados[$campo]=$valor_grabado;
                    }
                }
                $nueva_pk=$this->tabla->id_registro();
                $rta=$this->obtener_datos($this->filtro_solo_pk); // pisa id_registro y $rta;
                $rta['pk']=$nueva_pk;
                $rta['valor_grabado']=$valor_grabado;
                $rta['valores_grabados']=$valores_grabados;
                Loguear('2014-04-04',"el pk de id_registro = ".json_encode($rta['pk']));
                $this->contexto->db->commit();
                return new Respuesta_Positiva($rta);
            }else if($this->tabla->resultado->rowCount()==0){
                $this->contexto->db->rollBack();
                $this->tabla->leer_varios($this->filtro_solo_pk);
                if($this->tabla->obtener_leido()){
                    if($filtro_registros_editables){
                        $this->tabla->leer_varios(new Filtro_AND(array($this->filtro_solo_pk,$filtro_registros_editables)));
                        if(!$this->tabla->obtener_leido()){
                            return new Respuesta_Negativa("No tiene permiso para modificar el registro");
                        }
                    }
                    return new Respuesta_Negativa("No se pudo modificar el registro, quizás un usuario lo modificó antes. Valor actual=".$this->tabla->datos->{$campo}.". Refresque la pantalla");
                }else{
                    Loguear('2014-04-04',"el pk de id_registro = ".json_encode($this->filtro_solo_pk));
                    return new Respuesta_Negativa("el registro ya no está en la base de datos quizás otro usuario lo modificó");
                }
            }else if($this->tabla->resultado->rowCount()>1){
                $this->contexto->db->rollBack();
                return new Respuesta_Negativa("Error, se han intentado modificar múltiples registros (".$this->tabla->resultado->rowCount().") cuando debió ser uno. grabando {$this->argumentos->nuevo_valor} en {$this->nombre_grilla}");
            }
        }
    }
    function responder_agregar_registro_provisorio(){
        return $this->para_responder_agregar_registro(array('modo'=>'provisorio'));
    }
    function responder_agregar_registro_definitivo(){
        return $this->para_responder_agregar_registro(array('modo'=>'definitivo'));
    }
    function para_responder_agregar_registro($modo){
        if(!Puede('insertar en',$this->nombre_grilla)){
            return new Respuesta_Negativa("No tiene permisos para agregar registros a la tabla $nombre_grilla");
        }else{
            $this->tabla->valores_para_insert=array();
            foreach($this->tabla->obtener_nombres_campos_pk() as $campo_pk){
                if(isset($this->argumentos->filtro_para_lectura[$campo_pk])){
                    $this->tabla->valores_para_insert[$campo_pk]=$this->argumentos->filtro_para_lectura[$campo_pk];
                }else{
                    $this->tabla->valores_para_insert[$campo_pk]=0;
                }
            }
            foreach($this->tabla->definiciones_campo_originales as $campo=>$definicion){
                if(@$definicion['def']){
                    $this->tabla->valores_para_insert[$campo]=$definicion['def'];
                }
                if(@$definicion['def_calculado']){
                    if($definicion['def_calculado']=='autoincremento'){
                        $filtro_incremento = new Filtro_Normal($this->argumentos->filtro_para_lectura);
                        $tabla_incremento_por_default = $this->tabla->definicion_tabla($this->tabla->obtener_nombre_de_tabla());
                        $this->tabla->valores_para_insert[$campo]=($tabla_incremento_por_default->obtener_maximo($filtro_incremento, $campo))+1;
                    }
                }
            }
            if($modo['modo']=='definitivo'){
                foreach($this->argumentos->campos as $campo=>$valor){
                    if($valor!==''){
                        $this->tabla->valores_para_insert[$campo]=$valor;
                    }
                }
            }
            $this->tabla->ejecutar_insercion();
            return $this->responder_leer_grilla();
        }
    }
    function responder_eliminar_registro(){
        if(!Puede('eliminar registros en',$this->nombre_grilla)){
            return new Respuesta_Negativa("No tiene permisos para eliminar registros a la tabla $nombre_grilla");
        }else{
            $filtro_delete=array();
            $i=0;
            if(is_array($this->argumentos->pk)){
                foreach($this->tabla->obtener_nombres_campos_pk() as $nombre_campo_pk){
                    $filtro_delete[$nombre_campo_pk]=$this->argumentos->pk[$i];
                    $i++;
                }
            }else{
                $nombre_campo_pk=$this->tabla->obtener_nombres_campos_pk();
                $filtro_delete[$nombre_campo_pk[0]]=$this->argumentos->pk;
            }
            $this->contexto->db->beginTransaction();
            $this->tabla->ejecutar_delete_uno($filtro_delete,false);
            if(!isset($GLOBALS['con_auditoria_php']) || $GLOBALS['con_auditoria_php']){
                $tabla_modificaciones=$this->tabla->definicion_tabla('modificaciones');
                $tabla_modificaciones->valores_para_insert=array(
                    'mdf_tabla'=>$this->tabla->obtener_nombre_de_tabla(),
                    'mdf_operacion'=>'D',
                    'mdf_pk'=>(count($this->argumentos->pk)==1?$this->argumentos->pk[0]:json_encode($this->argumentos->pk)),
                    'mdf_campo'=>'*',
                    'mdf_actual'=>null,
                    'mdf_anterior'=>null,
                    'mdf_tlg'=>obtener_tiempo_logico($this->contexto),
                );
                $tabla_modificaciones->ejecutar_insercion();
            }
            $this->contexto->db->commit();
            return new Respuesta_Positiva();
        }
    }
}


class Grilla_vistas extends Grilla_tablas_o_vistas{
    // OJO cuando hagamos la segunda basada en SQL no copiar y pegar, sino sacar fator común
    var $campos;
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        $this->tabla_o_vista=$this->vista=$this->contexto->nuevo_Objeto('Vista_'.$nombre_del_objeto_base);
    }
    function responder_detallar(){
        $this->vista->establecer_detallado(true);
        return $this->responder_leer_grilla();
    }
}

function grilla($nombre,$contexto){
    $la_grilla;
    Loguear('2012-03-25','xxxxxxxxxxxxx');
    if(empieza_con($nombre,'tabla_')){
        $la_grilla=$contexto->nuevo_objeto("Grilla_tabla");
        $la_grilla->iniciar(quitar_prefijo($nombre,'tabla_'));
    }elseif(empieza_con($nombre,'vista_')){
        $la_grilla=$contexto->nuevo_objeto("Grilla_vistas");
        $la_grilla->iniciar(quitar_prefijo($nombre,'vista_'));
    }elseif(empieza_con($nombre,'respuestas_')){
        $la_grilla=$contexto->nuevo_objeto("Grilla_respuestas");
        $la_grilla->iniciar(quitar_prefijo($nombre,'respuestas_'));
    }else{
        $la_grilla=$contexto->nuevo_objeto("Grilla_$nombre");
        $la_grilla->iniciar($nombre);
    }
    if(@$la_grilla->tabla){
        $la_grilla->tabla->campos_lookup_nombres=array();
    }
    if(@$la_grilla->tabla->campos_lookup){
        foreach($la_grilla->tabla->campos_lookup as $exp=>$dummy){
            $expr=$exp;
            $alias=$exp;
            if(preg_match('/^(?P<expr>.+) as (?P<alias>\w+)$/im', str_replace(array("\r","\n"), array('',''), $exp), $matches)){
                $expr=$matches['expr'];
                $alias=$matches['alias'];
                Loguear('2014-07-03', contenido_interno_a_string($matches));
            }else{
                Loguear('2014-07-03', "nomatch: ".$exp);
            }
            $la_grilla->tabla->campos_lookup_nombres[$alias]=$expr;
        }
    }
    return $la_grilla;
}

function enviar_grilla($salida, $nombre_grilla=false, $filtro=array(), $receptaculo=false, $opciones=array()){
    if(!$receptaculo){
        $poner_el_contenedor="editor.poner_el_contenedor();";
    }else{
        $poner_el_contenedor="";
        if(@$opciones['agregar_al_contenedor']){
            $mas='+';
        }else{
            $mas='';
            $poner_el_contenedor.="elemento_existente(".json_encode($receptaculo).").innerHTML='';";
        }
        $poner_el_contenedor.="elemento_existente(".json_encode($receptaculo).").appendChild(editor.obtener_el_contenedor_dom());";
    }
    if($nombre_grilla){
        $tabla_entrecomillada_o_funcion_js_que_la_averigua=json_encode($nombre_grilla);
    }else{
        $tabla_entrecomillada_o_funcion_js_que_la_averigua='traer_de_sessionStorage("editor_nombre_grilla")';
    }
    $filtro=json_encode($filtro);
    $filtrar_visiblemente='';
    if(isset($opciones['filtro_visible'])){
        $filtrar_visiblemente="editor.filtro_manual=".json_encode($opciones['filtro_visible']).";";
    }
    $js_opciones="";
    foreach($opciones as $opcion=>$valor){
        $js_opciones.="editor[".json_encode($opcion)."]=".json_encode($valor)."; ";
    }
    $otras_opciones=(@($opciones['otras_opciones']))?json_encode($opciones['otras_opciones']):'{}';
    $salida->enviar_script(<<<JS
    {
        var nombre_grilla=$tabla_entrecomillada_o_funcion_js_que_la_averigua;
        var editor=editores[nombre_grilla]=new Editor(nombre_grilla,nombre_grilla,$filtro,null,$otras_opciones);
        $poner_el_contenedor
        $js_opciones
        $filtrar_visiblemente
        editor.cargar_grilla(null,true);
    }
JS
    );
}

class Proceso_grilla_soporte extends Procesos{
    function __construct(){
        parent::__construct(array());
    }
    function correr(){
    }
    function validar_argumentos(){
        controlar_parametros($this->argumentos,array(
            'grilla'=>null,
            'accion'=>array('opciones'=>array('leer_grilla','grabar_campo','agregar_registro_provisorio','eliminar_registro','agregar_registro_definitivo','grabar_registro')),
            'filtro_para_lectura'=>array('validar'=>'is_array_o_stdclass'),
            'filtro_manual'=>array('validar'=>'is_array_o_stdclass'),
            'pk'=>null,
            'campo'=>null,
            'nuevo_valor'=>null,
            'viejo_valor'=>null,
            'detallar'=>array('def'=>false,'validar'=>'is_bool'),
            'campos'=>null,
        ));
    }
    function responder(){
        $nombre_grilla=$this->argumentos->grilla; 
        $grilla=grilla($nombre_grilla,$this);
        $grilla->argumentos=$this->argumentos;
        if($this->argumentos->detallar){
            $this->argumentos->accion='detallar';
        }
        return $grilla->{"responder_".$this->argumentos->accion}();
    }
}
?>