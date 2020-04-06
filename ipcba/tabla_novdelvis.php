<?php
//UTF-8:SÍ
require_once "tablas.php";
/*
CREATE TABLE novdelvis (
    periodo character varying(11) NOT NULL,
    informante integer NOT NULL,
    visita integer DEFAULT 1 NOT NULL,
    formulario integer NOT NULL,
    confirma boolean DEFAULT false NOT NULL,
    modi_usu character varying(30),
    modi_fec timestamp without time zone,
    modi_ope character varying(1),
    comentarios character varying(200),
    usuario character varying(30),
    PRIMARY KEY (periodo, informante, visita, formulario),
    FOREIGN KEY (periodo, informante, visita, formulario) REFERENCES relvis(periodo, informante, visita, formulario)
);
*/
class Tabla_novdelvis extends Tabla{
    function definicion_estructura(){
    $this->con_campos_auditoria=false;
    $this->definir_esquema('cvp');
    $this->definir_campo('periodo'     ,array('tipo'=>'texto','largo'=>11,'es_pk'=>true));
    $this->definir_campo('informante'  ,array('tipo'=>'entero','es_pk'=>true));
    $this->definir_campo('visita'      ,array('tipo'=>'entero','es_pk'=>true));
    $this->definir_campo('formulario'  ,array('tipo'=>'entero','es_pk'=>true));
    $this->definir_campo('confirma'    ,array('tipo'=>'logico','not_null'=>true,'def'=>false)); 
    $this->definir_campo('comentarios' ,array('tipo'=>'texto','largo'=>8)); 
    $this->definir_campo('usu'         ,array('tipo'=>'texto','largo'=>30)); 
    }    
}    
class Grilla_novdelvis extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="novdelvis";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_novdelvis");
        $this->tabla->campos_lookup=array(
               "encuestador"=>false,
               //"nombreproducto"=>false,
               "nombreformulario"=>false,
               "panel"=>false,
               "tarea"=>false,
               "usu"=>false,
               //"infopre"=>false,
               //"infopreant"=>false,
               //"infoatr"=>false,
               //"infoatrant"=>false,
           ); 
        $this->tabla->tablas_lookup=array(
            "(SELECT r.periodo per, r.informante inf, r.formulario form, r.visita vis, r.encuestador||':'||e.nombre||' '||e.apellido as encuestador 
              FROM cvp.relvis r 
                left join cvp.personal e on r.encuestador = e.persona
              ) as pe"
            =>'pe.per=periodo and pe.inf = informante and pe.vis = visita and pe.form = formulario',
            /*
            "(SELECT producto prod, nombreproducto FROM cvp.productos) as n"
            => 'n.prod = producto',
            */
            "(SELECT v.periodo per, v.informante inf, v.visita vis, v.formulario form, f.nombreformulario as nombreformulario 
              FROM cvp.relvis v
                left join cvp.formularios f on v.formulario = f.formulario
              ) as fe"
            =>'fe.per=periodo and fe.inf = informante and fe.vis = visita and fe.form = formulario',
            
            "(SELECT r.periodo per, r.informante inf, r.formulario form, r.visita vis, r.panel 
              FROM cvp.relvis r 
             ) as pa"
            =>'pa.per=periodo and pa.inf = informante and pa.vis = visita and pa.form = formulario',
            "(SELECT r.periodo per, r.informante inf, r.formulario form, r.visita vis, r.tarea 
              FROM cvp.relvis r 
             ) as ta"
            =>'ta.per=periodo and ta.inf = informante and ta.vis = visita and ta.form = formulario',
            "(SELECT n.periodo per, n.informante inf, n.formulario form, n.visita vis,
               CASE WHEN n.modi_usu = 'cvpowner' THEN n.usuario ELSE n.modi_usu END as usu
              FROM cvp.novdelvis n 
             ) as na"
            =>'na.per=periodo and na.inf = informante and na.vis = visita and na.form = formulario',
            /*
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
                                                    ,'informante'
                                                    ,'visita'
                                                    ,'formulario'
                                                    ,'nombreformulario'
                                                    ,'usu'
                                                    ,'encuestador'
                                                    ,'panel'
                                                    ,'tarea'
                                                    ,'confirma'
                                                    ,'comentarios'
                                                   ));
    }
}

?>