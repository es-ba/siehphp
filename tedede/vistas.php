<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_o_vistas.php";
// require_once "grilla_respuestas.php";

abstract class Vistas extends Tablas_o_Vistas{
    var $campos_group_by=array();
    var $origenes=array();
    var $otros_campos_a_listar=array();
    var $operaciones=array();
    var $detallar=false;
    var $campos_a_detallar=array();
    function __construct(){
        $this->definir_prefijo('vis');
        parent::__construct();
    }
    function definir_campos_genericos_al_final(){
    }
    function extraer_parametros_especificos($nombre_campo,&$definicion_campo){
        $considerado_en_lista_de_campos=null; // null=todavía no sé.
        if(extraer_y_quitar_parametro($definicion_campo,'agrupa',array('def'=>false))){
            $this->campos_group_by[]=$nombre_campo;
            $considerado_en_lista_de_campos=true;
            $definicion_campo['es_pk']=true;
        }
        if(extraer_y_quitar_parametro($definicion_campo,'detallar',array('def'=>false))){
            $this->campos_a_detallar[]=$nombre_campo;
            $considerado_en_lista_de_campos=false;
        }
        $this->origenes[$nombre_campo]=extraer_y_quitar_parametro($definicion_campo,'origen',array('def'=>$nombre_campo));
        extraer_y_quitar_parametro($definicion_campo,'total',null);
        extraer_y_quitar_parametro($definicion_campo,'estilo',null);
        extraer_y_quitar_parametro($definicion_campo,'numerador',null);
        extraer_y_quitar_parametro($definicion_campo,'denominador',null);
        extraer_y_quitar_parametro($definicion_campo,'minimo_denominador',null);
        extraer_y_quitar_parametro($definicion_campo,'para',null);
        extraer_y_quitar_parametro($definicion_campo,'mostrar',null);
        extraer_y_quitar_parametro($definicion_campo,'restan',null);
        $boton=extraer_y_quitar_parametro($definicion_campo,'boton',null);
        if($boton){
            $this->definiciones_para_grilla[$nombre_campo]['boton']=$boton;
            $proceso=extraer_y_quitar_parametro($definicion_campo,'proceso',null);
            $this->definiciones_para_grilla[$nombre_campo]['proceso']=$proceso;
            $pre_proceso=extraer_y_quitar_parametro($definicion_campo,'pre_proceso',null);
            $this->definiciones_para_grilla[$nombre_campo]['pre_proceso']=$pre_proceso;
            $post_proceso=extraer_y_quitar_parametro($definicion_campo,'post_proceso',null);
            $this->definiciones_para_grilla[$nombre_campo]['post_proceso']=$post_proceso;
            $considerado_en_lista_de_campos=false;
        }
        $operacion=extraer_y_quitar_parametro($definicion_campo,'operacion',array('def'=>false));
        if($operacion){
            $this->operaciones[$nombre_campo]=$operacion;
            $definicion_campo['tipo']='entero';
            $considerado_en_lista_de_campos=true;
        }
        if($considerado_en_lista_de_campos===null){
            $this->otros_campos_a_listar[]=$nombre_campo;
        }
    }
    function clausula_from(){
        throw new Exception_Tedede("Hay que especificar la clausula_from en ".get_class($this));
    }
    function campos_select(){
        $pares=array();
        $this->para_clausula_group_by=array();
        foreach($this->campos_group_by as $campo){
            $pares[]=$this->origenes[$campo].' as '.$campo;
            $this->para_clausula_group_by[]=$this->origenes[$campo];
        }
        $expresiones_campos=array();
        $condiciones_campos=array();
        foreach($this->operaciones as $campo=>$operacion){
            if($this->detallar){
                switch($operacion){
                    case 'cuenta_true':
                        $expresion='('.$this->origenes[$campo].') is true';
                        break;
                    default:
                        $expresion=$this->origenes[$campo];
                }
            }else{
                switch($operacion){
                    case 'cuenta_true':
                        $expresion='sum(case when '.$this->origenes[$campo].' then 1 else 0 end)';
                        $condiciones_campos[$campo]=$this->origenes[$campo];
                        break;
                    case 'cuenta':
                        $expresion='count('.$this->origenes[$campo].')';
                        $condiciones_campos[$campo]=$this->origenes[$campo]=='*'?'true':'('.$this->origenes[$campo].') is not null';
                        break;
                    case 'tasa':
                        $minimo_denominador=$this->definiciones_campo_originales[$campo]["minimo_denominador"];
                        $expresion='round('.$expresiones_campos[$this->definiciones_campo_originales[$campo]["numerador"]].'*100.0/'.
                            'nullif('.$expresiones_campos[$this->definiciones_campo_originales[$campo]["denominador"]].',0),1)';
                        if($minimo_denominador){
                            $expresion="case when abs(".$expresiones_campos[$this->definiciones_campo_originales[$campo]["denominador"]].
                                ")>=".$minimo_denominador." then ".$expresion." else null end ";
                        }
                        break;
                    case 'muestra_otro':
                    case 'cuenta_otro':
                        $expresion=$expresiones_campos[$this->definiciones_campo_originales[$campo]["total"]];
                        $condicion='('.$condiciones_campos[$this->definiciones_campo_originales[$campo]["total"]].')';
                        foreach($this->definiciones_campo_originales[$campo]["restan"] as $campo_resta){
                            $expresion.='-('.$expresiones_campos[$campo_resta].')';
                            $condicion.=' and not ('.$condiciones_campos[$campo_resta].')';
                        }
                        $condiciones_campos[$campo]=$condicion;
                        if($operacion=='muestra_otro'){
                            $expresion="string_agg(case when {$condicion} then {$this->definiciones_campo_originales[$campo]["mostrar"]}::text else null end,', ' order by {$this->definiciones_campo_originales[$campo]["mostrar"]})";
                        }
                        break;
                    case 'concato_unico':
                        $expresion='string_agg(distinct '.$this->origenes[$campo]."::text,' ' order by ".$this->origenes[$campo].'::text)';
                        break;
                    case 'concato_texto':
                        $expresion='string_agg('.$this->origenes[$campo].",' ')";
                        break;
                    case 'count':
                    case 'avg':
                    case 'sum':
                    case 'max':
                    case 'min':
                        $expresion="{$operacion}({$this->origenes[$campo]})";
                        break;
                    default:
                        throw new Exception_Tedede("No existe la operacion $operacion en la vista ".get_class($this));
                }
            }
            $pares[]=$expresion.' as '.$campo."\n";
            $expresiones_campos[$campo]=$expresion;
        }
        foreach($this->otros_campos_a_listar as $campo){
            $pares[]=(@$this->origenes[$campo]?:$campo).' as '.$campo;
            // $pares[]=$this->origenes[$campo].' as '.$campo;
        }
        return implode(', ',$pares);
    }
    function clausula_group_by(){
        if($this->detallar || count($this->para_clausula_group_by)==0){
            return "";
        }else{
            return " group by ".implode(', ',$this->para_clausula_group_by);
        }
    }
    function en_que_where_va_el_campo_y_cual_campo(&$campo){
        if($this->detallar or @$this->definiciones_campo_originales[$campo]['agrupa']){
            $campo=$this->definiciones_campo_originales[$campo]['origen'];
            return 'where';
        }else{
            return 'where_posterior';
        }
    }
    protected function obtener_sentencia_select_y_parametros($filtro,$con_order_by){
        $f=parent::obtener_sentencia_select_y_parametros($filtro,$con_order_by);
        if($f->where_posterior){ 
            $f->sentencia_select="SELECT * FROM (".$f->sentencia_select.") x WHERE ".$f->where_posterior;
        }
        return $f;
    }
    protected function texto_de_ayuda($texto){
        //FALTA IMPLEMENTAR
    }
    protected function definir_campos_orden_detallado($campos){
        $this->campos_orden_detallado=$campos;
    }
    function establecer_detallado($detallar){
        $this->detallar=$detallar;
        if($detallar){
            foreach($this->campos_a_detallar as $campo){
                $this->pk[]=$campo;
                $this->campos_group_by[]=$campo;
            }
            $this->campos_orden=(@$this->campos_orden_detallado)?:$this->campos_orden;
        }
    }
}

?>
