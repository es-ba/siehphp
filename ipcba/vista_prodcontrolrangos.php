<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Vista_prodcontrolrango extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('producto'         ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'producto'));
        $this->definir_campo('nombreproducto'   ,array('tipo'=>'texto','origen'=>'nombreproducto'));
        $this->definir_campo('informante'       ,array('tipo'=>'entero','es_pk'=>true, 'origen'=>'informante'));
        $this->definir_campo('tipoinformante'   ,array('tipo'=>'texto', 'origen'=>'tipoinformante'));
        $this->definir_campo('observacion'      ,array('tipo'=>'texto','es_pk'=>true, 'origen'=>'observacion'));
        $this->definir_campo('visita'           ,array('tipo'=>'entero', 'es_pk'=>true,'origen'=>'visita'));
        $this->definir_campo('panel'            ,array('tipo'=>'entero', 'origen'=>'panel'));
        $this->definir_campo('tarea'            ,array('tipo'=>'entero', 'origen'=>'tarea'));
        $this->definir_campo('formulario'       ,array('tipo'=>'entero', 'origen'=>'formulario'));
        $this->definir_campo('precionormalizado',array('tipo'=>'decimal', 'origen'=>'precionormalizado'));
        $this->definir_campo('tipoprecio'       ,array('tipo'=>'texto', 'origen'=>'tipoprecio'));
        $this->definir_campo('cambio'           ,array('tipo'=>'texto', 'origen'=>'cambio'));
        $this->definir_campo('impobs'           ,array('tipo'=>'texto', 'origen'=>'impobs'));
        $this->definir_campo('precioant'        ,array('tipo'=>'real', 'origen'=>'precioant'));
        $this->definir_campo('tipoprecioant'    ,array('tipo'=>'texto', 'origen'=>'tipoprecioant'));
        $this->definir_campo('antiguedadsinprecioant',array('tipo'=>'entero', 'origen'=>'antiguedadsinprecioant'));
        $this->definir_campo('variac'           ,array('tipo'=>'real', 'origen'=>'variac'));
        $this->definir_campo('promvar'          ,array('tipo'=>'real', 'origen'=>'promvar'));
        $this->definir_campo('desvvar'          ,array('tipo'=>'real', 'origen'=>'desvvar'));
        $this->definir_campo('promrotativo'     ,array('tipo'=>'real', 'origen'=>'promrotativo'));
        $this->definir_campo('desvprot'         ,array('tipo'=>'real', 'origen'=>'desvprot'));
        $this->definir_campo('razon_impobs_ant' ,array('tipo'=>'entero', 'origen'=>'razon_impobs_ant'));
        $this->definir_campo('repregunta'       ,array('tipo'=>'texto', 'origen'=>'repregunta'));
        $this->definir_campos_orden(array('producto','informante','visita', 'observacion')); 
    }    
    function clausula_from(){
        return "(select producto, nombreproducto, informante, tipoinformante
                        ,observacion, visita, panel, tarea, formulario, precionormalizado
                        ,tipoprecio,cambio,impobs,precioant, tipoprecioant
                        ,antiguedadsinprecioant,variac,promvar, desvvar
                        ,promrotativo,desvprot,razon_impobs_ant, repregunta
                    from cvp.control_rangos
                    where periodo=(select max(periodo) from calculos where calculo=0)
                 ) as consulta";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
                    'producto',         
                    'nombreproducto',   
                    'informante',   
                    'tipoinformante',
                    'observacion',
                    'visita',
                    'panel',
                    'tarea',
                    'formulario',
                    'precionormalizado',
                    'tipoprecio',
                    'cambio',
                    'impobs',
                    'precioant',
                    'tipoprecioant',
                    'antiguedadsinprecioant',
                    'variac',
                    'promvar',
                    'desvvar', 
                    'promrotativo',
                    'desvprot',
                    'razon_impobs_ant',
                    'repregunta' 
                );
        return $campos_solo_lectura;        
    }
    function campos_a_listar($filtro_para_lectura){
        return array('*');
    }    
}
class Grilla_prodcontrolrangos extends Grilla_vistas{
    function iniciar($nombre_del_objeto_base){
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("vista_prodcontrolrango");
    }
    function campos_editables($filtro_para_lectura){
        //if(tiene_rol('coordinador')){
        //  return array('activo');
        //};
        return array();
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return array('*');
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