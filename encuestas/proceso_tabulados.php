<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";
//
//$es_ope_eah_con_modo=substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']>=2015?true:false; 

function letra_zonal_de($campo){
    if($campo =='zona_3'|| $campo =='zona_3_1'){
        return 'Z';
    }
    if($campo =='comuna'){
        return 'C';
    }
    return 'T';
}

function campo_zonal_de($campo){
    if(letra_zonal_de($campo)=='T'){
        return '0';
    }else{
        return 'pla_'.$campo;
    }
}

function letra_y_campo_zonal($tab_fila1, $tab_fila2){ 
    if ($tab_fila1 =='comuna' || $tab_fila1 =='zona_3'|| $tab_fila1 =='zona_3_1' || 
        $tab_fila2 =='comuna' || $tab_fila2 =='zona_3'|| $tab_fila2 =='zona_3_1'){
        if($tab_fila1 =='comuna' || $tab_fila2 =='comuna'){
            $var_grzona='C';
        }
        if($tab_fila1 =='zona_3'|| $tab_fila1 =='zona_3_1' ||  $tab_fila2 =='zona_3'|| $tab_fila2 =='zona_3_1'){
            $var_grzona='Z';
        }
        if($tab_fila1 =='comuna' || $tab_fila1 =='zona_3'|| $tab_fila1 =='zona_3_1'){
            $var_tabfila=$tab_fila1;
        }else{
            $var_tabfila=$tab_fila2;                
        } 
    }else{
        $var_grzona=letra_zonal_de($tab_fila2); // tab_fila1 y tab_fila2 ninguna es comuna ó zona_3 ó zona_3_1
        $var_tabfila=campo_zonal_de($tab_fila2); 
    }
    return array($var_grzona,$var_tabfila);
}
function cv_pasar_a_letras($formulaCV){
    return "case when {$formulaCV}>30 then 'c' when {$formulaCV}>20 then 'b' when {$formulaCV}>10 then 'a' else '' end ";
}    
class Proceso_tabulados extends Proceso_Formulario{

    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        global $esta_es_la_base_en_produccion;
    //    global $es_ope_eah_con_modo;
    //    $es_ope_eah_con_modo=substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'?true:false; NO LA TOMA en la funcion responder  DEFINIENDOLA ACA COMO GLOBAL
        global $es_ope_eah_con_modo;
        $tabla_tabulados=$this->nuevo_objeto("Tabla_tabulados");
        $tabla_tabulados->leer_varios(array());
        $primer_tabulado=$tabla_tabulados->obtener_leido()?$tabla_tabulados->datos->tab_tab:'';
        if(!$esta_es_la_base_en_produccion){
            $primer_tabulado='CUADRO 1z';
        }
        $hay_factor=false;
        /*
        $tabla_plana_tem=$this->nuevo_objeto("Tabla_plana_TEM_");
        $tabla_plana_tem->leer_varios(array()); 
        while($tabla_plana_tem->obtener_leido() && !$hay_factor){
            if($tabla_plana_tem->datos->pla_fexp <> null){
                $hay_factor=true;
            }
        }
        */
        //Función para generalizar si hay_factor pero no funciono consultar
        $existe_factor=function(&$vhay_factor,$tabla_nombre, $tabla_campo,$filtro, $esto){
            $tabla_dato=$esto->nuevo_objeto("Tabla_{$tabla_nombre}");
            $tabla_dato->leer_varios($filtro); 
            while($tabla_dato->obtener_leido()&&!$vhay_factor){
                if($tabla_dato->datos->$tabla_campo <> null){
                    $vhay_factor=true;
                }
            } 
        };
        $vtitulo_modo='';
        $val_modo='';
        if(substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']>=2015){
            $val_modo= ($_SESSION['modo_encuesta']=='ETOI')?$_SESSION['modo_encuesta']:$GLOBALS['NOMBRE_APP'];
            $existe_factor($hay_factor,'pla_ext_hog', 'pla_fexp',array('pla_modo'=>$val_modo), $this);  //modo_encuesta
            $vtitulo_modo=' - Modo '. $_SESSION['modo_encuesta'];
        }elseif( $GLOBALS['NOMBRE_APP']=='vcm2018'){
            $existe_factor($hay_factor,'plana_s1_', 'pla_fexpind',array(), $this);
        }
        else{
            $existe_factor($hay_factor,'plana_tem_', 'pla_fexp',array(), $this);  //modo_encuesta
        }; 
        //*/
        $hay_findividual=false;
        $opci_findividual=array();
        //if($GLOBALS['NOMBRE_APP']=='same2014'){
        if(preg_match("/^(same2014|ut2016|vcm2018)$/", $GLOBALS['NOMBRE_APP'])==1){
            // para ut2016 asumo que si hay pla_fexpind, tambien estan los otros factores
            $existe_factor($hay_findividual,'plana_s1_', 'pla_fexpind', array(),$this);
            if ($GLOBALS['NOMBRE_APP']=='same2014'){
                $opci_findividual=array('individual','comun');
            }
            elseif($GLOBALS['NOMBRE_APP']=='vcm2018'){
                $opci_findividual=array('individual');
            }
            else{
                $opci_findividual=array('comun','individual', 'ind. Lu a Vi','ind. Sa a Do');                
            }
            /*
            $tabla_plana_s1=$this->nuevo_objeto("Tabla_plana_s1_");
            $tabla_plana_s1->leer_varios(array()); 
            while($tabla_plana_s1->obtener_leido() && !$hay_findividual){
                if($tabla_plana_s1->datos->pla_fexpind <> null){
                    $hay_findividual=true;
                }
            }
            */
        }
        //Loguear('2017-05-19', 'valmodo ==>'.$val_modo);
        parent::post_constructor();
        $this->definir_parametros(array(
            'titulo'=>'Tabulados '.$vtitulo_modo,
            'permisos'=>array('grupo'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'parametros'=>array(
                'tra_tab'=>array('tipo'=>'texto','label'=>'Cuadro','def'=>$primer_tabulado,'opciones'=>$tabla_tabulados->lista_opciones(array())),
                'tra_expandido'=>array('label'=>false,'label-derecho'=>$hay_factor?'expandido':'muestral','type'=>'checkbox', 'def'=>$hay_factor,'disabled'=>!$hay_factor,/*,'onclick'=>'tra_estado.disabled=!tra_mostrar_grilla.checked;'*/),              
               // 'tra_findividual'=>array('label'=>false,'label-derecho'=>'factor_individual?','type'=>'checkbox', 'def'=>$hay_findividual,'disabled'=>!$hay_findividual,'invisible'=>!$hay_findividual,),
                'tra_findividual'=>array('label'=>'factor','style'=>'width:99px','def'=>($hay_findividual?'individual':''), 'opciones'=>$opci_findividual,'disabled'=>!$hay_findividual,'invisible'=>($hay_findividual &&'tra_expandido')?false:true),
                'tra_revisar'=>array('label'=>false,'label-derecho'=>'con población total','aclaracion'=>'(para control)','type'=>'checkbox', 'def'=>!$hay_factor/*,'disabled'=>!$hay_factor,*/),
                'tra_revisar2'=>array('label'=>false,'label-derecho'=>'solo población total','aclaracion'=>'(solo para tabulados de frecuencia)','type'=>'checkbox', 'def'=>!$hay_factor/*,'disabled'=>!$hay_factor,*/,'invisible'=>true),
                'tra_coefvar'=>array('label'=>false, 'label-derecho'=>'con coeficiente de variación', 'type'=>'checkbox', 'checked'=>'tra_expandido'&& (substr($GLOBALS['NOMBRE_APP'],0,3)=='eah' && (substr($val_modo,0,3)=='eah'||$val_modo==''))?true:false, 'disabled'=>'tra_expandido'&& (substr($GLOBALS['NOMBRE_APP'],0,3)=='eah' &&( substr($val_modo,0,3)=='eah'||$val_modo==''))?false:true),
                'tra_en_letras'=>array('label'=>false, 'label-derecho'=>'en letras', 'type'=>'checkbox', 'checked'=>'tra_expandido'&& (substr($GLOBALS['NOMBRE_APP'],0,3)=='eah' && (substr($val_modo,0,3)=='eah'||$val_modo==''))?true:false/*'def'=>true*/, 'invisible'=>'tra_coefvar'?false:true),
                'tra_en_numero'=>array('label'=>false, 'label-derecho'=>'en número', 'aclaracion'=>'(para control)', 'type'=>'checkbox', 'checked'=>false, 'invisible'=>'tra_coefvar'?false:true /*, 'style'=>'text-align:rigth'*/),
                'tra_coefvar_funcion'=>array('label'=>false, 'label-derecho'=>'cv con funcion 2018/04', 'type'=>'checkbox', 'checked'=>false, 'invisible'=>'tra_coefvar'?false:true),
                'tra_estado'=>array('label'=>'desde estados', 'style'=>'width:50px','def'=>'77'),
                'tra_separador_decimal'=>array('label'=>'separador decimal','style'=>'width:25px','def'=>',', 'opciones'=>array(','=>array(',','coma'),'.'=>array('.','punto'))),
                'tra_modalidad'=>array('label'=>'modalidad','style'=>'width:99px','def'=>'normal', 'opciones'=>array('normal','mixto','viejo')),
                'tra_coefvar_normal_tasa'=>array('label'=>false, 'label-derecho'=>'nueva fórmula', 'aclaracion'=>'el coeficiente de variación de los cuadros normales (%) se calcula teniendo en cuenta el numerador y el denominador', 'type'=>'checkbox', 'checked'=>true, 'disabled'=>'tra_expandido'?false:true),
                'tra_modo_encuesta'=>array('invisible'=>true, 'def'=>isset($_SESSION['modo_encuesta'])?$_SESSION['modo_encuesta']:'')
            ),
            'boton'=>array('id'=>'generar', 'script_ok'=>'tabulado_generico'),
            'bitacora'=>true,
            'para_produccion'=>true,
            'opcion_node'=>true,
        ));
    }
    function correr(){
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT 
                (SELECT bit_fin 
                   FROM encu.bitacora 
                   WHERE bit_proceso='compilar_variables_calculadas' 
                     AND bit_parametros like '%"tra_varcal":"#todo"%' 
                     AND bit_fin IS NOT NULL 
                 ORDER BY bit_fin desc 
                 LIMIT 1) as ultima_compilacion,
                (SELECT tlg_momento
                   FROM encu.tiempo_logico
                   WHERE tlg_tlg=
                        GREATEST(
                            (SELECT varcal_tlg 
                               FROM encu.varcal
                             ORDER BY varcal_tlg desc 
                             LIMIT 1),
                            (SELECT varcalopc_tlg 
                               FROM encu.varcalopc
                             ORDER BY varcalopc_tlg desc 
                             LIMIT 1))
                ) as ultima_modificacion
SQL
        ));
        $control=$cursor->fetchObject();
        if($control->ultima_compilacion<$control->ultima_modificacion){
            $this->salida->enviar("Última compilación de variables: ".($control->ultima_compilacion?:'no hubo').
                ". Última modificación de variables: ".$control->ultima_modificacion,"mensaje_error_grave"
            );
        }
        parent::correr();
    }
    function responder(){
        // $FRASE_TOTAL="0";
        $FRASE_TOTAL="-1234567";
        //global $es_ope_eah_con_modo;
        $es_ope_eah_con_modo=substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']>=2015?true:false;
        Loguear('2017-05-17','es_ope_eah_con_modo ==== '.var_export($es_ope_eah_con_modo,true));
        $tabla_tabulados=$this->nuevo_objeto("Tabla_tabulados");
        $tabla_tabulados->leer_varios(array('tab_tab'=>$this->argumentos->tra_tab));
        //Loguear('2017-05-18','tra ==== '.var_export($this->argumentos,true));
        $funcion_cv='coef_var_tab';
        $funcion_cv_tasa='coef_var_tab_tasa';
        if(!$tabla_tabulados->obtener_leido()){
            return new Respuesta_Negativa("No existe el tabulado");
        } 
        if(!in_array($tabla_tabulados->datos->tab_cel_tipo, array('comun','mediana','promedio','frecuencia','tasa','suma'))){
            return new Respuesta_Negativa("Aún no existen tabulados de tipo ".$tabla_tabulados->datos->tab_cel_tipo);
        }
        if(!$tabla_tabulados->datos->tab_columna){
            return new Respuesta_Negativa("Todavía no está preparado para tabulados sin columnas");
        }
        if($tabla_tabulados->datos->tab_cel_tipo=='mediana' && $tabla_tabulados->datos->tab_fila2){
            return new Respuesta_Negativa("No existe el tabulado de mediana para agrupar por dos variables");
        }
        $con_coefvar=false; 
        if($this->argumentos->tra_coefvar && !$this->argumentos->tra_expandido){
            return new Respuesta_Negativa("No es posible generar los coeficientes de variación si no se eligen tabulados expandidos");
        }
        if($this->argumentos->tra_coefvar && $tabla_tabulados->datos->tab_cel_tipo!='comun' && $tabla_tabulados->datos->tab_cel_tipo!='frecuencia'  && $tabla_tabulados->datos->tab_cel_tipo!='tasa'){
            return new Respuesta_Negativa("No es posible generar los coeficientes de variación para tabulados del tipo ".$tabla_tabulados->datos->tab_cel_tipo);
        }
        if($this->argumentos->tra_coefvar && $this->argumentos->tra_expandido && !($this->argumentos->tra_en_letras||$this->argumentos->tra_en_numero)){
            return new Respuesta_Negativa("Debe seleccionar una opción en letras o número para el coeficiente de variación");
        }
        if($this->argumentos->tra_coefvar && $this->argumentos->tra_expandido && $this->argumentos->tra_en_letras && $this->argumentos->tra_en_numero){
            return new Respuesta_Negativa("No es posible seleccionar ambas opciones en letras ó en numero");
        }
        if(!$this->argumentos->tra_coefvar && ($this->argumentos->tra_en_letras||$this->argumentos->tra_en_numero)){
            return new Respuesta_Negativa("No es posible seleccionar en letras o en número si no está seleccionada la opción coeficientes de variacion");
        }
        if(!$this->argumentos->tra_coefvar && $this->argumentos->tra_coefvar_funcion){
            return new Respuesta_Negativa("No debe marcar parametro coefvar_funcion si no elige mostrar coeficientes de variacion");
        }        
        if(substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']<2017 && $this->argumentos->tra_coefvar_funcion){
            return new Respuesta_Negativa("Funcion de CV no implementada en operativo");
        }        
        $td=$tabla_tabulados->datos; 
        if($this->argumentos->tra_expandido && $this->argumentos->tra_coefvar && ($this->argumentos->tra_en_letras || $this->argumentos->tra_en_numero)){
            $con_coefvar=true;
            list($var_grzona,$var_tabfila)=letra_y_campo_zonal($td->tab_fila1,$td->tab_fila2);
            loguear('2017-05-31', ' LC grzona:'.$var_grzona. ' tab_fila:'.$var_tabfila);
            
        }
        loguear('2018-04-05', 'coefvar_funcion'.$this->argumentos->tra_coefvar_funcion);
        if($this->argumentos->tra_expandido && $this->argumentos->tra_coefvar && !!$this->argumentos->tra_coefvar_funcion){
            $funcion_cv='coef_var_b';
            $funcion_cv_tasa='coef_var_b_tasa';
        }
        $tra_coefvar_normal_tasa=$this->argumentos->tra_coefvar_normal_tasa;
        $DECIMALES=$tabla_tabulados->datos->tab_decimales;
        if($DECIMALES===null){
            switch($td->tab_cel_tipo){
                case 'promedio':
                    return new Respuesta_Negativa("No es posible generar tabulados de promedios si no está especificada la cantidad de decimales");
                break;    
                case 'suma':
                    return new Respuesta_Negativa("No es posible generar tabulados de ".$td->tab_cel_tipo." si no está especificada la cantidad de decimales");
                break;    
                default:
                    $DECIMALES=1;
                break;                
            }
        }       
        //$DECIMALES=$tabla_tabulados->datos->tab_cel_tipo=='promedio'?0:1;
//Factor Expansion  
        if($this->argumentos->tra_expandido){
            if(preg_match("/^(same2014|ut2016|vcm2018)$/", $GLOBALS['NOMBRE_APP'])==1 && preg_match("/^(individual|ind. Lu a Vi|ind. Sa a Do)$/", $this->argumentos->tra_findividual)==1){
                switch($this->argumentos->tra_findividual){
                    case 'individual':
                        $pla_fexp='pla_fexpind';
                    break;    
                    case 'ind. Lu a Vi':
                        $pla_fexp='pla_fexpindlv';
                    break;    
                    default:
                        $pla_fexp='pla_fexpindsd';
                    break;                
                }    
            }elseif( $es_ope_eah_con_modo){
                $pla_fexp='eh.pla_fexp' ; //modo_encuesta                
            }else{     
                $pla_fexp='pla_fexp'; 
            }
        }
        
// armar filtros  
        $cur_vh=$this->db->ejecutar(new Sql(<<<SQL
            select distinct lower('plana_'||blo_for||'_' ) as tabla_vh, 
                CASE WHEN blo_for='A1' THEN 'inner join plana_s1_ as s1 on a.pla_enc=s1.pla_enc and a.pla_hog=s1.pla_hog'
                     ELSE ''
                END  join_vh      
              FROM encu.bloques
              WHERE blo_ope=dbo.ope_actual() and blo_blo in ('Viv', 'Hog','SM1.1') and blo_mat=''
SQL
        ));
        $leer_tabla_vh=$cur_vh->fetchObject();
        $v_tabla_vh= $leer_tabla_vh->tabla_vh;               
        $v_join_vh = $leer_tabla_vh->join_vh;
        $val_modo='';
        if(substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']>=2015){
            $val_modo= ($_SESSION['modo_encuesta']=='ETOI')?$_SESSION['modo_encuesta']:$GLOBALS['NOMBRE_APP'];
        }    
        $vmediana_modo=$es_ope_eah_con_modo?$val_modo:'';
        //Loguear('2016-03-07','vmediana_modo ==== '.$vmediana_modo);
        $v_ope_semestral=(substr($GLOBALS['NOMBRE_APP'],0,4)=='etoi'&& substr($GLOBALS['NOMBRE_APP'],6,1)=='s')?" t.pla_operativo_original":"'{$GLOBALS['NOMBRE_APP']}'";
        $v_valcan=(substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'||substr($GLOBALS['NOMBRE_APP'],0,4)=='etoi')?" left join valcan vc on vc.pla_ope={$v_ope_semestral}":''; 
        switch($tabla_tabulados->datos->tab_cel_exp){
            case 'personas':
                $complemento= ' and s1.pla_hog=eh.pla_hog';
                $v_join_exthog=($es_ope_eah_con_modo)?" inner join pla_ext_hog as eh on t.pla_enc=eh.pla_enc {$complemento} and pla_modo= '{$val_modo}'":'';
                $junta=<<<SQL
                        from plana_s1_p s1_p 
                          inner join plana_i1_ i1 on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie 
                          inner join plana_s1_ s1 on s1.pla_enc=i1.pla_enc and s1.pla_hog=i1.pla_hog and s1.pla_mie=0 
                          inner join plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and s1.pla_mie=0 
                          {$v_join_exthog}
                          {$v_valcan}  
SQL;
            break;
            case 'hogares':
                $complemento= ' and a.pla_hog=eh.pla_hog';
                $v_join_exthog=($es_ope_eah_con_modo)?" inner join pla_ext_hog as eh on t.pla_enc=eh.pla_enc {$complemento} and pla_modo= '{$val_modo}'":'';
                $junta=<<<SQL
                        from {$v_tabla_vh} a
                          {$v_join_vh}
                          inner join plana_tem_ t on a.pla_enc=t.pla_enc
                          {$v_join_exthog}
                          {$v_valcan}
SQL;
            break;
            case 'viviendas':
                $complemento= ' and eh.pla_hog=1';
                $v_join_exthog=($es_ope_eah_con_modo)?" inner join pla_ext_hog as eh on t.pla_enc=eh.pla_enc {$complemento} and pla_modo= '{$val_modo}'":'';
                $junta=<<<SQL
                        from {$v_tabla_vh} a
                          inner join plana_tem_ t on a.pla_enc=t.pla_enc
                          {$v_join_exthog}
                          {$v_valcan}
                          
SQL;
            break;
            default:
                return new Respuesta_Negativa("Todavía no está preparado para tabulados para ".$tabla_tabulados->datos->tab_cel_exp);
            break;
            
        }
       // $filtro_modo_encuesta= $_SESSION['modo_encuesta']=='ETOI'? " and rotaci_n_eah=1 ": ""; // modo_encuesta
        $filtro_rea=($GLOBALS['NOMBRE_APP']=='colon2015')?" ":" AND rea not in (0,2) ";
        //$filtro_general="estado>=".$this->argumentos->tra_estado." AND rea not in (0,2) ";
        $filtro_general="estado>=".$this->argumentos->tra_estado.$filtro_rea; 
        if($tabla_tabulados->datos->tab_cel_exp!='viviendas'){
            $filtro_general=$filtro_general." AND entrea <> 4 "; // lo agregamos para no contar los hogares salientes (Gladys)
        }
        $filtro_general=$filtro_general;
        if(!$tabla_tabulados->datos->tab_filtro){
            $campos_filtro=expresion_regular_agregar_prefijo($filtro_general,'pla_');
        } else {
            $campos_filtro=$tabla_tabulados->datos->tab_filtro." AND ".$filtro_general;
            $campos_filtro=expresion_regular_agregar_prefijo($campos_filtro,'pla_');
            if($tabla_tabulados->datos->tab_cel_exp=='viviendas'){
                $campos_filtro=preg_replace('#\bpla_(hog|enc)\b#','a.pla_$1',$campos_filtro);
            }else{
                $campos_filtro=preg_replace('#\bpla_(hog|enc)\b#','s1.pla_$1',$campos_filtro);
            }
            $campos_filtro=preg_replace('#\bpla_mie\b#','i1.pla_mie',$campos_filtro);
        }
        $campos=array();
        $td=$tabla_tabulados->datos;
        $campos_fila=array('pla_'.$td->tab_fila1);
        $campos['pla_'.$td->tab_fila1]  =array('posicion'=>'izquierda');
        if($td->tab_fila2){
            $campos['pla_'.$td->tab_fila2]=array('posicion'=>'izquierda');
            $campos_fila[]='pla_'.$td->tab_fila2;
        }
      //  loguear('2017-05-31', 'grzona:'.$var_grzona. ' tab_fila:'.$var_tabfila);
        if($con_coefvar){
            $poner_celda_coefvar=function($en_numero,$p_tabla,$campos_fila) use ($td,$var_grzona,$con_coefvar,$var_tabfila,&$campos,$pla_fexp,$tra_coefvar_normal_tasa,$funcion_cv_tasa, $funcion_cv){
                    if($var_grzona=='T'){
                        $v_parametro=$var_tabfila;
                    }else{
                        $v_parametro="pla_".$var_tabfila; 
                    }
                    if(is_array($campos_fila) && $tra_coefvar_normal_tasa){
                        $formula="dbo.".$funcion_cv_tasa."('".$p_tabla. "', '" .$var_grzona. "' ,".$v_parametro." , sum({$pla_fexp})".
                            ", '" .$var_grzona. "' ,".$v_parametro." , sum(sum({$pla_fexp})) over (".
                                ($campos_fila?"partition by ".implode(',',$campos_fila):'').
                            "))";
                    }else{
                        $formula="dbo.".$funcion_cv."('".$p_tabla. "', '" .$var_grzona. "' ,".$v_parametro." , sum({$pla_fexp}))";
                    }
                    if($en_numero){
                        $campos['pla_coefvar']= array('posicion'=>'centro','origen'=>$formula);
                    }else{
                        $campos['pla_coefvar']= array('posicion'=>'centro','origen'=>cv_pasar_a_letras($formula)); 
                    }    
            };
        }
        $resto='';
        switch($td->tab_cel_tipo){        
            case 'comun': 
                $campos['pla_'.$td->tab_columna]=array('posicion'=>'arriba');
                $campos['pla_cantidad']  =array('posicion'=>'centro', 'origen'=>$this->argumentos->tra_expandido?'sum('.$pla_fexp.")":'count(*)');  
                if($con_coefvar){
                    $poner_celda_coefvar($this->argumentos->tra_en_numero,$td->tab_cel_exp,$campos_fila);
                }                
            break;
            case 'frecuencia':
                if($td->tab_columna=='mie' || $td->tab_columna=='hog'){
                    $campos['pla_frecuencia']=array('posicion'=>'arriba');
                }else{
                    $campos['pla_'.$td->tab_columna]=array('posicion'=>'arriba');
                }            
                $campos['pla_cantidad']  =array('posicion'=>'centro', 'origen'=>$this->argumentos->tra_expandido?'sum('.$pla_fexp.")":'count(*)');           
                if($con_coefvar){
                    if($td->tab_columna=='hog' && $td->tab_cel_exp=='viviendas'){
                        $poner_celda_coefvar($this->argumentos->tra_en_numero,"hogares",false);//hasta que nos contesten sobre los coeficientes de variacion para viviendas, simulamos con hogares    
                    }
                    if($td->tab_columna=='hog' && $td->tab_cel_exp=='personas'){
                        $poner_celda_coefvar($this->argumentos->tra_en_numero,"hogares",false);// porque tab_cel_exp esta puesto como personas. y el coef var debe ser de hogares
                    } 
                    if($td->tab_columna=='hog' && $td->tab_cel_exp=='hogares'){ // porque tab_cel_exp esta puesto como hogares y cuenta hogares
                        $poner_celda_coefvar($this->argumentos->tra_en_numero,$td->tab_cel_exp,false);
                    }                     
                    if($td->tab_columna=='mie'){
                        $poner_celda_coefvar($this->argumentos->tra_en_numero,$td->tab_cel_exp,false);                 
                    }
                }                  
            break;
            case 'promedio': 
                $campos['pla_promedio']=array('posicion'=>'arriba');
                $campos['pla_cantidad'] = array('posicion'=>'centro', 'origen'=>$this->argumentos->tra_expandido?'round(sum(pla_'.$td->tab_columna."::numeric*{$pla_fexp})/sum({$pla_fexp})::numeric,{$DECIMALES})":'round(avg(pla_'.$td->tab_columna.")::numeric,{$DECIMALES})");
            break;  
            case 'suma': 
                $campos['pla_suma']=array('posicion'=>'arriba');
                $campos['pla_cantidad'] = array('posicion'=>'centro', 'origen'=>$this->argumentos->tra_expandido?'round(sum(pla_'.$td->tab_columna."::numeric *{$pla_fexp})::numeric,{$DECIMALES})":'round(sum(pla_'.$td->tab_columna.")::numeric,{$DECIMALES})");
            break;  
            case 'mediana': 
                $campos['pla_mediana']=array('posicion'=>'arriba');
                if($this->argumentos->tra_expandido){
                    $campos['pla_cantidad'] = array('posicion'=>'centro', 'origen'=>"dbo.mediana_expandida_agrupada('".$td->tab_columna."', '".$campos_filtro."', '".$td->tab_fila1."', pla_".$td->tab_fila1.", '".$vmediana_modo."' )");
                }else{
                    $campos['pla_cantidad'] = array('posicion'=>'centro', 'origen'=>'round(mediana(pla_'.$td->tab_columna.")::numeric,{$DECIMALES})");
                }
            break;             
            case 'tasa':  
                $campos['pla_tasa']=array('posicion'=>'arriba');
                $columna=$td->tab_columna;
                $div='/';
                $filasx=($td->tab_fila2?'x.pla_'.$td->tab_fila2.', ':'').'x.pla_'.$td->tab_fila1;
                $filas=($td->tab_fila2?'pla_'.$td->tab_fila2.', ':'').'pla_'.$td->tab_fila1;
                $resto=' ) x) y where y.pla_'.$td->tab_columna.' > 0)';
                $formula_coefvar_inter=function($en_numero,$p_campo,$tab_cel_exp,$campo_group_by) use ($con_coefvar, $funcion_cv_tasa, $funcion_cv){
                    if(!$con_coefvar){
                        return "";
                    }
                    $formula="dbo.".$funcion_cv_tasa."( '".$tab_cel_exp."' , '".letra_zonal_de($p_campo)."' ,".campo_zonal_de($p_campo).",pla_cantidad".
                        ", '".letra_zonal_de($p_campo)."' ,".campo_zonal_de($p_campo).", sum(x.pla_cantidad) OVER (PARTITION BY ".$campo_group_by."))";
                    if(!$en_numero){                                
                        $formula=cv_pasar_a_letras($formula);
                    }     
                    return ", ".$formula." as pla_coefvar ";
                };
                if($con_coefvar){
                    // $pla_coefvar=', 1234.444 as pla_coefvar';
                    $pla_coefvar=', pla_coefvar';
                    if($td->tab_fila2){
                        list($lo_tiro,$fila_mas_imp)=letra_y_campo_zonal($td->tab_fila1,$td->tab_fila2);
                    }else{
                        $fila_mas_imp=$td->tab_fila1;
                    }
                    $pla_coefvari=$formula_coefvar_inter($this->argumentos->tra_en_numero,$fila_mas_imp,$td->tab_cel_exp,$filasx);
                }else{
                    $pla_coefvar='';
                    $pla_coefvari='';
                }
                $dividir=$this->argumentos->tra_revisar?"":"*100 $div y.pla_total";
                if($this->argumentos->tra_expandido){
                    $origen=<<<SQL
                        round((y.pla_cantidad{$dividir})::numeric,{$DECIMALES}) as pla_cantidad $pla_coefvar from 
                          (SELECT x.pla_$columna, $filasx, x.pla_cantidad, sum(x.pla_cantidad) OVER (PARTITION BY $filasx) as pla_total $pla_coefvari 
                              FROM (select pla_$columna, $filas, sum({$pla_fexp})  

SQL;
                }else{
                    $origen=<<<SQL
                        round((y.pla_cantidad{$dividir})::numeric,{$DECIMALES}) as pla_cantidad from (SELECT x.pla_$columna, $filasx, x.pla_cantidad, sum(x.pla_cantidad)  OVER (PARTITION BY $filasx) as pla_total FROM 
(select pla_$columna, $filas, count(*)  
SQL;
                }
                $campos['pla_cantidad'] = array('posicion'=>'centro', 'origen'=>$origen);
                if($con_coefvar){
                    $campos['pla_coefvar']= array('posicion'=>'centro','origen'=>0);
                }
            break;
            default:
                return new Respuesta_Negativa("Todavía no está preparado para tabulados ".$td->tab_cel_exp);
            break;
        }
        $campos_select=array();
        $campos_groupby=array();        
        $campos_orderby=array(); 
        foreach($campos as $campo=>$definicion_campo){
        
            if(!isset($definicion_campo['titulo'])){
                $campos[$campo]['titulo']=quitar_prefijo($campo,'pla_');
            }
            if(!isset($definicion_campo['origen'])){
                if($campo!='pla_frecuencia' && $campo!='pla_promedio' && $campo!='pla_mediana' && $campo!='pla_tasa' && $campo!='pla_suma'){
                    $campos_select[]=$campo;
                }
            }else{
                $campos_select[]=$definicion_campo['origen'].' as '.$campo;
            }
            if(!isset($definicion_campo['tipo'])){
                $campos[$campo]['tipo']='numerico';
            }
            if($definicion_campo['posicion']!='centro'){
                if($td->tab_cel_tipo!='tasa'){
                    if($campo!='pla_frecuencia' && $campo!='pla_promedio' && $campo!='pla_suma'){
                        $campos_groupby[]=$campo;
                    }
                }
                $campos[$campo]['lookup']=array();
// busco variable en tabla variables y si está, cargo sus opciones, si tiene                
                $tabla_variables=$this->nuevo_objeto("Tabla_variables");                
                $variable=quitar_prefijo($campo,'pla_');
                $tabla_variables->leer_uno_si_hay(array(
                    'var_ope'=>$GLOBALS['NOMBRE_APP'],
                    'var_var'=>$variable,                    
                )); 
                $conopc='';
                $array_opciones=array(); 
                if($tabla_variables->obtener_leido()){
                    $conopc=$tabla_variables->datos->var_conopc;
                    $campos[$campo]['titulo'].=$tabla_variables->datos->var_texto?' ('.trim($tabla_variables->datos->var_texto).') ':'';
                    $tabla_opciones=$this->nuevo_objeto("Tabla_opciones");
                    $tabla_opciones->leer_varios(array(
                        'opc_ope'=>$GLOBALS['NOMBRE_APP'],
                        'opc_conopc'=>$conopc,                    
                    ));                
                    while($tabla_opciones->obtener_leido()){
                        if(stripos($tabla_opciones->datos->opc_texto,'?')!=false){
                            $array_opciones[$tabla_opciones->datos->opc_opc]=substr($tabla_opciones->datos->opc_texto,0,stripos($tabla_opciones->datos->opc_texto,'?'));
                        }else{
                            $array_opciones[$tabla_opciones->datos->opc_opc]=$tabla_opciones->datos->opc_texto;
                        }
                    } 
                }else{
// si no está en variables, la busco en variables calculadas con sus opciones en varcalopc
                    $tabla_variables_calculadas=$this->nuevo_objeto("Tabla_varcal");                
                    $variable=quitar_prefijo($campo,'pla_');
                    $tabla_variables_calculadas->leer_uno_si_hay(array(
                        'varcal_ope'=>$GLOBALS['NOMBRE_APP'],
                        'varcal_varcal'=>$variable,                    
                    )); 
                    $conopc='';
                    if($tabla_variables_calculadas->obtener_leido()){ 
                        $campos[$campo]['titulo'].=' ('.trim($tabla_variables_calculadas->datos->varcal_nombre).') ';
                        $tabla_varcalopc=$this->nuevo_objeto("Tabla_varcalopc");                
                        $tabla_varcalopc->leer_varios(array(
                            'varcalopc_ope'=>$GLOBALS['NOMBRE_APP'],
                            'varcalopc_varcal'=>$variable,                    
                        ));
                        while($tabla_varcalopc->obtener_leido()){
                            $array_opciones[$tabla_varcalopc->datos->varcalopc_opcion]=$tabla_varcalopc->datos->varcalopc_etiqueta;
                        }
                        /*
                        $tabla_varext=$this->nuevo_objeto("Tabla_varext");  //modo_encuesta              
                        $variable=quitar_prefijo($campo,'pla_');
                        $tabla_varext->leer_uno_si_hay(array(
                            'varext_ope'=>$GLOBALS['NOMBRE_APP'],
                            'varext_varext'=>$variable,                    
                        ));
                        $campos[$campo]['prefijo']='pla';
                        if($tabla_varext->obtener_leido()){
                            $campos[$campo]['prefijo']='exthog';
                        } 
                        */                         
                    }
                }
                $campos[$campo]['lookup']=$array_opciones;
            }
        }
        if($td->tab_cel_tipo=='tasa'){
            $tabla_varcalopc_tasa=$this->nuevo_objeto("Tabla_varcalopc");                
            $tabla_varcalopc_tasa->leer_uno_si_hay(array(
                'varcalopc_ope'=>$GLOBALS['NOMBRE_APP'],
                'varcalopc_varcal'=>$td->tab_columna,                   
                'varcalopc_opcion'=>1,                
            ));
            if($tabla_varcalopc_tasa->obtener_leido()){
                $titulo_columna=$tabla_varcalopc_tasa->datos->varcalopc_etiqueta;
            } else {
                $titulo_columna='TASA';
            }
                    
            $campos_groupby[]=$td->tab_columna;
            if($td->tab_fila2){
                $campos_groupby[]=$td->tab_fila2;
            }                        
            $campos_groupby[]=$td->tab_fila1;
            $campos_groupby=expresion_regular_agregar_prefijo($campos_groupby,'pla_');
            $campos_orderby[]=$td->tab_fila1;
            if($td->tab_fila2){
                $campos_orderby[]=$td->tab_fila2;
            }                        

            $campos_orderby=expresion_regular_agregar_prefijo($campos_orderby,'pla_');
        }
        if($td->tab_columna=='mie'){
            $sql_columnas="select 'PERSONAS' as pla_frecuencia ";
            $sql_cuerpo="select 'PERSONAS' as pla_frecuencia, ";
        }else{
            if($td->tab_columna=='hog' && $td->tab_cel_exp=='viviendas'){
                $sql_columnas="select 'VIVIENDAS' as pla_frecuencia ";
                $sql_cuerpo="select 'VIVIENDAS' as pla_frecuencia, ";
            }else{
                if($td->tab_columna=='hog' && ($td->tab_cel_exp=='personas' || $td->tab_cel_exp=='hogares')){
                    $sql_columnas="select 'HOGARES' as pla_frecuencia ";
                    $sql_cuerpo="select 'HOGARES' as pla_frecuencia, ";
                }else{
                    switch($td->tab_cel_tipo){      
                        case 'promedio':                     
                            $sql_columnas="select 'PROMEDIO' as pla_promedio ";
                            if($this->argumentos->tra_expandido){
                                $sql_principio="select 'PROMEDIO' as pla_promedio, {$FRASE_TOTAL} as ".implode(','.$FRASE_TOTAL.' as ',$campos_fila).", round(sum(pla_".$td->tab_columna."::numeric*{$pla_fexp})/sum({$pla_fexp})::numeric,{$DECIMALES}) as pla_cantidad ".$junta." WHERE ".$campos_filtro." UNION ";

                            }else{
                                $sql_principio="select 'PROMEDIO' as pla_promedio, {$FRASE_TOTAL} as ".implode(','.$FRASE_TOTAL.' as ',$campos_fila).", round(avg(pla_".$td->tab_columna.")::numeric,{$DECIMALES}) as pla_cantidad ".$junta." WHERE ".$campos_filtro." UNION ";
                            }
                            $sql_cuerpo=$sql_principio." select 'PROMEDIO' as pla_promedio, "; 
                        break;
                        case 'suma':                     
                            $sql_columnas="select 'SUMA' as pla_suma ";
                            if($this->argumentos->tra_expandido){
                                $sql_principio="select 'SUMA' as pla_suma, {$FRASE_TOTAL} as ".implode(','.$FRASE_TOTAL.' as ',$campos_fila).", round(sum(pla_".$td->tab_columna."::numeric*{$pla_fexp})::numeric,{$DECIMALES}) as pla_cantidad ".$junta." WHERE ".$campos_filtro." UNION ";
                            }else{
                                $sql_principio="select 'SUMA' as pla_suma, {$FRASE_TOTAL} as ".implode(','.$FRASE_TOTAL.' as ',$campos_fila).", round(sum(pla_".$td->tab_columna.")::numeric,{$DECIMALES}) as pla_cantidad ".$junta." WHERE ".$campos_filtro." UNION ";
                            }
                            $sql_cuerpo=$sql_principio." select 'SUMA' as pla_suma, "; 
                        break;
                        case 'mediana':
                            $sql_columnas="select 'MEDIANA' as pla_mediana ";
                            if($this->argumentos->tra_expandido){
                                $sql_principio="select 'MEDIANA' as pla_mediana, {$FRASE_TOTAL} as ".implode(',' .$FRASE_TOTAL. ' as ',$campos_fila).", dbo.mediana_expandida('".$td->tab_columna."', '".$campos_filtro."', '".$vmediana_modo."' ) as pla_cantidad UNION ";
                            }else{
                                $sql_principio="select 'MEDIANA' as pla_mediana, {$FRASE_TOTAL} as ".implode(',' .$FRASE_TOTAL. ' as ',$campos_fila).", round(mediana(pla_".$td->tab_columna.")::numeric,{$DECIMALES}) as pla_cantidad ".$junta." WHERE ".$campos_filtro." UNION ";
                            }
                            $sql_cuerpo=$sql_principio." select 'MEDIANA' as pla_mediana, "; 
                        break;
                        case 'tasa':    
                            $tra_revisar=$this->argumentos->tra_revisar;
                            $sql_columnas="select '$titulo_columna' as pla_tasa ";
                            if($this->argumentos->tra_expandido){
                                //$formula_coefvar=$this->argumentos->tra_en_numero?"-3":"'x'"; 
                                if($con_coefvar){
                                    // $formula_coefvar="dbo.".$funcion_cv."( '".$td->tab_cel_exp."' ,'T' ,0 ,sum({$pla_fexp}))";
                                    $formula_coefvar="dbo.".$funcion_cv_tasa."( '".$td->tab_cel_exp."' , 'T' ,0 ,sum(case when pla_".$td->tab_columna.">0 then {$pla_fexp} else 0 end),'T' ,0 ,sum({$pla_fexp}))";
                                    if(!$this->argumentos->tra_en_numero){                                
                                        $formula_coefvar=cv_pasar_a_letras($formula_coefvar);
                                        /*"case when {$formula_coefvar}<10 then ''  when {$formula_coefvar} between 10 and 20 then 'a' when {$formula_coefvar}>20 and {$formula_coefvar}<=30 then 'b' when {$formula_coefvar}>30 then 'c' end";
                                        */
                                    }    
                                    $formula_coefvar=", ".$formula_coefvar." as pla_coefvar ";
                                }else{
                                    $formula_coefvar="";
                                }
                                $dividir=$tra_revisar?"":"*100/sum({$pla_fexp})::numeric";
                                $cantidad=", 5 as pla_total";
                                $sql_principio="select '$titulo_columna' as pla_tasa, $FRASE_TOTAL as ".implode(','.$FRASE_TOTAL.' as ',$campos_fila).", round(sum(case when pla_".$td->tab_columna.">0 then {$pla_fexp} else 0 end){$dividir},{$DECIMALES}) as pla_cantidad ".$formula_coefvar." ".$junta." WHERE ".$campos_filtro."\n UNION \n";
                                if($td->tab_fila2){
                                    // $equis=$this->argumentos->tra_en_numero?"-3::numeric":"'x'::text"; 
                                    $dividir=$tra_revisar?"":"*100 / y.pla_total";
                                    $armar_sentencia_una_parte=function($esto,$izq, $campo_group_by) 
                                    use ($td,$pla_coefvar,$FRASE_TOTAL,$titulo_columna,$dividir,$junta,$campos_filtro,$con_coefvar,$formula_coefvar_inter,$DECIMALES,$pla_fexp){
                                        $prefijo_total_izq=$izq?   "{$FRASE_TOTAL} as ":"";
                                        $prefijo_total_der=$izq?"":"{$FRASE_TOTAL} as ";
                                        $prefijo_xero_izq=$izq?     "0 as ":"x.";
                                        $prefijo_xero_der=$izq?"x.":"0 as ";
                                        $prefijo_cero_izq=$izq?     "0 as ":"";
                                        $prefijo_cero_der=$izq?""  :"0 as "; 
                                        return "\n(select '$titulo_columna' as pla_tasa".
                                            "\n, $prefijo_total_izq pla_".$td->tab_fila1.
                                            "\n, $prefijo_total_der pla_".$td->tab_fila2.
                                            "\n , round((y.pla_cantidad {$dividir})::numeric,{$DECIMALES}) as pla_cantidad ".
                                            "\n$pla_coefvar from (".
                                            "\n   SELECT x.pla_".$td->tab_columna.
                                            "\n    , {$prefijo_xero_izq}pla_".$td->tab_fila1.
                                            "\n    , {$prefijo_xero_der}pla_".$td->tab_fila2.
                                            "\n    , x.pla_cantidad".
                                            "\n    , sum(x.pla_cantidad) OVER (PARTITION BY x.pla_".$campo_group_by.") as pla_total ".
                                            "\n      ".$formula_coefvar_inter($esto->argumentos->tra_en_numero,$campo_group_by,$td->tab_cel_exp,"x.pla_".$campo_group_by).
                                            "\n      FROM (select pla_".$td->tab_columna.
                                            "\n              , {$prefijo_cero_izq}pla_".$td->tab_fila1.
                                            "\n              , {$prefijo_cero_der}pla_".$td->tab_fila2.
                                            "\n              , sum({$pla_fexp}) as pla_cantidad ".
                                            "\n               ".$junta." WHERE ".$campos_filtro.
                                            "\n               group by pla_".$td->tab_columna.", pla_".$campo_group_by.
                                            "\n            ) x) y where y.pla_".$td->tab_columna." > 0 ) \n UNION ";
                                    };
                                    $sql_principio.=$armar_sentencia_una_parte($this, false, $td->tab_fila1);
                                    $sql_principio.=$armar_sentencia_una_parte($this, true , $td->tab_fila2);
                                }
                            }else{
                                $dividir=$tra_revisar?"":"*100/count(coalesce(pla_".$td->tab_columna.",1))::numeric";
                                $sql_principio="select '$titulo_columna' as pla_tasa, '$FRASE_TOTAL' as ".implode(','.$FRASE_TOTAL.' as ',$campos_fila).", round(sum(case when pla_".$td->tab_columna.">0 then 1 else 0 end){$dividir},{$DECIMALES}) as pla_cantidad ".$junta." WHERE ".$campos_filtro." UNION ";
                                if($td->tab_fila2){
                                    //$dividir=!$tra_revisar?"":"*100 / y.pla_total";
                                    $dividir=$tra_revisar?"":"*100 / y.pla_total";
                                    $sql_principio.="(select '$titulo_columna' as pla_tasa, pla_".$td->tab_fila1.", {$FRASE_TOTAL} as pla_".$td->tab_fila2.", round((y.pla_cantidad{$dividir})::numeric,{$DECIMALES}) as pla_cantidad from (SELECT x.pla_".$td->tab_columna.", 0 as pla_".$td->tab_fila2.", x.pla_".$td->tab_fila1.", x.pla_cantidad, sum(x.pla_cantidad) OVER (PARTITION BY x.pla_".$td->tab_fila1.") as pla_total FROM (select pla_".$td->tab_columna.", 0 as pla_".$td->tab_fila2.", pla_".$td->tab_fila1.", count(*) as pla_cantidad ".$junta." WHERE ".$campos_filtro." group by pla_".$td->tab_columna.", pla_".$td->tab_fila1." ) x) y where y.pla_".$td->tab_columna." > 0 ) \n UNION ";
                                    $sql_principio.="(select '$titulo_columna' as pla_tasa, {$FRASE_TOTAL} as pla_".$td->tab_fila1.", pla_".$td->tab_fila2.", round((y.pla_cantidad{$dividir})::numeric,{$DECIMALES}) as pla_cantidad from (SELECT x.pla_".$td->tab_columna.", x.pla_".$td->tab_fila2.", 0 as pla_".$td->tab_fila1.", x.pla_cantidad, sum(x.pla_cantidad) OVER (PARTITION BY x.pla_".$td->tab_fila2.") as pla_total FROM (select pla_".$td->tab_columna.", pla_".$td->tab_fila2.", 0 as pla_".$td->tab_fila1.", count(*) as pla_cantidad ".$junta." WHERE ".$campos_filtro." group by pla_".$td->tab_columna.", pla_".$td->tab_fila2." ) x) y where y.pla_".$td->tab_columna." > 0 ) \n UNION ";
                                }
                            }
                            $sql_cuerpo=$sql_principio."(select '$titulo_columna' as pla_tasa, "; 
                        break;
                            default:
                            $sql_columnas="select distinct pla_".$td->tab_columna." ".$junta. "\n WHERE ".$campos_filtro." order by 1";
                            $sql_cuerpo="select ";
                        break;
                    }
                } 
            }    
        }
        if($td->tab_cel_tipo=='tasa'){
            $sql_cuerpo=$sql_cuerpo.implode(',',$campos_select).$junta.
                        "\n WHERE ".$campos_filtro.
                        "\n GROUP BY ".implode(',',$campos_groupby).
                        $resto.
                        "\n ORDER BY ".implode(' nulls first,',$campos_orderby).' nulls first ';
            // return new Respuesta_Positiva($sql_cuerpo);
        }else{
            if($td->tab_cel_tipo=='mediana' && $this->argumentos->tra_expandido){
                $junta=" from (select distinct(pla_".$td->tab_fila1.") from plana_s1_p s1_p 
inner join plana_i1_ i1 on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie 
inner join plana_s1_ s1 on s1.pla_enc=i1.pla_enc and s1.pla_hog=i1.pla_hog and s1.pla_mie=0 
inner join plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and s1.pla_mie=0 order by pla_".$td->tab_fila1.") y "; 
                $sql_cuerpo=$sql_cuerpo.implode(',',$campos_select).$junta." order by pla_".$td->tab_fila1.' nulls first';
            }else{ 
                if(( $td->tab_cel_tipo=='comun' || $td->tab_cel_tipo=='frecuencia')){
                     $sql_cuerpo=$sql_cuerpo.implode(',',$campos_select).$junta.
                            "\n WHERE ".$campos_filtro.
                            "\n GROUP BY ".implode(',',$campos_groupby).
                            "\n ORDER BY ".implode(' nulls first,',$campos_groupby).' nulls first';
                    // consultar con Emilio si se recuperan los valores del coef. de variacion aca
                   // if($this->argumentos->tra_modalidad!='viejo'){
                      if($this->argumentos->tra_modalidad=='normal'){
                        if($con_coefvar){
                            $sql_tcfvar_llamada=function($expresion_completadora,$campos_groupby) use ($td,$tra_coefvar_normal_tasa,$funcion_cv_tasa,$funcion_cv){
                                if($tra_coefvar_normal_tasa){
                                    return "dbo.".$funcion_cv_tasa."('".$td->tab_cel_exp. "',".
                                        " '".$expresion_completadora." , sum(x.pla_cantidad),".
                                        " '".$expresion_completadora." , sum(sum(x.pla_cantidad)) over (".
                                            ($campos_groupby?"partition by ".implode(',',$campos_groupby):'').
                                        ")".
                                        ")";
                                }else{
                                    return "dbo.".$funcion_cv."('".$td->tab_cel_exp. "',".
                                        " '".$expresion_completadora." , sum(x.pla_cantidad))";
                                }
                            };
                            if($this->argumentos->tra_en_numero){
                                $sql_tcfvar=function($expresion_completadora,$campos_groupby) use ($td,$sql_tcfvar_llamada){
                                    return $sql_tcfvar_llamada($expresion_completadora,$campos_groupby)." as pla_coefvar from ( ";
                                };
                            }else{
                                $sql_tcfvar=function($expresion_completadora,$campos_groupby) use ($td,$sql_tcfvar_llamada){
                                    $cv_aux=$sql_tcfvar_llamada($expresion_completadora,$campos_groupby);
                                    return cv_pasar_a_letras($cv_aux).' as pla_coefvar from (';
                                    /*"case when ".$sql_tcfvar_llamada($expresion_completadora,$campos_groupby)." <10 then '' ".
                                        "when ".$sql_tcfvar_llamada($expresion_completadora,$campos_groupby)." between 10 and 20 then 'a'".
                                        "else 'b' end as pla_coefvar from ( "; 
                                    */    
                                }; 
                            }
                            $formula_simple=$sql_tcfvar('T'."' ,0",array());                            
                        }else{
                            $formula_simple=" from (";
                        }          
                        $completa_cadena=function(&$pcadena,$pagregado) use ($con_coefvar){
                            if($con_coefvar){                            
                                $pcadena=$pcadena." ,".$pagregado;
                            }else{
                                $pcadena=$pcadena.$pagregado;
                            }                            
                        };                        
                        if($td->tab_fila2){                    
                           $sql_tp="select {$FRASE_TOTAL} as "."pla_".$td->tab_fila1." , {$FRASE_TOTAL} as pla_".$td->tab_fila2." , pla_".$td->tab_columna." ,sum(pla_cantidad) as pla_cantidad "; 
                           $sql_tt="select {$FRASE_TOTAL} as "."pla_".$td->tab_fila1." , {$FRASE_TOTAL} as pla_".$td->tab_fila2." , {$FRASE_TOTAL} as pla_".$td->tab_columna." ,sum(pla_cantidad) as pla_cantidad "; 
                           $sql_tpinter="select {$FRASE_TOTAL} as "."pla_".$td->tab_fila1." , pla_".$td->tab_fila2." , pla_".$td->tab_columna." ,sum(pla_cantidad) as pla_cantidad ";
                           if($con_coefvar){
                               $completa_cadena($sql_tp,$formula_simple);
                               $completa_cadena($sql_tt,$formula_simple);
                               $completa_cadena($sql_tpinter,$sql_tcfvar(letra_zonal_de($td->tab_fila2)."' ,".campo_zonal_de($td->tab_fila2)." ",array("pla_".$td->tab_fila2)));
                           }else{
                               $completa_cadena($sql_tp,$formula_simple);
                               $completa_cadena($sql_tt,$formula_simple);
                               $completa_cadena($sql_tpinter,$formula_simple);
                           }   
                           $sql_tpinter_final=") x "."group by pla_".$td->tab_fila2." ,pla_" .$td->tab_columna."\n union ";
                           $sql_tpinter=$sql_tpinter.$sql_cuerpo.$sql_tpinter_final;
                           $sql_tpinter2="select pla_".$td->tab_fila1." , {$FRASE_TOTAL} as pla_".$td->tab_fila2." , pla_".$td->tab_columna." ,sum(pla_cantidad) as pla_cantidad ";
                           if($con_coefvar){
                               $completa_cadena($sql_tpinter2,$sql_tcfvar(letra_zonal_de($td->tab_fila1)."' ,".campo_zonal_de($td->tab_fila1)." ",array("pla_".$td->tab_fila1)));
                           }else{
                               $completa_cadena($sql_tpinter2,$formula_simple);
                           }     
                           $sql_tpinter2_final=") x "."group by pla_".$td->tab_fila1." ,pla_" .$td->tab_columna."\n union ";
                           $sql_tpinter2=$sql_tpinter2.$sql_cuerpo.$sql_tpinter2_final;
                        }else{
                           if($td->tab_cel_tipo=='frecuencia'){
                               $sql_inicio="select ".preg_replace('#\bselect\b#','',$sql_columnas)." , ";
                               $sql_tp=""; //es una única columna en frecuencias                              
                               $sql_tt=$sql_inicio." {$FRASE_TOTAL}. as "."pla_".$td->tab_fila1." ,sum(pla_cantidad) as pla_cantidad ";
                               if($con_coefvar){
                                   $completa_cadena($sql_tt,$formula_simple);
                               }else{
                                   $completa_cadena($sql_tt,$formula_simple);
                               }
                               if($td->tab_columna=='hog' && $td->tab_cel_exp=='personas'){                 
                                  $sql_tt=preg_replace('#\bpersonas\b#','hogares',$sql_tt); //porque tab_cel_exp en vez de decir hogares dice personas.
                               }
                               if($td->tab_columna=='hog' && $td->tab_cel_exp=='viviendas'){
                                  $sql_tt=preg_replace('#\bviviendas\b#','hogares',$sql_tt); //simulando hasta que nos contesten por los coefvar de viviendas
                               }
                           }else{ 
                               $sql_tp="select {$FRASE_TOTAL} as "."pla_".$td->tab_fila1." , pla_".$td->tab_columna." ,sum(pla_cantidad) as pla_cantidad ";
                               $sql_tt="select {$FRASE_TOTAL} as "."pla_".$td->tab_fila1." , {$FRASE_TOTAL} as pla_".$td->tab_columna." ,sum(pla_cantidad) as pla_cantidad ";
                               if($con_coefvar){
                                   $completa_cadena($sql_tp,$formula_simple);
                                   $completa_cadena($sql_tt,$formula_simple);
                               }else{
                                   $completa_cadena($sql_tp,$formula_simple);
                                   $completa_cadena($sql_tt,$formula_simple);
                               }
                           }
                        }
                        if($td->tab_cel_tipo=='comun'){
                            $sql_tp_final=") x "."group by  pla_".$td->tab_columna."\n UNION ";
                            $sql_tp=$sql_tp.$sql_cuerpo.$sql_tp_final;
                        }
                        $sql_tt_final=") x "."\n UNION ";
                        $sql_tt=$sql_tt.$sql_cuerpo.$sql_tt_final;
                        if($td->tab_fila2){ 
                           $sql_cuerpo=$sql_tt.$sql_tp.$sql_tpinter.$sql_tpinter2.$sql_cuerpo;
                        }else{
                           $sql_cuerpo=$sql_tt.$sql_tp.$sql_cuerpo;
                        }       
                    }
                }
                else{
                   $sql_cuerpo=$sql_cuerpo.implode(',',$campos_select).$junta.
                            "\n WHERE ".$campos_filtro.
                            "\n GROUP BY ".implode(',',$campos_groupby).
                            "\n ORDER BY ".implode(' nulls first,',$campos_groupby).' nulls first';  
                }
            }
        }
        Loguear('2019-09-06','sql tabulado-==== '.var_export($sql_cuerpo,true));
        //Loguear('2016-07-29','decimales '.$DECIMALES);
       // return new Respuesta_Negativa($sql_cuerpo);
        $cursor_cuerpo=$this->db->ejecutar_sql(new Sql($sql_cuerpo, array()));
        $cursor_columnas=$this->db->ejecutar_sql(new Sql($sql_columnas, array()));
        $vpara_titulo=$es_ope_eah_con_modo?($val_modo=='ETOI'?' - Modo '. $val_modo:' - Modo Completo'):'';
        return new Respuesta_Positiva(array(
            'columnas'=>$cursor_columnas->fetchAll(PDO::FETCH_OBJ),
            'cuerpo'=>$cursor_cuerpo->fetchAll(PDO::FETCH_OBJ),
            'campos'=>$campos,
            'titulo'=>$td->tab_tab.' '.$td->tab_titulo.' Ciudad de Buenos Aires. Año '.$GLOBALS['anio_operativo'].$vpara_titulo,  //$vanio_enc, 
            'tipo_totales'=>'totales_internos',
            'modo'=>(/*$this->argumentos->tra_expandido && */$this->argumentos->tra_revisar?'revisar':'final'),
            'modo2'=>(/*$this->argumentos->tra_expandido && */$this->argumentos->tra_revisar2?'revisar':'comun'),
            'modalidad'=>($this->argumentos->tra_modalidad),
            'tipo_tabulado'=>$tabla_tabulados->datos->tab_cel_tipo, 
            'expandido'=>$this->argumentos->tra_expandido?'si':'no',
            'coef_var'=>$con_coefvar,
            'separador_decimal'=>$this->argumentos->tra_separador_decimal,
            'cant_decimales'=>$DECIMALES
        ));
    }
}
?>