<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_varcal_tabulado extends Grilla_vistas{
    var $nombre_del_objeto_base="i1_";
    function iniciar($base){
        return parent::iniciar('varcal_tabulado');
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
        return isset($o_con_este_filtro['varcal_varcal']) && is_string($o_con_este_filtro['varcal_varcal']);
    }
    function obtener_datos($filtro_para_lectura_sin_filtro_manual,$filtro_manual=false){
        global $db;
        $this->vista->fin_de_definicion_estructura=false;
        $variable=$filtro_para_lectura_sin_filtro_manual['varcal_varcal'];
        //$destino=
        $this->vista->tra_estado=$filtro_para_lectura_sin_filtro_manual['pla_estado'];
        $this->vista->tra_estado_hasta=$filtro_para_lectura_sin_filtro_manual['pla_estado_hasta'];
        unset($filtro_para_lectura_sin_filtro_manual['pla_estado']);
        unset($filtro_para_lectura_sin_filtro_manual['pla_estado_hasta']);
        $this->vista->pla_agregar_variables=$filtro_para_lectura_sin_filtro_manual['pla_agregar_variables'];
        unset($filtro_para_lectura_sin_filtro_manual['pla_agregar_variables']);
        $this->vista->varcal=$variable;
        $this->vista->definir_campo("vis_$variable",array('agrupa'=>true,'tipo'=>'entero','origen'=>"coalesce(pla_$variable,varcalopc_opcion)"));
        $this->vista->definir_campo("vis_etiqueta",array('agrupa'=>true,'tipo'=>'entero','origen'=>"varcalopc_etiqueta"));
        $cur=$db->ejecutar(new Sql(<<<SQL
         SELECT coalesce(string_agg(varcalopc_expresion_condicion,' or '),'true')
                ||' or '||coalesce(string_agg(varcalopc_expresion_valor,' or '),'true')||(coalesce(' or '||nullif(:variables,''),'')) as variables, 
                varcal_destino as destino,
                'calculada' as tipo
            FROM  varcal
            LEFT JOIN varcalopc on varcalopc_ope=varcal_ope and varcalopc_varcal=varcal_varcal
            WHERE varcal_ope=:ope
              AND varcal_varcal=:var
            GROUP BY varcal_destino
SQL
           , array(':ope'=>$GLOBALS['nombre_app'], ':var'=>$variable, ':variables'=>$this->vista->pla_agregar_variables)
        ));
        $datos_varcal=$cur->fetchObject();
        if(!$datos_varcal){
            $cur=$db->ejecutar(new Sql(<<<SQL
                SELECT :variables ::text as variables, mat_ua as destino, 'registrada' as tipo
                  FROM information_schema.columns 
                    INNER JOIN encu.matrices ON mat_ope=:ope AND mat_for=upper(split_part(table_name,'_',2)) AND mat_mat=upper(coalesce(split_part(table_name,'_',3),''))
                  WHERE table_schema='encu'
                    AND column_name=:var
SQL
                , array(':ope'=>$GLOBALS['nombre_app'], ':var'=>'pla_'.$variable,':variables'=>$this->vista->pla_agregar_variables)
            ));
            $datos_varcal=$cur->fetchObject();
        }
        $this->vista->listColumnAux=[];
        if($datos_varcal){
            $variables=expresion_regular_extraer_variables($datos_varcal->variables);
            $varNoRepetidas=[];
            foreach($variables  as $unavar ){
                if(!in_array($unavar,$varNoRepetidas)){
                    $varNoRepetidas[]=$unavar;
                }
            };
            Loguear('2023-03-17','*-------Tenemos $datos_varcal '.json_encode($datos_varcal));
            Loguear('2022-03-17','*-------Tenemos $variables '.json_encode($variables));
            $this->vista->destino=$destino=$datos_varcal->destino;
            $this->vista->tipo=$tipo=$datos_varcal->tipo;
            $this->vista->listColumnAux=[$variable];
            $this->vista->listColumnAuxStr='';
            if(count($variables)>1){
                $vista_varmae=$this->contexto->nuevo_objeto("Vista_varmae");
                $listaSelect=[];     
                foreach($varNoRepetidas as $varaux){
                    if($varaux=='enc'){
                        continue;
                    }
                    if($varaux=='enc' or $varaux=='hog' or $varaux=='mie'){
                        $varaux=$varaux.'_';
                    }
                    if($datos_varcal->destino!='hog' ){ // REVISAR porque variables para hogar pueden involucrar variables del individual o de la matriz P
                            $this->vista->definir_campo("vis_$varaux",array('operacion'=>'concato_texto','origen'=>"distinct pla_$varaux::text"));
                            $listaSelect[]=$varaux;
                    }else{
                        $vista_varmae->leer_uno_si_hay(array('varmae_ope'=>$GLOBALS['NOMBRE_APP'], 'varmae_var'=>$varaux ));
                        if($vista_varmae->obtener_leido()){
                            if ($vista_varmae->datos->varmae_sufijodest==='S1_' or
                                $vista_varmae->datos->varmae_sufijodest==='A1_' or
                                $vista_varmae->datos->varmae_sufijodest==='TEM_' or
                                $vista_varmae->datos->varmae_sufijodest==='PMD_' ){
                                    $this->vista->definir_campo("vis_$varaux",array('operacion'=>'concato_texto','origen'=>"distinct pla_$varaux::text"));
                                    $listaSelect[]=$varaux;
                            }        
                        } 
                    } 
                }
            }
            $this->vista->listColumnAux=array_merge($this->vista->listColumnAux,$listaSelect);
            $xaux=implode(',',$this->vista->listColumnAux);
            Loguear('2023-03-17','-*od-------Tenemos $listColumnAux '.$xaux);
            foreach(($this->vista->listColumnAux) as &$varaux){
                $varaux='pla_'.$varaux;
            };
            unset($varaux);                   
            //armar la str lista select viene con la varcal,sus dependientes y variables agregadas, fexp con prefijo
            $this->vista->listColumnAuxStr=implode(',',$this->vista->listColumnAux).', pla_fexp,';
            //Loguear('2022-12-07','-*od-------Tenemos $str_listColumnAux '.json_encode($this->vista->listColumnAuxStr));

        }
        return parent::obtener_datos($filtro_para_lectura_sin_filtro_manual,$filtro_manual);
    }
}

class Vista_varcal_tabulado extends Vistas{
    var $varcal;
    var $tra_estado;
    var $listColumnAux;
    function definicion_estructura(){
        $this->definir_campo('vis_casos',array('operacion'=>'cuenta','origen'=>'x.pla_enc_','title'=>'cantidad casos'));
        $this->definir_campo('vis_expandido',array('operacion'=>'sum','origen'=>'pla_fexp','title'=>'suma factor'));
    }
    function leer_varios($filtro_para_lectura){
        $este_filtro=$filtro_para_lectura;
        unset($este_filtro['varcal_varcal']);
        return parent::leer_varios($este_filtro);
    }
    function clausula_from(){
        global $db;   
        $v_join_pla_ext_hog='';
        if(substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']>=2015){
            $val_modo=($_SESSION['modo_encuesta']=='ETOI')?$_SESSION['modo_encuesta']:$GLOBALS['NOMBRE_APP'];
            $v_join_pla_ext_hog=" inner join encu.pla_ext_hog x on x.pla_enc= s1.pla_enc and x.pla_hog= s1.pla_hog and x.pla_modo='{$val_modo}'" ;
        }
        $v_valcan=(substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'||substr($GLOBALS['NOMBRE_APP'],0,4)=='etoi')?" left join valcan vc on vc.pla_ope='{$GLOBALS['NOMBRE_APP']}'":'';         
        $tablas_especificias="";
        if($this->destino=='mie'){
            $tablas_especificias=<<<SQL
                   inner join plana_i1_ i1 on i1.pla_enc=s1.pla_enc and i1.pla_hog=s1.pla_hog 
                   inner join plana_s1_p s1p on i1.pla_enc=s1p.pla_enc and i1.pla_hog=s1p.pla_hog and i1.pla_mie=s1p.pla_mie
SQL;
        }
        if($this->destino=='per'){
            $tablas_especificias=<<<SQL
                   inner join plana_s1_p s1p on s1.pla_enc=s1p.pla_enc and s1.pla_hog=s1p.pla_hog
                   left  join plana_i1_ i1 on i1.pla_enc=s1p.pla_enc and i1.pla_hog=s1p.pla_hog and i1.pla_mie=s1p.pla_mie
SQL;
        }
        $cur=$db->ejecutar(new Sql(<<<SQL
        select 'inner join plana_a1_ a1 on s1.pla_enc=a1.pla_enc and s1.pla_hog=a1.pla_hog' as join_a1
            FROM encu.matrices 
            WHERE mat_for='A1' and mat_mat=''
SQL
        ));
        $leer_join_a1=$cur->fetchObject();
        $v_join_a1= ($leer_join_a1)? $leer_join_a1->join_a1: '';
        $v_otras_tablas="";
        if($GLOBALS['NOMBRE_APP']=='eah2019' || $GLOBALS['NOMBRE_APP']=='eah2021'){
            $v_otras_tablas=<<<SQL
                   left join plana_pmd_ pm on pm.pla_enc=s1.pla_enc and pm.pla_hog=s1.pla_hog 
SQL;
        }
        $sql_str=<<<SQL
            (select {$this->listColumnAuxStr} t.pla_enc as pla_enc_, s1.pla_hog as pla_hog_, s1.pla_mie as pla_mie_
                from plana_tem_ t 
                inner join plana_s1_ s1 on t.pla_enc=s1.pla_enc 
                {$v_join_a1}
                {$tablas_especificias}
                {$v_join_pla_ext_hog}
                {$v_otras_tablas}
                {$v_valcan}
                where pla_estado>={$this->tra_estado}
                  and pla_estado<{$this->tra_estado_hasta}
            )
SQL
            .($this->tipo=='calculada'?<<<SQL
            x full outer join 
            (select * 
                from varcalopc 
                where varcalopc_ope='{$GLOBALS['nombre_app']}' and varcalopc_varcal='{$this->varcal}'
            ) z on varcalopc_opcion=pla_{$this->varcal}
SQL
            :<<<SQL
            x full outer join 
            (select opc_opc::integer as varcalopc_opcion, opc_texto as varcalopc_etiqueta
                from opciones inner join variables on var_conopc=opc_conopc and var_ope=opc_ope
                where opc_ope='{$GLOBALS['nombre_app']}' and var_var='{$this->varcal}'
            ) z on varcalopc_opcion=pla_{$this->varcal}
SQL
            );
        //var_dump($sql_str);
        //Loguear('2022-12-07','-*-from--------------------str:'.$sql_str);
        //Loguear('2022-12-07','-*-from--------------------str_listColumnAux:'.$this->listColumnAuxStr);
        return $sql_str;

    }
}
?>