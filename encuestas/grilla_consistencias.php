<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_consistencias extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="consistencias";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_consistencias");
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'con_ope',
            'con_rev',
            'con_junta',
            'con_clausula_from',
            'con_expresion_sql',
            'con_valida',
            'con_error_compilacion',
            'con_ultima_modificacion',
            'con_ultima_variable',
            'con_ignorar_nulls'
        );
        if(!tiene_rol('programador') && !tiene_rol('procesamiento')){
            $campos_solo_lectura=array_merge($campos_solo_lectura,array(
                'con_precondicion',
                'con_rel',
                'con_postcondicion',
                'con_activa',
                'con_con',
                'con_grupo',
                'con_modulo',
                'con_momento',
                'con_version',
                'con_expl_ok',
                'con_descripcion',
                'con_tipo',
                'con_gravedad',
                'con_explicacion',
                'con_orden'
            ));
        }
        return $campos_solo_lectura;
    }
    function campos_editables($filtro_para_lectura){
        $editables=array();
        if(tiene_rol('programador') || tiene_rol('procesamiento')){
            return parent::campos_editables($filtro_para_lectura);
        }
        return $editables;
    }
    function campos_a_excluir($filtro_para_lectura){
        return array('con_tlg','con_clausula_from','con_junta','con_expresion_sql','con_ope','con_rev',
            'con_ultima_modificacion','con_ignorar_nulls','con_ultima_variable','con_grupo', 'con_descripcion',
            'con_expl_ok', 'con_estado', 'con_importancia', 'con_gravedad', 'con_orden', 'con_version');
    }
    function permite_grilla_sin_filtro(){
        return true;
    }
    function obtener_otros_atributos_y_completar_fila(&$fila,&$atributos_fila){
        $para_filtro_para_inconsistencias=array(
            'inc_ope'=>$GLOBALS['NOMBRE_APP'], 
            'inc_con'=>$fila['con_con'],
        );
        $filtro_para_inconsistencias=new Filtro_Normal($para_filtro_para_inconsistencias);
        $tabla_inconsistencias=$this->tabla->definicion_tabla('inconsistencias');
        $fila['con_cuantos']=$tabla_inconsistencias->contar_cuantos($filtro_para_inconsistencias);
        $atributos_fila['con_cuantos']['clase']=array(); 
        if($fila['con_tipo']=='Revisar'){
            foreach($fila as $campo=>$valor){
                $atributos_fila[$campo]['clase']='consistencias_a_revisar'; 
            }
        } 
        $tabla_variables=$this->contexto->nuevo_objeto("Tabla_variables");
        $tabla_variables->leer_uno_si_hay(array('var_ope'=>$GLOBALS['NOMBRE_APP'],'var_var'=>'s1a1_obs'));
        $leido=0;
        if($tabla_variables->obtener_leido()){        
            $cursor=$this->contexto->db->ejecutar_sql(new Sql(<<<SQL
                select string_agg(t.enc_encontrada, ' ')::text as con_salta
                  from
                    (select con_con, con_ope, case 
                          when (position(' '||con_con in substr(pla_s1a1_obs,position('SALTA' in pla_s1a1_obs)+5))>0 and 
                             length(substr(pla_s1a1_obs,position('SALTA' in pla_s1a1_obs)+5))+1=position(' '||con_con in substr(pla_s1a1_obs,position('SALTA' in pla_s1a1_obs)+5))+length(' '||con_con)) 
                            then pla_enc||' ' 
                          when (position(' '||con_con||' ' in substr(pla_s1a1_obs,position('SALTA' in pla_s1a1_obs)+5))>0 and 
                                length(substr(pla_s1a1_obs,position('SALTA' in pla_s1a1_obs)+5))+1>position(' '||con_con||' ' in substr(pla_s1a1_obs,position('SALTA' in pla_s1a1_obs)+5))+length(' '||con_con||' ')) 
                            then pla_enc||' '
                          else '' end as enc_encontrada 
                        from encu.consistencias inner join encu.plana_s1_ on true where pla_hog=1 order by con_con) t 
                  where t.con_con=:que_con and t.con_ope=:que_ope 
                  group by t.con_con    
SQL
                ,array(':que_con'=>$fila['con_con'], ':que_ope'=>$GLOBALS['NOMBRE_APP'])
                )
            );
            $leido=$cursor->fetchObject();
        }    
        $fila['con_ejemplos']=($leido)?$leido->con_salta:'';
    }
    function responder_detallar(){
        return false;
    }
    function boton_enviar(){
        return array(
            'leyenda'=>'C',
            'title'=>'Compilar',
            'proceso'=>'compilar_consistencia',
            'campos_parametros'=>array('tra_ope'=>null, 'tra_con'=>null, 'tra_mas_info'=>true),
            'y_luego'=>'compilar'
        );
    }
    function puede_insertar(){
        return tiene_rol('programador') || tiene_rol('procesamiento') || tiene_rol('tematica');
    }
    function puede_eliminar(){
        return tiene_rol('programador') || tiene_rol('procesamiento');
    }
    function cantidadColumnasFijas(){
        return 1;
    }
}
?>