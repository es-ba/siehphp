<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_compilar_variables_calculadas extends Proceso_Formulario{
    function __construct(){    
        parent::__construct(array(
            'titulo'=>(substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']>=2015)?'Compilar (o probar) variables calculadas - Modo '. $_SESSION['modo_encuesta']:'Compilar (o probar) variables calculadas ',
            'submenu'=>'procesamiento',
            'parametros'=>array(
                'tra_ope'=>array('label'=>'operativo','def'=>$GLOBALS['NOMBRE_APP'],'invisible'=>true),
                'tra_mostrar_grilla'=>array('label'=>false,'label-derecho'=>'probar una variable, mostrar la grilla resumen y no grabar los resultados','type'=>'checkbox','onclick'=>'refrescar_Proceso_compilar_variables_calculadas(1)'),
                'tra_saltear_compilacion'=>array('label'=>false,'label-derecho'=>'saltear la compilación','type'=>'checkbox','onclick'=>'refrescar_Proceso_compilar_variables_calculadas(3)'),
                'tra_mas_info'=>array('label'=>false,'label-derecho'=>'compilar, volver a calcular todas las variables y grabar resultados','type'=>'checkbox','onclick'=>'refrescar_Proceso_compilar_variables_calculadas(2)'),
                'tra_varcal'=>array('label'=>'variable calculada','def'=>'#todo','aclaracion'=>'no compila las dependientes ni graba resultados'), 
                'tra_estado'=>array('label'=>'estado','disabled'=>true,'style'=>'width:50px','def'=>'77', 'aclaracion'=>'Desde este estado incluyendolo'),
                'tra_estado_hasta'=>array('label'=>'hasta estado', 'disabled'=>true,'style'=>'width:50px','def'=>'80','aclaracion'=>'excluyendo este estado'),
                'tra_agregar_variables'=>array('label'=>'mostrar variables','aclaracion'=>'agregar estas a las variables de contexto (separarlas con coma)','style'=>'width:300px'),
            ),
            'para_produccion'=>true,
            'permisos'=>array('grupo'=>'procesamiento'),
            'bitacora'=>true,
            'boton'=>array('id'=>'compilar'),
        ));
    }
    function correr(){
        parent::correr();
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT x.bit_fin, x.bit_resultado
            FROM
                (SELECT bit_fin, bit_resultado
                   FROM encu.bitacora 
                   WHERE bit_proceso='compilar_variables_calculadas' 
                     AND bit_parametros like '%"tra_varcal":"#todo"%' 
                     AND bit_fin IS NOT NULL 
                 ORDER BY bit_fin desc 
                 LIMIT 5) x 
SQL
        ));
        while($control=$cursor->fetchObject()){       
            $this->salida->enviar("Fecha Compilación de variables: ".($control->bit_fin?:'no hubo').
                ". Resultado de la Compilación de variables: ".$control->bit_resultado,"mensaje_error_grave"
            );        
         };
        $this->salida->enviar_script(<<<JS
function refrescar_Proceso_compilar_variables_calculadas(cual){
"use strict";
    switch(cual){
    case 1:
        tra_mas_info.checked=false;
        tra_mostrar_grilla.checked=true;
        tra_saltear_compilacion.disabled=false;
        break;
    case 2:
        tra_mostrar_grilla.checked=false;
        tra_saltear_compilacion.checked=false;
        tra_saltear_compilacion.disabled=true;
        tra_mas_info.checked=true;
        break;
    case 3:
        tra_mas_info.checked=false;
        tra_mostrar_grilla.checked=true;
        break;
    }
    if(tra_mas_info.checked){
        aclaracion_tra_varcal.style.visibility='hidden';
        tra_estado.disabled=true;
        tra_estado_hasta.disabled=true;
        tra_varcal.value='#todo';
        tra_varcal.disabled=true;
    }
    if(tra_mostrar_grilla.checked){
        aclaracion_tra_varcal.style.visibility='visible';
        tra_estado.disabled=false;
        tra_estado_hasta.disabled=false;
        if(tra_varcal.value=='#todo'){
            tra_varcal.value='';
        }
        tra_varcal.disabled=false;
    }  
}
window.addEventListener('load',function(){
"use strict";
    // setInterval(refrescar_Proceso_compilar_variables_calculadas,500);
});
JS
        );
    }
    function responder(){
        global $db;
           if(!$this->argumentos->tra_mas_info){
            if($this->argumentos->tra_varcal=='#todo'){
                return new Respuesta_Negativa('Falta el tilde');
            }
        }else{
            if($this->argumentos->tra_varcal!='#todo'){
                return new Respuesta_Negativa('para compilar todo no solo debe tildar sino poner #todo');
            }
        }
        if($this->argumentos->tra_mostrar_grilla){
            if($this->argumentos->tra_varcal=='#todo'){
                return new Respuesta_Negativa('la grilla resumen no es para #todo');
            }
            if(!$this->argumentos->tra_saltear_compilacion){
                return new Respuesta_Negativa('No se puede compilar una sola variable. Hay que poner saltear compilación para ver el tabulado y no se usa la sintaxis nueva.');
            }
        }
        if($this->argumentos->tra_saltear_compilacion){
            $que=(object)array('texto'=>'SIN COMPILAR. DATOS CON LA VARIABLE SEGÚN LA ÚLTIMA COMPILACIÓN ANTERIOR');
        }else{
            $cursor=$db->ejecutar_sql(
                new Sql(
                    "select generar_trigger_variables_calculadas(:cuales) as texto",
                    array(':cuales'=>$this->argumentos->tra_varcal)
                )
            );
            $que=$cursor->fetchObject();
        }
        if(substr($que->texto,0,5)=='ERROR'){
            return new Respuesta_Negativa($que->texto);
        }else{
        /*
        while($control=$cursor->fetchObject()){        
            $this->salida=new Armador_de_salida(true);
            $this->salida->enviar('','',array('id'=>'div_grilla2'));
            enviar_grilla($this->salida,'bitacora_varcal',array( 'bit_fin'=>$control->bit_fin,'bit_resultado'=>$control->bit_resultado,'div_grilla2'));
            return $this->salida->obtener_una_respuesta_HTML();
        };
        */                   
            if($this->argumentos->tra_mostrar_grilla){
                $this->salida=new Armador_de_salida(true);
                $this->salida->enviar($que->texto);
                $this->salida->enviar('','',array('id'=>'div_grilla'));
                enviar_grilla($this->salida,'varcal_tabulado',array('varcal_varcal'=>$this->argumentos->tra_varcal,'pla_estado'=>$this->argumentos->tra_estado, 'pla_estado_hasta'=>$this->argumentos->tra_estado_hasta, 'pla_agregar_variables'=>$this->argumentos->tra_agregar_variables),'div_grilla');
                return $this->salida->obtener_una_respuesta_HTML();
            }else{
                return new Respuesta_Positiva($que->texto);
            }
        }
    }
}

?>