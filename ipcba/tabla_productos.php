<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_productos extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('producto'             ,array('tipo'=>'texto'  ,'es_pk'=>true));
        $this->definir_campo('nombreproducto'       ,array('tipo'=>'texto', 'mostrar_al_elegir'=>true));
        $this->definir_campo('imputacon'            ,array('tipo'=>'texto'));
        $this->definir_campo('cantperaltaauto'      ,array('tipo'=>'entero'));
        $this->definir_campo('cantperbajaauto'      ,array('tipo'=>'entero'));
        $this->definir_campo('esexternohabitual'    ,array('tipo'=>'entero'));
        $this->definir_campo('cantobs'              ,array('tipo'=>'entero'));
        $this->definir_campo('unidadmedidaabreviada',array('tipo'=>'entero'));
        $this->definir_campo('porc_adv_inf'         ,array('tipo'=>'decimal'));
        $this->definir_campo('porc_adv_sup'         ,array('tipo'=>'decimal'));
        $this->definir_campo('tipoexterno'          ,array('tipo'=>'texto'));
        $this->definir_campos_orden('producto');
    }
} 

class Grilla_productos extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_productos");
        $this->tabla->campos_lookup=array(
               "compatible"=>false,
           ); 
        $this->tabla->tablas_lookup=array( 
            "(SELECT producto as prod, 
                CASE WHEN unidadmedidaabreviada is not null then cvp.validar_unidadmedidaabreviada(producto) else null end as compatible
                   FROM cvp.productos p
                   WHERE p.producto = producto                   
                ) as c"
            =>'prod=producto',
        );
    }
    function campos_editables($filtro_para_lectura){
        if(tiene_rol('coordinador')){
            return array('nombreproducto','imputacon','cantperaltaauto','cantperbajaauto','unidadmedidaabreviada','porc_adv_inf','porc_adv_sup','tipoexterno');
        };
        return array();
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return array(  'producto',
                       'nombreproducto', 
                       'imputacon',
                       'cantperaltaauto',                       
                       'cantperbajaauto',
                       'esexternohabitual',
                       'cantobs',                       
                       'unidadmedidaabreviada', 
                       'compatible',
                       'porc_adv_inf', 
                       'porc_adv_sup',
                       'tipoexterno');
    }
    function boton_enviar(){
        return array(
            'leyenda'=>'ver',
            'title'=>'Ver ficha del producto',
            'proceso'=>'ficha_producto',
            'campos_parametros'=>array('tra_producto'=>null),
            'y_luego'=>'ver'
        );
    }
}
?>