<?php
//UTF-8:SÍ
require_once "tablas.php";

class Tabla_preguntas extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('pre');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('pre_ope',array('hereda'=>'operativos','modo'=>'pk','validart'=>'codigo'));
        $this->definir_campo('pre_pre',array('es_pk'=>true,'tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('pre_texto',array('tipo'=>'texto','largo'=>3000, 'validart'=>'castellano'));
        $this->definir_campo('pre_abreviado',array('tipo'=>'texto','largo'=>3000,'validart'=>'castellano'));
        $this->definir_campo('pre_for',array('hereda'=>'formularios','modo'=>'fk_obligatoria','validart'=>'codigo'));
        $this->definir_campo('pre_mat',array('hereda'=>'matrices','modo'=>'fk_obligatoria','forzar_null_a_vacio'=>true,'validart'=>'codigo'));
        $this->definir_campo('pre_blo',array('hereda'=>'bloques','modo'=>'fk_obligatoria','validart'=>'extendido'));
        $this->definir_campo('pre_aclaracion',array('tipo'=>'texto','largo'=>900,'validart'=>'castellano'));
        $this->definir_campo('pre_destino',array('tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('pre_desp_opc',array('tipo'=>'enumerado','elementos'=>array('horizontal','vertical'),'def'=>'vertical','validart'=>'codigo'));
        $this->definir_campo('pre_desp_nombre',array('tipo'=>'texto','largo'=>50,'validart'=>'castellano'));
        $this->definir_campo('pre_orden',array('tipo'=>'entero'));
        $this->definir_campo('pre_aclaracion_superior',array('tipo'=>'texto','largo'=>1000,'validart'=>'castellano'));   
        if (substr($GLOBALS['NOMBRE_APP'],0,4)=='eder'&& $GLOBALS['anio_operativo']=2017 ){ 
            $this->definir_campo('pre_retrospectiva',array('tipo'=>'entero'));   
            $this->definir_campo('pre_repetitiva',array('tipo'=>'texto','largo'=>400, 'validart'=>'castellano')); 
        }
        $this->definir_tablas_hijas(array('variables'=>false));
        $this->definir_campos_orden(array('pre_for','(select blo_orden from bloques where blo_ope=pre_ope and blo_blo=pre_blo and blo_for=pre_for)','pre_orden'));
    }
    function desplegar_subtablas(){
        $this->datos->tipo_conopc_anterior = null;
        $this->despliegue->tabla_preguntas->datos->todavia_sin_mostrar = true;
        $this->despliegue->tabla_variables=$tabla_variables=$this->definicion_tabla('variables');
        $tabla_variables->leer_varios(array(
            'var_ope'=>$this->datos->pre_ope,
            'var_for'=>$this->datos->pre_for,
            'var_pre'=>$this->datos->pre_pre,
        ));
        while($tabla_variables->obtener_leido()){
            if(!$tabla_variables->datos->var_subordinada_var && !$tabla_variables->datos->var_subordinada_opcion){
                $tabla_variables->desplegar();
            }
        }
    } 
    function desplegar(){
        $this->tiene_una_sola_variable_sin_texto=$this->contexto->db->preguntar(<<<SQL
            SELECT SUM(CASE WHEN var_texto IS NULL THEN 1 ELSE 0 END)=1 
                AND SUM(CASE WHEN var_texto IS NULL THEN 0 ELSE 1 END)=0
              FROM variables 
              WHERE var_ope=:var_ope and var_for=:var_for and var_pre=:var_pre
                AND var_subordinada_var IS NULL
SQL
            ,
            array(':var_ope'=>$this->datos->pre_ope,
                  ':var_for'=>$this->datos->pre_for,
                  ':var_pre'=>$this->datos->pre_pre)
        );
        if($this->datos->pre_desp_opc=='horizontal'){ // meto una subtabla
            $this->contexto->salida->abrir_grupo_interno("",array('tipo'=>'TR','referencia'=>'pregunta-'.$this->datos->pre_pre));
                $this->contexto->salida->abrir_grupo_interno("",array('tipo'=>'TD','colspan'=>2));
                    // OJO: PROVISORIO PARA FORMATEO:
                    $sub_clase='';
                    $preguntas_para_achicar=array('aj1','aj6','aj13','aj15','aj26');
                    foreach($preguntas_para_achicar as $pregunta_achicar){
                        if ($this->datos->pre_pre==$pregunta_achicar){
                            $sub_clase=' achicar_letra';
                        }                        
                    }
                    $this->contexto->salida->abrir_grupo_interno("tabla_preguntas_horizontales".$sub_clase,array('tipo'=>'TABLE','id'=>'tabla_pre_'.$this->datos->pre_pre));
        }
        if($this->datos->pre_aclaracion_superior){
            $this->contexto->salida->abrir_grupo_interno("pre_aclaracion_superior",array('tipo'=>'TR'));
                $this->contexto->salida->enviar($this->datos->pre_aclaracion_superior,"pre_aclaracion_superior meta_reem",array('tipo'=>'TD','colspan'=>'100'));
            $this->contexto->salida->cerrar_grupo_interno();
        }
        $this->contexto->salida->abrir_grupo_interno("encabezado_pregunta",array('tipo'=>'TR','referencia'=>'pregunta-'.$this->datos->pre_pre));
            $this->contexto->salida->abrir_grupo_interno("encabezado_pregunta",array('tipo'=>'TD','colspan'=>'100'));
                if(!$this->tiene_una_sola_variable_sin_texto and $this->datos->pre_texto){
                    if($this->datos->pre_desp_nombre===NULL){
                        $this->contexto->salida->enviar($this->datos->pre_pre,"pre_pre");
                    }else{
                        $this->contexto->salida->enviar($this->datos->pre_desp_nombre,"pre_pre");
                    }
                    $this->contexto->salida->enviar($this->datos->pre_texto,"pre_texto meta_reem",array('tipo'=>'SPAN'));
                    $this->contexto->salida->enviar($this->datos->pre_aclaracion,"pre_aclaracion meta_reem",array('tipo'=>'SPAN'));
                }
            $this->contexto->salida->cerrar_grupo_interno();
        $this->contexto->salida->cerrar_grupo_interno();
        $this->desplegar_subtablas();
        if($this->datos->pre_desp_opc=='horizontal'){ // cierro la subtabla
                    $this->contexto->salida->cerrar_grupo_interno();
                $this->contexto->salida->cerrar_grupo_interno();
            $this->contexto->salida->cerrar_grupo_interno();
        }
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE preguntas
  ADD CONSTRAINT "texto invalido en pre_abreviado de tabla preguntas" CHECK (comun.cadena_valida(pre_abreviado::text, 'castellano'::text));
/*OTRA*/
ALTER TABLE preguntas
  ADD CONSTRAINT "texto invalido en pre_aclaracion de tabla preguntas" CHECK (comun.cadena_valida(pre_aclaracion::text, 'cualquiera'::text));
/*OTRA*/
ALTER TABLE preguntas
  ADD CONSTRAINT "texto invalido en pre_blo de tabla preguntas" CHECK (comun.cadena_valida(pre_blo::text, 'extendido'::text));
/*OTRA*/
ALTER TABLE preguntas
  ADD CONSTRAINT "texto invalido en pre_desp_nombre de tabla preguntas" CHECK (comun.cadena_valida(pre_desp_nombre::text, 'castellano'::text));
/*OTRA*/
ALTER TABLE preguntas
  ADD CONSTRAINT "texto invalido en pre_desp_opc de tabla preguntas" CHECK (comun.cadena_valida(pre_desp_opc::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE preguntas
  ADD CONSTRAINT "texto invalido en pre_destino de tabla preguntas" CHECK (comun.cadena_valida(pre_destino::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE preguntas
  ADD CONSTRAINT "texto invalido en pre_for de tabla preguntas" CHECK (comun.cadena_valida(pre_for::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE preguntas
  ADD CONSTRAINT "texto invalido en pre_mat de tabla preguntas" CHECK (comun.cadena_valida(pre_mat::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE preguntas
  ADD CONSTRAINT "texto invalido en pre_ope de tabla preguntas" CHECK (comun.cadena_valida(pre_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE preguntas
  ADD CONSTRAINT "texto invalido en pre_pre de tabla preguntas" CHECK (comun.cadena_valida(pre_pre::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE preguntas
  ADD CONSTRAINT "texto invalido en pre_texto de tabla preguntas" CHECK (comun.cadena_valida(pre_texto::text, 'cualquiera'::text));
/*OTRA*/
ALTER TABLE preguntas
  ADD CONSTRAINT "texto invalido en pre_aclaracion_superior de tabla preguntas" CHECK (comun.cadena_valida(pre_aclaracion_superior::text, 'cualquiera'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }

}

?>