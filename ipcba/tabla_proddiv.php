<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_proddiv extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('producto'             ,array('tipo'=>'texto' ,'es_pk'=>true));
        $this->definir_campo('division'             ,array('tipo'=>'texto' ,'es_pk'=>true));
        $this->definir_campo('incluye_supermercados',array('tipo'=>'logico'));
        $this->definir_campo('incluye_tradicionales',array('tipo'=>'logico'));
        $this->definir_campo('tipoinformante'       ,array('tipo'=>'texto', 'largo'=>1));
        $this->definir_campo('sindividir'           ,array('tipo'=>'logico'));
        $this->definir_campo('ponderadordiv'        ,array('tipo'=>'real'));
        $this->definir_campo('umbralpriimp'         ,array('tipo'=>'entero'));
        $this->definir_campo('umbraldescarte'       ,array('tipo'=>'entero'));
        $this->definir_campo('umbralbajaauto'       ,array('tipo'=>'entero'));
    }
} 
class Grilla_proddiv extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_proddiv");
        $this->tabla->campos_lookup=array(
            "nombredivision"=>false,
        );
        $this->tabla->tablas_lookup=array(            
            '(select division as div, nombre_division as nombredivision from divisiones) div'=>'div=division',
        );
    }
    function campos_editables($filtro_para_lectura){
        $editables=array();
        $hasta_fecha=date_format(new DateTime('2014-07-11'),"Y-m-d");
        $usu=usuario_actual();
        $ahora=date_format(new DateTime(), "Y-m-d");
        //loguear('2014-07-04', 'usu:'.$usu.' ahora:'.$ahora. ' rol:'.tiene_rol('coordinador'). ' fhasta:'. date_format(new DateTime($hasta_fecha),"Y-m-d")); 
        if(tiene_rol('coordinador') || 
            ($ahora<= $hasta_fecha && ($usu=='mbonfils' ||$usu=='eiutrzenko'))){
          $editables=array('umbralpriimp','umbraldescarte','umbralbajaauto');
        }
        return $editables;    
    }
    function responder_detallar(){
        return true;
    }
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('producto'       
                                                    ,'division'
                                                    ,'ponderadordiv'
                                                    ,'umbralpriimp' 
                                                    ,'umbraldescarte'
                                                    ,'umbralbajaauto'
                                                    ,'nombredivision'
                                                    ,'tipoinformante'
                                                    ,'sindividir' ));
    }
    function campos_a_excluir($filtro_para_lectura){
        return array('incluye_supermercados',
                     'incluye_tradicionales'
        );
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