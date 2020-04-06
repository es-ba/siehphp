<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";

class Proceso_correr_consistencias extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Correr consistencias',
            'submenu'=>'consistencias',
            'permisos'=>array('grupo'=>'procesamiento', 'grupo1'=>'ana_sectorial'),
            'para_produccion'=>true,
            'parametros'=>array(
                // 'tra_bol'=>array('label'=>'Bolsa'),
                'tra_ope'=>array('label'=>'operativo','invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_enc'=>array('label'=>'encuesta','def'=>'#todo'),
                'tra_con'=>array('label'=>'consistencia','def'=>'#todo'),
             ),
            'boton'=>array('id'=>'boton_correr_consistencias','value'=>'correr consistencias >>'/*,'onclick'=>'boton_correr_consistencias();'*/),
            'bitacora'=>true,
        ));
    }
    function responder_campos_voy_por(){
        return array('con_con');
    }
    function responder_iniciar_estado(){
        $this->estado->errores="";
        $this->tabla_inconsistencias=$this->nuevo_objeto('Tabla_inconsistencias');                
        $filtro_de_borrado=$this->nuevo_objeto("Filtro_Normal",cambiar_prefijo($this->argumentos,'tra_','inc_'),$this->tabla_inconsistencias);
        Loguear('2014-05-21','************'.contenido_interno_a_string($filtro_de_borrado));
        $this->tabla_inconsistencias->ejecutar_delete_varios($filtro_de_borrado); // DUDA! ml
    }    
    function responder_iniciar_iteraciones(){
        $este=$this;
        $borrar = true;
        $mostrar_salida=true;
        $este->tabla_inconsistencias=$este->nuevo_objeto('Tabla_inconsistencias');                
        $este->tabla_consistencias=$este->nuevo_objeto('Tabla_consistencias');
        $filtro=array(
            'con_ope'=>$this->argumentos->tra_ope, 
            'con_con'=>$this->argumentos->tra_con?:'#todo', // 
            'con_activa'=>true,
            'con_valida'=>true,
        );
        $this->filtro_con=$this->nuevo_objeto("Filtro_Normal",$filtro,$this->tabla_consistencias);
        if(isset($this->voy_por)){
            $this->filtro_con=new Filtro_AND(array($this->filtro_con,new Filtro_Voy_Por($this->voy_por)),$this->tabla_consistencias);
        }
        $this->tabla_consistencias->leer_varios($this->filtro_con);
        $este->con_var = $este->nuevo_objeto('Tabla_con_var');
    }
    function responder_hay_mas(){
        if($this->estado->errores){
            return false;
        }
        if($this->tabla_consistencias->obtener_leido()){
            Loguear('2012-12-04','********************* obtener leído: '.$this->tabla_consistencias->datos->con_con);
            $this->voy_por=(object)array('con_con'=>$this->tabla_consistencias->datos->con_con);
            return true;
        }
        return false;
    }
    function responder_un_paso(){
        Loguear('2012-12-04','********************* responder un paso: '.$this->tabla_consistencias->datos->con_con);
        $este=$this;
        $salida_sql="";
        $consulta_sql="";
        $filtro_este_paso=new Filtro_AND(
            array(
                cambiar_prefijo($this->argumentos,'tra_','inc_'),
                array('inc_con'=>$this->tabla_consistencias->datos->con_con)
            ),
            $este->tabla_inconsistencias
        );
        $este->tabla_inconsistencias->ejecutar_delete_varios($filtro_este_paso);
        $este->con_var->leer_varios(array(
            'convar_ope'=>$GLOBALS['NOMBRE_APP'],
            'convar_con'=>$este->tabla_consistencias->datos->con_con,
        ));
        $inc_variables="''";
        $agregar_variable=function($la_variable,$prefijo='pla_') use (&$inc_variables){
            $variable_prefijada = $prefijo.$la_variable;
            $inc_variables.="||'{$la_variable}='||coalesce({$variable_prefijada}::text,'')||', '";
        };
        while($este->con_var->obtener_leido()){
            $agregar_variable($este->con_var->datos->convar_var);
        }
        foreach(explode(' ',$this->tabla_consistencias->datos->con_variables_contexto) as $variable){
            if($variable){
                $agregar_variable($variable);
            }
        }
        foreach(expresion_regular_extraer_llamada_funciones($este->tabla_consistencias->datos->con_expresion_sql) as $llamada){
            $agregar_variable($llamada,'');
        }
        $texto_from= str_replace("\r\n",' ',$este->tabla_consistencias->datos->con_clausula_from);
        $texto_where=str_replace("\r\n",' ',$este->tabla_consistencias->datos->con_expresion_sql);
        $nombre_consistencias=$este->tabla_consistencias->datos->con_con;
        $parametros_para_consistir=array(':con_con'=>$este->tabla_consistencias->datos->con_con);
        // ojo si viene otra cosa dentro de $filtro_para_consistir hay que tocar esto. 
        $campos_destino="";
        $campos_a_insertar="";
        $este->tabla_con_momentos=$este->nuevo_objeto("Tabla_con_momentos");
        $este->tabla_con_momentos->leer_uno_si_hay(array('conmom_conmom'=>$este->tabla_consistencias->datos->con_momento));
        if($este->tabla_con_momentos->obtener_leido()){
            $inc_nivel=$este->tabla_con_momentos->datos->conmom_nivel;
        }else{
            $inc_nivel=$este->tabla_con_momentos->obtener_maximo(array(), 'conmom_nivel');
        }
        foreach(json_decode($este->tabla_consistencias->datos->con_junta) as $campo_sin_prefijo=>$campo_con_alias_de_la_junta){
            $campos_destino.="inc_{$campo_sin_prefijo}, ";
            if($campo_con_alias_de_la_junta){
                $campos_a_insertar.=$campo_con_alias_de_la_junta.', ';
            }elseif(substr($GLOBALS['NOMBRE_APP'],0,2)=='ut' && $campo_sin_prefijo=='exm' && strpos($texto_from,'diario_actividades_vw')){
                $campos_a_insertar.='nfila, ';
            }else{    
                $campos_a_insertar.='0, ';
            }
        }
        $returning=" returning inc_con||':'||inc_variables_y_valores as problema";
        $filtro_encuestas=$this->nuevo_objeto('Filtro_Normal',array('tem.pla_enc'=>$this->argumentos->tra_enc));
        
        $consulta_sql="insert into inconsistencias (inc_ope, {$campos_destino} inc_con, inc_variables_y_valores, inc_nivel, inc_tlg) ".
            "select '{$GLOBALS['NOMBRE_APP']}', {$campos_a_insertar} :con_con, ".$inc_variables.", ".$inc_nivel.", ".obtener_tiempo_logico($este).
            " from ".$texto_from. 
            " where ".$texto_where.$filtro_encuestas->and_where.
            $returning; 
        $este->db->beginTransaction();
        $cursor=$este->db->ejecutar_sql(new Sql($consulta_sql, array_merge($parametros_para_consistir,$filtro_encuestas->parametros)));
        if($returning){
            while($fila=$cursor->fetchObject()){
                $array_salida[]=$fila->problema;
            }
        }
        $este->db->commit();
    }
    function responder_finalizar(){
        /*
        if($this->argumentos->tra_con=='#todo' && $this->argumentos->tra_enc != '#todo'){
            $array_salida=controlar_omisiones_de_ingreso(array(
                'tra_ope'=>$this->argumentos->tra_ope,
                'tra_enc'=>$this->argumentos->tra_enc
            ), $this);
        }
        */
        if(is_numeric($this->argumentos->tra_enc)){
            $this->tabla_roles=$this->nuevo_objeto("Tabla_roles");
            $this->tabla_roles->leer_unico(array('rol_rol'=>rol_actual())); 
            $nivel_hasta=$this->tabla_roles->datos->rol_ver_con_hasta_nivel;
            $salida=new Armador_de_salida(true);
            $salida->enviar($this->argumentos->tra_ope);
            if($this->existe_variable_observacion('s1a1_obs', $this)){
                $vinconsistencias=$this->contar_inconsistencias_mecanismo_prueba($this->argumentos->tra_ope,
                                                               $this->argumentos->tra_con,
                                                               $this->argumentos->tra_enc);
                 
                if($vinconsistencias['total_en_s1']>0){
                    $salida->enviar('Cantidad de inconsistencias informadas en Observaciones del S1:'. $vinconsistencias['total_en_s1'],'', array('id'=>'id_tot_en_s1'));
                    if(count($vinconsistencias['solo_en_observaciones'])>0 || count($vinconsistencias['solo_en_inconsistencias'])>0 ){
                        foreach(array('solo_en_inconsistencias'=>'Inconsistencia detectadas y no informadas en observaciones: ',
                                      'solo_en_observaciones'  =>'Inconsistencias que no saltaron e informadas en observaciones del S1: ')
                                      as $para_comparar=>$mensaje){
                            if(count($vinconsistencias[$para_comparar])>0){
                                $salida->enviar($mensaje.implode(', ',$vinconsistencias[$para_comparar]),'mensaje_alerta');
                            }
                        }
                    }
                }
            }  
            $salida->enviar('','',array('id'=>'div_grilla_inc'));
            enviar_grilla($salida, 'inconsistencias_visibles', array(
                            'inc_ope'=>$this->argumentos->tra_ope,
                            'inc_enc'=>$this->argumentos->tra_enc,
                            'inc_nivel'=>"#<=$nivel_hasta",
                                ),'div_grilla_inc');
            return $salida->obtener_una_respuesta_HTML();
        }
        return new Respuesta_Positiva('Listo');
    }
    function existe_variable_observacion($pvar, $este){ 
       $tabla_variables=$este->nuevo_objeto("Tabla_variables");
        $tabla_variables->leer_uno_si_hay(array('var_ope'=>$GLOBALS['NOMBRE_APP'],'var_var'=>$pvar));
        return $tabla_variables->obtener_leido();  
    }        
    function contar_inconsistencias_mecanismo_prueba($p_ope,$p_con,$p_enc){
        $vinconsistencias=array(
            'total'=>0,
            'total_en_s1'=>0,
            'lista_en_s1'=>''
        );
        $encontradas=array(
            'en_inconsistencias'=>array(),
            'en_observaciones'=>array()
        );
        $filtro_para_inconsistencias=array('inc_ope'=>$p_ope,'inc_con'=>$p_con,'inc_enc'=>$p_enc); 
        $tabla_inconsistencias=$this->nuevo_objeto('Tabla_inconsistencias'); 
        $vinconsistencias['total']=$tabla_inconsistencias->contar_cuantos($filtro_para_inconsistencias);
        $tabla_inconsistencias->leer_varios($filtro_para_inconsistencias);
        while($tabla_inconsistencias->obtener_leido()){
            $encontradas['en_inconsistencias'][]=(is_numeric($p_enc))?$tabla_inconsistencias->datos->inc_con:$tabla_inconsistencias->datos->inc_enc;
        }        
        $campos_filtro_con_s1=cambiar_prefijo($filtro_para_inconsistencias,'inc_','con_');
        $campos_filtro_con_s1['pla_enc']=$campos_filtro_con_s1['con_enc'];
        unset($campos_filtro_con_s1['con_enc']);
        $this->filtro_con_s1=$this->nuevo_objeto("Filtro_Normal",$campos_filtro_con_s1);
        $que_cuenta=(is_numeric($p_enc))?'con_con':'pla_enc';
        $sql=<<<SQL
            select string_agg($que_cuenta::text, ' ' order by $que_cuenta) as lista_en_s1, count(*)::integer as total_en_s1
                from encu.plana_s1_,encu.consistencias
                where pla_hog=1 and 
                    comun.esta_palabra_en_texto_despues_de_salta(con_con,pla_s1a1_obs) is true and 
                    {$this->filtro_con_s1->where}
SQL;
        //var_dump($this->filtro->parametros, $this->filtro->where, $sql);
        //Loguear('2014-07-11','********************* expre: '.$sql.' where:'. $this->filtro->where);
        $cursor=$this->db->ejecutar_sql(new Sql($sql,
                                        $this->filtro_con_s1->parametros));
        if($que_encuentra=$cursor->fetchObject()){
            $vinconsistencias['total_en_s1']=$que_encuentra->total_en_s1;
            $vinconsistencias['lista_en_s1']=$que_encuentra->lista_en_s1;
            $encontradas['en_observaciones']=explode(' ',$que_encuentra->lista_en_s1);
        }
        $interseccion = array_intersect($encontradas['en_inconsistencias'], $encontradas['en_observaciones']);
        $diferencias=array(
            'en_inconsistencias'=>array(),
            'en_observaciones'=>array()
        );
        foreach($encontradas as $encontrada=>$array_encontrada){
            foreach($array_encontrada as $elemento) {
                if(!in_array($elemento, $interseccion)){
                    $diferencias[$encontrada][]=$elemento;
                }
            }
        }
        $vinconsistencias['solo_en_inconsistencias']=$diferencias['en_inconsistencias'];
        $vinconsistencias['solo_en_observaciones']=$diferencias['en_observaciones'];
        Loguear('2014-07-11','*********inconsistencias: '.$vinconsistencias);
        //var_dump($vinconsistencias);
        
        return $vinconsistencias;
    }   
}

?>