<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";

class Proceso_liberacion_a_campo extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Liberar encuestas a campo',
            'submenu'=>'coordinación de campo',
            'para_produccion'=>true,
            'permisos'=>array('grupo'=>'subcoor_campo'),
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_dominio'=>array('label'=>'dominio','aclaracion'=>'indique #todo para todos los dominios'),
                'tra_replica'=>array('label'=>'réplica','aclaracion'=>'indique #todo para todas las réplicas'),
                'tra_comuna'=>array('label'=>'comuna','def'=>'#todo','aclaracion'=>'para excluir una use por ejemplo #!=14'),
                'tra_up'=>array('label'=>'UP','def'=>'#todo','aclaracion'=>'para rango use por ejemplo #>=100 & <=139'),
                'tra_confirmar'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Entiendo que el proceso no es reversible'),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'procesar','script_ok'=>'luego_refrescar_grilla("vista_liberadas")'),
        ));
    }
    function correr(){
        parent::correr();
        enviar_grilla($this->salida,'vista_liberadas');
    }
    function responder(){
        if (!isset($this->argumentos->tra_dominio) || $this->argumentos->tra_dominio ==''){
            return new Respuesta_Negativa("Error: Debe ingresar un número o filtro en dominio");
        } else if(!isset($this->argumentos->tra_replica) || $this->argumentos->tra_replica ==''){
            return new Respuesta_Negativa("Error: Debe ingresar un número o filtro en réplica");
        } else if(!isset($this->argumentos->tra_comuna) || $this->argumentos->tra_comuna ==''){
            return new Respuesta_Negativa("Error: Debe ingresar un número o filtro en comuna");        
        } else if(!isset($this->argumentos->tra_up) || $this->argumentos->tra_up ==''){
            return new Respuesta_Negativa("Error: Debe ingresar un número o filtro en up");    
        } else if(!$this->argumentos->tra_confirmar){
            return new Respuesta_Negativa("No contesto afirmativamente la pregunta realizada");
        }       
        $procesadas=0;
        $campos_filtro=cambiar_prefijo($this->argumentos,'tra_','pla_');
        unset($campos_filtro->pla_ope);
        unset($campos_filtro->pla_confirmar);
        $filtro=$this->nuevo_objeto("Filtro_Normal",$campos_filtro);
        $ver=$this->db->ejecutar_sql(new Sql(<<<SQL
update respuestas
  set res_valor='1'
  from plana_tem_ x
  where pla_estado=19
    and {$filtro->where}  
    and res_enc=x.pla_enc  
    and res_ope='{$this->argumentos->tra_ope}'
    and res_for='TEM'
    and res_mat=''
    and res_var='asignable'
    and res_hog=0
    and res_mie=0
    and res_exm=0 
SQL
        ,$filtro->parametros));
        $procesadas=$this->db->ultima_consulta->rowCount();
        if($procesadas>0){
            return new Respuesta_Positiva("Encuestas liberadas $procesadas.");
        }else{
            return new Respuesta_Positiva("No se liberaron encuestas");            
        }
    }
}

class Vista_liberadas extends Vistas{
    function definicion_estructura(){
        $this->definir_campo('vis_dominio'                ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_dominio'  ));
        $this->definir_campo('vis_replica'                ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_replica'  ));
        $this->definir_campo('vis_sin_liberar'            ,array('operacion'=>'cuenta_true','origen'=>'pla_estado=19'));
        $this->definir_campo('vis_comunas_sin_liberar'    ,array('operacion'=>'concato_unico','origen'=>'comun.para_ordenar_numeros(case when pla_estado=19 then pla_comuna::text else null end)'));
        $this->definir_campo('vis_liberadas_no_usadas'    ,array('operacion'=>'cuenta_true','origen'=>'pla_estado=20'));
        $this->definir_campo('vis_liberadas_en_uso'       ,array('operacion'=>'cuenta_true','origen'=>'pla_estado>20'));
    }
    function clausula_from(){
        return "plana_tem_";
    }
}

?>