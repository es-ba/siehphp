<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";
//
class Proceso_alta_tem extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Alta números de encuesta',
            'submenu'=>'ingreso',
            'para_produccion'=>true,
            'permisos'=>array('grupo'=>'subcoor_campo','grupo2'=>'ingresador'),
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_enc_ini'=>array('label'=>'Nro. de encuesta inicial'),
                'tra_enc_final'=>array('label'=>'Nro. de encuesta final','label-derecho'=>'Repetir nro de encuesta inicial si es una unica encuesta' ),
                //'tra_confirmar'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Entiendo que el proceso no es reversible'),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'Siguiente','script_ok'=>'luego_refrescar_grilla("vista_alta_encuestas")'),
        ));
    }
    function correr(){
        parent::correr();
        enviar_grilla($this->salida,'vista_alta_encuestas');
    }
    
    function responder(){
        if (!isset($this->argumentos->tra_enc_ini) || $this->argumentos->tra_enc_ini ==''){
            return new Respuesta_Negativa("Error: Debe ingresar un número de encuesta inicial");
        }
        if (!isset($this->argumentos->tra_enc_final) || $this->argumentos->tra_enc_final ==''){
            return new Respuesta_Negativa("Error: Debe ingresar un número de encuesta final");
        }        
        $procesadas=0;
        $campos_filtro=cambiar_prefijo($this->argumentos,'tra_','pla_');
        unset($campos_filtro->pla_ope);
      //  unset($campos_filtro->pla_confirmar);
        $filtro=$this->nuevo_objeto("Filtro_Normal",$campos_filtro);
        // VALUES ({$this->argumentos->tra_enc}, 3, 1, 1);
        $ver=$this->db->ejecutar_sql(new Sql(<<<SQL
    INSERT INTO tem(
            tem_enc, tem_dominio,tem_semana, tem_tlg)
    (SELECT generate_series({$this->argumentos->tra_enc_ini}, {$this->argumentos->tra_enc_final}) , 3, 1, 1 );
   
SQL
        //,$filtro->parametros
        ));
        
        $ver=$this->db->ejecutar_sql(new Sql(<<<SQL
    INSERT INTO claves(
            cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm, cla_tlg)
    (SELECT '{$this->argumentos->tra_ope}', 'TEM','', generate_series({$this->argumentos->tra_enc_ini}, {$this->argumentos->tra_enc_final}), 0, 0, 0, 1);
SQL
        //,$filtro->parametros
        ));
        //seteamos el estado a 26 para poder ingresar
        $procesadas=$this->db->ultima_consulta->rowCount();
        $ver=$this->db->ejecutar_sql(new Sql(<<<SQL
    update encu.respuestas
      set res_valor=1
      where res_ope=dbo.ope_actual() and res_for='TEM' and res_mat='' and res_var='a_ingreso_enc' and res_enc between {$this->argumentos->tra_enc_ini} and  {$this->argumentos->tra_enc_final};
SQL
        //,$filtro->parametros
        ));
        /*
        $ver=$this->db->ejecutar_sql(new Sql(<<<SQL
    update encu.respuestas
      set res_valor=1
      where res_ope=dbo.ope_actual() and res_for='TEM' and res_mat='' and res_var='cod_enc' and res_enc between {$this->argumentos->tra_enc_ini} and  {$this->argumentos->tra_enc_final};
SQL
        //,$filtro->parametros
        ));
        */
        if($procesadas>0){
            return new Respuesta_Positiva("Encuesta/s agregada/s  $procesadas.");
        }else{
            return new Respuesta_Positiva("No se agregaron encuestas  $procesadas.");            
        }
    }
}

class Vista_alta_encuestas extends Vistas{
    function definicion_estructura(){ 
        $this->definir_campo('vis_enc'                   ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_enc'  )); //hay que poner agrupa pq sino muestra una unica encuesta
        $this->definir_campo('vis_semana'                ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_semana'  ));
        $this->definir_campo('vis_estado'                ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_estado'  ));
//        $this->definir_campo('vis_comunas_sin_liberar'    ,array('operacion'=>'concato_unico','origen'=>'comun.para_ordenar_numeros(case when pla_estado=19 then pla_comuna::text else null end)'));
//        $this->definir_campo('vis_liberadas_no_usadas'    ,array('operacion'=>'cuenta_true','origen'=>'pla_estado=20'));
//        $this->definir_campo('vis_liberadas_en_uso'       ,array('operacion'=>'cuenta_true','origen'=>'pla_estado>20'));
        $this->campos_orden=array(1);
    }
    function clausula_from(){
        return "plana_tem_";
    }
/*
    function clausula_where_agregada(){
        return " and pla_enc between {$this->argumentos->tra_enc_ini} and {$this->argumentos->tra_enc_final}";        
    }
*/    
}

?>