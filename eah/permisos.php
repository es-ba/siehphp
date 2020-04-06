<?php
$este_rol_contiene=false;

function Cargar_Roles_De_La_Base(){
global $db,$este_rol_contiene,$usuario_rol;
	if(!$este_rol_contiene){
		$este_rol_contiene=array();
		$cursor=$db->ejecutar(<<<SQL
			SELECT rol_rol, rolrol_delegado
				FROM roles left join rol_rol on rol_rol=rolrol_delegado and :usu_rol=rolrol_principal
SQL
		, array(':usu_rol'=>$usuario_rol)
		);
		while($fila=$cursor->fetchObject()){
			$este_rol_contiene[$fila->rol_rol]=$fila->rolrol_delegado?true:false;
		}
		$este_rol_contiene[$usuario_rol]=true;
	}
	Loguear('2011-10-03',var_export($este_rol_contiene,true));
}

function Puede($accion, $detalles='', $subdetalles=false){
global $este_rol_contiene;
	Cargar_Roles_De_La_Base();
	if($este_rol_contiene['programador']){
		return true;
	}
	switch($accion){
		case 'editar':
			switch($detalles){
				case 'bolsas':
					switch($subdetalles){
					    case 'bolsa_cerrada':
							return $este_rol_contiene['subcoor_campo'];
					    case 'bolsa_revisada':
							return $este_rol_contiene['sup_ing'];
					}
					return false;
				case 'consistencias':
					return $este_rol_contiene['procesamiento'];
				case 'excepciones':
					return true;
				case 'textos de los metadatos de los formularios':
					return true;
				case 'tem':
				case 'tem11':
				case 'encuess':
					switch($subdetalles){
					    case false:
							return $este_rol_contiene['recepcionista'];
						case 'cod_enc':
						case 'rea':
						case 'norea_enc':
						case 'cod_recu':
						case 'fec_enc':
						case 'fec_entr_recu':
						case 'fec_recu':
						case 'norea_recu':
						case 'pobl':
						case 'hog':
						case 'rea_modulo':
						case 'norea_modulo':
						case 'rea_recu_modu':
						case 'norea_recu_modu':
						case 's1_extra':
						
						case 'inq_recuento':
						case 'inq_tipo_viv':
						case 'inq_ocu_flia':
						case 'inq_ocu_pas':
						case 'inq_desocupados':
						case 'inq_otro':
						case 'inq_tot_hab':
						case 'inq_dominio':
						case 'vil_hogpre_rea':
						case 'vil_hogpre_hog':
						case 'vil_hogpre_pob':
						case 'vil_hogaus_rea':
						case 'vil_hogaus_hog':
						case 'vil_hogaus_pob':
							return $este_rol_contiene['recepcionista'];
						case 'sup_tel':
						case 'sup_campo':
						case 'sup_recu_campo':
						case 'cod_sup':
						case 'fin_sup':
						case 'bolsa':
							return $este_rol_contiene['subcoor_campo'];
						case 'cnombre':
						case 'hn':
						case 'hp':
						case 'hd':
						case 'hab':
						case 'ident_edif':
						case 'barrio':
							return $este_rol_contiene['mues_campo'];
					}
					return false; 
				case 'tabulados':
					return $este_rol_contiene['mues_campo'] || $este_rol_contiene['procesamiento']; 
				case 'excepciones':
					return true; 

			}
			return false;
		case 'eliminar':
			switch($detalles){
				case 'consistencias':
					return $este_rol_contiene['procesamiento'];
				case 'personal':
					return $este_rol_contiene['subcoor_campo'];
				case 'encuestas':
					return $este_rol_contiene['procesamiento'];
				case 'formularios':
					return $este_rol_contiene['procesamiento'];
				case 'agregados_tem':
					return $este_rol_contiene['mues_campo'];
				case 'tabulados':
					return $este_rol_contiene['mues_campo'] || $este_rol_contiene['procesamiento'];
				case 'excepciones':
					return $este_rol_contiene['programador'];
			}
			return false;
		case 'grabar en':
			switch($detalles){
				case 'consistencias':
					return $este_rol_contiene['procesamiento'] || $este_rol_contiene['tematica'];
				case 'inconsistencias':
					return $este_rol_contiene['ana_ing'] || $este_rol_contiene['ana_campo'];
				case 'encuess':
					return $este_rol_contiene['recepcionista'];
				case 'bolsas':
					return $este_rol_contiene['sup_ing'] || $este_rol_contiene['subcoor_campo'];
				case 'personal':
					return $este_rol_contiene['subcoor_campo'];
				case 'las_comunas':
					return $este_rol_contiene['coor_campo'];
				case 'agregados_tem':
					return $este_rol_contiene['mues_campo'];
				case 'tabulados':
					return $este_rol_contiene['mues_campo'] || $este_rol_contiene['procesamiento'];
				case 'excepciones':
					return true;
			}
			return false;
		case 'confirmar':
			switch($detalles){
				case 'explicación de consistencias':
					return $este_rol_contiene['tematica'];
			}
			return false;
		case 'administrar':
			switch($detalles){
				case 'personal':
					return $este_rol_contiene['subcoor_campo'];
				case 'comunas':
					return $este_rol_contiene['coor_campo'];
				case 'agregados_tem':
					return $este_rol_contiene['mues_campo'];
			}
			return false;
		case 'cambio estado tem':
		case 'crear':
			switch($detalles){
				case 'usuarios':
					return true;
			}
		case 'seguimiento':
			return $este_rol_contiene['recepcionista'] || $este_rol_contiene['ana_ing']|| $este_rol_contiene['ana_campo'];
		case 'ingresar encuestas':
			return $este_rol_contiene['ingresador'];
		case 'finalizar_encuesta':
			switch($detalles){
				case 'mandar a campo':
					return $este_rol_contiene['ana_ing'] || $este_rol_contiene['procesamiento']; // sé que procesamiento contiene ana_ing, pero eso podría mañana dejar de ser. 
				case 'mandar a procesamiento':
					return $este_rol_contiene['ana_campo'] || $este_rol_contiene['ana_ing'] && !$este_rol_contiene['procesamiento'];
				case 'aceptar inconsistentes':
					return $este_rol_contiene['procesamiento'];
			}
		case 'ver':
			switch($detalles){
				case 'tabulados':
					return $este_rol_contiene['mues_campo'] || $este_rol_contiene['procesamiento']; 
				case 'auditoria_modificaciones':
					return $este_rol_contiene['mues_campo'] || $este_rol_contiene['procesamiento']; 
				case 'respuestas_nsnc':
					return $este_rol_contiene['procesamiento']; 
				case 'his_inconsistencias_25':
					return $este_rol_contiene['mues_campo']; 
				case 'no_realizadas':
					return $este_rol_contiene['mues_campo']; 
		}
		case 'reabrir':
			switch($detalles){
				case 'bolsas':
					return $este_rol_contiene['procesamiento']; 
				case 'encuestas':
					return $este_rol_contiene['sup_ing'] || $este_rol_contiene['procesamiento'] || $este_rol_contiene['mues_campo']; 
		}
	}
	return false;
}

?>