<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Vista_monitoreo_resumen_norea extends Vistas{
    var $campo_corte="";
    var $campo_corte2="";
    var $campo_corte3="";
    var $solo_encuestador=FALSE;
    function __construct(){
        parent::__construct();
    }
    function definicion_estructura(){
        $para='planificacion';
        $para='campo';
        if($this->solo_encuestador){
            $this->rea_enc="rea_enc";
        }else{
            $this->rea_enc="rea";
        }
        $v_norea='pla_norea';
        $v_rea='pla_rea';
        $NomAPP=$GLOBALS['NOMBRE_APP'];
        $condicion_en_campo = "pla_estado<69";
        $condicion_noacampo = "not $condicion_en_campo and $v_norea=97";
        $operativo_tiene_990=substr($GLOBALS['NOMBRE_APP'],0,4)=='same'?true:false;
        $operativo_tiene_99=substr($GLOBALS['NOMBRE_APP'],0,3)=='vcm'?true:false;
        $operativo_tiene_gh=((substr($GLOBALS['NOMBRE_APP'],0,4)=='etoi' && (int)(substr($GLOBALS['NOMBRE_APP'],4))>=162 && (int)(substr($GLOBALS['nombre_app'],4)) <=172) || (substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']==2016) )?true:false;
        $operativo_tiene_pyg=$GLOBALS['NOMBRE_APP']=='eah2018'?true:false;
        $operativo_tiene_md=$NomAPP=='eah2018'||$NomAPP=='eah2024'?true:false;
        $es_eah2014=$GLOBALS['NOMBRE_APP']=='eah2014'?true:false;
        $operativo_tiene_pmd=($GLOBALS['NOMBRE_APP']=='eah2019' || $GLOBALS['NOMBRE_APP']=='eah2021')?true:false;
        $this->con_campos_auditoria=false;
        $this->definir_esquema('encu');
        if($this->campo_corte){
            if($this->campo_corte=="zona_regsan"){
                $origen_agrup='(case when pla_dominio=3 then
                                          case when pla_comuna in (1,3,4) then 1 
                                               when pla_comuna in (7,8,9) then 2
                                               when pla_comuna in (5,6,10,11,15) then 3
                                               when pla_comuna in (2,12,13,14) then 4
                                               else null end    
                                     else null end)';
            }else{
                $origen_agrup="pla_{$this->campo_corte}";
            }
            $this->definir_campo("v_{$this->campo_corte}"  ,array('agrupa'=>true,'tipo'=>'entero', 'origen'=>"$origen_agrup", 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>true))));
        }else{
            $this->campos_orden=array(1);
            $this->definir_campo('v_total_gral'        ,array('tipo'=>'texto', 'operacion' =>'max', 'origen'=>"'TOTAL'", 'title' =>'TOTAL', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>true))));
        }
        if($this->campo_corte2){
            $this->definir_campo("v_{$this->campo_corte2}"  ,array('agrupa'=>true,'tipo'=>'entero', 'origen'=>"pla_{$this->campo_corte2}", 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>true))));
        }
        if($this->campo_corte3){
            $this->definir_campo("v_{$this->campo_corte3}"  ,array('agrupa'=>true,'tipo'=>'entero', 'origen'=>"pla_{$this->campo_corte3}", 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>true))));
        }
        $this->definir_campo('v_total'                 ,array('tipo'=>'entero', 'operacion' =>'cuenta', 'origen'=>'pla_enc', 'title' =>'Total', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>true))));
        $this->definir_campo('v_todavia_no_salieron'   ,array('tipo'=>'entero', 'operacion' =>'cuenta_true', 'origen'=>"vis_condicion='todavia no salieron'",'title' =>'Todavía no salieron a campo por no estar asignadas','estilo'=>'columna_pura', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>false))));
        $this->definir_campo('v_no_salen_a_campo'      ,array('tipo'=>'entero', 'operacion' =>'cuenta_true', 'origen'=>"vis_condicion='no salen a campo'",'title' =>'No salen a campo','estilo'=>'columna_pura', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>false))));
        $this->definir_campo('v_total_salieron'        ,array('tipo'=>'entero', 'operacion' =>'cuenta_otro', 'total'=>'v_total', 'restan'=>array('v_todavia_no_salieron','v_no_salen_a_campo'), 'title' =>'Total salieron', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>true)))); //CG
        $this->definir_campo('v_en_campo_sin_resultado',array('tipo'=>'entero', 'operacion' =>'cuenta_true', 'origen'=>"vis_condicion='en campo sin resultado'",'title' =>'En campo sin resultado aún', 'estilo'=>'columna_pura', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>false))));
        $this->definir_campo('v_con_resultado'         ,array('tipo'=>'entero', 'operacion' =>'cuenta_otro', 'total'=>'v_total_salieron', 'restan'=>array('v_en_campo_sin_resultado'), 'title' =>'En campo', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>true))));
        $this->definir_campo('v_hogares'               ,array('tipo'=>'entero', 'operacion' =>'sum', 'origen'=>"pla_hog_tot", 'title' =>'hogares', 'invisible'=>$this->es_invisible(array('campo'=>false,'planificacion'=>true))));
        $this->definir_campo('v_poblacion'             ,array('tipo'=>'entero', 'operacion' =>'sum', 'origen'=>"pla_pob_tot", 'title' =>'población', 'invisible'=>$this->es_invisible(array('campo'=>false,'planificacion'=>true))));
        
        if($operativo_tiene_990){
            $this->definir_campo('v_hogar_edad_fuera_rango'   ,array('tipo'=>'entero', 'operacion' =>'cuenta_true', 'origen'=>"vis_condicion='fuera de rango'" , 'title' =>'Hogar con edad fuera de rango', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>false)/*, 'invisible'=>!"$nombre_operativo"*/)));
        }
        if($operativo_tiene_99){
            $this->definir_campo('v_hogar_edad_sexo_fuera_rango'   ,array('tipo'=>'entero', 'operacion' =>'cuenta_true', 'origen'=>"vis_condicion='fuera de rango edad y sexo'" , 'title' =>'Hogar con edad y sexo fuera de rango', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>false)/*, 'invisible'=>!"$nombre_operativo"*/)));
        }
        if($operativo_tiene_gh) {
            $this->definir_campo('v_total_gh'               ,array('tipo'=>'entero', 'operacion' =>'sum', 'origen'=>"pla_gh_tot", 'title' =>'total_gh', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>true))));
        }
        if($operativo_tiene_pyg) {
            $this->definir_campo('v_tiene_pyg'              ,array('tipo'=>'entero', 'operacion' =>'cuenta', 'origen'=>"pla_pyg_tot", 'title' =>'total_pyg', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>true))));
        }
        if($operativo_tiene_md) {
          //  $this->definir_campo('v_total_md'              ,array('tipo'=>'entero', 'operacion' =>'sum', 'origen'=>"pla_md_tot", 'title' =>'total_md', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>true))));
          //  $this->definir_campo('v_porc_md'               ,array('tipo'=>'decimal', 'operacion'=>'tasa', 'minimo_denominador'=>20, 'numerador'=>'v_total_md', 'denominador'=>'v_poblacion', 'title' =>'Porcentaje MD', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>false))));
            $this->definir_campo('v_total_md_resp'          ,array('tipo'=>'entero',  'operacion' =>'sum', 'origen'=>"pla_md_tot", 'title' =>'total_md_resp', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>true))));
            $this->definir_campo('v_porc_md_resp'           ,array('tipo'=>'decimal', 'operacion'=>'tasa', 'minimo_denominador'=>20, 'numerador'=>'v_total_md_resp', 'denominador'=>'v_poblacion', 'title' =>'Porcentaje MD RESP', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>false))));
        }
        if ($operativo_tiene_pmd){
            $this->definir_campo('v_pmd_rea'              ,array('tipo'=>'numero' , 'operacion'=>'sum', 'origen'=>'pla_pmd_tot',  'title' =>'resp_pmd', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>true))));
        }
        $this->definir_campo('v_error_marco'           ,array('tipo'=>'entero', 'operacion' =>'cuenta_true', 'origen'=>"vis_condicion='error marco'", 'title' =>'Error de marco', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>true))));
        $this->definir_campo('v_o_no_encuestables'     ,array('tipo'=>'entero', 'operacion' =>'cuenta_true', 'origen'=>"vis_condicion='otras no encuestables'", 'title' =>'Otras no encuestables', 'invisible'=>$this->es_invisible(array('campo'=>false,'planificacion'=>false))));
        $this->definir_campo('v_no_encuestables'       ,array('tipo'=>'entero', 'operacion' =>'cuenta_true', 'origen'=>"vis_condicion in ('otras no encuestables','error marco','fuera de rango edad y sexo')", 'title' =>'No encuestables', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>true))));
        $this->definir_campo('v_encuestables'          ,array('tipo'=>'entero', 'operacion' =>'cuenta_otro', 'total'=>'v_con_resultado', 'restan'=>array('v_no_encuestables'), 'title' =>'Encuestables (REAS y NOREAS)', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>true))));
        $this->definir_campo('v_ausencias'             ,array('tipo'=>'entero', 'operacion' =>'cuenta_true', 'origen'=>"vis_condicion='ausencia'", 'title' =>'Ausencias', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>false))));
        $this->definir_campo('v_contactados'           ,array('tipo'=>'entero', 'operacion' =>'cuenta_otro', 'total'=>"v_encuestables", 'restan'=>array('v_ausencias'), 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>false))));
        $this->definir_campo('v_rechazo'               ,array('tipo'=>'entero', 'operacion' =>'cuenta_true', 'origen'=>"vis_condicion='rechazo'", 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>false))));
        $this->definir_campo('v_otras_causas'          ,array('tipo'=>'entero', 'operacion' =>'cuenta_true', 'origen'=>"vis_condicion='otras norea'", 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>false))));
        $this->definir_campo('v_rechazo_otras_causas'  ,array('tipo'=>'entero', 'operacion' =>'cuenta_true', 'origen'=>"vis_condicion in ('rechazo', 'otras norea')",'estilo'=>'columna_invisible', /*'invisible'=>true, */'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>false))));
        $this->definir_campo('v_respondentes'          ,array('tipo'=>'entero', 'operacion' =>'cuenta_true', 'origen'=>"vis_condicion='rea'", 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>false))));
        $this->definir_campo('v_otras_condiciones'     ,array('tipo'=>'entero', 'operacion' =>'cuenta_otro', 'total'=>'v_total', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>false)),
        'restan'=>array(
            'v_todavia_no_salieron',
            'v_no_salen_a_campo',
            'v_en_campo_sin_resultado',
            'v_no_encuestables',
            'v_ausencias',
            'v_rechazo',
            'v_otras_causas',
            'v_respondentes',
        )));     
        $this->definir_campo('v_tasa_error_marco'       ,array('tipo'=>'decimal', 'operacion'=>'tasa', 'minimo_denominador'=>20, 'numerador'=>'v_error_marco', 'denominador'=>'v_con_resultado', 'title' =>'Tasa Error Marco', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>false))));
        $this->definir_campo('v_tasa_nenc'              ,array('tipo'=>'decimal', 'operacion'=>'tasa', 'minimo_denominador'=>20, 'numerador'=>'v_no_encuestables', 'denominador'=>'v_con_resultado', 'title' =>'Tasa NoEnc', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>false))));
        $this->definir_campo('v_tasa_ausencia'          ,array('tipo'=>'decimal', 'operacion'=>'tasa', 'minimo_denominador'=>20, 'numerador'=>'v_ausencias', 'denominador'=>'v_encuestables', 'title' =>'Tasa Ausencia', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>false))));
        $this->definir_campo('v_tasa_rechazo_y_otros'   ,array('tipo'=>'decimal', 'operacion'=>'tasa', 'minimo_denominador'=>20, 'numerador'=>'v_rechazo_otras_causas', 'denominador'=>'v_encuestables', 'title' =>'Tasa Rechazo y Otras causas', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>false))));
        $this->definir_campo('v_tasa_resp_efectiva'     ,array('tipo'=>'decimal', 'operacion'=>'tasa', 'minimo_denominador'=>20, 'numerador'=>'v_respondentes', 'denominador'=>'v_con_resultado', 'title' =>'Tasa Respuesta Efectiva', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>false))));
        $this->definir_campo('v_tasa_efectividad'       ,array('tipo'=>'decimal', 'operacion'=>'tasa', 'minimo_denominador'=>20, 'numerador'=>'v_respondentes', 'denominador'=>'v_encuestables', 'title' =>'Tasa Efectividad', 'invisible'=>$this->es_invisible(array('campo'=>true,'planificacion'=>true))));
        if ($es_eah2014){
            $this->definir_campo('v_con_modulo'         ,array('tipo'=>'numero' , 'operacion'=>'cuenta_true', 'origen'=>'v_modulo',  'title' =>'tiene modulo', 'invisible'=>$this->es_invisible(array('campo'=>false,'planificacion'=>true))));
        }
    }   
    function clausula_from(){
        $es_eah2014=$GLOBALS['NOMBRE_APP']=='eah2014'?true:false;
        $rea=$this->rea_enc;
        if($es_eah2014){
            $select='(case when pg.pla_enc is not null then true else false end) v_modulo,';
            $join='left join plana_pg1_m pg on t.pla_enc=pg.pla_enc and pg.pla_hog=1 and pg.pla_mie=0 and pg.pla_exm=1 ';
        } else {
            $select='';
            $join='';
        }  
        return "(select {$select} t.*,
          case when pla_estado<=20 then 'todavia no salieron'
               when pla_no{$rea}=97 then 'no salen a campo'
               when pla_{$rea} is null or pla_estado<25 then 'en campo sin resultado'
               when pla_no{$rea}=990 then 'fuera de rango'
               when pla_no{$rea}=99 then 'fuera de rango edad y sexo'
               when pla_no{$rea} between 61 and 64 then 'error marco'
               when pla_no{$rea} between 11 and 59 and pla_no{$rea}<>18 or pla_no{$rea} in (91,95,96) then 'otras no encuestables'
               when pla_no{$rea} between 71 and 79 then 'ausencia'
               when pla_no{$rea} between 81 and 89 then 'rechazo'
               when pla_no{$rea}>0 then 'otras norea'
               when pla_{$rea} in (1,3,4) then 'rea'
               else 'otras condiciones'
          end as vis_condicion
        from plana_tem_ t {$join}
       ) x";
    }
    function clausula_where_agregada(){
      //  return " and pla_estado is distinct from 98 and pla_estado is distinct from 18 and not(pla_dominio=4 and pla_estado=90)";
        return " and pla_estado >=19 and pla_estado is distinct from 98 and not(pla_dominio=4 and pla_estado=90)"; /* cambio solicitado por Guillermo */
    }   
    function es_invisible($parametros){
        if(tiene_rol('programador')){
            return false;
        }
        if(tiene_rol('mues_campo')||tiene_rol('procesamiento')){
            return !$parametros['planificacion'];
        }
        return !$parametros['campo'];
    }
}
class Vista_monitoreo_resumen_norea_total_enc extends Vista_monitoreo_resumen_norea{
    function __construct(){
        $this->campo_corte="";
        $this->campo_var_resumen="norea_enc";
        parent::__construct();
    }
}

class Vista_monitoreo_resumen_norea_semanal extends Vista_monitoreo_resumen_norea{
    function __construct(){
        $this->campo_corte="semana";
        $this->campo_var_resumen="norea";
        parent::__construct();
    }
}
class Vista_monitoreo_resumen_norea_dominio extends Vista_monitoreo_resumen_norea{
    function __construct(){
        $this->campo_corte="dominio";
        $this->campo_var_resumen="norea";
        parent::__construct();
    }
}
class Vista_monitoreo_resumen_norea_estrato extends Vista_monitoreo_resumen_norea{
    function __construct(){
        $this->campo_corte="estrato";
        $this->campo_var_resumen="norea";
        parent::__construct();
    }
}
class Vista_monitoreo_resumen_norea_zonal extends Vista_monitoreo_resumen_norea{
    function __construct(){
        $this->campo_corte="zona";
        $this->campo_var_resumen="norea";
        parent::__construct();
    }
}
class Vista_monitoreo_resumen_norea_comunal extends Vista_monitoreo_resumen_norea{
    function __construct(){
        $this->campo_corte="comuna";
        $this->campo_var_resumen="norea";
        parent::__construct();
    }
}
class Vista_monitoreo_resumen_norea_area extends Vista_monitoreo_resumen_norea{
    function __construct(){
        $this->campo_corte="area";
        $this->campo_var_resumen="norea";
        parent::__construct();
    }
}
class Vista_monitoreo_resumen_norea_zonal_regsan extends Vista_monitoreo_resumen_norea{
    function __construct(){
        $this->campo_corte="zona_regsan";
        $this->campo_var_resumen="norea";
        parent::__construct();
    }
}

class Vista_monitoreo_resumen_norea_encuestador_enc extends Vista_monitoreo_resumen_norea{
    function __construct(){
        $this->campo_corte="cod_enc";
        $this->campo_var_resumen="norea_enc";
        parent::__construct();
    }
}
class Vista_monitoreo_resumen_norea_encuestador extends Vista_monitoreo_resumen_norea{
    function __construct(){
        $this->campo_corte="cod_enc";
        $this->campo_var_resumen="norea";
        parent::__construct();
    }
}
class Vista_monitoreo_resumen_norea_recuperador extends Vista_monitoreo_resumen_norea{
    function __construct(){
        $this->campo_corte="cod_recu";
        $this->campo_var_resumen="norea";
        parent::__construct();
    }
}
class Vista_monitoreo_resumen_norea_semanal_enc extends Vista_monitoreo_resumen_norea{
    function __construct(){
        $this->campo_corte="semana";
        $this->campo_var_resumen="norea_enc";
        parent::__construct();
    }
}
class Vista_monitoreo_resumen_norea_estrato_enc extends Vista_monitoreo_resumen_norea{
    function __construct(){
        $this->campo_corte="estrato";
        $this->campo_var_resumen="norea_enc";
        parent::__construct();
    }
}

class Vista_monitoreo_resumen_norea_zonal_enc extends Vista_monitoreo_resumen_norea{
    function __construct(){
        $this->campo_corte="zona";
        $this->campo_var_resumen="norea_enc";
        parent::__construct();
    }
}
class Vista_monitoreo_resumen_norea_comunal_enc extends Vista_monitoreo_resumen_norea{
    function __construct(){
        $this->campo_corte="comuna";
        $this->campo_var_resumen="norea_enc";
        parent::__construct();
    }
}
class Vista_monitoreo_resumen_norea_dominio_semana extends Vista_monitoreo_resumen_norea{
    function __construct(){
        $this->campo_corte="dominio";
        $this->campo_corte2="semana";
        $this->campo_var_resumen="norea";
        parent::__construct();
    }
}
class Vista_monitoreo_resumen_norea_semana_area extends Vista_monitoreo_resumen_norea{
    function __construct(){
        $this->campo_corte="semana";
        $this->campo_corte2="area";
        $this->campo_var_resumen="norea";
        parent::__construct();
    }
}

class Vista_monitoreo_resumen_norea_dominio_comuna_semana extends Vista_monitoreo_resumen_norea{
    function __construct(){
        $this->campo_corte="dominio";
        $this->campo_corte2="comuna";
        $this->campo_corte3="semana";
        $this->campo_var_resumen="norea";
        parent::__construct();
    }
}
class Vista_monitoreo_resumen_norea_dominio_estrato extends Vista_monitoreo_resumen_norea{
    function __construct(){
        $this->campo_corte="dominio";
        $this->campo_corte2="estrato";
        $this->campo_var_resumen="norea";
        parent::__construct();
    }
}

?>    