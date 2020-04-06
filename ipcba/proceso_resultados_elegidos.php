<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_resultados_elegidos extends Proceso_Formulario{
    var $lista_indicadores= array('variación (redondeada)','variación sin redondear'
                            ,'incidencia redondeada','incidencia sin redondear','índice'
                            ,'índice redondeado','grupo antecesor','nivel','ponderador relativo');
    var $lista_indvariables=array('variación (redondeada)'=>'variacion','variación sin redondear'=>'variacionsinredondear'
                            ,'incidencia redondeada'=>'incidenciaredondeada','incidencia sin redondear'=>'incidenciasinredondear','índice'=>'indice'
                            ,'índice redondeado'=>'indiceredondeado','grupo antecesor'=>'grupoantecesor','nivel'=>'nivel','ponderador relativo'=>'ponderadorrelativo');
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT max(periodo) as ultimocalculo
              FROM calculos
              WHERE calculo = 0 
SQL
        ));
        $fila=$cursor->fetchObject();
        $ultimo_periodo_calculado=$fila->ultimocalculo;

        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT periodoanterior as anterior
              FROM periodos 
              WHERE periodo = '$ultimo_periodo_calculado'              
SQL
        ));
        $fila=$cursor->fetchObject();
        $def_periodo=$fila->anterior;

        $this->definir_parametros(array(
            'titulo'=>'Resultados (permite elegir columnas)',
            'submenu'=>'Resultados',
            'parametros'=>array(
                'tra_agrupacion'=>array('tipo'=>'texto','label'=>'Agrupacion','def'=> 'Z'),
                'tra_periodo'=>array('tipo'=>'texto','label'=>'Período','def'=> $ultimo_periodo_calculado),
                'tra_1_indicador'=>array('tipo'=>'texto','label'=>'Indicador','def'=>$this->lista_indicadores[0]),
                'tra_1_contraperiodo'=>array('tipo'=>'texto','label'=>'Contra período','def'=> $def_periodo),
                'tra_1_contranivel'=>array('tipo'=>'texto','label'=>'Contra nivel','def'=> '-1'),
             ),
            'para_produccion'=>true,
            'permisos'=>array('grupo'=>'analista'),
            'bitacora'=>true,
            'botones'=>array(
                array('id'=>'Más columnas','onclick'=>'mas_columnas_proceso_resultados_elegidos(this)'),
                array('id'=>'Ver','onclick'=>'ver_proceso_resultados_elegidos(this)')
            )
        ));
    }
    function correr(){
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT max(periodo) as ultimocalculo
              FROM calculos
              WHERE calculo = 0
SQL
        ));
        $fila=$cursor->fetchObject();
        $ultimo_periodo_calculado=$fila->ultimocalculo;
        
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT periodoanterior as anterior
              FROM periodos 
              WHERE periodo = '$ultimo_periodo_calculado'              
SQL
        ));
        $fila=$cursor->fetchObject();
        $def_periodo=$fila->anterior;
        $tabla_agrupacion=$this->nuevo_objeto("Tabla_agrupaciones");
        $tabla_agrupacion->definir_campos_orden(array('agrupacion'));
        $this->parametros->parametros['tra_agrupacion']['opciones']=$tabla_agrupacion->lista_opciones(array());
        $tabla_calculo=$this->nuevo_objeto("Tabla_calculos");
        $tabla_calculo->definir_campos_orden(array('periodo desc'));
        $this->parametros->parametros['tra_periodo']['opciones']=$tabla_calculo->lista_opciones(array('calculo'=>0),'periodo');
        $this->parametros->parametros['tra_1_indicador']['opciones']=$this->lista_indicadores;
        $tabla_periodo=$this->nuevo_objeto("Tabla_periodos");
        $tabla_periodo->definir_campos_orden(array('periodo desc'));
        $this->parametros->parametros['tra_1_contraperiodo']['opciones']=array_slice($this->parametros->parametros['tra_periodo']['opciones'],1);
        $this->parametros->parametros['tra_1_contranivel']['opciones']=array('-1'=>array('-1','padre'),array('0','nivel general'),array('1','división'),'2','3','4','5');
        //Loguear('2014-02-20','LLEGUÉ ACÁ: ------------- '.var_export($this->parametros,true));

        parent::correr();
        $this->salida->enviar_script(<<<JS
            function habilitar_y_deshabilitar_parametros(){
                var cant_cols=campos_proceso_resultados_elegidos[campos_proceso_resultados_elegidos.length-1].split('_')[1];
                for (var i=1; i<=cant_cols; i++){
                    var varcontraperiodo = document.getElementById("tra_"+i+"_contraperiodo");
                    var varcontranivel = document.getElementById("tra_"+i+"_contranivel");
                    var varindicador = document.getElementById("tra_"+i+"_indicador");
                    varcontraperiodo.disabled =!(varindicador.value.indexOf("varia")>=0||varindicador.value.indexOf("incid")>=0);
                    varcontranivel.disabled =!(varindicador.value.indexOf("incid")>=0||varindicador.value.indexOf("grupo")>=0||varindicador.value.indexOf("ponde")>=0);
                    var flechaopcper= varcontraperiodo.parentNode.getElementsByTagName('img')[0];
                    var varopcperfun=(varcontraperiodo.disabled)?'return;':"mostrar_opciones('opciones_de_tra_"+i+"_contraperiodo')";
                    flechaopcper.setAttribute('onClick',varopcperfun);
                    var flechaopcniv= varcontranivel.parentNode.getElementsByTagName('img')[0];
                    var varopcnivfun=(varcontranivel.disabled)?'return;':"mostrar_opciones('opciones_de_tra_"+i+"_contranivel')";
                    flechaopcniv.setAttribute('onClick',varopcnivfun);
                    
                    //alert(varcontraperiodo.getElementsByClassName("mostrar_opciones_boton").innerHTML);
               }
            }
            window.addEventListener('load',function(){
                setInterval(habilitar_y_deshabilitar_parametros,1000);
            });
JS
        );
    }
// <img src="../imagenes/mopciones.png" onclick="mostrar_opciones('opciones_de_tra_1_contraperiodo')" class="mostrar_opciones_boton">
//            window.addEventListener('load',function(){
//                setTimeout(habilitar_y_deshabilitar_parametros,1000);

    function responder(){
        $cad_invalidos='';
        $val_ind='';//tendra el valor del indicador
        foreach ($this->argumentos as $clave => $valor){
            $vclave=explode('_', $clave);
            $val_ind= (count($vclave)===3 and $vclave[2]==='indicador')?$valor:$val_ind;
            if (count($vclave)===3 and $vclave[2]==='contraperiodo'
                 and $valor >= $this->argumentos->tra_periodo
                   and !(strpos($val_ind, 'variac')===false and strpos($val_ind, 'incid')===false)){
                   $cad_invalidos= $cad_invalidos . " $vclave[1] ";
            }
        }
        if (strlen($cad_invalidos)>0){
            return new Respuesta_Negativa("Error, Contraperiodo debe ser < a periodo en las columna/s: $cad_invalidos ");
        }
        $this->salida=new Armador_de_salida(true);
        $this->salida->enviar('','',array('id'=>'div_calgru'));
        $parametros=array();
        $columna_ant=-1;
        reset($this->argumentos);
        foreach ($this->argumentos as $clave => $valor){
            $nuevaclave = str_replace('tra_','',$clave);
            $nuevovalor = $valor;
            $pos = strpos($nuevaclave, '_');
            if (!($pos === false)){
                $indice= explode('_',$nuevaclave);
                $nuevaclave = $indice[1].$indice[0];
                $nuevovalor = ($indice[0]!=$columna_ant)?$this->lista_indvariables[$valor]:$valor;
                $columna_ant=$indice[0];
            }
            $parametros[$nuevaclave] = $nuevovalor; 
        }
        //return new Respuesta_Positiva($parametros);
        //Loguear('2014-02-07','Hola: ------------- '.var_export($parametros,true));
        enviar_grilla($this->salida,'calgru_tabulado',$parametros,'div_calgru');
        return $this->salida->obtener_una_respuesta_HTML();
    }
}

?>