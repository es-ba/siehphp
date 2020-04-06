<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_ingreso_formulario extends Proceso_Formulario{
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
            'titulo'=>'Ingreso de formularios',
            'permisos'=>array('grupo'=>'ingresador'),
            'submenu'=>'Ingreso',
            'para_produccion'=>true,
            'horizontal'=>true,
            'parametros'=>array(
                   'tra_periodo'=>array('tipo'=>'texto','label'=>'Período','style'=>'width:100px'),
                   'tra_informante'=>array('tipo'=>'texto','label'=>'Informante','style'=>'width:70px'),
                   'tra_formulario'=>array('tipo'=>'texto','label'=>'Formulario','style'=>'width:40px'),
                   'tra_visita'=>array('tipo'=>'texto','label'=>'Visita','style'=>'width:30px'),
            ),
            'bitacora'=>true, // provisorio
            'en_construccion'=>true,
            'boton'=>array('id'=>'ver', 'value' => 'ver', 'script_ok'=>'mostrar_pantalla_ingreso'),
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

        $tabla_hastaperiodo=$this->nuevo_objeto("Tabla_periodos");
        $tabla_hastaperiodo->definir_campos_orden(array('periodo desc'));
        $this->parametros->parametros['tra_periodo']['opciones']=$tabla_hastaperiodo->lista_opciones(array());
        /* AGREGAR:
        $tabla_formularios=$this->nuevo_objeto("Tabla_formularios");
        $this->parametros->parametros['tra_producto']['opciones']=$tabla_formularios->lista_opciones(array());
        */
        parent::correr();
    }
    function responder(){
        $parametros=array(
            ':tra_periodo'=>$this->argumentos->tra_periodo,
            ':tra_informante'=>$this->argumentos->tra_informante,
            ':tra_formulario'=>$this->argumentos->tra_formulario,
            ':tra_visita'=>$this->argumentos->tra_visita,
        );
        $partevis=<<<SQL
           select r.periodo, r.informante, i.nombreinformante, r.visita, r.formulario, f.nombreformulario, 
                  r.panel, r.tarea, r.fechasalida, r.fechaingreso, r.encuestador,
                  r.supervisor, r.recepcionista, r.ingresador, r.razon, z.nombrerazon
             from cvp.relvis r 
               inner join cvp.formularios f on r.formulario = f.formulario
               inner join cvp.informantes i on r.informante = i.informante
               left join cvp.razones z on z.razon=r.razon
             where r.periodo=:tra_periodo and r.informante=:tra_informante and r.visita=:tra_visita and r.formulario=:tra_formulario
             order by r.periodo, r.informante, r.visita, r.formulario
SQL;
        $partepre=Proceso_guardar_relpre::sql_select($parametros);
        $parteatr=<<<SQL
           select a.periodo, a.producto, a.observacion, a.informante, a.atributo, t.nombreatributo, a.valor, a_1.valor_1, 
               case when t.tipodato='N' then
                   case when (a.valor::decimal)<rangodesde then 'menor'
                        when (a.valor::decimal)>rangohasta then 'mayor'
                        else 'ok' end 
                 else 'ok' end as fueraderango,
               a.visita, t.tipodato, pa.orden, pa.rangodesde, pa.rangohasta, pa.alterable, pa.normalizable
             from cvp.relpre p 
               left join cvp.relatr a on p.periodo = a.periodo and p.informante = a.informante and p.producto = a.producto and
                                         p.observacion = a.observacion and p.visita = a.visita
               left join cvp.relatr_1 a_1 on a.periodo = a_1.periodo and a.informante = a_1.informante and a.producto = a_1.producto and
                                         a.observacion = a_1.observacion and a.visita = a_1.visita and a.atributo = a_1.atributo
               left join cvp.atributos t on a.atributo = t.atributo
               left join cvp.prodatr pa on a.producto = pa.producto and a.atributo = pa.atributo
             where p.periodo=:tra_periodo and p.informante=:tra_informante and p.visita=:tra_visita and p.formulario=:tra_formulario
             order by a.periodo, a.informante, a.visita, a.producto, a.observacion, pa.orden
SQL;
        $partes=array(
            'relvis'=>array('sql'=>$partevis),
            'relpre'=>array('sql'=>$partepre),
            'relatr'=>array('sql'=>$parteatr),
        );
        $rta=array();
        foreach($partes as $id_parte=>$def_parte){
            $cursor=$this->db->ejecutar_sql(new Sql($def_parte['sql'], $parametros));
            $filas=$cursor->fetchAll(PDO::FETCH_OBJ);
            $rta[$id_parte]=array('filas'=>$filas);
        }
        return new Respuesta_Positiva($rta);
    }
}
?>