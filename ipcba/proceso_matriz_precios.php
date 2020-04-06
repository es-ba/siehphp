<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_matriz_precios extends Proceso_Formulario{
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
            'titulo'=>'Matriz de precios',
            'permisos'=>array('grupo'=>'analista'),
            'submenu'=>'Gabinete',
            'para_produccion'=>true,
            'en_construccion'=>true,
            'parametros'=>array(
                   'tra_desdeperiodo'=>array('tipo'=>'texto','label'=>'Desde Período','def'=> $def_periodo ),
                   'tra_hastaperiodo'=>array('tipo'=>'texto','label'=>'Hasta Período','def'=> $def_periodo ),
                   'tra_producto'=>array('tipo'=>'texto','label'=>'Producto','def'=>'P0111111'),
                   'tra_variacion'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Variación'),
                   'tra_paneltarea'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Panel-Tarea'),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'ver', 'value' => 'ver', 'script_ok'=>'matriz_precios'),
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
    function responder(){
        $array_salida=array();
        $separadordecimal = '.';
        $sqlPeriodos = <<<SQL
            SELECT periodo as periodo
              FROM Periodos 
              WHERE periodo between :tra_desdeperiodo and :tra_hastaperiodo 
              ORDER BY periodo
SQL;
        $sqlPeriodosLookup = <<<SQL
            SELECT periodo, cvp.devolver_mes_anio(periodo) as periodo_mostrable
              FROM Periodos 
              WHERE periodo between :tra_desdeperiodo and :tra_hastaperiodo 
              ORDER BY periodo
SQL;
        $cursorPeriodos=$this->db->ejecutar_sql(new Sql($sqlPeriodos
           , array(
            ':tra_desdeperiodo'=>$this->argumentos->tra_desdeperiodo,
            ':tra_hastaperiodo'=>$this->argumentos->tra_hastaperiodo
           )
        ));
        $cursorPeriodosLookup=$this->db->ejecutar_sql(new Sql($sqlPeriodosLookup
           , array(
            ':tra_desdeperiodo'=>$this->argumentos->tra_desdeperiodo,
            ':tra_hastaperiodo'=>$this->argumentos->tra_hastaperiodo
           )
        ));
        $datosPeriodosLookup=$cursorPeriodosLookup->fetchAll(PDO::FETCH_OBJ);
        $periodosLookup=array();
        foreach($datosPeriodosLookup as $registro){
            $periodosLookup[$registro->periodo]=$registro->periodo_mostrable;
        }
        $sqlPrecios =  <<<SQL
        SELECT * FROM 
         (SELECT c.division, c.informante, c.observacion, c.periodo, c.periodo
           , case when avg(case when c.antiguedadIncluido>0 then c.promObs else null end)>0 then 
               ROUND(avg(case when c.antiguedadIncluido>0 then c.promObs else null end)::numeric,2)::text else 
               max(case when c.antiguedadexcluido>0 then 'X ' else '' end)||
               string_agg(case when c.antiguedadexcluido>0 then
               substr(comun.a_texto(ROUND(r.precionormalizado::NUMERIC,2)),1,strpos( comun.a_texto(ROUND(r.precionormalizado::NUMERIC,2)) , '.')+2)::text
               else null end,';' ORDER BY r.visita) end as precio
               , max(case when c.antiguedadIncluido>0 then coalesce(c.impObs,'') else 'X' end) as impobs
               , max(coalesce(r.tipoprecio,'')) as tipoprecio
               , max(coalesce(r.cambio,'')) as cambio
               , max(case when r.tipoprecio ='M' then coalesce(comun.a_texto(bp.precio),'') else null end) as blaprecio
               , max(case when r.tipoprecio ='M' then coalesce(bp.tipoprecio,'') else null end) as blatipoprecio
               , max(case when r.tipoprecio ='M' then coalesce(ba.valores,'') else null end) as blavalores
               , case when min(pr.periodo) is not null then '®' else ' ' end as repregunta
SQL;
        if ($this->argumentos->tra_paneltarea) {
            $sqlPrecios .= <<<SQL
                , min(v.panel) as panel, min(v.tarea) as tarea
SQL;
        }
        If ($this->argumentos->tra_variacion) {
            $sqlPrecios .= <<<SQL
                , (case when avg(case when c.antiguedadIncluido>0 then c.promObs else null end)>0 then 
                            round((avg(case when c.antiguedadIncluido>0 then c.promObs else null end)
                                   /avg(case when c.antiguedadIncluido>0 then c_1.promObs else null end)*100-100)::numeric,1)
                            else null end)::text as variacion
SQL;
        }
        $sqlPrecios .= <<<SQL
          FROM cvp.calobs c
          LEFT JOIN cvp.relpre r on r.informante=c.informante and r.producto=c.producto and r.periodo=c.periodo and r.observacion=c.observacion
SQL;
        If ($this->argumentos->tra_variacion) {
            $sqlPrecios .= <<<SQL
               LEFT JOIN cvp.periodos p ON c.periodo = p.periodo
               LEFT JOIN cvp.calobs c_1 ON c_1.periodo = p.periodoanterior and c_1.calculo = c.calculo and c_1.producto = c.producto and 
                           c_1.informante = c.informante and c_1.observacion = c.observacion
SQL;
        }
        if ($this->argumentos->tra_paneltarea) {
          $sqlPrecios .= <<<SQL
          LEFT JOIN cvp.relvis v on v.informante=r.informante and v.periodo=r.periodo and v.visita=r.visita and v.formulario=r.formulario
SQL;
        }
        $sqlPrecios .= <<<SQL
          LEFT JOIN cvp.prerep pr on pr.informante=c.informante and pr.producto=c.producto and pr.periodo=c.periodo
          LEFT JOIN cvp.blapre bp on r.informante=bp.informante and r.producto=bp.producto and r.periodo=bp.periodo and r.observacion=bp.observacion and r.visita = bp.visita
          LEFT JOIN (SELECT periodo, producto, informante, observacion, visita, string_agg(valor,',' ORDER BY atributo) as valores
                       FROM cvp.blaatr
                       WHERE Valor Is Not Null
                       GROUP BY periodo, producto, informante, observacion, visita) ba
                       on r.informante=ba.informante and r.producto=ba.producto and r.periodo=ba.periodo and r.observacion=ba.observacion and r.visita = ba.visita
        , cvp.revisor_parametros rr
        WHERE c.producto=:tra_producto and c.calculo=0 and c.periodo between :tra_desdeperiodo and :tra_hastaperiodo
        GROUP BY c.division, c.informante, c.observacion, c.periodo) as X
        ORDER BY 1,2,3,4
SQL;
        
        $cursorPrecios=$this->db->ejecutar_sql(new Sql($sqlPrecios
           , array(
            ':tra_producto'=>$this->argumentos->tra_producto,
            ':tra_desdeperiodo'=>$this->argumentos->tra_desdeperiodo,
            ':tra_hastaperiodo'=>$this->argumentos->tra_hastaperiodo
           )
        ));
        
        //return new Respuesta_Positiva($sqlPrecios);
        return new Respuesta_Positiva(array(
            'columnas'=>$cursorPeriodos->fetchAll(PDO::FETCH_OBJ),
            'cuerpo'=>$cursorPrecios->fetchAll(PDO::FETCH_OBJ),
            'campos'=>array(
                'division'         =>array('titulo'=>'división'      ,'tipo'=>'texto'   ,'posicion'=>'izquierda'),
                'informante'       =>array('titulo'=>'informante'    ,'tipo'=>'numerico','posicion'=>'izquierda'),
                'observacion'      =>array('titulo'=>'obs'           ,'tipo'=>'numerico','posicion'=>'izquierda'),
                'periodo'          =>array('titulo'=>'período'       ,'tipo'=>'periodo' ,'posicion'=>'arriba'   , 'lookup'=>$periodosLookup),
                'precio'           =>array('titulo'=>'precio'        ,'tipo'=>'numerico','posicion'=>'centro'   ),
                'tipoprecio'       =>array('titulo'=>'T.P.'          ,'tipo'=>'texto'   ,'posicion'=>'centro'   ),
                'impobs'           =>array('titulo'=>'imp'           ,'tipo'=>'texto'   ,'posicion'=>'centro'   ),
                'cambio'           =>array('titulo'=>'cambio'        ,'tipo'=>'texto'   ,'posicion'=>'centro'   ),
                'blaprecio'        =>array('titulo'=>'blaprecio'     ,'tipo'=>'texto'   ,'posicion'=>'centro'   ),
                'blatipoprecio'    =>array('titulo'=>'blatipoprecio' ,'tipo'=>'texto'   ,'posicion'=>'centro'   ),
                'blavalores'       =>array('titulo'=>'blavalores'    ,'tipo'=>'texto'   ,'posicion'=>'centro'   ),
                'repregunta'       =>array('titulo'=>'repregunta'    ,'tipo'=>'texto'   ,'posicion'=>'centro'   ),
                'panel'            =>array('titulo'=>'panel'         ,'tipo'=>'texto'   ,'posicion'=>'centro'   ),
                'tarea'            =>array('titulo'=>'tarea'         ,'tipo'=>'texto'   ,'posicion'=>'centro'   ),
                'variacion'        =>array('titulo'=>'variacion'     ,'tipo'=>'texto'   ,'posicion'=>'centro'   ),
            ),
            'titulo'=>'Matriz de precios'
        ));
    }
}
?>