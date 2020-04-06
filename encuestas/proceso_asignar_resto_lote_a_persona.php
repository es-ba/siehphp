<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";
class Proceso_asignar_resto_lote_a_enc extends Proceso_asignar_resto_lote_a_per{
    function __construct(){
        $this->inforol=new Info_Rol_Enc();
        parent::__construct();
    }
}
class Proceso_asignar_resto_lote_a_recu extends Proceso_asignar_resto_lote_a_per{
    function __construct(){
        $this->inforol=new Info_Rol_Recu();
        parent::__construct();
    }
}
class Proceso_asignar_resto_lote_a_sup_telefonico extends Proceso_asignar_resto_lote_a_per{
    function __construct(){
        $this->inforol=new Info_Rol_Sup_Telefonico();
        parent::__construct();
    }
}
class Proceso_asignar_resto_lote_a_sup_campo extends Proceso_asignar_resto_lote_a_per{
    function __construct(){
        $this->inforol=new Info_Rol_Sup_Campo();
        parent::__construct();
    }
}
class Proceso_asignar_resto_lote_a_per extends Proceso_Formulario{
    function __construct(){
        $ROL=$this->inforol->sufijo_rol();
        $rol_persona=$this->inforol->rol_persona();
        if($GLOBALS['nombre_app']=='same2014'){
            $para_parametros=array(
                'tra_dominio'=>array('tipo'=>'entero'),
                'tra_replica'=>array('tipo'=>'entero'),
                'tra_comuna'=>array('tipo'=>'entero'),
                'tra_up'=>array('tipo'=>'entero'),
                'tra_lote'=>array('tipo'=>'entero'),
                "tra_cod_{$ROL}"=>array('tipo'=>'entero'),
                "tra_dispositivo_{$ROL}"=>array('tipo'=>'entero'),
                'tra_asignacion_incremental'=>array('type'=>'checkbox','label'=>false,'label-derecho'=>'asigna incrementalmente cuando ya tenga carga (solo para dominios 4 y 5)','def'=>false),        
            );
        }else{
            $para_parametros=array(
                'tra_dominio'=>array('tipo'=>'entero'),
                'tra_replica'=>array('tipo'=>'entero'),
                'tra_comuna'=>array('tipo'=>'entero'),
                'tra_lote'=>array('tipo'=>'entero'),
                "tra_cod_{$ROL}"=>array('tipo'=>'entero'),
                "tra_dispositivo_{$ROL}"=>array('tipo'=>'entero'),
                'tra_asignacion_incremental'=>array('type'=>'checkbox','label'=>false,'label-derecho'=>'asigna incrementalmente cuando ya tenga carga (solo para dominios 4 y 5)','def'=>false),        
            );
        }
        parent::__construct(array(
            'titulo'=>"asignar resto lote al {$rol_persona}",
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'permisos'=>array('grupo'=>'recepcionista'),
            'parametros'=>$para_parametros,
            'bitacora'=>true,
            'boton'=>array('id'=>'asignar'),
        ));
    }
    function responder(){
        $ROL=$this->inforol->sufijo_rol();
        $estados_asignable=$this->inforol->estados_asignable();
        $estados_cargado=$this->inforol->estados_cargado();
        $rol_persona=$this->inforol->rol_persona();
        if(!isset($this->argumentos->{"tra_cod_{$ROL}"}) || $this->argumentos->{"tra_cod_{$ROL}"} ==''){
            return new Respuesta_Negativa("falta el codigo de $rol_persona");
        }
        if(!isset($this->argumentos->{"tra_dispositivo_{$ROL}"}) || $this->argumentos->{"tra_dispositivo_{$ROL}"} ==''){
            return new Respuesta_Negativa("falta ingresar el dispositivo");
        }        
        $forzar_asignacion=$this->argumentos->tra_asignacion_incremental or ($ROL=='sup'); // esto hay que traerlo de la casilla de verificacion del formulario.
        unset($this->argumentos->tra_asignacion_incremental);
        $tabla_plana_tem=$this->nuevo_objeto("Tabla_plana_TEM_");
        $filtro_estados=$estados_cargado?'#='.implode("|=",$estados_cargado):'#<0';
        $para_filtro_verificador_de_asignacion = array(
            'pla_estado'=>$filtro_estados, // debería ser 24 porque solo se puede asignar incrementalemente cuando lo asignado es en papel LLEGAMOS ACA
            "pla_cod_{$ROL}"=>$this->argumentos->{"tra_cod_{$ROL}"},
        );
        $filtro_verificador_de_asignacion=new Filtro_Normal($para_filtro_verificador_de_asignacion);
        $encuestas_asignadas=$tabla_plana_tem->contar_cuantos($filtro_verificador_de_asignacion);
        $filtro_lote=array(
            'pla_dominio'=>$this->argumentos->tra_dominio,
            'pla_replica'=>$this->argumentos->tra_replica,
            'pla_comuna'=>$this->argumentos->tra_comuna,
            'pla_lote'=>$this->argumentos->tra_lote
        );
        if($GLOBALS['nombre_app']=='same2014'){
            $filtro_lote['pla_up']=$this->argumentos->tra_up;
        }
        $tabla_plana_tem->leer_unico($filtro_lote);
        $pla_dominio=$tabla_plana_tem->datos->pla_dominio;
        if($encuestas_asignadas>0){
            //OJO: GENERALIZAR
            if ($forzar_asignacion===true and (($pla_dominio==4 or $pla_dominio==5 or $GLOBALS['NOMBRE_APP']=='ebcp2014') or ($ROL=='sup')) and $this->argumentos->{"tra_dispositivo_{$ROL}"}==2){
            }else{
                $string_forzar_asignacion=json_encode($forzar_asignacion);
                // return new Respuesta_Negativa("la persona ya tiene {$encuestas_asignadas} encuestas cargadas. = ({$string_forzar_asignacion}===true and (({$pla_dominio}==4 or {$pla_dominio}==5) or ({$ROL}=='supr' or {$ROL}=='supe')) and {$this->argumentos->{"tra_dispositivo_{$ROL}"}}==2)");
                return new Respuesta_Negativa("la persona ya tiene {$encuestas_asignadas} encuestas cargadas.");
            }
        }
        $tabla_personal=$this->nuevo_objeto("Tabla_personal");
        $filtro_personal=array(
            'per_ope'=>$GLOBALS['nombre_app'],
            'per_per'=>$this->argumentos->{"tra_cod_{$ROL}"},                
            'per_activo'=>true,                
        );
        $tabla_personal->leer_unico($filtro_personal);
        
        if($tabla_personal->datos->per_rol!=$rol_persona){
            return new Respuesta_Negativa("la persona seleccionada tiene que ser $rol_persona");
        }
        $filtro=cambiar_prefijo($this->argumentos,'tra_','pla_');
        $filtro->{"pla_cod_{$ROL}"}=null;
        unset($filtro->{"pla_cod_{$ROL}"});
        unset($filtro->{"pla_dispositivo_{$ROL}"});
        $filtro->pla_estado='#='.implode("|=",$estados_asignable); 
        //global $es_tele_etoi;
        //$str_tele=$GLOBALS['es_tele_etoi']?'T':'f'; --esta variable era para escribir mensaje en el log
        //Loguear('2017-07-24','** es_tele_etoi '.$GLOBALS['es_tele_etoi']. ' rol '.$ROL );
        //Loguear('2017-07-24','** ASIGNAR es_tele_etoi '.$str_tele. ' rol '.$ROL );
        if ( $GLOBALS['NOMBRE_APP']=='etoi173' && /*$es_tele_etoi */ isset($GLOBALS['es_tele_etoi']) && $GLOBALS['es_tele_etoi'] && $ROL=='enc') {
           if($this->argumentos->{"tra_dispositivo_{$ROL}"}==1){
              $filtro->pla_ent_telefonica=0 ;
           }else{
              $filtro->pla_ent_telefonica=1;  
           }
        } 
        $tabla_plana_tem->leer_varios($filtro);
        $asignadas=0;
        $cuales=array();
        $cod_recepcionista=null;
        $usuario_logueado = usuario_actual(); 
        $tabla_usuarios=$this->nuevo_objeto("Tabla_usuarios");
        $filtro_usuarios=array(
            'usu_usu'=>$usuario_logueado,
        );
        $tabla_usuarios->leer_unico($filtro_usuarios);
        if($tabla_usuarios->datos->usu_rol!='programador'){
            $tabla_personal_logeado=$this->nuevo_objeto("Tabla_personal");
            $filtro_personal_logeado=array(
                'per_ope'=>$GLOBALS['nombre_app'],
                'per_usu'=>$tabla_usuarios->datos->usu_usu,
                'per_activo'=>true,
            );
            $tabla_personal_logeado->leer_unico($filtro_personal_logeado);
            $cod_recepcionista=$tabla_personal_logeado->datos->per_per;
        }
        $campos_valores_update=array(
                "cod_{$ROL}"=>$this->argumentos->{"tra_cod_{$ROL}"}, 
                'recepcionista'=>$cod_recepcionista,
        ); 
        if($this->inforol->puede_usar_DM()){
            $campos_valores_update=array_merge($campos_valores_update,array("dispositivo_{$ROL}"=>$this->argumentos->{"tra_dispositivo_{$ROL}"}));
        }
        while($tabla_plana_tem->obtener_leido()){ 
            $tabla_plana_tem->update_TEM($tabla_plana_tem->datos->pla_enc,$campos_valores_update);
            $cuales[]=$tabla_plana_tem->datos->pla_enc;
            $asignadas++;
        }
        return new Respuesta_Positiva("asignadas $asignadas encuestas: ".implode(', ',$cuales));
    }
}
?>