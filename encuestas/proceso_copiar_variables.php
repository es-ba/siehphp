<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_copiar_variables extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT min(baspro_baspro) as base
              FROM baspro  
              WHERE baspro_ope='{$GLOBALS['NOMBRE_APP']}'
SQL
        ));
        $fila=$cursor->fetchObject();
        $a_base=$fila->base;
        $de_base=$fila->base;
        $this->definir_parametros(array(
            'titulo'=>'Bases producidas (definición)',
            'permisos'=>array('grupo'=>'programador','grupo2'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_nueva'=>array('tipo'=>'texto','label'=>'Nombre de la nueva base'),
                'tra_base'=>array('tipo'=>'texto','label'=>'Nombre de la base en la cual basarse'),
                'tra_todas'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Agregar todas las variables posibles (relevadas, calculadas y externas)','def'=>false,'disabled'=>false, 'onclick'=>'habilitar_y_deshabilitar_parametros_copia()'),
                'tra_confirmar'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'copiar las variables de la base basada a la nueva base','def'=>true,'disabled'=>true),
                ),
            'bitacora'=>true,
            'boton'=>array('id'=>'boton_copiar_variables','value'=>'agregar base basada en una existente'),
        ));
    }
    function correr(){
        //Loguear('2013-02-22','LLEGUÉ ACÁ: ------------- '.var_export($this->parametros,true));
        $tabla_baspro=$this->nuevo_objeto("Tabla_baspro");
        $tabla_baspro->definir_campos_orden(array('baspro_baspro'));
        $this->parametros->parametros['tra_base']['opciones']=$tabla_baspro->lista_opciones(array('baspro_ope'=>$GLOBALS['NOMBRE_APP']),'baspro_baspro');
        parent::correr();
        //para agregar la grilla debajo:
        $ope_para_filtro = "{$GLOBALS['NOMBRE_APP']}";
        //enviar_grilla($this->salida,'baspro',null,null,array('filtro_manual'=>array('baspro_ope'=>$ope_para_filtro)),false,array('otras_opciones'=>array('agregando_filas_completas'=>true)));
        enviar_grilla($this->salida,'baspro',array(),false,array('otras_opciones'=>array('agregando_filas_completas'=>true)));
        $this->salida->enviar_script(<<<JS
            function habilitar_y_deshabilitar_parametros_copia(){
               var vartrabase = document.getElementById("tra_base");
               var vartratodas = document.getElementById("tra_todas");
               //document.writeln(vartratodas.value.indexOf("on"));
               vartrabase.disabled =tra_todas.checked;
               var flechaopcper= vartrabase.parentNode.getElementsByTagName('img')[0];
               var varopcperfun=(vartrabase.disabled)?'return;':"mostrar_opciones('opciones_de_tra_base')";
               flechaopcper.setAttribute('onClick',varopcperfun);
            }
JS
        );
    }
    function responder(){
        $this->salida=new Armador_de_salida(true);
        if (!$this->argumentos->tra_nueva){
            return new Respuesta_Negativa('Debe especificar una base nueva');        
        }
        if (!$this->argumentos->tra_base && !$this->argumentos->tra_todas){
            return new Respuesta_Negativa('Debe especificar una base en la cual basarse');        
        }
        if ($this->argumentos->tra_base && $this->argumentos->tra_todas){
            return new Respuesta_Negativa('No debe especificar una base en la cual basarse, indicó todas las variables');        
        }
        if ($this->argumentos->tra_base==$this->argumentos->tra_nueva){
            return new Respuesta_Negativa('Debe especificar bases distintas para hacer la copia');        
        }
        $tabla_bp = new tabla_baspro();
        $tabla_bp->contexto=$this;
        $tabla_bp->leer_uno_si_hay(array(
            'baspro_ope'=>"{$GLOBALS['NOMBRE_APP']}",        
            'baspro_baspro'=>$this->argumentos->tra_nueva,
        ));        
        if($tabla_bp->obtener_leido()){
            return new Respuesta_Negativa('Ya existe una base con ese nombre');
        }
        
        $tabla_bp_para_insertar = new tabla_baspro();
        $tabla_bp_para_insertar->contexto=$this;
        $tabla_bp_para_insertar->valores_para_insert=(array(
               'baspro_ope'                  =>"{$GLOBALS['NOMBRE_APP']}",
               'baspro_baspro'               =>$this->argumentos->tra_nueva,
               'baspro_nombre'               =>$this->argumentos->tra_nueva,
               'baspro_cambiar_especiales'   =>false,
               'baspro_sin_pk'               =>false));
        $tabla_bp_para_insertar->ejecutar_insercion();
        if ($this->argumentos->tra_todas) {
            $sentencia_sql = new Sql(<<<SQL
            SELECT x.basprovar_var, x.basprovar_alias, x.basprovar_cantdecimales, 
                   row_number() OVER (ORDER BY x.basprovar_orden)::integer as basprovar_orden
                FROM
                (
                SELECT var_var as basprovar_var, null::text as basprovar_alias, null::integer as basprovar_cantdecimales, null::integer as basprovar_orden
                FROM encu.variables
                WHERE var_ope = '{$GLOBALS['NOMBRE_APP']}' AND var_for is distinct from 'SUP'
                UNION
                SELECT varcal_varcal as basprovar_var, varcal_nombrevar_baseusuario as basprovar_alias, null::integer as basprovar_cantdecimales, null::integer as basprovar_orden
                FROM encu.varcal
                WHERE varcal_activa and varcal_ope = '{$GLOBALS['NOMBRE_APP']}'
                ) AS x
                ORDER BY x.basprovar_orden           
SQL
               , array()
            );
        } else{
            $sentencia_sql = new Sql(<<<SQL
                SELECT * FROM encu.baspro_var where basprovar_ope = '{$GLOBALS['NOMBRE_APP']}' and basprovar_baspro=:tra_base
SQL
               , array(':tra_base'=>$this->argumentos->tra_base)
            );
        }
        $cursor=$this->db->ejecutar_sql($sentencia_sql);
        $datos=$cursor->fetchAll(PDO::FETCH_ASSOC);
        $tabla_basprovar_destino = new tabla_baspro_var();
        $tabla_basprovar_destino->contexto=$this;
        if($datos){
            foreach($datos as $fila){
             $tabla_basprovar_destino->valores_para_insert=(array(
                   'basprovar_ope'           =>"{$GLOBALS['NOMBRE_APP']}",
                   'basprovar_baspro'        =>$this->argumentos->tra_nueva,
                   'basprovar_var'           =>$fila['basprovar_var'],
                   'basprovar_alias'         =>$fila['basprovar_alias'],
                   'basprovar_cantdecimales' =>$fila['basprovar_cantdecimales'],
                   'basprovar_orden'         =>$fila['basprovar_orden']));
             $tabla_basprovar_destino->ejecutar_insercion();
            }
        }
    return new Respuesta_Positiva('Variables para la base ' . $this->argumentos->tra_base . ' copiadas con exito en '. $this->argumentos->tra_nueva .' ('.count(array_keys($datos)).').');
    } 
}
?>