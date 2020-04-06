<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";

class Proceso_exportar_linea_pobreza extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Exportar línea de pobreza e indigencia',
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'permisos'=>array('grupo'=>'procesamiento'),
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_anio'=>array('label'=>'Anio','aclaracion'=>'indique anio a exportar'),
                'tra_mes'=>array('label'=>'Mes','aclaracion'=>'indique mes a exportar'),
                'tra_confirmar'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Entiendo que el proceso se realiza una vez para el operativo, y si se realiza nuevamente es por algún cambio informado por IPCBA'),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'exportar', 'script_ok'=>'luego_refrescar_grilla("vista_valcan")'),
        ));
    }
    function correr(){
        parent::correr();
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT x.bit_fin, x.bit_resultado
            FROM
                (SELECT bit_fin, bit_resultado
                   FROM encu.bitacora 
                   WHERE bit_proceso='exportar_linea_pobreza' 
                     AND bit_fin IS NOT NULL 
                 ORDER BY bit_fin desc 
                 LIMIT 2) x 
SQL
        ));
        while($control=$cursor->fetchObject()){       
            $this->salida->enviar("Fecha Exportación: ".($control->bit_fin?:'no hubo').
                ". Resultado de la exportacion: ".$control->bit_resultado,"mensaje_error_grave"
            );        
         };
        enviar_grilla($this->salida,'vista_valcan');
    }
    function responder(){
        if (!isset($this->argumentos->tra_anio) || $this->argumentos->tra_anio ==''){
            return new Respuesta_Negativa("Error: Debe ingresar un anio");
        } else if(!isset($this->argumentos->tra_mes) || $this->argumentos->tra_mes ==''){
            return new Respuesta_Negativa("Error: Debe ingresar un mes");
        } else if(!$this->argumentos->tra_confirmar){
            return new Respuesta_Negativa("No contesto afirmativamente la pregunta realizada");
        }
        $tabla_parametros=$this->nuevo_objeto("Tabla_parametros");
        $tabla_parametros->leer_uno_si_hay(array('par_ope'=>$this->argumentos->tra_ope, 'par_anio_ipcba'=>$this->argumentos->tra_anio, 'par_mes_ipcba'=>$this->argumentos->tra_mes));        
        if(!$tabla_parametros->obtener_leido()){
            return new Respuesta_Negativa("No coincide el anio/mes ingresado con el existente en la tabla parametros");
        }        
        $salida='';
        $tabla_valcan=$this->nuevo_objeto("Tabla_valcan");
        $tabla_valcan->leer_uno_si_hay(array('pla_ope'=>$this->argumentos->tra_ope));
        $tabla_bitacora=$this->nuevo_objeto("Tabla_bitacora");
        $tabla_valcan->leer_uno_si_hay(array('pla_ope'=>$this->argumentos->tra_ope));
        $this->db->beginTransaction();
        try{
            $sqls=array(
                        <<<SQL
                            delete from encu.valcan where pla_ope='{$this->argumentos->tra_ope}';
SQL
                        , <<<SQL
                                select encu.importar_canastas_fun(); 
SQL
            );
            foreach($sqls as $sql_parcial){
                    $this->db->ejecutar_sql(new Sql($sql_parcial));
                }
        }catch(Exception $e){
                $this->db->rollBack();
                return new Respuesta_Negativa($e->getMessage());
            }
        $this->db->commit();
        return new Respuesta_Positiva("Todo ok. Se exporto correctamente linea de pobreza e indigencia");
    }
}
class Vista_valcan extends Vistas{
    function definicion_estructura(){
        $this->definir_campo('vis_ope'                    ,array('agrupa'=>true,'tipo'=>'texto','origen'=>'pla_ope'               ));
        $this->definir_campo('vis_ca_p'                   ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_ca_p'            ));
        $this->definir_campo('vis_alquiler_p'             ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>' pla_alquiler_p'     ));
        $this->definir_campo('vis_gastosexpensas_p'       ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_gastoexpensas_p' ));     
        $this->definir_campo('vis_gas_p'                  ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_gas_p'           )); 
        $this->definir_campo('vis_electricidad_p'         ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_electricidad_p'  ));
        $this->definir_campo('vis_agua_p'                 ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_agua_p'          ));
        $this->definir_campo('vis_jardin_p'               ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_jardin_p'        ));
        $this->definir_campo('vis_preescyprim_p'          ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_preescyprim_p'   ));
        $this->definir_campo('vis_secundaria_p'           ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_secundaria_p'    ));
        $this->definir_campo('vis_artytextos_p'           ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_artytextos_p'    ));
        $this->definir_campo('vis_transpu_p'              ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_transpu_p'       ));
        $this->definir_campo('vis_comunicaciones_p'       ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_comunicaciones_p')); 
        $this->definir_campo('vis_limpieza_p'             ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_limpieza_p'      ));
        $this->definir_campo('vis_esparcimiento_p'        ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_esparcimiento_p' ));
        $this->definir_campo('vis_bieneserv_p'            ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_bieneserv_p'     ));
        $this->definir_campo('vis_indadultos_p'           ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_indadultos_p'    ));
        $this->definir_campo('vis_indninios_p'            ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_indninios_p'     ));
        $this->definir_campo('vis_salud_p'                ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_salud_p'         ));
        $this->definir_campo('vis_equipamiento_p'         ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_equipamiento_p'  ));
        $this->definir_campo('vis_ca_c'                   ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_ca_c'            ));
        $this->definir_campo('vis_alquiler_c'             ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_alquiler_c'      ));
        $this->definir_campo('vis_gastoexpensas_c'        ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_gastoexpensas_c' ));
        $this->definir_campo('vis_gas_c'                  ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_gas_c'           ));
        $this->definir_campo('vis_electricidad_c'         ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_electricidad_c'  ));
        $this->definir_campo('vis_agua_c'                 ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_agua_c'          ));
        $this->definir_campo('vis_jardin_c'               ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_jardin_c'        ));
        $this->definir_campo('vis_preescyprim_c'          ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_preescyprim_c'   ));
        $this->definir_campo('vis_secundaria_c'           ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_secundaria_c'    ));
        $this->definir_campo('vis_artytextos_c'           ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_artytextos_c'    ));
        $this->definir_campo('vis_transpu_c'              ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_transpu_c'       ));
        $this->definir_campo('vis_comunicaciones_c'       ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_comunicaciones_c')); 
        $this->definir_campo('vis_limpieza_c'             ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_limpieza_c'      ));
        $this->definir_campo('vis_esparcimiento_c'        ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_esparcimiento_c' ));
        $this->definir_campo('vis_bieneserv_c'            ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_bieneserv_c'     ));
        $this->definir_campo('vis_indadultos_c'           ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_indadultos_c'    ));
        $this->definir_campo('vis_indninios_c'            ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_indninios_c'     ));
        $this->definir_campo('vis_salud_c'                ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_salud_c'         ));
        $this->definir_campo('vis_equipamiento_c'         ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_equipamiento_c'  ));
        $this->definir_campo('vis_axesorios_c'            ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_axesorios_c'     ));
        $this->definir_campo('vis_servind_c'              ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_servind_c'       ));
        /*
        $this->definir_campo('vis_ca_p_t'                 ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_ca_p_t'              ));
        $this->definir_campo('vis_alquiler_p_t'           ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>' pla_alquiler_p_t'       ));
        $this->definir_campo('vis_gastosexpensas_p_t'     ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_gastoexpensas_p_t'   ));     
        $this->definir_campo('vis_gas_p_t'                ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_gas_p_t'             )); 
        $this->definir_campo('vis_electricidad_p_t'       ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_electricidad_p_t'    ));
        $this->definir_campo('vis_agua_p_t'               ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_agua_p_t'            ));
        $this->definir_campo('vis_jardin_p_t'             ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_jardin_p_t'          ));
        $this->definir_campo('vis_preescyprim_p_t'        ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_preescyprim_p_t'     ));
        $this->definir_campo('vis_secundaria_p_t'         ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_secundaria_p_t'      ));
        $this->definir_campo('vis_artytextos_p_t'         ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_artytextos_p_t'      ));
        $this->definir_campo('vis_transpu_p_t'            ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_transpu_p_t'         ));
        $this->definir_campo('vis_comunicaciones_p_t'     ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_comunicaciones_p_t'  )); 
        $this->definir_campo('vis_limpieza_p_t'           ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_limpieza_p_t'        ));
        $this->definir_campo('vis_esparcimiento_p_t'      ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_esparcimiento_p_t'   ));
        $this->definir_campo('vis_bieneserv_p_t'          ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_bieneserv_p_t'       ));
        $this->definir_campo('vis_indadultos_p_t'         ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_indadultos_p_t'      ));
        $this->definir_campo('vis_indninios_p_t'          ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_indninios_p_t'       ));
        $this->definir_campo('vis_salud_p_t'              ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_salud_p_t'           ));
        $this->definir_campo('vis_equipamiento_p_t'       ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_equipamiento_p_t'    ));
        $this->definir_campo('vis_ca_c_t'                 ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_ca_c_t'              ));
        $this->definir_campo('vis_alquiler_c_t'           ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_alquiler_c_t'        ));
        $this->definir_campo('vis_gastoexpensas_c_t'      ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_gastoexpensas_c_t'   ));
        $this->definir_campo('vis_gas_c_t'                ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_gas_c_t'             ));
        $this->definir_campo('vis_electricidad_c_t'       ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_electricidad_c_t'    ));
        $this->definir_campo('vis_agua_c_t'               ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_agua_c_t'            ));
        $this->definir_campo('vis_jardin_c_t'             ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_jardin_c_t'          ));
        $this->definir_campo('vis_preescyprim_c_t'        ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_preescyprim_c_t'     ));
        $this->definir_campo('vis_secundaria_c_t'         ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_secundaria_c_t'      ));
        $this->definir_campo('vis_artytextos_c_t'         ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_artytextos_c_t'      ));
        $this->definir_campo('vis_transpu_c_t'            ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_transpu_c_t'         ));
        $this->definir_campo('vis_comunicaciones_c_t'     ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_comunicaciones_c_t'  )); 
        $this->definir_campo('vis_limpieza_c_t'           ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_limpieza_c_t'        ));
        $this->definir_campo('vis_esparcimiento_c_t'      ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_esparcimiento_c_t'   ));
        $this->definir_campo('vis_bieneserv_c_t'          ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_bieneserv_c_t'       ));
        $this->definir_campo('vis_indadultos_c_t'         ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_indadultos_c_t'      ));
        $this->definir_campo('vis_indninios_c_t'          ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_indninios_c_t'       ));
        $this->definir_campo('vis_salud_c_t'              ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_salud_c_t'           ));
        $this->definir_campo('vis_equipamiento_c_t'       ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_equipamiento_c_t'    ));
        $this->definir_campo('vis_axesorios_c_t'          ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_axesorios_c_t'       ));
        $this->definir_campo('vis_servind_c_t'            ,array('agrupa'=>true,'tipo'=>'decimal','origen'=>'pla_servind_c_t'         ));
    */    
    }
    function clausula_from(){
        return "valcan";
    } 
}
?>