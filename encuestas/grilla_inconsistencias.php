<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_inconsistencias extends Grilla_tabla{
    var $var_empa_arr=array();
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="inconsistencias";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_inconsistencias");
        if($GLOBALS['nombre_app'] ==='colon2015'){
            $var_obs_s1='pla_obs';
        }else{
            $var_obs_s1='pla_s1a1_obs';                        
        };
        if($GLOBALS['nombre_app'] ==='ut2015'||$GLOBALS['nombre_app'] ==='ut2016'|| $GLOBALS['nombre_app'] ==='vcm2018' ){
            $var_obs_i1='pla_observ';
        }else{
            $var_obs_i1='pla_obs';
        };    
        
        $this->tabla->campos_lookup=array(
            "coalesce(con_explicacion,coalesce(con_precondicion,'')||coalesce(con_rel,'')||coalesce(con_postcondicion,'')) as explicacion"=>true,
            "inc_falsos_positivos as inc_falsos_positivos"=>false,
            "pla_bolsa   as inc_bolsa"                    =>false,
            "pla_estado  as inc_estado"                   =>false,
            "pla_comuna  as inc_comuna"                   =>false,
            "con_momento as inc_momento"                  =>false,
            "con_modulo  as inc_modulo"                   =>false,
            <<<SQL
              (select comun.esta_palabra_en_texto_despues_de_salta(inc_con, {$var_obs_s1}) as inc_encontrada 
                  from plana_s1_ where inc_enc = pla_enc and pla_hog = 1 
              ) as inc_controlada
SQL
              =>false,
            <<<SQL
             (select case when fori1.conteo>0 then i.{$var_obs_i1} else s.{$var_obs_s1} end 
                from plana_s1_ s
                left join plana_i1_ i on  inc_enc = i.pla_enc and inc_hog=i.pla_hog and inc_mie=i.pla_mie
                left join (select  convar_con,count(*) as conteo
                            from con_var where  convar_for='I1' 
                            group by convar_con
                ) as fori1  on fori1.convar_con=inc_con
                where inc_enc = s.pla_enc and inc_hog=s.pla_hog
             ) as inc_observaciones 
SQL
              =>false
        );
        if (substr($GLOBALS['nombre_app'],0,4) ==='empa'){
            $this->tabla->campos_lookup["pla_sectorb as pla_sectorb"]=false;
            $this->var_empa_arr=array('pla_sectorb');
        }
        if (tiene_rol('procesamiento')){
            $where_agregada="";
            $this->tabla->campos_lookup["pla_comuna as inc_comuna"]=false;
        }else{
            $where_agregada=" and con_momento IS DISTINCT FROM 'Procesamiento' ";
        } 
        $this->tabla->tablas_lookup=array(            
            'consistencias'=>"con_con=inc_con and con_ope=inc_ope $where_agregada",
            'plana_tem_'   =>'pla_enc=inc_enc',
        );
    }
    function campos_solo_lectura(){
        return array_merge(nombres_campos_claves('inc_'), array('inc_variables_y_valores'), $this->var_empa_arr);
    }
    function campos_editables($filtro_para_lectura){
        if (tiene_rol('procesamiento')){
            return array('inc_justificacion', 'inc_obs_consis');
        }else{
            return array('inc_justificacion');
        }
    }
    function campos_a_excluir($filtro_para_lectura){
        return array(
            'inc_ope',
            'inc_autor_justificacion',
            'inc_tlg',
        );  
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function responder_detallar(){
        return false;
    }
    function puede_detallar(){
        return false;
    }
     function campos_a_listar($filtro_para_lectura){
        return array_merge(array(
          'inc_con',        
          'inc_enc',
          'inc_hog',
          'inc_mie',
          'inc_exm',
          'inc_variables_y_valores',
          'inc_justificacion',
          'inc_falsos_positivos',
          'inc_nivel',
          'explicacion',
          'inc_bolsa',
          'inc_estado',
          'inc_comuna'),
          $this->var_empa_arr,
          array(
          'inc_momento',
          'inc_modulo',
          'inc_controlada',
          'inc_observaciones',
          'inc_obs_consis')
        );
    }
    function boton_enviar(){
        return array(
            'leyenda'=>'ir',
            'title'=>'abrir encuesta',
            'proceso'=>'ingresar_encuesta',
            'campos_parametros'=>array('tra_ope'=>$GLOBALS['nombre_app'], 'tra_con'=>null, 'tra_enc'=>null,'tra_hn'=>array('forzar_valor'=>-951)),
            'y_luego'=>'boton_ingresar_encuesta',
        );
    }
}

class Grilla_inconsistencias_todas extends Grilla_inconsistencias{
        function campos_editables($filtro_para_lectura){
        if (tiene_rol('procesamiento')){
            return array('inc_justificacion', 'inc_obs_consis');
        }else{
            return array();
        }
    }

}
?>