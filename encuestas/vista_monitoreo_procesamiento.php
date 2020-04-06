<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Vista_monitoreo_procesamiento extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('encu');
        $this->definir_campo('replica'              ,array('agrupa'=>true,'tipo'=>'entero', 'origen'=>'replica'));
        $this->definir_campo('comuna'               ,array('agrupa'=>true,'tipo'=>'entero', 'origen'=>'comuna'));       
        $this->definir_campo('resumen_estado'       ,array('agrupa'=>true,'tipo'=>'texto', 'origen'=>'resumen_estado'));
        $this->definir_campo('nombre_estado'        ,array('agrupa'=>true,'tipo'=>'texto', 'origen'=>'nombre_estado'));
        $this->definir_campo('dias_por_pasar'       ,array('agrupa'=>true,'tipo'=>'entero', 'origen'=>'dias_por_pasar'));
        $this->definir_campo('rea'                  ,array('agrupa'=>true,'tipo'=>'texto', 'origen'=>'rea'));
        $this->definir_campo('cantidad_encuestas'   ,array('tipo'=>'entero','operacion'=>'cuenta','origen'=>'*','title'=>'Cantidad de encuestas'));
        $this->definir_campos_orden(array('resumen_estado','replica','dias_por_pasar'));
    }
    function clausula_from(){
        return " (
select pla_enc as encuesta, 
       case when estado<'60' then pla_replica else null::integer end as replica,
       null::integer as comuna,
       case when estado between '21' and '59' then '21..59' else estado end resumen_estado, 
       case when estado between '21' and '59' then 'En campo' else est_nombre end nombre_estado, ".$this->sql_comun_final();;
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'replica',
            'comuna',
            'resumen_estado',
            'nombre_estado',
            'dias_por_pasar',
            'rea',
            'cantidad_encuestas'
             );
        return $campos_solo_lectura;
    }
    function sql_comun_final($sin_dias_por_pasar=false, $limite_rea=69){
        $rta="";
        if($sin_dias_por_pasar){
            $rta.="null::integer as dias_por_pasar,";
        }else{
            $rta.=<<<SQL
           case when estado='69' and pla_rea not in ('0','2') then extract(days from cambio_estado-date_trunc('day',current_timestamp)+(dom_dias_para_fin_campo||' days')::interval)
             else null end as dias_por_pasar,
SQL;
        }
        $rta.=<<<SQL
        date_trunc('day', cambio_estado) as cambio_estado, 
           case when estado<'$limite_rea' then null when pla_rea in ('0','2') then 'NR' when pla_rea is not null then 'rea' else null end as rea
        from encu.plana_tem_ inner join encu.dominio on dom_dom=pla_dominio
        inner join (select res_enc, res_valor as estado, tlg_momento as cambio_estado
                      from encu.respuestas inner join encu.tiempo_logico on res_tlg=tlg_tlg
                      where res_ope='{$GLOBALS['NOMBRE_APP']}'
                        and res_for='TEM'
                        and res_mat=''
                       and res_var='estado') estados on pla_enc=estados.res_enc
         inner join encu.estados e on estados.estado::integer = e.est_est
                     ) as base
SQL;
        return $rta;
    }
}

class Vista_monitoreo_procesamiento_2 extends Vista_monitoreo_procesamiento{
     function clausula_from(){
        return " (
select pla_enc as encuesta, 
       case when estado<'40' then pla_replica else null::integer end as replica,
       case when estado between '40' and '59' then pla_comuna else null::integer end as comuna,
       case when estado between '21' and '39' then '21..39' 
            when estado between '40' and '59' then '40..59' 
            else estado end resumen_estado, 
       case when estado between '21' and '39' then 'En campo'
            when estado between '40' and '59' then 'En supervision'
            else est_nombre end nombre_estado, ".$this->sql_comun_final();
    }
}

class Vista_monitoreo_procesamiento_3 extends Vista_monitoreo_procesamiento{
     function clausula_from(){
        return " (
       select pla_enc as encuesta, 
       null::integer as replica,
       case when estado between '21' and '39' then pla_comuna else null::integer end as comuna,
       case when estado between '21' and '39' then '21..39' 
            when estado between '40' and '59' then '40..59' 
            else estado end resumen_estado, 
       case when estado between '21' and '39' then 'En campo'
            when estado between '40' and '59' then 'En supervision'
            else est_nombre end nombre_estado, ".$this->sql_comun_final();
    }
}

class Vista_monitoreo_procesamiento_4 extends Vista_monitoreo_procesamiento{
    function clausula_from(){
        return " (
        select pla_enc as encuesta, 
          pla_replica as replica,
          null::integer as comuna,
          estado as resumen_estado, 
          est_nombre as nombre_estado, ".$this->sql_comun_final();
    }
}

class Vista_monitoreo_procesamiento_rea extends Vista_monitoreo_procesamiento{
    function clausula_from(){
        return " (
           select pla_enc as encuesta, 
               null::integer as replica,
               null::integer as comuna,
               case when estado::integer<27 then estado 
                    when estado::integer between 27 and 68 then '27..65'
                    when estado::integer>68 then '69..99' end as resumen_estado, 
               case when estado::integer<27 then est_nombre 
                    when estado::integer between 27 and 68 then 'en campo'
                    when estado::integer>68 then 'fin campo, en espera y en procesamiento'
               end as nombre_estado, ".$this->sql_comun_final(true,27);
    }
}

?>