<?php
//UTF-8:SÍ
require_once "tablas.php";

class Tabla_novobs extends Tabla{
    function definicion_estructura(){
    $this->con_campos_auditoria=false;
    $this->definir_esquema('cvp');
    $this->definir_campo('periodo'     ,array('tipo'=>'texto','largo'=>11, 'es_pk'=>true));
    $this->definir_campo('calculo'     ,array('tipo'=>'entero', 'es_pk'=>true));
    $this->definir_campo('producto'    ,array('tipo'=>'texto','largo'=>8, 'es_pk'=>true));
    $this->definir_campo('informante'  ,array('tipo'=>'entero', 'es_pk'=>true));
    $this->definir_campo('observacion' ,array('tipo'=>'entero', 'es_pk'=>true));
    $this->definir_campo('estado'      ,array('tipo'=>'texto','largo'=>18));
    $this->definir_campo('usuario'     ,array('tipo'=>'texto','largo'=>30)); 
    }    
}    
class Grilla_novobs extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="anoenc";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_novobs");
    }
    function campos_editables($filtro_para_lectura){
        return array('estado');
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'       
                                                    ,'calculo' 
                                                    ,'producto' 
                                                    ,'informante'
                                                    ,'observacion'
                                                    ,'usuario'
                                                   ));
    }
}
class Grilla_novobs_campo extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="anoenc";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_novobs");
        $this->tabla->campos_lookup=array(
            "visita"=>false,
            "encuestador"=>false,
            "recepcionista"=>false,
            "nombreproducto"=>false,
            "nombreformulario"=>false,
            "panel"=>false,
            "tarea"=>false
        );
        $this->tabla->tablas_lookup=array(
            "(select r.periodo per, r.producto prod, r.informante inf, r.observacion obs, string_agg(r.visita::text,'|' order by r.visita) as visita, 
              string_agg(distinct v.encuestador||':'||s.nombre||' '||s.apellido,'|') as encuestador,
              string_agg(distinct v.recepcionista||':'||c.nombre||' '||c.apellido,'|') as recepcionista,
              p.nombreproducto, 
              string_agg(distinct fo.nombreformulario,'|') as nombreformulario, 
              string_agg(distinct panel::text, '|') as panel, string_agg(distinct tarea::text,'|') as tarea
              from cvp.perfiltro f 
                join cvp.relpre r on f.periodo = r.periodo
                join cvp.productos p on r.producto = p.producto
                join cvp.formularios fo on r.formulario = fo.formulario
                join cvp.relvis v on r.periodo = v.periodo and r.informante = v.informante and r.formulario = v.formulario and r.visita = v.visita 
                join cvp.personal s on s.persona = v.encuestador
                join cvp.personal c on c.persona = v.recepcionista
                group by r.periodo, r.producto, r.informante, r.observacion, p.nombreproducto) x"
                =>'x.per=periodo and x.prod = producto and x.inf = informante and x.obs = observacion',
        );
    }
    function responder_detallar(){
        return false;
    }
    function campos_editables($filtro_para_lectura){
        return array();
    }    
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'       
                                                    ,'calculo' 
                                                    ,'producto' 
                                                    ,'informante'
                                                    ,'observacion'
                                                    ,'visita'
                                                    ,'usuario'
                                                    ,'encuestador'
                                                    ,'recepcionista'
                                                    ,'nombreproducto'
                                                    ,'nombreformulario'
                                                    ,'panel'
                                                    ,'tarea'
                                                   ));
    }
}
?>