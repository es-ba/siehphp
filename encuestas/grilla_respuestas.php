<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";


function planas_reconocer_valores_especiales($valor_ingresado,$tipovar){
    $valores_especiales_planas=array('-1'=>array('valor'=>null,'valesp'=>'..','valor_con_error'=>null),
    '-9'=>array('valor'=>null,'valesp'=>'//','valor_con_error'=>null),
    '-5'=>array('valor'=>null,'valesp'=>null,'valor_con_error'=>'#!null'));

    $reconocidos=(object)array();
    if($valor_ingresado===NSNC || $valor_ingresado===RELEVAMIENTO_OMITIDO){
        $reconocidos->valesp=$valor_ingresado;
        $reconocidos->valor=NULL;
        $reconocidos->valor_con_error=NULL;
    }else{
        $reconocidos->valesp=NULL;
        $reconocidos->valor=$valor_ingresado;
        $reconocidos->valor_con_error=NULL;
    }
    if (array_key_exists($valor_ingresado, $valores_especiales_planas)){
        $reconocidos->valesp         =$valores_especiales_planas[$valor_ingresado]['valesp'];
        $reconocidos->valor          =$valores_especiales_planas[$valor_ingresado]['valor'];
        $reconocidos->valor_con_error=$valores_especiales_planas[$valor_ingresado]['valor_con_error'];        
    }
    return $reconocidos;
}

    
class Grilla_respuestas extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="tabla_plana_".$nombre_del_objeto_base;
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_plana_".$nombre_del_objeto_base);
        list($this->tra_for,$this->tra_mat)=explode('_',$nombre_del_objeto_base);
        /*
        $this->tabla->iniciar($this->tra_for,$this->tra_mat);
        */
    }
    function filtrar_campos_del_operativo($p_arraycampos){
            loguear('2014-12-11','**** entrada '.implode($p_arraycampos,','));
            $p_arraycamposope=array();
            $vista_varmae=$this->contexto->nuevo_objeto("Vista_varmae");     
            foreach($p_arraycampos as $campo){
                if (substr($campo,0,4)==='pla_'){
                    $vista_varmae->leer_uno_si_hay(array('varmae_ope'=>$GLOBALS['NOMBRE_APP'], 'varmae_var'=>substr($campo,4 )));
                    if ($vista_varmae->obtener_leido()){
                        $p_arraycamposope[]=$campo;
                    }
                }else{
                    $p_arraycamposope[]=$campo;
                }
            }
            loguear('2014-12-11','****  salida'.implode($p_arraycamposope,','));
            return $p_arraycamposope;
    }
    function campos_solo_lectura(){
        $rta=array();
        foreach($this->tabla_o_vista->obtener_nombres_campos_pk() as $nombre_campo){
            $rta[]=$nombre_campo;
        }
        return $rta;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function obtener_otros_atributos_y_completar_fila(&$fila,&$atributos_fila){
        /*
        $tabla_respuestas=$this->tabla_o_vista->definicion_tabla('respuestas');
        $tabla_respuestas->leer_varios(
            $this->tabla_o_vista->armar_clave_para('res_', $GLOBALS['NOMBRE_APP'], $this->tra_for, $this->tra_mat)
        );
        $campos_a_listar=$this->campos_a_listar(array());
        while($tabla_respuestas->obtener_leido() && $this->debe_listar_campo('pla_'.$tabla_respuestas->datos->res_var,array())){
            $atributos_campo=array('clase'=>$tabla_respuestas->datos->res_estado);
            if($tabla_respuestas->datos->res_anotaciones_marginales){
                $atributos_campo['title']=$tabla_respuestas->datos->res_anotaciones_marginales;
            }
            if($fila['pla_'.$tabla_respuestas->datos->res_var]==-5){
                $fila['pla_'.$tabla_respuestas->datos->res_var]=$tabla_respuestas->datos->res_valor_con_error;
            }
            $atributos_fila['pla_'.$tabla_respuestas->datos->res_var]=$atributos_campo;
        }
        */
    }
    function responder_grabar_campo(){
        //Loguear('2018-02-23','-----por grabar campo de respuestas '.var_export($this->argumentos,true));
        if(!Puede('grabar en',$this->nombre_grilla)){
            return new Respuesta_Negativa("No tiene permisos para modificar la tabla $nombre_grilla");
        }else{
            $this->tabla_respuestas=$this->tabla->definicion_tabla('respuestas');
            $this->tabla_variables=$this->tabla->definicion_tabla('respuestas');
            $var_var=quitar_prefijo($this->argumentos->campo,'pla_');
            // $this->tabla_variables->leer_pk(array($this->argumentos->pk[0],$var_var));
            $campo=$this->argumentos->campo;
            $this->tabla_respuestas->valores_para_update=array();
            $actuales=planas_reconocer_valores_especiales($this->argumentos->nuevo_valor  ,null/*,$this->tabla_variables->var_tipovar*/);
            $anteriores=planas_reconocer_valores_especiales($this->argumentos->viejo_valor,null/*,$this->tabla_variables->var_tipovar*/);
            $this->tabla_respuestas->valores_para_update['res_valor']=$actuales->valor;
            $this->tabla_respuestas->valores_para_update['res_valesp']=$actuales->valesp;
            $this->tabla_respuestas->valores_para_update['res_valor_con_error']=$actuales->valor_con_error;
            $filtro_update=array();
            $i=0;
            foreach($this->tabla->obtener_nombres_campos_pk() as $nombre_campo_pk){
                $filtro_update[cambiar_prefijo($nombre_campo_pk,'pla_','res_')]=$this->argumentos->pk[$i];
                $i++;
            }
            $filtro_linea=cambiar_prefijo($filtro_update,'res_','pla_');
            $filtro_update['res_ope']=$GLOBALS['NOMBRE_APP'];
            $filtro_update['res_for']=$this->tra_for;
            $filtro_update['res_mat']=$this->tra_mat;
            $filtro_colorear=cambiar_prefijo($filtro_update,'res_','tra_');
            $filtro_update['res_var']=$var_var;
            $filtro_solo_pk=$filtro_update;
            $filtro_update['res_valor']=$anteriores->valor;
            $filtro_update['res_valesp']=$anteriores->valesp;
            $filtro_update['res_valor_con_error']=$anteriores->valor_con_error;
            $this->contexto->db->beginTransaction();
            $this->tabla_respuestas->ejecutar_update_unico($filtro_update,false);
            if($this->tabla_respuestas->resultado->rowCount()==0){
                unset($filtro_update['res_valor']);
                $filtro_update['res_valor_con_error']=$anteriores->valor;
                $this->tabla_respuestas->ejecutar_update_unico($filtro_update,false);
                if($this->tabla_respuestas->resultado->rowCount()==0 && $anteriores->valor==-5){
                    $filtro_update['res_valor_con_error']='#!null';
                    $filtro_update['res_valor']='#null';
                    $this->tabla_respuestas->ejecutar_update_unico($filtro_update,false);
                }
            }
            if($this->tabla_respuestas->resultado->rowCount()==1){
                $valor_grabado=$this->tabla_respuestas->valor_ingresado();
                $nueva_pk=json_encode($this->argumentos->pk);
                $this->contexto->db->commit();
                $proceso_colorear_respuestas=$this->contexto->nuevo_objeto("Proceso_colorear_respuestas");
                $proceso_colorear_respuestas->argumentos=(object)$filtro_colorear;
                $proceso_colorear_respuestas->argumentos->tra_grabando=true;
                //$proceso_colorear_respuestas->validar_argumentos();
                if ($proceso_colorear_respuestas->argumentos->tra_for=='TEM' ) {
                   $proceso_colorear_respuestas->responder();
                }
                $rta=$this->obtener_datos($filtro_linea); // pisa id_registro y $rta;
                $rta['pk']=$nueva_pk;
                $rta['valor_grabado']=$valor_grabado;
                return new Respuesta_Positiva($rta);
            }else if($this->tabla_respuestas->resultado->rowCount()==0){
                $this->contexto->db->rollBack();
                $this->tabla_respuestas->leer_varios($filtro_solo_pk);
                if($this->tabla_respuestas->obtener_leido()){
                    return new Respuesta_Negativa("No se pudo modificar el registro, quizas un usuario lo modifico antes. Valor actual=".$this->tabla_respuestas->valor_ingresado().". Refresque la pantalla");
                }else{
                    return new Respuesta_Negativa("el registro ya no esta en la base de datos quizas otro usuario lo modifico ".json_encode($filtro_solo_pk)." en ".$this->tabla_respuestas->obtener_nombre_de_tabla());
                }
            }else if($this->tabla_respuestas->resultado->rowCount()>1){
                $this->contexto->db->rollBack();
                return new Respuesta_Negativa("Error, se han intentado modificar multiples registros (".$this->tabla_respuestas->resultado->rowCount().") cuando debió ser uno. grabando {$this->argumentos->nuevo_valor} en {$this->nombre_grilla}");
            }
            return new Respuesta_Negativa("Error interno al leer respuestas (".$this->tabla_respuestas->resultado->rowCount().") cuando debió ser uno. grabando {$this->argumentos->nuevo_valor} en {$this->nombre_grilla}");
        }
    }
}
?>