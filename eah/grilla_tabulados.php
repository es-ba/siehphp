<?php

// Tabulado  (singular) es un tabulado, o sea la grilla con el resultado
// Tabulados (plural) es la tabla donde se definen los tabulados (los tabulados pueden originarse de tabulados, de variables o de consistencias).

$juntas=array(
	  's1a1'=>"(tem11 t inner join eah11_viv_s1a1 a on a.nenc=t.encues)"
	, 'fam' =>"(tem11 t inner join eah11_viv_s1a1 a on a.nenc=t.encues) inner join eah11_fam f on a.nenc=f.nenc and a.nhogar=f.nhogar"
	, 'i1'  =>"(tem11 t inner join eah11_viv_s1a1 a on a.nenc=t.encues) inner join eah11_fam f on a.nenc=f.nenc and a.nhogar=f.nhogar inner join eah11_i1 i on f.nenc=i.nenc and f.nhogar=i.nhogar and f.p0=i.miembro and (participacion=1 or participacion>1 and p7<>3)"
	, 'md'  =>"(tem11 t inner join eah11_viv_s1a1 a on a.nenc=t.encues) inner join eah11_fam f on a.nenc=f.nenc and a.nhogar=f.nhogar inner join eah11_i1 i on f.nenc=i.nenc and f.nhogar=i.nhogar and f.p0=i.miembro and (participacion=1 or participacion>1 and p7<>3) inner join eah11_md d on d.nenc=f.nenc and d.nhogar=f.nhogar and d.miembro=f.p0"
	, 'un'  =>"(tem11 t inner join eah11_viv_s1a1 a on a.nenc=t.encues) inner join eah11_fam f on a.nenc=f.nenc and a.nhogar=f.nhogar inner join eah11_i1 i on f.nenc=i.nenc and f.nhogar=i.nhogar and f.p0=i.miembro and (participacion=1 or participacion>1 and p7<>3) inner join eah11_un u on u.nenc=f.nenc and u.nhogar=f.nhogar and u.miembro=f.p0"
	, 'ex'  =>"(tem11 t inner join eah11_viv_s1a1 a on a.nenc=t.encues) inner join eah11_ex e on e.nenc=a.nenc and e.nhogar=a.nhogar "
);

class Grilla_tabulado extends Grilla{
	function obtener_datos($filtro_para_lectura){
		global $db,$annio2d,$tabla_de,$juntas;
		if(@$filtro_para_lectura['tab_for']){
			$from="FROM eah{$annio2d}_".$tabla_de[@$filtro_para_lectura['tab_for']][@$filtro_para_lectura['tab_mat']];
		}elseif(@$filtro_para_lectura['tab_junta']){
			$sql_junta=$juntas[@$filtro_para_lectura['tab_junta']];
			$from="FROM ($sql_junta) z ";
		}
		if(@$filtro_para_lectura['tab_postcondicion']){
			if(@$filtro_para_lectura['tab_precondicion']){
				$filtro_para_lectura['tab_expresion']=<<<SQL
					CASE WHEN ({$filtro_para_lectura['tab_precondicion']}) IS NOT TRUE THEN 3
						WHEN ({$filtro_para_lectura['tab_postcondicion']}) IS NOT TRUE THEN 1 ELSE 2 END
SQL;
			}else{
				$filtro_para_lectura['tab_expresion']=<<<SQL
					CASE WHEN ({$filtro_para_lectura['tab_postcondicion']}) IS NOT TRUE THEN 1 ELSE 2 END
SQL;
			}
			$tab_expresion=$filtro_para_lectura['tab_expresion'];
			$tab_expresion=Acomodar_Expresion($tab_expresion,@$filtro_para_lectura['tab_ignorar_nulls']);
			$join_texto=<<<SQL
			LEFT JOIN (
				SELECT 1 AS val_num, 'fallan' AS val_texto, null as var_nsnc
				UNION SELECT 2 AS val_num, 'pasan' AS val_texto , null as var_nsnc
				UNION SELECT 3 AS val_num, 'no entran' AS val_texto , null as var_nsnc) v ON val_num=($tab_expresion)
SQL;
		}else{
			$primera_expresion=$filtro_para_lectura['tab_expresion'];
			$join_texto=<<<SQL
				LEFT JOIN variables ON var_var='$primera_expresion' and var_enc='EAH20{$annio2d}'
				LEFT JOIN valores ON val_enc=var_enc and val_for=var_for and val_cel=var_cel and val_padre=var_val and val_opcion=($primera_expresion)::text
SQL;
		}
		$coma="";
		$expresiones_order_by="";
		$expresiones_valor="";
		$numero="";
		$reyeno="";
		while($tab_expresion=@$filtro_para_lectura['tab_expresion'.$numero]){
			$tab_expresion=Acomodar_Expresion($tab_expresion,@$filtro_para_lectura['tab_ignorar_nulls']);
			$expresiones_order_by.=$coma.$tab_expresion;
			$expresiones_valor.="$coma($tab_expresion)::text as \"valor $numero\"";
			if($numero){
				$reyeno.=",''";
			}else{
				$primera_expresion=$tab_expresion;
			}
			$numero=$numero?$numero+1:2;
			$coma=",";
		}
		$datos_tabla=$db->preguntar_tabla_pk(<<<SQL
			SELECT row_number() over (order by $expresiones_order_by) as pk, $expresiones_valor
				, coalesce(val_texto,case ($primera_expresion)::text when '-1' then '-- SIN ESP --' when var_nsnc::text then 'NS//NC' else '' end) as texto
				, count(*)
			  $from
			  $join_texto
			  GROUP BY $expresiones_order_by, val_texto, var_nsnc
SQL
		.(($numero>2 || (@$filtro_para_lectura['tab_postcondicion']))?'':<<<SQL
			UNION 
			SELECT 9999999990 as pk, chr(8721),'positivos' $reyeno,count(*)
			  $from
				LEFT JOIN variables ON var_var='$primera_expresion' and var_enc='EAH20{$annio2d}'
			  WHERE ($primera_expresion)::text not in ('-1',var_nsnc::text)
			UNION 
			SELECT 9999999991 as pk, chr(8721),'sin nulos' $reyeno,count(*)
			  $from
			  WHERE ($primera_expresion) is not null
SQL
		).<<<SQL
			UNION 
			SELECT 9999999992 as pk, chr(8721),'totales' $reyeno,count(*)
			  $from
			ORDER BY 2,3,4
SQL
		);
		return $datos_tabla;
	}
	function pks(){
		return array();
	}
}

class Grilla_tabulados extends Grilla{
	function campos_a_listar($filtro_para_lectura){
		return array('*', "'' as tabulado_tabulado");
	}
	function campos_editables($filtro_para_lectura){
		if(Puede('editar','tabulados')){
			return true;
		}else{
			return array();
		}
	}
	function joins(){
		return array(
			'tabulado'=>array(
				'tab_var1'=>'tab_expresion'
				, 'tab_var2'=>'tab_expresion2'
				, 'tab_junta'=>'tab_junta'
				, 'tab_ignorar_nulls'=>'tab_ignorar_nulls'
		));
	}
	function pks(){
		return array('tab_tab');
	}
	function puede_eliminar(){
		return Puede('eliminar','tabulados');
	}
}

?>