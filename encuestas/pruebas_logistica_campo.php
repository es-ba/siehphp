<?php
//UTF-8:SÍ
class Para_Pruebas_Procesos_con_TEM extends Pruebas{
    // GRANT CREATE ON DATABASE eah2013_desa_db TO tedede_php;
    var $ope_prueba;
    function __construct(){
        $this->ope_prueba=$GLOBALS['nombre_app'];
    }
    function pre_probar_para_clase(){
        global $esta_es_la_base_en_produccion;
        if($esta_es_la_base_en_produccion){
            throw new Exception_Tedede('No se pueden correr puebas de procesos en produccion');
        }
        $this->tabla_tem=$this->contexto->nuevo_objeto("Tabla_tem");
        $this->tabla_plana_tem=$this->contexto->nuevo_objeto("Tabla_plana_TEM_");
        $this->tabla_plana_s1=$this->contexto->nuevo_objeto("Tabla_plana_s1_");
        $this->tabla_plana_s1_p=$this->contexto->nuevo_objeto("Tabla_plana_s1_p");
        $this->tabla_plana_i1=$this->contexto->nuevo_objeto("Tabla_plana_i1_");
        $this->tabla_claves=$this->contexto->nuevo_objeto("Tabla_claves");
        $this->tabla_respuestas=$this->contexto->nuevo_objeto("Tabla_respuestas");
        $this->tabla_personal=$this->contexto->nuevo_objeto("Tabla_personal");
        $filtro_del=array('per_per'=>'#<=-1');
        $this->tabla_personal->ejecutar_delete_varios($filtro_del);
        $this->tabla_personal->valores_para_insert=array('per_ope'=>$this->ope_prueba, 'per_per'=>-1, 'per_rol'=>'encuestador');
        $this->tabla_personal->ejecutar_insercion();
        $this->tabla_personal->valores_para_insert=array('per_ope'=>$this->ope_prueba, 'per_per'=>-2, 'per_rol'=>'encuestador');
        $this->tabla_personal->ejecutar_insercion();
    }
    function cargar_tem($encuesta,$variables_y_valores=null,$otros_campos_tem=array()){
        $filtro_del=array('res_ope'=>$this->ope_prueba,'res_enc'=>$encuesta);
        $this->tabla_respuestas->ejecutar_delete_varios($filtro_del);
        $this->tabla_claves->ejecutar_delete_varios(cambiar_prefijo($filtro_del,'res_','cla_'));
        $this->tabla_plana_tem->ejecutar_delete_varios(array('pla_enc'=>$encuesta));
        $this->tabla_plana_s1->ejecutar_delete_varios(array('pla_enc'=>$encuesta));
        $this->tabla_plana_s1_p->ejecutar_delete_varios(array('pla_enc'=>$encuesta));
        $this->tabla_plana_i1->ejecutar_delete_varios(array('pla_enc'=>$encuesta));
        $this->tabla_tem->valores_para_insert=array('tem_enc'=>$encuesta);
        $this->tabla_tem->ejecutar_insercion_si_no_existe();
        if(count($otros_campos_tem)){
            $this->tabla_tem->valores_para_update=cambiar_prefijo($otros_campos_tem,'','tem_');
            $this->tabla_tem->ejecutar_update_unico(array('tem_enc'=>$encuesta));
        }
        $this->tabla_claves->valores_para_insert=array_merge(
            claves_respuesta_vacia('cla_'),
            cambiar_prefijo($this->tabla_tem->valores_para_insert,'tem_','cla_'),
            array('cla_ope'=>$this->ope_prueba,'cla_for'=>'TEM')
         );
        $this->tabla_claves->ejecutar_insercion_si_no_existe();
        if($variables_y_valores){
            $this->tabla_plana_tem->update_TEM($encuesta,$variables_y_valores);
        }else{
            $this->tabla_plana_tem->update_TEM($encuesta,array('asignable'=>3));
            $this->tabla_plana_tem->update_TEM($encuesta,array('asignable'=>null));
        }
    }
    function obtener_respuesta_positiva($nombre_proceso,$argumentos){
        $proceso=$this->contexto->nuevo_objeto('Proceso_'.$nombre_proceso);
        $proceso->argumentos=(object)$argumentos;
        $obtenido=$proceso->responder();
        $this->probador->verificar('Respuesta_Positiva',get_class($obtenido),$obtenido->obtener_mensaje());
        $this->mensaje_ultima_respuesta=$obtenido->obtener_mensaje();
        if(!is_string($this->mensaje_ultima_respuesta)){
            $this->mensaje_ultima_respuesta=json_encode($this->mensaje_ultima_respuesta);
        }
        return $obtenido;
    }
    function verificar_tem($encuesta,$variables_y_valores,$aclaracion_al_fallar=''){
        $this->tabla_plana_tem->leer_unico(array('pla_enc'=>$encuesta));
        $this->probador->verificar_arreglo_asociativo(cambiar_prefijo($variables_y_valores,'','pla_'),(array)$this->tabla_plana_tem->datos,false,$aclaracion_al_fallar);
    }
    function verificar_estado($encuesta,$estado_esperado){
        $this->tabla_plana_tem->leer_unico(array('pla_enc'=>$encuesta));
        $this->probador->verificar($estado_esperado,$this->tabla_plana_tem->datos->pla_estado);
    }
}

class No_Prueba_Proceso_cargar_dispositivo extends Para_Pruebas_Procesos_con_TEM{
    var $tem_tipico=array('dominio'=>3,'replica'=>1, 'comuna'=>1, 'up'=>-11, 'lote'=>2);
    function x_probar_liberar_encuestas(){
        $this->cargar_tem(1001,null,array('up'=>'-11'));
        $this->verificar_estado(1001,19);
        $this->obtener_respuesta_positiva(
            'liberacion_a_campo',array(
                'tra_ope'=>$this->ope_prueba,
                'tra_dominio'=>'#todo', 
                'tra_replica'=>'#todo', 
                'tra_comuna'=>'#todo', 
                'tra_up'=>'-11', 
                'tra_confirmar'=>true
            )
        );
        $this->verificar_estado(1001,20);
    }
    function x_probar_asignar_dos_encuestas_a_un_encuestador_por_primera_vez(){
        foreach(
            array(
                'DM'=>array('dispositivo'=>1, 'estado_esperado'=>22),
                'papel'=>array('dispositivo'=>2, 'estado_esperado'=>22)
            ) as $id_caso=>$caso
        ){
            $this->cargar_tem(1001,array('asignable'=>1),$this->tem_tipico);
            $this->cargar_tem(1002,array('asignable'=>1),$this->tem_tipico);
            $this->obtener_respuesta_positiva(
                'asignar_resto_lote_a_enc',
                array_merge(
                    cambiar_prefijo($this->tem_tipico,'','tra_'),
                    array(
                        'tra_cod_enc'=>-2, // usar el -2 solo acá para que no molesten otros casos
                        'tra_dispositivo_enc'=>$caso['dispositivo'],
                        'tra_asignacion_incremental'=>false
                    )
                )
            );
            $this->verificar_tem(1002,array('estado'=>$caso['estado_esperado'],'cod_enc'=>-2,'dispositivo_enc'=>$caso['dispositivo']),$this->mensaje_ultima_respuesta);
        }
    }
    function x_probar_cargar_dos_encuestas_a_un_encuestador_por_primera_vez(){
        global $hoy;
        foreach(
            array(
                'DM'   =>array('dispositivo'=>1, 'estado_esperado'=>23, 'proceso'=>'cargar_dispositivo'            ,'args'=>array('tra_cod_per'=>-1,'tra_rol'=>1)),
                'papel'=>array('dispositivo'=>2, 'estado_esperado'=>24, 'proceso'=>'confirmar_entrega_en_papel_enc','args'=>array('tra_cod_per'=>-1,))
            ) as $id_caso=>$caso
        ){
            $this->cargar_tem(1001,array('asignable'=>1,'cod_enc'=>-1,'dispositivo_enc'=>$caso['dispositivo']),$this->tem_tipico);
            $this->cargar_tem(1002,array('asignable'=>1,'cod_enc'=>-1,'dispositivo_enc'=>$caso['dispositivo']),$this->tem_tipico);
            $this->cargar_tem(1003,array('asignable'=>1,'cod_enc'=>-1,'dispositivo_enc'=>$caso['dispositivo'],'fecha_carga_enc'=>'2013-09-09','fecha_primcarga_enc'=>'2013-09-09','fecha_descarga_enc'=>'2013-09-10','con_dato_enc'=>1),$this->tem_tipico);
            $this->verificar_tem(1002,array('estado'=>22),'antes de cargar');
            $this->obtener_respuesta_positiva($caso['proceso'],$caso['args']);
            $formato='Y-m-d 00:00:00';
            $this->verificar_tem(1002,array('estado'=>$caso['estado_esperado'],'fecha_carga_enc'=>$hoy->format($formato),'fecha_primcarga_enc'=>$hoy->format($formato)),$this->mensaje_ultima_respuesta);
            $this->verificar_tem(1003,array('asignable'=>1,'cod_enc'=>-1,'dispositivo_enc'=>$caso['dispositivo'],'fecha_carga_enc'=>'2013-09-09 00:00:00','fecha_primcarga_enc'=>'2013-09-09 00:00:00'),$this->mensaje_ultima_respuesta);
        }
    }
    function x_probar_fin_descarga_enc(){
        //$this->probador->pendiente_ticket(1009);
        global $ahora;
        foreach(array(
            'vacia'=>array('estado_esperado'=>25),
            'NOREA'=>array(
                'estado_esperado'=>27,
                'uds_a_grabar'=>array(
                    array(  
                        'pk_ud'=>(object)array("tra_ope"=>"eah2013", "tra_for"=>"S1", "tra_mat"=>"", "tra_enc"=>1001, "tra_hog"=>1, "tra_mie"=>0, "tra_exm"=>0),
                        'rta_ud'=>array("var_entrea"=>2,"var_razon1"=>2,"var_razon2_2"=>2),
                        'estados_rta_ud'=>null
                    )
                ),
                'tem_sincronizada'=>array(
                    'rea_enc'=>0, 'norea_enc'=>22, 'rea'=>0, 'norea'=>22, 'rea_recu'=>null, 'norea_recu'=>null, 'rol'=>'encuestador', 'per'=>-1, 'con_dato_enc'=>1
                )
            ),
            'NOREA71oMayor'=>array(
                'estado_esperado'=>27,
                'uds_a_grabar'=>array(
                    array(  
                        'pk_ud'=>(object)array("tra_ope"=>"eah2013", "tra_for"=>"S1", "tra_mat"=>"", "tra_enc"=>1001, "tra_hog"=>1, "tra_mie"=>0, "tra_exm"=>0),
                        'rta_ud'=>array("var_entrea"=>2,"var_razon1"=>7,"var_razon2_7"=>1),
                        'estados_rta_ud'=>null
                    )
                ),
                'tem_sincronizada'=>array(
                    'rea_enc'=>0, 'norea_enc'=>71, 'rea'=>0, 'norea'=>71, 'rea_recu'=>null, 'norea_recu'=>null, 'rol'=>'encuestador', 'per'=>-1, 'con_dato_enc'=>1
                )
            ),
            'REA'=>array(
                'estado_esperado'=>27,
                'uds_a_grabar'=>array(
                    array(  
                        'pk_ud'=>(object)array("tra_ope"=>"eah2013", "tra_for"=>"S1", "tra_mat"=>"", "tra_enc"=>1001, "tra_hog"=>1, "tra_mie"=>0, "tra_exm"=>0),
                        'rta_ud'=>array("var_entrea"=>1,"var_total_h"=>1,"var_total_m"=>2,"var_v1"=>1),
                        'estados_rta_ud'=>null
                    ),
                    array(  
                        'pk_ud'=>(object)array("tra_ope"=>"eah2013", "tra_for"=>"S1", "tra_mat"=>"P", "tra_enc"=>1001, "tra_hog"=>1, "tra_mie"=>1, "tra_exm"=>0),
                        'rta_ud'=>array("var_edad"=>21),
                        'estados_rta_ud'=>null
                    ),
                    array(  
                        'pk_ud'=>(object)array("tra_ope"=>"eah2013", "tra_for"=>"S1", "tra_mat"=>"P", "tra_enc"=>1001, "tra_hog"=>1, "tra_mie"=>2, "tra_exm"=>0),
                        'rta_ud'=>array("var_edad"=>21),
                        'estados_rta_ud'=>null
                    ),
                    array(  
                        'pk_ud'=>(object)array("tra_ope"=>"eah2013", "tra_for"=>"S1", "tra_mat"=>"P", "tra_enc"=>1001, "tra_hog"=>1, "tra_mie"=>3, "tra_exm"=>0),
                        'rta_ud'=>array("var_edad"=>21, "var_p7"=>3),
                        'estados_rta_ud'=>null
                    ),
                    array(  
                        'pk_ud'=>(object)array("tra_ope"=>"eah2013", "tra_for"=>"S1", "tra_mat"=>"P", "tra_enc"=>1001, "tra_hog"=>1, "tra_mie"=>3, "tra_exm"=>0),
                        'rta_ud'=>array("var_edad"=>21),
                        'estados_rta_ud'=>null
                    ),
                    array(  
                        'pk_ud'=>(object)array("tra_ope"=>"eah2013", "tra_for"=>"S1", "tra_mat"=>"P", "tra_enc"=>1001, "tra_hog"=>1, "tra_mie"=>4, "tra_exm"=>0),
                        'rta_ud'=>array("var_edad"=>null, "var_nombre"=>"Susana"),
                        'estados_rta_ud'=>null
                    ),
                    array(  
                        'pk_ud'=>(object)array("tra_ope"=>"eah2013", "tra_for"=>"S1", "tra_mat"=>"P", "tra_enc"=>1001, "tra_hog"=>1, "tra_mie"=>6, "tra_exm"=>0),
                        'rta_ud'=>array("var_edad"=>"--", "var_nombre"=>"--"),
                        'estados_rta_ud'=>null
                    ),
                    array(  
                        'pk_ud'=>(object)array("tra_ope"=>"eah2013", "tra_for"=>"I1", "tra_mat"=>"", "tra_enc"=>1001, "tra_hog"=>1, "tra_mie"=>1, "tra_exm"=>0),
                        'rta_ud'=>array("var_t1"=>1),
                        'estados_rta_ud'=>null
                    ),
                    array(  
                        'pk_ud'=>(object)array("tra_ope"=>"eah2013", "tra_for"=>"I1", "tra_mat"=>"", "tra_enc"=>1001, "tra_hog"=>1, "tra_mie"=>2, "tra_exm"=>0),
                        'rta_ud'=>array("var_t1"=>1),
                        'estados_rta_ud'=>null
                    )
                ),
                'tem_sincronizada'=>array(
                    'rea_enc'=>1, 'norea_enc'=>null, 'rea'=>1, 'norea'=>null, 'rea_recu'=>null, 'norea_recu'=>null, 'rol'=>'encuestador', 'per'=>-1, 'con_dato_enc'=>1, 'hog_tot'=>1, 'hog_pre'=>1, 'pob_tot'=>3, 'pob_pre'=>2, 
                )
            ),
            'REA+NOREA'=>array(
                'estado_esperado'=>27,
                'uds_a_grabar'=>array(
                    array(  
                        'pk_ud'=>(object)array("tra_ope"=>"eah2013", "tra_for"=>"S1", "tra_mat"=>"", "tra_enc"=>1001, "tra_hog"=>2, "tra_mie"=>0, "tra_exm"=>0),
                        'rta_ud'=>array("var_entrea"=>2,"var_razon1"=>2,"var_razon2_2"=>2),
                        'estados_rta_ud'=>null
                    ),
                    array(  
                        'pk_ud'=>(object)array("tra_ope"=>"eah2013", "tra_for"=>"S1", "tra_mat"=>"", "tra_enc"=>1001, "tra_hog"=>1, "tra_mie"=>0, "tra_exm"=>0),
                        'rta_ud'=>array("var_entrea"=>1,"var_v1"=>2),
                        'estados_rta_ud'=>null
                    )
                ),
                'tem_sincronizada'=>array(
                    'rea_enc'=>0, 'norea_enc'=>10, 'rea'=>0, 'norea'=>10, 'rea_recu'=>null, 'norea_recu'=>null, 'rol'=>'encuestador', 'per'=>-1, 'con_dato_enc'=>1
                )
            ),
            'REA+REA'=>array(
                'estado_esperado'=>27,
                'uds_a_grabar'=>array(
                    array(  
                        'pk_ud'=>(object)array("tra_ope"=>"eah2013", "tra_for"=>"S1", "tra_mat"=>"", "tra_enc"=>1001, "tra_hog"=>2, "tra_mie"=>0, "tra_exm"=>0),
                        'rta_ud'=>array("var_entrea"=>1,"var_v1"=>2,"var_total_h"=>2),
                        'estados_rta_ud'=>null
                    ),
                    array(  
                        'pk_ud'=>(object)array("tra_ope"=>"eah2013", "tra_for"=>"S1", "tra_mat"=>"", "tra_enc"=>1001, "tra_hog"=>1, "tra_mie"=>0, "tra_exm"=>0),
                        'rta_ud'=>array("var_entrea"=>1,"var_v1"=>2),
                        'estados_rta_ud'=>null
                    )
                ),
                'tem_sincronizada'=>array(
                    'rea_enc'=>1, 'rea'=>1, 'rea_recu'=>null, 'norea_recu'=>null, 'rol'=>'encuestador', 'per'=>-1, 'con_dato_enc'=>1, 'hog_tot'=>2, 'hog_pre'=>2, 
                )
            ),
        ) as $id_caso=>$caso){
            $this->cargar_tem(1001,array('asignable'=>1,'cod_enc'=>-1,'dispositivo_enc'=>1,'fecha_carga_enc'=>'2013-09-01'),$this->tem_tipico);
            $this->verificar_tem(1001,array('estado'=>23),'antes de descargar');
            if(isset($caso['uds_a_grabar'])){
                $this->obtener_respuesta_positiva('grabar_fecha_comenzo_descarga',array('tra_ope'=>'eah2013','tra_enc'=>1001));
                foreach($caso['uds_a_grabar'] as $ud){
                    $this->obtener_respuesta_positiva('grabar_ud',$ud);
                }
            }
            $this->obtener_respuesta_positiva('fin_descargar_dispositivo_enc',array('tra_cod_enc'=>-1,'tra_enc'=>1001,'tra_visitas'=>array()));
            $this->contexto->db->log_hasta='2013-09-19';
            $this->contexto->db->log_hasta='2013-09-07';
            $formato='Y-m-d 00:00:00';
            $this->verificar_tem(1001,array('estado'=>$caso['estado_esperado'],'fecha_descarga_enc'=>$ahora->format('Y-m-d H:i:s')),$this->mensaje_ultima_respuesta);
            if(isset($caso['tem_sincronizada'])){
                $this->verificar_tem(1001,$caso['tem_sincronizada'],"en caso {$id_caso}");
            }
        }
    }
    function x_probar_mandar_a_ingreso_enc(){
        global $hoy;
        foreach(
            array(
                'DM vacio'=>array('dispositivo'=>1, 'estado_ini'=>25,'fecha_descarga_enc'=>'2013-09-13','con_dato_enc'=>0),
                'DM lleno'=>array('dispositivo'=>1, 'estado_ini'=>27,'fecha_descarga_enc'=>'2013-09-13','con_dato_enc'=>1),
                'papel'   =>array('dispositivo'=>2, 'estado_ini'=>24,'fecha_descarga_enc'=>null        ,'con_dato_enc'=>null)
            ) as $id_caso=>$caso
        ){
            $this->cargar_tem(1002,array('asignable'=>1,'cod_enc'=>-1,'dispositivo_enc'=>$caso['dispositivo'],'fecha_carga_enc'=>'2013-09-13','fecha_descarga_enc'=>$caso['fecha_descarga_enc'],'con_dato_enc'=>$caso['con_dato_enc']),$this->tem_tipico);
            $this->verificar_tem(1002,array('estado'=>$caso['estado_ini']),"en caso {$id_caso}");
            /*
            try{
                $this->tabla_plana_tem->update_TEM(1002,array('a_ingreso_enc'=>9));
                $this->probador->verificar("DEBIÓ FALLAR CON a_ingreso_enc INVÁLIDO","y no falló");
            }catch(Exception $err){
            }
            */
            $this->tabla_plana_tem->update_TEM(1002,array('a_ingreso_enc'=>1));
            if($id_caso=='DM lleno'){
                $this->verificar_tem(1002,array('con_dato_enc'=>2),"en caso {$id_caso}");
            }
            $this->verificar_tem(1002,array('estado'=>26),"en caso {$id_caso}");
            $this->tabla_plana_tem->update_TEM(1002,array('fin_ingreso_enc'=>1));
            $this->verificar_tem(1002,array('estado'=>27),"en caso {$id_caso}");
        }
    }
    function x_probar_volver_a_cargar_enc(){
        global $hoy;
        foreach(
            array(
                'con dato'=>array('con_dato'=>1, 'estado_ini'=>27),
                'sin dato'=>array('con_dato'=>0, 'estado_ini'=>25)
            ) as $id_caso=>$caso
        ){
            $this->cargar_tem(1002,array('asignable'=>1,'cod_enc'=>-1,'dispositivo_enc'=>1,'fecha_carga_enc'=>'2013-09-13','fecha_descarga_enc'=>'2013-09-13','con_dato_enc'=>$caso['con_dato']),$this->tem_tipico);
            $this->verificar_tem(1002,array('estado'=>$caso['estado_ini']),"en caso {$id_caso}");
            $this->tabla_plana_tem->update_TEM(1002,array('volver_a_cargar_enc'=>1));
            $this->verificar_tem(1002,array('estado'=>22,'fecha_carga_enc'=>null,'fecha_descarga_enc'=>null,'con_dato_enc'=>null),"en caso {$id_caso}");
            $this->tabla_plana_tem->update_TEM(1002,array('fecha_carga_enc'=>$hoy->format('Y-m-d')));
            $this->verificar_tem(1002,array('estado'=>23,'fecha_descarga_enc'=>null,'con_dato_enc'=>null,'volver_a_cargar_enc'=>null),"en caso {$id_caso}");
            $this->tabla_plana_tem->update_TEM(1002,array('fecha_descarga_enc'=>$hoy->format('Y-m-d')));
            $this->tabla_plana_tem->update_TEM(1002,array('con_dato_enc'=>0));
            $this->verificar_tem(1002,array('estado'=>25,'con_dato_enc'=>0),"en caso {$id_caso}");
        }
    }
    function x_probar_volver_a_cargar_recu(){
        global $hoy;
        foreach(
            array(
                'con dato'=>array('con_dato'=>1, 'estado_ini'=>37),
                'sin dato'=>array('con_dato'=>0, 'estado_ini'=>35)
            ) as $id_caso=>$caso
        ){
            $this->cargar_tem(1002,array('asignable'=>1,'cod_recu'=>-1,'dispositivo_recu'=>1,'fecha_carga_recu'=>'2013-09-13','fecha_descarga_recu'=>'2013-09-13','con_dato_recu'=>$caso['con_dato']),$this->tem_tipico);
            $this->verificar_tem(1002,array('estado'=>$caso['estado_ini']),"en caso {$id_caso}");
            $this->tabla_plana_tem->update_TEM(1002,array('volver_a_cargar_recu'=>1));
            $this->verificar_tem(1002,array('estado'=>32,'fecha_carga_recu'=>null,'fecha_descarga_recu'=>null,'con_dato_recu'=>null,'a_ingreso_recu'=>null),"en caso {$id_caso}");
            $this->tabla_plana_tem->update_TEM(1002,array('fecha_carga_recu'=>$hoy->format('Y-m-d')));
            $this->verificar_tem(1002,array('estado'=>33,'fecha_descarga_recu'=>null,'con_dato_recu'=>null,'volver_a_cargar_recu'=>null, 'a_ingreso_recu'=>null),"en caso {$id_caso}");
            $this->tabla_plana_tem->update_TEM(1002,array('fecha_comenzo_descarga'=>$hoy->format('Y-m-d')));
            $this->tabla_plana_tem->update_TEM(1002,array('fecha_descarga_recu'=>$hoy->format('Y-m-d')));
            $this->tabla_plana_tem->update_TEM(1002,array('con_dato_recu'=>$caso['con_dato']));
            $this->tabla_plana_tem->update_TEM(1002,array('fecha_comenzo_descarga'=>null));
            $this->verificar_tem(1002,array('estado'=>$caso['estado_ini'],'con_dato_recu'=>$caso['con_dato'],'volver_a_cargar_recu'=>null),"en caso {$id_caso}");
        }
    }
    function x_probar_tem_desde_archivo(){
        global $hoy;
        //$this->probador->pendiente_ticket(0);  // para que no de error
        $contenido=file_get_contents('..\..\pruebas_automaticas\campo\casos_TEM.txt');
        $numero_linea=0;
        $this->tabla_plana_tem=$this->contexto->nuevo_objeto("Tabla_plana_TEM_");
        $this->tabla_tem=$this->contexto->nuevo_objeto("Tabla_TEM");
        foreach(explode("\n",$contenido) as $linea){
            $numero_linea++;
            $columnas=explode("|",$linea);
            if($numero_linea==1){
                $nombres_columnas=$columnas;
            }elseif(count($columnas)>0){
                if($columnas[0]){
                    $nombre_caso=$columnas[0];
                }elseif(count($columnas)>2){
                    $accion=$columnas[1];
                    $encuesta=$columnas[2];
                    $mapa_variables=array();
                    $mapa_variables_sin_fecha=array();
                    $mapa_tem=array();
                    $mapa_parametros=array();
                    $ya_vi_tra=false;
                    for($i=3; $i<count($columnas)-1; $i++){
                        $valor=$columnas[$i];
                        switch($valor){
                        case 'hoy':
                            $valor=$hoy->format('Y-m-d H:i:s');
                        break;
                        case 'null':
                            $valor=null;
                        break;
                        default:
                        }
                        $nombre_columna=$nombres_columnas[$i];
                        if($valor!==''){
                            if($this->tabla_plana_tem->existe_campo(cambiar_prefijo($nombre_columna,'','pla_'))){
                                $definicion_campo=$this->tabla_plana_tem->definicion_campo(cambiar_prefijo($nombre_columna,'','pla_'));
                                if($definicion_campo['tipo']=='entero' && $valor!==null){
                                    $valor=intval($valor);
                                }
                                $es_fecha=$definicion_campo['tipo']=='fecha' || $definicion_campo['tipo']=='timestamp';
                            }
                            if(empieza_con($nombre_columna,'tra_')){
                                $mapa_parametros[$nombre_columna]=$valor;
                            }elseif($this->tabla_tem->existe_campo(cambiar_prefijo($nombre_columna,'','tem_'))){
                                $mapa_tem[$nombre_columna]=$valor;
                            }else{ 
                                $mapa_variables[$nombre_columna]=$valor;
                                if(!$es_fecha){
                                    $mapa_variables_sin_fecha[$nombre_columna]=$valor;
                                }
                            }     
                        }
                    }
                    if($accion){
                        switch($accion){
                        case "dado":
                            Loguear('2013-10-01',"dado: ".implode("*",$columnas));
                            //$cantidad=count($mapa_variables);
                            //echo 'Cantidad de casos '.$cantidad;
                            $this->cargar_tem($encuesta,$mapa_variables,$mapa_tem); //para el resto
                            $this->verificar_tem($encuesta,$mapa_variables_sin_fecha,"Excel [{$numero_linea}] caso {$nombre_caso}");
                        break;
                        case "ver":
                            Loguear('2013-10-01',"ver: ".implode("*",$columnas));
                            $this->verificar_tem($encuesta,$mapa_variables,"Excel [{$numero_linea}] caso {$nombre_caso}");
                        break;
                        case "poner":
                            Loguear('2013-10-01',"poner: ".contenido_interno_a_string($mapa_variables));
                            $this->tabla_plana_tem->update_TEM($encuesta,$mapa_variables);
                        break;
                        default:
                            $nombre_proceso=$accion;
                            $mapa_con_todo=array_merge(cambiar_prefijo($mapa_tem,'','tra_'), $mapa_parametros, cambiar_prefijo($mapa_variables,'','tra_'));
                            $this->obtener_respuesta_positiva($nombre_proceso, $mapa_con_todo);
                            Loguear('2013-10-01',"proceso[{$nombre_proceso}]: ".json_encode($mapa_con_todo));
                        }
                    }
                }
            }
        }
    }
    function x_probar_deshacer_carga(){
        $this->probador->pendiente_ticket(0);
        $cargado_encuestador=array('per_a_cargar'=>null, 'per'=>101, 'dispositivo'=>1, 'rol'=>1, 'estado_carga'=>1, 'verificado'=>null);
        $this->cargar_tem(1002,$cargado_encuestador);
        $this->cargar_tem(1003,$cargado_encuestador);
        // $this->obtener_respuesta_positiva('deshacer_cargar_dispositivo',array('tra_per'=>101,'tra_enc'=>1002));
        // $this->verificar_tem(1002,array_merge($cargado_encuestador,array('estado_carga'=>2, 'per_a_cargar'=>101)));
    }
}

?>