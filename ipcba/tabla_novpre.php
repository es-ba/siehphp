<?php
//UTF-8:SÍ
require_once "tablas.php";

class Tabla_novpre extends Tabla{
    function definicion_estructura(){
    $this->con_campos_auditoria=false;
    $this->definir_esquema('cvp');
    $this->definir_campo('periodo'     ,array('tipo'=>'texto','largo'=>11,'es_pk'=>true));
    $this->definir_campo('producto'    ,array('tipo'=>'texto','largo'=>8,'es_pk'=>true));
    $this->definir_campo('informante'  ,array('tipo'=>'entero','es_pk'=>true));
    $this->definir_campo('observacion' ,array('tipo'=>'entero','es_pk'=>true));
    $this->definir_campo('visita'      ,array('tipo'=>'entero','es_pk'=>true));
    $this->definir_campo('confirma'    ,array('tipo'=>'logico','not_null'=>true,'def'=>false)); 
    $this->definir_campo('comentarios' ,array('tipo'=>'texto','largo'=>8)); 
    $this->definir_campo('usuario'     ,array('tipo'=>'texto','largo'=>30)); 
    }    
}    
class Grilla_novpre extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="novpre";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_novpre");
        $this->tabla->campos_lookup=array(
               "encuestador"=>false,
               "recepcionista"=>false,
               "nombreproducto"=>false,
               "nombreformulario"=>false,
               "panel"=>false,
               "tarea"=>false,
               "infopre"=>false,
               "infopreant"=>false,
               //"infoatr"=>false,
               //"infoatrant"=>false,
           ); 
        $this->tabla->tablas_lookup=array(
            "(SELECT p.periodo per, p.informante inf, p.formulario, p.observacion obs, p.producto prod, p.visita vis, 
              r.encuestador||':'||e.nombre||' '||e.apellido as encuestador, 
              r.recepcionista||':'||c.nombre||' '||c.apellido as recepcionista 
              FROM cvp.relvis r 
                left join cvp.relpre p on r.periodo = p.periodo and r.visita = p.visita and r.formulario = p.formulario and r.informante = p.informante
                left join cvp.personal e on r.encuestador = e.persona
                left join cvp.personal c on r.recepcionista = c.persona
              ) as pe"
            =>'pe.per=periodo and pe.prod = producto and pe.obs = observacion and pe.inf = informante and pe.vis = visita',
            "(SELECT producto prod, nombreproducto FROM cvp.productos) as n"
            => 'n.prod = producto',
            
            "(SELECT v.periodo per, v.informante inf, r.producto prod, r.observacion obs, v.visita vis, 
               v.formulario||':'||f.nombreformulario as nombreformulario 
              FROM cvp.relvis v
                left join cvp.relpre r on v.periodo = r.periodo and v.informante = r.informante and v.visita = r.visita
                          and v.formulario = r.formulario                
                left join cvp.formularios f on v.formulario = f.formulario
              ) as fe"
            =>'fe.per=periodo and fe.prod = producto and fe.inf = informante and fe.obs = observacion and fe.vis = visita',
            
            "(SELECT p.periodo per, p.informante inf, p.formulario, p.observacion obs, p.producto prod, p.visita vis, r.panel 
              FROM cvp.relvis r 
                left join cvp.relpre p on r.periodo = p.periodo and r.visita = p.visita and r.formulario = p.formulario 
                and r.informante = p.informante
             ) as pa"
            =>'pa.per=periodo and pa.prod = producto and pa.obs = observacion and pa.inf = informante and pa.vis = visita',
            "(SELECT p.periodo per, p.informante inf, p.formulario, p.observacion obs, p.producto prod, p.visita vis, r.tarea 
              FROM cvp.relvis r 
                left join cvp.relpre p on r.periodo = p.periodo and r.visita = p.visita and 
                r.formulario = p.formulario and r.informante = p.informante
             ) as ta"
            =>'ta.per=periodo and ta.prod = producto and ta.obs = observacion and ta.inf = informante and ta.vis = visita',
            "(SELECT n.periodo as per, n.informante as inf, n.visita as vis, n.producto as prod, n.observacion as obs,
                coalesce(precio::text||';','')||coalesce(tipoprecio||';','')||coalesce(cambio,'') as infopre
                FROM cvp.novpre n 
                  left join cvp.relpre p on n.periodo = p.periodo and n.producto = p.producto and n.observacion = p.observacion and
                  n.informante = p.informante and n.visita = p.visita                
             ) as r"
            =>'r.per=periodo and r.prod = producto and r.obs = observacion and r.inf = informante and r.vis = visita',
            "(SELECT n.periodo as per, n.producto as prod, n.observacion as obs, n.informante as inf, n.visita as vis, 
               coalesce(precio_1::text||';','')||coalesce(tipoprecio_1||';','')||coalesce(cambio_1,'') as infopreant
               FROM cvp.novpre n 
                 left join cvp.relpre_1 r on n.periodo = r.periodo and n.producto = r.producto and n.observacion = r.observacion and
                 n.informante = r.informante and n.visita = r.visita                
             ) as p"
			 =>'p.per=periodo and p.prod = producto and p.obs = observacion and p.inf = informante and p.vis = visita',
            /*
			"(SELECT n.periodo as per, n.producto as prod, n.observacion as obs, n.informante as inf, n.visita as vis, 
                string_agg(atributo||':'||coalesce(valor,''), ';') as infoatr
                FROM cvp.novpre n 
                left join cvp.relatr_1 r on n.periodo = r.periodo and n.producto = r.producto and n.observacion = r.observacion and
                n.informante = r.informante and n.visita = r.visita 
                GROUP BY n.periodo, n.producto, n.observacion, n.informante, n.visita                
             ) as q"
            =>'q.per=periodo and q.prod = producto and q.obs = observacion and q.inf = informante and q.vis = visita',
            "(SELECT n.periodo as per, n.producto as prod, n.observacion as obs, n.informante as inf, n.visita as vis, 
                string_agg(atributo||':'||coalesce(valor_1,''), ';') as infoatrant
                FROM cvp.novpre n 
                  left join cvp.relatr_1 r on n.periodo = r.periodo and n.producto = r.producto and n.observacion = r.observacion and
                  n.informante = r.informante and n.visita = r.visita 
                  GROUP BY n.periodo, n.producto, n.observacion, n.informante, n.visita                
             ) as w"
            =>'w.per=periodo and w.prod = producto and w.obs = observacion and w.inf = informante and w.vis = visita',*/
			
        );
    }
    function campos_editables($filtro_para_lectura){
        return array('confirma'
                     ,'comentarios'
                    );
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'       
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
                                                    ,'infopre'
                                                    ,'infopreant'
                                                    //,'infoatr'
                                                    //,'infoatrant'
                                                    ,'confirma'
                                                    ,'comentarios'
                                                   ));
    }
}

?>