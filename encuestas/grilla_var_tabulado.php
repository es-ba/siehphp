<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_var_tabulado extends Grilla_vistas{
    var $nombre_del_objeto_base="i1_";
    function iniciar($base){
        return parent::iniciar('var_tabulado');
    }
    function campos_editables($filtro_para_lectura){
        return array();
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function responder_detallar(){
        return false;
    }
    function permite_grilla_con_este_filtro($o_con_este_filtro){
        return isset($o_con_este_filtro['var_var']) && is_string($o_con_este_filtro['var_var']);
    }
    function obtener_datos($filtro_para_lectura_sin_filtro_manual,$filtro_manual=false){
        global $db;
        $this->vista->fin_de_definicion_estructura=false;
        $variable=$filtro_para_lectura_sin_filtro_manual['var_var'];
        //$destino=
        $this->vista->tra_estado_desde=$filtro_para_lectura_sin_filtro_manual['pla_estado_desde'];
        unset($filtro_para_lectura_sin_filtro_manual['pla_estado_desde']);
        $this->vista->tra_estado_hasta=$filtro_para_lectura_sin_filtro_manual['pla_estado_hasta'];
        unset($filtro_para_lectura_sin_filtro_manual['pla_estado_hasta']);
        $this->vista->pla_agregar_variables=$filtro_para_lectura_sin_filtro_manual['pla_agregar_variables'];
        unset($filtro_para_lectura_sin_filtro_manual['pla_agregar_variables']);
      
        $this->vista->{'var'}=$variable;
        $this->vista->definir_campo("vis_$variable",array('agrupa'=>true,'tipo'=>'entero','origen'=>"coalesce(pla_$variable::text,opc_opc)"));
        $this->vista->definir_campo("vis_etiqueta",array('agrupa'=>true,'tipo'=>'entero','origen'=>"opc_texto"));
        $cur=$db->ejecutar(new Sql(<<<SQL
            SELECT :variables::text as variables, var_conopc, mat_ua as destino
              FROM variables inner join matrices on mat_ope=var_ope and mat_for=var_for and mat_mat=var_mat
              WHERE var_ope=:ope
                AND var_var=:var
SQL
            , array(':ope'=>$GLOBALS['nombre_app'], ':var'=>$variable, ':variables'=>$this->vista->pla_agregar_variables)
        ));
        $datos_var=$cur->fetchObject();
        if($datos_var){
            $variables=expresion_regular_extraer_variables($datos_var->variables);
            $this->vista->destino=$destino=$datos_var->destino;
            $this->vista->conopc=$datos_var->var_conopc;
            loguear('2014-12-20','----------------------variables:'.implode($variables));
            if($variables){
                foreach($variables as $varaux){
                    if($varaux=='enc'){
                        continue;
                    }
                    if($varaux=='enc' or $varaux=='hog' or $varaux=='mie'){
                        $varaux=$varaux.'_';
                    }
                    if($destino!='hog'){ // PROVISORIO porque variables para hogar pueden involucrar variables del individual o de la matriz P
                        $this->vista->definir_campo("vis_$varaux",array('operacion'=>'concato_texto','origen'=>"distinct pla_$varaux::text"));
                        loguear('2014-12-20','----------------------variable definida:'.$varaux);
                    }
                }
            }
        }
        loguear('2014-12-20','----------------------campos:'.json_encode( $this->vista->campos));        
        return parent::obtener_datos($filtro_para_lectura_sin_filtro_manual,$filtro_manual);
    }
}

class Vista_var_tabulado extends Vistas{
    var $var;
    var $conopc;
    var $tra_estado_desde;
    var $tra_estado_hasta;
    function definicion_estructura(){
        $this->definir_campo('vis_casos',array('operacion'=>'cuenta','origen'=>'x.pla_enc_','title'=>'cantidad casos'));
    }
    function leer_varios($filtro_para_lectura){
        $este_filtro=$filtro_para_lectura;
        unset($este_filtro['var_var']);
        return parent::leer_varios($este_filtro);
    }
    function clausula_from(){
        global $db;
        $vcondicion='';
        if(substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']>=2015){
            $vcondicion=($_SESSION['modo_encuesta']=='ETOI')?' and t.pla_rotaci_n_eah=1 ':'';
        } 
        $tablas_especificias="";
        if($this->destino=='mie'){ 
            $tablas_especificias=<<<SQL
                   inner join plana_i1_ i1 on i1.pla_enc=s1.pla_enc and i1.pla_hog=s1.pla_hog 
                   inner join plana_s1_p s1p on i1.pla_enc=s1p.pla_enc and i1.pla_hog=s1p.pla_hog and i1.pla_mie=s1p.pla_mie
SQL;
        }
        if($GLOBALS['NOMBRE_APP']==='same2014' or substr($GLOBALS['NOMBRE_APP'],0,4)==='empa' or substr($GLOBALS['NOMBRE_APP'],0,2)==='ut' ){
            $tablas_hogar="";
        }else{
            $tablas_hogar="inner join plana_a1_ a1 on s1.pla_enc=a1.pla_enc and s1.pla_hog=a1.pla_hog";
        }
        $otras_tablas_hogar="";
        if($GLOBALS['NOMBRE_APP']==='eah2019'){
            $otras_tablas_hogar="left join plana_pmd_ pm on pm.pla_enc=s1.pla_enc and pm.pla_hog=s1.pla_hog";
        }
        return <<<SQL
            (select *, t.pla_enc as pla_enc_, s1.pla_hog as pla_hog_, s1.pla_mie as pla_mie_
                from plana_tem_ t 
                inner join plana_s1_ s1 on t.pla_enc=s1.pla_enc 
                {$tablas_hogar}
                {$otras_tablas_hogar}
                {$tablas_especificias}
                where pla_estado>={$this->tra_estado_desde} and pla_estado<={$this->tra_estado_hasta}{$vcondicion}
            ) x full outer join 
            (select * 
                from opciones 
                where opc_ope='{$GLOBALS['nombre_app']}' and opc_conopc='{$this->conopc}'
            ) z on opc_opc=pla_{$this->var}::text
SQL;

    }
}
?>