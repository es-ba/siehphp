<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_matriz_precios_producto extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $ahora=new DateTime();
        $ahora->sub(new DateInterval('P1M'));
        //$def_periodo='a'.$ahora->format('Y').'m'.$ahora->format('m');
         $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT max(periodo) as ultimo
              FROM periodos  
SQL
        ));
        $fila=$cursor->fetchObject();
        $def_periodo=$fila->ultimo;
        $this->definir_parametros(array(
            'titulo'=>'Matriz de precios por producto',
            'permisos'=>array('grupo'=>'analista'),
            'submenu'=>'Resultados',
            'para_produccion'=>true,
            'parametros'=>array(
                   'tra_desdeperiodo'=>array('tipo'=>'texto','label'=>'Desde Período','def'=> $def_periodo ),
                   'tra_hastaperiodo'=>array('tipo'=>'texto','label'=>'Hasta Período','def'=> $def_periodo ),
                   //'tra_proceso'=>array('tipo'=>'texto','label'=>'Proceso','opciones'=>array('Matriz','MatrizV','MatrizVPT'),'style'=>'width:90px', 'def'=>'MatrizVPT' ),
                   'tra_producto'=>array('tipo'=>'texto','label'=>'Producto','def'=>'P0111111'),
                   'tra_variacion'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Variación'),
                   'tra_paneltarea'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Panel-Tarea'),
                   //'tra_tarea'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Tarea'),
                ),
            'bitacora'=>true,
            'boton'=>array('id'=>'ver', 'value' => 'ver'),
        ));
    }
    function correr(){
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT max(periodo) as ultimo FROM periodos 
SQL
        ));
        $fila=$cursor->fetchObject();
        $ultimo_periodo_calculado=$fila->ultimo;
        Loguear('2013-02-22','LLEGUÉ ACÁ: ------------- '.var_export($this->parametros,true));
        //$this->parametros->parametros['tra_periodo']['def']=$ultimo_periodo_calculado;

        $tabla_desdeperiodo=$this->nuevo_objeto("Tabla_periodos");
        $tabla_desdeperiodo->definir_campos_orden(array('periodo desc'));
        $this->parametros->parametros['tra_desdeperiodo']['opciones']=$tabla_desdeperiodo->lista_opciones(array());
        
        $tabla_hastaperiodo=$this->nuevo_objeto("Tabla_periodos");
        $tabla_hastaperiodo->definir_campos_orden(array('periodo desc'));
        $this->parametros->parametros['tra_hastaperiodo']['opciones']=$tabla_hastaperiodo->lista_opciones(array());

        $tabla_productos=$this->nuevo_objeto("Tabla_productos");
        $this->parametros->parametros['tra_producto']['opciones']=$tabla_productos->lista_opciones(array());

        parent::correr();
    }
/*
    function anteriorPeriodo($periodo){
        $anno = substr($periodo, 1, 4);
        $mes = substr($periodo, 6, 2);
        $mes = $mes - 1;
        if ($mes < 1){
            $mes = 12;
            $anno = $anno - 1;
        }
        if ($mes < 10){
            $mes='0'.$mes;
        }
        return 'a' . $anno . 'm' . $mes;
    }  
*/    
    function siguientePeriodo($periodo){
        $anno = substr($periodo, 1, 4);
        $mes = substr($periodo, 6, 2);
        $mes = $mes + 1;
        if ($mes > 12){
            $mes = 1;
            $anno = $anno + 1;
        }
        if ($mes < 10){
            $mes='0'.$mes;
        }
        return 'a' . $anno . 'm' . $mes;
    }  
  
    function responder(){
       $array_salida=array();
       $separadordecimal = '.';
       /*
       $conRelvis = '';
       if ($this->argumentos->tra_variacion && $this->argumentos->tra_paneltarea ) {
          $conRelvis = ' LEFT JOIN cvp.relvis v on v.informante=r.informante and v.periodo=r.periodo and v.visita=r.visita and v.formulario=r.formulario';
       }
       */
       $sqlRevisor = 'SELECT * FROM (SELECT c.division, c.informante, c.observacion ';
       $actual = $this->argumentos->tra_desdeperiodo;
       //$anterior = $this->anteriorPeriodo($this->argumentos->tra_desdeperiodo);
       $anterior = '';
       while ($actual <= $this->argumentos->tra_hastaperiodo) {
       //do {
       //for ($actual = $this->argumentos->tra_desdeperiodo; $actual <= $this->argumentos->tra_hastaperiodo;$actual = $this->siguientePeriodo($actual)){
            //Agregar Sql, " , avg(case when c.periodo='" & Actual & "' and c.antiguedadIncluido>0 then c.promObs else null end) as " & Actual & "_pr"
            $sqlRevisor .=" , case when avg(case when c.periodo='$actual' and c.antiguedadIncluido>0 then c.promObs else null end)>0 ";            
            $sqlRevisor .="   then replace(avg(case when c.periodo='$actual' and c.antiguedadIncluido>0 then c.promObs else null end)::text,'.','$separadordecimal') ";
            $sqlRevisor .="   else max(case when c.periodo='$actual' and c.antiguedadexcluido>0 then 'X '     else '' end)||";
            $sqlRevisor .="      string_agg(case when c.periodo='$actual' and c.antiguedadexcluido>0 then ";
            $sqlRevisor .="      replace(substr(comun.a_texto(ROUND(r.precionormalizado::NUMERIC,6)),1,strpos( comun.a_texto(ROUND(r.precionormalizado::NUMERIC,6)) , '.')+6)::text ";
            $sqlRevisor .="      ,'.','$separadordecimal') else null end,';' ORDER BY r.visita) end as $actual" .'_pr';
            $sqlRevisor .=" , max(case when c.periodo='$actual' then case when c.antiguedadIncluido>0 then coalesce(c.impObs,'')||':' else 'X:' end else null end)";
            $sqlRevisor .="   || coalesce(string_agg(case when c.periodo='$actual' then coalesce(r.tipoprecio,'')";
            $sqlRevisor .="   || coalesce(','||r.cambio,'') ";
            //agregar los atributos y precios de los tipoprecio = M
            $sqlRevisor .="   || case when r.tipoprecio ='M' then coalesce(' '||comun.a_texto(bp.precio),'') ";
            $sqlRevisor .="   || coalesce(' '||bp.tipoprecio,'') || coalesce(' '||ba.valores,'') ELSE '' end";
            //fin agregar los atributos y precios de los tipoprecio = M
            $sqlRevisor .=" else null end, ';' ORDER BY r.visita),'') || case  when  min(pr.periodo)='$actual' and  min(pr.periodo ) is not null then ',®' else ' ' end as  $actual".'_tipo';
            if ($this->argumentos->tra_paneltarea) {
                $sqlRevisor .=" , min(case when c.periodo='$actual' then v.panel else null end) as $actual".'_panel';
                $sqlRevisor .=" , min(case when c.periodo='$actual' then v.tarea else null end) as $actual".'_tarea';
            }
            $anterior = $actual;
            $actual = $this->siguientePeriodo($actual);
            If ($this->argumentos->tra_variacion) {
                $sqlRevisor .=" , replace((case when avg(case when c.periodo='$anterior' and c.antiguedadIncluido>0 then c.promObs else null end)>0 ";
                $sqlRevisor .="   then round((avg(case when c.periodo='$actual' and c.antiguedadIncluido>0 then c.promObs else null end)";
                $sqlRevisor .="        / avg(case when c.periodo='$anterior' and c.antiguedadIncluido>0 then c.promObs else null end)*100-100)::numeric,1)";
                $sqlRevisor .="   else null end)::text,'.','$separadordecimal') as $anterior".'_var';
            }
        }
        //} while ($actual > $this->argumentos->tra_hastaperiodo);
        $sqlRevisor .=" FROM cvp.calobs c ";
        $sqlRevisor .="    LEFT JOIN cvp.relpre r on r.informante=c.informante and r.producto=c.producto and r.periodo=c.periodo ";
        $sqlRevisor .="         and r.observacion=c.observacion ";
        if ($this->argumentos->tra_paneltarea) {
            $sqlRevisor .="    LEFT JOIN cvp.relvis v on v.informante=r.informante and v.periodo=r.periodo and v.visita=r.visita and v.formulario=r.formulario ";
        }
        $sqlRevisor .="    LEFT JOIN cvp.prerep pr on pr.informante=c.informante and pr.producto=c.producto and pr.periodo=c.periodo ";
        //agregar los atributos y precios de los tipoprecio = M
        $sqlRevisor .="    LEFT JOIN cvp.blapre bp on r.informante=bp.informante and r.producto=bp.producto and r.periodo=bp.periodo and r.observacion=bp.observacion and r.visita = bp.visita ";
        $sqlRevisor .="    LEFT JOIN (SELECT periodo, producto, informante, observacion, visita, string_agg(valor,',' ORDER BY atributo) as valores ";
        $sqlRevisor .="               FROM cvp.blaatr ";
        $sqlRevisor .="               WHERE Valor Is Not Null";
        $sqlRevisor .="               GROUP BY periodo, producto, informante, observacion, visita) ba ";
        $sqlRevisor .="               on r.informante=ba.informante and r.producto=ba.producto and r.periodo=ba.periodo and r.observacion=ba.observacion and r.visita = ba.visita ";
        //fin agregar los atributos y precios de los tipoprecio = M
        $sqlRevisor .="       , cvp.revisor_parametros rr ";
        $sqlRevisor .=" WHERE c.producto=:tra_producto and c.calculo=0";
        //Agregar Sql, condicionVersionOk
        $sqlRevisor .=" GROUP BY c.division, c.informante, c.observacion";
        $sqlRevisor .=") as X ";
        //Agregar Sql, " ORDER BY 1,2 NULLS FIRST,3 NULLS FIRST"
        //Agregar Sql, "ORDER BY CASE WHEN division =' ' THEN 2 WHEN informante IS NULL THEN 1 ELSE 3 END, 1 ,2 NULLS FIRST,3 NULLS FIRST"
        $sqlRevisor .=" ORDER BY 1,2,3";
        $cursor=$this->db->ejecutar_sql(new Sql($sqlRevisor
           , array(':tra_producto'=>$this->argumentos->tra_producto)
        ));
        while($fila=$cursor->fetchObject()){
            $array_salida[]=$fila;
        }
        /*
        $poner_parte=function($parte,$tipo) use ($fila,&$cuadro){
            $nodes=array();
            foreach(explode('|||',$fila->{$parte}) as $renglon){
                $renglon=trim($renglon);
                $nodes[]=array('tipox'=>'p', 'nodes'=>array(
                    'tipox'=>strlen($renglon)<13?$tipo:'span',
                    'nodes'=>$renglon
                ));
            }
            $cuadro[]=array('tipox'=>'div', 'className'=>'cuadro_'.$parte, 'nodes'=>$nodes);
        };
        $poner_parte('encabezado','b');
        $tipox=$funcion_a_llamar=='res_cuadro_matriz_hogar'?'cuadro_cpm':'cuadro_cp';
        */
        $tipox='cuadro_cp';
        $cuadro[]=array('tipox'=>$tipox,'className'=>'cuadro','filas'=>$array_salida);
        //$poner_parte('pie1','span');
        //$poner_parte('pie','span');
        $cuadro=array('tipox'=>'div','className'=>'cuadro','nodes'=>$cuadro);
        return new Respuesta_Positiva($cuadro);
        //return new Respuesta_Positiva(array('tipo'=>'tedede_cm','tedede_cm'=>$cuadro));
        //return new Respuesta_Positiva($array_salida);





       
       /*
       $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
       SELECT * FROM (
           SELECT c.division, c.informante, c.observacion 
             FROM cvp.calobs c
             LEFT JOIN cvp.relpre r on r.informante=c.informante and r.producto=c.producto and r.periodo=c.periodo and r.observacion=c.observacion
             LEFT JOIN cvp.prerep pr on pr.informante=c.informante and pr.producto=c.producto and pr.periodo=c.periodo 
             LEFT JOIN cvp.blapre bp on r.informante=bp.informante and r.producto=bp.producto and r.periodo=bp.periodo and r.observacion=bp.observacion and r.visita = bp.visita
             LEFT JOIN (SELECT periodo, producto, informante, observacion, visita, string_agg(valor,',' ORDER BY atributo) as valores 
                          FROM cvp.blaatr
                          WHERE Valor Is Not Null
                          GROUP BY periodo, producto, informante, observacion, visita) ba 
                on r.informante=ba.informante and r.producto=ba.producto and r.periodo=ba.periodo and r.observacion=ba.observacion and r.visita = ba.visita
              , cvp.revisor_parametros rr
            WHERE c.producto=:tra_producto and c.calculo=0
            GROUP BY c.division, c.informante, c.observacion
        ) as X 
        ORDER BY 1,2,3
SQL
           , array(':tra_producto'=>$this->argumentos->tra_producto)
        ));
        while($fila=$cursor->fetchObject()){
            $array_salida[]=$fila;
        }
        */
        //return new Respuesta_Positiva($array_salida);
        //return new Respuesta_Positiva($sqlRevisor);
    
    
    
    
    
    
    
    
    
    
    
    
/*    
        //$tra_desdeperiodo=$this->argumentos->tra_desdeperiodo;
        //$tra_hastaperiodo=$this->argumentos->tra_hastaperiodo;
        //$tra_proceso=$this->argumentos->tra_proceso;
        //$tra_producto=$this->argumentos->tra_producto;
        $this->salida=new Armador_de_salida(true);
        $this->salida->enviar('','',array('id'=>'div_matriz_precios_producto'));
        //enviar_grilla($this->salida,'vista_matriz_precios_producto',array('producto'=>$tra_producto),'div_matriz_precios_producto');
        enviar_grilla($this->salida,'vista_matriz_precios_producto',array(),'div_matriz_precios_producto');
        //'desdeperiodo'=>$tra_desdeperiodo,'hastaperiodo'=>$tra_hastaperiodo,'proceso'=>$tra_proceso,'producto'=>$tra_producto
        return $this->salida->obtener_una_respuesta_HTML();
*/
        }    
  /*  
    function responder(){
        $this->salida=new Armador_de_salida(true);
        if (!$this->argumentos->tra_motivocopia){
            return new Respuesta_Negativa('Debe especificar motivo de copia del calculo');        
        }
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT max(calculo) as ult_calculo FROM calculos where periodo=:tra_periodo
SQL
           , array(':tra_periodo'=>$this->argumentos->tra_periodo)
        ));
        $fila=$cursor->fetchObject();
        $calculo_destino=$fila->ult_calculo+1;
        $tabla_calculos_def = new tabla_calculos_def();
        $tabla_calculos_def->contexto=$this;
        $tabla_calculos_def->leer_uno_si_hay(array(
            'calculo'=>$calculo_destino
        ));        
        if(!$tabla_calculos_def->obtener_leido()){
            $tabla_calculos_def->valores_para_insert=(array(
                   'calculo'    =>$calculo_destino,
                   'definicion' =>'Copia del Calculo'));
            $tabla_calculos_def->ejecutar_insercion();
        }    
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT * from cvp.calculos  WHERE periodo=:tra_periodo AND calculo=:tra_calculo_destino
SQL
            , array(':tra_periodo'=>$this->argumentos->tra_periodo, ':tra_calculo_destino'=>$calculo_destino )
        ));
        $fila=$cursor->fetchObject();
        if(!!$fila){
            return new Respuesta_Negativa('Ya hay una copia del calculo periodo '. $this->argumentos->tra_periodo . ' calculo destino '. $calculo_destino);
        }else{
            $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
                SELECT 1 as hay_calculo FROM cvp.calculos where periodo=:tra_periodo and calculo=0
SQL
                , array(':tra_periodo'=>$this->argumentos->tra_periodo)
            ));
            $hay_calculo=$cursor->fetchObject();
            if($hay_calculo){
                $time_start = microtime(true);
                $this->db->ejecutar_sql(new Sql("select cvp.copiarcalculo(:tra_periodo, 0, :tra_periodo, :tra_calculo_destino, :tra_motivocopia)",
                                    array(':tra_periodo'=>$this->argumentos->tra_periodo, ':tra_periodo'=>$this->argumentos->tra_periodo,':tra_calculo_destino'=>$calculo_destino, ':tra_motivocopia'=>$this->argumentos->tra_motivocopia )));
                $demora = round(microtime(true) - $time_start);
                return new Respuesta_Positiva('Calculo copiado con éxito en calculo=' . $calculo_destino. '. Copia hecha en '. $demora .' segundos');
            }else{
                return new Respuesta_Negativa('No habia datos del periodo '. $this->argumentos->tra_periodo .' para copiar');
            }
        }        
    return $this->salida->obtener_una_respuesta_HTML();
    }
    */
}
?>