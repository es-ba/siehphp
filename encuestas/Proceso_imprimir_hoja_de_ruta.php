<?php
//UTF-8:SÍ

//recorre tem
require_once "lo_imprescindible.php";
require_once "procesos.php";

function periodicidad($p_rotacion_etoi, $p_dominio){
    if($p_dominio==3){
        switch(substr($GLOBALS['NOMBRE_APP'],0,3)){
            case 'eah': 
                if ($GLOBALS['anio_operativo'] >='2014'){
                    if($p_rotacion_etoi== 4){
                        return 'A';
                    }else{
                        return 'T';
                    } 
                }else{
                    return null;
                };
                break;
            case 'eto': 
                return 'T';
                break;
            default:    
                return null;
        }
    }else{
        return null;
    }    
};

class Proceso_imprimir_hoja_de_ruta extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Imprimir hoja de ruta',
            'submenu'=>'campo',
            'permisos'=>array('grupo'=>'subcoor_campo','grupo1'=>'recepcionista'),
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_sufijo_rol' =>array('invisible'=>true,'tipo'=>'texto','label'=>'Rol de la persona','def'=>'enc'),//YA NO SE USA
                'tra_cod_per' =>array('tipo'=>'entero','label'=>'Número de persona'),
            ),
            'boton'=>array('id'=>'imprimir'),
        ));
    }
    function imprimir(){
        $dias_semana=array(
            0=>'Domingo',
            1=>'Lunes',
            2=>'Martes',
            3=>'Miércoles',
            4=>'Jueves',
            5=>'Viernes',
            6=>'Sábado',
        );
        $meses=array(
            1=>'Enero',
            2=>'Febrero',
            3=>'Marzo',
            4=>'Abril',
            5=>'Mayo',
            6=>'Junio',
            7=>'Julio',
            8=>'Agosto',
            9=>'Setiembre',
            10=>'Octubre',
            11=>'Noviembre',
            12=>'Diciembre',
        );
        global $hoy;
        $numero_carga=null;
        $rol_texto = '';
        $this->inforol=Info_Rol::a_partir_de_sufijo($this->argumentos->tra_sufijo_rol);
        $rol_texto=$this->inforol->rol_persona();
        $rol_texto.=' '.$this->argumentos->tra_cod_per;
        $this->argumentos->tra_ope=$GLOBALS['NOMBRE_APP'];
        $anio=$GLOBALS['anio_operativo'];
        if (isset($GLOBALS['trimestre_operativo'])){
            $trimestre=$GLOBALS['trimestre_operativo'];
        }else{
            $trimestre='';
        }
        $this->salida->abrir_grupo_interno('tabla_remito_enc',array('tipo'=>'table','border'=>'none'));
            $this->salida->abrir_grupo_interno('',array('tipo'=>'tr'));
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td','rowspan'=>2,'style'=>'width:90px')); 
                    //$this->salida->enviar_imagen('../imagenes/logo_etoi143.png','',array('style'=>'width:130px'));
                    $this->salida->enviar($GLOBALS['NOMBRE_APP']); // hasta que esté el logo
                $this->salida->cerrar_grupo_interno();
                $this->salida->enviar('','',array('tipo'=>'td'));
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                    $this->salida->enviar('HOJA DE RUTA');
                $this->salida->cerrar_grupo_interno();
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                $this->salida->enviar($rol_texto);
                $tabla_personal=$this->nuevo_objeto('Tabla_personal');
                $tabla_personal->leer_unico(array(
                    'per_ope'=>$GLOBALS['NOMBRE_APP'],
                    'per_per'=>$this->argumentos->tra_cod_per,
                    'per_activo'=>'true',                    
                ));
                $nombre_y_apellido_persona=$tabla_personal->datos->per_nombre.' '.$tabla_personal->datos->per_apellido;
                $this->salida->enviar($nombre_y_apellido_persona);
                $this->salida->cerrar_grupo_interno();
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                $this->salida->cerrar_grupo_interno();
            $this->salida->cerrar_grupo_interno();
            $this->salida->abrir_grupo_interno('',array('tipo'=>'tr'));
                $this->salida->enviar('','',array('tipo'=>'td'));
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                    if(isset($GLOBALS['trimestre_operativo'])){
                        $this->salida->enviar('Año '.$anio.$GLOBALS['trimestre_operativo']?' Trimestre '.$trimestre:'','',array('style'=>'font-size:80%')); // generalizar
                    }
                $this->salida->cerrar_grupo_interno();
                $this->salida->enviar('','',array('tipo'=>'td'));
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td'));
                    Loguear('2014-10-06','***************** por poner HOY');
                    Loguear('2014-10-06','*****************'.$hoy->format('d/m/Y'));
                    $this->salida->enviar($hoy->format('d/m/Y'));
                $this->salida->cerrar_grupo_interno();
            $this->salida->cerrar_grupo_interno();
        $this->salida->cerrar_grupo_interno();
        $tabla_operativos=$this->nuevo_objeto('Tabla_operativos');
        $tabla_operativos->leer_unico(array(
            'ope_ope'=>$GLOBALS['NOMBRE_APP']
        ));
        $tabla_respuestas=$this->nuevo_objeto('Tabla_respuestas');        
        $tabla_tem=$this->nuevo_objeto('Tabla_plana_TEM_');
        $tabla_anoenc=$this->nuevo_objeto('Tabla_anoenc');
        $sufijo_rol=$this->inforol->sufijo_rol();
        $tabla_tem->definir_campos_orden(array("pla_dispositivo_{$sufijo_rol}",'pla_areaup','pla_cnombre','pla_hn','pla_hp','pla_hd','pla_hab'));
        $filtro_para_tem=new Filtro_OR(array(
                array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>22,
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>23,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>24,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>32,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>33,
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>34,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>42,
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>43,
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>44,
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>45,
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>46,
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>52,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>53,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>54,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>55,                
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>56,                
                )
        ));
        if(@$this->argumentos->tra_carga){
                $filtro_para_tem = array_merge($filtro_para_tem, array('pla_carga'=>$this->argumentos->tra_carga));
        }
        
        $tabla_tem->leer_varios($filtro_para_tem);
        $columnas=$this->obtenerColumnas();
        $alineacion=array('Número'=>'derecha','Piso'=>'derecha','Área'=>'derecha');
        $this->salida->abrir_grupo_interno('tabla_remito',array('tipo'=>'table'));
            $this->salida->abrir_grupo_interno('',array('tipo'=>'tr'));
                foreach($columnas as $titulo=>$definicionGeneral){
                    if(!@$definicionGeneral['otro_renglon']){
                        $this->salida->enviar($titulo,'',array('tipo'=>'th'));
                    }
                }
            $this->salida->cerrar_grupo_interno();
            $cuenta_encuestas=0;
            $this->semanas= array();
            while($tabla_tem->obtener_leido()){
                if(!in_array($tabla_tem->datos->pla_semana,$this->semanas)){
                    $this->semanas[]=$tabla_tem->datos->pla_semana;    
                }
                $cuenta_encuestas++;
                $this->salida->abrir_grupo_interno('tabla_remito_fila',array('tipo'=>'tr'));
                    foreach($columnas as $titulo=>$definicionGeneral){
                        $definicion=$definicionGeneral['campos'];
                        $i=0;
                        do{
                            if(@$definicionGeneral['otro_renglon']){
                                $es_obs_ant=true;
                                $dato_obs_ant=array();
                                $cursor_ope=$this->db->ejecutar_sql(new Sql(<<<SQL
                                        select  string_agg(
                                        ope_ope_anterior,
                                        ',' order by ope_ope) as resultado
                                        from encu.operativos;
SQL
                                ,array(
                                )));
                                $datos_ope=$cursor_ope->fetchObject();
                                $dato_ope=$datos_ope->resultado; 
                                $array_dato_ope=explode(',',$dato_ope);
                                array_push($array_dato_ope, $GLOBALS['NOMBRE_APP']);
                                foreach( $array_dato_ope as $operativo){
                                    $tabla_respuestas->leer_uno_si_hay(array(
                                        'res_ope'=>$operativo,
                                        'res_enc'=>$tabla_tem->datos->pla_enc,
                                        'res_var'=>'s1a1_obs',                                    
                                    )); 
                                    if($tabla_respuestas->obtener_leido() && $tabla_respuestas->datos->res_valor){
                                        if($operativo!=$GLOBALS['NOMBRE_APP'] && substr($GLOBALS['NOMBRE_APP'],0,3)=='eah' AND $anio >='2015'){                                             
                                            if(periodicidad($tabla_tem->datos->pla_rotaci_n_etoi, $tabla_tem->datos->pla_dominio)=='A'){
                                                $operativo='eah'.(intval($anio)-substr($operativo,strlen($operativo)-1,1));
                                            }else{
                                                $vtrim=(substr($operativo,strlen($operativo)-1,1)=='1')?'3':'2';
                                                $operativo='etoi'.substr($anio,2,2).$vtrim;
                                            }
                                        }
                                        $dato_obs_ant[]=$operativo.": ".$tabla_respuestas->datos->res_valor;
                                    }
                                }
                                $para_telefonos='';
                                $tabla_respuestas->leer_varios(array(
                                    'res_ope'=>$tabla_operativos->datos->ope_ope_anterior,
                                    'res_enc'=>$tabla_tem->datos->pla_enc, 
                                    'res_for'=>'A1',
                                    'res_var'=>'telefono',
                                ));
                                while($tabla_respuestas->obtener_leido()){
                                    if($tabla_respuestas->datos->res_valor){
                                        $para_telefonos.=$tabla_respuestas->datos->res_hog<>1?(' Hog. '.$tabla_respuestas->datos->res_hog.': '):'';
                                        $para_telefonos.=' '.$tabla_respuestas->datos->res_valor;
                                    }
                                }
                                $tabla_respuestas->leer_varios(array(
                                    'res_ope'=>$tabla_operativos->datos->ope_ope_anterior,
                                    'res_enc'=>$tabla_tem->datos->pla_enc, 
                                    'res_for'=>'A1',
                                    'res_var'=>'movil',
                                ));
                                while($tabla_respuestas->obtener_leido()){
                                    if($tabla_respuestas->datos->res_valor){
                                        $para_telefonos.=' móvil '.$tabla_respuestas->datos->res_valor;
                                    }
                                }                                
                                if($para_telefonos!=''){
                                    $dato_obs_ant[]='Telefono/s:'.$para_telefonos;
                                }
                                $para_respondentes='';
                                $tabla_respuestas->leer_varios(array(
                                    'res_ope'=>$tabla_operativos->datos->ope_ope_anterior,
                                    'res_enc'=>$tabla_tem->datos->pla_enc, 
                                    'res_for'=>'S1',
                                    'res_var'=>'nombrer',
                                ));
                                $respondente_por_hogar= Array();
                                while($tabla_respuestas->obtener_leido()){
                                    if($tabla_respuestas->datos->res_valor){
                                        $respondente_por_hogar[$tabla_respuestas->datos->res_hog]=$tabla_respuestas->datos->res_valor; 
                                    }else{
                                        $respondente_por_hogar[$tabla_respuestas->datos->res_hog]=' ';
                                    }
                                }
                                foreach($respondente_por_hogar as $hogar=>$respondente){
                                    if($respondente==' '){ // lo busco en S1P por respond del S1
                                        $tabla_respuestas->leer_uno_si_hay(array(
                                            'res_ope'=>$tabla_operativos->datos->ope_ope_anterior,
                                            'res_enc'=>$tabla_tem->datos->pla_enc,
                                            'res_hog'=>$hogar,
                                            'res_for'=>'S1',
                                            'res_var'=>'respond',
                                        ));
                                        if($tabla_respuestas->obtener_leido() && $tabla_respuestas->datos->res_valor){
                                            $tabla_respuestas->leer_uno_si_hay(array(
                                                'res_ope'=>$tabla_operativos->datos->ope_ope_anterior,
                                                'res_enc'=>$tabla_tem->datos->pla_enc, 
                                                'res_for'=>'S1',
                                                'res_mat'=>'P',
                                                'res_hog'=>$hogar,
                                                'res_mie'=>$tabla_respuestas->datos->res_valor,
                                                'res_var'=>'nombre',
                                            )); 
                                            if($tabla_respuestas->obtener_leido()){
                                                $respondente_por_hogar[$tabla_respuestas->datos->res_hog]=$tabla_respuestas->datos->res_valor;
                                            }else{ // busco nombre del miembro 1 del hogar
                                                $tabla_respuestas->leer_uno_si_hay(array(
                                                    'res_ope'=>$tabla_operativos->datos->ope_ope_anterior,
                                                    'res_enc'=>$tabla_tem->datos->pla_enc, 
                                                    'res_for'=>'S1',
                                                    'res_mat'=>'P',
                                                    'res_hog'=>$hogar,
                                                    'res_mie'=>1,
                                                    'res_var'=>'nombre',
                                                ));
                                                if($tabla_respuestas->obtener_leido()){ 
                                                    $respondente_por_hogar[$tabla_respuestas->datos->res_hog]=$tabla_respuestas->datos->res_valor;
                                                }
                                            }
                                        }else{ // busco nombre  del miembro 1 del hogar
                                            $tabla_respuestas->leer_uno_si_hay(array(
                                                'res_ope'=>$tabla_operativos->datos->ope_ope_anterior,
                                                'res_enc'=>$tabla_tem->datos->pla_enc, 
                                                'res_for'=>'S1',
                                                'res_mat'=>'P',
                                                'res_hog'=>$hogar,
                                                'res_mie'=>1,
                                                'res_var'=>'nombre',
                                            ));
                                            if($tabla_respuestas->obtener_leido()){ 
                                                $respondente_por_hogar[$tabla_respuestas->datos->res_hog]=$tabla_respuestas->datos->res_valor;
                                            }
                                        }
                                    }
                                }
                                foreach($respondente_por_hogar as $hogar=>$respondente){
                                    if($respondente!=' '){
                                        $para_respondentes.=$hogar<>1?' - Hog. '.$hogar.': ':'';
                                        $para_respondentes.=' '.$respondente;
                                    }
                                }
                                if($para_respondentes!=''){
                                    $ope_anterior=$tabla_operativos->datos->ope_ope_anterior;
                                    $vope_ant=$ope_anterior;
                                    if(substr($GLOBALS['NOMBRE_APP'],0,3)=='eah' AND $anio >='2015'){
                                        if(periodicidad($tabla_tem->datos->pla_rotaci_n_etoi,$tabla_tem->datos->pla_dominio)=='A'){
                                            $vope_ant='eah'.(intval($anio)-1);
                                        }else{
                                            $vope_ant='etoi'.substr($anio,2,2).'3';
                                        }
                                    }
                                    $dato_obs_ant[]="Respondente/s $vope_ant:".$para_respondentes;
                                }
                                $tabla_anoenc->leer_varios(array(
                                    'anoenc_ope'=>$tabla_operativos->datos->ope_ope_anterior,
                                    'anoenc_enc'=>$tabla_tem->datos->pla_enc,
                                ));
                                $para_visitas='';
                                while($tabla_anoenc->obtener_leido()){
                                    $para_visitas.=' '.$tabla_anoenc->datos->anoenc_anotacion.' ('.$tabla_anoenc->datos->anoenc_fecha.' '.$tabla_anoenc->datos->anoenc_hora.')';
                                }
                                if($para_visitas!=''){
                                    $dato_obs_ant[]='Visita/s:'.$para_visitas;
                                }
                                if(count($dato_obs_ant)>0){
                                    $this->salida->abrir_grupo_interno('tabla_remito_obs_ant',array('tipo'=>'tr'));
                                    $this->salida->enviar('observaciones '.implode(' / ',$dato_obs_ant),'',array('tipo'=>'td','colspan'=>'99'));
                                    $this->salida->cerrar_grupo_interno();
                                }
                            }else if($definicion[$i]=='enc_rec'){
                                if($tabla_tem->datos->pla_cod_recu){
                                    $dato='R '.$tabla_tem->datos->pla_cod_recu;
                                }else{
                                    $dato='E '.$tabla_tem->datos->pla_cod_enc;
                                }                                
                            }else if($definicion[$i]=='rea_sup'){
                                $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
                                        select  string_agg(
                                        case when pla_entrea in (1,3) then 'REA' else 'NOREA '||coalesce(pla_razon1,0)
                                        ||coalesce(pla_razon2_1::text,'')
                                        ||coalesce(pla_razon2_2::text,'')
                                        ||coalesce(pla_razon2_3::text,'')
                                        ||coalesce(pla_razon2_4::text,'')
                                        end,
                                        ',' order by pla_hog) as resultado
                                        from encu.plana_s1_
                                        where pla_enc=:tra_enc
SQL
                                ,array(
                                    ':tra_enc'=>$tabla_tem->datos->pla_enc,
                                )));                                    
                                $datos=$cursor->fetchObject();
                                $dato=$datos->resultado;                                
                            }else if($definicion[$i]=='hog_mie'){                                
                                $cursor_hog=$this->db->ejecutar_sql(new Sql(<<<SQL
                                        select  string_agg(
                                        pla_hog::text,
                                        ',' order by pla_hog) as resultado
                                        from encu.plana_s1_
                                        where pla_enc=:tra_enc;
SQL
                                ,array(
                                    ':tra_enc'=>$tabla_tem->datos->pla_enc,
                                )));
                                $datos_hog=$cursor_hog->fetchObject();
                                $dato_hog=$datos_hog->resultado;                          
                                $array_dato_hog=explode(',',$dato_hog);
                                
                                $cursor_mie=$this->db->ejecutar_sql(new Sql(<<<SQL
                                        select  string_agg(
                                        pla_mie::text,
                                        ',' order by pla_hog) as resultado
                                        from encu.plana_i1_
                                        where pla_enc=:tra_enc;
SQL
                                ,array(
                                    ':tra_enc'=>$tabla_tem->datos->pla_enc,
                                )));
                                $datos_mie=$cursor_mie->fetchObject();
                                $dato_mie=$datos_mie->resultado;                          
                                $array_dato_mie=explode(',',$dato_mie);
                                $n=0;
                                $dato_hogar_mie='';
                                foreach($array_dato_hog as $cada_hog){
                                    if ($n>0) $dato_hogar_mie=$dato_hogar_mie.',';
                                    $dato_hogar_mie=$dato_hogar_mie.$cada_hog;
                                    if ($array_dato_mie[$n]){
                                        $dato_hogar_mie=$dato_hogar_mie.'('.$array_dato_mie[$n].')';
                                    };         
                                    $n++;
                                }
                                $dato=$dato_hogar_mie;                                
                            }else if($definicion[$i]=='tipo_sup'){                                
                                $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
                                        select 
                                        case when pla_sup_aleat =3 then 'aleat. presencial' else 
                                        case when pla_sup_aleat =4 then 'aleat. telefónica' else 
                                        case when pla_sup_dirigida =3 then 'dirig. presencial' else 
                                        case when pla_sup_dirigida =4 then 'dirig. telefónica' else 
                                        null end end end end as resultado
                                        from encu.plana_tem_ 
                                        where pla_enc=:tra_enc;
SQL
                                ,array(
                                    ':tra_enc'=>$tabla_tem->datos->pla_enc,
                                )));
                                $datos=$cursor->fetchObject();
                                $dato=$datos->resultado;                          
                            }else if($definicion[$i]=='respondente'){                                
                                $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
                                        select coalesce(pla_nombrer,'-') as resultado from encu.plana_s1_ 
                                        where pla_enc=:tra_enc;
SQL
                                ,array(
                                    ':tra_enc'=>$tabla_tem->datos->pla_enc,
                                )));
                                $datos=$cursor->fetchObject();
                                $dato=$datos->resultado;                                                          
                            }else if($definicion[$i]=='telefono'){
                                if(strtolower(substr($GLOBALS['NOMBRE_APP'],0,4))=='same'  ){
                                    $sentencia_select='tel1';
                                    $sentencia_from='left join encu.plana_i1_ i1 on t.pla_enc=i1.pla_enc';
                                }elseif( strtolower(substr($GLOBALS['NOMBRE_APP'],0,2))=='ut' || strtolower($GLOBALS['NOMBRE_APP']=='vcm2018') ) {
                                    $sentencia_select='coalesce(pla_tel1,pla_tel2)';
                                    $sentencia_from='';
                                }
                                else{                                
                                    $sentencia_select=" trim(coalesce (pla_telefono, '') || ' ' || coalesce (pla_movil, '')) ";
                                    $sentencia_from='left join encu.plana_a1_ a1 on t.pla_enc=a1.pla_enc';
                                }
                                
                                $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
                                    select $sentencia_select as resultado 
                                    from encu.plana_tem_ t left join encu.plana_s1_ s1 on t.pla_enc=s1.pla_enc
                                    $sentencia_from
                                    where t.pla_enc=:tra_enc;
SQL
                                ,array(
                                    ':tra_enc'=>$tabla_tem->datos->pla_enc,
                                )));                                
                                $datos=$cursor->fetchObject();
                                $dato=$datos->resultado;                                                          
                            }else if($definicion[$i]=='enc_period'){
                                $dato=periodicidad($tabla_tem->datos->pla_rotaci_n_etoi,$tabla_tem->datos->pla_dominio);                               
                            }else{
                                $es_obs_ant=false;
                                $dato=$tabla_tem->datos->{$definicion[$i]};
                            }                                    
                            if($definicion[$i]=='pla_cnombre'){
                                $es_pla_cnombre=true; 
                                $mostrar_cnombre=$tabla_tem->datos->pla_cnombre;
                            }else{
                                $es_pla_cnombre=false;
                            }
                            if($definicion[$i]=='pla_barrio'){
                                $es_pla_barrio=true; 
                                $mostrar_barrio=$tabla_tem->datos->pla_barrio;
                            }else{
                                $es_pla_barrio=false;
                            }
                            if($definicion[$i]=='pla_ident_edif'){
                                $es_pla_ident_edif=true;
                                $mostrar_ident_edif    =$tabla_tem->datos->pla_ident_edif;
                            }else{
                                $es_pla_ident_edif=false;
                            }
                            if($definicion[$i]=='pla_edificio'){
                                $es_pla_edificio=true;
                                $existe_ident_edif=!(is_null($tabla_tem->datos->pla_ident_edif))&&is_null($tabla_tem->datos->pla_edificio)?$tabla_tem->datos->pla_ident_edif:'';
                                $mostrar_edificio =$tabla_tem->datos->pla_sector.' '.$tabla_tem->datos->pla_edificio.' '.$tabla_tem->datos->pla_entrada.' '.$existe_ident_edif;
                            }else{
                                $es_pla_edificio=false;
                            }
                            if($definicion[$i]=='pla_obs'){
                                $es_pla_obs=true; 
                                $mostrar_obs=$tabla_tem->datos->pla_obs;
                            }else{
                                $es_pla_obs=false;
                            }
                            if ($definicion[$i]=='pla_dispositivo_enc'){
                                $dato=$tabla_tem->datos->pla_dispositivo_enc==1?'DM':'P';                                
                            }
                            $i++;
                        }while($i<count($definicion) && !$dato);
                        if(isset($valores_anteriores[$titulo]) && $valores_anteriores[$titulo]==$dato){
                            $clase='tabla_remito_celda_vacia';
                            $dato_a_mostrar='';
                        }elseif($es_pla_cnombre){
                            $clase='tabla_remito_cnombre15';    
                            $dato_a_mostrar=$mostrar_cnombre;
                        }elseif($es_pla_barrio){
                            $clase='tabla_remito_barrio15';    
                            $dato_a_mostrar=$mostrar_barrio;                            
                        }elseif($es_pla_ident_edif){
                            $clase='tabla_remito_ident_edif15';
                            $dato_a_mostrar=$mostrar_ident_edif;
                        }elseif($es_pla_edificio){
                            $clase='tabla_remito_edificio15';
                            $dato_a_mostrar=$mostrar_edificio;
                        }elseif($es_pla_obs){
                            $clase='tabla_remito_obs15';
                            $dato_a_mostrar=$mostrar_obs;
                        }else{
                            $clase='tabla_remito_td';
                            $dato_a_mostrar=$dato;
                            if(isset($valores_anteriores[$titulo])){
                                $valores_anteriores[$titulo]=$dato;
                            }
                        }
                        $dato_a_mostrar=''.$dato_a_mostrar;
                        $clase.=@(' '.$alineacion[$titulo]);
                        if(!$es_obs_ant){                            
                            $this->salida->enviar($dato_a_mostrar,$clase,array('tipo'=>'td'));                            
                        }
                    }
                $this->salida->cerrar_grupo_interno();
            }
        $this->salida->cerrar_grupo_interno();
        $this->salida->abrir_grupo_interno('tabla_remito_enc',array('tipo'=>'table'));
            $this->salida->abrir_grupo_interno('tabla_remito_totales',array('tipo'=>'tr'));
                $this->salida->enviar('Cantidad total de encuestas: '.$cuenta_encuestas,'',array('tipo'=>'th'));
            $this->salida->cerrar_grupo_interno();
        $this->salida->cerrar_grupo_interno();
        $columnas_semanas=array(
            'numero'         =>array('origen'=>'sem_sem','formato'=>'ninguno','texto'=>'número'),
            'rdes'           =>array('origen'=>'sem_semana_referencia_desde','formato'=>'fecha','texto'=>'desde'),
            'rhas'           =>array('origen'=>'sem_semana_referencia_hasta','formato'=>'fecha','texto'=>'hasta'),
            'des30'          =>array('origen'=>'sem_30dias_referencia_desde','formato'=>'fecha','texto'=>'desde'),
            'has30'          =>array('origen'=>'sem_30dias_referencia_hasta','formato'=>'fecha','texto'=>'hasta'),            
            'ref'            =>array('origen'=>'sem_mes_referencia','formato'=>'mes','texto'=>'referencia'),
        );
        $this->salida->abrir_grupo_interno('tabla_remito_enc',array('tipo'=>'table'));
            $this->salida->abrir_grupo_interno('tabla_remito_fila',array('tipo'=>'tr','style'=>'font-weight:bold'));
                $this->salida->enviar('Semana','',array('tipo'=>'td','colspan'=>1));
                $this->salida->enviar('Semana de referencia','',array('tipo'=>'td','colspan'=>2));
                $this->salida->enviar('30 días de referencia','',array('tipo'=>'td','colspan'=>2));
                $this->salida->enviar('Mes de','',array('tipo'=>'td','colspan'=>1));
            $this->salida->cerrar_grupo_interno();
            $this->salida->abrir_grupo_interno('tabla_remito_fila',array('tipo'=>'tr'));
                foreach($columnas_semanas as $titulo=>$definicion){
                    $this->salida->enviar($definicion['texto'],'',array('tipo'=>'td','colspan'=>1,'style'=>'font-weight:bold'));
                }
            $this->salida->cerrar_grupo_interno(); 
            setlocale(LC_TIME,'es_AR');
            $clase_semana='tabla_remito_td.izquierda';
                $tabla_semanas=$this->nuevo_objeto('Tabla_semanas'); 
                sort($this->semanas,SORT_NUMERIC);
                foreach($this->semanas as $una_semana){
                    $this->salida->abrir_grupo_interno('tabla_remito_fila',array('tipo'=>'tr'));
                    $tabla_semanas->leer_unico(array(
                                'sem_ope'=>$GLOBALS['NOMBRE_APP'],
                                'sem_sem'=>$una_semana
                    )); 
                    $tabla_semanas->datos=(array)$tabla_semanas->datos;
                    foreach($columnas_semanas as $titulo=>$definicion){
                        $texto=$tabla_semanas->datos[$definicion['origen']];
                        if($definicion['formato']=='fecha'){
                            $tmp=strtotime($tabla_semanas->datos[$definicion['origen']]);
                            $fecha_en_array = getdate($tmp);
                            $texto=$dias_semana[$fecha_en_array['wday']].' '.$fecha_en_array['mday'].' de '.$meses[$fecha_en_array['mon']];
                        }else if($definicion['formato']=='mes'){
                            $tmp=strtotime($tabla_semanas->datos[$definicion['origen']]);
                            $fecha_en_array = getdate($tmp);
                            $texto=$meses[$fecha_en_array['mon']];                       
                        }
                        $this->salida->enviar(' '.$texto,$clase_semana,array('tipo'=>'td'));
                    } 
                    $this->salida->cerrar_grupo_interno(); 
                }
        $this->salida->cerrar_grupo_interno();
        $str=<<<JS
            var cssPagedMedia = (function () {
                var style = document.createElement('style');
                document.head.appendChild(style);
                return function (rule) {
                    style.innerHTML = rule;
                };
            }());
cssPagedMedia.size = function (size) {
    cssPagedMedia('@page {size: ' + size + '}');
};
cssPagedMedia.size('landscape');
window.print();
            
JS;
        $this->salida->enviar_script($str); 
    }
/*    
    public function obtenerColumnas(){
        $sufijo_rol=$this->inforol->sufijo_rol();
        $columnas=array(
            'Disp'                       =>array('campos'=>array("pla_dispositivo_{$sufijo_rol}")),
            'Com'                        =>array('campos'=>array('pla_comuna')),
            'Área'                       =>array('campos'=>array('pla_area')),
            'Encuesta'                   =>array('campos'=>array('pla_enc')),
            'Sem'                        =>array('campos'=>array('pla_semana')),            
            'Calle'                      =>array('campos'=>array('pla_cnombre')),
            'Número'                     =>array('campos'=>array('pla_hn')), 
            'Piso'                       =>array('campos'=>array('pla_hp')), 
            'Depto'                      =>array('campos'=>array('pla_hd')), 
            'Hab'                        =>array('campos'=>array('pla_hab')),
            'Barrio'                     =>array('campos'=>array('pla_barrio')),
            'Ident Edificio'             =>array('campos'=>array('pla_ident_edif')),
            'Edificio'                   =>array('campos'=>array('pla_edificio')),
            'REA'                        =>array('campos'=>array('pla_rea')),             
            'NoREA'                      =>array('campos'=>array('pla_norea')), 
            'Cod.Enc Cod.Rec'            =>array('campos'=>array('enc_rec')), 
            'Observaciones'              =>array('campos'=>array('pla_obs')), 
            'Observaciones año anterior' =>array('campos'=>array('obs_ant'),'otro_renglon'=>true), 
        );
        return $columnas;     
    }
*/
}
?>