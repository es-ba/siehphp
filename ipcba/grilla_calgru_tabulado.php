<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_calgru_tabulado extends Grilla_vistas{
    function iniciar($base){
        return parent::iniciar('calgru_tabulado');
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
    function obtener_datos($filtro_para_lectura_sin_filtro_manual,$filtro_manual=false){
        $this->vista->fin_de_definicion_estructura=false;
        
        $this->vista->periodo=$filtro_para_lectura_sin_filtro_manual['periodo'];
        $this->vista->agrupacion=$filtro_para_lectura_sin_filtro_manual['agrupacion'];
        $this->vista->fin_de_definicion_estructura=false;        
        $this->vista->definir_campo('periodo'    ,array('tipo'=>'texto' , 'es_pk'=>true, 'origen'=>'periodo' /*, 'invisible'=>true*/));
        $this->vista->definir_campo('calculo'    ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'calculo', 'def'=>0, 'invisible'=>true));
        $this->vista->definir_campo('agrupacion' ,array('tipo'=>'texto' , 'es_pk'=>true, 'origen'=>'agrupacion', 'invisible'=>true ));
        $this->vista->definir_campo('ordenpor'   ,array('tipo'=>'texto' , 'origen'=>'ordenpor', 'invisible'=>true ));
        $this->vista->definir_campo('grupo'      ,array('tipo'=>'texto' , 'es_pk'=>true, 'origen'=>'grupo'));
        $this->vista->definir_campo('nombre'     ,array('tipo'=>'texto' , 'origen'=>'nombre'));
        $indice = 0;
        foreach ($filtro_para_lectura_sin_filtro_manual as $clave => $valor){
           $ultimo=substr($clave,-1);
           if ($clave == 'periodo'){
              $this->vista->periodo=$filtro_para_lectura_sin_filtro_manual[$clave];
           }elseif ($clave == 'agrupacion'){
              $this->vista->agrupacion=$filtro_para_lectura_sin_filtro_manual[$clave];
           }elseif (substr($clave,0,-1) == 'indicador'){
            $this->vista->indicadores[$indice]=$filtro_para_lectura_sin_filtro_manual[$clave];
            $this->vista->definir_campo("$clave" ,array('tipo'=>'texto', 'origen'=>"indic$ultimo", 'invisible'=>true));
           }elseif (substr($clave,0,-1) == 'contraperiodo'){
            $this->vista->contraperiodos[$indice]=$filtro_para_lectura_sin_filtro_manual[$clave];
            $this->vista->definir_campo("$clave" ,array('tipo'=>'texto'  , 'origen'=>"conper$ultimo" /*, 'invisible'=>true*/));
           }elseif (substr($clave,0,-1) == 'contranivel'){
            $this->vista->contraniveles[$indice]=$filtro_para_lectura_sin_filtro_manual[$clave];
            $this->vista->definir_campo("$clave" ,array('tipo'=>'texto'  , 'origen'=>"conniv$ultimo", 'invisible'=>true));
            $indice = $indice+1;
           }
        }
        $indice=0;
        foreach ($this->vista->indicadores as $xindicador){
            $indice=$indice+1;
            $this->vista->definir_campo("$xindicador$indice" ,array('tipo'=>'decimal','origen'=>"$xindicador$indice"));
        }
        return parent::obtener_datos($filtro_para_lectura_sin_filtro_manual,$filtro_manual);
    }
}

class Vista_calgru_tabulado extends Vistas{
    var $periodo;
    var $calculo;
    var $agrupacion;
    var $indicadores=array();
    var $contraperiodos=array();
    var $contraniveles=array();
    function definicion_estructura(){
        $este=$this;
        $este->definir_campos_orden(array('ordenpor'));

    }
    function leer_varios($filtro_para_lectura){
        $este_filtro=$filtro_para_lectura;
        //unset($este_filtro['varcal_varcal']);
        return parent::leer_varios($este_filtro);
    }
    function expresion_indicador_en_select($indicador, $columna){
        $expresion='';
        if($indicador=='variacion'){
            $expresion=" CASE WHEN c_$columna.Indice=0 THEN null ELSE round((round(c.Indice::decimal,2)/round(c_$columna.Indice::decimal,2)*100-100)::decimal,1) END";
        }elseif($indicador=='variacionsinredondear'){
            $expresion=" CASE WHEN c_$columna.Indice=0 THEN null ELSE (c.Indice::decimal/c_$columna.Indice::decimal*100-100)::decimal END";
        }elseif($indicador=='incidenciaredondeada'){
            $expresion=" round(((round(c.indice::decimal,2) - round(ci_$columna.indice::decimal,2)) * c.ponderador / (round(ci_$columna.indicenivel::decimal,2)*ci_$columna.ponderadornivel) * 100) ::decimal,2) "; 
        }elseif($indicador=='incidenciasinredondear'){
            $expresion = "(c.indice - ci_$columna.indice) * c.ponderador / (ci_$columna.indicenivel*ci_$columna.ponderadornivel) * 100::double precision";
        }elseif($indicador=='grupoantecesor'){
            $expresion = "ci_$columna.gruponivel";
        }elseif($indicador=='ponderadorrelativo'){
            $expresion = "round((ci_$columna.ponderador/ci_$columna.ponderadornivel)::decimal,6)";           
        }elseif($indicador=='indice' or $indicador=='indiceredondeado' 
                or $indicador=='nivel' ){
            $expresion = ' c.'.$indicador;
        }else{ 
              $expresion ='Expresion no definida';
        }
        Loguear('2014-02-17','parametros de expresion_indicador_en select: ------------- '.var_export($indicador,true). var_export($columna, true). var_export($expresion, true));
        return $expresion;
    }
    function clausula_from(){
        $parteselect = <<<CAD
           (select c.periodo, c.calculo, c.agrupacion, substr(c.grupo,2) ordenpor, c.grupo, c.nombre 
CAD;
        $partefrom =<<<CAD
                from cvp.calgru_vw c 
CAD;
        $indclave = 0;      
        foreach ($this->indicadores as $indvalor){
            $indice =$indclave + 1;
            $nuevacolumna=$this->expresion_indicador_en_select($this->indicadores[$indclave], $indice);
            $parteselect=  
                <<<SQL
                $parteselect
                  ,comun.a_texto('{$this->contraperiodos[$indclave]}') as conper$indice
                  ,comun.a_texto('{$this->contraniveles[$indclave]}') as conniv$indice           
                  ,comun.a_texto('{$this->indicadores[$indclave]}') as indic$indice
                  ,$nuevacolumna as {$this->indicadores[$indclave]}$indice
SQL;
            $xnivel= ($this->contraniveles[$indclave]==-1)?" CASE WHEN c_$indice.nivel=0 THEN c_$indice.nivel ELSE c_$indice.nivel-1 END": $this->contraniveles[$indclave];
            $fromindicador='';
            if (!(strpos($indvalor,'variacion')===false)){
                $fromindicador = <<<SQL
                    left join cvp.calgru c_$indice on c_$indice.periodo='{$this->contraperiodos[$indclave]}' and c.calculo= c_$indice.calculo and 
                                                      c.agrupacion=c_$indice.agrupacion and c.grupo=c_$indice.grupo
SQL;
            }elseif (!(strpos($indvalor,'incidencia')===false)){
                $fromindicador = <<<SQL
                    left join ( SELECT c_$indice.periodo,c_$indice.calculo,c_$indice.agrupacion,
                                       c_$indice.grupo, c_$indice.indice, c_n$indice.indice as indicenivel, c_n$indice.grupo as gruponivel, c_n$indice.ponderador as ponderadornivel 
                                    from cvp.calgru c_$indice 
                                        left join cvp.gru_grupos gg$indice on c_$indice.agrupacion=gg$indice.agrupacion and
                                                                              c_$indice.grupo= gg$indice.grupo                                    
                                        join cvp.calgru c_n$indice on c_n$indice.periodo=c_$indice.periodo and
                                                                           c_n$indice.calculo=c_$indice.calculo and 
                                                                           c_n$indice.agrupacion=c_$indice.agrupacion and
                                                                           c_n$indice.nivel=$xnivel and
                                                                           c_n$indice.grupo= gg$indice.grupo_padre
                              ) as ci_$indice on ci_$indice.periodo='{$this->contraperiodos[$indclave]}' and
                                  ci_$indice.calculo= c.calculo and
                                  ci_$indice.agrupacion=c.agrupacion and
                                  ci_$indice.grupo=c.grupo  
SQL;
            }elseif (!(strpos($indvalor,'grupoantecesor')===false)){
                $fromindicador = <<<SQL
                    left join ( SELECT c_$indice.agrupacion, c_$indice.grupo, gg$indice.grupo_padre as gruponivel
                                    from cvp.grupos c_$indice 
                                        left join cvp.gru_grupos gg$indice on c_$indice.agrupacion=gg$indice.agrupacion and c_$indice.grupo=gg$indice.grupo
                                        join cvp.grupos c_n$indice on c_n$indice.agrupacion=gg$indice.agrupacion and
                                                                      c_n$indice.nivel=$xnivel and
                                                                      c_n$indice.grupo= gg$indice.grupo_padre    
                              ) as ci_$indice on ci_$indice.agrupacion=c.agrupacion and
                                                 ci_$indice.grupo=c.grupo 
SQL;
            }elseif (!(strpos($indvalor,'ponderadorrelativo')===false)){
                $fromindicador = <<<SQL
                    left join ( SELECT c_$indice.agrupacion, c_$indice.grupo, c_$indice.ponderador, c_n$indice.ponderador as ponderadornivel
                                    from cvp.grupos c_$indice 
                                        left join cvp.gru_grupos gg$indice on c_$indice.agrupacion=gg$indice.agrupacion and c_$indice.grupo=gg$indice.grupo
                                        join cvp.grupos c_n$indice on c_n$indice.agrupacion=gg$indice.agrupacion and
                                                                      c_n$indice.nivel=$xnivel and
                                                                      c_n$indice.grupo= gg$indice.grupo_padre    
                              ) as ci_$indice on ci_$indice.agrupacion=c.agrupacion and
                                                 ci_$indice.grupo=c.grupo                     
SQL;
            }elseif(!(strpos($indvalor,'indice')===false) or
                    !(strpos($indvalor,'nivel')===false)) {
                   $fromindicador='';
            }else{
               $fromindicador='Error_indicador_no_considerado';
            }
           
            $partefrom =<<<SQL
                $partefrom 
                $fromindicador
SQL;
            $indclave = $indclave +1;
        }
        $consulta = <<<SQL
        $parteselect
        $partefrom
            where c.periodo='{$this->periodo}' and
                  c.calculo=0 and
                  c.agrupacion='{$this->agrupacion}'
        ) as micalgru                  
SQL;

        //Loguear('2014-03-27','LLEGUÉ ACÁ: ------------- '.var_export($consulta,true));
        return $consulta;
    }
}
?>