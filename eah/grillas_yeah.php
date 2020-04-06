<?php

class Grilla{
	var $nombre_tabla=null;
    var $esquema='';
	function __construct(){
		$this->nombre_tabla=substr(get_class($this),strlen('Grilla_'));
		Loguear(3,$this->nombre_tabla);
	}
	function armar_detalles(){
		throw new Exception("Falta definir como armar detalles en la grilla ".get_class($this));
	}
	function boton_enviar(){
		return false;
	}
	function campos_a_listar($filtro_para_lectura){
		return array('*');
	}
	function campos_de_auditoria_para_update(){
		return '';
	}
	function campos_editables($filtro_para_lectura){
		if(Puede('editar_cualquier_campo')){
			return true;
		}else{
			$editables=array();
			foreach($this->campos_a_listar($filtro_para_lectura) as $campo){
				if(Puede('editar',$this->nombre_tabla,$campo)){
					$editables[]=$campo;
				}
			}
			return $editables;
		}
	}
	function campos_solo_lectura(){
		return array();
	}
	function clausula_where($filtro_para_lectura,&$array_con_parametros_para_pdo=null){
		global $db;
		$str=' WHERE ';
		if($filtro_para_lectura){
			$and='';
			$pks=$this->pks();
			foreach($filtro_para_lectura as $c=>$v){
				if(is_numeric($c)){
					$c=$pks[$c];
					// throw new Exception("ya no se puede mandar posicionales");
				}
				if($v===null){
					$str.=$and.$c.' is null';
				}else{
					if($array_con_parametros_para_pdo){
						$array_con_parametros_para_pdo[':'.$c]=$v;
						$str.=$and.$c.'=:'.$c;
					}else{
						$str.=$and.$c.'='.$db->quote($v);
					}
				}
				$and=" and ";
			}
		}else{
			$str.='TRUE';
		}
		return $str;
	}
	function joins(){
		return array();
	}
	function nombre_tabla(){
		if($this->nombre_tabla){
			return $this->nombre_tabla;
		}else{
			throw new Exception("Falta definir el nombre de la tabla en la grilla ".get_class($this));
		}
	}
	function obtener_datos($filtro_para_lectura){
		global $db;
		$sub_select=$this->obtener_tabla_o_subselect($filtro_para_lectura);
		$campos=implode(', ',$this->campos_a_listar($filtro_para_lectura));
		$pks=$this->pks();
		//$pk=@("'[\"'||".implode("||'\",\"'||",$pks)."||'\"]'")?:'row_number() over ()';
		$pk=@("json_encode(ARRAY[".implode("::text,",$pks)."::text])")?:'row_number() over ()';
		$clausula_where=$this->clausula_where($filtro_para_lectura);
		$order_by=$this->order_by(); 
		$datos_tabla=$db->preguntar_tabla_pk(<<<SQL
			select $pk as pk, $campos
				from $sub_select a
				$clausula_where
				order by $order_by
SQL
		);
		return $datos_tabla;
	}
	function obtener_tabla_o_subselect(){
		global $db;
		return ($this->esquema?$this->esquema.'.':'').$db->quote($this->nombre_tabla,'tabla'); 
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
	function pks(){
		throw new Exception("Falta definir las pks de la grilla ".get_class($this));
	}
	function prefijo_nombre_campos(){
		$pks=$this->pks();
		$primer_pk=$pks[0];
		return substr($primer_pk,0,strpos($primer_pk,'_'));
	}
	function puede_eliminar(){
		return Puede('eliminar_cualquier_registro');
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
}

class Grilla_agregados_tem extends Grilla{
	function __construct(){
		parent::__construct();
		$this->nombre_tabla='tem11';
	}
	function campos_editables($filtro_para_lectura){
		if(Puede('administrar','agregados_tem')){
			return true;
		}else {
			return array();
		}
	}
	function campos_de_auditoria_para_update(){
		global $db,$usuario_logueado;
		return ', usu_ult_mod='.$db->quote($usuario_logueado);
	}
	function clausula_where($filtro_para_lectura){
		return parent::clausula_where($filtro_para_lectura)." and (posterior = 1)";
	}
	function campos_a_listar($filtro_para_lectura){
		return array('comuna, "replica", up, lote, ipad, encues, sup_campo, sup_recu_campo, 
       sup_tel, id_marco, idd, dpto, frac, radio, mza, clado, seg, nced, 
       hn, orden_altu, hp, pisoaux, hd, h0, h4, usp, h1, ccodigo, cnombre, 
       ident_edif, rep, barrio, cuit, tot_hab, pzas, hab, te, fuente, 
       fec_mod, comunas, frac_comun, radio_comu, mza_comuna, up_comuna, 
       anio_list, replica_cm, marco, marco_anio, nro_orden, incluido, 
       operacion, usuario, ok, titular, suplente, marca, pelusa, anio_list_ant, 
       obs, idcuerpo, rama_act, nomb_inst, eli, fuente_ant, replica_cm_2007, 
       yearfuente, idprocedencia, codord, replica2, marca1, reserva, 
       orden_de_reemplazo, up_i, estrato, habitaciones');
	}
	function pks(){
		return array('encues');
	}
 	function puede_eliminar(){
		return Puede('eliminar','agregados_tem');
	}
	function sql_para_valores_insert_de_la_pk(){
		$valores=array();
		foreach($this->pks() as $campo_pk){
			$valores[]="least(0,(SELECT min(encues) as pk_min FROM yeah_2011.tem11) - 1)";
		}
		return $valores;
	}
}

class Grilla_ano_con extends Grilla{
	function campos_a_listar($filtro_para_lectura){
		return array('anocon_anotacion', 'anocon_autor', 'anocon_momento');
	}
	function pks(){
		return array('anocon_con','anocon_num');
	}
}



class Grilla_base_preguntas_u_opciones extends Grilla{
	function __construct(){
		parent::__construct();
		$this->nombre_tabla='valores';
	}
	function campos_a_listar($filtro_para_lectura){
		return array('*', '(select count(*) from valores b where a.val_enc=b.val_enc and a.val_for=b.val_for and a.val_cel=b.val_cel and a.val_val=b.val_padre) as aux_cant_opciones');
	}
	function campos_editables($filtro_para_lectura){
		global $usuario_rol;
		if(Puede('editar_cualquier_campo')){
			return true;
		}else if(Puede('editar','textos de los metadatos de los formularios')){
			return array('val_texto', 'val_aclaracion');
		}
	}
	function order_by(){
		return 'val_orden, para_ordenar_numeros(val_val)';
	}
	function pks(){
		return array('val_enc','val_for','val_cel','val_val');
	}
}

class Grilla_base_tem extends Grilla{
	var $campos_id;
	var $profundidad;
	var $obtener_tabla_o_subselect;
	var $pks;
	var $joins=array("encuess"=>false);
	function __construct($rama,$profundidad){
		global $annio2d;
		parent::__construct();
		$this->profundidad=$profundidad;
		$this->descripcion=array(
			'estado'=>'(select est_nombre from estados where est_est=estado) as "descrip estado"'
		  , 'bolsa'=>'(select bolsa_cerrada from bolsas where bolsa_bolsa=bolsa) as bolsa_cerrada, (select bolsa_revisada from bolsas where bolsa_bolsa=bolsa) as bolsa_revisada'
		);
		switch($rama){
			case 'a':
				$this->campos_id=array("rol_poseedor","poseedor","encues");
				$this->joins=array("poseedors"=>false,"encuess"=>false);
				break;
			case 'b':
				$this->campos_id=array("bolsa","encues");
				break;
			case 'c':
				$this->campos_id=array("comuna","replica","up","encues");
				$this->joins=array("replicas"=>false,"ups"=>false,"encuess"=>false);
				break;
			case 'd':
				$this->campos_id=array("dominio","lote","encues");
				$this->joins=array("lotes"=>false,"encuess"=>false);
				break;
			case 'e':
				$this->campos_id=array("estado","encues");
		}
		$this->obtener_tabla_o_subselect="(select ";
		$this->obtener_tabla_o_subselect_group_by="";
		$coma="";
		$this->pks=array();
		$anidado_campo=array();
		$campos_join=array();
		for($i=0; $i<$profundidad; $i++){
			$campo=$this->campos_id[$i];
			$anidado_campo[]=$campo;
			$this->obtener_tabla_o_subselect.=$coma.$campo;
			$this->obtener_tabla_o_subselect_group_by.=$coma.$campo;
			if(@$this->descripcion[$campo]){
				$coma=', ';
				$this->obtener_tabla_o_subselect.=$coma.$this->descripcion[$campo];
				//$this->obtener_tabla_o_subselect_group_by.=$coma.$this->descripcion[$campo];
			}
			$this->pks[]=$campo;
			$campos_join[$campo]=$campo;
			$coma=', ';
		}
		for($i=$profundidad; $i<count($this->campos_id); $i++){
			$campo=$this->campos_id[$i];
			$anidado_campo[]=$campo;
			$this->obtener_tabla_o_subselect.=$coma."count(distinct array[".implode("::text,",$anidado_campo)."::text]) as \"aux_cant_{$campo}s\"\n";
			$coma=', ';
		}
		foreach($this->joins as $grilla=>$se_como_calcularla){
			if(!$se_como_calcularla){
				$this->joins[$grilla]=$campos_join;
			}
		}
		if($rama=='d' && $profundidad==2){
			$this->obtener_tabla_o_subselect.=", case when max(sup_campo) is null then null when min(case when sup_campo is null and rea in (1,3) then -1 else sup_campo end)=-1 then 0 else 1 end as superviones";
		}
		foreach(array('estado'=>'estados','poseedor'=>'poseedores') as $singular=>$plural){
			$this->obtener_tabla_o_subselect.=$coma."mostrar_rango_simplificado(min(comun.para_ordenar_numeros($singular::text)),max(comun.para_ordenar_numeros($singular::text)),count(distinct $singular)) as $plural";
		}
		foreach(array(24=>'ana_ing',25=>'ana_campo',26=>'procesamiento') as $estado=>$titulo){
			$this->obtener_tabla_o_subselect.="\n , sum(case when estado=$estado then 1 else 0 end) as $titulo";
		}
		$this->obtener_tabla_o_subselect.=" from tem{$annio2d} ";
		$this->obtener_tabla_o_subselect.="group by ";
		$this->obtener_tabla_o_subselect.=$this->obtener_tabla_o_subselect_group_by;
		$this->obtener_tabla_o_subselect.=")";

	}
	function joins(){
		return $this->joins;
	}
	function obtener_tabla_o_subselect(){
		return $this->obtener_tabla_o_subselect;
	}
	function pks(){
		return $this->pks;
	}
	function puede_eliminar(){
		return false;
	}
	function remover_en_nombre_de_campo(){
		return "^aux_";
	}
}

class Grilla_bolsas extends Grilla_base_tem{
	function __construct(){
		parent::__construct('b',1);
		$this->nombre_tabla='bolsas';
	}
	function boton_enviar(){
		return array('leyenda'=>'R', 'title'=>'Imprimir remito', 'ir_a'=>'remito.php');
	}
	/*
	function campos_a_listar($filtro_para_lectura){
		return array('bolsa','bolsa_cerrada','bolsa_revisada','aux_cant_encuess','estados','poseedores');
	}
	*/
	function campos_editables($filtro_para_lectura){
		if(Puede('editar','bolsas','bolsa_cerrada')){
			return array('bolsa_cerrada');
		}else if(Puede('editar','bolsas','bolsa_revisada')){
			return array('bolsa_revisada');
		}else{
			return array(); // poner return true si son todos (menos los de solo_lectura)
		}
	}
}

class Grilla_celdas extends Grilla{
	function campos_a_listar($filtro_para_lectura){
		return array('*', '(select count(*) from valores where cel_enc=val_enc and cel_for=val_for and cel_cel=val_cel and val_padre is null) as aux_cant_preguntas');
	}
	function campos_editables($filtro_para_lectura){
		global $usuario_rol;
		if(Puede('editar_cualquier_campo')){
			return true;
		}else if(Puede('editar','textos de los metadatos de los formularios')){
			return array('cel_texto', 'cel_aclaracion', 'cel_numero_pagina');	
		}
	}
	function joins(){
		return array('preguntas'=>array('cel_enc'=>'val_enc','cel_for'=>'val_for','cel_cel'=>'val_cel'));
	}
	function order_by(){
		return 'cel_mat is not null, cel_mat, cel_orden, para_ordenar_numeros(cel_cel)';
	}
	function pks(){
		return array('cel_enc','cel_for','cel_cel');
	}
}

class Grilla_comunas extends Grilla_base_tem{
	function __construct(){
		parent::__construct('c',1);
	}
}

class Grilla_consistencias extends Grilla{
	function boton_enviar(){
		return array('leyenda'=>'C', 'title'=>'Compilar', 'ir_a'=>'consistencias.php');
	}
	function campos_a_listar($filtro_para_lectura){
		return array('con_con', 'con_ignorar_nulls', 'con_precondicion', 'con_rel', 'con_postcondicion', 'con_activa', 'con_explicacion', 'con_expl_ok', 'null as aux_anotacion'
		, "(select count(*) from inconsistencias where con_con=inc_con) as tabulado_tabulado"  
		, 'con_tipo', 'con_gravedad', 'con_momento', 'con_version', 'con_orden', 'con_grupo', 'con_descripcion', 'con_modulo'
		, 'con_valida', 'con_junta', 'con_expresion_sql', 'con_error_compilacion', 'con_ultima_variable');
	}
	function campos_editables($filtro_para_lectura){
		return true;
	}
	function campos_solo_lectura(){
		$solo_lectura=array('con_valida', 'con_junta', 'con_expresion_sql', 'con_error_compilacion', 'con_ultima_variable');
		if(!Puede('confirmar','explicación de consistencias')){
			$solo_lectura=array_merge($solo_lectura,array('con_expl_ok'));
		}
		if(!Puede('editar','consistencias')){
			$solo_lectura=array_merge($solo_lectura,array('con_con', 'con_precondicion', 'con_rel', 'con_postcondicion', 'con_activa', 'con_tipo', 'con_gravedad', 'con_momento', 'con_version', 'con_orden', 'con_grupo', 'con_descripcion', 'con_modulo'));
		}
		return $solo_lectura;
	}
	function joins(){
		return array(
			'tabulado'=>array(
				'con_precondicion'=>'tab_precondicion'
				, 'con_postcondicion'=>'tab_postcondicion'
				, 'con_junta'=>'tab_junta'
				, 'con_ignorar_nulls'=>'tab_ignorar_nulls'
				, 'con_con'=>'tab_es_consistencia'
		));
	}
	function pks(){
		return array('con_con');
	}
	function puede_eliminar(){
		return Puede('eliminar','consistencias');
	}
}

class Grilla_con_var extends Grilla{
	function campos_a_listar($filtro_para_lectura){
		return array('convar_var', 'convar_texto', 'convar_for');
	}
	function clausula_where($filtro_para_lectura){
		global $annio2d;
		return parent::clausula_where($filtro_para_lectura)." and (convar_enc='EAH20{$annio2d}' or convar_enc is null)";
	}
	function pks(){
		return array('convar_con','convar_var');
	}
}

class Grilla_dominios extends Grilla_base_tem{
	function __construct(){
		parent::__construct('d',1);
	}
}

class Grilla_encuess extends Grilla{
	function __construct(){
		global $annio2d;
		$this->nombre_tabla="tem{$annio2d}";
	}
	function boton_enviar(){
		return array('leyenda'=>'i', 'title'=>'Ingresar encuesta', 'accion'=>'AbrirEncuesta');
	}
	function campos_a_listar($filtro_para_lectura){
		$campos=array('comuna', 'replica', 'up', 'lote', 'encues', 'cnombre', 'hn', 'hp', 'hd', 'hab', 'ident_edif', 'barrio'
			, 'estado', 'cod_enc', 'encues as encuesta', 'rea', 'hog', 'pobl', 'norea_enc', 's1_extra', 'fec_enc'
			, 'fec_entr_recu', 'fec_recu', 'cod_recu', 'norea_recu'
			, 'sup_tel', 'sup_campo', 'sup_recu_campo', 'rea_modulo' , 'norea_modulo', 'rea_recu_modu', 'norea_recu_modu'
			, 'cod_sup', 'fin_sup' , 'bolsa');
		if(@$filtro_para_lectura['dominio']=='i'){
			$mas_campos=array('inq_recuento', 'inq_tipo_viv', 'inq_ocu_flia','inq_ocu_pas','inq_desocupados','inq_otro','inq_tot_hab','inq_dominio');
			array_splice($campos,15,0,$mas_campos);
		}
		if(@$filtro_para_lectura['dominio']=='v'){
			$mas_campos=array('vil_hogpre_rea','vil_hogpre_hog','vil_hogpre_pob','vil_hogaus_rea','vil_hogaus_hog','vil_hogaus_pob','inq_tot_hab','inq_dominio');
			array_splice($campos,14,0,$mas_campos);
		}
		
		return $campos;
	}
	function campos_de_auditoria_para_update(){
		global $db,$usuario_logueado;
		return ', usu_ult_mod='.$db->quote($usuario_logueado);
	}
	function pks(){
		return array("encues");
	}
	function puede_eliminar(){
		return false;
	}
	function remover_en_nombre_de_campo(){
		return "^aux_";
	}
}
class Grilla_errores_salto extends Grilla{
	function campos_a_listar($filtro_para_lectura){
		global $annio2d; 
		$ver= array('res_encuesta', 'res_hogar'
		            , 'coalesce(nullif(res_miembro,0),nullif(res_ex_miembro,0)) as res_miembro_o_ex'
					, 'nullif(res_relacion,0) as res_relacion'
					, 'res_var', 'var_texto'
					, 'res_for', 'res_mat'
					, "case when res_respuesta in ('-1','SIN ESPECIFICAR') then '--' else res_respuesta end as res_respuesta"
					, "substring(res_estado from char_length(res_estado)-3) estado");
		if(!$filtro_para_lectura){
			array_splice($ver, count($ver),0,array(
					'esting_descripcion'
					, 'esting_correcto'
				    , "comuna", 'replica', 'lote', 'cod_enc', 'cod_recu', 'cod_sup', 'bolsa'
					)
			);
		}
		return $ver;
	}
	function clausula_where($filtro_para_lectura){
		return parent::clausula_where($filtro_para_lectura)." and (not esting_correcto) and (p7<>3 or p7 is null)";
	}
	function obtener_tabla_o_subselect(){
		global $annio2d;
		return "(SELECT * FROM respuestas INNER JOIN tem11 ON res_encuesta=encues 
		INNER JOIN estado_de_ingreso ON esting_estado=res_estado
		LEFT JOIN variables ON var_var=res_var and var_enc='EAH2011'
		left join eah11_fam on res_encuesta=nenc and res_hogar = nhogar and res_miembro=p0)";
	}
	function pks(){
		return array('res_encuesta', 'res_hogar', 'res_miembro', 'res_ex_miembro', 'res_relacion', 'res_var');
	}
	function puede_eliminar(){
		return false;
	}
	// ACA!
}


class Grilla_estados extends Grilla_base_tem{
	function __construct(){
		parent::__construct('e',1);
	}
}

class Grilla_excepciones extends Grilla{
	function campos_editables($filtro_para_lectura){
		return array('exc_encues','exc_observacion');
	}
	function campos_a_listar($filtro_para_lectura){
		return array('exc_encues,exc_observacion');
	}
	function order_by(){
		return 'exc_encues';
	}
	function pks(){
		return array('exc_encues');
	}
	function puede_eliminar(){
		return Puede('eliminar','excepciones');
	}
	function sql_para_valores_insert_de_la_pk(){
		$valores=array();
		foreach($this->pks() as $campo_pk){
			$valores[]="1";
		}
		return $valores;
	}
}
class Grilla_formularios extends Grilla{
	function campos_a_listar($filtro_para_lectura){
		return array('*', '(select count(*) from celdas where cel_enc=for_enc and cel_for=for_for) as aux_cant_celdas');
	}
	function clausula_where($filtro_para_lectura){
		global $annio2d;
		return parent::clausula_where($filtro_para_lectura)." and for_enc='EAH20{$annio2d}' ";
	}
	function joins(){
		return array('celdas'=>array('for_enc'=>'cel_enc','for_for'=>'cel_for'));
	}
	function pks(){
		return array('for_enc','for_for');
	}
}

class Grilla_generica extends Grilla{
	var $pks;
	function __construct($nombre_tabla){
		global $db;
		$this->nombre_tabla=$nombre_tabla;
		$this->pks=$db->campos_pk('yeah',$nombre_tabla);
	}
	function pks(){
		return $this->pks;
	}
}

class Grilla_inconsistencias extends Grilla{
	function campos_a_listar($filtro_para_lectura){
		global $annio2d;
		return array(
			"(select bolsa from tem{$annio2d} where encues=inc_nenc) as bolsa"
	
			,'inc_nenc'
			,"(select id_proc from tem{$annio2d} where encues=inc_nenc) as id"
			,'inc_nhogar as "H"','inc_miembro_ex_0 as "M"','inc_relacion_0 as "R"'
			,'inc_con','inc_variables_y_valores','inc_justificacion'
			,'(select coalesce(con_explicacion,con_descripcion) from consistencias where con_con=inc_con) as "explicacion"'
			,'(select substr(con_gravedad,1,1) from consistencias where con_con=inc_con) as "Gr"'
			,"(select comuna from tem{$annio2d} where encues=inc_nenc) as comuna"
			,"(select estado from tem{$annio2d} where encues=inc_nenc) as estado"
			);
	}
	function campos_editables($filtro_para_lectura){
		return array('inc_justificacion');
	}
	function pks(){
		return array('inc_con','inc_nenc','inc_nhogar','inc_miembro_ex_0','inc_relacion_0');
	}
	function order_by(){
		return 'bolsa,inc_nenc,inc_nhogar,inc_miembro_ex_0,inc_relacion_0';
	}
	
	function puede_eliminar(){
		return false;
	}
}

class Grilla_inconsistencias_listado extends Grilla{
	function __construct(){
		$this->nombre_tabla='inconsistencias';
	}
	function campos_a_listar($filtro_para_lectura){
		global $annio2d;
		return array(
			"(select bolsa from tem{$annio2d} where encues=inc_nenc) as bolsa"
	
			,'inc_nenc'
			,"(select id_proc from tem{$annio2d} where encues=inc_nenc) as id"
			,'inc_nhogar as "H"'
            ,"inc_miembro_ex_0::text||coalesce('/'||nullif(inc_relacion_0,0)::text,'') as \"M\""
			,'inc_con'
            ,"(select coalesce(inc_variables_y_valores,'')||chr(10)||coalesce(con_descripcion,con_explicacion) from consistencias where con_con=inc_con) as detalle"
            ,'inc_justificacion'
			,'(select substr(con_gravedad,1,1) from consistencias where con_con=inc_con) as "Gr"'
			,"(select estado from tem{$annio2d} where encues=inc_nenc) as est"
            ,"'' as observaciones"
			);
	}
	function pks(){
		return array('inc_con','inc_nenc','inc_nhogar','inc_miembro_ex_0','inc_relacion_0');
	}
	function order_by(){
		return 'bolsa,inc_nenc,inc_nhogar,inc_miembro_ex_0,inc_relacion_0';
	}
}

class Grilla_ingreso_faltante extends Grilla{
	function campos_a_listar($filtro_para_lectura){
		global $annio2d; 
		return array('res_encuesta', 'res_hogar'
		            , 'coalesce(nullif(res_miembro,0),nullif(res_ex_miembro,0)) as res_miembro_o_ex'
					, 'nullif(res_relacion,0) as res_relacion'
					, 'res_var', 'var_texto'
					, 'res_for', 'res_mat'
					, "case when res_respuesta in ('-1','SIN ESPECIFICAR') then '--' else res_respuesta end as res_respuesta"
				    , "comuna", 'replica', 'lote', 'cod_enc', 'cod_recu', 'cod_sup', 'bolsa'
				   );
	}
	function clausula_where($filtro_para_lectura){
		return parent::clausula_where($filtro_para_lectura)." and (res_respuesta in ('-1','SIN ESPECIFICAR'))";
	}
	function obtener_tabla_o_subselect(){
		global $annio2d;
		return "(SELECT * FROM respuestas INNER JOIN tem{$annio2d} ON res_encuesta=encues LEFT JOIN variables ON var_var=res_var)";
	}
	function pks(){
		return array('res_encuesta', 'res_hogar', 'res_miembro', 'res_ex_miembro', 'res_relacion', 'res_var');
	}
	function puede_eliminar(){
		return false;
	}
	// ACA!
}

class Grilla_his_inconsistencias extends Grilla{
    function __construct(){
        parent::__construct();
        if(Puede('ver','auditoria_modificaciones')){
            $this->nombre_tabla='his_inconsistencias';
            $this->esquema='his';
        }else{
            $this->nombre_tabla='(select 1 as dato where false)';
        }
    }
	function campos_a_listar($filtro_para_lectura){
        if(Puede('ver','auditoria_modificaciones')){
        return array('inc_con','inc_nenc','inc_nhogar as "H"','inc_miembro_ex_0 as "M"','inc_relacion_0 as "R"','inc_variables_y_valores','inc_justificacion'
			,'(select coalesce(con_explicacion,con_descripcion) from consistencias where con_con=inc_con) as "explicacion"'
			,'(select substr(con_gravedad,1,1) from consistencias where con_con=inc_con) as "Gr"'
			);
        }else{
            return array('dato');
        }
	}
	function pks(){
		return array('inc_con','inc_nenc','inc_nhogar','inc_miembro_ex_0','inc_relacion_0');
	}
	function puede_eliminar(){
		return false;
	}
}
class Grilla_his_inconsistencias_25 extends Grilla{
    function __construct(){
        parent::__construct();
            $this->nombre_tabla='his_inconsistencias';
            $this->esquema='his';
    }
	function campos_a_listar($filtro_para_lectura){
        return array('inc_con','inc_nenc','inc_nhogar as "H"','inc_miembro_ex_0 as "M"','inc_relacion_0 as "R"','inc_variables_y_valores','inc_justificacion'
			,'(select coalesce(con_explicacion,con_descripcion) from consistencias where con_con=inc_con) as "explicacion"'
			,'(select substr(con_gravedad,1,1) from consistencias where con_con=inc_con) as "Gr"'
			);
	}
	function pks(){
		return array('inc_con','inc_nenc','inc_nhogar','inc_miembro_ex_0','inc_relacion_0');
	}
	function puede_eliminar(){
		return false;
	}
	function puede_insertar(){
		return false;
	}
	function obtener_tabla_o_subselect($filtro_para_lectura){
		    return <<<SQL
               (select * from his.his_inconsistencias where inc_estado_tem=25)
SQL;
        }
	function campos_editables($filtro_para_lectura){
		return array();
	}
}

class Grilla_his_respuestas extends Grilla{
	function campos_a_listar($filtro_para_lectura){
		global $annio2d; 
        if(Puede('ver','auditoria_modificaciones')){
            return array('res_encuesta', 'res_hogar as "H"', 'coalesce(res_miembro,res_ex_miembro) as "M"', 'res_relacion as "R"',
                        'res_var', 'res_for', 'respuestas'
                        );
        }else{
            return array('dato');
        }
	}
	function obtener_tabla_o_subselect($filtro_para_lectura){
		global $annio2d;
		$clausula_where=$this->clausula_where($filtro_para_lectura);
        if(Puede('ver','auditoria_modificaciones')){
            return <<<SQL
               (select res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for
					,  substr(concato(' \u2192 '||res_respuesta),2) as respuestas
                  from (
                    SELECT res_encuesta, res_hogar , res_miembro ,res_ex_miembro, res_relacion, res_fec_ult_mod, 
                           res_var, res_for, res_respuesta, res_estado
                           , lead(res_var,1) over (order by res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var) as var_prox
                           , lead(res_var,-1) over (order by res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var) as var_ant
                      FROM his.his_respuestas
					  $clausula_where
                      order by res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var) x
                  where res_var=var_prox or res_var=var_ant
				  group by res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for)
SQL;
        }else{
            return '(select 1 as dato where false)';
        }
    }
	function pks(){
		return array('res_encuesta','res_hogar','res_miembro','res_ex_miembro','res_relacion','res_var');
	}
}

class Grilla_las_comunas extends Grilla{
	function __construct(){
		parent::__construct();
		$this->nombre_tabla='comunas';
	}
	function campos_a_listar($filtro_para_lectura){
		return array('comuna_comuna'
				   , 'comuna_cod_recep'
				   , "(select coalesce(per_apellido||', ','')||coalesce(per_nombre,'') from personal where per_per=comuna_cod_recep) as recepcionista"
				   , 'comuna_cod_recu'
				   , "(select coalesce(per_apellido||', ','')||coalesce(per_nombre,'') from personal where per_per=comuna_cod_recu) as recuperador"
				   , 'comuna_cod_sup'
				   , "(select coalesce(per_apellido||', ','')||coalesce(per_nombre,'') from personal where per_per=comuna_cod_sup) as supervisor"
				   , 'comuna_cod_subcoor'
				   , "(select coalesce(per_apellido||', ','')||coalesce(per_nombre,'') from personal where per_per=comuna_cod_subcoor) as subcoordinador")
				   ;
	}
	function pks(){
		return array('comuna_comuna');
	}
	function puede_eliminar(){
		return false;
	}
	function campos_editables($filtro_para_lectura){
		if(Puede('administrar','comunas')){
			return array('comuna_cod_recep','comuna_cod_recu','comuna_cod_subcoor','comuna_cod_sup');
		}else {
			return array();
		} 
	}

}

class Grilla_lotes extends Grilla_base_tem{
	function __construct(){
		parent::__construct('d',2);
	}
	function boton_enviar(){
		return array('leyenda'=>'S', 'title'=>'marcar las supervisiones', 'accion'=>'MarcarSupervisiones');
	}
}
class Grilla_no_realizadas extends Grilla{
	
    function __construct(){
        parent::__construct();
            $this->nombre_tabla='tem11';
    }
	function pks(){
		return array('encues');
	}
	function puede_eliminar(){
		return false;
	}
	function puede_insertar(){
		return false;
	}
	function obtener_tabla_o_subselect($filtro_para_lectura){
		    return <<<SQL
               (select encues, comuna, frac_comun frac, radio_comu radio, mza_comuna mza, cnombre calle, hn, hp, hd, ident_edif, barrio, norea_enc,s1a1_obs from yeah_2011.tem11 t11 left join yeah_2011.eah11_viv_s1a1 s1a1 on t11.encues = s1a1.nenc where    t11.rea in (0,2))
SQL;
        }
	function campos_editables($filtro_para_lectura){
		return array();
	}
	function order_by(){
		return 'comuna::integer, frac::integer, radio::integer, mza::integer';
	}
	
}

class Grilla_opciones extends Grilla_base_preguntas_u_opciones{
	function clausula_where($filtro_para_lectura){
		global $annio2d;
		Loguear(3,var_export($filtro_para_lectura,true));
		if(@in_array('para_subgrilla',$filtro_para_lectura) && !isset($filtro_para_lectura['val_padre']) && isset($filtro_para_lectura[3])){
			$filtro_para_lectura['val_padre']=$filtro_para_lectura[3];
			unset($filtro_para_lectura[3]);
		}
		Loguear(3,var_export($filtro_para_lectura,true));
		return parent::clausula_where($filtro_para_lectura);
	}
}

class Grilla_personal extends Grilla{
	function campos_editables($filtro_para_lectura){
		if(Puede('administrar','personal')){
			return true;
		}else {
			return array();
		} 
	}
	function pks(){
		return array('per_per');
	}
	function puede_eliminar(){
		return Puede('eliminar','personal');
	}
}

class Grilla_poseedors extends Grilla_base_tem{
	function __construct(){
		parent::__construct('a',2);
	}
}

class Grilla_preguntas extends Grilla_base_preguntas_u_opciones{
	function clausula_where($filtro_para_lectura){
		global $annio2d;
		return parent::clausula_where($filtro_para_lectura)." and val_tipovar is not null";
	}
	function joins(){
		return array('opciones'=>array('val_enc'=>'val_enc','val_for'=>'val_for','val_cel'=>'val_cel','val_val'=>'val_padre'));
	}
}

class Grilla_principal extends Grilla{
	function campos_editables($filtro_para_lectura){
		return array();
	}
	function obtener_datos($filtro_para_lectura){
		global $db,$annio2d;
		$poseed=$db->preguntar("select count(distinct rol_poseedor) from tem{$annio2d}");
		$bolsas=$db->preguntar("select count(distinct bolsa) from tem{$annio2d}");
		$estados=$db->preguntar("select count(distinct estado) from tem{$annio2d}");
		return array(
			  '["a"]'=>array("rama"=>'a',"agrupado_por"=>"asignaciones"        ,"subgrilla_grupos"=>array('mostrar'=>$poseed ,'grilla'=>'rol_poseedor','pk'=>'[]'))
			, '["b"]'=>array("rama"=>'b',"agrupado_por"=>"bolsa"               ,"subgrilla_grupos"=>array('mostrar'=>$bolsas ,'grilla'=>'bolsas'  ,'pk'=>'[]'))
			, '["c"]'=>array("rama"=>'c',"agrupado_por"=>"comuna, replica y up","subgrilla_grupos"=>array('mostrar'=>15      ,'grilla'=>'comunas' ,'pk'=>'[]'))
			, '["d"]'=>array("rama"=>'d',"agrupado_por"=>"dominio y lote"      ,"subgrilla_grupos"=>array('mostrar'=>3       ,'grilla'=>'dominios','pk'=>'[]'))
			, '["e"]'=>array("rama"=>'e',"agrupado_por"=>"estados"             ,"subgrilla_grupos"=>array('mostrar'=>$estados,'grilla'=>'estados' ,'pk'=>'[]'))
		);
	}
	function pks(){
		return array();
	}
	function puede_eliminar(){
		return false;
	}
}

class Grilla_replicas extends Grilla_base_tem{
	function __construct(){
		parent::__construct('c',2);
	}
}
class Grilla_respuestas_nsnc extends Grilla{
    function __construct(){
        parent::__construct();
            $this->nombre_tabla='respuestas';
    }
	function pks(){
		return array('res_encuesta', 'res_hogar', 'res_miembro', 'res_ex_miembro', 'res_relacion', 'res_var');
	}
	function puede_eliminar(){
		return false;
	}
	function puede_insertar(){
		return false;
	}
	function obtener_tabla_o_subselect($filtro_para_lectura){
		    return <<<SQL
               (select bolsa, id_proc as id, respuestas.* from respuestas inner join tem11 on encues=res_encuesta where res_respuesta in ('99','999','9999','9999999', '-1') 
				and res_encuesta in (select inc_nenc from inconsistencias group by inc_nenc) order by res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var)
SQL;
        }
	function campos_editables($filtro_para_lectura){
		return array();
	}
}

class Grilla_roles extends Grilla{
	function pks(){
		return array('rol_rol');
	}
	function puede_eliminar(){
		return Puede('eliminar','roles');
	}
	function puede_insertar(){
		return Puede('insertar','roles');
	}
}

class Grilla_rol_poseedor extends Grilla_base_tem{
	function __construct(){
		parent::__construct('a',1);
	}
}

class Grilla_ups extends Grilla_base_tem{
	function __construct(){
		parent::__construct('c',3);
	}
}

class Grilla_usuarios extends Grilla{
	function campos_a_listar($filtro_para_lectura){
		$campos=array('usu_usu', 'usu_rol', 'usu_nombre', 'usu_apellido', 'usu_interno', 'usu_mail', 'usu_activo', 'length(usu_clave)<>32 as aux_con_clave_provisoria');
		if(Puede('ver','md5 passowrd')){
			array_splice($campos,6,0,'usu_clave');
		}
		return $campos;
	}
	function campos_editables($filtro_para_lectura){
		if(Puede('administrar','usuarios')){
			return true;
		}else if(Puede('blanquear password')){
			return array('usu_clave');
		}
		return array();
	}
	function campos_solo_lectura(){
		return array('aux_con_clave_provisoria');
	}
	function pks(){
		return array('usu_usu');
	}
}

class Grilla_variables extends Grilla{
	function campos_a_listar($filtro_para_lectura){
		return array('var_enc', 'var_for', 'var_var',
					 "'' as tabulado_tabulado", 
					 'var_texto', 'var_salta', 'var_tipovar', 'var_nsnc',
					 'var_maximo', 'var_minimo', 'var_advertencia_sup', 'var_advertencia_inf', 'var_expresion_habilitar'
					 );
	}
	function clausula_where($filtro_para_lectura){
		global $annio2d;
		return parent::clausula_where($filtro_para_lectura)." and var_enc='EAH20{$annio2d}' ";
	}
	function joins(){
		return array('tabulado'=>array('var_var'=>'tab_expresion','var_for'=>'tab_for','var_mat'=>'tab_mat'));
	}
	function pks(){
		return array('var_enc','var_for','var_var');
	}
}
//kzk
class Grilla_version_commit_instalado_en_produccion extends Grilla{
	function __construct(){
		parent::__construct();
		$this->nombre_tabla='parametros';
	}
	function campos_a_listar($filtro_para_lectura){
		return array('versioncommitinstaladoenproduccion');
	}
	function campos_solo_lectura(){
		return array('versioncommitinstaladoenproduccion');
	}
	function pks(){
		return array('unicoregistro');
	}
	function puede_eliminar(){
		return false;
	} 
}
//kzk
function grilla($nombre){
	$la_grilla;
	Loguear(3,'xxxxxxxxxxxxx');
	try{
		$reflector=new ReflectionClass("Grilla_$nombre");
		Loguear(3,'yyyyyyyyyyy');
		$la_grilla=$reflector->newInstance();
	}catch(Exception $e){
		Loguear(3,'xzzzzzzzzzzzz');
		if(Puede('hacer todo')){
			$la_grilla=new Grilla_generica($nombre);
		}
		
	}
	return $la_grilla;
}

?>