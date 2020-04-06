<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_relpre extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        //$this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'          ,array('hereda'=>'periodos','es_pk'=>true,'modo'=>'pk'));
        $this->definir_campo('producto'         ,array('hereda'=>'productos','es_pk'=>true,'modo'=>'pk'));
        $this->definir_campo('observacion'      ,array('es_pk'=>true,'tipo'=>'entero','not_null'=>true));
        $this->definir_campo('informante'       ,array('hereda'=>'informantes','es_pk'=>true,'modo'=>'pk'));
        $this->definir_campo('formulario'       ,array('hereda'=>'formularios','modo'=>'fk_obligatoria'));
        $this->definir_campo('precio'           ,array('tipo'=>'real', 'invisible'=> true ));
        $this->definir_campo('tipoprecio'       ,array('hereda'=>'tipopre','modo'=>'fk_optativa'));
        $this->definir_campo('visita'           ,array('hereda'=>'relvis','es_pk'=>true,'modo'=>'pk'));
        $this->definir_campo('comentariosrelpre',array('tipo'=>'texto','largo'=>200));
        $this->definir_campo('observaciones'    ,array('tipo'=>'texto','largo'=>200));
        $this->definir_campo('cambio'           ,array('tipo'=>'texto','largo'=>1));
        $this->definir_campo('precionormalizado',array('tipo'=>'real', 'invisible'=> true ));
        $this->definir_campo('especificacion'   ,array('tipo'=>'entero','not_null'=>true, 'invisible'=> true ));
        $this->definir_campo('ultima_visita'    ,array('tipo'=>'logico', 'invisible'=> true ));
    }
}

class Grilla_relpre_control_rangos_analisis extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="relpre_control_rangos_analisis";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_relpre");

        $this->tabla->campos_lookup=array(
               "panel"         => false,
               "nombreproducto"         => false,
               "tipoinformante"         => false,
               "repregunta"             => false,
               "precioant"              => false,
               "tipoprecioant"          => false,
               "antiguedadsinprecioant" => false,
               "variac"                 => false,
               "promvar"                => false,
               "desvvar"                => false,
               "promrotativo"           => false,
               "desvprot"               => false,
               "precionormalizadored"   => false
           ); 
        $this->tabla->tablas_lookup=array( 
            "(SELECT periodo per, producto prod, nombreproducto, informante inf, tipoinformante, observacion obs, repregunta, round(precioant::decimal,2) precioant, panel, visita vis, 
                     tipoprecioant, antiguedadsinprecioant, round(variac::decimal,2) variac, round(promvar::decimal,2) promvar, round(desvvar::decimal,2) desvvar, 
                     round(promrotativo::decimal,2) promrotativo, round(desvprot::decimal,2) desvprot, round(control_rangos.precionormalizado::decimal,2) precionormalizadored
              FROM control_rangos) c"=>'c.per=periodo and c.prod=producto and c.obs=observacion and c.inf=informante and c.vis=visita'  
        );
    }
    function campos_editables($filtro_para_lectura){
        $editables=array();
        if(tiene_rol('analista')||tiene_rol('coordinador')) {$editables[]='observaciones';}
        return $editables;
    }
    function permite_grilla_sin_filtro(){
        return true;
    }
    function puede_insertar(){
        return false;
    }
    function puede_eliminar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
      if(tiene_rol('analista')||tiene_rol('coordinador')){
        return array('periodo', 
                     'producto', 
                     'nombreproducto',
                     'panel',
                     'informante' ,
                     'tipoinformante', 
                     'observacion', 
                     'precionormalizadored', 
                     'tipoprecio', 
                     'cambio', 
                     'repregunta', 
                     'precioant', 
                     'tipoprecioant', 
                     'antiguedadsinprecioant',
                     'variac', 
                     'comentariosrelpre',
                     'observaciones',
                     'promvar', 
                     'desvvar', 
                     'promrotativo', 
                     'desvprot' 
                    );
      }
    }
}

class Grilla_relpre_control_rangos_recepcion extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="relpre_control_rangos_recepcion";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_relpre");

        $this->tabla->campos_lookup=array(
               "nombreproducto"         => false,
               "panel"                  => false,
               "tarea"                  => false,
               "encuestador"            => false,
               "recepcionista"          => false,
               "repregunta"             => false,
               "precioant"              => false,
               "tipoprecioant"          => false,
               "antiguedadsinprecioant" => false,
               "variac"                 => false,
               "precionormalizadored"   => false
           ); 
        $this->tabla->tablas_lookup=array( 
            "(SELECT periodo per, producto prod, nombreproducto, informante inf, observacion obs, visita vis, panel, tarea, encuestador, recepcionista, 
                     repregunta, round(precioant::decimal,2) precioant, tipoprecioant, antiguedadsinprecioant, round(variac::decimal,2) variac, 
                     round(control_rangos.precionormalizado::decimal,2) precionormalizadored
              FROM control_rangos) c"=>'c.per=periodo and c.prod=producto and c.obs=observacion and c.inf=informante and c.vis=visita'  
        );
    }
    function campos_editables($filtro_para_lectura){
        $editables=array();
        if(tiene_rol('jefe_campo')||tiene_rol('recepcionista')) {$editables[]='comentariosrelpre';}
        return $editables;
    }
    function permite_grilla_sin_filtro(){
        return true;
    }
    function puede_insertar(){
        return false;
    }
    function puede_eliminar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
      if(tiene_rol('jefe_campo')||tiene_rol('recepcionista')||tiene_rol('analista')||tiene_rol('coordinador')){
        return array('periodo', 
                     'producto', 
                     'nombreproducto', 
                     'informante' ,
                     'observacion', 
                     'visita', 
                     'panel', 
                     'tarea',
                     'encuestador', 
                     'recepcionista', 
                     'formulario',
                     'precionormalizadored', 
                     'tipoprecio', 
                     'cambio', 
                     'repregunta', 
                     'precioant', 
                     'tipoprecioant', 
                     'antiguedadsinprecioant',
                     'variac', 
                     'comentariosrelpre',
                     'observaciones'
                    );
      }
    }
}
?>