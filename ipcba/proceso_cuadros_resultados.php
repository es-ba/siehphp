<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_cuadros_resultados extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $ahora=new DateTime();
        $ahora->sub(new DateInterval('P1M'));
        //$def_periodo='a'.$ahora->format('Y').'m'.$ahora->format('m');
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT case when min(periodo) is not null then min(periodo) 
                   else (select max(periodo)
                         from calculos c join calculos_def cd on c.calculo = cd.calculo
                         where principal)
                   end as ultimo
              FROM calculos c join calculos_def cd on c.calculo = cd.calculo  
              WHERE abierto='S' and principal
SQL
        ));
        $fila=$cursor->fetchObject();
        $def_periodo=$fila->ultimo;
        $this->definir_parametros(array(
              'titulo'=>'Cuadros',
              'permisos'=>array('grupo'=>'analista_cuadros'),
              'submenu'=>'Resultados',
              'para_produccion'=>true,
              'parametros'=>array(
                   'tra_periodo'=>array('tipo'=>'texto','label'=>'Período','def'=> $def_periodo ),
                   'tra_cuadro'=>array('tipo'=>'texto','label'=>'Cuadro','def'=>'1'),
                   'tra_separador_decimal'=>array('tipo'=>'texto','label'=>'separador decimal','style'=>'width:25px','def'=>',', 'opciones'=>array(','=>array(',','coma'),'.'=>array('.','punto'))),
                   'tra_periodo_desde'=>array('tipo'=>'texto','label'=>'Período desde','def'=> $def_periodo ),
                   'tra_hogar'=>array('tipo'=>'texto','label'=>'Hogar','def'=>'Hogar 1'),
                   'tra_agrupacion'=>array('tipo'=>'texto','label'=>'Agrupación','def'=>'A'),
               ),
              'bitacora'=>true,
              'botones'=>array(
                    array('id'=>'boton_ver','value'=>'ver','otro_control'=>
                       array('id'=>'boton_exportar','innerText'=>'exportar', 'style'=>'visibility:hidden','tipo'=>'a', 'href'=>'.')
                    )
               )
            ));
    }
    function correr(){
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT max(periodo) as ultimo FROM calculos 
SQL
        ));
        $fila=$cursor->fetchObject();
        $ultimo_periodo_calculado=$fila->ultimo;
        //$this->parametros->parametros['tra_periodo']['def']=$ultimo_periodo_calculado;

        $cursor_otro=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT calculo as principal FROM calculos_def where principal 
SQL
        ));
        $fila_otra=$cursor_otro->fetchObject();
        $calculo_principal=$fila_otra->principal;

        $tabla_calculos=$this->nuevo_objeto("Tabla_calculos");
        $tabla_calculos->definir_campos_orden(array('periodo desc'));
        $tabla_hogares=$this->nuevo_objeto("Tabla_hogares");
        $tabla_agrupaciones=$this->nuevo_objeto("Tabla_agrupaciones");
        $tabla_hogares->definir_campos_orden(array('comun.para_ordenar_numeros(hogar)'));
        $this->parametros->parametros['tra_periodo']['opciones']=$tabla_calculos->lista_opciones(array('calculo'=>$calculo_principal),'periodo');
        $this->parametros->parametros['tra_periodo_desde']['opciones']=$tabla_calculos->lista_opciones(array('calculo'=>$calculo_principal),'periodo');
        $this->parametros->parametros['tra_hogar']['opciones']=$tabla_hogares->lista_opciones(array());
        $this->parametros->parametros['tra_agrupacion']['opciones']=$tabla_agrupaciones->lista_opciones(array());
        
        $tabla_cuadros=$this->nuevo_objeto("Tabla_cuadros");
        $this->parametros->parametros['tra_cuadro']['opciones']=$tabla_cuadros->lista_opciones(array('activo'=>'S'));
        // en periodos el filtro será algo así como array('cerrado'=>false)
        parent::correr();
        //    vartraperiododesde.disabled =!(vartracuadro.value.indexOf("HC")>=0);

        $this->salida->enviar_script(<<<JS
            function habilitar_y_deshabilitar_parametros_cuadros(){
               var vartraperiododesde = document.getElementById("tra_periodo_desde");
               var vartrahogar = document.getElementById("tra_hogar");
               var vartracuadro = document.getElementById("tra_cuadro");
               var vartraagrupacion = document.getElementById("tra_agrupacion")
               vartraperiododesde.disabled =!/X+|HC|5|10|11|P|_var+|h+|9b|CC|I/.test(vartracuadro.value);
               vartrahogar.disabled =!/HC|I/.test(vartracuadro.value);
               vartraagrupacion.disabled =!/X+|H+/.test(vartracuadro.value);
               var flechaopcper= vartraperiododesde.parentNode.getElementsByTagName('img')[0];
               var varopcperfun=(vartraperiododesde.disabled)?'return;':"mostrar_opciones('opciones_de_tra_periodo_desde')";
               flechaopcper.setAttribute('onClick',varopcperfun);
               var flechaopchog= vartrahogar.parentNode.getElementsByTagName('img')[0];
               var varopchogfun=(vartrahogar.disabled)?'return;':"mostrar_opciones('opciones_de_tra_hogar')";
               flechaopchog.setAttribute('onClick',varopchogfun);
            }
            window.addEventListener('load',function(){
                setInterval(habilitar_y_deshabilitar_parametros_cuadros,1000);
            });
JS
        );
    }
    //!(vartracuadro.value.indexOf("HC")>=0)
    function responder(){
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
           SELECT * from cvp.cuadros  WHERE cuadro=:tra_cuadro
SQL
           , array(':tra_cuadro'=>$this->argumentos->tra_cuadro)
        ));
        $fila=$cursor->fetchObject();        
        $funcion_a_llamar=$fila->funcion; 
        // PONGO OR TRUE en usa_periodo porque si no no hay que pasar el periodo abajo en el parámetro de la llamada, así se pasa siempre. 
        //|| CASE WHEN f.usa_agrupacion    THEN ','''||c.agrupacion|| '''' ELSE '' END 
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
           select CASE WHEN f.usa_parametro1    THEN ''''||c.parametro1|| '''' ELSE '' END 
               || CASE WHEN f.usa_periodo       THEN ', :tra_periodo' ELSE '' END 
               || CASE WHEN f.usa_nivel         THEN ','||c.nivel::text ELSE '' END 
               || CASE WHEN f.usa_grupo         THEN ','''||c.grupo|| '''' ELSE '' END 
               || CASE WHEN f.usa_agrupacion    THEN ','||CASE WHEN :tra_cuadro in ('HC','H1','HH','HC_var','HH_var','X1','X2','LH','LH_var') THEN ''''||:tra_agrupacion||'''' ELSE ''''||c.agrupacion|| '''' END ELSE '' END 
               || CASE WHEN f.usa_ponercodigos  THEN ','||c.ponercodigos::text ELSE '' END 
               || CASE WHEN f.usa_agrupacion2   THEN ','''||c.agrupacion2|| '''' ELSE '' END 
               || CASE WHEN f.usa_cuadro        THEN ','''||c.cuadro|| '''' ELSE '' END 
               || CASE WHEN f.usa_hogares       THEN ','||CASE WHEN :tra_cuadro in ('HC','HC_var','I') THEN ''''||:tra_hogar||'''' ELSE c.hogares::text END ELSE '' END 
               || CASE WHEN f.usa_cantdecimales THEN ','||c.cantdecimales::text ELSE '' END 
               || CASE WHEN f.usa_desde         THEN ','''||CASE WHEN :tra_cuadro in ('X1','X2','HC','HC_var','HH_var','5','10','11','P','LH_var','9b','CC','I') OR :tra_cuadro like '%h%' THEN :tra_periodo_desde ELSE '' END|| '''' ELSE '' END 
               || CASE WHEN f.usa_orden         THEN ','''||c.orden|| '''' ELSE '' END
               || CASE WHEN f.usa_empalmedesde  THEN ','||c.empalmedesde::text ELSE '' END 
               || CASE WHEN f.usa_empalmehasta  THEN ','||c.empalmehasta::text ELSE '' END 
               || CASE WHEN f.usa_empalmedesde or f.usa_empalmehasta  THEN ','''||p.periodo_empalme||'''' ELSE '' END
               as str_paramfun 
             , f.usa_periodo
             , :tra_separador_decimal::text as separador_decimal
             , CASE WHEN :tra_agrupacion = 'D' THEN c.encabezado2 ELSE c.encabezado END 
               || CASE WHEN :tra_cuadro = '6' OR :tra_cuadro = '7' OR :tra_cuadro = 'LH' THEN '. '||cvp.devolver_mes_anio(:tra_periodo) 
                   WHEN :tra_cuadro like 'HC%' THEN '. '|| cvp.devolver_mes_anio(:tra_periodo_desde)||CASE WHEN :tra_periodo_desde <> :tra_periodo THEN '/'||cvp.devolver_mes_anio(:tra_periodo) ELSE '' END||'. Evolución de su valor en '||CASE WHEN :tra_cuadro like '%var' THEN '%. ' ELSE 'pesos. ' END || :tra_hogar ||'*'
                   WHEN :tra_cuadro like 'I%' THEN  '. '|| cvp.devolver_mes_anio(:tra_periodo_desde)||CASE WHEN :tra_periodo_desde <> :tra_periodo THEN '/'||cvp.devolver_mes_anio(:tra_periodo) ELSE '' END||'. En pesos. '|| :tra_hogar ||'*'
                   WHEN :tra_cuadro like '11' THEN  ' ' || CASE WHEN :tra_periodo_desde <> :tra_periodo THEN cvp.devolver_mes_anio(:tra_periodo_desde)||'/'||cvp.devolver_mes_anio(:tra_periodo) ELSE cvp.devolver_mes_anio(:tra_periodo) END
                   WHEN :tra_cuadro like 'X%' OR :tra_cuadro = 'P' THEN  '. ' || CASE WHEN :tra_periodo_desde <> :tra_periodo THEN cvp.devolver_mes_anio(:tra_periodo_desde)||'/'||cvp.devolver_mes_anio(:tra_periodo) ELSE cvp.devolver_mes_anio(:tra_periodo) END
                   ELSE '' END 
               as encabezado
             , c.pie1, c.pie, '(*)'||h.nombrehogar as piehogar 
          from cvp.cuadros c join cvp.cuadros_funciones f on c.funcion= f.funcion join cvp.parametros p on unicoregistro
               , (SELECT nombrehogar FROM cvp.hogares WHERE hogar = :tra_hogar) h WHERE cuadro=:tra_cuadro and c.activo = 'S'
SQL
           , array(':tra_cuadro'=>$this->argumentos->tra_cuadro,':tra_periodo'=>$this->argumentos->tra_periodo, 
                   ':tra_separador_decimal'=>$this->argumentos->tra_separador_decimal,
                   ':tra_periodo_desde'=>$this->argumentos->tra_periodo_desde,
                   ':tra_hogar'=>$this->argumentos->tra_hogar,
                   ':tra_agrupacion'=>$this->argumentos->tra_agrupacion,
                   )
        ));
        $fila=$cursor->fetchObject();        
        $funcion_parametros=$fila->str_paramfun;
        //echo "<script languaje='javascript'>alert('sql : ".$fila->str_paramfun."')</script>";
        $funcion_separador=$fila->separador_decimal;
        $parametros=array();
        if($fila->usa_periodo){
            $parametros[':tra_periodo']=$this->argumentos->tra_periodo;
        }
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
           SELECT * from cvp.{$funcion_a_llamar}({$funcion_parametros},'{$funcion_separador}'); 
SQL
           , $parametros
        ));
        $resultado=array();
        while($row=$cursor->fetchObject()){
            $resultado[]=$row;
        }
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
        $tipox=($funcion_a_llamar=='res_cuadro_matriz_hogar_var'||$funcion_a_llamar=='res_cuadro_matriz_hogar'||$funcion_a_llamar=='res_cuadro_matriz_linea'||$funcion_a_llamar=='res_cuadro_matriz_up'||$funcion_a_llamar=='res_cuadro_matriz_canasta'||$funcion_a_llamar=='res_cuadro_matriz_canasta_var'||$funcion_a_llamar=='res_cuadro_matriz_i'||$funcion_a_llamar=='res_cuadro_vc'||$funcion_a_llamar=='res_cuadro_pp'||$funcion_a_llamar=='res_cuadro_matriz_linea_var'||$funcion_a_llamar=='res_cuadro_matriz_hogar_per'||$funcion_a_llamar=='res_cuadro_matriz_ingreso')?'cuadro_cpm':'cuadro_cp';
        $cuadro[]=array('tipox'=>$tipox,'className'=>'cuadro','filas'=>$resultado);
        if ($this->argumentos->tra_cuadro == 'HC'||$this->argumentos->tra_cuadro == 'HC_var'||$this->argumentos->tra_cuadro == 'I') { 
          $poner_parte('piehogar','span');
        }
        $poner_parte('pie1','span');
        $poner_parte('pie','span');
        $cuadro=array('tipox'=>'div','className'=>'cuadro','nodes'=>$cuadro);
        return new Respuesta_Positiva(array('tipo'=>'tedede_cm','tedede_cm'=>$cuadro));
    }
}
?>